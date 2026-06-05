#!/usr/bin/env python3
"""
One-shot: convert decp-global.json (pre-deduplicated aggregate) → Parquet.

Single source: the official deduplicated global file from data.gouv.fr.
Streams with ijson (O(1) memory), writes via ParquetWriter. No merge, no dedup.

Usage:
    python scripts/consolidate_decp.py

Output:
    parquet/decp_commande_publique.parquet
"""

import decimal
import os
import sys
import time

import ijson
import pyarrow as pa
import pyarrow.parquet as pq
import urllib.request

# ── Configuration ─────────────────────────────────────────────────────────────
SOURCE_URL = "https://static.data.gouv.fr/resources/donnees-essentielles-de-la-commande-publique-fichiers-consolides/20260526-154435/decp-global.json"
OUTPUT = "parquet/decp-global.parquet"
CACHE_FILE = ".tmp/decp_global.json"
BATCH_SIZE = 100_000  # rows per row group

SCHEMA = pa.schema([
    pa.field("id", pa.string()),
    pa.field("acheteur_id", pa.string()),
    pa.field("acheteur_nom", pa.string()),
    pa.field("nature", pa.string()),
    pa.field("type_contrat", pa.string()),
    pa.field("objet", pa.string()),
    pa.field("code_cpv", pa.string()),
    pa.field("procedure", pa.string()),
    pa.field("ccag", pa.string()),
    pa.field("offres_recues", pa.int64()),
    pa.field("type_groupement", pa.string()),
    pa.field("lieu_code", pa.string()),
    pa.field("lieu_type_code", pa.string()),
    pa.field("lieu_nom", pa.string()),
    pa.field("duree_mois", pa.int64()),
    pa.field("date_notification", pa.string()),
    pa.field("date_publication", pa.string()),
    pa.field("date_debut_execution", pa.string()),
    pa.field("montant", pa.float64()),
    pa.field("montant_min", pa.float64()),
    pa.field("montant_max", pa.float64()),
    pa.field("forme_prix", pa.string()),
    pa.field("sous_traitance", pa.bool_()),
    pa.field("marche_innovant", pa.bool_()),
    pa.field("attribution_avance", pa.bool_()),
    pa.field("titulaires_ids", pa.string()),
    pa.field("nb_titulaires", pa.int64()),
    pa.field("source", pa.string()),
    pa.field("origine_ue", pa.float64()),
    pa.field("origine_france", pa.float64()),
    pa.field("taux_avance", pa.float64()),
    pa.field("annee", pa.string()),
])


# ── Type coercers ────────────────────────────────────────────────────────────
def _s(v) -> str | None:
    if v is None: return None
    x = str(v).strip()
    return x if x else None


def _i(v) -> int | None:
    if v is None: return None
    if isinstance(v, bool): return int(v)
    if isinstance(v, (int, float, decimal.Decimal)): return int(v)
    if isinstance(v, str):
        try: return int(v)
        except (ValueError, TypeError): return None
    return None


def _f(v) -> float | None:
    if v is None: return None
    if isinstance(v, bool): return float(v)
    if isinstance(v, (int, float, decimal.Decimal)): return float(v)
    if isinstance(v, str):
        try: return float(v)
        except (ValueError, TypeError): return None
    return None


def _b(v) -> bool | None:
    if v is None: return None
    return v if isinstance(v, bool) else None


def _year(m: dict) -> str | None:
    """Extract year from date fields. Validates year is in 1990–2030 range."""
    for key in ("dateNotification", "datePublicationDonnees", "dateDebutExecution"):
        val = m.get(key)
        if isinstance(val, str) and len(val) >= 4 and val[:4].isdigit():
            y = val[:4]
            if 1990 <= int(y) <= 2030:
                return y
    return None


# ── Record flattening ────────────────────────────────────────────────────────
def flatten(rec: dict, contract_type: str) -> dict:
    """Flatten one DECP record to a dict matching SCHEMA."""
    a = rec.get("acheteur") or {}
    lieu = rec.get("lieuExecution") or {}
    tids = [
        str(t["titulaire"]["id"])
        for t in (rec.get("titulaires") or [])
        if isinstance(t, dict) and isinstance(t.get("titulaire"), dict) and t["titulaire"].get("id")
    ]
    return {
        "id": _s(rec.get("id")),
        "acheteur_id": _s(a.get("id")),
        "acheteur_nom": _s(a.get("nom")),
        "nature": _s(rec.get("nature")),
        "type_contrat": contract_type,
        "objet": _s(rec.get("objet")),
        "code_cpv": _s(rec.get("codeCPV")),
        "procedure": _s(rec.get("procedure")),
        "ccag": _s(rec.get("ccag")),
        "offres_recues": _i(rec.get("offresRecues")),
        "type_groupement": _s(rec.get("typeGroupementOperateurs")),
        "lieu_code": _s(lieu.get("code")),
        "lieu_type_code": _s(lieu.get("typeCode")),
        "lieu_nom": _s(lieu.get("nom")),
        "duree_mois": _i(rec.get("dureeMois")),
        "date_notification": _s(rec.get("dateNotification")),
        "date_publication": _s(rec.get("datePublicationDonnees")),
        "date_debut_execution": _s(rec.get("dateDebutExecution")),
        "montant": _f(rec.get("montant")),
        "montant_min": _f(rec.get("montantMin")),
        "montant_max": _f(rec.get("montantMax")),
        "forme_prix": _s(rec.get("formePrix")),
        "sous_traitance": _b(rec.get("sousTraitanceDeclaree")),
        "marche_innovant": _b(rec.get("marcheInnovant")),
        "attribution_avance": _b(rec.get("attributionAvance")),
        "titulaires_ids": "|".join(tids) if tids else None,
        "nb_titulaires": len(tids) if tids else 0,
        "source": _s(rec.get("source")),
        "origine_ue": _f(rec.get("origineUE")),
        "origine_france": _f(rec.get("origineFrance")),
        "taux_avance": _f(rec.get("tauxAvance")),
        "annee": _year(rec),
    }


# ── Streaming JSON reader ────────────────────────────────────────────────────
def iter_records(json_path: str):
    """Yield (contract_type, record) tuples from decp-global.json via ijson.

    Format: {"marches": {"marche": [...], "contrat-concession": [...]}}
    """
    prefixes = [
        ("Marché", "marches.marche.item"),
        ("Contrat-Concession", "marches.contrat-concession.item"),
    ]
    for ct, prefix in prefixes:
        count = 0
        try:
            with open(json_path, "rb") as fh:
                for rec in ijson.items(fh, prefix):
                    yield ct, rec
                    count += 1
        except ijson.common.IncompleteJSONError:
            pass
        except Exception as e:
            print(f"  WARN: {prefix}: {e}", file=sys.stderr)
        if count:
            print(f"  {prefix}: {count:,} records")


# ── Download helper ──────────────────────────────────────────────────────────
def download(url: str, dest: str):
    """Download file with progress, skip if cached."""
    if os.path.exists(dest):
        size_mb = os.path.getsize(dest) / 1024**2
        print(f"  Cached ({size_mb:.0f} MB)")
        return
    os.makedirs(os.path.dirname(dest), exist_ok=True)
    print(f"  Downloading {url.rsplit('/', 1)[-1]}...")
    t0 = time.time()
    def cb(n, bs, total):
        e = max(time.time() - t0, 0.01)
        pct = min(n * bs / max(total, 1) * 100, 100)
        print(f"  {pct:.0f}% ({n*bs/e/1024**2:.1f} MB/s)  ", end="\r")
    urllib.request.urlretrieve(url, dest, reporthook=cb)
    print(f"  Done in {time.time()-t0:.0f}s ({os.path.getsize(dest)/1024**2:.0f} MB)")


# ── Main ──────────────────────────────────────────────────────────────────────
def main():
    t_start = time.time()

    # Step 1: Download
    print("=== Step 1/3: Download ===\n")
    download(SOURCE_URL, CACHE_FILE)

    # Step 2: Stream convert
    print(f"\n=== Step 2/3: Stream JSON → {OUTPUT} ===\n")

    total = 0
    batch = []

    os.makedirs(os.path.dirname(OUTPUT) or ".", exist_ok=True)

    with pq.ParquetWriter(OUTPUT, SCHEMA, compression="zstd") as writer:
        for ct, rec in iter_records(CACHE_FILE):
            row = flatten(rec, ct)
            batch.append(row)

            if len(batch) >= BATCH_SIZE:
                writer.write_table(pa.Table.from_pylist(batch, schema=SCHEMA))
                elapsed = time.time() - t_start
                rate = total / max(elapsed, 0.01)
                print(f"\r  {total:,} rows ({rate:,.0f} rec/s)", end="")
                batch = []

            total += 1

        # Flush remaining
        if batch:
            writer.write_table(pa.Table.from_pylist(batch, schema=SCHEMA))

    # Step 3: Summary
    size_mb = os.path.getsize(OUTPUT) / 1024**2
    total_elapsed = time.time() - t_start
    print(f"\r  {total:,} rows in {total_elapsed:.0f}s ({total/max(total_elapsed,0.01):,.0f} rec/s)")

    print(f"\n=== Step 3/3: Done ===\n")
    print(f"  Output: {OUTPUT} ({size_mb:.1f} MB)")
    print(f"  Total:  {total:,} rows")
    print(f"\n  Upload at:")
    print(f"  https://www.data.gouv.fr/admin/community-resources/new?dataset_id=5cd57bf68b4c4179299eb0e9")


if __name__ == "__main__":
    main()
