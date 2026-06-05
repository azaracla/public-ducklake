#!/usr/bin/env bash
# Download all DECP yearly JSON files and convert to Parquet.
#
# Usage:
#   bash scripts/download_decp.sh            # download all
#   bash scripts/download_decp.sh --years 2025,2026  # specific years
#
# Output: parquet/decp-YYYY.parquet  (one file per year)
#
# Upload the Parquet files as community resources at:
#   https://www.data.gouv.fr/admin/community-resources/new?dataset_id=5cd57bf68b4c4179299eb0e9

set -euo pipefail

YEARS="${1:---years 2019,2022,2024,2025,2026}"
OUTDIR="parquet"

# Parse --years flag
if [[ "$YEARS" == --years* ]]; then
    YEARS=$(echo "$YEARS" | cut -d' ' -f2)
else
    YEARS="2019,2022,2024,2025,2026"
fi

mkdir -p "$OUTDIR" .tmp/decp_download

echo "=== Downloading DECP JSON files ==="
IFS=',' read -ra YEAR_ARRAY <<< "$YEARS"
for YEAR in "${YEAR_ARRAY[@]}"; do
    echo ""
    echo "--- Year $YEAR ---"

    # Find the right resource filename
    # The resource URLs follow a pattern: decp-YYYY.json
    # We get them from the dataset resources list

    # Actually, let's use the known URL pattern from the dataset exploration:
    # These are the "cumulative yearly" files
    JSON_FILE=".tmp/decp_download/decp-${YEAR}.json"

    # We need to find the actual resource URL from the dataset
    # For now, use the data.gouv.fr API
    if [ ! -f "$JSON_FILE" ]; then
        echo "Fetching resource list for year $YEAR..."
        # Get resource list and find the yearly JSON for this year
        python3 -c "
import json, urllib.request, sys

url = 'https://www.data.gouv.fr/api/1/datasets/5cd57bf68b4c4179299eb0e9/'
data = json.load(urllib.request.urlopen(url))

year = '$YEAR'
found = False
for r in data.get('resources', []):
    title = r.get('title', '')
    url_r = r.get('url', '')
    # Match yearly cumulative file (not monthly)
    if f'decp-{year}.json' in title.lower() or f'decp-{year}.json' in url_r:
        print(f'Found: {title} ({r[\"format\"]})', file=sys.stderr)
        print(url_r)
        found = True
        break

if not found:
    print(f'WARNING: no yearly file found for {year}', file=sys.stderr)
    sys.exit(1)
" > .tmp/decp_download/decp-${YEAR}.url

        URL=$(cat .tmp/decp_download/decp-${YEAR}.url)
        echo "Downloading $URL ..."
        curl -L -o "$JSON_FILE" "$URL"
        echo "  → $(du -h "$JSON_FILE" | cut -f1)"
    else
        echo "  Already downloaded ($(du -h "$JSON_FILE" | cut -f1))"
    fi
done

echo ""
echo "=== Converting to Parquet ==="
for YEAR in "${YEAR_ARRAY[@]}"; do
    JSON_FILE=".tmp/decp_download/decp-${YEAR}.json"
    PARQUET_FILE="${OUTDIR}/decp-${YEAR}.parquet"

    if [ -f "$JSON_FILE" ]; then
        if [ ! -f "$PARQUET_FILE" ] || [ "$JSON_FILE" -nt "$PARQUET_FILE" ]; then
            python3 scripts/convert_decp_to_parquet.py "$JSON_FILE" -o "$OUTDIR/"
        else
            echo "decp-${YEAR}.parquet: up to date ($(du -h "$PARQUET_FILE" | cut -f1))"
        fi
    else
        echo "SKIP $YEAR: JSON not downloaded"
    fi
done

echo ""
echo "=== Done ==="
ls -lh "$OUTDIR"/decp-*.parquet 2>/dev/null || echo "No Parquet files found"
echo ""
echo "Upload these .parquet files at:"
echo "  https://www.data.gouv.fr/admin/community-resources/new?dataset_id=5cd57bf68b4c4179299eb0e9"
