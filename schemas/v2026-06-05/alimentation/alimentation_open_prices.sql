-- Schema: alimentation
-- Table: open_prices
-- Dataset: Open Prices
-- Source: https://www.data.gouv.fr/datasets/open-prices/
-- Projet Open Food Facts : collecte collaborative des prix de produits dans le monde
-- 52 colonnes, ~262K lignes, ~27 MB Parquet
-- Hosted on HuggingFace: openfoodfacts/open-prices
-- Last updated: 2026-06-05

CREATE TABLE alimentation.open_prices (
  id BIGINT NULL,
  type VARCHAR NULL,
  product_code VARCHAR NULL,
  product_name VARCHAR NULL,
  category_tag VARCHAR NULL,
  labels_tags VARCHAR[] NULL,
  origins_tags VARCHAR[] NULL,
  price DECIMAL(10,3) NULL,
  price_is_discounted BOOLEAN NULL,
  price_without_discount DECIMAL(10,3) NULL,
  discount_type VARCHAR NULL,
  price_per VARCHAR NULL,
  currency VARCHAR NULL,
  location_osm_id BIGINT NULL,
  location_osm_type VARCHAR NULL,
  location_id INTEGER NULL,
  date DATE NULL,
  proof_id INTEGER NULL,
  receipt_quantity FLOAT NULL,
  owner VARCHAR NULL,
  source VARCHAR NULL,
  created TIMESTAMP WITH TIME ZONE NULL,
  updated TIMESTAMP WITH TIME ZONE NULL,
  proof_file_path VARCHAR NULL,
  proof_mimetype VARCHAR NULL,
  proof_type VARCHAR NULL,
  proof_date DATE NULL,
  proof_currency VARCHAR NULL,
  proof_receipt_price_count INTEGER NULL,
  proof_receipt_price_total DECIMAL(10,3) NULL,
  proof_owner VARCHAR NULL,
  proof_source VARCHAR NULL,
  proof_created TIMESTAMP WITH TIME ZONE NULL,
  proof_updated TIMESTAMP WITH TIME ZONE NULL,
  location_type VARCHAR NULL,
  location_osm_display_name VARCHAR NULL,
  location_osm_tag_key VARCHAR NULL,
  location_osm_tag_value VARCHAR NULL,
  location_osm_address_postcode VARCHAR NULL,
  location_osm_address_city VARCHAR NULL,
  location_osm_address_country VARCHAR NULL,
  location_osm_address_country_code VARCHAR NULL,
  location_osm_lat DOUBLE NULL,
  location_osm_lon DOUBLE NULL,
  location_website_url VARCHAR NULL,
  location_source VARCHAR NULL,
  location_created TIMESTAMP WITH TIME ZONE NULL,
  location_updated TIMESTAMP WITH TIME ZONE NULL
);

COMMENT ON TABLE alimentation.open_prices IS 'Open Prices : collecte collaborative des prix de produits (alimentation, cosmétiques, etc.) dans le monde entier. 52 colonnes, ~262K preuves de prix. Projet Open Food Facts. Source: HuggingFace openfoodfacts/open-prices';

COMMENT ON COLUMN alimentation.open_prices.id IS 'Identifiant unique de la preuve de prix';
COMMENT ON COLUMN alimentation.open_prices.product_code IS 'Code-barres (EAN) du produit';
COMMENT ON COLUMN alimentation.open_prices.product_name IS 'Nom du produit';
COMMENT ON COLUMN alimentation.open_prices.category_tag IS 'Catégorie du produit (tag Open Food Facts)';
COMMENT ON COLUMN alimentation.open_prices.price IS 'Prix du produit';
COMMENT ON COLUMN alimentation.open_prices.currency IS 'Devise (EUR, USD, etc.)';
COMMENT ON COLUMN alimentation.open_prices.date IS 'Date du relevé de prix';
COMMENT ON COLUMN alimentation.open_prices.location_osm_address_city IS 'Ville du point de vente';
COMMENT ON COLUMN alimentation.open_prices.location_osm_address_country IS 'Pays du point de vente';
COMMENT ON COLUMN alimentation.open_prices.location_osm_lat IS 'Latitude du point de vente';
COMMENT ON COLUMN alimentation.open_prices.location_osm_lon IS 'Longitude du point de vente';
COMMENT ON COLUMN alimentation.open_prices.proof_type IS 'Type de preuve (ticket de caisse, étiquette prix, etc.)';

CALL ducklake_add_data_files('dg', 'open_prices',
    'https://huggingface.co/datasets/openfoodfacts/open-prices/resolve/main/prices.parquet',
    schema => 'alimentation');
