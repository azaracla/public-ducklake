-- ============================================================
-- DuckLake Database: data_gouv_catalog
-- Auto-generated from schemas/v2026-06-02
-- ============================================================

INSTALL ducklake;
INSTALL httpfs;
LOAD ducklake;
LOAD httpfs;

ATTACH 'ducklake:data_gouv_catalog.ducklake' AS dg (DATA_PATH './dg_lake/');
USE dg;

CREATE SCHEMA IF NOT EXISTS demographie;
CREATE SCHEMA IF NOT EXISTS entreprises;

.include schemas/v2026-06-02/demographie/demographie_recensement_individus_2020.sql
.include schemas/v2026-06-02/demographie/demographie_recensement_individus_2021.sql
.include schemas/v2026-06-02/demographie/demographie_recensement_logements_2020.sql
.include schemas/v2026-06-02/demographie/demographie_recensement_logements_2021.sql
.include schemas/v2026-06-02/entreprises/entreprises_annuaire_etablissements.sql
.include schemas/v2026-06-02/entreprises/entreprises_annuaire_unites_legales.sql
.include schemas/v2026-06-02/entreprises/entreprises_beaamp_2025.sql
.include schemas/v2026-06-02/entreprises/entreprises_donnees_financieres.sql
.include schemas/v2026-06-02/entreprises/entreprises_sirene_etablissements.sql
.include schemas/v2026-06-02/entreprises/entreprises_sirene_etablissements_historique.sql
.include schemas/v2026-06-02/entreprises/entreprises_sirene_unites_legales.sql
.include schemas/v2026-06-02/entreprises/entreprises_sirene_unites_legales_historique.sql
