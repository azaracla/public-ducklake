-- Schema: entreprises
-- Table: sirene_etablissements_historique
-- Dataset: Base Sirene des entreprises et de leurs établissements (SIREN, SIRET)
-- Source: https://static.data.gouv.fr/resources/base-sirene-des-entreprises-et-de-leurs-etablissements-siren-siret/20260601-092749/stock-stocketablissementhistorique-parquet.parquet
-- Last updated: 2026-06-03

CREATE SCHEMA IF NOT EXISTS entreprises;

CREATE TABLE entreprises.sirene_etablissements_historique (
  siren VARCHAR NULL
,
  nic VARCHAR NULL
,
  siret VARCHAR NULL
,
  dateFin DATE NULL
,
  dateDebut DATE NULL
,
  etatAdministratifEtablissement VARCHAR NULL
,
  changementEtatAdministratifEtablissement BOOLEAN NULL
,
  enseigne1Etablissement VARCHAR NULL
,
  enseigne2Etablissement VARCHAR NULL
,
  enseigne3Etablissement VARCHAR NULL
,
  changementEnseigneEtablissement BOOLEAN NULL
,
  denominationUsuelleEtablissement VARCHAR NULL
,
  changementDenominationUsuelleEtablissement BOOLEAN NULL
,
  activitePrincipaleEtablissement VARCHAR NULL
,
  nomenclatureActivitePrincipaleEtablissement VARCHAR NULL
,
  changementActivitePrincipaleEtablissement BOOLEAN NULL
,
  caractereEmployeurEtablissement VARCHAR NULL
,
  changementCaractereEmployeurEtablissement BOOLEAN NULL
);

COMMENT ON TABLE entreprises.sirene_etablissements_historique IS 'Historique des établissements (Base Sirene)';

CALL ducklake_add_data_files('dg', 'sirene_etablissements_historique',
    'https://static.data.gouv.fr/resources/base-sirene-des-entreprises-et-de-leurs-etablissements-siren-siret/20260601-092749/stock-stocketablissementhistorique-parquet.parquet',
    schema => 'entreprises');