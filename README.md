# Public DuckLake — Data.gouv.fr

[![CI](https://github.com/azaracla/public-ducklake/actions/workflows/ci.yml/badge.svg)](https://github.com/azaracla/public-ducklake/actions/workflows/ci.yml)

**Un entrepôt SQL instantané sur les données publiques françaises.**

Un fichier `.ducklake` de 11 Mo qui référence des fichiers Parquet distants hébergés sur data.gouv.fr.  
Attachez-le, et interrogez 15 tables (INSEE, Éducation nationale, Annuaire des Entreprises…) en SQL, sans rien télécharger.

```sql
ATTACH 'ducklake:https://raw.githubusercontent.com/azaracla/public-ducklake/main/data_gouv_catalog.ducklake' AS dg (TYPE ducklake, READ_ONLY true);
USE dg;

-- Combien d'écoles par région, avec leur indice de position sociale moyen ?
SELECT region, COUNT(*) AS nb_ecoles, AVG(CAST(ips AS DOUBLE)) AS ips_moyen
FROM education.ips_ecoles
WHERE ips ~ '^[0-9]+(\.[0-9]+)?$'
GROUP BY region
ORDER BY ips_moyen DESC;
```

## Vision

Les données publiques françaises existent, elles sont ouvertes, mais leur exploitation reste complexe :  
formats hétérogènes, volumes importants, absence d'index, pas de SQL possible sans ingestion préalable.

**Public DuckLake supprime cette friction.** Il transforme data.gouv.fr en base de données SQL, sans ETL, sans serveur, sans copie.

C'est possible grâce à deux technologies :
- **Parquet** — format columnar standard, utilisé par l'INSEE, l'Éducation nationale et data.gouv.fr pour leurs exports
- **DuckDB + DuckLake** — moteur SQL embarrable qui sait lire des fichiers Parquet distants et les exposer via un catalogue virtuel

L'utilisateur final n'a besoin que de DuckDB (un binaire, 0 dépendance) et d'une ligne d'`ATTACH`.

## Datasets couverts

| Schéma | Tables | Source |
|---|---|---|
| `demographie` | Recensement individus 2020/2021, logements 2020/2021 | INSEE |
| `entreprises` | Sirene (unités légales + établissements + historique), Annuaire des Entreprises, BEAAMP, Données financières | INSEE, data.gouv.fr, Signaux Faibles |
| `education` | IPS écoles, Indice d'éloignement des lycées, IVAL lycées GT | Ministère de l'Éducation nationale |

## Ce que ça permet

Des requêtes qui étaient jusqu'ici lourdes ou impossibles deviennent triviales :

```sql
-- Corrélation entre performance scolaire et tissu économique par département
WITH dept_ips AS (
  SELECT code_du_departement, AVG(CAST(ips AS DOUBLE)) AS ips_moyen
  FROM education.ips_ecoles WHERE ips ~ '^[0-9]+'
  GROUP BY code_du_departement
),
dept_entreprises AS (
  SELECT RIGHT(siren, 2) AS dept, COUNT(*) AS nb_entreprises
  FROM entreprises.sirene_unites_legales
  GROUP BY dept
)
SELECT * FROM dept_ips JOIN dept_entreprises ON dept_ips.code_du_departement = dept_entreprises.dept
ORDER BY ips_moyen DESC;
```
