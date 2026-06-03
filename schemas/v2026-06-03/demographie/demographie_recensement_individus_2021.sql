-- Schema: demographie
-- Table: recensement_individus_2021
-- Source: https://static.data.gouv.fr/resources/recensement-de-la-population-fichiers-detail-individus-localises-au-canton-ou-ville-2020-1/20250211-164757/rp2021-indcvi.parquet
-- Last updated: 2026-06-03

CREATE SCHEMA IF NOT EXISTS demographie;

CREATE TABLE demographie.recensement_individus_2021 (
  CANTVILLE VARCHAR NULL,
  NUMMI VARCHAR NULL,
  ACHLR VARCHAR NULL,
  AEMMR VARCHAR NULL,
  AGED VARCHAR NULL,
  AGER20 VARCHAR NULL,
  AGEREV VARCHAR NULL,
  AGEREVQ VARCHAR NULL,
  ANAI VARCHAR NULL,
  ANEMR VARCHAR NULL,
  APAF VARCHAR NULL,
  ARM VARCHAR NULL,
  ASCEN VARCHAR NULL,
  BAIN VARCHAR NULL,
  BATI VARCHAR NULL,
  CATIRIS VARCHAR NULL,
  CATL VARCHAR NULL,
  CATPC VARCHAR NULL,
  CHAU VARCHAR NULL,
  CHFL VARCHAR NULL,
  CHOS VARCHAR NULL,
  CLIM VARCHAR NULL,
  CMBL VARCHAR NULL,
  COUPLE VARCHAR NULL,
  CUIS VARCHAR NULL,
  CS1 VARCHAR NULL,
  DEPT VARCHAR NULL,
  DEROU VARCHAR NULL,
  DIPL VARCHAR NULL,
  DNAI VARCHAR NULL,
  EAU VARCHAR NULL,
  EGOUL VARCHAR NULL,
  ELEC VARCHAR NULL,
  EMPL VARCHAR NULL,
  ETUD VARCHAR NULL,
  GARL VARCHAR NULL,
  HLML VARCHAR NULL,
  ILETUD VARCHAR NULL,
  ILT VARCHAR NULL,
  IMMIP VARCHAR NULL,
  INAI VARCHAR NULL,
  INATC VARCHAR NULL,
  INFAM VARCHAR NULL,
  INPER VARCHAR NULL,
  INPERF VARCHAR NULL,
  IPONDI DOUBLE NULL,
  IRAN VARCHAR NULL,
  IRIS VARCHAR NULL,
  LIENF VARCHAR NULL,
  LPRF VARCHAR NULL,
  LPRM VARCHAR NULL,
  METRODOM VARCHAR NULL,
  MOCO VARCHAR NULL,
  MOCO_DET VARCHAR NULL,
  RECOMPOSEE VARCHAR NULL,
  SANI VARCHAR NULL,
  SANIDOM VARCHAR NULL,
  SEXE VARCHAR NULL,
  SFM VARCHAR NULL,
  STAT_CONJ VARCHAR NULL,
  STATR VARCHAR NULL,
  STOCD VARCHAR NULL,
  SURF VARCHAR NULL,
  TACT VARCHAR NULL,
  TACTD16 VARCHAR NULL,
  TP VARCHAR NULL,
  TRANS VARCHAR NULL,
  TRIRIS VARCHAR NULL,
  TYPC VARCHAR NULL,
  TYPFC VARCHAR NULL,
  TYPL VARCHAR NULL,
  TYPMC VARCHAR NULL,
  TYPMR VARCHAR NULL,
  TDM8 VARCHAR NULL,
  VOIT VARCHAR NULL,
  WC VARCHAR NULL
);

COMMENT ON TABLE demographie.recensement_individus_2021 IS 'Fichier détaillé individus 2021 - Recensement de la population';

COMMENT ON COLUMN demographie.recensement_individus_2021.CANTVILLE IS 'Département, canton-ou-ville du lieu de résidence (pseudo-canton)';
COMMENT ON COLUMN demographie.recensement_individus_2021.NUMMI IS 'Numéro du ménage dans le canton-ou-ville (anonymisé)';
COMMENT ON COLUMN demographie.recensement_individus_2021.ACHLR IS 'Période regroupée d''achèvement de la construction de la maison ou de l''immeuble';
COMMENT ON COLUMN demographie.recensement_individus_2021.AEMMR IS 'Année d''emménagement dans le logement (regroupée)';
COMMENT ON COLUMN demographie.recensement_individus_2021.AGED IS 'Âge détaillé (en différence de millésimes)';
COMMENT ON COLUMN demographie.recensement_individus_2021.AGER20 IS 'Âge en années révolues (âge au dernier anniversaire) en 13 classes d''âge, détaillées autour de 20 ans';
COMMENT ON COLUMN demographie.recensement_individus_2021.AGEREV IS 'Âge en années révolues détaillé';
COMMENT ON COLUMN demographie.recensement_individus_2021.AGEREVQ IS 'Âge quinquennal en années révolues';
COMMENT ON COLUMN demographie.recensement_individus_2021.ANAI IS 'Année de naissance';
COMMENT ON COLUMN demographie.recensement_individus_2021.ANEMR IS 'Ancienneté d''emménagement dans le logement (regroupée)';
COMMENT ON COLUMN demographie.recensement_individus_2021.APAF IS 'Appartenance à une famille';
COMMENT ON COLUMN demographie.recensement_individus_2021.ARM IS 'Arrondissement municipal de résidence (Paris, Lyon et Marseille)';
COMMENT ON COLUMN demographie.recensement_individus_2021.ASCEN IS 'Desserte par un ascenseur';
COMMENT ON COLUMN demographie.recensement_individus_2021.BAIN IS 'Baignoire ou douche (DOM)';
COMMENT ON COLUMN demographie.recensement_individus_2021.BATI IS 'Aspect du bâti (DOM)';
COMMENT ON COLUMN demographie.recensement_individus_2021.CATIRIS IS 'Catégorie de l''IRIS';
COMMENT ON COLUMN demographie.recensement_individus_2021.CATL IS 'Catégorie de logement';
COMMENT ON COLUMN demographie.recensement_individus_2021.CATPC IS 'Catégorie de population condensée';
COMMENT ON COLUMN demographie.recensement_individus_2021.CHAU IS 'Moyen de chauffage du logement (DOM)';
COMMENT ON COLUMN demographie.recensement_individus_2021.CHFL IS 'Chauffage central du logement (France métropolitaine)';
COMMENT ON COLUMN demographie.recensement_individus_2021.CHOS IS 'Chauffe-eau solaire (DOM)';
COMMENT ON COLUMN demographie.recensement_individus_2021.CLIM IS 'Existence d''au moins une pièce climatisée (DOM)';
COMMENT ON COLUMN demographie.recensement_individus_2021.CMBL IS 'Combustible principal du logement (France métropolitaine)';
COMMENT ON COLUMN demographie.recensement_individus_2021.COUPLE IS 'Déclaration de vie en couple';
COMMENT ON COLUMN demographie.recensement_individus_2021.CUIS IS 'Cuisine intérieure avec évier (DOM)';
COMMENT ON COLUMN demographie.recensement_individus_2021.CS1 IS 'Catégorie socioprofessionnelle en 8 postes';
COMMENT ON COLUMN demographie.recensement_individus_2021.DEPT IS 'Département du lieu de résidence';
COMMENT ON COLUMN demographie.recensement_individus_2021.DEROU IS 'Nombre de deux-roues à moteur du ménage (DOM)';
COMMENT ON COLUMN demographie.recensement_individus_2021.DIPL IS 'Diplôme le plus élevé';
COMMENT ON COLUMN demographie.recensement_individus_2021.DNAI IS 'Département de naissance (si né en France)';
COMMENT ON COLUMN demographie.recensement_individus_2021.EAU IS 'Point d''eau potable à l''intérieur du logement (DOM)';
COMMENT ON COLUMN demographie.recensement_individus_2021.EGOUL IS 'Mode d''évacuation des eaux usées (DOM)';
COMMENT ON COLUMN demographie.recensement_individus_2021.ELEC IS 'Électricité dans le logement (DOM)';
COMMENT ON COLUMN demographie.recensement_individus_2021.EMPL IS 'Condition d''emploi';
COMMENT ON COLUMN demographie.recensement_individus_2021.ETUD IS 'Inscription dans un établissement d''enseignement';
COMMENT ON COLUMN demographie.recensement_individus_2021.GARL IS 'Emplacement réservé de stationnement';
COMMENT ON COLUMN demographie.recensement_individus_2021.HLML IS 'Appartenance du logement à un organisme HLM';
COMMENT ON COLUMN demographie.recensement_individus_2021.ILETUD IS 'Indicateur du lieu d''études';
COMMENT ON COLUMN demographie.recensement_individus_2021.ILT IS 'Indicateur du lieu de travail';
COMMENT ON COLUMN demographie.recensement_individus_2021.INAI IS 'Indicateur du lieu de naissance';
COMMENT ON COLUMN demographie.recensement_individus_2021.INATC IS 'Indicateur de nationalité condensé (Français/Étranger)';
COMMENT ON COLUMN demographie.recensement_individus_2021.INFAM IS 'Nombre de familles du ménage';
COMMENT ON COLUMN demographie.recensement_individus_2021.INPER IS 'Nombre de personnes du ménage';
COMMENT ON COLUMN demographie.recensement_individus_2021.INPERF IS 'Nombre de personnes de la famille';
COMMENT ON COLUMN demographie.recensement_individus_2021.IPONDI IS 'Poids de l''individu';
COMMENT ON COLUMN demographie.recensement_individus_2021.IRAN IS 'Indicateur de résidence antérieure au 1er janvier de l''année précédente';
COMMENT ON COLUMN demographie.recensement_individus_2021.IRIS IS 'Code IRIS du lieu de résidence';
COMMENT ON COLUMN demographie.recensement_individus_2021.LIENF IS 'Lien familial';
COMMENT ON COLUMN demographie.recensement_individus_2021.LPRF IS 'Lien à la personne de référence de la famille';
COMMENT ON COLUMN demographie.recensement_individus_2021.LPRM IS 'Lien à la personne de référence du ménage';
COMMENT ON COLUMN demographie.recensement_individus_2021.METRODOM IS 'Indicateur Métropole ou DOM du lieu de résidence';
COMMENT ON COLUMN demographie.recensement_individus_2021.MOCO IS 'Mode de cohabitation';
COMMENT ON COLUMN demographie.recensement_individus_2021.MOCO_DET IS 'Mode de cohabitation détaillée d''une personne';
COMMENT ON COLUMN demographie.recensement_individus_2021.RECOMPOSEE IS 'Indicateur de recomposition d''une famille';
COMMENT ON COLUMN demographie.recensement_individus_2021.SANI IS 'Installations sanitaires (France métropolitaine)';
COMMENT ON COLUMN demographie.recensement_individus_2021.SANIDOM IS 'Installations sanitaires (DOM)';
COMMENT ON COLUMN demographie.recensement_individus_2021.SEXE IS 'Sexe';
COMMENT ON COLUMN demographie.recensement_individus_2021.SFM IS 'Structure familiale du ménage';
COMMENT ON COLUMN demographie.recensement_individus_2021.STAT_CONJ IS 'Statut conjugal';
COMMENT ON COLUMN demographie.recensement_individus_2021.STATR IS 'Statut professionnel regroupé';
COMMENT ON COLUMN demographie.recensement_individus_2021.STOCD IS 'Statut d''occupation détaillé du logement';
COMMENT ON COLUMN demographie.recensement_individus_2021.SURF IS 'Superficie du logement';
COMMENT ON COLUMN demographie.recensement_individus_2021.TACT IS 'Type d''activité';
COMMENT ON COLUMN demographie.recensement_individus_2021.TACTD16 IS 'Type d''activité détaillé en 16 postes';
COMMENT ON COLUMN demographie.recensement_individus_2021.TP IS 'Temps de travail';
COMMENT ON COLUMN demographie.recensement_individus_2021.TRANS IS 'Mode de transport principal le plus souvent utilisé pour aller travailler';
COMMENT ON COLUMN demographie.recensement_individus_2021.TRIRIS IS 'Code TRIRIS du lieu de résidence';
COMMENT ON COLUMN demographie.recensement_individus_2021.TYPC IS 'Type de construction';
COMMENT ON COLUMN demographie.recensement_individus_2021.TYPFC IS 'Type de famille condensé';
COMMENT ON COLUMN demographie.recensement_individus_2021.TYPL IS 'Type de logement';
COMMENT ON COLUMN demographie.recensement_individus_2021.TYPMC IS 'Type de ménage regroupé (en 4 postes)';
COMMENT ON COLUMN demographie.recensement_individus_2021.TYPMR IS 'Type de ménage regroupé (en 9 postes)';
COMMENT ON COLUMN demographie.recensement_individus_2021.TDM8 IS 'Type détaillé du ménage en 8 postes';
COMMENT ON COLUMN demographie.recensement_individus_2021.VOIT IS 'Nombre de voitures du ménage';
COMMENT ON COLUMN demographie.recensement_individus_2021.WC IS 'Présence de W.-C. à l''intérieur du logement (DOM)';

CALL ducklake_add_data_files('dg', 'recensement_individus_2021',
    'https://static.data.gouv.fr/resources/recensement-de-la-population-fichiers-detail-individus-localises-au-canton-ou-ville-2020-1/20250211-164757/rp2021-indcvi.parquet',
    schema => 'demographie');