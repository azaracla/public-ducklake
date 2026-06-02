-- ============================================================
-- SCHEMA: entreprises
-- ============================================================

CREATE SCHEMA IF NOT EXISTS entreprises;

-- Table: entreprises.beaamp_2025
-- Source: https://static.data.gouv.fr/resources/base-etendue-amelioree-et-unifiee-des-annonces-des-marches-publics/20260102-130531/beauamp-2025-1.1.0.parquet

CREATE TABLE entreprises.beaamp_2025 (
  procedure_acceleree VARCHAR NULL,
  cpv_supp VARCHAR NULL,
  publicite VARCHAR NULL,
  omc VARCHAR NULL,
  allotissement VARCHAR NULL,
  modifie VARCHAR NULL,
  decision VARCHAR NULL,
  adresse_fournisseur VARCHAR NULL,
  siren_fournisseur VARCHAR NULL,
  nom_siren_fournisseur VARCHAR NULL,
  nom_declare_fournisseur VARCHAR NULL,
  date_avis_attribution VARCHAR NULL,
  adresse_acheteur VARCHAR NULL,
  siren_acheteur VARCHAR NULL,
  nom_siren_acheteur VARCHAR NULL,
  nom_declare_acheteur VARCHAR NULL,
  date_avis_marche VARCHAR NULL,
  debut_contrat VARCHAR NULL,
  type_contrat VARCHAR NULL,
  intitule_critere VARCHAR NULL,
  type_critere VARCHAR NULL,
  poids_critere VARCHAR NULL,
  duree VARCHAR NULL,
  clause_environnementale VARCHAR NULL,
  valeur_totale_estimee VARCHAR NULL,
  financement_ue VARCHAR NULL,
  lieu_execution VARCHAR NULL,
  type_accord_cadre VARCHAR NULL,
  nom_fonds_ue VARCHAR NULL,
  id_boamp_attribution VARCHAR NULL,
  id_boamp_contrat VARCHAR NULL,
  prix_attribution_lot VARCHAR NULL,
  valeur_estimee_lot VARCHAR NULL,
  id_lot VARCHAR NULL,
  cpv VARCHAR NULL,
  valeur_max_totale_accord_cadre VARCHAR NULL,
  nombre_lots VARCHAR NULL,
  nombre_offres VARCHAR NULL,
  objet VARCHAR NULL,
  procedure VARCHAR NULL,
  id_projet VARCHAR NULL,
  renouvellement VARCHAR NULL,
  marche_reserve VARCHAR NULL,
  favorable_pme VARCHAR NULL,
  clause_sociale VARCHAR NULL,
  strategique_environnemental VARCHAR NULL,
  strategique_social VARCHAR NULL,
  valeur_totale VARCHAR NULL,
  code_statut_juridique_acheteur VARCHAR NULL,
  nom_statut_juridique_acheteur VARCHAR NULL,
  effectif_acheteur VARCHAR NULL,
  acheteur_ess VARCHAR NULL,
  date_creation_acheteur VARCHAR NULL,
  code_activite_principale_acheteur VARCHAR NULL,
  version_activite_acheteur VARCHAR NULL,
  code_statut_juridique_fournisseur VARCHAR NULL,
  nom_statut_juridique_fournisseur VARCHAR NULL,
  effectif_fournisseur VARCHAR NULL,
  fournisseur_ess VARCHAR NULL,
  fournisseur_mission VARCHAR NULL,
  version_activite_fournisseur VARCHAR NULL,
  niveau_activite1_fournisseur VARCHAR NULL,
  niveau_activite2_fournisseur VARCHAR NULL,
  niveau_activite3_fournisseur VARCHAR NULL,
  niveau_activite4_fournisseur VARCHAR NULL,
  niveau_activite5_fournisseur VARCHAR NULL,
  date_creation_fournisseur VARCHAR NULL,
  gps_fournisseur VARCHAR NULL,
  gps_acheteur VARCHAR NULL,
  nom_commune_fournisseur VARCHAR NULL,
  departement_fournisseur VARCHAR NULL,
  region_fournisseur VARCHAR NULL,
  code_commune_fournisseur VARCHAR NULL,
  epci_fournisseur VARCHAR NULL,
  nom_epci_fournisseur VARCHAR NULL,
  nature_epci_fournisseur VARCHAR NULL,
  nom_commune_acheteur VARCHAR NULL,
  departement_acheteur VARCHAR NULL,
  region_acheteur VARCHAR NULL,
  code_commune_acheteur VARCHAR NULL,
  epci_acheteur VARCHAR NULL,
  nom_epci_acheteur VARCHAR NULL,
  nature_epci_acheteur VARCHAR NULL,
  siren_fournisseur_connu VARCHAR NULL,
  siren_acheteur_connu VARCHAR NULL,
  nombre_offres_pme VARCHAR NULL,
  __index_level_0__ BIGINT NULL
);

CALL ducklake_add_data_files('dg', 'beaamp_2025',
    'https://static.data.gouv.fr/resources/base-etendue-amelioree-et-unifiee-des-annonces-des-marches-publics/20260102-130531/beauamp-2025-1.1.0.parquet',
    schema => 'entreprises');


-- Table: entreprises.sirene_unites_legales
-- Source: https://static.data.gouv.fr/resources/base-sirene-des-entreprises-et-de-leurs-etablissements-siren-siret/20260601-092310/stock-stockunitelegale-parquet.parquet

CREATE TABLE entreprises.sirene_unites_legales (
  siren VARCHAR NULL,
  statutDiffusionUniteLegale VARCHAR NULL,
  unitePurgeeUniteLegale BOOLEAN NULL,
  dateCreationUniteLegale DATE NULL,
  sigleUniteLegale VARCHAR NULL,
  sexeUniteLegale VARCHAR NULL,
  prenom1UniteLegale VARCHAR NULL,
  prenom2UniteLegale VARCHAR NULL,
  prenom3UniteLegale VARCHAR NULL,
  prenom4UniteLegale VARCHAR NULL,
  prenomUsuelUniteLegale VARCHAR NULL,
  pseudonymeUniteLegale VARCHAR NULL,
  identifiantAssociationUniteLegale VARCHAR NULL,
  trancheEffectifsUniteLegale VARCHAR NULL,
  anneeEffectifsUniteLegale BIGINT NULL,
  dateDernierTraitementUniteLegale TIMESTAMP NULL,
  nombrePeriodesUniteLegale BIGINT NULL,
  categorieEntreprise VARCHAR NULL,
  anneeCategorieEntreprise BIGINT NULL,
  dateDebut DATE NULL,
  etatAdministratifUniteLegale VARCHAR NULL,
  nomUniteLegale VARCHAR NULL,
  nomUsageUniteLegale VARCHAR NULL,
  denominationUniteLegale VARCHAR NULL,
  denominationUsuelle1UniteLegale VARCHAR NULL,
  denominationUsuelle2UniteLegale VARCHAR NULL,
  denominationUsuelle3UniteLegale VARCHAR NULL,
  categorieJuridiqueUniteLegale BIGINT NULL,
  activitePrincipaleUniteLegale VARCHAR NULL,
  nomenclatureActivitePrincipaleUniteLegale VARCHAR NULL,
  nicSiegeUniteLegale VARCHAR NULL,
  economieSocialeSolidaireUniteLegale VARCHAR NULL,
  societeMissionUniteLegale VARCHAR NULL,
  caractereEmployeurUniteLegale VARCHAR NULL,
  activitePrincipaleNAF25UniteLegale VARCHAR NULL
);

CALL ducklake_add_data_files('dg', 'sirene_unites_legales',
    'https://static.data.gouv.fr/resources/base-sirene-des-entreprises-et-de-leurs-etablissements-siren-siret/20260601-092310/stock-stockunitelegale-parquet.parquet',
    schema => 'entreprises');


-- Table: entreprises.sirene_etablissements
-- Source: https://static.data.gouv.fr/resources/base-sirene-des-entreprises-et-de-leurs-etablissements-siren-siret/20260601-092940/stock-stocketablissement-parquet.parquet

CREATE TABLE entreprises.sirene_etablissements (
  siren VARCHAR NULL,
  nic VARCHAR NULL,
  siret VARCHAR NULL,
  statutDiffusionEtablissement VARCHAR NULL,
  dateCreationEtablissement DATE NULL,
  trancheEffectifsEtablissement VARCHAR NULL,
  anneeEffectifsEtablissement BIGINT NULL,
  activitePrincipaleRegistreMetiersEtablissement VARCHAR NULL,
  dateDernierTraitementEtablissement TIMESTAMP NULL,
  etablissementSiege BOOLEAN NULL,
  nombrePeriodesEtablissement BIGINT NULL,
  complementAdresseEtablissement VARCHAR NULL,
  numeroVoieEtablissement VARCHAR NULL,
  indiceRepetitionEtablissement VARCHAR NULL,
  dernierNumeroVoieEtablissement VARCHAR NULL,
  indiceRepetitionDernierNumeroVoieEtablissement VARCHAR NULL,
  typeVoieEtablissement VARCHAR NULL,
  libelleVoieEtablissement VARCHAR NULL,
  codePostalEtablissement VARCHAR NULL,
  libelleCommuneEtablissement VARCHAR NULL,
  libelleCommuneEtrangerEtablissement VARCHAR NULL,
  distributionSpecialeEtablissement VARCHAR NULL,
  codeCommuneEtablissement VARCHAR NULL,
  codeCedexEtablissement VARCHAR NULL,
  libelleCedexEtablissement VARCHAR NULL,
  codePaysEtrangerEtablissement VARCHAR NULL,
  libellePaysEtrangerEtablissement VARCHAR NULL,
  identifiantAdresseEtablissement VARCHAR NULL,
  coordonneeLambertAbscisseEtablissement VARCHAR NULL,
  coordonneeLambertOrdonneeEtablissement VARCHAR NULL,
  complementAdresse2Etablissement VARCHAR NULL,
  numeroVoie2Etablissement VARCHAR NULL,
  indiceRepetition2Etablissement VARCHAR NULL,
  typeVoie2Etablissement VARCHAR NULL,
  libelleVoie2Etablissement VARCHAR NULL,
  codePostal2Etablissement VARCHAR NULL,
  libelleCommune2Etablissement VARCHAR NULL,
  libelleCommuneEtranger2Etablissement VARCHAR NULL,
  distributionSpeciale2Etablissement VARCHAR NULL,
  codeCommune2Etablissement VARCHAR NULL,
  codeCedex2Etablissement VARCHAR NULL,
  libelleCedex2Etablissement VARCHAR NULL,
  codePaysEtranger2Etablissement VARCHAR NULL,
  libellePaysEtranger2Etablissement VARCHAR NULL,
  dateDebut DATE NULL,
  etatAdministratifEtablissement VARCHAR NULL,
  enseigne1Etablissement VARCHAR NULL,
  enseigne2Etablissement VARCHAR NULL,
  enseigne3Etablissement VARCHAR NULL,
  denominationUsuelleEtablissement VARCHAR NULL,
  activitePrincipaleEtablissement VARCHAR NULL,
  nomenclatureActivitePrincipaleEtablissement VARCHAR NULL,
  caractereEmployeurEtablissement VARCHAR NULL,
  activitePrincipaleNAF25Etablissement VARCHAR NULL
);

CALL ducklake_add_data_files('dg', 'sirene_etablissements',
    'https://static.data.gouv.fr/resources/base-sirene-des-entreprises-et-de-leurs-etablissements-siren-siret/20260601-092940/stock-stocketablissement-parquet.parquet',
    schema => 'entreprises');


-- Table: entreprises.sirene_unites_legales_historique
-- Source: https://static.data.gouv.fr/resources/base-sirene-des-entreprises-et-de-leurs-etablissements-siren-siret/20260601-092423/stock-stockunitelegalehistorique-parquet.parquet

CREATE TABLE entreprises.sirene_unites_legales_historique (
  siren VARCHAR NULL,
  dateFin DATE NULL,
  dateDebut DATE NULL,
  etatAdministratifUniteLegale VARCHAR NULL,
  changementEtatAdministratifUniteLegale BOOLEAN NULL,
  nomUniteLegale VARCHAR NULL,
  changementNomUniteLegale BOOLEAN NULL,
  nomUsageUniteLegale VARCHAR NULL,
  changementNomUsageUniteLegale BOOLEAN NULL,
  denominationUniteLegale VARCHAR NULL,
  changementDenominationUniteLegale BOOLEAN NULL,
  denominationUsuelle1UniteLegale VARCHAR NULL,
  denominationUsuelle2UniteLegale VARCHAR NULL,
  denominationUsuelle3UniteLegale VARCHAR NULL,
  changementDenominationUsuelleUniteLegale BOOLEAN NULL,
  categorieJuridiqueUniteLegale VARCHAR NULL,
  changementCategorieJuridiqueUniteLegale BOOLEAN NULL,
  activitePrincipaleUniteLegale VARCHAR NULL,
  nomenclatureActivitePrincipaleUniteLegale VARCHAR NULL,
  changementActivitePrincipaleUniteLegale BOOLEAN NULL,
  nicSiegeUniteLegale VARCHAR NULL,
  changementNicSiegeUniteLegale BOOLEAN NULL,
  economieSocialeSolidaireUniteLegale VARCHAR NULL,
  changementEconomieSocialeSolidaireUniteLegale BOOLEAN NULL,
  societeMissionUniteLegale VARCHAR NULL,
  changementSocieteMissionUniteLegale BOOLEAN NULL,
  caractereEmployeurUniteLegale VARCHAR NULL,
  changementCaractereEmployeurUniteLegale BOOLEAN NULL
);

CALL ducklake_add_data_files('dg', 'sirene_unites_legales_historique',
    'https://static.data.gouv.fr/resources/base-sirene-des-entreprises-et-de-leurs-etablissements-siren-siret/20260601-092423/stock-stockunitelegalehistorique-parquet.parquet',
    schema => 'entreprises');


-- Table: entreprises.sirene_etablissements_historique
-- Source: https://static.data.gouv.fr/resources/base-sirene-des-entreprises-et-de-leurs-etablissements-siren-siret/20260601-092749/stock-stocketablissementhistorique-parquet.parquet

CREATE TABLE entreprises.sirene_etablissements_historique (
  siren VARCHAR NULL,
  nic VARCHAR NULL,
  siret VARCHAR NULL,
  dateFin DATE NULL,
  dateDebut DATE NULL,
  etatAdministratifEtablissement VARCHAR NULL,
  changementEtatAdministratifEtablissement BOOLEAN NULL,
  enseigne1Etablissement VARCHAR NULL,
  enseigne2Etablissement VARCHAR NULL,
  enseigne3Etablissement VARCHAR NULL,
  changementEnseigneEtablissement BOOLEAN NULL,
  denominationUsuelleEtablissement VARCHAR NULL,
  changementDenominationUsuelleEtablissement BOOLEAN NULL,
  activitePrincipaleEtablissement VARCHAR NULL,
  nomenclatureActivitePrincipaleEtablissement VARCHAR NULL,
  changementActivitePrincipaleEtablissement BOOLEAN NULL,
  caractereEmployeurEtablissement VARCHAR NULL,
  changementCaractereEmployeurEtablissement BOOLEAN NULL
);

CALL ducklake_add_data_files('dg', 'sirene_etablissements_historique',
    'https://static.data.gouv.fr/resources/base-sirene-des-entreprises-et-de-leurs-etablissements-siren-siret/20260601-092749/stock-stocketablissementhistorique-parquet.parquet',
    schema => 'entreprises');


-- Table: entreprises.annuaire_unites_legales
-- Source: https://static.data.gouv.fr/resources/donnees-des-entreprises-utilisees-dans-lannuaire-des-entreprises/20260602-160727/unites-legales-2026-06-02.parquet

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
  date_mise_a_jour_insee TIMESTAMP_NS NULL,
  date_mise_a_jour_rne TIMESTAMP_NS NULL,
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
  liste_elus LIST NULL,
  element VARCHAR NULL,
  liste_id_organisme_formation LIST NULL,
  element VARCHAR NULL,
  liste_idcc LIST NULL,
  element VARCHAR NULL,
  est_siae BOOLEAN NULL,
  type_siae VARCHAR NULL,
  liste_finess_juridique LIST NULL,
  element VARCHAR NULL,
  a_aide_ademe BOOLEAN NULL,
  est_avocat BOOLEAN NULL
);

CALL ducklake_add_data_files('dg', 'annuaire_unites_legales',
    'https://static.data.gouv.fr/resources/donnees-des-entreprises-utilisees-dans-lannuaire-des-entreprises/20260602-160727/unites-legales-2026-06-02.parquet',
    schema => 'entreprises');


-- Table: entreprises.annuaire_etablissements
-- Source: https://static.data.gouv.fr/resources/donnees-des-entreprises-utilisees-dans-lannuaire-des-entreprises/20260602-161010/etablissements-2026-06-02.parquet

CREATE TABLE entreprises.annuaire_etablissements (
  siren VARCHAR NULL,
  siret VARCHAR NULL,
  est_siege BOOLEAN NULL,
  ancien_siege BOOLEAN NULL,
  adresse VARCHAR NULL,
  etat_administratif VARCHAR NULL,
  statut_diffusion VARCHAR NULL,
  liste_finess_geographique LIST NULL,
  element VARCHAR NULL,
  liste_id_bio LIST NULL,
  element VARCHAR NULL,
  liste_idcc LIST NULL,
  element VARCHAR NULL,
  liste_rge LIST NULL,
  element VARCHAR NULL,
  liste_uai LIST NULL,
  element VARCHAR NULL
);

CALL ducklake_add_data_files('dg', 'annuaire_etablissements',
    'https://static.data.gouv.fr/resources/donnees-des-entreprises-utilisees-dans-lannuaire-des-entreprises/20260602-161010/etablissements-2026-06-02.parquet',
    schema => 'entreprises');


-- Table: entreprises.donnees_financieres
-- Source: https://static.data.gouv.fr/resources/donnees-financieres-detaillees-des-entreprises-format-parquet/20260210-082327/export-detail-bilan.parquet

CREATE TABLE entreprises.donnees_financieres (
  siren VARCHAR NULL,
  date_cloture_exercice DATE NULL,
  type_bilan VARCHAR NULL,
  confidentiality VARCHAR NULL,
  liasse MAP NULL,
  key VARCHAR NULL,
  value INTEGER NULL
);

CALL ducklake_add_data_files('dg', 'donnees_financieres',
    'https://static.data.gouv.fr/resources/donnees-financieres-detaillees-des-entreprises-format-parquet/20260210-082327/export-detail-bilan.parquet',
    schema => 'entreprises');


