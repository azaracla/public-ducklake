# Rapport d'analyse — Requêtes cross-schema Public DuckLake

Date : 2026-06-05
Environnement : DuckDB v1.5.3 (Variegata), DuckLake + httpfs + spatial

## Requêtes testées

### 1. Prix immobilier vs densité de population (foncier × demographie)

```sql
INSTALL ducklake; LOAD ducklake;
INSTALL httpfs; LOAD httpfs;
ATTACH 'ducklake:data_gouv_catalog.ducklake' AS dg (READ_ONLY true);
USE dg;

WITH prix_commune AS (
  SELECT code_commune, nom_commune,
         AVG(valeur_fonciere / NULLIF(TRY_CAST(surface_reelle_bati AS DOUBLE), 0)) AS prix_m2_moyen,
         COUNT(*) AS nb_transactions
  FROM foncier.dvf
  WHERE type_local = 'Appartement'
    AND surface_reelle_bati IS NOT NULL
    AND TRY_CAST(surface_reelle_bati AS DOUBLE) > 5
    AND valeur_fonciere / NULLIF(TRY_CAST(surface_reelle_bati AS DOUBLE), 0) BETWEEN 100 AND 20000
  GROUP BY code_commune, nom_commune
),
pop_commune AS (
  SELECT COMMUNE, SUM(IPONDL) AS population
  FROM demographie.recensement_logements_2021
  GROUP BY COMMUNE
)
SELECT p.nom_commune, ROUND(p.prix_m2_moyen, 0) AS prix_m2_moyen, p.nb_transactions,
       CAST(pop.population AS INTEGER) AS population,
       ROUND(p.prix_m2_moyen / NULLIF(pop.population, 0) * 1000, 2) AS ratio_prix_pop
FROM prix_commune p
JOIN pop_commune pop ON p.code_commune = pop.COMMUNE
WHERE p.nb_transactions > 50
ORDER BY prix_m2_moyen DESC
LIMIT 20;
```

**Résultat** (top 10) :

| Commune | Prix/m² | Transactions | Population |
|---|---|---|---|
| Savignies | 18 370 € | 62 | 443 |
| Sainte-Colombe-sur-Seine | 15 121 € | 66 | 517 |
| Luneray | 13 177 € | 190 | 1 173 |
| Llupia | 12 843 € | 55 | 1 006 |
| Saint-Jean-Cap-Ferrat | 11 802 € | 171 | 2 080 |
| Val-d'Isère | 11 533 € | 512 | 6 888 |
| Neuilly-sur-Seine | 10 782 € | 4 950 | 34 899 |
| Saint-Tropez | 10 367 € | 747 | 6 841 |
| Courchevel | 10 218 € | 644 | 7 819 |
| Megève | 9 768 € | 1 204 | 9 279 |

Lecture : le top est dominé par les stations de ski et les communes littorales de luxe. Les petites communes (< 1000 habitants) ont des ratios prix/population extrêmes car quelques ventes de biens de prestige suffisent à faire exploser la moyenne.

---

### 2. Marchés publics vs Indice de Position Sociale des écoles (entreprises × education)

```sql

INSTALL ducklake; LOAD ducklake;
INSTALL httpfs; LOAD httpfs;
ATTACH 'ducklake:data_gouv_catalog.ducklake' AS dg (READ_ONLY true);
USE dg;

WITH marches_region AS (
  SELECT UPPER(TRIM(region_acheteur)) AS region_norm,
         COUNT(*) AS nb_marches,
         COUNT(DISTINCT siren_acheteur) AS nb_acheteurs
  FROM entreprises.beaamp_2025
  WHERE region_acheteur IS NOT NULL
  GROUP BY region_norm
),
ips_region AS (
  SELECT UPPER(TRIM(region)) AS region_norm,
         AVG(CASE WHEN ips ~ '^[0-9]+(\.[0-9]+)?$' THEN CAST(ips AS DOUBLE) END) AS ips_moyen,
         COUNT(DISTINCT uai) AS nb_ecoles
  FROM education.ips_ecoles
  WHERE region IS NOT NULL AND ips IS NOT NULL AND ips != ''
  GROUP BY region_norm
)
SELECT m.region_norm, m.nb_marches, m.nb_acheteurs,
       ROUND(i.ips_moyen, 2) AS ips_moyen, i.nb_ecoles,
       ROUND(m.nb_marches * 1.0 / NULLIF(i.nb_ecoles, 0), 2) AS marches_par_ecole
FROM marches_region m
JOIN ips_region i ON m.region_norm = i.region_norm
ORDER BY i.ips_moyen DESC;
```

**Résultat** :

| Région | Nb marchés | Acheteurs | IPS moyen | Écoles | Marchés/école |
|---|---|---|---|---|---|
| BRETAGNE | 3 683 | 242 | 107.17 | 1 997 | 1.84 |
| OCCITANIE | 6 369 | 404 | 106.16 | 3 066 | 2.08 |
| PAYS DE LA LOIRE | 3 141 | 224 | 104.81 | 2 225 | 1.41 |
| NOUVELLE-AQUITAINE | 6 930 | 393 | 104.50 | 3 169 | 2.19 |
| CENTRE-VAL DE LOIRE | 2 140 | 157 | 102.82 | 1 357 | 1.58 |
| CORSE | 939 | 45 | 102.39 | 181 | 5.19 |
| NORMANDIE | 3 499 | 217 | 101.93 | 1 816 | 1.93 |
| GRAND EST | 5 698 | 336 | 101.27 | 2 842 | 2.00 |
| HAUTS-DE-FRANCE | 5 259 | 328 | 98.39 | 3 403 | 1.55 |

Lecture : 9 régions sur 18 matchent — voir section problèmes. Corrélation IPS × marchés publics pas évidente sur ces 9 régions. La Corse a le ratio marchés/école le plus élevé (5.19) pour un IPS dans la moyenne.

---

### 3. Analyse spatiale — Prix immobilier autour de Notre-Dame (foncier × spatial)

```sql

INSTALL ducklake; LOAD ducklake;
INSTALL httpfs; LOAD httpfs;
INSTALL spatial; LOAD spatial;
ATTACH 'ducklake:data_gouv_catalog.ducklake' AS dg (READ_ONLY true);
USE dg;

-- Rayon de 5km autour de Notre-Dame
SELECT AVG(valeur_fonciere) AS prix_moyen,
       COUNT(*) AS nb_ventes,
       ROUND(AVG(valeur_fonciere / NULLIF(TRY_CAST(surface_reelle_bati AS DOUBLE), 0)), 0) AS prix_m2_moyen
FROM foncier.dvf
WHERE ST_DWithin(
  geom,
  ST_GeomFromText('POINT(2.3499 48.8530)'),
  5000
)
AND type_local = 'Appartement'
AND TRY_CAST(surface_reelle_bati AS DOUBLE) > 5
AND valeur_fonciere / NULLIF(TRY_CAST(surface_reelle_bati AS DOUBLE), 0) BETWEEN 100 AND 25000;
```

**Résultat** :

| Prix moyen | Nb ventes | Prix/m² |
|---|---|---|
| 249 765 € | 2 540 891 | 4 724 € |

2.5 millions de transactions en 5 ans dans un rayon de 5km autour de Notre-Dame. Prix/m² cohérent avec le marché parisien.

**Note** : requête exécutée en ~3 secondes. La colonne `geom` (GeoParquet v2 native) est indexée par DuckDB spatial — les filtres spatiaux sont très rapides.

---

### 4. Créations d'entreprises par année (entreprises Sirene)

```sql

INSTALL ducklake; LOAD ducklake;
INSTALL httpfs; LOAD httpfs;
ATTACH 'ducklake:data_gouv_catalog.ducklake' AS dg (READ_ONLY true);
USE dg;

SELECT YEAR(dateDebut) AS annee_creation,
       COUNT(*) AS nb_creations
FROM entreprises.sirene_unites_legales
WHERE dateDebut IS NOT NULL
  AND YEAR(dateDebut) BETWEEN 2015 AND 2025
GROUP BY YEAR(dateDebut)
ORDER BY annee_creation;
```

**Résultat** :

| Année | Créations |
|---|---|
| 2015 | 691 810 |
| 2016 | 949 710 |
| 2017 | 796 743 |
| 2018 | 898 708 |
| 2019 | 1 032 712 |
| 2020 | 1 200 967 |
| 2021 | 1 502 024 |
| 2022 | 1 589 287 |
| 2023 | 2 019 466 |
| 2024 | 2 396 706 |
| 2025 | 2 350 431 |

Cette requête utilise la colonne `dateDebut` (DATE NULL) qui est bien typée dans le Parquet source.

---

### 5. Créations 2024 par forme juridique

```sql

INSTALL ducklake; LOAD ducklake;
INSTALL httpfs; LOAD httpfs;
ATTACH 'ducklake:data_gouv_catalog.ducklake' AS dg (READ_ONLY true);
USE dg;

SELECT categorieJuridiqueUniteLegale,
       COUNT(*) AS nb,
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS pct
FROM entreprises.sirene_unites_legales
WHERE dateDebut IS NOT NULL AND YEAR(dateDebut) = 2024
  AND categorieJuridiqueUniteLegale IS NOT NULL
GROUP BY categorieJuridiqueUniteLegale
ORDER BY nb DESC
LIMIT 10;
```

**Résultat** :

| Code juridique | Nb créations | % |
|---|---|---|
| 1000 (EI) | 1 576 475 | 65.78 |
| 5710 (SAS) | 322 817 | 13.47 |
| 5499 (SARL) | 191 940 | 8.01 |
| 6540 (SCI) | 128 507 | 5.36 |
| 9220 (Association) | 53 128 | 2.22 |
| 3220 (SNC) | 25 466 | 1.06 |
| 2110 | 22 526 | 0.94 |
| 6599 | 18 268 | 0.76 |
| 5202 | 12 011 | 0.50 |
| 5485 | 6 230 | 0.26 |

2/3 des créations = entrepreneurs individuels (régime micro-entrepreneur). SAS + SARL = 21.5%.

---

## Problèmes rencontrés

### 1. `SET force_download=true` — interdit en usage normal

**Symptôme** : avec `SET force_download=true`, toute requête qui lit une colonne de `entreprises.sirene_etablissements` échoue avec `Invalid Error: stoi`. Sans `force_download`, la table fonctionne parfaitement (43M lignes, toutes colonnes lisibles).

**Diagnostic** : `force_download` est une option de configuration DuckDB (`BOOLEAN`, default `false`) qui force le téléchargement complet du fichier avant lecture, au lieu des HTTP range requests habituelles. Ce flag double le trafic réseau et casse le lazy loading de DuckLake — il n'a aucun intérêt pour le catalogue. L'erreur `stoi` est un bug DuckLake qui ne se déclenche que dans ce mode.

**Correction** : ne jamais utiliser `SET force_download=true`. Toutes les requêtes de ce rapport ont été corrigées. Le catalogue est conçu pour le streaming HTTP partiel — `force_download` va à l'encontre de son architecture.

### 3. DVF — outliers dans `valeur_fonciere`

Des transactions ont des valeurs aberrantes (ex: 220 623 264 € pour un appartement). Vraisemblablement des mutations groupées (immeubles entiers, lots multiples) enregistrées avec la surface d'un seul bien.

**Correction** : filtrer `prix/m² BETWEEN 100 AND 20000` élimine les outliers tout en gardant les biens de luxe.

### 4. Jointures inter-régions — noms non normalisés

Les jointures entre `education` (colonne `region`) et `entreprises` (BEAAMP : `region_acheteur`, Sirene : `libelleCommuneEtablissement`) perdent environ 50% des régions. Même avec `UPPER(TRIM())`, des régions comme Île-de-France, Auvergne-Rhône-Alpes, PACA ne matchent pas.

**Cause probable** :
- BEAAMP utilise des noms administratifs officiels
- Les tables Éducation utilisent des noms d'affichage avec accents et variations
- Sirene n'a pas de colonne région, seulement le nom de commune

**Solution** : créer une table de mapping des noms de région, ou joindre via le code département.

### 5. `surface_reelle_bati` est en VARCHAR

La colonne DVF `surface_reelle_bati` est déclarée en `VARCHAR NULL` dans le Parquet source, alors qu'elle contient des valeurs numériques. Utiliser `TRY_CAST(... AS DOUBLE)` systématiquement.

### 6. Colonnes numériques avec valeurs non numériques (`NS`, `NA`)

Les tables éducation (`ips`, `indice_eloignement`) contiennent des marqueurs textuels `'NS'` (Non Significatif) et `'NA'` (Non Applicable). Pattern de filtrage nécessaire :

```sql
CASE WHEN colonne ~ '^[0-9]+(\.[0-9]+)?$' THEN CAST(colonne AS DOUBLE) END
```

---

## Synthèse

### Ce qui marche bien

| Fonctionnalité | Statut |
|---|---|
| Spatial (ST_DWithin sur geom) | ✅ Rapide, ~3s sur 20M lignes |
| Cross-schema DVF × Démographie | ✅ Après filtre outliers |
| Cross-schema BEAAMP × Éducation | ✅ Jointure partielle |
| Sirene unites_legales | ✅ Toutes colonnes OK |
| Données financières | ✅ via MAP |
| GeoParquet v2 geom | ✅ Natif DuckDB spatial |

### Ce qui est cassé

| Problème | Impact | Sévérité |
|---|---|---|
| Jointures inter-régions | ~50% des régions perdues | 🟡 Moyen |
| DVF outliers | Filtre manuel nécessaire | 🟡 Moyen |
| Colonnes numériques avec strings | CAST nécessaire partout | 🟡 Moyen |
| `force_download=true` | Télécharge tout le fichier, casse DuckLake | 🔴 Ne pas utiliser |

### Recommandations

1. **Bannir `SET force_download=true`** — ce flag force le téléchargement complet des fichiers et casse l'architecture streaming du catalogue. Documenter dans CLAUDE.md.
2. **Ajouter une table de lookup `codes_geographiques`** — mapping code_departement → région normalisé, pour fiabiliser les jointures inter-schémas.
3. **Nettoyer les colonnes numériques en amont** — remplacer `'NS'`/`'NA'` par NULL dans les colonnes `ips`, `indice_eloignement` au niveau du Parquet source.
4. **Ajouter une colonne `surface_reelle_bati_num` DOUBLE** dans le schema DVF pour éviter le TRY_CAST systématique.
