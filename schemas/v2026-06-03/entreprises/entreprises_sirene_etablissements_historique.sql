-- Schema: entreprises
-- Table: sirene_etablissements_historique
-- Dataset: Base Sirene des entreprises et de leurs établissements (SIREN, SIRET)
-- Source: https://www.data.gouv.fr/api/1/datasets/r/2b3a0c79-f97b-46b8-ac02-8be6c1f01a8c
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
    'https://www.data.gouv.fr/api/1/datasets/r/2b3a0c79-f97b-46b8-ac02-8be6c1f01a8c',
    schema => 'entreprises');