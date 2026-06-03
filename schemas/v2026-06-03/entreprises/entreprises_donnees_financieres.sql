-- Schema: entreprises
-- Table: donnees_financieres
-- Dataset: Données financières détaillées des entreprises (format parquet)
-- Source: https://static.data.gouv.fr/resources/donnees-financieres-detaillees-des-entreprises-format-parquet/20260210-082327/export-detail-bilan.parquet
-- Last updated: 2026-06-03

CREATE SCHEMA IF NOT EXISTS entreprises;

CREATE TABLE entreprises.donnees_financieres (
  siren VARCHAR NULL
,
  date_cloture_exercice DATE NULL
,
  type_bilan VARCHAR NULL
,
  confidentiality VARCHAR NULL
,
  liasse MAP(VARCHAR NULL
,
  INTEGER) NULL NULL
);

COMMENT ON TABLE entreprises.donnees_financieres IS 'Données financières détaillées des entreprises';

CALL ducklake_add_data_files('dg', 'donnees_financieres',
    'https://static.data.gouv.fr/resources/donnees-financieres-detaillees-des-entreprises-format-parquet/20260210-082327/export-detail-bilan.parquet',
    schema => 'entreprises');