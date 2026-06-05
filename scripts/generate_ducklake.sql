-- ============================================================
-- DuckLake Database: data_gouv_catalog
-- Auto-generated from schemas/v2026-06-05
-- ============================================================

INSTALL ducklake;
INSTALL httpfs;
LOAD ducklake;
LOAD httpfs;

ATTACH 'ducklake:data_gouv_catalog.ducklake' AS dg (DATA_PATH './dg_lake/');
USE dg;

CREATE SCHEMA IF NOT EXISTS demographie;
CREATE SCHEMA IF NOT EXISTS entreprises;
CREATE SCHEMA IF NOT EXISTS education;
CREATE SCHEMA IF NOT EXISTS foncier;
CREATE SCHEMA IF NOT EXISTS economie;
CREATE SCHEMA IF NOT EXISTS alimentation;

.read schemas/v2026-06-03/demographie/demographie_recensement_individus_2020.sql
.read schemas/v2026-06-03/demographie/demographie_recensement_individus_2021.sql
.read schemas/v2026-06-03/demographie/demographie_recensement_logements_2020.sql
.read schemas/v2026-06-03/demographie/demographie_recensement_logements_2021.sql
.read schemas/v2026-06-03/education/education_indicateur_valeur_ajoutee_lycees_gt.sql
.read schemas/v2026-06-03/education/education_indice_eloignement_lycees.sql
.read schemas/v2026-06-03/education/education_ips_ecoles.sql
.read schemas/v2026-06-03/entreprises/entreprises_annuaire_etablissements.sql
.read schemas/v2026-06-03/entreprises/entreprises_annuaire_unites_legales.sql
.read schemas/v2026-06-03/entreprises/entreprises_beaamp_2025.sql
.read schemas/v2026-06-03/entreprises/entreprises_donnees_financieres.sql
.read schemas/v2026-06-03/entreprises/entreprises_sirene_etablissements.sql
.read schemas/v2026-06-03/entreprises/entreprises_sirene_etablissements_historique.sql
.read schemas/v2026-06-03/entreprises/entreprises_sirene_unites_legales.sql
.read schemas/v2026-06-03/entreprises/entreprises_sirene_unites_legales_historique.sql
.read schemas/v2026-06-03/foncier/foncier_dvf.sql
.read schemas/v2026-06-05/economie/economie_commande_publique.sql
.read schemas/v2026-06-05/economie/economie_filosofi_carroye.sql
.read schemas/v2026-06-05/economie/economie_insee_olap.sql
.read schemas/v2026-06-05/economie/economie_boamp_siren.sql
.read schemas/v2026-06-05/alimentation/alimentation_open_prices.sql
.read schemas/v2026-06-05/alimentation/alimentation_open_food_facts.sql
