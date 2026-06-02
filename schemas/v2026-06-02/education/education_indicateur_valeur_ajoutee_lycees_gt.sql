-- Metadonnées
-- Schema: education
-- Table: indicateur_valeur_ajoutee_lycees_gt
-- Source: https://data.education.gouv.fr/api/explore/v2.1/catalog/datasets/fr-en-indicateurs-de-resultat-des-lycees-gt_v2/exports/parquet
-- Last updated: 2026-06-02

-- Créer le schema si besoin
CREATE SCHEMA IF NOT EXISTS education;

-- Créer la table avec les types EXACTS du parquet_schema
CREATE TABLE education.indicateur_valeur_ajoutee_lycees_gt (
  annee DATE NULL
  uai VARCHAR NULL
  libelle_uai VARCHAR NULL
  secteur VARCHAR NULL
  code_commune VARCHAR NULL
  libelle_commune VARCHAR NULL
  code_departement VARCHAR NULL
  libelle_departement VARCHAR NULL
  libelle_academie VARCHAR NULL
  code_region VARCHAR NULL
  libelle_region VARCHAR NULL
  presents_total BIGINT NULL
  taux_reu_total DOUBLE NULL
  va_reu_total DOUBLE NULL
  taux_acces_2nde DOUBLE NULL
  va_acces_2nde DOUBLE NULL
  taux_men_total DOUBLE NULL
  va_men_total DOUBLE NULL
  presents_l BIGINT NULL
  presents_es BIGINT NULL
  presents_s BIGINT NULL
  presents_gnle BIGINT NULL
  presents_sti2d BIGINT NULL
  presents_std2a BIGINT NULL
  presents_stmg BIGINT NULL
  presents_stl BIGINT NULL
  presents_st2s BIGINT NULL
  presents_s2tmd BIGINT NULL
  presents_sthr BIGINT NULL
  taux_reu_l VARCHAR NULL
  taux_reu_es VARCHAR NULL
  taux_reu_s VARCHAR NULL
  taux_reu_gnle VARCHAR NULL
  taux_reu_sti2d VARCHAR NULL
  taux_reu_std2a VARCHAR NULL
  taux_reu_stmg VARCHAR NULL
  taux_reu_stl VARCHAR NULL
  taux_reu_st2s VARCHAR NULL
  taux_reu_s2tmd VARCHAR NULL
  taux_reu_sthr VARCHAR NULL
  va_reu_l VARCHAR NULL
  va_reu_es VARCHAR NULL
  va_reu_s VARCHAR NULL
  va_reu_gnle VARCHAR NULL
  va_reu_sti2d VARCHAR NULL
  va_reu_std2a VARCHAR NULL
  va_reu_stmg VARCHAR NULL
  va_reu_stl VARCHAR NULL
  va_reu_st2s VARCHAR NULL
  va_reu_s2tmd VARCHAR NULL
  va_reu_sthr VARCHAR NULL
  eff_2nde BIGINT NULL
  eff_1ere BIGINT NULL
  eff_term BIGINT NULL
  taux_acces_1ere VARCHAR NULL
  taux_acces_term VARCHAR NULL
  va_acces_1ere VARCHAR NULL
  va_acces_term VARCHAR NULL
  taux_men_l VARCHAR NULL
  taux_men_es VARCHAR NULL
  taux_men_s VARCHAR NULL
  taux_men_gnle VARCHAR NULL
  taux_men_sti2d VARCHAR NULL
  taux_men_std2a VARCHAR NULL
  taux_men_stmg VARCHAR NULL
  taux_men_stl VARCHAR NULL
  taux_men_st2s VARCHAR NULL
  taux_men_s2tmd VARCHAR NULL
  taux_men_sthr VARCHAR NULL
  va_men_l VARCHAR NULL
  va_men_es VARCHAR NULL
  va_men_s VARCHAR NULL
  va_men_gnle VARCHAR NULL
  va_men_sti2d VARCHAR NULL
  va_men_std2a VARCHAR NULL
  va_men_stmg VARCHAR NULL
  va_men_stl VARCHAR NULL
  va_men_st2s VARCHAR NULL
  va_men_s2tmd VARCHAR NULL
  va_men_sthr VARCHAR NULL
  nb_mentions_tb_avecf_g BIGINT NULL
  nb_mentions_tb_sansf_g BIGINT NULL
  nb_mentions_b_g BIGINT NULL
  nb_mentions_ab_g BIGINT NULL
  nb_mentions_tb_avecf_t BIGINT NULL
  nb_mentions_tb_sansf_t BIGINT NULL
  nb_mentions_b_t BIGINT NULL
  nb_mentions_ab_t BIGINT NULL
);

-- Commenter la table
COMMENT ON TABLE education.indicateur_valeur_ajoutee_lycees_gt 
IS 'Les indicateurs de valeur ajoutee des lycees sont une batterie d''indicateurs qui visent a evaluer l''action propre de chaque lycee pour faire reussir les eleves qu''il accueille, en terme de reussite au baccalaureat et d''accompagnement tout au long de sa scolarite au lycee. Les IVAL permettent un diagnostic qui va au-dela des seuls taux de reussite bruts a l''examen.';

-- Attacher le fichier Parquet (NE PAS COPIER les donnees)
CALL ducklake_add_data_files('dg', 'indicateur_valeur_ajoutee_lycees_gt',
    'https://data.education.gouv.fr/api/explore/v2.1/catalog/datasets/fr-en-indicateurs-de-resultat-des-lycees-gt_v2/exports/parquet',
    schema => 'education');
