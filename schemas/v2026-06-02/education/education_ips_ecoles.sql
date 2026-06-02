-- Metadonnées
-- Schema: education
-- Table: ips_ecoles
-- Source: https://data.education.gouv.fr/api/explore/v2.1/catalog/datasets/fr-en-ips-ecoles-ap2022/exports/parquet
-- Last updated: 2026-06-02

-- Créer le schema si besoin
CREATE SCHEMA IF NOT EXISTS education;

-- Créer la table avec les types EXACTS du parquet_schema
CREATE TABLE education.ips_ecoles (
  rentree_scolaire VARCHAR NULL
  code_region VARCHAR NULL
  region VARCHAR NULL
  code_de_l_academie VARCHAR NULL
  academie VARCHAR NULL
  code_du_departement VARCHAR NULL
  departement VARCHAR NULL
  code_insee_de_la_commune VARCHAR NULL
  nom_de_la_commune VARCHAR NULL
  uai VARCHAR NULL
  nom_de_l_etablissement VARCHAR NULL
  secteur VARCHAR NULL
  ips VARCHAR NULL
  ips_national_prive VARCHAR NULL
  ips_national_public VARCHAR NULL
  ips_national VARCHAR NULL
  ips_academique_prive VARCHAR NULL
  ips_academique_public VARCHAR NULL
  ips_academique VARCHAR NULL
  ips_departemental_prive VARCHAR NULL
  ips_departemental_public VARCHAR NULL
  ips_departemental VARCHAR NULL
  num_ligne DOUBLE NULL
);

-- Commenter la table
COMMENT ON TABLE education.ips_ecoles 
IS 'L''indice de position sociale (IPS) permet d''apprehender le statut social des eleves a partir des professions et categories sociales (PCS) de leurs parents. A chaque PCS ou couple de PCS est associee une valeur numerique de l''IPS. Cette valeur numerique correspond a un resume quantitatif d''un ensemble d''attributs socio-economiques et culturels lies a la reussite scolaire. Plus l''indice de position sociale (IPS) est eleve, plus les eleves sont en moyenne d''origine sociale favorisee.';

-- Attacher le fichier Parquet (NE PAS COPIER les donnees)
CALL ducklake_add_data_files('dg', 'ips_ecoles',
    'https://data.education.gouv.fr/api/explore/v2.1/catalog/datasets/fr-en-ips-ecoles-ap2022/exports/parquet',
    schema => 'education');
