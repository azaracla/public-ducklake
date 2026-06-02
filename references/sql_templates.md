# SQL Templates

## Basic Table Template

```sql
-- Schema: <category>
-- Table: <table_name>
-- Source: <parquet_url>
-- Last updated: <date>

CREATE SCHEMA IF NOT EXISTS <category>;

CREATE TABLE <category>.<table_name> (
  <column1> <type1> NULL,
  <column2> <type2> NULL,
  ...
);

COMMENT ON TABLE <category>.<table_name> IS '<description>';

CALL ducklake_add_data_files('dg', '<table_name>',
    '<parquet_url>',
    schema => '<category>');
```

## Type Mapping

| DuckDB Type | SQL Type |
|-------------|----------|
| VARCHAR | VARCHAR |
| BIGINT | BIGINT |
| INTEGER | INTEGER |
| BOOLEAN | BOOLEAN |
| DATE | DATE |
| TIMESTAMP | TIMESTAMP |
| TIMESTAMP_NS | TIMESTAMP |
| DOUBLE | DOUBLE |
| FLOAT | FLOAT |
| VARCHAR[] | LIST(VARCHAR) |
| MAP | MAP |
