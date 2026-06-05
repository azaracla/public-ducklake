---
name: public-ducklake-maintainer
description: >
  Maintenance autonome du catalog DuckLake public data.gouv.fr. Explorer, décider,
  générer du SQL, régénérer le catalog, commiter sur GitHub. Déclencher pour :
  ajouter/mettre à jour une table, convertir un dataset JSON/CSV en Parquet,
  vérifier l'intégrité, publier une ressource communautaire, ou tout ce qui touche
  au repo public-ducklake.
user-invocable: true
---

# Agent Mainteneur — Public DuckLake data.gouv.fr

Agent autonome. Explorer, décider, agir. Ne pas attendre de code utilisateur — générer le SQL, interroger les APIs, commiter. En cas de doute, vérifier directement.

## Repo cible

```
owner: azaracla
repo:  public-ducklake
branch: main
```

Structure :
```
public-ducklake/
├── data_gouv_catalog.ducklake     ← catalog binaire DuckLake
├── dg_lake/                       ← métadonnées locales DuckLake
├── schemas/
│   └── vYYYY-MM-DD/
│       └── <categorie>/
│           └── <categorie>_<table>.sql
├── parquet/                       ← Parquet locaux (ressources communautaires)
├── tracking/
│   └── datasets.json
├── scripts/
│   └── generate_ducklake.sql      ← script de reconstruction
└── .github/workflows/ci.yml
```

## Schémas et tables actuels

| Schéma | Tables | Format |
|--------|--------|--------|
| `demographie` | `recensement_individus_2020`, `recensement_individus_2021`, `recensement_logements_2020`, `recensement_logements_2021` | Parquet INSEE |
| `entreprises` | `sirene_unites_legales`, `sirene_unites_legales_historique`, `sirene_etablissements`, `sirene_etablissements_historique`, `annuaire_etablissements`, `annuaire_unites_legales`, `beaamp_2025`, `donnees_financieres` | Parquet |
| `education` | `ips_ecoles`, `indice_eloignement_lycees`, `indicateur_valeur_ajoutee_lycees_gt` | Parquet Éducation Nationale |
| `foncier` | `dvf` | GeoParquet v2 (colonne `geom GEOMETRY`) |
| `economie` | `commande_publique` | JSON→Parquet converti |

---

## Commandes DuckDB essentielles

```bash
# Schéma d'un Parquet distant (source de vérité pour les types)
duckdb -c "SELECT name, duckdb_type FROM parquet_schema('<url>') WHERE name != 'schema' ORDER BY column_id;"

# Lister les tables du catalog
duckdb -c "
INSTALL ducklake; INSTALL httpfs; LOAD ducklake; LOAD httpfs;
ATTACH 'ducklake:data_gouv_catalog.ducklake' AS dg (DATA_PATH './dg_lake/');
USE dg; SHOW ALL TABLES;
"

# Vérifier les fichiers attachés à une table
duckdb -c "
ATTACH 'ducklake:data_gouv_catalog.ducklake' AS dg (DATA_PATH './dg_lake/');
SELECT dt.table_name, df.path
FROM __ducklake_metadata_dg.ducklake_data_file df
JOIN __ducklake_metadata_dg.ducklake_table dt ON df.table_id = dt.table_id
WHERE dt.table_name = '<table>';
"
```

---

## Workflow principal

### 1. Ajout d'une table Parquet (source directe)

Quand le dataset est déjà en Parquet sur data.gouv.fr :

```bash
# a) Récupérer l'URL Parquet
# API: GET https://www.data.gouv.fr/api/1/datasets/<id>/resources/
# Filtrer format=parquet, prendre le plus récent

# b) Inspecter le schéma RÉEL (ne jamais deviner)
duckdb -c "SELECT name, duckdb_type FROM parquet_schema('$URL') WHERE name != 'schema' ORDER BY column_id;"

# c) Générer le SQL dans schemas/vYYYY-MM-DD/<cat>/<cat>_<table>.sql
# d) Attacher au catalog binaire
duckdb -c "
ATTACH 'ducklake:data_gouv_catalog.ducklake' AS dg (DATA_PATH './dg_lake/');
USE dg;
CALL ducklake_add_data_files('dg', '<table>', '<url>', schema => '<schema>');
"
# e) Vérifier, commiter, pusher
```

### 2. Conversion JSON/CSV → Parquet (source non-Parquet)

`ducklake_add_data_files` accepte UNIQUEMENT du Parquet. Pour JSON/CSV :

```python
# Pattern: streaming ijson + ParquetWriter (O(1) mémoire)
import decimal, ijson, pyarrow as pa, pyarrow.parquet as pq

# ⚠️ ijson retourne Decimal pour les nombres → gérer dans les coercers
def _f(v):
    if isinstance(v, (int, float, decimal.Decimal)): return float(v)
    ...

# Écrire en streaming
with pq.ParquetWriter("output.parquet", schema, compression="zstd") as w:
    with open("source.json", "rb") as f:
        for rec in ijson.items(f, "prefix.item"):
            batch.append(flatten(rec))
            if len(batch) >= 100_000:
                w.write_table(pa.Table.from_pylist(batch, schema=schema))
                batch = []
    if batch: w.write_table(...)

# Uploader comme ressource communautaire sur data.gouv.fr
# Puis ducklake_add_data_files avec l'URL static.data.gouv.fr
```

Fichier de référence : `scripts/consolidate_decp.py` — exemple complet.

### 3. Mise à jour d'une table existante

- Si l'URL Parquet a changé : nouveau fichier SQL en `vYYYY-MM-DD/`, nouveau `ducklake_add_data_files`
- Si schéma changé : nouvelle version, ne PAS écraser l'ancien SQL
- Si juste refresh données : le Parquet distant est déjà à jour (DuckLake lit en direct)

### 4. Régénération du catalog

```bash
# DuckDB 1.5.3 n'a PAS .include — concaténer les SQL :
{
  echo "INSTALL ducklake; INSTALL httpfs; LOAD ducklake; LOAD httpfs;"
  echo "ATTACH 'ducklake:data_gouv_catalog.ducklake' AS dg (DATA_PATH './dg_lake/');"
  echo "USE dg;"
  echo "CREATE SCHEMA IF NOT EXISTS demographie;"
  # ... tous les schémas ...
  cat schemas/vYYYY-MM-DD/*/*.sql
} > .tmp/generate.sql && duckdb < .tmp/generate.sql

# Vérifier chaque table :
for schema_table in economie.commande_publique foncier.dvf ...; do
  duckdb -c "ATTACH 'ducklake:data_gouv_catalog.ducklake' AS dg (DATA_PATH './dg_lake/'); SELECT COUNT(*) FROM $schema_table;"
done
```

---

## Règles critiques

### Types DuckLake — mapping strict

`ducklake_add_data_files` rejette tout mismatch de type. Vérifier avec `parquet_schema()`.

| Parquet | DuckLake SQL | Notes |
|---------|-------------|-------|
| BYTE_ARRAY (UTF8) | VARCHAR | |
| INT32 | INTEGER | |
| INT64 | BIGINT | |
| DOUBLE | DOUBLE | |
| BOOLEAN | BOOLEAN | |
| TIMESTAMP_NS | TIMESTAMP | **Mapper, pas TIMESTAMP_NS** |
| LIST | LIST(...) | |
| MAP | MAP(K,V) | **Vérifier syntaxe : MAP(VARCHAR, VARCHAR)** |
| GEOMETRY (GeoParquet v2) | GEOMETRY | Nécessite extension `spatial` |

### Type coercers ijson

**ijson retourne `decimal.Decimal` pour les nombres, pas `float`/`int`.** Les coercers doivent gérer `decimal.Decimal` :

```python
import decimal
def _f(v):
    if isinstance(v, (int, float, decimal.Decimal)): return float(v)
def _i(v):
    if isinstance(v, (int, float, decimal.Decimal)): return int(v)
```

### Versioning

- **Toujours** `schemas/vYYYY-MM-DD/` pour les changements
- **Jamais** écraser un fichier SQL dans une version passée
- Date = jour du commit

### Catalog binaire

- Doit être regénéré et commité après chaque ajout/modification de table
- Contient les métadonnées DuckLake, pas les données
- ~11 MB, fichier binaire DuckDB
- Hébergé sur GitHub raw CDN pour `ATTACH` distant

### Colonnes NULLable

Toutes les colonnes en `NULL` — les Parquet sources n'ont pas de contrainte NOT NULL.

---

## Leçons apprises

### 1. `.include` cassé dans DuckDB 1.5.3
Utiliser `cat` pour concaténer les SQL et pipe dans `duckdb`. Voir `scripts/generate_ducklake.sql` pour la liste à jour.

### 2. DuckDB ne peut pas lire du JSON nested en pur SQL
Un JSON nested de 50 MB (DECP) → 9.3 GB RAM avec `json_each`. Solution : ijson + PyArrow en Python. Résultat : 903 MB JSON → 41 MB Parquet (compression 22x avec Zstd).

### 3. ijson retourne Decimal, pas float
Bug silencieux : `isinstance(x, (int, float))` → False pour Decimal. Toutes les valeurs numériques → NULL. Toujours ajouter `decimal.Decimal` dans les coercers.

### 4. Deux formats JSON dans le même dataset DECP
Ancien (2019, 2022) : `{"marches": [...]}`, nouveau (2024+) : `{"marches": {"marche": [...]}}`. ijson prefix diffèrent. Toujours vérifier la structure avant de stream.

### 5. Valeurs sentinelles dans les montants DECP
`1e16` et `99999999999999` = "montant illimité". 36 outliers sur 656K lignes. Documenter, ne pas exclure.

### 6. Concessions sans montant
Les `Contrat-Concession` DECP n'ont pas de champ `montant` (748 sur 656K). Normal, pas un bug.

### 7. Année extraite des dates : valider la plage
Certaines dates sont erronées dans la source (ex: `0021-12-05`). Valider `1990 <= year <= 2030`. Prioriser `dateNotification` sur `datePublicationDonnees`.

### 8. GeoParquet v2 : colonne `geom GEOMETRY`
Le `foncier.dvf` utilise GeoParquet v2 avec colonne native `geom`. DuckDB doit avoir l'extension `spatial`. Le Parquet n'est PAS un format GeoParquet v1 (pas de colonne `geometry` avec métadonnées geo).

### 9. URLs data.gouv.fr : slugs ≠ dataset_ids
- URL ressource : `.../recensement-de-la-population-fichiers-detail-logements-ordinaires-en-2020-1/...`
- API slug : `recensement-de-la-population-fichiers-detail-logements-ordinaires`
Extraire avec l'API, ne pas deviner.

### 10. Ressources communautaires data.gouv.fr
Quand on convertit JSON→Parquet, uploader sur :
`https://www.data.gouv.fr/admin/community-resources/new?dataset_id=<id>`
Puis utiliser l'URL `static.data.gouv.fr` résultante dans `ducklake_add_data_files`.

---

## Intégrité des données

Toujours vérifier après conversion JSON→Parquet :

```bash
# Compter les lignes et sommer les montants dans le JSON source (ijson)
python3 -c "
import ijson, decimal
count = 0; total = 0.0
with open('source.json', 'rb') as f:
    for rec in ijson.items(f, 'prefix.item'):
        count += 1
        m = rec.get('montant')
        if isinstance(m, (int,float,decimal.Decimal)): total += float(m)
print(f'{count} rows, {total:,.2f} total')
"

# Comparer avec le Parquet
duckdb -c "SELECT COUNT(*), SUM(montant) FROM 'output.parquet'"
```

---

## Messages de commit

```
feat: add <dataset> - <YYYY-MM-DD>
chore: update <dataset> URLs - <YYYY-MM-DD>
fix: <table> schema/types - <YYYY-MM-DD>
docs: add column comments for <table>
```

Un commit par changement logique. Corps du commit en français ou anglais.

---

## Fichiers de référence dans le repo

| Fichier | Rôle |
|---------|------|
| `CLAUDE.md` | Instructions projet, data caveats, architecture |
| `duckdb-cheatsheet.txt` | Référence DuckDB SQL (syntaxe, fonctions, v1.0→v1.5) |
| `tracking/datasets.json` | Registre JSON des datasets actifs |
| `scripts/generate_ducklake.sql` | Script de reconstruction (template, pas exécutable direct) |
| `scripts/consolidate_decp.py` | Exemple JSON→Parquet avec ijson+ParquetWriter |
