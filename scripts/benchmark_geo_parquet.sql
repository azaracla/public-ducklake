-- Benchmark GeoParquet - Ordered vs Unordered
-- Test performance de lecture et pruning sur colonnes géométriques

LOAD spatial;

-- Configuration pour les mesures
PRAGMA disable_progress_bar=true;
PRAGMA temp_directory='/tmp';

-- Fonction pour mesurer une requête
CREATE MACRO measure_query(query, label) AS (
  PRINT '=== ' || label || ' ===';
  PRINT 'Starting measurement...';
  .chrono on
  query;
  .chrono off
);

-- Vérifier le nombre total de lignes
measure_query(
  SELECT COUNT(*) AS total_rows FROM read_parquet('geo-dvf-2021-2025-ordered.parquet'),
  'Total rows (ordered)'
);

measure_query(
  SELECT COUNT(*) AS total_rows FROM read_parquet('geo-dvf-2021-2025.parquet'),
  'Total rows (unordered)'
);

-- TEST 1: Filtre par département (75 = Paris)
measure_query(
  SELECT COUNT(*) AS cnt 
  FROM read_parquet('geo-dvf-2021-2025-ordered.parquet') 
  WHERE code_departement = '75',
  'TEST 1a: Filter code_departement=75 (ordered)'
);

measure_query(
  SELECT COUNT(*) AS cnt 
  FROM read_parquet('geo-dvf-2021-2025.parquet') 
  WHERE code_departement = '75',
  'TEST 1b: Filter code_departement=75 (unordered)'
);

-- TEST 2: Filtre par département + commune (Paris 75056)
measure_query(
  SELECT COUNT(*) AS cnt 
  FROM read_parquet('geo-dvf-2021-2025-ordered.parquet') 
  WHERE code_departement = '75' AND code_commune = '75056',
  'TEST 2a: Filter dept+commune (ordered)'
);

measure_query(
  SELECT COUNT(*) AS cnt 
  FROM read_parquet('geo-dvf-2021-2025.parquet') 
  WHERE code_departement = '75' AND code_commune = '75056',
  'TEST 2b: Filter dept+commune (unordered)'
);

-- TEST 3: Filtre IN sur plusieurs départements (Île-de-France)
measure_query(
  SELECT COUNT(*) AS cnt 
  FROM read_parquet('geo-dvf-2021-2025-ordered.parquet') 
  WHERE code_departement IN ('75', '77', '78', '91', '92', '93', '94', '95'),
  'TEST 3a: Filter IN 8 depts (ordered)'
);

measure_query(
  SELECT COUNT(*) AS cnt 
  FROM read_parquet('geo-dvf-2021-2025.parquet') 
  WHERE code_departement IN ('75', '77', '78', '91', '92', '93', '94', '95'),
  'TEST 3b: Filter IN 8 depts (unordered)'
);

-- TEST 4: Agrégation par département
measure_query(
  SELECT code_departement, COUNT(*) AS cnt, AVG(nombre_lots) AS avg_lots
  FROM read_parquet('geo-dvf-2021-2025-ordered.parquet') 
  GROUP BY code_departement
  ORDER BY cnt DESC,
  'TEST 4a: GROUP BY code_departement (ordered)'
);

measure_query(
  SELECT code_departement, COUNT(*) AS cnt, AVG(nombre_lots) AS avg_lots
  FROM read_parquet('geo-dvf-2021-2025.parquet') 
  GROUP BY code_departement
  ORDER BY cnt DESC,
  'TEST 4b: GROUP BY code_departement (unordered)'
);

-- TEST 5: Requête spatiale - Bounding box de Paris
-- Paris bounding box approximatif: lon 2.25-2.45, lat 48.815-48.90
measure_query(
  SELECT COUNT(*) AS cnt
  FROM read_parquet('geo-dvf-2021-2025-ordered.parquet') 
  WHERE ST_XMin(geom) BETWEEN 2.25 AND 2.45 
    AND ST_YMin(geom) BETWEEN 48.815 AND 48.90,
  'TEST 5a: Spatial bbox Paris (ordered)'
);

measure_query(
  SELECT COUNT(*) AS cnt
  FROM read_parquet('geo-dvf-2021-2025.parquet') 
  WHERE ST_XMin(geom) BETWEEN 2.25 AND 2.45 
    AND ST_YMin(geom) BETWEEN 48.815 AND 48.90,
  'TEST 5b: Spatial bbox Paris (unordered)'
);

-- TEST 6: Combinaison filtre attributaire + spatial
measure_query(
  SELECT COUNT(*) AS cnt
  FROM read_parquet('geo-dvf-2021-2025-ordered.parquet') 
  WHERE code_departement = '75' 
    AND ST_XMin(geom) BETWEEN 2.25 AND 2.45 
    AND ST_YMin(geom) BETWEEN 48.815 AND 48.90,
  'TEST 6a: Combined filter (ordered)'
);

measure_query(
  SELECT COUNT(*) AS cnt
  FROM read_parquet('geo-dvf-2021-2025.parquet') 
  WHERE code_departement = '75' 
    AND ST_XMin(geom) BETWEEN 2.25 AND 2.45 
    AND ST_YMin(geom) BETWEEN 48.815 AND 48.90,
  'TEST 6b: Combined filter (unordered)'
);
