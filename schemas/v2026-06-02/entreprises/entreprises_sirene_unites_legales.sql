-- Schema: entreprises
-- Table: sirene_unites_legales
-- Source: https://static.data.gouv.fr/resources/base-sirene-des-entreprises-et-de-leurs-etablissements-siren-siret/20260601-092310/stock-stockunitelegale-parquet.parquet
-- Last updated: 2026-06-02

CREATE SCHEMA IF NOT EXISTS entreprises;

CREATE TABLE entreprises.sirene_unites_legales (
  siren VARCHAR NULL,
  statutDiffusionUniteLegale VARCHAR NULL,
  unitePurgeeUniteLegale BOOLEAN NULL,
  dateCreationUniteLegale DATE NULL,
  sigleUniteLegale VARCHAR NULL,
  sexeUniteLegale VARCHAR NULL,
  prenom1UniteLegale VARCHAR NULL,
  prenom2UniteLegale VARCHAR NULL,
  prenom3UniteLegale VARCHAR NULL,
  prenom4UniteLegale VARCHAR NULL,
  prenomUsuelUniteLegale VARCHAR NULL,
  pseudonymeUniteLegale VARCHAR NULL,
  identifiantAssociationUniteLegale VARCHAR NULL,
  trancheEffectifsUniteLegale VARCHAR NULL,
  anneeEffectifsUniteLegale BIGINT NULL,
  dateDernierTraitementUniteLegale TIMESTAMP NULL,
  nombrePeriodesUniteLegale BIGINT NULL,
  categorieEntreprise VARCHAR NULL,
  anneeCategorieEntreprise BIGINT NULL,
  dateDebut DATE NULL,
  etatAdministratifUniteLegale VARCHAR NULL,
  nomUniteLegale VARCHAR NULL,
  nomUsageUniteLegale VARCHAR NULL,
  denominationUniteLegale VARCHAR NULL,
  denominationUsuelle1UniteLegale VARCHAR NULL,
  denominationUsuelle2UniteLegale VARCHAR NULL,
  denominationUsuelle3UniteLegale VARCHAR NULL,
  categorieJuridiqueUniteLegale BIGINT NULL,
  activitePrincipaleUniteLegale VARCHAR NULL,
  nomenclatureActivitePrincipaleUniteLegale VARCHAR NULL,
  nicSiegeUniteLegale VARCHAR NULL,
  economieSocialeSolidaireUniteLegale VARCHAR NULL,
  societeMissionUniteLegale VARCHAR NULL,
  caractereEmployeurUniteLegale VARCHAR NULL,
  activitePrincipaleNAF25UniteLegale VARCHAR NULL
);

COMMENT ON TABLE entreprises.sirene_unites_legales IS 'Unités légales (Base Sirene - INSEE)';

CALL ducklake_add_data_files('dg', 'sirene_unites_legales',
    'https://static.data.gouv.fr/resources/base-sirene-des-entreprises-et-de-leurs-etablissements-siren-siret/20260601-092310/stock-stockunitelegale-parquet.parquet',
    schema => 'entreprises');
