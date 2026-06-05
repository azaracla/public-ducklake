-- Schema: economie
-- Table: commande_publique
-- Dataset: Données essentielles de la commande publique - fichiers consolidés
-- Source: https://www.data.gouv.fr/datasets/donnees-essentielles-de-la-commande-publique-fichiers-consolides
-- Converted from decp-global.json (903 MB) to flat Parquet (41 MB) via ijson + PyArrow (scripts/consolidate_decp.py)
-- Last updated: 2026-06-05

CREATE SCHEMA IF NOT EXISTS economie;

CREATE TABLE economie.commande_publique (
  id VARCHAR NULL
,
  acheteur_id VARCHAR NULL
,
  acheteur_nom VARCHAR NULL
,
  nature VARCHAR NULL
,
  type_contrat VARCHAR NULL
,
  objet VARCHAR NULL
,
  code_cpv VARCHAR NULL
,
  procedure VARCHAR NULL
,
  ccag VARCHAR NULL
,
  offres_recues BIGINT NULL
,
  type_groupement VARCHAR NULL
,
  lieu_code VARCHAR NULL
,
  lieu_type_code VARCHAR NULL
,
  lieu_nom VARCHAR NULL
,
  duree_mois BIGINT NULL
,
  date_notification VARCHAR NULL
,
  date_publication VARCHAR NULL
,
  date_debut_execution VARCHAR NULL
,
  montant DOUBLE NULL
,
  montant_min DOUBLE NULL
,
  montant_max DOUBLE NULL
,
  forme_prix VARCHAR NULL
,
  sous_traitance BOOLEAN NULL
,
  marche_innovant BOOLEAN NULL
,
  attribution_avance BOOLEAN NULL
,
  titulaires_ids VARCHAR NULL
,
  nb_titulaires BIGINT NULL
,
  source VARCHAR NULL
,
  origine_ue DOUBLE NULL
,
  origine_france DOUBLE NULL
,
  taux_avance DOUBLE NULL
,
  annee VARCHAR NULL
);

COMMENT ON TABLE economie.commande_publique IS 'Données essentielles de la commande publique française — fichier global dédoublonné (2018–2026). 656 202 marchés et contrats de concession, convertis du JSON source en Parquet plat (41 MB). Source: data.gouv.fr dataset 5cd57bf6';

COMMENT ON COLUMN economie.commande_publique.id IS 'Identifiant unique du marché dans la source';
COMMENT ON COLUMN economie.commande_publique.acheteur_id IS 'SIRET de l''acheteur public (collectivité, ministère, etc.)';
COMMENT ON COLUMN economie.commande_publique.acheteur_nom IS 'Nom de l''acheteur public';
COMMENT ON COLUMN economie.commande_publique.nature IS 'Nature du marché (Marché, Marché de partenariat, etc.)';
COMMENT ON COLUMN economie.commande_publique.type_contrat IS 'Type de contrat : Marché ou Contrat-Concession';
COMMENT ON COLUMN economie.commande_publique.objet IS 'Description de l''objet du marché';
COMMENT ON COLUMN economie.commande_publique.code_cpv IS 'Code CPV (Common Procurement Vocabulary)';
COMMENT ON COLUMN economie.commande_publique.procedure IS 'Procédure de passation (appel d''offres, procédure adaptée, etc.)';
COMMENT ON COLUMN economie.commande_publique.ccag IS 'Cahier des clauses administratives générales applicable';
COMMENT ON COLUMN economie.commande_publique.offres_recues IS 'Nombre d''offres reçues';
COMMENT ON COLUMN economie.commande_publique.type_groupement IS 'Type de groupement d''opérateurs économiques';
COMMENT ON COLUMN economie.commande_publique.lieu_code IS 'Code du lieu d''exécution (commune ou département)';
COMMENT ON COLUMN economie.commande_publique.lieu_type_code IS 'Type de code lieu (Code postal, Code commune, etc.)';
COMMENT ON COLUMN economie.commande_publique.lieu_nom IS 'Nom du lieu d''exécution';
COMMENT ON COLUMN economie.commande_publique.duree_mois IS 'Durée du marché en mois';
COMMENT ON COLUMN economie.commande_publique.date_notification IS 'Date de notification du marché (YYYY-MM-DD)';
COMMENT ON COLUMN economie.commande_publique.date_publication IS 'Date de publication des données (YYYY-MM-DD)';
COMMENT ON COLUMN economie.commande_publique.date_debut_execution IS 'Date de début d''exécution (YYYY-MM-DD)';
COMMENT ON COLUMN economie.commande_publique.montant IS 'Montant du marché en euros';
COMMENT ON COLUMN economie.commande_publique.montant_min IS 'Montant minimum (si contrat à montant variable) en euros';
COMMENT ON COLUMN economie.commande_publique.montant_max IS 'Montant maximum (si contrat à montant variable) en euros';
COMMENT ON COLUMN economie.commande_publique.forme_prix IS 'Forme du prix (Forfaitaire, Unitaire, etc.)';
COMMENT ON COLUMN economie.commande_publique.sous_traitance IS 'Sous-traitance déclarée (true/false)';
COMMENT ON COLUMN economie.commande_publique.marche_innovant IS 'Marché innovant (true/false)';
COMMENT ON COLUMN economie.commande_publique.attribution_avance IS 'Attribution avec avance (true/false)';
COMMENT ON COLUMN economie.commande_publique.titulaires_ids IS 'SIRET des titulaires, séparés par | si multiples';
COMMENT ON COLUMN economie.commande_publique.nb_titulaires IS 'Nombre de titulaires du marché';
COMMENT ON COLUMN economie.commande_publique.source IS 'Source des données (data.gouv.fr_pes, megalis, etc.)';
COMMENT ON COLUMN economie.commande_publique.origine_ue IS 'Part de l''origine UE dans le prix (0.0–1.0)';
COMMENT ON COLUMN economie.commande_publique.origine_france IS 'Part de l''origine France dans le prix (0.0–1.0)';
COMMENT ON COLUMN economie.commande_publique.taux_avance IS 'Taux d''avance (0.0–1.0)';
COMMENT ON COLUMN economie.commande_publique.annee IS 'Année du marché, extraite de la date de notification';

CALL ducklake_add_data_files('dg', 'commande_publique',
    'https://static.data.gouv.fr/resources/donnees-essentielles-de-la-commande-publique-fichiers-consolides/20260605-091141/decp-global.parquet',
    schema => 'economie');
