-- Sources: Insee, comptes nationaux 2025; AFT, rapport d'activité 2025; Eurostat.
-- Edition: v2026-08-01

CREATE TABLE finances_publiques.apu_annuel (
    annee BIGINT NOT NULL,
    pib_millions DOUBLE NOT NULL,
    dette_maastricht_millions DOUBLE NOT NULL,
    dette_debut_annee_millions DOUBLE NOT NULL,
    deficit_millions DOUBLE NOT NULL,
    interets_millions DOUBLE NOT NULL,
    dette_etat_millions DOUBLE,
    dette_odac_millions DOUBLE,
    dette_apul_millions DOUBLE,
    dette_asso_millions DOUBLE,
    dette_pct_pib_publie DOUBLE NOT NULL,
    deficit_pct_pib_publie DOUBLE NOT NULL,
    taux_10_ans_moyen_pct DOUBLE NOT NULL,
    taux_nouvelles_emissions_pct DOUBLE,
    dette_negociable_etat_millions BIGINT,
    duree_vie_moyenne_ans BIGINT,
    duree_vie_moyenne_jours BIGINT,
    date_publication DATE NOT NULL,
    date_recuperation DATE NOT NULL,
    statut VARCHAR NOT NULL
);

COMMENT ON TABLE finances_publiques.apu_annuel IS 'Série annuelle 2019-2025 des administrations publiques; les détails de l’État et de l’AFT sont disponibles pour 2025.';
COMMENT ON COLUMN finances_publiques.apu_annuel.dette_maastricht_millions IS 'Dette brute consolidée de toutes les administrations publiques, en millions d’euros.';
COMMENT ON COLUMN finances_publiques.apu_annuel.interets_millions IS 'Charges d’intérêts des administrations publiques, en millions d’euros; le point 2025 reprend la publication Insee hors correction SIFIM.';
COMMENT ON COLUMN finances_publiques.apu_annuel.taux_nouvelles_emissions_pct IS 'Taux moyen pondéré des émissions AFT à moyen et long terme; ce n’est pas le coupon moyen du stock.';

CALL ducklake_add_data_files(
    'dg',
    'apu_annuel',
    'https://raw.githubusercontent.com/azaracla/public-ducklake/main/data/finances_publiques/v2026-08-01/apu_annuel.parquet',
    schema => 'finances_publiques',
    allow_missing => true
);
