-- Schema: entreprises
-- Table: annuaire_etablissements
-- Dataset: Données des entreprises utilisées dans l'Annuaire des Entreprises
-- Source: https://www.data.gouv.fr/api/1/datasets/r/58427078-8afb-4651-9469-c9043991d892
-- Last updated: 2026-06-03

CREATE SCHEMA IF NOT EXISTS entreprises;

CREATE TABLE entreprises.annuaire_etablissements (
  siren VARCHAR NULL
,
  siret VARCHAR NULL
,
  est_siege BOOLEAN NULL
,
  ancien_siege BOOLEAN NULL
,
  adresse VARCHAR NULL
,
  etat_administratif VARCHAR NULL
,
  statut_diffusion VARCHAR NULL
,
  liste_finess_geographique STRING[] NULL
,
  liste_id_bio STRING[] NULL
,
  liste_idcc STRING[] NULL
,
  liste_rge STRING[] NULL
,
  liste_uai STRING[] NULL
);

COMMENT ON TABLE entreprises.annuaire_etablissements IS 'Établissements des entreprises (Annuaire des Entreprises)';

COMMENT ON COLUMN entreprises.annuaire_etablissements.siren IS 'SIREN de l''unité légale (source : base Sirene)';
COMMENT ON COLUMN entreprises.annuaire_etablissements.siret IS 'Numéro unique de l''établissement (source : base Sirene)';
COMMENT ON COLUMN entreprises.annuaire_etablissements.est_siege IS 'L''établissement est le siège de l''unité légale (source : base Sirene)';
COMMENT ON COLUMN entreprises.annuaire_etablissements.ancien_siege IS 'L''établissement a précédemment servi de siège de l''unité légale (source : base Sirene)';
COMMENT ON COLUMN entreprises.annuaire_etablissements.adresse IS 'Champs construit depuis les champs d''adresse de la base SIRENE : complement adresse + numéro voie + indice repetition + type voie + libelle voie + distribution spéciale + (code postal + libelle commune | cedex + libelle cedex) + libelle commune étranger + libelle pays étranger';
COMMENT ON COLUMN entreprises.annuaire_etablissements.etat_administratif IS 'Etat administratif de l''établissement. ''A'' pour Actif, ''F'' pour Fermé (source : base Sirene)';
COMMENT ON COLUMN entreprises.annuaire_etablissements.statut_diffusion IS 'Statut de diffusion de l''établissement (source : base Sirene)';
COMMENT ON COLUMN entreprises.annuaire_etablissements.liste_id_bio IS 'Liste des identifiants BIO de l''établissement (source : Agence Bio)';
COMMENT ON COLUMN entreprises.annuaire_etablissements.liste_idcc IS 'Liste des conventions collectives de l''établissement (source : Ministère du travail)';
COMMENT ON COLUMN entreprises.annuaire_etablissements.liste_rge IS 'Liste des identifiants RGE de l''établissement (source : ADEME)';
COMMENT ON COLUMN entreprises.annuaire_etablissements.liste_uai IS 'Liste des identifiants UAI de l''établissement (source : Ministère de l''enseignement supérieur et de la recherche)';

CALL ducklake_add_data_files('dg', 'annuaire_etablissements',
    'https://www.data.gouv.fr/api/1/datasets/r/58427078-8afb-4651-9469-c9043991d892',
    schema => 'entreprises');