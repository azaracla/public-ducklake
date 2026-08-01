-- Schema: entreprises
-- Table: sirene_unites_legales_historique
-- Dataset: Base Sirene des entreprises et de leurs établissements (SIREN, SIRET)
-- Source: https://www.data.gouv.fr/api/1/datasets/r/1b9290ed-d0bc-461f-ba31-0250a99cc140
-- Last updated: 2026-06-03

CREATE SCHEMA IF NOT EXISTS entreprises;

CREATE TABLE entreprises.sirene_unites_legales_historique (
  siren VARCHAR NULL
,
  dateFin DATE NULL
,
  dateDebut DATE NULL
,
  etatAdministratifUniteLegale VARCHAR NULL
,
  changementEtatAdministratifUniteLegale BOOLEAN NULL
,
  nomUniteLegale VARCHAR NULL
,
  changementNomUniteLegale BOOLEAN NULL
,
  nomUsageUniteLegale VARCHAR NULL
,
  changementNomUsageUniteLegale BOOLEAN NULL
,
  denominationUniteLegale VARCHAR NULL
,
  changementDenominationUniteLegale BOOLEAN NULL
,
  denominationUsuelle1UniteLegale VARCHAR NULL
,
  denominationUsuelle2UniteLegale VARCHAR NULL
,
  denominationUsuelle3UniteLegale VARCHAR NULL
,
  changementDenominationUsuelleUniteLegale BOOLEAN NULL
,
  categorieJuridiqueUniteLegale VARCHAR NULL
,
  changementCategorieJuridiqueUniteLegale BOOLEAN NULL
,
  activitePrincipaleUniteLegale VARCHAR NULL
,
  nomenclatureActivitePrincipaleUniteLegale VARCHAR NULL
,
  changementActivitePrincipaleUniteLegale BOOLEAN NULL
,
  nicSiegeUniteLegale VARCHAR NULL
,
  changementNicSiegeUniteLegale BOOLEAN NULL
,
  economieSocialeSolidaireUniteLegale VARCHAR NULL
,
  changementEconomieSocialeSolidaireUniteLegale BOOLEAN NULL
,
  societeMissionUniteLegale VARCHAR NULL
,
  changementSocieteMissionUniteLegale BOOLEAN NULL
,
  caractereEmployeurUniteLegale VARCHAR NULL
,
  changementCaractereEmployeurUniteLegale BOOLEAN NULL
);

COMMENT ON TABLE entreprises.sirene_unites_legales_historique IS 'Historique des unités légales (Base Sirene)';

CALL ducklake_add_data_files('dg', 'sirene_unites_legales_historique',
    'https://www.data.gouv.fr/api/1/datasets/r/1b9290ed-d0bc-461f-ba31-0250a99cc140',
    schema => 'entreprises');