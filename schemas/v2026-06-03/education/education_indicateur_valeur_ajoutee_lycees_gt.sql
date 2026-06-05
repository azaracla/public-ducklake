-- Schema: education
-- Table: indicateur_valeur_ajoutee_lycees_gt
-- Dataset: Indicateurs de valeur ajoutée des lycées d'enseignement général et technologique
-- Source: https://data.education.gouv.fr/api/explore/v2.1/catalog/datasets/fr-en-indicateurs-de-resultat-des-lycees-gt_v2/exports/parquet
-- Last updated: 2026-06-03

CREATE SCHEMA IF NOT EXISTS education;

CREATE TABLE education.indicateur_valeur_ajoutee_lycees_gt (
  annee DATE NULL
);

CALL ducklake_add_data_files('dg', 'indicateur_valeur_ajoutee_lycees_gt',
    'https://data.education.gouv.fr/api/explore/v2.1/catalog/datasets/fr-en-indicateurs-de-resultat-des-lycees-gt_v2/exports/parquet',
    schema => 'education', ignore_extra_columns => true);