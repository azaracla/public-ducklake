-- Schema: entreprises
-- Table: sirene_etablissements
-- Dataset: Base Sirene des entreprises et de leurs établissements (SIREN, SIRET)
-- Source: https://www.data.gouv.fr/api/1/datasets/r/a29c1297-1f92-4e2a-8f6b-8c902ce96c5f
-- Last updated: 2026-06-03

CREATE SCHEMA IF NOT EXISTS entreprises;

CREATE TABLE entreprises.sirene_etablissements (
  siren VARCHAR NULL
,
  nic VARCHAR NULL
,
  siret VARCHAR NULL
,
  statutDiffusionEtablissement VARCHAR NULL
,
  dateCreationEtablissement DATE NULL
,
  trancheEffectifsEtablissement VARCHAR NULL
,
  anneeEffectifsEtablissement BIGINT NULL
,
  activitePrincipaleRegistreMetiersEtablissement VARCHAR NULL
,
  dateDernierTraitementEtablissement TIMESTAMP NULL
,
  etablissementSiege BOOLEAN NULL
,
  nombrePeriodesEtablissement BIGINT NULL
,
  complementAdresseEtablissement VARCHAR NULL
,
  numeroVoieEtablissement VARCHAR NULL
,
  indiceRepetitionEtablissement VARCHAR NULL
,
  dernierNumeroVoieEtablissement VARCHAR NULL
,
  indiceRepetitionDernierNumeroVoieEtablissement VARCHAR NULL
,
  typeVoieEtablissement VARCHAR NULL
,
  libelleVoieEtablissement VARCHAR NULL
,
  codePostalEtablissement VARCHAR NULL
,
  libelleCommuneEtablissement VARCHAR NULL
,
  libelleCommuneEtrangerEtablissement VARCHAR NULL
,
  distributionSpecialeEtablissement VARCHAR NULL
,
  codeCommuneEtablissement VARCHAR NULL
,
  codeCedexEtablissement VARCHAR NULL
,
  libelleCedexEtablissement VARCHAR NULL
,
  codePaysEtrangerEtablissement VARCHAR NULL
,
  libellePaysEtrangerEtablissement VARCHAR NULL
,
  identifiantAdresseEtablissement VARCHAR NULL
,
  coordonneeLambertAbscisseEtablissement VARCHAR NULL
,
  coordonneeLambertOrdonneeEtablissement VARCHAR NULL
,
  complementAdresse2Etablissement VARCHAR NULL
,
  numeroVoie2Etablissement VARCHAR NULL
,
  indiceRepetition2Etablissement VARCHAR NULL
,
  typeVoie2Etablissement VARCHAR NULL
,
  libelleVoie2Etablissement VARCHAR NULL
,
  codePostal2Etablissement VARCHAR NULL
,
  libelleCommune2Etablissement VARCHAR NULL
,
  libelleCommuneEtranger2Etablissement VARCHAR NULL
,
  distributionSpeciale2Etablissement VARCHAR NULL
,
  codeCommune2Etablissement VARCHAR NULL
,
  codeCedex2Etablissement VARCHAR NULL
,
  libelleCedex2Etablissement VARCHAR NULL
,
  codePaysEtranger2Etablissement VARCHAR NULL
,
  libellePaysEtranger2Etablissement VARCHAR NULL
,
  dateDebut DATE NULL
,
  etatAdministratifEtablissement VARCHAR NULL
,
  enseigne1Etablissement VARCHAR NULL
,
  enseigne2Etablissement VARCHAR NULL
,
  enseigne3Etablissement VARCHAR NULL
,
  denominationUsuelleEtablissement VARCHAR NULL
,
  activitePrincipaleEtablissement VARCHAR NULL
,
  nomenclatureActivitePrincipaleEtablissement VARCHAR NULL
,
  caractereEmployeurEtablissement VARCHAR NULL
,
  activitePrincipaleNAF25Etablissement VARCHAR NULL
);

COMMENT ON TABLE entreprises.sirene_etablissements IS 'Établissements des entreprises (Base Sirene - INSEE)';

CALL ducklake_add_data_files('dg', 'sirene_etablissements',
    'https://www.data.gouv.fr/api/1/datasets/r/a29c1297-1f92-4e2a-8f6b-8c902ce96c5f',
    schema => 'entreprises');