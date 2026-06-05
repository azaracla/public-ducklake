-- Schema: economie
-- Table: insee_olap
-- Dataset: Recensement de la population communal et Filosofi depuis 2015 - France métropolitaine
-- Source: https://www.data.gouv.fr/datasets/recensement-de-la-population-communal-et-filosofi-depuis-2015-france-metropolitaine/
-- Cube OLAP: 571 indicateurs (recensement + Filosofi) × 35 401 communes × années 2015–2021
-- Format Entity-Attribute-Value (clef_json = indicateur, valeur = valeur)
-- 124M rows, 1.7 GB
-- Last updated: 2026-06-05

CREATE TABLE economie.insee_olap (
  code_com VARCHAR NULL
,
  nom_commune VARCHAR NULL
,
  annee INTEGER NULL
,
  source VARCHAR NULL
,
  clef_json VARCHAR NULL
,
  valeur FLOAT NULL
);

COMMENT ON TABLE economie.insee_olap IS 'Cube OLAP commune × année × indicateur : recensement de la population et Filosofi depuis 2015. 571 indicateurs pour 35 401 communes de France métropolitaine sur 2015–2021. Format EAV (Entity-Attribute-Value) : clef_json = nom de l''indicateur, valeur = valeur numérique. Source: data.gouv.fr dataset 67289477639527408ae687da';

COMMENT ON COLUMN economie.insee_olap.code_com IS 'Code commune INSEE (5 caractères)';
COMMENT ON COLUMN economie.insee_olap.nom_commune IS 'Nom de la commune';
COMMENT ON COLUMN economie.insee_olap.annee IS 'Année de référence (2015–2021)';
COMMENT ON COLUMN economie.insee_olap.source IS 'Source de la donnée : Recensement ou Filosofi';
COMMENT ON COLUMN economie.insee_olap.clef_json IS 'Clé de l''indicateur (ex: pop, pop_h, pop_f, men_pauv, med_rev, ...) — 571 indicateurs distincts';
COMMENT ON COLUMN economie.insee_olap.valeur IS 'Valeur de l''indicateur (numérique, peut être NULL si secret statistique)';

CALL ducklake_add_data_files('dg', 'insee_olap',
    'https://static.data.gouv.fr/resources/recensement-de-la-population-communal-et-filosofi-depuis-2015-france-metropolitaine/20241104-093439/donnees-insee-olap.parquet',
    schema => 'economie');
