-- Schema: economie
-- Table: boamp_siren
-- Dataset: Jointure BOAMP - SIREN / Côté acheteurs / 2024, 2025 et 2026
-- Source: https://www.data.gouv.fr/datasets/jointure-boamp-siren-cote-acheteurs-2024-2025-et-2026/
-- BOAMP (Bulletin Officiel des Annonces de Marchés Publics) enrichi avec données SIREN des acheteurs
-- 84 colonnes : annonces BOAMP (B_*) + enrichissement SIREN (SN_*)
-- 3 années : 2024 (~432 MB), 2025 (~456 MB), 2026 (~175 MB)
-- Last updated: 2026-06-05

CREATE TABLE economie.boamp_siren (
  B_01_annonceLie VARCHAR NULL
,
  B_02_annonceReferenceSchemaV110 VARCHAR NULL
,
  B_03_annoncesAnterieuresSchemaV110 VARCHAR NULL
,
  B_04_codeDepartement VARCHAR NULL
,
  B_05_codeDepartementPrestation VARCHAR NULL
,
  B_06_criteres VARCHAR NULL
,
  B_07_dateFinDiffusion VARCHAR NULL
,
  B_08_dateLimiteReponse VARCHAR NULL
,
  B_09_dateParution VARCHAR NULL
,
  B_10_dc VARCHAR NULL
,
  B_11_descripteurCode VARCHAR NULL
,
  B_12_descripteurLibelle VARCHAR NULL
,
  B_13_etat VARCHAR NULL
,
  B_14_famille VARCHAR NULL
,
  B_15_familleLibelle VARCHAR NULL
,
  B_16_filename VARCHAR NULL
,
  B_17_idweb VARCHAR NULL
,
  B_18_marchePublicSimplifie VARCHAR NULL
,
  B_19_marchePublicSimplifieLabel VARCHAR NULL
,
  B_20_nature VARCHAR NULL
,
  B_21_natureCategorise VARCHAR NULL
,
  B_22_natureCategoriseLibelle VARCHAR NULL
,
  B_23_natureLibelle VARCHAR NULL
,
  B_24_nomAcheteur VARCHAR NULL
,
  B_25_objet VARCHAR NULL
,
  B_26_perimetre VARCHAR NULL
,
  B_27_procedureCategorise VARCHAR NULL
,
  B_28_procedureLibelle VARCHAR NULL
,
  B_29_sourceSchema VARCHAR NULL
,
  B_30_sousNature VARCHAR NULL
,
  B_31_sousNatureLibelle VARCHAR NULL
,
  B_32_sousTypeProcedure VARCHAR NULL
,
  B_33_titulaire VARCHAR NULL
,
  B_34_typeAvis VARCHAR NULL
,
  B_35_typeMarche VARCHAR NULL
,
  B_36_typeMarcheFacette VARCHAR NULL
,
  B_37_typeProcedure VARCHAR NULL
,
  B_38_urlAvis VARCHAR NULL
,
  B_39_id VARCHAR NULL
,
  B_40_GESTION VARCHAR NULL
,
  B_41_GESTION_URL_JSON VARCHAR NULL
,
  B_42_DONNEES VARCHAR NULL
,
  B_43_DONNEES_URL_JSON VARCHAR NULL
,
  B_44_ANNONCES_ANTERIEURES VARCHAR NULL
,
  B_45_ANNONCES_ANTERIEURES_URL_JSON VARCHAR NULL
,
  B_46_NUM_SIRET_ACHETEURS_RECUP VARCHAR NULL
,
  B_47_NOM_SIRET_ACHETEURS_RECUP VARCHAR NULL
,
  B_48_NOM_CAT_JUR_ACHETEUR VARCHAR NULL
,
  B_49_contractfolderid VARCHAR NULL
,
  SN_01_activitePrincipaleUniteLegale VARCHAR NULL
,
  SN_02_anneeCategorieEntreprise VARCHAR NULL
,
  SN_03_anneeEffectifsUniteLegale VARCHAR NULL
,
  SN_04_caractereEmployeurUniteLegale VARCHAR NULL
,
  SN_05_categorieEntreprise VARCHAR NULL
,
  SN_06_categorieJuridiqueUniteLegale VARCHAR NULL
,
  SN_07_dateCreationUniteLegale VARCHAR NULL
,
  SN_08_dateDebut VARCHAR NULL
,
  SN_09_dateDernierTraitementUniteLegale VARCHAR NULL
,
  SN_10_denominationUniteLegale VARCHAR NULL
,
  SN_11_denominationUsuelle1UniteLegale VARCHAR NULL
,
  SN_12_denominationUsuelle2UniteLegale VARCHAR NULL
,
  SN_13_denominationUsuelle3UniteLegale VARCHAR NULL
,
  SN_14_economieSocialeSolidaireUniteLegale VARCHAR NULL
,
  SN_15_etatAdministratifUniteLegale VARCHAR NULL
,
  SN_16_identifiantAssociationUniteLegale VARCHAR NULL
,
  SN_17_nicSiegeUniteLegale VARCHAR NULL
,
  SN_18_nomUniteLegale VARCHAR NULL
,
  SN_19_nomUsageUniteLegale VARCHAR NULL
,
  SN_20_nombrePeriodesUniteLegale VARCHAR NULL
,
  SN_21_nomenclatureActivitePrincipaleUniteLegale VARCHAR NULL
,
  SN_22_prenom1UniteLegale VARCHAR NULL
,
  SN_23_prenom2UniteLegale VARCHAR NULL
,
  SN_24_prenom3UniteLegale VARCHAR NULL
,
  SN_25_prenom4UniteLegale VARCHAR NULL
,
  SN_26_prenomUsuelUniteLegale VARCHAR NULL
,
  SN_27_pseudonymeUniteLegale VARCHAR NULL
,
  SN_28_sexeUniteLegale VARCHAR NULL
,
  SN_29_sigleUniteLegale VARCHAR NULL
,
  SN_30_siren VARCHAR NULL
,
  SN_31_societeMissionUniteLegale VARCHAR NULL
,
  SN_32_statutDiffusionUniteLegale VARCHAR NULL
,
  SN_33_trancheEffectifsUniteLegale VARCHAR NULL
,
  SN_34_unitePurgeeUniteLegale VARCHAR NULL
,
  activitePrincipaleNAF25UniteLegale VARCHAR NULL
);

COMMENT ON TABLE economie.boamp_siren IS 'Jointure BOAMP-SIREN côté acheteurs : annonces de marchés publics (BOAMP) enrichies avec les données SIREN des acheteurs. 84 colonnes couvrant 2024–2026. Complémentaire à economie.commande_publique (DECP) et entreprises.beaamp_2025. Source: data.gouv.fr dataset 6863b7cbb1aafe4118ea43d3 (AuFilDuBoamp.com)';

COMMENT ON COLUMN economie.boamp_siren.B_01_annonceLie IS 'Annonce liée (identifiant)';
COMMENT ON COLUMN economie.boamp_siren.B_09_dateParution IS 'Date de parution de l''annonce BOAMP';
COMMENT ON COLUMN economie.boamp_siren.B_24_nomAcheteur IS 'Nom de l''acheteur public';
COMMENT ON COLUMN economie.boamp_siren.B_25_objet IS 'Objet du marché';
COMMENT ON COLUMN economie.boamp_siren.B_33_titulaire IS 'Nom du titulaire du marché';
COMMENT ON COLUMN economie.boamp_siren.B_39_id IS 'Identifiant unique de l''annonce';
COMMENT ON COLUMN economie.boamp_siren.B_46_NUM_SIRET_ACHETEURS_RECUP IS 'SIRET de l''acheteur récupéré';
COMMENT ON COLUMN economie.boamp_siren.B_47_NOM_SIRET_ACHETEURS_RECUP IS 'Nom associé au SIRET acheteur';
COMMENT ON COLUMN economie.boamp_siren.SN_01_activitePrincipaleUniteLegale IS 'Activité principale de l''unité légale (code NAF)';
COMMENT ON COLUMN economie.boamp_siren.SN_06_categorieJuridiqueUniteLegale IS 'Catégorie juridique de l''unité légale';
COMMENT ON COLUMN economie.boamp_siren.SN_10_denominationUniteLegale IS 'Dénomination de l''unité légale';
COMMENT ON COLUMN economie.boamp_siren.SN_18_nomUniteLegale IS 'Nom de l''unité légale';
COMMENT ON COLUMN economie.boamp_siren.SN_30_siren IS 'Numéro SIREN de l''acheteur';
COMMENT ON COLUMN economie.boamp_siren.SN_33_trancheEffectifsUniteLegale IS 'Tranche d''effectifs de l''unité légale';
COMMENT ON COLUMN economie.boamp_siren.activitePrincipaleNAF25UniteLegale IS 'Activité principale NAF25 de l''unité légale';

CALL ducklake_add_data_files('dg', 'boamp_siren',
    'https://static.data.gouv.fr/resources/jointure-boamp-siren-cote-acheteurs-2024-2025-et-2026/20260604-062858/boamp-avec-siren-acheteurs-2026.parquet',
    schema => 'economie');

CALL ducklake_add_data_files('dg', 'boamp_siren',
    'https://static.data.gouv.fr/resources/jointure-boamp-siren-cote-acheteurs-2024-2025-et-2026/20260514-070839/boamp-avec-siren-acheteurs-2025.parquet',
    schema => 'economie');

CALL ducklake_add_data_files('dg', 'boamp_siren',
    'https://static.data.gouv.fr/resources/jointure-boamp-siren-cote-acheteurs-2024-2025-et-2026/20260514-070736/boamp-avec-siren-acheteurs-2024.parquet',
    schema => 'economie');
