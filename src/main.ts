import "./style.css";
import { query } from "./duckdb";
import manifestUrl from "../data/finances_publiques/v2026-08-01/sources.json?url";

export interface SourceVersion {
  id: string;
  title: string;
  url: string;
  publishedAt: string;
  retrievedAt: string;
  sha256: string;
}

export interface Evidence {
  formula: string;
  sql: string;
  sourceIds: string[];
}

export interface ChartSeries {
  label: string;
  value: number;
  unit: string;
  tone?: "coral" | "gold" | "green";
}

export interface Claim {
  id: string;
  number: string;
  eyebrow: string;
  title: string;
  explanation: string;
  status: "constaté" | "provisoire" | "donnée de marché";
  vintage: string;
  evidence: Evidence;
}

type StoryClaim = Claim & { render: (rows: Record<string, unknown>[]) => string };
const money = new Intl.NumberFormat("fr-FR", { maximumFractionDigits: 1 });
const percent = new Intl.NumberFormat("fr-FR", { minimumFractionDigits: 1, maximumFractionDigits: 2 });
const n = (value: unknown) => Number(value);
const esc = (value: unknown) => String(value).replace(/[&<>"]/g, (character) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;" })[character]!);

const sources: SourceVersion[] = [
  { id: "insee", title: "Insee · comptes des APU 2025", url: "https://www.insee.fr/fr/statistiques/8997691", publishedAt: "29 mai 2026", retrievedAt: "1 août 2026", sha256: "4a42854010a7…abd86" },
  { id: "insee-apu", title: "Insee · comptes des APU 2019–2025", url: "https://www.data.gouv.fr/datasets/comptes-des-administrations-publiques", publishedAt: "7 juillet 2026", retrievedAt: "1 août 2026", sha256: "72727dc0b037…00880b" },
  { id: "quarterly", title: "Insee · dette trimestrielle", url: "https://www.insee.fr/fr/statistiques/2830301", publishedAt: "30 juillet 2026", retrievedAt: "1 août 2026", sha256: "fe87bc53d6a2…3d633" },
  { id: "eurostat", title: "Eurostat · taux français à 10 ans", url: "https://ec.europa.eu/eurostat/databrowser/view/irt_lt_mcby_m/default/table", publishedAt: "série mensuelle", retrievedAt: "1 août 2026", sha256: "c71f284b77d4…7e244" },
  { id: "aft", title: "AFT · rapport 2025 et encours OAT", url: "https://www.aft.gouv.fr/fr/publications/communiques-presse/07072026-lagence-france-tresor-publie-son-rapport-dactivite-2025", publishedAt: "7 juillet 2026", retrievedAt: "1 août 2026", sha256: "173ff2ce5698…47a" },
  { id: "commande", title: "data.gouv.fr · données essentielles de la commande publique", url: "https://www.data.gouv.fr/datasets/donnees-essentielles-de-la-commande-publique-fichiers-consolides", publishedAt: "5 juin 2026", retrievedAt: "à la lecture", sha256: "Parquet distant · 41 Mo" },
];

function bars(series: ChartSeries[]) {
  const max = Math.max(...series.map(({ value }) => value), 1);
  const format = (value: number, unit: string) => unit === "%" ? percent.format(value) : money.format(value);
  return `<div class="chart" role="img" aria-label="${esc(series.map(({ label, value, unit }) => `${label} ${format(value, unit)} ${unit}`).join(", "))}">
    ${series.map(({ label, value, unit, tone = "green" }) => `<div class="bar-row"><span>${esc(label)}</span><div class="track"><i class="${tone}" style="width:${value / max * 100}%"></i></div><b>${format(value, unit)} ${unit}</b></div>`).join("")}
  </div>`;
}

function trend(rows: Record<string, unknown>[]) {
  const series = [
    { label: "Dette / PIB", key: "dette_pct", tone: "green" },
    { label: "Déficit / PIB", key: "deficit_pct", tone: "coral" },
    { label: "Intérêts / PIB", key: "interets_pct", tone: "gold" },
  ];
  return `<div class="trends" aria-label="Évolution annuelle 2019 à 2025 de la dette, du déficit et des intérêts, en pourcentage du PIB">${series.map(({ label, key, tone }) => {
    const values = rows.map((row) => n(row[key]));
    const max = Math.max(...values, 1);
    const points = values.map((value, index) => `${index / (values.length - 1) * 100},${40 - value / max * 34}`).join(" ");
    return `<div><small>${label}</small><b>${percent.format(values.at(-1)!)} %</b><svg viewBox="0 0 100 44" role="img" aria-label="${label}, de ${percent.format(values[0])} à ${percent.format(values.at(-1)!)} % du PIB"><polyline class="${tone}" points="${points}" /></svg><span>${rows.map((row) => String(row.annee).slice(2)).join(" · ")}</span></div>`;
  }).join("")}</div>`;
}

function metric(label: string, value: string, detail: string) {
  return `<div class="metric"><small>${esc(label)}</small><strong>${esc(value)}</strong><span>${esc(detail)}</span></div>`;
}

const claims: StoryClaim[] = [
  {
    id: "combien", number: "01", eyebrow: "Le point de départ", title: "Combien doit la France ?",
    explanation: "Fin 2025, la dette publique désigne ici la dette Maastricht de l’État, des organismes centraux, des collectivités et de la Sécurité sociale.",
    status: "constaté", vintage: "Comptes annuels 2025 · mise à jour trimestrielle séparée",
    evidence: {
      formula: "dette fin 2025 ÷ PIB 2025 × 100",
      sql: `SELECT '2025 annuel' AS periode, dette_maastricht_millions / 1000 AS dette_md, dette_pct_pib_publie AS publie, 100 * dette_maastricht_millions / pib_millions AS recalcule, statut FROM finances_publiques.apu_annuel WHERE annee = 2025
UNION ALL
SELECT trimestre, dette_millions / 1000, ROUND(ratio_pib, 1), ROUND(ratio_pib, 1), statut FROM finances_publiques.dette_trimestrielle WHERE trimestre = (SELECT MAX(trimestre) FROM finances_publiques.dette_trimestrielle)`,
      sourceIds: ["insee", "quarterly"],
    },
    render: ([annual, update]) => `<div class="metric-grid">${metric("Dette publiée", `${money.format(n(annual.dette_md))} Md€`, "au 31 décembre 2025")}${metric("Ratio publié", `${percent.format(n(annual.publie))} %`, "du PIB")}${metric("Ratio recalculé", `${percent.format(n(annual.recalcule))} %`, `écart ${percent.format(n(annual.recalcule) - n(annual.publie))} point`)}</div><aside class="update"><span>Dernière donnée provisoire</span><b>${esc(update.periode)} · ${money.format(n(update.dette_md))} Md€ · ${percent.format(n(update.publie))} % du PIB</b></aside>`,
  },
  {
    id: "trois-mots", number: "02", eyebrow: "Trois notions", title: "Dette, déficit et intérêts ne racontent pas la même chose",
    explanation: "La dette est un stock à une date. Le déficit est ce qui manque sur une année. Les intérêts sont le prix payé cette année-là pour financer le stock accumulé.",
    status: "constaté", vintage: "Insee · année 2025",
    evidence: {
      formula: "indicateur ÷ PIB annuel × 100",
      sql: `SELECT annee, dette_maastricht_millions / 1000 AS dette_md, deficit_millions / 1000 AS deficit_md, interets_millions / 1000 AS interets_md, 100 * dette_maastricht_millions / pib_millions AS dette_pct, 100 * deficit_millions / pib_millions AS deficit_pct, 100 * interets_millions / pib_millions AS interets_pct FROM finances_publiques.apu_annuel ORDER BY annee`,
      sourceIds: ["insee", "insee-apu"],
    },
    render: (rows) => { const latest = rows.at(-1)!; return bars([{ label: "Dette (stock)", value: n(latest.dette_md), unit: "Md€" }, { label: "Déficit (flux annuel)", value: n(latest.deficit_md), unit: "Md€", tone: "coral" }, { label: "Intérêts (flux annuel)", value: n(latest.interets_md), unit: "Md€", tone: "gold" }]) + trend(rows) + `<p class="reading">En 2025, les intérêts représentent <b>${percent.format(n(latest.interets_pct))} % du PIB</b>. Ils ne s’ajoutent pas à la dette comme une troisième mesure du même objet.</p>`; },
  },
  {
    id: "qui", number: "03", eyebrow: "Le périmètre", title: "Qui porte cette dette publique ?",
    explanation: "L’État en porte l’essentiel, mais « dette française » ne signifie pas seulement dette de l’État. Les quatre sous-secteurs sont consolidés entre eux.",
    status: "constaté", vintage: "Insee · au 31 décembre 2025",
    evidence: {
      formula: "somme des quatre sous-secteurs = dette Maastricht consolidée",
      sql: `SELECT * FROM (VALUES
('État', (SELECT dette_etat_millions / 1000 FROM finances_publiques.apu_annuel WHERE annee = 2025)),
('Organismes centraux', (SELECT dette_odac_millions / 1000 FROM finances_publiques.apu_annuel WHERE annee = 2025)),
('Collectivités', (SELECT dette_apul_millions / 1000 FROM finances_publiques.apu_annuel WHERE annee = 2025)),
('Sécurité sociale', (SELECT dette_asso_millions / 1000 FROM finances_publiques.apu_annuel WHERE annee = 2025))) AS t(secteur, montant_md) ORDER BY montant_md DESC`,
      sourceIds: ["insee"],
    },
    render: (rows) => bars(rows.map((row) => ({ label: String(row.secteur), value: n(row.montant_md), unit: "Md€" }))) + `<p class="reading">Somme vérifiée : <b>${money.format(rows.reduce((sum, row) => sum + n(row.montant_md), 0))} Md€</b>.</p>`,
  },
  {
    id: "perimetres", number: "04", eyebrow: "Deux périmètres", title: "Dette publique et dette négociable de l’État : deux chiffres vrais",
    explanation: "La première couvre toutes les administrations publiques. La seconde couvre les titres négociables émis par l’État. Elles ne répondent pas à la même question.",
    status: "constaté", vintage: "Insee et AFT · fin 2025",
    evidence: {
      formula: "écart = dette Maastricht APU − dette négociable de l’État",
      sql: `SELECT dette_maastricht_millions / 1000 AS publique_md, dette_negociable_etat_millions / 1000 AS negociable_md, (dette_maastricht_millions - dette_negociable_etat_millions) / 1000 AS ecart_md FROM finances_publiques.apu_annuel WHERE annee = 2025`,
      sourceIds: ["insee", "aft"],
    },
    render: ([row]) => bars([{ label: "Dette publique Maastricht", value: n(row.publique_md), unit: "Md€" }, { label: "Dette négociable de l’État", value: n(row.negociable_md), unit: "Md€", tone: "gold" }]) + `<p class="reading">Écart de périmètre : <b>${money.format(n(row.ecart_md))} Md€</b>. Ce n’est ni une erreur ni une dette cachée.</p>`,
  },
  {
    id: "taux", number: "05", eyebrow: "Le prix du temps", title: "Trois taux, trois temporalités",
    explanation: "Le taux à dix ans observe le marché, le taux d’émission mesure les nouveaux financements de l’AFT, et le taux apparent rapporte les intérêts de tout le stock à sa dette moyenne.",
    status: "donnée de marché", vintage: "Eurostat et AFT 2025 · comptes Insee 2025",
    evidence: {
      formula: "taux apparent = intérêts 2025 ÷ moyenne(dette fin 2024, dette fin 2025) × 100",
      sql: `SELECT * FROM (VALUES
('Marché à 10 ans', (SELECT taux_10_ans_moyen_pct FROM finances_publiques.apu_annuel WHERE annee = 2025)),
('Nouvelles émissions', (SELECT taux_nouvelles_emissions_pct FROM finances_publiques.apu_annuel WHERE annee = 2025)),
('Stock — taux apparent', (SELECT 100 * interets_millions / ((dette_debut_annee_millions + dette_maastricht_millions) / 2) FROM finances_publiques.apu_annuel WHERE annee = 2025))) AS t(taux, valeur_pct)`,
      sourceIds: ["insee", "eurostat", "aft"],
    },
    render: (rows) => bars(rows.map((row, index) => ({ label: String(row.taux), value: n(row.valeur_pct), unit: "%", tone: index === 2 ? "gold" : "coral" }))) + `<p class="reading"><b>Le coupon moyen des OAT n’est pas utilisé :</b> il ne mesure ni le rendement d’émission ni la charge comptable réelle.</p>`,
  },
  {
    id: "echeances", number: "06", eyebrow: "Le refinancement", title: "La hausse des taux met du temps à traverser le stock",
    explanation: "Les OAT ne sont refinancées qu’à leur échéance. Le mur montre les remboursements futurs ; la durée moyenne de 8 ans et 184 jours explique la transmission progressive des taux.",
    status: "donnée de marché", vintage: "Encours AFT · extraction du 1 août 2026",
    evidence: {
      formula: "encours par année = somme des encours OAT arrivant à échéance cette année",
      sql: `SELECT CASE WHEN YEAR(echeance) <= 2040 THEN CAST(YEAR(echeance) AS VARCHAR) ELSE 'Après 2040' END AS echeance, ROUND(SUM(encours_euros) / 1000000000, 1) AS encours_md FROM finances_publiques.oat GROUP BY 1 ORDER BY MIN(YEAR(echeance))`,
      sourceIds: ["aft"],
    },
    render: (rows) => bars(rows.map((row) => ({ label: String(row.echeance), value: n(row.encours_md), unit: "Md€", tone: "gold" }))) + `<p class="reading">Ce profil décrit l’encours au millésime d’extraction, pas une projection de charge d’intérêts à 2029.</p>`,
  },
  {
    id: "commande-publique", number: "07", eyebrow: "Prochaine enquête · pilote", title: "La commande publique n’est pas une base unique",
    explanation: "Ce fichier consolidé relie déjà 585 000 marchés, mais les acheteurs, les titulaires et les montants n’y sont pas toujours renseignés de la même façon. C’est précisément là que commence l’enquête : avant de classer, il faut rendre les ruptures de données visibles.",
    status: "constaté", vintage: "DECP consolidées · 2021–2025 · Parquet distant de 41 Mo",
    evidence: {
      formula: "compte des lignes, identifiants et champs renseignés dans le fichier consolidé",
      sql: `SELECT * FROM (VALUES
('Marchés publiés', (SELECT COUNT(*) FROM economie.commande_publique WHERE annee BETWEEN '2021' AND '2025')),
('Acheteurs identifiés', (SELECT COUNT(DISTINCT acheteur_id) FROM economie.commande_publique WHERE annee BETWEEN '2021' AND '2025')),
('Chaînes de titulaires distinctes', (SELECT COUNT(DISTINCT titulaires_ids) FROM economie.commande_publique WHERE annee BETWEEN '2021' AND '2025')),
('Montants > 1 Md€ à contrôler', (SELECT COUNT(*) FROM economie.commande_publique WHERE annee BETWEEN '2021' AND '2025' AND montant > 1000000000))) AS t(indicateur, valeur)`,
      sourceIds: ["commande"],
    },
    render: (rows) => bars(rows.map((row, index) => ({ label: String(row.indicateur), value: n(row.valeur), unit: "", tone: index === 3 ? "coral" : "green" }))) + `<p class="reading"><b>Le total monétaire brut n’est pas affiché volontairement :</b> ${money.format(n(rows[3].valeur))} lignes dépassent 1 Md€, un signal de contrôle avant toute comparaison de dépenses.</p>`,
  },
];

const app = document.querySelector<HTMLElement>("#app")!;
app.innerHTML = `
  <header class="hero"><nav><a class="brand" href="#top">données<span>.</span>à creuser</a><a href="https://github.com/azaracla/public-ducklake">Source ouverte ↗</a></nav><div class="hero-copy" id="top"><p class="kicker">Enquêtes reproductibles</p><h1>La dette française,<br><em>sans raccourci.</em></h1><p>Six étapes pour lire la dette, puis un premier pilote sur la commande publique : un fichier volumineux, hétérogène, dont les limites font partie de l’histoire.</p><a class="start" href="#combien">Commencer l’enquête <span>↓</span></a></div></header>
  <nav class="chapters" aria-label="Chapitres">${claims.map(({ id, number, title }) => `<a href="#${id}"><small>${number}</small>${esc(title)}</a>`).join("")}</nav>
  <main>${claims.map((claim) => `<section class="chapter" id="${claim.id}" data-claim="${claim.id}"><div class="chapter-copy"><p class="eyebrow">${claim.number} · ${esc(claim.eyebrow)}</p><h2>${esc(claim.title)}</h2><p>${esc(claim.explanation)}</p><div class="provenance"><span class="badge ${claim.status === "provisoire" ? "provisional" : claim.status === "donnée de marché" ? "market" : ""}">${claim.status}</span><span>${esc(claim.vintage)}</span></div></div><div class="result" aria-live="polite"><p class="loading"><i></i> Calcul local en attente…</p></div></section>`).join("")}</main>
  <footer><span>DuckDB‑Wasm · calcul local · aucun compte<br><i id="catalogue-status">Catalogue DuckLake non chargé</i></span><a href="${manifestUrl}">Manifeste des sources</a></footer>`;

window.addEventListener("catalogue-status", (event) => {
  document.querySelector<HTMLElement>("#catalogue-status")!.textContent = (event as CustomEvent<string>).detail;
});

function proof(claim: Claim, rows: Record<string, unknown>[]) {
  const linked = sources.filter(({ id }) => claim.evidence.sourceIds.includes(id));
  return `<details class="proof"><summary>Voir la preuve <span>+</span></summary><div class="proof-grid"><div><small>Formule</small><p>${esc(claim.evidence.formula)}</p><small>Requête SQL exécutée</small><pre><code>${esc(claim.evidence.sql)}</code></pre></div><div><small>Lignes sources retournées</small><pre><code>${esc(JSON.stringify(rows.slice(0, 12), null, 2))}</code></pre><small>Sources officielles</small><ul>${linked.map(({ title, url, publishedAt, retrievedAt, sha256 }) => `<li><a href="${url}" target="_blank" rel="noreferrer">${esc(title)} ↗</a><span>publié ${publishedAt} · récupéré ${retrievedAt}<br>SHA‑256 ${sha256}</span></li>`).join("")}</ul></div></div></details>`;
}

async function load(section: HTMLElement) {
  if (section.dataset.loaded) return;
  section.dataset.loaded = "true";
  const claim = claims.find(({ id }) => id === section.dataset.claim)!;
  const result = section.querySelector<HTMLElement>(".result")!;
  result.innerHTML = `<p class="loading"><i></i> DuckDB lit les Parquet dans votre navigateur…</p>`;
  try {
    const rows = await query(claim.evidence.sql);
    result.innerHTML = claim.render(rows) + proof(claim, rows);
  } catch (error) {
    result.innerHTML = `<div class="error" role="alert"><b>Impossible d’établir la preuve.</b><p>${esc(error instanceof Error ? error.message : error)}</p><button type="button">Réessayer</button></div>`;
    section.dataset.loaded = "";
    result.querySelector("button")!.addEventListener("click", () => load(section));
  }
}

const observer = new IntersectionObserver((entries) => entries.filter(({ isIntersecting }) => isIntersecting).forEach(({ target }) => { observer.unobserve(target); void load(target as HTMLElement); }), { rootMargin: "300px" });
document.querySelectorAll<HTMLElement>(".chapter").forEach((section) => observer.observe(section));
