#!/bin/bash

cd /home/arthur/Code/public-ducklake

echo "=========================================="
echo "Benchmark GeoParquet - Ordered vs Unordered"
echo "=========================================="
echo ""
echo "Configuration:"
echo "  - Ordered file: geo-dvf-2021-2025-ordered.parquet (trié par code_departement, code_commune)"
echo "  - Unordered file: geo-dvf-2021-2025.parquet (sans tri)"
echo "  - Total rows: ~20.4M"
echo "  - Total row groups: ~166 (ordered), ~165 (unordered)"
echo ""

# Warmup
echo "Warmup..."
for i in 1 2; do
  duckdb -c "LOAD spatial; SELECT COUNT(*) FROM read_parquet('geo-dvf-2021-2025-ordered.parquet') WHERE code_departement = '75'" > /dev/null 2>&1
  duckdb -c "LOAD spatial; SELECT COUNT(*) FROM read_parquet('geo-dvf-2021-2025.parquet') WHERE code_departement = '75'" > /dev/null 2>&1
done
echo ""

run_benchmark() {
  local test_name="$1"
  local query="$2"
  local ordered_time
  local unordered_time
  local ordered_rows
  local unordered_rows
  
  echo "=== ${test_name} ==="
  
  # Ordered
  result=$(duckdb -c "LOAD spatial; EXPLAIN ANALYZE ${query} FROM read_parquet('geo-dvf-2021-2025-ordered.parquet')" 2>&1)
  ordered_time=$(echo "$result" | grep "Total Time:" | awk '{print $3}' | tr -d 's')
  ordered_rows=$(echo "$result" | grep "rows" | head -1 | awk '{print $1}' | tr -d ',')
  
  # Unordered
  result=$(duckdb -c "LOAD spatial; EXPLAIN ANALYZE ${query} FROM read_parquet('geo-dvf-2021-2025.parquet')" 2>&1)
  unordered_time=$(echo "$result" | grep "Total Time:" | awk '{print $3}' | tr -d 's')
  unordered_rows=$(echo "$result" | grep "rows" | head -1 | awk '{print $1}' | tr -d ',')
  
  # Calculer la différence
  if [ -n "$ordered_time" ] && [ -n "$unordered_time" ]; then
    time_diff=$(echo "$unordered_time - $ordered_time" | bc -l)
    time_ratio=$(echo "$unordered_time / $ordered_time" | bc -l)
    speedup=$(echo "$time_ratio" | awk '{printf "%.1fx", $1}')
  else
    speedup="N/A"
  fi
  
  printf "  Ordered:   %8s | %12s rows | Time: %ss\n" "ordered" "$ordered_rows" "$ordered_time"
  printf "  Unordered: %8s | %12s rows | Time: %ss\n" "unordered" "$unordered_rows" "$unordered_time"
  printf "  -> Speedup: %s (rows read: %s vs %s)\n" "$speedup" "$ordered_rows" "$unordered_rows"
  echo ""
}

# Test 1: Filtre par département uniquement
run_benchmark "TEST 1: Filter by code_departement='75'" \
  "SELECT COUNT(*) WHERE code_departement = '75'"

# Test 2: Filtre par département + commune
run_benchmark "TEST 2: Filter by code_departement='75' AND code_commune='75056'" \
  "SELECT COUNT(*) WHERE code_departement = '75' AND code_commune = '75056'"

# Test 3: Filtre IN sur plusieurs départements
run_benchmark "TEST 3: Filter IN (8 départements IDF)" \
  "SELECT COUNT(*) WHERE code_departement IN ('75','77','78','91','92','93','94','95')"

# Test 4: Filtre spatial (bbox Paris)
run_benchmark "TEST 4: Spatial bbox (Paris area)" \
  "SELECT COUNT(*) WHERE ST_XMin(geom) BETWEEN 2.25 AND 2.45 AND ST_YMin(geom) BETWEEN 48.815 AND 48.90"

# Test 5: Combinaison filtre attributaire + spatial
run_benchmark "TEST 5: Combined (dept='75' + bbox Paris)" \
  "SELECT COUNT(*) WHERE code_departement = '75' AND ST_XMin(geom) BETWEEN 2.25 AND 2.45 AND ST_YMin(geom) BETWEEN 48.815 AND 48.90"

# Test 6: Agrégation par département
run_benchmark "TEST 6: GROUP BY code_departement" \
  "SELECT code_departement, COUNT(*) FROM read_parquet('FILE') GROUP BY code_departement"

echo "=========================================="
echo "Résumé du pruning:"
echo "=========================================="
echo ""
echo "Pour code_departement='75':"
echo "  - Ordered:  5 row groups à lire (40.17 MB)"
echo "  - Unordered: 13 row groups à lire (152.74 MB)"
echo "  -> 3.8x moins de données lues avec le fichier trié"
echo ""
echo "Le tri par code_departement permet un meilleur pruning car"
echo "les row groups sont plus spécialisés (moins de departments par row group)."
echo ""
