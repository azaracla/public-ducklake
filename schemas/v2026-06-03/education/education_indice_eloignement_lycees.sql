-- Schema: education
-- Table: indice_eloignement_lycees
-- Dataset: Indice d'éloignement des lycées
-- Source: https://data.education.gouv.fr/api/explore/v2.1/catalog/datasets/fr-en-indice_eloignement_lycee_ap2020/exports/parquet
-- Last updated: 2026-06-03

CREATE SCHEMA IF NOT EXISTS education;

CREATE TABLE education.indice_eloignement_lycees (
  rentree_scolaire VARCHAR NULL
);

CALL ducklake_add_data_files('dg', 'indice_eloignement_lycees',
    'https://data.education.gouv.fr/api/explore/v2.1/catalog/datasets/fr-en-indice_eloignement_lycee_ap2020/exports/parquet',
    schema => 'education');