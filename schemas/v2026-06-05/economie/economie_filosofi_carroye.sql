-- Schema: economie
-- Table: filosofi_carroye
-- Dataset: Revenus, pauvreté et niveau de vie - Données carroyées 2019 et 2021 (Filosofi)
-- Source: https://www.data.gouv.fr/datasets/revenus-pauvrete-et-niveau-de-vie-donnees-carroyees-2019-et-2021-dispositif-fichier-localise-social-et-fiscal-filosofi/
-- INSEE Filosofi carroyé 200m — ménages, revenus, pauvreté, âges par carreau
-- GeoParquet v1 (geometry stored as WKB BLOB, EPSG:3035 LAEA Europe)
-- Note: 2019 and 2021 files have different schemas — table is the union of both
-- Last updated: 2026-06-05

CREATE TABLE economie.filosofi_carroye (
  idcar_200m VARCHAR NULL
,
  idcar_1km VARCHAR NULL
,
  idcar_nat VARCHAR NULL
,
  i_est_200 INTEGER NULL
,
  i_est_1km INTEGER NULL
,
  lcog_geo VARCHAR NULL
,
  ind DOUBLE NULL
,
  men DOUBLE NULL
,
  men_pauv DOUBLE NULL
,
  men_1ind DOUBLE NULL
,
  men_5ind DOUBLE NULL
,
  men_prop DOUBLE NULL
,
  men_fmp DOUBLE NULL
,
  ind_snv DOUBLE NULL
,
  men_surf DOUBLE NULL
,
  men_coll DOUBLE NULL
,
  men_mais DOUBLE NULL
,
  log_av45 DOUBLE NULL
,
  log_45_70 DOUBLE NULL
,
  log_70_90 DOUBLE NULL
,
  log_ap90 DOUBLE NULL
,
  log_inc DOUBLE NULL
,
  log_soc DOUBLE NULL
,
  ind_0_3 DOUBLE NULL
,
  ind_4_5 DOUBLE NULL
,
  ind_6_10 DOUBLE NULL
,
  ind_11_17 DOUBLE NULL
,
  ind_18_24 DOUBLE NULL
,
  ind_25_39 DOUBLE NULL
,
  ind_40_54 DOUBLE NULL
,
  ind_55_64 DOUBLE NULL
,
  ind_65_79 DOUBLE NULL
,
  ind_80p DOUBLE NULL
,
  ind_inc DOUBLE NULL
,
  bbox STRUCT(xmin DOUBLE, ymin DOUBLE, xmax DOUBLE, ymax DOUBLE) NULL
,
  geometry BLOB NULL
,
  __index_level_0__ BIGINT NULL
);

COMMENT ON TABLE economie.filosofi_carroye IS 'Revenus, pauvreté et niveau de vie carroyé 200m (Filosofi INSEE). 2.3M carreaux de 200m de côté, projection EPSG:3035 (LAEA Europe). 2 années : 2019 et 2021. Indicateurs : nombre d''individus, ménages, ménages pauvres, revenu, tranches d''âge, logements. Source: data.gouv.fr dataset 66fd2924ca43b044d55a7b74';

COMMENT ON COLUMN economie.filosofi_carroye.idcar_200m IS 'Identifiant unique du carreau de 200m (format INSEE)';
COMMENT ON COLUMN economie.filosofi_carroye.idcar_1km IS 'Identifiant du carreau de 1km parent (2019 seulement)';
COMMENT ON COLUMN economie.filosofi_carroye.idcar_nat IS 'Identifiant national du carreau (2019 seulement)';
COMMENT ON COLUMN economie.filosofi_carroye.i_est_200 IS 'Indicateur estimation 200m (2019 seulement)';
COMMENT ON COLUMN economie.filosofi_carroye.i_est_1km IS 'Indicateur estimation 1km (2019 seulement)';
COMMENT ON COLUMN economie.filosofi_carroye.lcog_geo IS 'Code géographique COG (2019 seulement)';
COMMENT ON COLUMN economie.filosofi_carroye.ind IS 'Nombre d''individus dans le carreau';
COMMENT ON COLUMN economie.filosofi_carroye.men IS 'Nombre de ménages dans le carreau';
COMMENT ON COLUMN economie.filosofi_carroye.men_pauv IS 'Nombre de ménages pauvres (sous le seuil de 60% du revenu médian)';
COMMENT ON COLUMN economie.filosofi_carroye.men_1ind IS 'Nombre de ménages d''une personne';
COMMENT ON COLUMN economie.filosofi_carroye.men_5ind IS 'Nombre de ménages de 5 personnes ou plus';
COMMENT ON COLUMN economie.filosofi_carroye.men_prop IS 'Nombre de ménages propriétaires';
COMMENT ON COLUMN economie.filosofi_carroye.men_fmp IS 'Nombre de ménages à faibles revenus (1er décile)';
COMMENT ON COLUMN economie.filosofi_carroye.ind_snv IS 'Individus sans niveau de vie (hors champ fiscal)';
COMMENT ON COLUMN economie.filosofi_carroye.men_surf IS 'Ménages en situation de surpeuplement';
COMMENT ON COLUMN economie.filosofi_carroye.men_coll IS 'Ménages en logement collectif';
COMMENT ON COLUMN economie.filosofi_carroye.men_mais IS 'Ménages en maison individuelle';
COMMENT ON COLUMN economie.filosofi_carroye.log_av45 IS 'Logements construits avant 1945';
COMMENT ON COLUMN economie.filosofi_carroye.log_45_70 IS 'Logements construits entre 1945 et 1970';
COMMENT ON COLUMN economie.filosofi_carroye.log_70_90 IS 'Logements construits entre 1970 et 1990';
COMMENT ON COLUMN economie.filosofi_carroye.log_ap90 IS 'Logements construits après 1990';
COMMENT ON COLUMN economie.filosofi_carroye.log_inc IS 'Logements de l''INSEE (hors logements ordinaires)';
COMMENT ON COLUMN economie.filosofi_carroye.log_soc IS 'Logements sociaux';
COMMENT ON COLUMN economie.filosofi_carroye.ind_0_3 IS 'Individus de 0 à 3 ans';
COMMENT ON COLUMN economie.filosofi_carroye.ind_4_5 IS 'Individus de 4 à 5 ans';
COMMENT ON COLUMN economie.filosofi_carroye.ind_6_10 IS 'Individus de 6 à 10 ans';
COMMENT ON COLUMN economie.filosofi_carroye.ind_11_17 IS 'Individus de 11 à 17 ans';
COMMENT ON COLUMN economie.filosofi_carroye.ind_18_24 IS 'Individus de 18 à 24 ans';
COMMENT ON COLUMN economie.filosofi_carroye.ind_25_39 IS 'Individus de 25 à 39 ans';
COMMENT ON COLUMN economie.filosofi_carroye.ind_40_54 IS 'Individus de 40 à 54 ans';
COMMENT ON COLUMN economie.filosofi_carroye.ind_55_64 IS 'Individus de 55 à 64 ans';
COMMENT ON COLUMN economie.filosofi_carroye.ind_65_79 IS 'Individus de 65 à 79 ans';
COMMENT ON COLUMN economie.filosofi_carroye.ind_80p IS 'Individus de 80 ans ou plus';
COMMENT ON COLUMN economie.filosofi_carroye.ind_inc IS 'Individus de l''INSEE (hors ménages ordinaires)';
COMMENT ON COLUMN economie.filosofi_carroye.bbox IS 'Bounding box du carreau (xmin, ymin, xmax, ymax) en EPSG:3035 (2021 seulement)';
COMMENT ON COLUMN economie.filosofi_carroye.geometry IS 'Géométrie du carreau (polygone) en WKB BLOB, EPSG:3035 — convertir avec ST_GeomFromWKB(geometry) via extension spatial DuckDB';
COMMENT ON COLUMN economie.filosofi_carroye.__index_level_0__ IS 'Index pandas artefact (2019 seulement)';

CALL ducklake_add_data_files('dg', 'filosofi_carroye',
    'https://static.data.gouv.fr/resources/revenus-pauvrete-et-niveau-de-vie-donnees-carroyees-dispositif-fichier-localise-social-et-fiscal-filosofi/20260309-120901/carreaux-200m-met-3035-2021.parquet',
    schema => 'economie', allow_missing => true);

CALL ducklake_add_data_files('dg', 'filosofi_carroye',
    'https://static.data.gouv.fr/resources/revenus-pauvrete-et-niveau-de-vie-en-2019-donnees-carroyees-dispositif-fichier-localise-social-et-fiscal-filosofi/20241002-110718/carreaux-200m-met-3035.parquet',
    schema => 'economie', allow_missing => true);
