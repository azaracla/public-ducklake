-- Schema: demographie
-- Table: recensement_logements_2021
-- Source: https://static.data.gouv.fr/resources/recensement-de-la-population-fichiers-detail-logements-ordinaires/20250212-094137/fd-logemt-2021.parquet
-- Last updated: 2026-06-03

CREATE SCHEMA IF NOT EXISTS demographie;

CREATE TABLE demographie.recensement_logements_2021 (
  COMMUNE VARCHAR NULL,
  ARM VARCHAR NULL,
  IRIS VARCHAR NULL,
  ACHL VARCHAR NULL,
  AEMM VARCHAR NULL,
  AEMMR VARCHAR NULL,
  AGEMEN8 VARCHAR NULL,
  ANEM VARCHAR NULL,
  ANEMR VARCHAR NULL,
  ASCEN VARCHAR NULL,
  BAIN VARCHAR NULL,
  BATI VARCHAR NULL,
  CATIRIS VARCHAR NULL,
  CATL VARCHAR NULL,
  CHAU VARCHAR NULL,
  CHFL VARCHAR NULL,
  CHOS VARCHAR NULL,
  CLIM VARCHAR NULL,
  CMBL VARCHAR NULL,
  CUIS VARCHAR NULL,
  DEROU VARCHAR NULL,
  DIPLM VARCHAR NULL,
  EAU VARCHAR NULL,
  EGOUL VARCHAR NULL,
  ELEC VARCHAR NULL,
  EMPLM VARCHAR NULL,
  GARL VARCHAR NULL,
  HLML VARCHAR NULL,
  ILETUDM VARCHAR NULL,
  ILTM VARCHAR NULL,
  IMMIM VARCHAR NULL,
  INAIM VARCHAR NULL,
  INEEM VARCHAR NULL,
  INP11M VARCHAR NULL,
  INP15M VARCHAR NULL,
  INP17M VARCHAR NULL,
  INP19M VARCHAR NULL,
  INP24M VARCHAR NULL,
  INP3M VARCHAR NULL,
  INP60M VARCHAR NULL,
  INP65M VARCHAR NULL,
  INP5M VARCHAR NULL,
  INP75M VARCHAR NULL,
  INPAM VARCHAR NULL,
  INPER VARCHAR NULL,
  INPER1 VARCHAR NULL,
  INPER2 VARCHAR NULL,
  INPOM VARCHAR NULL,
  INPSM VARCHAR NULL,
  IPONDL DOUBLE NULL,
  IRANM VARCHAR NULL,
  METRODOM VARCHAR NULL,
  NBPI VARCHAR NULL,
  RECHM VARCHAR NULL,
  REGION VARCHAR NULL,
  SANI VARCHAR NULL,
  SANIDOM VARCHAR NULL,
  SEXEM VARCHAR NULL,
  STAT_CONJM VARCHAR NULL,
  STOCD VARCHAR NULL,
  SURF VARCHAR NULL,
  TACTM VARCHAR NULL,
  TPM VARCHAR NULL,
  TRANSM VARCHAR NULL,
  TRIRIS VARCHAR NULL,
  TYPC VARCHAR NULL,
  TYPL VARCHAR NULL,
  VOIT VARCHAR NULL,
  WC VARCHAR NULL
);

COMMENT ON TABLE demographie.recensement_logements_2021 IS 'Fichier détaillé logements 2021 - Recensement de la population';

COMMENT ON COLUMN demographie.recensement_logements_2021.ACHL IS 'Période d''achèvement de la construction de la maison ou de l''immeuble';
COMMENT ON COLUMN demographie.recensement_logements_2021.AEMM IS 'Année d''emménagement dans le logement (détaillée)';
COMMENT ON COLUMN demographie.recensement_logements_2021.AEMMR IS 'Année d''emménagement dans le logement (regroupée)';
COMMENT ON COLUMN demographie.recensement_logements_2021.AGEMEN8 IS 'Âge regroupé de la personne de référence du ménage en 8 classes d''âge';
COMMENT ON COLUMN demographie.recensement_logements_2021.ANEM IS 'Ancienneté d''emménagement dans le logement (détaillée)';
COMMENT ON COLUMN demographie.recensement_logements_2021.ANEMR IS 'Ancienneté d''emménagement dans le logement (regroupée)';
COMMENT ON COLUMN demographie.recensement_logements_2021.ASCEN IS 'Desserte par un ascenseur';
COMMENT ON COLUMN demographie.recensement_logements_2021.BAIN IS 'Baignoire ou douche (DOM)';
COMMENT ON COLUMN demographie.recensement_logements_2021.BATI IS 'Aspect du bâti (DOM)';
COMMENT ON COLUMN demographie.recensement_logements_2021.CATIRIS IS 'Catégorie de l''IRIS';
COMMENT ON COLUMN demographie.recensement_logements_2021.CATL IS 'Catégorie de logement';
COMMENT ON COLUMN demographie.recensement_logements_2021.CHAU IS 'Moyen de chauffage du logement (DOM)';
COMMENT ON COLUMN demographie.recensement_logements_2021.CHFL IS 'Chauffage central du logement (France métropolitaine)';
COMMENT ON COLUMN demographie.recensement_logements_2021.CHOS IS 'Chauffe-eau solaire (DOM)';
COMMENT ON COLUMN demographie.recensement_logements_2021.CLIM IS 'Existence d''au moins une pièce climatisée (DOM)';
COMMENT ON COLUMN demographie.recensement_logements_2021.CMBL IS 'Combustible principal du logement (France métropolitaine)';
COMMENT ON COLUMN demographie.recensement_logements_2021.CUIS IS 'Cuisine intérieure avec évier (DOM)';
COMMENT ON COLUMN demographie.recensement_logements_2021.DEROU IS 'Nombre de deux-roues à moteur du ménage (DOM)';
COMMENT ON COLUMN demographie.recensement_logements_2021.DIPLM IS 'Diplôme le plus élevé obtenu (personne de référence du ménage)';
COMMENT ON COLUMN demographie.recensement_logements_2021.EAU IS 'Point d''eau potable à l''intérieur du logement (DOM)';
COMMENT ON COLUMN demographie.recensement_logements_2021.EGOUL IS 'Mode d''évacuation des eaux usées (DOM)';
COMMENT ON COLUMN demographie.recensement_logements_2021.ELEC IS 'Électricité dans le logement (DOM)';
COMMENT ON COLUMN demographie.recensement_logements_2021.EMPLM IS 'Condition d''emploi (personne de référence du ménage)';
COMMENT ON COLUMN demographie.recensement_logements_2021.GARL IS 'Emplacement réservé de stationnement';
COMMENT ON COLUMN demographie.recensement_logements_2021.HLML IS 'Appartenance du logement à un organisme HLM';
COMMENT ON COLUMN demographie.recensement_logements_2021.ILETUDM IS 'Indicateur du lieu d''études (personne de référence du ménage)';
COMMENT ON COLUMN demographie.recensement_logements_2021.ILTM IS 'Indicateur de lieu de travail (personne de référence du ménage)';
COMMENT ON COLUMN demographie.recensement_logements_2021.IMMIM IS 'Situation quant à l''immigration (personne de référence du ménage)';
COMMENT ON COLUMN demographie.recensement_logements_2021.INAIM IS 'Indicateur du lieu de naissance (personne de référence du ménage)';
COMMENT ON COLUMN demographie.recensement_logements_2021.INEEM IS 'Nombre d''élèves, étudiants ou stagiaires âgés de 14 ans ou plus du ménage';
COMMENT ON COLUMN demographie.recensement_logements_2021.INP11M IS 'Nombre de personnes âgées de 11 ans ou moins du ménage';
COMMENT ON COLUMN demographie.recensement_logements_2021.INP15M IS 'Nombre de personnes âgées de 15 ans ou moins du ménage';
COMMENT ON COLUMN demographie.recensement_logements_2021.INP17M IS 'Nombre de personnes âgées de 17 ans ou moins du ménage';
COMMENT ON COLUMN demographie.recensement_logements_2021.INP19M IS 'Nombre de personnes âgées de 19 ans ou moins du ménage';
COMMENT ON COLUMN demographie.recensement_logements_2021.INP24M IS 'Nombre de personnes âgées de 24 ans ou moins du ménage';
COMMENT ON COLUMN demographie.recensement_logements_2021.INP3M IS 'Nombre de personnes âgées de 3 ans ou moins du ménage';
COMMENT ON COLUMN demographie.recensement_logements_2021.INP60M IS 'Nombre de personnes âgées de 60 ans ou plus du ménage';
COMMENT ON COLUMN demographie.recensement_logements_2021.INP65M IS 'Nombre de personnes âgées de 65 ans ou plus du ménage';
COMMENT ON COLUMN demographie.recensement_logements_2021.INP5M IS 'Nombre de personnes âgées de 5 ans ou moins du ménage';
COMMENT ON COLUMN demographie.recensement_logements_2021.INP75M IS 'Nombre de personnes âgées de 75 ans ou plus du ménage';
COMMENT ON COLUMN demographie.recensement_logements_2021.INPAM IS 'Nombre de personnes actives du ménage';
COMMENT ON COLUMN demographie.recensement_logements_2021.INPER IS 'Nombre de personnes du ménage';
COMMENT ON COLUMN demographie.recensement_logements_2021.INPER1 IS 'Nombre de personnes du ménage, de sexe masculin';
COMMENT ON COLUMN demographie.recensement_logements_2021.INPER2 IS 'Nombre de personnes du ménage, de sexe féminin';
COMMENT ON COLUMN demographie.recensement_logements_2021.INPOM IS 'Nombre de personnes actives ayant un emploi du ménage';
COMMENT ON COLUMN demographie.recensement_logements_2021.INPSM IS 'Nombre de personnes scolarisées du ménage';
COMMENT ON COLUMN demographie.recensement_logements_2021.IPONDL IS 'Poids du logement';
COMMENT ON COLUMN demographie.recensement_logements_2021.IRANM IS 'Indicateur du lieu de résidence antérieure au 1er janvier de l''annéee précédente de la personne de référence du ménage';
COMMENT ON COLUMN demographie.recensement_logements_2021.METRODOM IS 'Indicateur Métropole ou DOM du lieu de résidence';
COMMENT ON COLUMN demographie.recensement_logements_2021.NBPI IS 'Nombre de pièces du logement';
COMMENT ON COLUMN demographie.recensement_logements_2021.RECHM IS 'Ancienneté de recherche d''emploi (personne de référence du ménage)';
COMMENT ON COLUMN demographie.recensement_logements_2021.REGION IS 'Région du lieu de résidence';
COMMENT ON COLUMN demographie.recensement_logements_2021.SANI IS 'Installations sanitaires (France métropolitaine)';
COMMENT ON COLUMN demographie.recensement_logements_2021.SANIDOM IS 'Installations sanitaires (DOM)';
COMMENT ON COLUMN demographie.recensement_logements_2021.SEXEM IS 'Sexe de la personne de référence du ménage';
COMMENT ON COLUMN demographie.recensement_logements_2021.STAT_CONJM IS 'Statut conjugal de la personne de référence du ménage';
COMMENT ON COLUMN demographie.recensement_logements_2021.STOCD IS 'Statut d''occupation détaillé du logement';
COMMENT ON COLUMN demographie.recensement_logements_2021.SURF IS 'Superficie du logement';
COMMENT ON COLUMN demographie.recensement_logements_2021.TACTM IS 'Type d''activité de la personne de référence du ménage';
COMMENT ON COLUMN demographie.recensement_logements_2021.TPM IS 'Temps de travail (personne de référence du ménage)';
COMMENT ON COLUMN demographie.recensement_logements_2021.TRANSM IS 'Mode de transport principal le plus souvent utilisé pour aller travailler (personne de référence du ménage)';
COMMENT ON COLUMN demographie.recensement_logements_2021.TRIRIS IS 'Code TRIRIS du lieu de résidence';
COMMENT ON COLUMN demographie.recensement_logements_2021.TYPC IS 'Type de construction';
COMMENT ON COLUMN demographie.recensement_logements_2021.TYPL IS 'Type de logement';
COMMENT ON COLUMN demographie.recensement_logements_2021.VOIT IS 'Nombre de voitures du ménage';
COMMENT ON COLUMN demographie.recensement_logements_2021.WC IS 'Présence de W.-C. à l''intérieur du logement (DOM)';

CALL ducklake_add_data_files('dg', 'recensement_logements_2021',
    'https://static.data.gouv.fr/resources/recensement-de-la-population-fichiers-detail-logements-ordinaires-en-2020-1/20250212-094137/fd-logemt-2021.parquet',
    schema => 'demographie', ignore_extra_columns => true);