-- Source: Insee, dette des administrations publiques au sens de Maastricht.
-- Edition: v2026-08-01

CREATE TABLE finances_publiques.dette_trimestrielle (
    trimestre VARCHAR NOT NULL,
    dette_millions DOUBLE NOT NULL,
    ratio_pib DOUBLE NOT NULL,
    statut VARCHAR NOT NULL
);

COMMENT ON TABLE finances_publiques.dette_trimestrielle IS 'Dette Maastricht trimestrielle depuis 1995; les ratios en cours d’année utilisent un PIB glissant.';
COMMENT ON COLUMN finances_publiques.dette_trimestrielle.ratio_pib IS 'Dette en pourcentage du PIB; approximation sur quatre trimestres glissants hors quatrième trimestre.';

CALL ducklake_add_data_files(
    'dg',
    'dette_trimestrielle',
    'https://raw.githubusercontent.com/azaracla/public-ducklake/main/data/finances_publiques/v2026-08-01/dette_trimestrielle.parquet',
    schema => 'finances_publiques',
    allow_missing => true
);
