-- Source: Agence France Trésor, encours détaillés des OAT, OATi et OAT€i.
-- Edition: v2026-08-01

CREATE TABLE finances_publiques.oat (
    isin VARCHAR NOT NULL,
    libelle VARCHAR NOT NULL,
    coupon_pct DOUBLE NOT NULL,
    echeance DATE NOT NULL,
    encours_euros BIGINT NOT NULL,
    indexation VARCHAR NOT NULL,
    verte BOOLEAN NOT NULL,
    date_extraction DATE NOT NULL,
    statut VARCHAR NOT NULL
);

COMMENT ON TABLE finances_publiques.oat IS 'Encours détaillé des obligations assimilables du Trésor au millésime d’extraction.';
COMMENT ON COLUMN finances_publiques.oat.coupon_pct IS 'Coupon facial du titre; il ne mesure pas le coût réel de la dette.';
COMMENT ON COLUMN finances_publiques.oat.indexation IS 'nominale, inflation_france ou inflation_zone_euro.';

CALL ducklake_add_data_files(
    'dg',
    'oat',
    'https://raw.githubusercontent.com/azaracla/public-ducklake/main/data/finances_publiques/v2026-08-01/oat.parquet',
    schema => 'finances_publiques',
    allow_missing => true
);
