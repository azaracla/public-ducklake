-- Schema: education
-- Table: ips_ecoles
-- Dataset: Indices de position sociale des écoles (à partir de 2022)
-- Source: https://data.education.gouv.fr/api/explore/v2.1/catalog/datasets/fr-en-ips-ecoles-ap2022/exports/parquet
-- Last updated: 2026-06-03

CREATE SCHEMA IF NOT EXISTS education;

CREATE TABLE education.ips_ecoles (
  rentree_scolaire VARCHAR NULL
);

CALL ducklake_add_data_files('dg', 'ips_ecoles',
    'https://data.education.gouv.fr/api/explore/v2.1/catalog/datasets/fr-en-ips-ecoles-ap2022/exports/parquet',
    schema => 'education', ignore_extra_columns => true);