-- Metadonnées
-- Schema: education
-- Table: indice_eloignement_lycees
-- Source: https://data.education.gouv.fr/api/explore/v2.1/catalog/datasets/fr-en-indice_eloignement_lycee_ap2020/exports/parquet
-- Last updated: 2026-06-02

-- Créer le schema si besoin
CREATE SCHEMA IF NOT EXISTS education;

-- Créer la table avec les types EXACTS du parquet_schema
CREATE TABLE education.indice_eloignement_lycees (
  rentree_scolaire VARCHAR NULL
  uai VARCHAR NULL
  code_departement VARCHAR NULL
  departement VARCHAR NULL
  code_academie VARCHAR NULL
  academie VARCHAR NULL
  code_region VARCHAR NULL
  code_region_insee VARCHAR NULL
  region VARCHAR NULL
  patronyme VARCHAR NULL
  indice_eloignement VARCHAR NULL
);

-- Commenter la table
COMMENT ON TABLE education.indice_eloignement_lycees 
IS 'L''eloignement des lycees peut etre decrit statistiquement a l''aide d''un indicateur synthetique qui tient compte, pour un etablissement donne, de multiples dimensions : du lieu de residence des eleves qu''il scolarise, de l''offre d''enseignement et des equipements alentour. L''indice d''''eloignement permet de synthetiser en un indicateur la notion d''''eloignement pour un etablissement donne.';

-- Attacher le fichier Parquet (NE PAS COPIER les donnees)
CALL ducklake_add_data_files('dg', 'indice_eloignement_lycees',
    'https://data.education.gouv.fr/api/explore/v2.1/catalog/datasets/fr-en-indice_eloignement_lycee_ap2020/exports/parquet',
    schema => 'education');
