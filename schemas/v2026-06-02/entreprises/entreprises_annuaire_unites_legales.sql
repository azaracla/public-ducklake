-- Schema: entreprises
-- Table: annuaire_unites_legales
-- Source: https://static.data.gouv.fr/resources/donnees-des-entreprises-utilisees-dans-lannuaire-des-entreprises/20260602-160727/unites-legales-2026-06-02.parquet
-- Last updated: 2026-06-02

CREATE SCHEMA IF NOT EXISTS entreprises;

CREATE TABLE entreprises.annuaire_unites_legales (
  siren VARCHAR NULL,
  siret_siege VARCHAR NULL,
  etat_administratif VARCHAR NULL,
  statut_diffusion VARCHAR NULL,
  nombre_etablissements BIGINT NULL,
  nombre_etablissements_ouverts BIGINT NULL,
  nom_complet VARCHAR NULL,
  nature_juridique VARCHAR NULL,
  colter_code VARCHAR NULL,
  colter_code_insee VARCHAR NULL,
  colter_elus VARCHAR NULL,
  colter_niveau VARCHAR NULL,
  date_mise_a_jour_insee TIMESTAMP NULL,
  date_mise_a_jour_rne TIMESTAMP NULL,
  egapro_renseignee BOOLEAN NULL,
  est_achats_responsables BOOLEAN NULL,
  est_alim_confiance BOOLEAN NULL,
  est_association BOOLEAN NULL,
  est_entrepreneur_individuel BOOLEAN NULL,
  est_entrepreneur_spectacle BOOLEAN NULL,
  est_patrimoine_vivant BOOLEAN NULL,
  statut_entrepreneur_spectacle VARCHAR NULL,
  est_ess BOOLEAN NULL,
  est_organisme_formation BOOLEAN NULL,
  est_qualiopi BOOLEAN NULL,
  est_administration BOOLEAN NULL,
  est_societe_mission VARCHAR NULL,
  liste_elus LIST(VARCHAR) NULL,
  liste_id_organisme_formation LIST(VARCHAR) NULL,
  liste_idcc LIST(VARCHAR) NULL,
  est_siae BOOLEAN NULL,
  type_siae VARCHAR NULL,
  liste_finess_juridique LIST(VARCHAR) NULL,
  a_aide_ademe BOOLEAN NULL,
  est_avocat BOOLEAN NULL
);

COMMENT ON TABLE entreprises.annuaire_unites_legales IS 'Unités légales des entreprises (Annuaire des Entreprises)';

CALL ducklake_add_data_files('dg', 'annuaire_unites_legales',
    'https://static.data.gouv.fr/resources/donnees-des-entreprises-utilisees-dans-lannuaire-des-entreprises/20260602-160727/unites-legales-2026-06-02.parquet',
    schema => 'entreprises');
