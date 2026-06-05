-- Schema: alimentation
-- Table: open_food_facts
-- Dataset: Open Food Facts - Produits alimentaires : ingrédients, nutrition, labels
-- Source: https://www.data.gouv.fr/datasets/open-food-facts-produits-alimentaires-ingredients-nutrition-labels/
-- Base collaborative de produits alimentaires : ingrédients, valeurs nutritionnelles,
-- labels (Nutri-Score, Eco-Score, NOVA), allergènes, additifs.
-- 111 colonnes, ~4.5M produits, ~7.5 GB Parquet
-- Hosted on HuggingFace: openfoodfacts/product-database (simplified export)
-- ⚠️ 9 colonnes STRUCT imbriquées (product_name, nutriments, images, packagings, etc.)
-- ⚠️ Colonnes *_tags en VARCHAR[] — utiliser unnest() ou list_contains() pour les requêtes
-- License: ODbL
-- Last updated: 2026-06-05

CREATE TABLE alimentation.open_food_facts (
  additives_n INTEGER NULL,
  additives_tags VARCHAR[] NULL,
  allergens_tags VARCHAR[] NULL,
  brands_tags VARCHAR[] NULL,
  brands VARCHAR NULL,
  categories VARCHAR NULL,
  categories_tags VARCHAR[] NULL,
  categories_properties STRUCT(ciqual_food_code INTEGER, agribalyse_food_code INTEGER, agribalyse_proxy_food_code INTEGER) NULL,
  checkers_tags VARCHAR[] NULL,
  ciqual_food_name_tags VARCHAR[] NULL,
  cities_tags VARCHAR[] NULL,
  code VARCHAR NULL,
  compared_to_category VARCHAR NULL,
  complete INTEGER NULL,
  completeness FLOAT NULL,
  correctors_tags VARCHAR[] NULL,
  countries_tags VARCHAR[] NULL,
  created_t BIGINT NULL,
  creator VARCHAR NULL,
  data_quality_errors_tags VARCHAR[] NULL,
  data_quality_info_tags VARCHAR[] NULL,
  data_quality_warnings_tags VARCHAR[] NULL,
  data_sources_tags VARCHAR[] NULL,
  environmental_score_data VARCHAR NULL,
  environmental_score_grade VARCHAR NULL,
  environmental_score_score INTEGER NULL,
  environmental_score_tags VARCHAR[] NULL,
  editors VARCHAR[] NULL,
  emb_codes_tags VARCHAR[] NULL,
  emb_codes VARCHAR NULL,
  entry_dates_tags VARCHAR[] NULL,
  food_groups_tags VARCHAR[] NULL,
  generic_name STRUCT(lang VARCHAR, "text" VARCHAR)[] NULL,
  images STRUCT("key" VARCHAR, imgid INTEGER, rev INTEGER, sizes STRUCT("100" STRUCT(h INTEGER, w INTEGER), "200" STRUCT(h INTEGER, w INTEGER), "400" STRUCT(h INTEGER, w INTEGER), "full" STRUCT(h INTEGER, w INTEGER)), uploaded_t BIGINT, uploader VARCHAR)[] NULL,
  informers_tags VARCHAR[] NULL,
  ingredients_analysis_tags VARCHAR[] NULL,
  ingredients_from_palm_oil_n INTEGER NULL,
  ingredients_n INTEGER NULL,
  ingredients_original_tags VARCHAR[] NULL,
  ingredients_percent_analysis INTEGER NULL,
  ingredients_tags VARCHAR[] NULL,
  ingredients_text STRUCT(lang VARCHAR, "text" VARCHAR)[] NULL,
  ingredients_with_specified_percent_n INTEGER NULL,
  ingredients_with_unspecified_percent_n INTEGER NULL,
  ingredients_without_ciqual_codes_n INTEGER NULL,
  ingredients_without_ciqual_codes VARCHAR[] NULL,
  ingredients VARCHAR NULL,
  known_ingredients_n INTEGER NULL,
  labels_tags VARCHAR[] NULL,
  labels VARCHAR NULL,
  lang VARCHAR NULL,
  languages_tags VARCHAR[] NULL,
  last_edit_dates_tags VARCHAR[] NULL,
  last_editor VARCHAR NULL,
  last_image_t BIGINT NULL,
  last_modified_by VARCHAR NULL,
  last_modified_t BIGINT NULL,
  last_updated_t BIGINT NULL,
  link VARCHAR NULL,
  main_countries_tags VARCHAR[] NULL,
  manufacturing_places_tags VARCHAR[] NULL,
  manufacturing_places VARCHAR NULL,
  max_imgid INTEGER NULL,
  minerals_tags VARCHAR[] NULL,
  misc_tags VARCHAR[] NULL,
  new_additives_n INTEGER NULL,
  no_nutrition_data BOOLEAN NULL,
  nova_group INTEGER NULL,
  nova_groups_tags VARCHAR[] NULL,
  nova_groups VARCHAR NULL,
  nucleotides_tags VARCHAR[] NULL,
  nutrient_levels_tags VARCHAR[] NULL,
  nutriments STRUCT("name" VARCHAR, "value" FLOAT, "100g" FLOAT, serving FLOAT, unit VARCHAR, prepared_value FLOAT, prepared_100g FLOAT, prepared_serving FLOAT, prepared_unit VARCHAR)[] NULL,
  nutriscore_grade VARCHAR NULL,
  nutriscore_score INTEGER NULL,
  nutrition_data_per VARCHAR NULL,
  obsolete BOOLEAN NULL,
  origins_tags VARCHAR[] NULL,
  origins VARCHAR NULL,
  owner_fields STRUCT(field_name VARCHAR, "timestamp" BIGINT)[] NULL,
  owner VARCHAR NULL,
  packagings_complete BOOLEAN NULL,
  packaging_recycling_tags VARCHAR[] NULL,
  packaging_shapes_tags VARCHAR[] NULL,
  packaging_tags VARCHAR[] NULL,
  packaging_text STRUCT(lang VARCHAR, "text" VARCHAR)[] NULL,
  packaging VARCHAR NULL,
  packagings STRUCT(material VARCHAR, number_of_units BIGINT, quantity_per_unit VARCHAR, quantity_per_unit_unit VARCHAR, quantity_per_unit_value VARCHAR, recycling VARCHAR, shape VARCHAR, weight_measured FLOAT)[] NULL,
  photographers VARCHAR[] NULL,
  popularity_key BIGINT NULL,
  popularity_tags VARCHAR[] NULL,
  product_name STRUCT(lang VARCHAR, "text" VARCHAR)[] NULL,
  product_quantity_unit VARCHAR NULL,
  product_quantity VARCHAR NULL,
  purchase_places_tags VARCHAR[] NULL,
  quantity VARCHAR NULL,
  rev INTEGER NULL,
  scans_n INTEGER NULL,
  serving_quantity VARCHAR NULL,
  serving_size VARCHAR NULL,
  states_tags VARCHAR[] NULL,
  stores_tags VARCHAR[] NULL,
  stores VARCHAR NULL,
  traces_tags VARCHAR[] NULL,
  unique_scans_n INTEGER NULL,
  unknown_ingredients_n INTEGER NULL,
  unknown_nutrients_tags VARCHAR[] NULL,
  vitamins_tags VARCHAR[] NULL,
  with_non_nutritive_sweeteners INTEGER NULL,
  with_sweeteners INTEGER NULL,
  schema_version INTEGER NULL
);

COMMENT ON TABLE alimentation.open_food_facts IS 'Open Food Facts : base collaborative de produits alimentaires. Ingrédients, valeurs nutritionnelles, labels (Nutri-Score, Eco-Score, NOVA), allergènes, additifs. ~4.5M produits dans le monde. Export Parquet simplifié hébergé sur HuggingFace (openfoodfacts/product-database). License ODbL.';

COMMENT ON COLUMN alimentation.open_food_facts.code IS 'Code-barres EAN du produit (identifiant unique Open Food Facts)';
COMMENT ON COLUMN alimentation.open_food_facts.product_name IS 'Nom du produit (multilingue : STRUCT(lang VARCHAR, text VARCHAR)[])';
COMMENT ON COLUMN alimentation.open_food_facts.brands IS 'Marque(s) du produit';
COMMENT ON COLUMN alimentation.open_food_facts.categories IS 'Catégories du produit (hiérarchie, séparées par virgules)';
COMMENT ON COLUMN alimentation.open_food_facts.categories_tags IS 'Tags de catégories (VARCHAR[]) — utiliser unnest() pour aplatir';
COMMENT ON COLUMN alimentation.open_food_facts.ingredients IS 'Liste des ingrédients (format texte brut)';
COMMENT ON COLUMN alimentation.open_food_facts.ingredients_tags IS 'Tags d''ingrédients (VARCHAR[])';
COMMENT ON COLUMN alimentation.open_food_facts.nutriscore_grade IS 'Nutri-Score : a (meilleur) à e (moins bon)';
COMMENT ON COLUMN alimentation.open_food_facts.nutriscore_score IS 'Score Nutri-Score numérique';
COMMENT ON COLUMN alimentation.open_food_facts.nova_group IS 'Groupe NOVA (1=non transformé, 4=ultra-transformé)';
COMMENT ON COLUMN alimentation.open_food_facts.nutriments IS 'Valeurs nutritionnelles détaillées (énergie, lipides, glucides, sel, etc. pour 100g et par portion). STRUCT(name, value, 100g, serving, unit, prepared_*)[]';
COMMENT ON COLUMN alimentation.open_food_facts.labels IS 'Labels et certifications (Bio, AOP, IGP, Commerce équitable, etc.)';
COMMENT ON COLUMN alimentation.open_food_facts.allergens_tags IS 'Allergènes (VARCHAR[]) : gluten, lait, œufs, arachides, etc.';
COMMENT ON COLUMN alimentation.open_food_facts.additives_tags IS 'Additifs alimentaires (VARCHAR[]) : E100, E200, etc.';
COMMENT ON COLUMN alimentation.open_food_facts.images IS 'Images du produit : URLs, dimensions, uploader. STRUCT imbriqué complexe';
COMMENT ON COLUMN alimentation.open_food_facts.obsolete IS 'True si le produit est marqué comme obsolète';
COMMENT ON COLUMN alimentation.open_food_facts.unique_scans_n IS 'Nombre de scans uniques (popularité du produit)';
COMMENT ON COLUMN alimentation.open_food_facts.completeness IS 'Score de complétude des données (0.0 à 1.0)';

CALL ducklake_add_data_files('dg', 'open_food_facts',
    'https://huggingface.co/datasets/openfoodfacts/product-database/resolve/main/food.parquet',
    schema => 'alimentation');
