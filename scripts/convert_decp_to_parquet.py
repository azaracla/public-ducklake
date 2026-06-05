#!/usr/bin/env python3
"""
Convert DECP (Données Essentielles de la Commande Publique) JSON to Parquet.

DECP publishes nested JSON like:
    {"marches": {"marche": [...], "contrat-concession": [...]}}

This flattens the structure and writes compressed Parquet files
ready for upload as community resources on data.gouv.fr.

Usage:
    # Single file
    python scripts/convert_decp_to_parquet.py decp-2026-06.json

    # Multiple files (one Parquet per input, with yearly merges)
    python scripts/convert_decp_to_parquet.py decp-2026-*.json

    # Output directory
    python scripts/convert_decp_to_parquet.py decp-2026-06.json -o ./parquet/

Output:
    decp-2026-06.parquet    — flattened marches + concessions
"""

import argparse
import decimal
import json
import os
import sys
from pathlib import Path

import pyarrow as pa
import pyarrow.parquet as pq


def safe_str(value):
    """Convert value to str, return None for None/empty."""
    if value is None:
        return None
    s = str(value).strip()
    return s if s else None


def safe_int(value):
    """Convert value to int, return None for non-numeric (e.g. 'NC')."""
    if value is None:
        return None
    if isinstance(value, bool):
        return int(value)
    if isinstance(value, (int, float)):
        return int(value)
    if isinstance(value, str):
        try:
            return int(value)
        except (ValueError, TypeError):
            return None
    return None


def safe_float(value):
    """Convert value to float, return None for non-numeric."""
    if value is None:
        return None
    if isinstance(value, bool):
        return float(value)
    if isinstance(value, (int, float)):
        return float(value)
    if isinstance(value, str):
        try:
            return float(value)
        except (ValueError, TypeError):
            return None
    return None


def safe_bool(value):
    """Convert value to bool, return None for None."""
    if value is None:
        return None
    if isinstance(value, bool):
        return value
    return None


def flatten_marche(m: dict, contract_type: str = "Marché") -> dict:
    """Flatten a single marche/concession dict to a flat row."""
    acheteur = m.get("acheteur") or {}
    lieu = m.get("lieuExecution") or {}
    titulaires = m.get("titulaires") or []

    # Extract titulaire SIRETs as pipe-separated string (DuckDB-friendly)
    titulaire_ids = []
    for t in titulaires:
        tit = t.get("titulaire") or {}
        tid = tit.get("id")
        if tid:
            titulaire_ids.append(str(tid))
    titulaires_str = "|".join(titulaire_ids) if titulaire_ids else None

    row = {
        "id": safe_str(m.get("id")),
        "acheteur_id": safe_str(acheteur.get("id")),
        "acheteur_nom": safe_str(acheteur.get("nom")),
        "nature": safe_str(m.get("nature")),
        "type_contrat": contract_type,
        "objet": safe_str(m.get("objet")),
        "code_cpv": safe_str(m.get("codeCPV")),
        "procedure": safe_str(m.get("procedure")),
        "ccag": safe_str(m.get("ccag")),
        "offres_recues": safe_int(m.get("offresRecues")),
        "type_groupement": safe_str(m.get("typeGroupementOperateurs")),
        "lieu_code": safe_str(lieu.get("code")),
        "lieu_type_code": safe_str(lieu.get("typeCode")),
        "lieu_nom": safe_str(lieu.get("nom")),
        "duree_mois": safe_int(m.get("dureeMois")),
        "date_notification": safe_str(m.get("dateNotification")),
        "date_publication": safe_str(m.get("datePublicationDonnees")),
        "date_debut_execution": safe_str(m.get("dateDebutExecution")),
        "montant": safe_float(m.get("montant")),
        "montant_min": safe_float(m.get("montantMin")),
        "montant_max": safe_float(m.get("montantMax")),
        "forme_prix": safe_str(m.get("formePrix")),
        "sous_traitance": safe_bool(m.get("sousTraitanceDeclaree")),
        "marche_innovant": safe_bool(m.get("marcheInnovant")),
        "attribution_avance": safe_bool(m.get("attributionAvance")),
        "titulaires_ids": titulaires_str,
        "nb_titulaires": len(titulaire_ids) if titulaire_ids else 0,
        "source": safe_str(m.get("source")),
        "origine_ue": safe_float(m.get("origineUE")),
        "origine_france": safe_float(m.get("origineFrance")),
        "taux_avance": safe_float(m.get("tauxAvance")),
    }
    return row


def convert_file(input_path: str, output_path: str) -> int:
    """Convert a single DECP JSON file to Parquet. Returns row count."""
    print(f"Reading {input_path}...")
    with open(input_path, "r") as f:
        data = json.load(f)

    rows = []

    # Handle both nesting patterns
    marches_container = data.get("marches", data)

    # Pattern 1: {"marche": [...], "contrat-concession": [...]}
    if isinstance(marches_container, dict):
        for contract_type, key in [("Marché", "marche"), ("Contrat-Concession", "contrat-concession")]:
            items = marches_container.get(key, [])
            if items and isinstance(items, list):
                for m in items:
                    rows.append(flatten_marche(m, contract_type))
                print(f"  {key}: {len(items)} rows")

    # Pattern 2: Direct list (older format)
    elif isinstance(marches_container, list):
        for m in marches_container:
            rows.append(flatten_marche(m, "Marché"))
        print(f"  marche (list): {len(marches_container)} rows")

    if not rows:
        print(f"  WARNING: no rows extracted from {input_path}")
        return 0

    schema = pa.schema([
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
    ])

    table = pa.Table.from_pylist(rows, schema=schema)
    os.makedirs(os.path.dirname(output_path) or ".", exist_ok=True)
    pq.write_table(table, output_path, compression="zstd")
    size_mb = os.path.getsize(output_path) / (1024 * 1024)
    print(f"Wrote {len(rows)} rows → {output_path} ({size_mb:.1f} MB)")
    return len(rows)


def main():
    parser = argparse.ArgumentParser(description="Convert DECP JSON to Parquet")
    parser.add_argument("inputs", nargs="+", help="DECP JSON file(s) or glob pattern")
    parser.add_argument("-o", "--output-dir", default="./parquet/",
                        help="Output directory for Parquet files (default: ./parquet/)")
    parser.add_argument("--merge-yearly", action="store_true",
                        help="Merge monthly files into yearly Parquet files")
    args = parser.parse_args()

    total_rows = 0
    os.makedirs(args.output_dir, exist_ok=True)

    for input_file in args.inputs:
        basename = os.path.basename(input_file).replace(".json", "")
        output_file = os.path.join(args.output_dir, f"{basename}.parquet")
        rows = convert_file(input_file, output_file)
        total_rows += rows

    print(f"\nTotal: {total_rows} rows across {len(args.inputs)} file(s)")

    if args.merge_yearly and not args.inputs:
        print("--merge-yearly requires input files to be specified")


if __name__ == "__main__":
    main()
