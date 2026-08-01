#!/usr/bin/env python3
"""Build and validate the reproducible French public-debt edition."""

from __future__ import annotations

import argparse
import csv
import hashlib
import html
import io
import json
import re
import urllib.request
import zipfile
from datetime import date
from pathlib import Path
from xml.etree import ElementTree

import pyarrow as pa
import pyarrow.parquet as pq


EDITION = "v2026-08-01"
OUTPUT = Path("data/finances_publiques") / EDITION
SOURCES = {
    "insee_apu": {
        "url": "https://api.insee.fr/melodi/file/DD_CNA_APU/DD_CNA_APU_CSV_FR",
        "publication_date": "2026-07-07",
    },
    "insee_annual": {
        "url": "https://www.insee.fr/fr/statistiques/fichier/8997691/ip2106.xlsx",
        "publication_date": "2026-05-29",
    },
    "insee_gdp": {
        "url": "https://www.insee.fr/fr/statistiques/8988793",
        "publication_date": "2026-05-29",
    },
    "insee_quarterly": {
        "url": "https://www.insee.fr/fr/statistiques/fichier/2830301/econ-gen-dette-trim-adm-pub-2.xlsx",
        "publication_date": "2026-07-30",
    },
    "eurostat_10y": {
        "url": "https://ec.europa.eu/eurostat/api/dissemination/statistics/1.0/data/irt_lt_mcby_m?geo=FR&sinceTimePeriod=2019-01&untilTimePeriod=2025-12",
        "publication_date": "2026-01-01",
    },
    "aft_oat": {
        "url": "https://www.aft.gouv.fr/fr/encours-detaille-oat",
        "fetch_url": "https://r.jina.ai/https://www.aft.gouv.fr/fr/encours-detaille-oat",
        "publication_date": "2026-08-01",
    },
    "aft_oati": {
        "url": "https://www.aft.gouv.fr/fr/encours-detaille-oati",
        "fetch_url": "https://r.jina.ai/https://www.aft.gouv.fr/fr/encours-detaille-oati",
        "publication_date": "2026-08-01",
    },
    "aft_oatei": {
        "url": "https://www.aft.gouv.fr/fr/encours-detaille-oatei",
        "fetch_url": "https://r.jina.ai/https://www.aft.gouv.fr/fr/encours-detaille-oatei",
        "publication_date": "2026-08-01",
    },
    "aft_report": {
        "url": "https://www.aft.gouv.fr/fr/publications/communiques-presse/07072026-lagence-france-tresor-publie-son-rapport-dactivite-2025",
        "fetch_url": "https://r.jina.ai/https://www.aft.gouv.fr/fr/publications/communiques-presse/07072026-lagence-france-tresor-publie-son-rapport-dactivite-2025",
        "publication_date": "2026-07-07",
    },
}
MONTHS = {
    "janvier": 1,
    "février": 2,
    "mars": 3,
    "avril": 4,
    "mai": 5,
    "juin": 6,
    "juillet": 7,
    "août": 8,
    "septembre": 9,
    "octobre": 10,
    "novembre": 11,
    "décembre": 12,
}


def download(url: str) -> bytes:
    request = urllib.request.Request(url, headers={"User-Agent": "public-ducklake/1.0"})
    with urllib.request.urlopen(request, timeout=90) as response:
        return response.read()


def fetch_sources() -> tuple[dict[str, bytes], list[dict[str, str]]]:
    bodies, manifest = {}, []
    retrieved = date.today().isoformat()
    for name, source in SOURCES.items():
        fetch_url = source.get("fetch_url", source["url"])
        body = download(fetch_url)
        bodies[name] = body
        manifest.append(
            {
                "id": name,
                "url": source["url"],
                "retrieved_via": fetch_url,
                "publication_date": source["publication_date"],
                "retrieval_date": retrieved,
                "sha256": hashlib.sha256(body).hexdigest(),
            }
        )
    return bodies, manifest


def _column(cell: str) -> int:
    value = 0
    for character in re.match(r"[A-Z]+", cell).group():
        value = value * 26 + ord(character) - 64
    return value - 1


def xlsx_sheets(body: bytes) -> dict[str, list[list[str | float | None]]]:
    namespace = {"x": "http://schemas.openxmlformats.org/spreadsheetml/2006/main"}
    relation = "{http://schemas.openxmlformats.org/officeDocument/2006/relationships}id"
    with zipfile.ZipFile(io.BytesIO(body)) as archive:
        shared = []
        if "xl/sharedStrings.xml" in archive.namelist():
            root = ElementTree.fromstring(archive.read("xl/sharedStrings.xml"))
            shared = ["".join(item.itertext()) for item in root.findall("x:si", namespace)]
        rels = ElementTree.fromstring(archive.read("xl/_rels/workbook.xml.rels"))
        targets = {item.attrib["Id"]: item.attrib["Target"] for item in rels}
        workbook = ElementTree.fromstring(archive.read("xl/workbook.xml"))
        sheets = {}
        for sheet in workbook.findall(".//x:sheet", namespace):
            target = targets[sheet.attrib[relation]].lstrip("/")
            path = target if target.startswith("xl/") else f"xl/{target}"
            root = ElementTree.fromstring(archive.read(path))
            rows = []
            for xml_row in root.findall(".//x:sheetData/x:row", namespace):
                cells: dict[int, str | float | None] = {}
                for cell in xml_row.findall("x:c", namespace):
                    value = cell.find("x:v", namespace)
                    raw = None if value is None else value.text
                    if cell.attrib.get("t") == "s" and raw is not None:
                        parsed: str | float | None = shared[int(raw)]
                    elif cell.attrib.get("t") == "inlineStr":
                        parsed = "".join(cell.itertext())
                    else:
                        try:
                            parsed = float(raw) if raw is not None else None
                        except ValueError:
                            parsed = raw
                    cells[_column(cell.attrib["r"])] = parsed
                if cells:
                    row = [None] * (max(cells) + 1)
                    for index, value in cells.items():
                        row[index] = value
                    rows.append(row)
            sheets[sheet.attrib["name"]] = rows
    return sheets


def _find_row(rows: list[list], label: str) -> list:
    return next(row for row in rows if row and label.casefold() in str(row[0]).casefold())


def parse_annual(sheets: dict[str, list[list]]) -> dict[str, float]:
    financing = _find_row(sheets["Figure 3"], "Ensemble des administrations")
    interest = _find_row(sheets["Figure 4"], "Charges d'intérêts")
    debt_rows = sheets["Figure 5"]
    return {
        "deficit": abs(float(financing[5])),
        "interest": float(interest[7]),
        "debt_start": float(_find_row(debt_rows, "Ensemble des administrations")[1]),
        "debt_end": float(_find_row(debt_rows, "Ensemble des administrations")[3]),
        "debt_ratio_published": float(_find_row(debt_rows, "En % du PIB")[3]),
        "state": float(_find_row(debt_rows, "État")[3]),
        "odac": float(_find_row(debt_rows, "Organismes divers")[3]),
        "local": float(_find_row(debt_rows, "Administrations publiques locales")[3]),
        "social": float(_find_row(debt_rows, "Administrations de sécurité sociale")[3]),
    }


def parse_gdp(body: bytes) -> float:
    text = html.unescape(re.sub(r"<[^>]+>", " ", body.decode("utf-8"))).replace("\xa0", " ")
    match = re.search(r"atteint\s+([0-9 ]+,[0-9])\s+milliards", text, re.IGNORECASE)
    if not match:
        raise ValueError("PIB 2025 introuvable dans la publication Insee")
    return float(match.group(1).replace(" ", "").replace(",", "."))


def parse_quarterly(sheets: dict[str, list[list]]) -> list[dict]:
    rows = []
    for row in sheets["Données"]:
        if len(row) >= 3 and re.fullmatch(r"(?:19|20)\d{2}-T[1-4]", str(row[0])):
            rows.append(
                {
                    "trimestre": row[0],
                    "dette_millions": round(float(row[1]) * 1_000, 3),
                    "ratio_pib": float(row[2]),
                    "statut": "provisoire" if str(row[0]).startswith("2026") else "constate",
                }
            )
    return sorted(rows, key=lambda row: row["trimestre"])


def parse_eurostat(body: bytes) -> list[tuple[str, float]]:
    payload = json.loads(body)
    periods = payload["dimension"]["time"]["category"]["index"]
    return sorted((period, float(payload["value"][str(index)])) for period, index in periods.items())


def parse_aft(body: bytes, indexation: str, extraction_date: str) -> list[dict]:
    text = body.decode("utf-8")
    pattern = re.compile(
        r"\[(FR[A-Z0-9]{10})\]\([^)]*\)\s*\|\s*([^|]+?)\s*\|\s*([0-9][0-9 ]+)\s*\|",
        re.IGNORECASE,
    )
    rows = []
    for isin, label, amount in pattern.findall(text):
        maturity = re.search(r"(\d{1,2})\s+(%s)\s+(\d{4})" % "|".join(MONTHS), label, re.IGNORECASE)
        if not maturity:
            raise ValueError(f"Échéance AFT illisible: {label}")
        day, month, year = maturity.groups()
        coupon = re.search(r"(\d+[,.]\d+)\s*%", label)
        rows.append(
            {
                "isin": isin.upper(),
                "libelle": label.strip(),
                "coupon_pct": float(coupon.group(1).replace(",", ".")) if coupon else 0.0,
                "echeance": date(int(year), MONTHS[month.casefold()], int(day)),
                "encours_euros": int(amount.replace(" ", "")),
                "indexation": indexation,
                "verte": "verte" in label.casefold(),
                "date_extraction": date.fromisoformat(extraction_date),
                "statut": "donnee_de_marche",
            }
        )
    if not rows:
        raise ValueError(f"Aucune OAT trouvée pour {indexation}")
    return rows


def parse_aft_report(body: bytes) -> dict[str, float | int]:
    text = body.decode("utf-8").replace("\xa0", " ")
    rate = re.search(r"taux moyen pondéré de\s+([0-9,]+)\s*%", text, re.IGNORECASE)
    stock = re.search(r"Encours de la dette négociable[^:]*:\s*([0-9 ]+)\s*milliards", text, re.IGNORECASE)
    duration = re.search(r"Durée de vie moyenne[^:]*:\s*(\d+)\s*ans et\s*(\d+)\s*jours", text, re.IGNORECASE)
    if not all((rate, stock, duration)):
        raise ValueError("Chiffres clés AFT 2025 introuvables")
    return {
        "issuance_rate": float(rate.group(1).replace(",", ".")),
        "negotiable_debt": int(stock.group(1).replace(" ", "")),
        "duration_years": int(duration.group(1)),
        "duration_days": int(duration.group(2)),
    }


def parse_apu_history(body: bytes) -> dict[int, dict[str, float]]:
    required = {"STO", "REF_SECTOR", "TIME_PERIOD", "OBS_VALUE"}
    with zipfile.ZipFile(io.BytesIO(body)) as archive:
        name = next(name for name in archive.namelist() if name.endswith("_data.csv"))
        with archive.open(name) as raw:
            rows = csv.DictReader(io.TextIOWrapper(raw, encoding="utf-8"), delimiter=";")
            if missing := required - set(rows.fieldnames or []):
                raise ValueError(f"Colonnes Insee manquantes: {', '.join(sorted(missing))}")
            values: dict[int, dict[str, float]] = {}
            for row in rows:
                if not (
                    row["TIME_PERIOD"] in {str(year) for year in range(2019, 2026)}
                    and row["REF_SECTOR"] == "S13"
                    and row["CONSOLIDATION"] == "C"
                    and row["UNIT_MEASURE"] == "XDC"
                    and row["FREQ"] == "A"
                ):
                    continue
                year = int(row["TIME_PERIOD"])
                if row["STO"] == "B9" and row["ACCOUNTING_ENTRY"] == "B":
                    values.setdefault(year, {})["deficit"] = abs(float(row["OBS_VALUE"]))
                if row["STO"] == "D41" and row["ACCOUNTING_ENTRY"] == "D":
                    values.setdefault(year, {})["interest"] = float(row["OBS_VALUE"])
    if set(values) != set(range(2019, 2026)) or any(set(value) != {"deficit", "interest"} for value in values.values()):
        raise ValueError("Série annuelle Insee incomplète pour 2019-2025")
    return values


def validate(annuals: list[dict], quarters: list[dict], oats: list[dict]) -> None:
    annual = next(row for row in annuals if row["annee"] == 2025)
    checks = {
        "dette en Md€": (annual["dette_maastricht_millions"] / 1_000, 3_460.5, 0.1),
        "dette en % du PIB": (annual["dette_maastricht_millions"] / annual["pib_millions"] * 100, 115.7, 0.1),
        "déficit en Md€": (annual["deficit_millions"] / 1_000, 152.5, 0.1),
        "déficit en % du PIB": (annual["deficit_millions"] / annual["pib_millions"] * 100, 5.1, 0.1),
    }
    failures = [f"{name}: {actual:.3f} au lieu de {expected}" for name, (actual, expected, tolerance) in checks.items() if abs(actual - expected) > tolerance]
    subsectors = sum(annual[key] for key in ("dette_etat_millions", "dette_odac_millions", "dette_apul_millions", "dette_asso_millions"))
    if abs(subsectors - annual["dette_maastricht_millions"]) > 100:
        failures.append("la somme des sous-secteurs ne correspond pas à la dette totale")
    if len({row["trimestre"] for row in quarters}) != len(quarters) or any(row["dette_millions"] is None or row["ratio_pib"] is None for row in quarters):
        failures.append("périodes trimestrielles dupliquées ou incomplètes")
    if [row["annee"] for row in annuals] != list(range(2019, 2026)) or any(
        row[key] is None for row in annuals for key in ("pib_millions", "dette_maastricht_millions", "deficit_millions", "interets_millions", "taux_10_ans_moyen_pct")
    ):
        failures.append("série annuelle 2019-2025 incomplète")
    if len({row["isin"] for row in oats}) != len(oats) or any(row["encours_euros"] <= 0 for row in oats):
        failures.append("ISIN OAT dupliqués ou encours invalides")
    if failures:
        raise ValueError("Validation refusée:\n- " + "\n- ".join(failures))


def build(output: Path = OUTPUT) -> None:
    bodies, manifest = fetch_sources()
    history = parse_apu_history(bodies["insee_apu"])
    published = parse_annual(xlsx_sheets(bodies["insee_annual"]))
    gdp = parse_gdp(bodies["insee_gdp"])
    quarters = parse_quarterly(xlsx_sheets(bodies["insee_quarterly"]))
    rates = parse_eurostat(bodies["eurostat_10y"])
    aft = parse_aft_report(bodies["aft_report"])
    extraction_date = date.today().isoformat()
    oats = []
    for source, indexation in (("aft_oat", "nominale"), ("aft_oati", "inflation_france"), ("aft_oatei", "inflation_zone_euro")):
        oats.extend(parse_aft(bodies[source], indexation, extraction_date))
    by_quarter = {row["trimestre"]: row for row in quarters}
    rates_by_year: dict[int, list[float]] = {}
    for period, value in rates:
        rates_by_year.setdefault(int(period[:4]), []).append(value)
    annuals = []
    for year in range(2019, 2026):
        end = by_quarter[f"{year}-T4"]
        start = by_quarter[f"{year - 1}-T4"]
        annuals.append({
            "annee": year,
            "pib_millions": end["dette_millions"] / end["ratio_pib"] * 100,
            "dette_maastricht_millions": end["dette_millions"],
            "dette_debut_annee_millions": start["dette_millions"],
            "deficit_millions": history[year]["deficit"],
            "interets_millions": history[year]["interest"],
            "dette_etat_millions": None,
            "dette_odac_millions": None,
            "dette_apul_millions": None,
            "dette_asso_millions": None,
            "dette_pct_pib_publie": end["ratio_pib"],
            "deficit_pct_pib_publie": history[year]["deficit"] / (end["dette_millions"] / end["ratio_pib"] * 100) * 100,
            "taux_10_ans_moyen_pct": sum(rates_by_year[year]) / len(rates_by_year[year]),
            "taux_nouvelles_emissions_pct": None,
            "dette_negociable_etat_millions": None,
            "duree_vie_moyenne_ans": None,
            "duree_vie_moyenne_jours": None,
            "date_publication": date(2026, 7, 7),
            "date_recuperation": date.today(),
            "statut": "constate",
        })
    annual = {
        "annee": 2025,
        "pib_millions": gdp * 1_000,
        "dette_maastricht_millions": published["debt_end"] * 1_000,
        "dette_debut_annee_millions": published["debt_start"] * 1_000,
        "deficit_millions": published["deficit"] * 1_000,
        "interets_millions": published["interest"] * 1_000,
        "dette_etat_millions": published["state"] * 1_000,
        "dette_odac_millions": published["odac"] * 1_000,
        "dette_apul_millions": published["local"] * 1_000,
        "dette_asso_millions": published["social"] * 1_000,
        "dette_pct_pib_publie": published["debt_ratio_published"],
        "deficit_pct_pib_publie": 5.1,
        "taux_10_ans_moyen_pct": sum(rates_by_year[2025]) / len(rates_by_year[2025]),
        "taux_nouvelles_emissions_pct": aft["issuance_rate"],
        "dette_negociable_etat_millions": aft["negotiable_debt"] * 1_000,
        "duree_vie_moyenne_ans": aft["duration_years"],
        "duree_vie_moyenne_jours": aft["duration_days"],
        "date_publication": date(2026, 5, 29),
        "date_recuperation": date.today(),
        "statut": "constate",
    }
    annuals[-1] = annual
    validate(annuals, quarters, oats)
    output.mkdir(parents=True, exist_ok=True)
    pq.write_table(pa.Table.from_pylist(annuals), output / "apu_annuel.parquet", compression="zstd")
    pq.write_table(pa.Table.from_pylist(quarters), output / "dette_trimestrielle.parquet", compression="zstd")
    pq.write_table(pa.Table.from_pylist(oats), output / "oat.parquet", compression="zstd")
    (output / "sources.json").write_text(json.dumps({"edition": EDITION, "sources": manifest}, ensure_ascii=False, indent=2) + "\n")
    print(f"{len(annuals)} années, {len(quarters)} trimestres, {len(oats)} OAT — contrôles 2025 conformes")


def check(output: Path = OUTPUT) -> None:
    annual = pq.read_table(output / "apu_annuel.parquet").to_pylist()
    quarters = pq.read_table(output / "dette_trimestrielle.parquet").to_pylist()
    oats = pq.read_table(output / "oat.parquet").to_pylist()
    validate(annual, quarters, oats)
    print("4 chiffres de référence, schémas et cohérences: OK")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true", help="contrôle les Parquet versionnés sans téléchargement")
    parser.add_argument("--output", type=Path, default=OUTPUT)
    arguments = parser.parse_args()
    check(arguments.output) if arguments.check else build(arguments.output)
