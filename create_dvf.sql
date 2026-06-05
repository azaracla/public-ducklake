LOAD spatial;
  COPY (
    SELECT
      -- Colonnes originales
      id_mutation,
      date_mutation,
      numero_disposition,
      nature_mutation,
      valeur_fonciere,
      adresse_numero,
      adresse_suffixe,
      adresse_nom_voie,
      adresse_code_voie,
      code_postal,
      code_commune,
      nom_commune,
      code_departement,
      ancien_code_commune,
      ancien_nom_commune,
      id_parcelle,
      ancien_id_parcelle,
      numero_volume,
      lot1_numero,
      lot1_surface_carrez,
      lot2_numero,
      lot2_surface_carrez,
      lot3_numero,
      lot3_surface_carrez,
      lot4_numero,
      lot4_surface_carrez,
      lot5_numero,
      lot5_surface_carrez,
      nombre_lots,
      code_type_local,
      type_local,
      -- surface_reelle_bati: VARCHAR dans le CSV, doit être DOUBLE
      TRY_CAST(surface_reelle_bati AS DOUBLE) AS surface_reelle_bati,
      nombre_pieces_principales,
      code_nature_culture,
      nature_culture,
      code_nature_culture_speciale,
      nature_culture_speciale,
      surface_terrain,
      longitude,
      latitude,
      -- prix/m² pré-calculé (NULL si surface invalide)
      CASE
        WHEN TRY_CAST(surface_reelle_bati AS DOUBLE) > 0
        THEN valeur_fonciere / TRY_CAST(surface_reelle_bati AS DOUBLE)
      END AS prix_m2,
      ST_Point(longitude, latitude) AS geom
    FROM read_csv(
      'https://static.data.gouv.fr/resources/demandes-de-valeurs-foncieres-geolocalisees/20260424-090024/dvf.csv.gz',
      types={
        'lot1_numero': 'VARCHAR', 'lot2_numero': 'VARCHAR',
        'lot3_numero': 'VARCHAR', 'lot4_numero': 'VARCHAR',
        'lot5_numero': 'VARCHAR', 'numero_volume': 'VARCHAR',
        'surface_reelle_bati': 'VARCHAR'
      },
      quote='"'
    )
  ) TO 'geo-dvf-2021-2025.parquet'
  (FORMAT PARQUET, GEOPARQUET_VERSION V2, COMPRESSION ZSTD, COMPRESSION_LEVEL 16);

