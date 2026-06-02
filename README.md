# Public DuckLake - Data.gouv.fr Datasets

DuckLake frozen référençant les principaux datasets Parquet de data.gouv.fr.

## Utilisation

```bash
duckdb -c "ATTACH 'ducklake\:https://raw.githubusercontent.com/azaracla/public-ducklake/main/data_gouv_catalog.ducklake' AS dg (TYPE ducklake, READ_ONLY true);"
