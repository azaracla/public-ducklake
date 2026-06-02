-- Schema: entreprises
-- Table: sirene_unites_legales_historique
-- Source: https://static.data.gouv.fr/resources/base-sirene-des-entreprises-et-de-leurs-etablissements-siren-siret/20260601-092423/stock-stockunitelegalehistorique-parquet.parquet
-- Last updated: 2026-06-02

CREATE SCHEMA IF NOT EXISTS entreprises;

CREATE TABLE entreprises.sirene_unites_legales_historique (
  siren VARCHAR NULL,
  dateFin DATE NULL,
  dateDebut DATE NULL,
  etatAdministratifUniteLegale VARCHAR NULL,
  changementEtatAdministratifUniteLegale BOOLEAN NULL,
  nomUniteLegale VARCHAR NULL,
  changementNomUniteLegale BOOLEAN NULL,
  nomUsageUniteLegale VARCHAR NULL,
  changementNomUsageUniteLegale BOOLEAN NULL,
  denominationUniteLegale VARCHAR NULL,
  changementDenominationUniteLegale BOOLEAN NULL,
  denominationUsuelle1UniteLegale VARCHAR NULL,
  denominationUsuelle2UniteLegale VARCHAR NULL,
  denominationUsuelle3UniteLegale VARCHAR NULL,
  changementDenominationUsuelleUniteLegale BOOLEAN NULL,
  categorieJuridiqueUniteLegale VARCHAR NULL,
  changementCategorieJuridiqueUniteLegale BOOLEAN NULL,
  activitePrincipaleUniteLegale VARCHAR NULL,
  nomenclatureActivitePrincipaleUniteLegale VARCHAR NULL,
  changementActivitePrincipaleUniteLegale BOOLEAN NULL,
  nicSiegeUniteLegale VARCHAR NULL,
  changementNicSiegeUniteLegale BOOLEAN NULL,
  economieSocialeSolidaireUniteLegale VARCHAR NULL,
  changementEconomieSocialeSolidaireUniteLegale BOOLEAN NULL,
  societeMissionUniteLegale VARCHAR NULL,
  changementSocieteMissionUniteLegale BOOLEAN NULL,
  caractereEmployeurUniteLegale VARCHAR NULL,
  changementCaractereEmployeurUniteLegale BOOLEAN NULL
);

COMMENT ON TABLE entreprises.sirene_unites_legales_historique IS 'Historique des unités légales (Base Sirene)';

CALL ducklake_add_data_files('dg', 'sirene_unites_legales_historique',
    'https://static.data.gouv.fr/resources/base-sirene-des-entreprises-et-de-leurs-etablissements-siren-siret/20260601-092423/stock-stockunitelegalehistorique-parquet.parquet',
    schema => 'entreprises');
