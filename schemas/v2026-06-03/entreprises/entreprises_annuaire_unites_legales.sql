-- Schema: entreprises
-- Table: annuaire_unites_legales
-- Dataset: Données des entreprises utilisées dans l'Annuaire des Entreprises
-- Source: https://static.data.gouv.fr/resources/donnees-des-entreprises-utilisees-dans-lannuaire-des-entreprises/20260602-160727/unites-legales-2026-06-02.parquet
-- Last updated: 2026-06-03

CREATE SCHEMA IF NOT EXISTS entreprises;

CREATE TABLE entreprises.annuaire_unites_legales (
  siren VARCHAR NULL
,
  siret_siege VARCHAR NULL
,
  etat_administratif VARCHAR NULL
,
  statut_diffusion VARCHAR NULL
,
  nombre_etablissements BIGINT NULL
,
  nombre_etablissements_ouverts BIGINT NULL
,
  nom_complet VARCHAR NULL
,
  nature_juridique VARCHAR NULL
,
  colter_code VARCHAR NULL
,
  colter_code_insee VARCHAR NULL
,
  colter_elus VARCHAR NULL
,
  colter_niveau VARCHAR NULL
,
  date_mise_a_jour_insee TIMESTAMP NULL
,
  date_mise_a_jour_rne TIMESTAMP NULL
,
  egapro_renseignee BOOLEAN NULL
,
  est_achats_responsables BOOLEAN NULL
,
  est_alim_confiance BOOLEAN NULL
,
  est_association BOOLEAN NULL
,
  est_entrepreneur_individuel BOOLEAN NULL
,
  est_entrepreneur_spectacle BOOLEAN NULL
,
  est_patrimoine_vivant BOOLEAN NULL
,
  statut_entrepreneur_spectacle VARCHAR NULL
,
  est_ess BOOLEAN NULL
,
  est_organisme_formation BOOLEAN NULL
,
  est_qualiopi BOOLEAN NULL
,
  est_administration BOOLEAN NULL
,
  est_societe_mission VARCHAR NULL
,
  liste_elus LIST(VARCHAR) NULL
,
  liste_id_organisme_formation LIST(VARCHAR) NULL
,
  liste_idcc LIST(VARCHAR) NULL
,
  est_siae BOOLEAN NULL
,
  type_siae VARCHAR NULL
,
  liste_finess_juridique LIST(VARCHAR) NULL
,
  a_aide_ademe BOOLEAN NULL
,
  est_avocat BOOLEAN NULL
);

COMMENT ON TABLE entreprises.annuaire_unites_legales IS 'Unités légales des entreprises (Annuaire des Entreprises)';

COMMENT ON COLUMN entreprises.annuaire_unites_legales.siren IS 'Numéro unique de l''entreprise (source: base Sirene)';
COMMENT ON COLUMN entreprises.annuaire_unites_legales.siret_siege IS 'Numéro unique de l''établissement siège (source: base Sirene)';
COMMENT ON COLUMN entreprises.annuaire_unites_legales.etat_administratif IS 'État administratif de l''unité légale. ''A'' pour Active, ''C'' pour Cessée (source : base Sirene)';
COMMENT ON COLUMN entreprises.annuaire_unites_legales.statut_diffusion IS 'Statut de diffusion de le l''unité légale (source : base Sirene)';
COMMENT ON COLUMN entreprises.annuaire_unites_legales.nombre_etablissements IS 'Nombre des établissements de l''unité légale (source : base Sirene)';
COMMENT ON COLUMN entreprises.annuaire_unites_legales.nombre_etablissements_ouverts IS 'Nombre des établissements ouverts de l''unité légale (source : base Sirene)';
COMMENT ON COLUMN entreprises.annuaire_unites_legales.nom_complet IS 'Champs construit depuis les champs de dénomination : denomination de l''unité légale | Nom et prénom | Nom inconnu (dénomination usuelle : construite à partir des trois champs de dénomination usuelle de la base SIRENE) (sigle de l''unité légale)';
COMMENT ON COLUMN entreprises.annuaire_unites_legales.colter_code IS 'Code affilié à une collectivité territoriale (Commune - code INSEE, EPCI - n° SIREN, Département - Code INSEE + ''D'' (sauf cas particulier), Région - Code INSEE)';
COMMENT ON COLUMN entreprises.annuaire_unites_legales.colter_code_insee IS 'Code INSEE de la collectivité territoriale';
COMMENT ON COLUMN entreprises.annuaire_unites_legales.colter_elus IS 'Élus enregistrés au Répertoire National des Élus(source : Ministère de l''Intérieur et des Outre-Mer)';
COMMENT ON COLUMN entreprises.annuaire_unites_legales.colter_niveau IS 'Niveau de collectivité territoriale';
COMMENT ON COLUMN entreprises.annuaire_unites_legales.date_mise_a_jour_insee IS 'Date de mise à jour de la donnée dans la base Sirene (source: base Sirene)';
COMMENT ON COLUMN entreprises.annuaire_unites_legales.date_mise_a_jour_rne IS 'Date de mise à jour de la donnée dans le RNE (source : le RNE)';
COMMENT ON COLUMN entreprises.annuaire_unites_legales.egapro_renseignee IS 'Indique si au moins un établissement a un indice égalité professionnel H/F renseigné (source : Ministère du Travail du Plein emploi et de l''Insertion)';
COMMENT ON COLUMN entreprises.annuaire_unites_legales.est_association IS 'L''unité légale est une association (source : base Sirene)';
COMMENT ON COLUMN entreprises.annuaire_unites_legales.est_entrepreneur_individuel IS 'Entreprise individuelle (source : base Sirene)';
COMMENT ON COLUMN entreprises.annuaire_unites_legales.est_entrepreneur_spectacle IS 'Entreprise ayant une licence d''entrepreneur du spectacle (source : Ministère de la Culture)';
COMMENT ON COLUMN entreprises.annuaire_unites_legales.statut_entrepreneur_spectacle IS 'Statut des établissements ayant fait une demande de licence d''entrepreneur du spectacle (source : Ministère de la Culture)';
COMMENT ON COLUMN entreprises.annuaire_unites_legales.est_ess IS 'Entreprises appartenant au champ de l''économie sociale et solidaire (source : base Sirene et ESS France)';
COMMENT ON COLUMN entreprises.annuaire_unites_legales.est_organisme_formation IS 'Entreprise ayant au moins un établissement organisme de formation (source : Ministère du Travail)';
COMMENT ON COLUMN entreprises.annuaire_unites_legales.est_qualiopi IS 'Entreprise ayant une certification de la marque « Qualiopi » (source : Ministère du Travail)';
COMMENT ON COLUMN entreprises.annuaire_unites_legales.est_administration IS 'Uniquement les structures reconnues comme administration. Attention : Cette donnée se base sur des règles de gestion documentées ici: https://github.com/annuaire-entreprises-data-gouv-fr/search-infra/blob/97b81953f060015b881f44482897a066f2cd34cf/data_enrichment.py#L103. Cette donnée n''est pas exhaustive et peut contenir des faux positifs.';
COMMENT ON COLUMN entreprises.annuaire_unites_legales.est_societe_mission IS 'Société qui appartient au champ des sociétés à mission (source : base Sirene)';
COMMENT ON COLUMN entreprises.annuaire_unites_legales.liste_elus IS 'Liste des élus s''il s''agit de collectivé territoriale (source : Ministère de l''Intérieur et des Outre-Mer)';
COMMENT ON COLUMN entreprises.annuaire_unites_legales.liste_id_organisme_formation IS 'Liste des numéros de déclaration d''activité des établissement organismes de formation (source : Ministère du Travail)';
COMMENT ON COLUMN entreprises.annuaire_unites_legales.liste_idcc IS 'Liste des conventions collectives de l''unité légale (source : Ministère du travail)';
COMMENT ON COLUMN entreprises.annuaire_unites_legales.est_siae IS 'Structure d''insertion par l''activité économique (source : Marché de l''Inclusion)';
COMMENT ON COLUMN entreprises.annuaire_unites_legales.type_siae IS 'Type de structure de l''inclusion (source : Marché de l''Inclusion)';

CALL ducklake_add_data_files('dg', 'annuaire_unites_legales',
    'https://static.data.gouv.fr/resources/donnees-des-entreprises-utilisees-dans-lannuaire-des-entreprises/20260602-160727/unites-legales-2026-06-02.parquet',
    schema => 'entreprises');