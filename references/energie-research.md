# Recherche : données énergie pour Public DuckLake

**Date :** 2026-06-05
**Résultat :** aucun dataset énergie français publié en Parquet statique sur `static.data.gouv.fr`
**Blocage :** tout l'écosystème open data énergie (ODRÉ, Enedis, ADEME) utilise OpenDataSoft qui ne supporte pas les Range Requests HTTP
**Solution :** uploader des Parquets comme ressources communautaires data.gouv.fr

## Contexte

Pour fonctionner avec DuckLake, un fichier Parquet distant doit :
1. Être hébergé sur un serveur qui supporte les requêtes HTTP `Range` (status 206 Partial Content)
2. Avoir un header `Content-Length`
3. Idéalement : données triées + row groups avec min/max pour le pruning

Les CDN qui marchent : `static.data.gouv.fr`, `data.education.gouv.fr`, `raw.githubusercontent.com`.

## Problème

**Aucun** producteur de données énergie en France ne publie de Parquet sur ces CDN.
Tous utilisent des instances OpenDataSoft :

| Producteur | Instance | Parquet ? | Range Requests ? |
|-----------|----------|-----------|-----------------|
| ODRÉ (RTE, NaTran, Teréga) | `odre.opendatasoft.com` | ✅ Export API | ❌ Génération dynamique |
| Enedis | `opendata.enedis.fr` | ✅ Export API | ❌ Génération dynamique |
| ADEME | `data.ademe.fr` | ✅ Export API | ❌ Génération dynamique |

OpenDataSoft génère le Parquet à la volée à chaque requête → pas de `Content-Length`, pas de `Accept-Ranges: bytes`, le header `Range` est ignoré (retourne 200 au lieu de 206).

## Datasets énergie identifiés

### ✅ Viables (taille/lignes suffisantes pour DuckLake)

| Dataset | Lignes | Taille brute | Taille ZSTD | Producteur |
|---------|--------|-------------|-------------|-----------|
| éCO2mix régional consolidé | 2 752 704 | 84 MB | 66 MB | RTE/ODRÉ |
| Registre national installations | 125 930 | 6.4 MB | 5.3 MB | RTE/ODRÉ |
| Conso quotidienne brute | 251 232 | 5.7 MB | ~4 MB | NaTran/Teréga/RTE/ODRÉ |

### ❌ Trop petits (pas d'intérêt DuckLake)

| Dataset | Lignes | Problème |
|---------|--------|----------|
| éCO2mix national TR | 12 096 | Seulement ~4 mois, pas historique |
| Production régionale par filière | 234 | Table agrégée minuscule |
| Production régionale ENR | 234 | Table agrégée minuscule |
| Conso annuelle brute | 25 | 25 lignes... |

### Potentiels (massifs, à investiguer)

| Dataset | Lignes estimées | Producteur | Statut |
|---------|----------------|------------|--------|
| DPE Logements existants | ~20M (500+ MB) | ADEME | Pas de Parquet public |
| Conso élec par commune × secteur | ~500K | Enedis | OpenDataSoft |
| Bilan électrique Enedis | ~100K | Enedis | OpenDataSoft |

## Solution : ressources communautaires data.gouv.fr

La seule voie pour avoir des Parquets sur `static.data.gouv.fr` :

1. Télécharger le Parquet depuis l'API OpenDataSoft
2. Optimiser : trier par colonnes pertinentes, compression ZSTD, row groups ~20K
3. Uploader comme ressource communautaire sur data.gouv.fr
4. Récupérer l'URL `static.data.gouv.fr`
5. Utiliser cette URL dans `ducklake_add_data_files`

### Script de préparation

```sql
-- Télécharger depuis ODRÉ (peut prendre 5 min pour les gros fichiers)
-- Puis optimiser avec DuckDB :

-- éCO2mix régional consolidé (2.7M lignes, 2013-2026)
COPY (
  SELECT * EXCLUDE(column_30)
  FROM read_parquet('https://odre.opendatasoft.com/api/explore/v2.1/catalog/datasets/eco2mix-regional-cons-def/exports/parquet')
  ORDER BY date_heure, code_insee_region
) TO 'eco2mix_regional_cons.parquet'
(FORMAT PARQUET, COMPRESSION ZSTD, ROW_GROUP_SIZE 20000);

-- Registre national installations (126K lignes, trié par région)
COPY (
  SELECT * FROM read_parquet('https://odre.opendatasoft.com/api/explore/v2.1/catalog/datasets/registre-national-installation-production-stockage-electricite-agrege-311225/exports/parquet')
  ORDER BY region, filiere, puismaxinstallee DESC
) TO 'registre_installations.parquet'
(FORMAT PARQUET, COMPRESSION ZSTD, ROW_GROUP_SIZE 10000);

-- Conso quotidienne (251K lignes, déjà trié par date)
COPY (
  SELECT * FROM read_parquet('https://odre.opendatasoft.com/api/explore/v2.1/catalog/datasets/consommation-quotidienne-brute/exports/parquet')
  ORDER BY date_heure
) TO 'conso_quotidienne.parquet'
(FORMAT PARQUET, COMPRESSION ZSTD, ROW_GROUP_SIZE 10000);
```

### URLs des datasets sources sur data.gouv.fr

- Registre installations : https://www.data.gouv.fr/datasets/registre-national-des-installations-de-production-et-de-stockage-delectricite-au-31-12-2025
- éCO2mix régional consolidé : https://odre.opendatasoft.com/explore/dataset/eco2mix-regional-cons-def/ (pas sur data.gouv.fr, directement ODRÉ)
- Conso quotidienne : https://www.data.gouv.fr/datasets/consommation-quotidienne-brute

### Procédure d'upload ressource communautaire

1. Aller sur la page data.gouv.fr du dataset
2. Cliquer "Proposer une ressource communautaire"
3. Uploader le fichier `.parquet` optimisé
4. Récupérer l'URL `https://static.data.gouv.fr/resources/.../...parquet`
5. Créer le fichier `schemas/vYYYY-MM-DD/energie/energie_<table>.sql` avec `ducklake_add_data_files` pointant sur cette URL
6. Régénérer le catalog

## Leçons apprises

1. **OpenDataSoft ≠ CDN statique** — L'API `/exports/parquet` génère le fichier à la volée. Pas de Range Requests = incompatible DuckLake.
2. **Taille des fichiers ODRÉ** — L'éCO2mix régional pèse 84 MB (SNAPPY), 66 MB (ZSTD). Le téléchargement prend 5 minutes.
3. **Pruning fonctionne si trié** — Les données ODRÉ sont déjà triées par date pour les séries temporelles (éCO2mix, conso_quotidienne). Le registre n'est pas trié → trier par `region` pour permettre le pruning géographique.
4. **Compression ZSTD** — Réduit la taille de 15-25% vs SNAPPY. Le gain est modeste mais appréciable sur 84 MB.
5. **Éco2mix TR (temps réel) inutile** — Seulement 4 mois de données glissantes. L'intérêt de DuckLake est sur l'historique complet (éCO2mix régional consolidé : 13 ans).
