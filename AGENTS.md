# Repository Guidelines

## Project Structure & Module Organization

The published artifact is `data_gouv_catalog.ducklake`, a DuckLake catalog over remote public Parquet files. Table definitions live in `schemas/<date>/<domain>/`, for example `schemas/v2026-06-05/economie/economie_boamp_siren.sql`. `scripts/generate_ducklake.sql` assembles the active schema versions into the catalog. Keep dataset metadata synchronized in `tracking/datasets.json` and document sources or investigations under `references/`. Utility and conversion scripts belong in `scripts/`; reusable SQL examples belong in `sql/`. CI configuration is in `.github/workflows/ci.yml`.

## Build, Test, and Development Commands

- `uv sync` installs the Python 3.13 dependencies used by conversion scripts.
- `rm -f data_gouv_catalog.ducklake && rm -rf dg_lake/ && duckdb < scripts/generate_ducklake.sql` rebuilds the catalog from scratch. Run only when replacing the generated artifact intentionally.
- `duckdb data_gouv_catalog.ducklake` opens the local catalog for inspection.
- `bash scripts/benchmark.sh` runs the optional GeoParquet benchmark; it requires the ignored local benchmark files.

The build requires DuckDB with network access so it can install the `ducklake` and `httpfs` extensions.

## Coding Style & Naming Conventions

Use four spaces in Python and conventional `snake_case` names. Keep shell scripts POSIX-friendly where practical and quote variables. Format SQL with uppercase keywords, one logical clause per line, and schema-qualified table names. Name schema files `<domain>_<table>.sql`; create new date-based schema directories instead of rewriting historical snapshots. No formatter or linter is currently configured, so match nearby files and keep diffs focused.

## Testing Guidelines

There is no standalone unit-test framework or coverage target. Before submitting schema changes, rebuild the catalog and run focused DuckDB queries that read real columns, not only `COUNT(*)`. CI rebuilds the catalog, lists registered tables, queries remote datasets, checks cross-schema behavior, and validates comments. Add a focused CI query when a change fixes a regression that could recur.

Never enable DuckDB's `force_download=true`; it defeats HTTP range reads and can break remote Parquet access.

## Commit & Pull Request Guidelines

History follows Conventional Commit-style subjects such as `feat:`, `fix:`, `fix(ci):`, `docs:`, and `chore:`. Keep subjects imperative and concise; include the schema date when adding datasets. Pull requests should explain the data source, affected schemas, catalog regeneration, and validation performed. Link relevant issues and note remote-file size or rate-limit risks; screenshots are unnecessary unless documentation rendering changes.
