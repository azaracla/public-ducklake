-- Schema: entreprises
-- Table: beaamp_2025
-- Dataset: Base Étendue, Améliorée et Unifiée des Annonces des Marchés Publics
-- Source: https://static.data.gouv.fr/resources/base-etendue-amelioree-et-unifiee-des-annonces-des-marches-publics/20260602-185506/beauamp-mai-2026-1.1.0.parquet
-- Last updated: 2026-06-03

CREATE SCHEMA IF NOT EXISTS entreprises;

CREATE TABLE entreprises.beaamp_2025 (
  procedure_acceleree VARCHAR NULL
,
  cpv_supp VARCHAR NULL
,
  publicite VARCHAR NULL
,
  omc VARCHAR NULL
,
  allotissement VARCHAR NULL
,
  modifie VARCHAR NULL
,
  decision VARCHAR NULL
,
  adresse_fournisseur VARCHAR NULL
,
  siren_fournisseur VARCHAR NULL
,
  nom_siren_fournisseur VARCHAR NULL
,
  nom_declare_fournisseur VARCHAR NULL
,
  date_avis_attribution VARCHAR NULL
,
  adresse_acheteur VARCHAR NULL
,
  siren_acheteur VARCHAR NULL
,
  nom_siren_acheteur VARCHAR NULL
,
  nom_declare_acheteur VARCHAR NULL
,
  date_avis_marche VARCHAR NULL
,
  debut_contrat VARCHAR NULL
,
  type_contrat VARCHAR NULL
,
  intitule_critere VARCHAR NULL
,
  type_critere VARCHAR NULL
,
  poids_critere VARCHAR NULL
,
  duree VARCHAR NULL
,
  clause_environnementale VARCHAR NULL
,
  valeur_totale_estimee VARCHAR NULL
,
  financement_ue VARCHAR NULL
,
  lieu_execution VARCHAR NULL
,
  type_accord_cadre VARCHAR NULL
,
  nom_fonds_ue VARCHAR NULL
,
  id_boamp_attribution VARCHAR NULL
,
  id_boamp_contrat VARCHAR NULL
,
  prix_attribution_lot VARCHAR NULL
,
  valeur_estimee_lot VARCHAR NULL
,
  id_lot VARCHAR NULL
,
  cpv VARCHAR NULL
,
  valeur_max_totale_accord_cadre VARCHAR NULL
,
  nombre_lots VARCHAR NULL
,
  nombre_offres VARCHAR NULL
,
  objet VARCHAR NULL
,
  procedure VARCHAR NULL
,
  id_projet VARCHAR NULL
,
  renouvellement VARCHAR NULL
,
  marche_reserve VARCHAR NULL
,
  favorable_pme VARCHAR NULL
,
  clause_sociale VARCHAR NULL
,
  strategique_environnemental VARCHAR NULL
,
  strategique_social VARCHAR NULL
,
  valeur_totale VARCHAR NULL
,
  code_statut_juridique_acheteur VARCHAR NULL
,
  nom_statut_juridique_acheteur VARCHAR NULL
,
  effectif_acheteur VARCHAR NULL
,
  acheteur_ess VARCHAR NULL
,
  date_creation_acheteur VARCHAR NULL
,
  code_activite_principale_acheteur VARCHAR NULL
,
  version_activite_acheteur VARCHAR NULL
,
  code_statut_juridique_fournisseur VARCHAR NULL
,
  nom_statut_juridique_fournisseur VARCHAR NULL
,
  effectif_fournisseur VARCHAR NULL
,
  fournisseur_ess VARCHAR NULL
,
  fournisseur_mission VARCHAR NULL
,
  version_activite_fournisseur VARCHAR NULL
,
  niveau_activite1_fournisseur VARCHAR NULL
,
  niveau_activite2_fournisseur VARCHAR NULL
,
  niveau_activite3_fournisseur VARCHAR NULL
,
  niveau_activite4_fournisseur VARCHAR NULL
,
  niveau_activite5_fournisseur VARCHAR NULL
,
  date_creation_fournisseur VARCHAR NULL
,
  gps_fournisseur VARCHAR NULL
,
  gps_acheteur VARCHAR NULL
,
  nom_commune_fournisseur VARCHAR NULL
,
  departement_fournisseur VARCHAR NULL
,
  region_fournisseur VARCHAR NULL
,
  code_commune_fournisseur VARCHAR NULL
,
  epci_fournisseur VARCHAR NULL
,
  nom_epci_fournisseur VARCHAR NULL
,
  nature_epci_fournisseur VARCHAR NULL
,
  nom_commune_acheteur VARCHAR NULL
,
  departement_acheteur VARCHAR NULL
,
  region_acheteur VARCHAR NULL
,
  code_commune_acheteur VARCHAR NULL
,
  epci_acheteur VARCHAR NULL
,
  nom_epci_acheteur VARCHAR NULL
,
  nature_epci_acheteur VARCHAR NULL
,
  siren_fournisseur_connu VARCHAR NULL
,
  siren_acheteur_connu VARCHAR NULL
,
  nombre_offres_pme VARCHAR NULL
,
  __index_level_0__ BIGINT NULL
);

COMMENT ON TABLE entreprises.beaamp_2025 IS 'Base Étendue, Améliorée et Unifiée des Annonces des Marchés Publics - Mise à jour mai 2026';

CALL ducklake_add_data_files('dg', 'beaamp_2025',
    'https://static.data.gouv.fr/resources/base-etendue-amelioree-et-unifiee-des-annonces-des-marches-publics/20260602-185506/beauamp-mai-2026-1.1.0.parquet',
    schema => 'entreprises');