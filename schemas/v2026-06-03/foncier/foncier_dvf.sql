-- Schema: foncier
-- Table: dvf
-- Dataset: Demandes de valeurs foncières géolocalisées
-- Source: https://static.data.gouv.fr/resources/demandes-de-valeurs-foncieres-geolocalisees/20260603-214003/geo-dvf-2021-2025.parquet
-- Last updated: 2026-06-03
-- Note: GeoParquet v2 supporté par DuckLake - colonne geom accessible directement

CREATE SCHEMA IF NOT EXISTS foncier;

CREATE TABLE foncier.dvf (
  id_mutation VARCHAR NULL,
  date_mutation DATE NULL,
  numero_disposition VARCHAR NULL,
  nature_mutation VARCHAR NULL,
  valeur_fonciere DOUBLE NULL,
  adresse_numero BIGINT NULL,
  adresse_suffixe VARCHAR NULL,
  adresse_nom_voie VARCHAR NULL,
  adresse_code_voie VARCHAR NULL,
  code_postal VARCHAR NULL,
  code_commune VARCHAR NULL,
  nom_commune VARCHAR NULL,
  code_departement VARCHAR NULL,
  ancien_code_commune VARCHAR NULL,
  ancien_nom_commune VARCHAR NULL,
  id_parcelle VARCHAR NULL,
  ancien_id_parcelle VARCHAR NULL,
  numero_volume VARCHAR NULL,
  lot1_numero VARCHAR NULL,
  lot1_surface_carrez DOUBLE NULL,
  lot2_numero VARCHAR NULL,
  lot2_surface_carrez DOUBLE NULL,
  lot3_numero VARCHAR NULL,
  lot3_surface_carrez DOUBLE NULL,
  lot4_numero VARCHAR NULL,
  lot4_surface_carrez DOUBLE NULL,
  lot5_numero VARCHAR NULL,
  lot5_surface_carrez DOUBLE NULL,
  nombre_lots BIGINT NULL,
  code_type_local BIGINT NULL,
  type_local VARCHAR NULL,
  surface_reelle_bati VARCHAR NULL,
  nombre_pieces_principales BIGINT NULL,
  code_nature_culture VARCHAR NULL,
  nature_culture VARCHAR NULL,
  code_nature_culture_speciale VARCHAR NULL,
  nature_culture_speciale VARCHAR NULL,
  surface_terrain BIGINT NULL,
  longitude DOUBLE NULL,
  latitude DOUBLE NULL,
  geom GEOMETRY NULL
);

COMMENT ON TABLE foncier.dvf IS 'Demandes de valeurs foncières géolocalisées - Transactions immobilières 2021-2025 (DGFiP) - Normalisé et enrichi avec COG 2020 et PCI 2020 - GeoParquet v2 avec géométries';

-- Commentaires sur les colonnes
COMMENT ON COLUMN foncier.dvf.id_mutation IS 'Identifiant unique de la mutation foncière';
COMMENT ON COLUMN foncier.dvf.date_mutation IS 'Date de la mutation (transaction)';
COMMENT ON COLUMN foncier.dvf.numero_disposition IS 'Numéro de disposition administrative';
COMMENT ON COLUMN foncier.dvf.nature_mutation IS 'Nature de la mutation (Vente, Échange, etc.)';
COMMENT ON COLUMN foncier.dvf.valeur_fonciere IS 'Valeur foncière déclarée de la transaction (en euros)';
COMMENT ON COLUMN foncier.dvf.adresse_numero IS 'Numéro dans la voie';
COMMENT ON COLUMN foncier.dvf.adresse_suffixe IS 'Suffixe du numéro (bis, ter, etc.)';
COMMENT ON COLUMN foncier.dvf.adresse_nom_voie IS 'Nom de la voie';
COMMENT ON COLUMN foncier.dvf.adresse_code_voie IS 'Code de la voie';
COMMENT ON COLUMN foncier.dvf.code_postal IS 'Code postal';
COMMENT ON COLUMN foncier.dvf.code_commune IS 'Code commune INSEE';
COMMENT ON COLUMN foncier.dvf.nom_commune IS 'Nom de la commune';
COMMENT ON COLUMN foncier.dvf.code_departement IS 'Code département';
COMMENT ON COLUMN foncier.dvf.ancien_code_commune IS 'Ancien code commune (avant fusion)';
COMMENT ON COLUMN foncier.dvf.ancien_nom_commune IS 'Ancien nom de la commune (avant fusion)';
COMMENT ON COLUMN foncier.dvf.id_parcelle IS 'Identifiant de la parcelle cadastrale';
COMMENT ON COLUMN foncier.dvf.ancien_id_parcelle IS 'Ancien identifiant de la parcelle (avant remodelage)';
COMMENT ON COLUMN foncier.dvf.numero_volume IS 'Numéro de volume';
COMMENT ON COLUMN foncier.dvf.lot1_numero IS 'Numéro du premier lot';
COMMENT ON COLUMN foncier.dvf.lot1_surface_carrez IS 'Surface Carrez du premier lot (en m²)';
COMMENT ON COLUMN foncier.dvf.lot2_numero IS 'Numéro du deuxième lot';
COMMENT ON COLUMN foncier.dvf.lot2_surface_carrez IS 'Surface Carrez du deuxième lot (en m²)';
COMMENT ON COLUMN foncier.dvf.lot3_numero IS 'Numéro du troisième lot';
COMMENT ON COLUMN foncier.dvf.lot3_surface_carrez IS 'Surface Carrez du troisième lot (en m²)';
COMMENT ON COLUMN foncier.dvf.lot4_numero IS 'Numéro du quatrième lot';
COMMENT ON COLUMN foncier.dvf.lot4_surface_carrez IS 'Surface Carrez du quatrième lot (en m²)';
COMMENT ON COLUMN foncier.dvf.lot5_numero IS 'Numéro du cinquième lot';
COMMENT ON COLUMN foncier.dvf.lot5_surface_carrez IS 'Surface Carrez du cinquième lot (en m²)';
COMMENT ON COLUMN foncier.dvf.nombre_lots IS 'Nombre total de lots concernés par la mutation';
COMMENT ON COLUMN foncier.dvf.code_type_local IS 'Code type de local';
COMMENT ON COLUMN foncier.dvf.type_local IS 'Type de local (Maison, Appartement, Local industriel, etc.)';
COMMENT ON COLUMN foncier.dvf.surface_reelle_bati IS 'Surface réelle du bâti (en m²)';
COMMENT ON COLUMN foncier.dvf.nombre_pieces_principales IS 'Nombre de pièces principales';
COMMENT ON COLUMN foncier.dvf.code_nature_culture IS 'Code nature de culture';
COMMENT ON COLUMN foncier.dvf.nature_culture IS 'Nature de culture (Terre, Pré, Vigne, etc.)';
COMMENT ON COLUMN foncier.dvf.code_nature_culture_speciale IS 'Code nature de culture spéciale';
COMMENT ON COLUMN foncier.dvf.nature_culture_speciale IS 'Nature de culture spéciale';
COMMENT ON COLUMN foncier.dvf.surface_terrain IS 'Surface du terrain (en m²)';
COMMENT ON COLUMN foncier.dvf.longitude IS 'Longitude (WGS84)';
COMMENT ON COLUMN foncier.dvf.latitude IS 'Latitude (WGS84)';

CALL ducklake_add_data_files('dg', 'dvf',
    'https://static.data.gouv.fr/resources/demandes-de-valeurs-foncieres-geolocalisees/20260603-214003/geo-dvf-2021-2025.parquet',
    schema => 'foncier');
