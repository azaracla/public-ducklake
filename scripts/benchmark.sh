#!/bin/bash

cd /home/arthur/Code/public-ducklake

# Warmup
for i in 1 2; do
  echo "Warmup $i..."
  duckdb -c "LOAD spatial; SELECT COUNT(*) FROM read_parquet('geo-dvf-2021-2025-ordered.parquet') WHERE code_departement = '75'" > /dev/null 2>&1
  duckdb -c "LOAD spatial; SELECT COUNT(*) FROM read_parquet('geo-dvf-2021-2025.parquet') WHERE code_departement = '75'" > /dev/null 2>&1
done

echo "=========================================="
echo "Benchmark GeoParquet Performance"
echo "=========================================="
echo ""

run_test() {
  local query="$1"
  local label="$2"
  local file="$3"
  
  # Remplacer le nom du fichier dans la requête
  query="${query//FILE/${file}}"
  
  # Mesurer le temps
  time_val=$( { time -p duckdb -c "LOAD spatial; ${query}" > /tmp/benchmark_result.txt 2>&1; } 2>&1 | grep real | awk '{print $2}' )
  result=$(cat /tmp/benchmark_result.txt | tail -3 | head -1)
  
  echo "${label} (${file}): ${time_val}s | Result: ${result}"
}

# Test 1: Filtre par département
run_test "SELECT COUNT(*) FROM read_parquet('FILE') WHERE code_departement = '75'" \
  "TEST 1 - code_departement=75" \
  "geo-dvf-2021-2025-ordered.parquet"

run_test "SELECT COUNT(*) FROM read_parquet('FILE') WHERE code_departement = '75'" \
  "TEST 1 - code_departement=75" \
  "geo-dvf-2021-2025.parquet"

echo ""

# Test 2: Filtre par département + commune
run_test "SELECT COUNT(*) FROM read_parquet('FILE') WHERE code_departement = '75' AND code_commune = '75056'" \
  "TEST 2 - dept+commune (Paris 75056)" \
  "geo-dvf-2021-2025-ordered.parquet"

run_test "SELECT COUNT(*) FROM read_parquet('FILE') WHERE code_departement = '75' AND code_commune = '75056'" \
  "TEST 2 - dept+commune (Paris 75056)" \
  "geo-dvf-2021-2025.parquet"

echo ""

# Test 3: Filtre IN sur 8 départements (Île-de-France)
run_test "SELECT COUNT(*) FROM read_parquet('FILE') WHERE code_departement IN ('75','77','78','91','92','93','94','95')" \
  "TEST 3 - IN 8 départements (IDF)" \
  "geo-dvf-2021-2025-ordered.parquet"

run_test "SELECT COUNT(*) FROM read_parquet('FILE') WHERE code_departement IN ('75','77','78','91','92','93','94','95')" \
  "TEST 3 - IN 8 départements (IDF)" \
  "geo-dvf-2021-2025.parquet"

echo ""

# Test 4: Agrégation par département
run_test "SELECT code_departement, COUNT(*) AS cnt FROM read_parquet('FILE') GROUP BY code_departement ORDER BY cnt DESC LIMIT 5" \
  "TEST 4 - GROUP BY code_departement" \
  "geo-dvf-2021-2025-ordered.parquet"

run_test "SELECT code_departement, COUNT(*) AS cnt FROM read_parquet('FILE') GROUP BY code_departement ORDER BY cnt DESC LIMIT 5" \
  "TEST 4 - GROUP BY code_departement" \
  "geo-dvf-2021-2025.parquet"

echo ""

# Test 5: Requête spatiale (bbox Paris)
run_test "SELECT COUNT(*) FROM read_parquet('FILE') WHERE ST_XMin(geom) BETWEEN 2.25 AND 2.45 AND ST_YMin(geom) BETWEEN 48.815 AND 48.90" \
  "TEST 5 - Spatial bbox (Paris)" \
  "geo-dvf-2021-2025-ordered.parquet"

run_test "SELECT COUNT(*) FROM read_parquet('FILE') WHERE ST_XMin(geom) BETWEEN 2.25 AND 2.45 AND ST_YMin(geom) BETWEEN 48.815 AND 48.90" \
  "TEST 5 - Spatial bbox (Paris)" \
  "geo-dvf-2021-2025.parquet"

echo ""

# Test 6: Combinaison filtre attributaire + spatial
run_test "SELECT COUNT(*) FROM read_parquet('FILE') WHERE code_departement = '75' AND ST_XMin(geom) BETWEEN 2.25 AND 2.45 AND ST_YMin(geom) BETWEEN 48.815 AND 48.90" \
  "TEST 6 - Combined (dept + bbox)" \
  "geo-dvf-2021-2025-ordered.parquet"

run_test "SELECT COUNT(*) FROM read_parquet('FILE') WHERE code_departement = '75' AND ST_XMin(geom) BETWEEN 2.25 AND 2.45 AND ST_YMin(geom) BETWEEN 48.815 AND 48.90" \
  "TEST 6 - Combined (dept + bbox)" \
  "geo-dvf-2021-2025.parquet"

echo ""
echo "=========================================="
echo "Benchmark Complete"
echo "=========================================="
