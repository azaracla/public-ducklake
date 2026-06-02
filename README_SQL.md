# Scripts SQL pour le catalogue DuckLake Data.gouv.fr

Ce dossier contient les scripts SQL pour recréer le catalogue DuckLake `data_gouv_catalog.ducklake` à partir des métadonnées extraites.

## Fichiers générés

### 1. Fichier principal
- **`create_ducklake_catalog.sql`** : Script complet qui crée tous les schémas et tables du catalogue.

### 2. Fichiers par schéma
- **`create_schema_entreprises.sql`** : Script pour le schéma `entreprises` uniquement
- **`create_schema_demographie.sql`** : Script pour le schéma `demographie` uniquement

## Structure du catalogue

### Schéma: entreprises
Contient les données relatives aux entreprises françaises :

| Table | Description | Source |
|-------|-------------|--------|
| `annuaire_etablissements` | Établissements des entreprises (Annuaire) | data.gouv.fr |
| `annuaire_unites_legales` | Unités légales des entreprises (Annuaire) | data.gouv.fr |
| `beaamp_2025` | Base Étendue et Améliorée des Annonces de Marchés Publics | data.gouv.fr |
| `donnees_financieres` | Données financières détaillées des entreprises | data.gouv.fr |
| `sirene_etablissements` | Établissements des entreprises (Base Sirene - INSEE) | data.gouv.fr |
| `sirene_etablissements_historique` | Historique des établissements (Base Sirene) | data.gouv.fr |
| `sirene_unites_legales` | Unités légales (Base Sirene - INSEE) | data.gouv.fr |
| `sirene_unites_legales_historique` | Historique des unités légales (Base Sirene) | data.gouv.fr |

### Schéma: demographie
Contient les données du recensement de la population :

| Table | Description | Source |
|-------|-------------|--------|
| `recensement_logements_2020` | Fichier détaillé logements 2020 | data.gouv.fr |
| `recensement_logements_2021` | Fichier détaillé logements 2021 | data.gouv.fr |

## Utilisation

### Pour recréer le catalogue complet :

```bash
duckdb -c "$(cat create_ducklake_catalog.sql)"
```

Ou en mode interactif :
```sql
.read create_ducklake_catalog.sql
```

### Pour créer un schéma spécifique :

```bash
# Pour le schéma entreprises
duckdb -c "$(cat create_schema_entreprises.sql)"

# Pour le schéma demographie
duckdb -c "$(cat create_schema_demographie.sql)"
```

## Notes techniques

- Toutes les tables sont créées avec des colonnes NULLables (conforme à la source)
- Les types de données sont mappés depuis les types DuckDB vers SQL standard
- Chaque table inclut un commentaire avec son nom complet et l'URL source
- La commande `ducklake_add_data_files` est utilisée pour attacher les fichiers Parquet distants
- Le catalogue utilise le chemin de données local `./dg_lake/` pour stocker les métadonnées

## Mappings des types de données

| Type DuckDB | Type SQL |
|-------------|----------|
| varchar | VARCHAR |
| int64 | BIGINT |
| boolean | BOOLEAN |
| date | DATE |
| timestamp | TIMESTAMP |
| float64 | DOUBLE |
| int32 | INTEGER |
| int16 | SMALLINT |
| int8 | TINYINT |

## Génération

Ces fichiers ont été générés automatiquement à partir des métadonnées du catalogue DuckLake existant le 2026-06-02.
