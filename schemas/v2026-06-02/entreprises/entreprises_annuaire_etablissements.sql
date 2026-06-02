-- Schema: entreprises
-- Table: annuaire_etablissements
-- Source: https://static.data.gouv.fr/resources/donnees-des-entreprises-utilisees-dans-lannuaire-des-entreprises/20260602-161010/etablissements-2026-06-02.parquet
-- Last updated: 2026-06-02

CREATE SCHEMA IF NOT EXISTS entreprises;

CREATE TABLE entreprises.annuaire_etablissements (
  siren VARCHAR NULL,
  siret VARCHAR NULL,
  est_siege BOOLEAN NULL,
  ancien_siege BOOLEAN NULL,
  adresse VARCHAR NULL,
  etat_administratif VARCHAR NULL,
  statut_diffusion VARCHAR NULL,
  liste_finess_geographique LIST(VARCHAR) NULL,
  liste_id_bio LIST(VARCHAR) NULL,
  liste_idcc LIST(VARCHAR) NULL,
  liste_rge LIST(VARCHAR) NULL,
  liste_uai LIST(VARCHAR) NULL
);

COMMENT ON TABLE entreprises.annuaire_etablissements IS 'Établissements des entreprises (Annuaire des Entreprises)';

CALL ducklake_add_data_files('dg', 'annuaire_etablissements',
    'https://static.data.gouv.fr/resources/donnees-des-entreprises-utilisees-dans-lannuaire-des-entreprises/20260602-161010/etablissements-2026-06-02.parquet',
    schema => 'entreprises');
