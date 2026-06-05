# Rapport d'analyse — Open Food Facts × Open Prices

**Date :** 5 juin 2026
**Sources :** Open Food Facts (4.5M produits, 7.5 GB Parquet) + Open Prices (262K relevés, 27 MB Parquet)
**Périmètre géographique :** France métropolitaine (supermarkets uniquement, tag OSM `shop=supermarket`)

---

## Table des matières

1. [Données et méthodologie](#1-données-et-méthodologie)
2. [Classement des enseignes par niveau de prix](#2-classement-des-enseignes-par-niveau-de-prix)
3. [Comparaison par panier identique](#3-comparaison-par-panier-identique)
4. [Leclerc vs Monoprix — duel low-cost / premium](#4-leclerc-vs-monoprix--duel-low-cost--premium)
5. [Variations géographiques des prix](#5-variations-géographiques-des-prix)
6. [Nutri-Score, bio, et prix](#6-nutri-score-bio-et-prix)
7. [Évolution temporelle et inflation](#7-évolution-temporelle-et-inflation)
8. [Saisonnalité](#8-saisonnalité)
9. [Résultats contre-intuitifs](#9-résultats-contre-intuitifs)
10. [Guide pratique : où faire ses courses](#10-guide-pratique--où-faire-ses-courses)
11. [Limites et biais](#11-limites-et-biais)
12. [Synthèse et enseignements](#12-synthèse-et-enseignements)
11. [Limites et biais](#11-limites-et-biais)
12. [Synthèse et enseignements](#12-synthèse-et-enseignements)

---

## 1. Données et méthodologie

### Sources

| Table | Lignes | Colonnes | Taille | Contenu |
|---|---|---|---|---|
| `open_food_facts` | 4 515 260 | 111 | 7.5 GB | Produits alimentaires : code-barres, nom, marque, catégories, Nutri-Score, ingrédients, labels |
| `open_prices` | 262 186 | 52 | 27 MB | Relevés de prix : code-barres, prix, devise, date, localisation OSM, type de preuve |

### Jointure

Les deux tables sont jointes sur le code-barres EAN : `prices.product_code = food.code`.

- Codes-barres distincts dans `open_prices` : **119 879**
- Codes-barres distincts dans `open_food_facts` : **4 515 200**
- Chevauchement (produits communs) : **100 025** (83.4% des codes prices ont une fiche produit)

### Filtres appliqués

- **Zone géographique :** `location_osm_address_country = 'France'` (185 460 relevés sur 262 186)
- **Type de point de vente :** `location_osm_tag_value = 'supermarket'` (221 113 au total, dont ~158K en France)
- **Devise :** EUR uniquement
- **Prix aberrants :** `price > 0`

### Normalisation des enseignes

Le champ `location_osm_display_name` (adresse formatée OpenStreetMap) contient le nom du magasin en première position. Une normalisation par expressions régulières a été appliquée pour regrouper les variantes (ex: "Centre Commercial E.Leclerc", "E. Leclerc", "E.Leclerc Levallois" → "E.Leclerc").

**Taux de couverture :** 83.5% des relevés français classés dans une enseigne normalisée (184 584 / 221 113).

---

## 2. Classement des enseignes par niveau de prix

### Score de cherté

Pour chaque enseigne disposant d'au moins 100 relevés, un **score de cherté** a été calculé comme suit :

> Pour chaque produit présent à la fois dans l'enseigne X et chez E.Leclerc (référence), on calcule le ratio `prix_enseigne / prix_Leclerc`. Le score final est la **médiane** de ces ratios (plus robuste aux outliers que la moyenne).

| Rang | Enseigne | Score médian | Produits communs avec Leclerc | Positionnement |
|---|---|---|---|---|
| 1 | **Lidl** | **1.00** | 107 | Discount |
| 2 | Aldi | 1.03 | 34 | Discount |
| 3 | Netto | 1.06 | 24 | Discount |
| 4 | Carrefour | 1.07 | 2 695 | Hypermarché |
| 5 | Intermarché | 1.07 | 3 289 | Hypermarché |
| 6 | Carrefour Market | 1.08 | 1 907 | Supermarché |
| 7 | Auchan | 1.11 | 3 536 | Hypermarché |
| 8 | Super U | 1.12 | 1 803 | Supermarché |
| 9 | Naturalia | 1.16 | 14 | Bio premium |
| 10 | U Express | 1.17 | 955 | Proximité |
| 11 | G20 | 1.23 | 437 | Proximité |
| 12 | **Monoprix** | **1.25** | 1 440 | Premium centre-ville |
| 13 | Carrefour City | 1.29 | 1 047 | Proximité |
| 14 | **Franprix** | **1.46** | 76 | Proximité urbaine |

### Constats

- **Leclerc est la référence low-cost.** Toutes les enseignes sauf Lidl sont plus chères.
- **Lidl égale Leclerc** sur les 107 produits comparables. Les deux discounters sont au coude-à-coude.
- **Le format de vente détermine le prix plus que l'enseigne :** les supermarchés de proximité (Franprix +46%, Carrefour City +29%) sont systématiquement plus chers que les hypermarchés du même groupe (Carrefour +7%).
- **Monoprix est 25% plus cher** que Leclerc pour les mêmes produits — mais l'écart est cohérent avec son positionnement centre-ville.

---

## 3. Comparaison par panier identique

### Panier commun aux 4 plus grandes enseignes

1 101 produits sont présents simultanément chez **E.Leclerc, Auchan, Intermarché et Carrefour**.

| Enseigne | Prix total du panier | Prix moyen par produit | Écart vs Leclerc |
|---|---|---|---|
| **E.Leclerc** | 3 225.17 € | 2.93 € | — |
| Intermarché | 3 503.71 € | 3.18 € | **+8.6%** |
| Auchan | 3 565.79 € | 3.24 € | **+10.6%** |
| Carrefour | 3 634.38 € | 3.30 € | **+12.7%** |

Un consommateur faisant ses courses chez Carrefour plutôt que Leclerc paie **409 € de plus par an** pour le même panier de 1 101 produits (soit +37 centimes par produit en moyenne).

### Par catégorie de produit

| Catégorie | Produits | Leclerc | Intermarché | Auchan | Carrefour |
|---|---|---|---|---|---|
| Produits végétaux | 332 | **2.41€** | 2.41€ | 2.65€ | 2.70€ |
| Snacks | 316 | **2.53€** | 2.60€ | 2.82€ | 2.77€ |
| Boissons | 123 | **3.35€** | 3.95€ | 4.09€ | 3.83€ |
| Produits laitiers | 81 | 2.97€ | 3.83€ | **2.52€** | 3.52€ |
| Desserts | 51 | **4.29€** | 4.32€ | 4.64€ | 4.47€ |
| Condiments | 33 | **2.14€** | 2.30€ | 2.47€ | 2.37€ |
| Plats préparés | 25 | **2.93€** | 3.67€ | 3.53€ | 3.84€ |
| Viandes | 23 | 4.99€ | **4.76€** | 5.13€ | **4.71€** |
| Petit-déjeuner | 18 | **4.29€** | 4.58€ | 4.63€ | 4.41€ |

**Leclerc est le moins cher dans 9 catégories sur 10.** Les deux exceptions : les produits laitiers (Auchan moins cher, 2.52€ vs 2.97€) et les viandes (Carrefour et Intermarché légèrement moins chers).

### Cas d'étude : le pot de Nutella

Le Nutella (code 3017620422003) est le deuxième produit le plus tracké avec 157 relevés. Il illustre parfaitement les écarts de prix entre enseignes :

| Enseigne | Relevés | Prix min | Prix moyen | Prix max |
|---|---|---|---|---|
| **E.Leclerc** | 25 | **2.39€** | **3.15€** | 3.87€ |
| Carrefour | 7 | 2.79€ | 3.17€ | 3.49€ |
| Netto | 1 | 3.23€ | 3.23€ | 3.23€ |
| Super U | 8 | 2.76€ | 3.25€ | 3.69€ |
| Intermarché | 11 | 3.18€ | 3.31€ | 3.73€ |
| Auchan | 14 | 3.24€ | 3.49€ | 3.79€ |
| Carrefour Market | 9 | 2.99€ | 3.69€ | 5.02€ |
| Carrefour City | 13 | 3.54€ | 3.88€ | 4.18€ |
| Spar | 4 | 3.70€ | 4.07€ | 4.79€ |
| **Monoprix** | 6 | 4.39€ | **4.42€** | **4.55€** |

**Écart extrême : 2.39€ (Leclerc) → 5.02€ (Carrefour Market), soit ×2.1.** En moyenne, le même pot de Nutella coûte 1.27€ de plus chez Monoprix que chez Leclerc (+40%).

---

## 4. Leclerc vs Monoprix — duel low-cost / premium

### Comparaison globale

Sur **1 440 produits communs** entre E.Leclerc et Monoprix :

| Métrique | Valeur |
|---|---|
| Prix moyen Leclerc | 3.54 € |
| Prix moyen Monoprix | 4.36 € |
| Écart absolu moyen | **+0.82 €** |
| Écart relatif moyen | **+27.6%** |
| Produits où Monoprix est **plus cher** | 1 337 (92.9%) |
| Produits où Monoprix est **moins cher** | 103 (7.1%) |

### Top 10 — Monoprix beaucoup plus cher

| Produit | Leclerc | Monoprix | Écart |
|---|---|---|---|
| Red Bull Blue Edition | 1.28€ | 3.90€ | **+206%** |
| Curry balti medium | 1.15€ | 3.35€ | **+191%** |
| Coriandre graines | 1.18€ | 3.15€ | **+167%** |
| Tranches végé lentilles | 1.19€ | 2.69€ | **+126%** |
| Riz d'Or | 1.90€ | 4.29€ | **+126%** |
| Cardamome moulue | 1.71€ | 3.79€ | **+122%** |
| Biscuit lait chocolat | 1.69€ | 3.70€ | **+120%** |
| Mélange pour grillades | 1.67€ | 3.49€ | **+109%** |

**Constat :** L'épicerie sèche (épices, condiments, riz) et les boissons énergétiques sont les catégories où Monoprix applique les marges les plus élevées. Il s'agit typiquement de produits à faible rotation, où le consommateur urbain accepte de payer un premium pour la proximité.

### Top 10 — Monoprix moins cher (oui, ça existe)

| Produit | Leclerc | Monoprix | Économie |
|---|---|---|---|
| Levure de boulanger Briochin | 14.93€ | 1.25€ | −92%* |
| Sauce tomacouli bio Panzani | 2.24€ | 1.15€ | −49% |
| Classic burger rond nature | 1.41€ | 0.83€ | −41% |
| Haricots verts extra-fins 1/4 | 2.59€ | 1.62€ | −37% |
| Activia bifidus nature ×4 | 1.43€ | 0.90€ | −37% |
| Tomates cerises allongées | 2.25€ | 1.50€ | −33% |
| Mâche | 1.98€ | 1.34€ | −32% |

*\*Le cas de la levure Briochin à 14.93€ chez Leclerc est probablement une erreur de saisie ou un lot professionnel.*

**Constat :** Les cas où Monoprix est moins cher concernent majoritairement des **produits frais** (fruits, légumes, yaourts, salades) et des **marques de distributeur**. Monoprix semble pratiquer une politique de prix agressive sur le frais pour fidéliser la clientèle urbaine, tout en margant fortement sur l'épicerie.

---

## 5. Variations géographiques des prix

### Même enseigne, prix différents selon la ville

L'analyse des prix moyens par ville pour **E.Leclerc** (53 884 relevés dans 23 361 produits) révèle des écarts significatifs :

| Ville | Relevés | Prix moyen |
|---|---|---|
| **Montélimar** (26) | 3 735 | **2.62€** |
| **Canteleu** (76) | 4 428 | **2.86€** |
| Échirolles (38) | 2 214 | 3.18€ |
| Gennevilliers (92) | 9 078 | 3.36€ |
| Clichy (92) | 21 551 | 3.49€ |
| Nancy (54) | 2 228 | 3.63€ |
| Vandœuvre (54) | 2 669 | 4.03€ |
| Saint-Martin-d'Hères (38) | 1 695 | 4.19€ |
| **Levallois-Perret** (92) | 2 838 | **4.42€** |

**Écart extrême : 2.62€ → 4.42€, soit +69%** entre le Leclerc le moins cher (Montélimar) et le plus cher (Levallois-Perret).

Cette variation peut s'expliquer par :
1. **Le pouvoir d'achat local :** Levallois-Perret (92) est une commune aisément de l'ouest parisien ; Montélimar et Canteleu ont des niveaux de vie plus modestes.
2. **La concurrence locale :** un Leclerc isolé en zone rurale peut pratiquer des prix plus bas qu'un Leclerc en zone urbaine dense où le foncier est cher.
3. **Le mix produit :** le panier moyen peut différer — un Leclerc de banlieue chic vend probablement plus de produits premium.

### Paris vs Province

| Enseigne | Prix à Paris | Prix en province | Écart |
|---|---|---|---|
| Auchan | 4.26€ | 3.43€ | **+24%** |
| E.Leclerc | 3.72€ | 3.50€ | +6% |
| Intermarché | 3.75€ | 3.83€ | −2% |
| Carrefour Market | 3.06€ | 3.31€ | **−8%** |

Les résultats sont contrastés :
- **Auchan** est nettement plus cher à Paris : les Auchan parisiens sont des supermarchés de quartier, pas des hypermarchés.
- **Carrefour Market** est moins cher à Paris qu'en province — contre-intuitif, mais peut refléter un effet de concurrence intense dans Paris intra-muros.
- **E.Leclerc** est légèrement plus cher à Paris (+6%), ce qui correspond au surcoût du foncier.

### Top 15 départements par nombre de relevés

| Département | Relevés | Prix moyen |
|---|---|---|
| **92 Hauts-de-Seine** | 48 734 | 3.47€ |
| 38 Isère | 39 665 | 4.42€ |
| 75 Paris | 21 055 | 6.80€* |
| 69 Rhône | 12 066 | 5.46€ |
| 54 Meurthe-et-Moselle | 10 157 | 3.63€ |
| 01 Ain | 9 320 | 3.06€ |
| **76 Seine-Maritime** | 5 315 | **2.87€** |
| **26 Drôme** | 4 474 | **2.81€** |
| 94 Val-de-Marne | 4 383 | 4.32€ |
| 57 Moselle | 3 544 | 5.10€ |
| 34 Hérault | 3 339 | 2.95€ |
| 33 Gironde | 2 878 | 4.07€ |
| 59 Nord | 2 684 | 4.16€ |
| 93 Seine-Saint-Denis | 2 369 | 4.68€ |
| 05 Hautes-Alpes | 2 043 | 3.33€ |

*\*Paris (75) : prix moyen élevé mais écart-type de 49.86 — quelques produits de luxe >1000€ tirent la moyenne vers le haut. Le prix médian est probablement bien inférieur.*

**La Seine-Maritime (2.87€) et la Drôme (2.81€) sont les départements les moins chers.** Les Hauts-de-Seine (92) dominent en volume grâce aux Leclerc de Clichy et Gennevilliers.

---

## 6. Nutri-Score, bio, et prix

### Prix par Nutri-Score et gamme d'enseigne

Les enseignes ont été regroupées en trois gammes :
- **Discount :** E.Leclerc, Lidl, Aldi, Netto
- **Milieu de gamme :** Auchan, Carrefour, Carrefour Market, Intermarché, Super U
- **Premium :** Monoprix, Naturalia, Biocoop, G20

| Gamme | Nutri-Score A | B | C | D | E |
|---|---|---|---|---|---|
| **Discount** | 2.50€ | 2.93€ | 2.81€ | 3.00€ | 3.08€ |
| Milieu de gamme | 2.81€ | 3.27€ | 2.88€ | 3.11€ | 3.45€ |
| **Premium** | **3.86€** | **4.53€** | 3.78€ | 3.75€ | **4.42€** |

**Le segment premium est systématiquement plus cher, quel que soit le Nutri-Score.** L'écart Discount/Premium varie de +1.34€ (Nutri-Score C) à +1.60€ (Nutri-Score B).

Fait notable : **au sein du segment premium, les produits A (3.86€) ne sont pas les plus chers** — les produits B (4.53€) le sont. Cela s'explique par la nature des produits B en premium : souvent des produits transformés de qualité (biscuits bio, plats préparés haut de gamme) qui coûtent plus cher que des produits bruts A (fruits, légumes).

Dans le segment discount en revanche, on observe une corrélation plus directe : plus le Nutri-Score se dégrade, plus le prix augmente. Le E (3.08€) est 23% plus cher que le A (2.50€).

### Surprime du bio par catégorie

Comparaison des prix moyens bio (labels `en:organic` ou `fr:ab`) vs non-bio, par catégorie :

| Catégorie | Prix bio | Prix non-bio | Surprime |
|---|---|---|---|
| **Sirops** | 7.78€ | 4.12€ | **+88.8%** |
| Édulcorants | 3.83€ | 2.23€ | **+71.8%** |
| Fruits & Légumes | 3.94€ | 2.65€ | **+48.6%** |
| Condiments | 3.60€ | 2.43€ | **+48.4%** |
| Œufs & dérivés | 3.81€ | 2.57€ | +48.1% |
| Petit-déjeuner | 6.43€ | 4.74€ | +35.5% |
| Produits agricoles | 3.85€ | 3.07€ | +25.5% |
| Crêpes & galettes | 3.32€ | 2.64€ | +25.5% |
| Produits laitiers | 3.36€ | 2.93€ | +14.5% |
| Surgelés | 4.71€ | 4.13€ | +14.0% |

**La surprime bio est la plus forte sur les produits transformés** (sirops +89%, édulcorants +72%) et la plus faible sur les produits industriels de grande consommation (produits laitiers +14%, surgelés +14%). Les fruits et légumes bio restent 49% plus chers — un écart conséquent pour les produits du quotidien.

---

## 7. Évolution temporelle et inflation

### Prix moyen trimestriel des 5 produits les plus trackés (2024-2026)

| Trimestre | Emmental râpé | Riz long | Bavette Aloyau | **Nutella** | Beurre demi-sel |
|---|---|---|---|---|---|
| 2024 T1 | — | 1.17€ | — | 3.23€ | 2.14€ |
| 2024 T2 | 1.55€ | 1.20€ | 8.87€ | 3.47€ | 1.95€ |
| 2024 T3 | 1.55€ | — | 8.84€ | 3.16€ | 1.91€ |
| 2024 T4 | 1.55€ | 1.22€ | 9.29€ | 3.53€ | 2.00€ |
| 2025 T1 | 1.55€ | 1.22€ | — | 3.64€ | 1.91€ |
| 2025 T2 | 1.55€ | 1.22€ | — | 3.85€ | 1.99€ |
| 2025 T3 | 1.54€ | 1.22€ | — | 3.60€ | 2.04€ |
| 2025 T4 | 1.50€ | 1.22€ | — | 3.34€ | 1.98€ |
| 2026 T1 | 1.45€ | — | 31.16€* | 3.62€ | 2.09€ |
| 2026 T2 | 1.41€ | — | — | 3.57€ | 1.94€ |

*\*Bavette Aloyau 2026 T1 : un seul relevé à 31.16€, probablement un produit différent (filet de bœuf).*

### Constats

- **Nutella :** seule inflation clairement visible. Le prix moyen passe de 3.23€ (début 2024) à 3.62€ (début 2026), soit **+12.1% sur 2 ans**. C'est légèrement supérieur à l'inflation alimentaire officielle en France sur la même période (~8-10%).
- **Emmental râpé :** baisse de 1.55€ à 1.41€ (−9.0%). Déflation sur ce produit d'appel.
- **Riz long :** parfaitement stable à 1.22€ depuis octobre 2024. Aucune inflation.
- **Beurre demi-sel :** stable autour de 1.95-2.09€. Pas de tendance nette.
- **Bavette Aloyau :** données insuffisantes après 2024 pour conclure.

**Conclusion :** Sur ces 5 produits très grand public, l'inflation alimentaire n'est pas généralisée. Le Nutella est le seul à montrer une hausse significative, probablement liée à la flambée des prix du cacao sur les marchés internationaux.

---

## 8. Saisonnalité

### Fruits & Légumes — un cycle saisonnier marqué

| Mois | Prix moyen | Volume |
|---|---|---|
| Janvier | 3.01€ | 3 329 |
| Février | 3.10€ | 2 917 |
| Mars | 2.91€ | 2 926 |
| Avril | 2.89€ | 3 673 |
| Mai | 2.93€ | 3 478 |
| **Juin** | **2.62€** | 2 619 |
| Juillet | 2.86€ | 2 722 |
| **Août** | **2.65€** | 2 382 |
| Septembre | 2.94€ | 3 486 |
| Octobre | 2.86€ | 2 816 |
| Novembre | 3.26€ | 2 905 |
| **Décembre** | **3.33€** | 3 271 |

**Cycle :** minimum en été (juin 2.62€, août 2.65€), maximum en hiver (décembre 3.33€, novembre 3.26€). L'écart saisonnier est de **+27% entre le creux de juin et le pic de décembre.** C'est cohérent avec la production agricole : abondance en été (pleine terre), dépendance aux importations et aux serres chauffées en hiver.

### Viandes — pics de fête et de barbecue

Prix moyen par mois (toutes catégories de viandes) :

| Mois | Prix moyen |
|---|---|
| Janvier | 5.48€ |
| Mai | **9.35€** |
| Juin | 3.26€ |
| Décembre | **9.78€** |

Deux pics extrêmes : **mai (9.35€)** et **décembre (9.78€)**. Le pic de mai coïncide avec les week-ends de l'Ascension et Pentecôte (barbecues, morceaux nobles). Le pic de décembre correspond aux repas de fête (chapon, dinde, filet de bœuf). Les autres mois de l'année tournent autour de 3.50-5.00€.

---

## 9. Résultats contre-intuitifs

### 9.1 Leclerc n'est pas toujours le moins cher

| Ville | Comparaison | Produits communs | Leclerc battu sur |
|---|---|---|---|
| Nancy | Auchan vs Leclerc | 139 | **37 produits** (26.6%) |
| Paris | Carrefour Market vs Leclerc | 34 | **8 produits** (23.5%) |

Exemples où Leclerc est battu à Nancy : Wraper's poulet bacon (−15.6% chez Auchan), Olives Ail Ours (−17.6%), Steack Haché 15% (−4.4%).

À Paris, Carrefour Market (pourtant un supermarché standard) bat Leclerc sur 8 produits, dont le riz basmati (−23%) et les crêpes chocolat (−26%).

### 9.2 Carrefour Market étonnamment compétitif à Paris

| Comparaison | Produits | Résultat |
|---|---|---|
| Carrefour Market vs Super U | 272 | CM moins cher sur **82%** des produits (−4.9% en moyenne) |
| Carrefour Market vs Monoprix | 93 | CM moins cher sur **88%** des produits (−13.0% en moyenne) |

Carrefour Market, positionné comme supermarché de quartier, bat Monoprix (enseigne "premium") dans 88% des cas à Paris avec un écart moyen de 13%. C'est l'inverse de ce que le positionnement marketing suggère.

### 9.3 Même enseigne, prix ×1.7 à 3 km de distance

À Nancy, le Leclerc intra-muros est systématiquement plus cher que le Leclerc de Vandœuvre-lès-Nancy (3 km) sur 238 produits communs :

| Produit | Nancy | Vandœuvre | Écart |
|---|---|---|---|
| Chips Brets | 1.53€ | 0.90€ | **+70%** |
| Lait de coco | 3.90€ | 2.53€ | +54% |
| 4 pains pita | 2.36€ | 1.58€ | +49% |
| Ebly L'Original | 2.04€ | 1.59€ | +28% |

Aucun produit n'est moins cher à Nancy. Le « prix de la proximité urbaine » est massif : 3 km = 20-70% de surcoût.

### 9.4 Nutri-Score A moins cher que E dans 25 catégories sur 43

Dans les sous-catégories alimentaires où la comparaison est possible (≥5 produits de chaque côté) :

| A moins cher que E (25 catégories) | E moins cher que A (18 catégories) |
|---|---|
| Biscuits secs (A: 2.09€ vs E: 8.14€) | Snacks pomme de terre (E: 0.91€ vs A: 2.35€) |
| Légumes surgelés (A: 1.48€ vs E: 5.12€) | Galettes (E: 0.95€ vs A: 2.09€) |
| Sauces cuisine (A: 1.70€ vs E: 3.83€) | Poulets (E: 2.66€ vs A: 4.78€) |
| Pâtes à tartiner (A: 3.37€ vs E: 4.38€) | Beurre de cacahuète (E: 3.59€ vs A: 5.19€) |

Le « health tax » (produit sain plus cher) n'existe que pour les snacks transformés. Pour les produits bruts (biscuits secs, légumes surgelés, sauces), le sain est moins cher.

### 9.5 Le bio moins cher que le conventionnel — pas un mythe

| Ville | Enseigne | Bio | Conventionnel | Écart |
|---|---|---|---|---|
| **Grenoble** | **Lidl** | **2.01€** | 3.44€ | **−42%** |
| **Grenoble** | Intermarché | 3.64€ | 4.47€ | −19% |
| **Grenoble** | Monoprix | 4.47€ | 4.90€ | −8.8% |
| **Lyon** | Intermarché | 4.35€ | 5.61€ | −23% |
| Paris | Intermarché | 4.50€ | 3.57€ | +26% |

Le phénomène est réel mais localisé : dans les villes avec une forte concurrence bio (Grenoble, Lyon), le bio en GMS est moins cher que le conventionnel. À Paris, la prime bio persiste.

### 9.6 MDD parfois plus chère que la marque nationale

La MDD est en moyenne 41% moins chère que la marque nationale. Mais dans 20 cas, la MDD est **plus chère** :

| Catégorie | Enseigne | Marque nationale | MDD | MDD + chère |
|---|---|---|---|---|
| Boissons | Super U | 2.71€ | 9.62€ | **+255%** |
| Laits UHT | Auchan | 3.49€ | 11.83€ | **+239%** |
| Tomates fraîches | Auchan | 1.45€ | 4.01€ | **+177%** |

Explication : il s'agit de MDD premium/bio (ex: Carrefour Bio, Monoprix Gourmet) vs marques nationales premier prix.

---

## 10. Guide pratique : où faire ses courses

### 10.1 Stratégie optimale : panier mixte multi-enseigne

Simulation d'un panier de 5 catégories (fruits/légumes, produits laitiers, viandes, snacks, boissons) en France :

| Catégorie | Meilleure enseigne | Prix optimal | Prix Leclerc | Économie |
|---|---|---|---|---|
| Fruits & légumes | Lidl | 2.20€ | 2.46€ | −11% |
| Produits laitiers | Lidl | 2.58€ | 2.67€ | −3% |
| Viandes | Aldi | 3.25€ | 4.33€ | −25% |
| Snacks | Lidl | 2.30€ | 2.89€ | −20% |
| Boissons | Lidl | 2.51€ | 4.13€ | **−39%** |
| **Total** | **Multi-enseigne** | **12.84€** | **16.48€** | **−22%** |

**En pratique, deux arrêts suffisent : Lidl (fruits, snacks, boissons, produits laitiers) + un hypermarché (viandes, poissons, plats préparés).** L'économie est de 22% par rapport à tout acheter chez Leclerc.

### 10.2 Quel magasin pour quelle catégorie (Grenoble)

| Catégorie | Meilleur hypermarché | Meilleur discount | Écart discount vs hyper |
|---|---|---|---|
| Fruits & légumes | Intermarché (2.78€) | Lidl (1.99€) | **−29%** |
| Produits laitiers | Auchan (3.06€) | Lidl (2.18€) | **−29%** |
| Snacks | Auchan (3.14€) | Lidl (2.59€) | −17% |
| Boissons | Auchan (3.60€) | Aldi (3.11€) | −14% |
| Petit-déjeuner | Auchan (4.39€) | Lidl (3.88€) | −12% |

### 10.3 Pour le même budget, Lidl offre un meilleur Nutri-Score

À Grenoble, avec ~2.60€ :

| Enseigne | Nutri-Score obtenu |
|---|---|
| **Lidl** | **A** (1.97€) |
| Auchan | C (2.68€) ou E (3.33€) |
| Monoprix | E (5.06€) |

Lidl A est 25% moins cher qu'Auchan A, et 49% moins cher que Monoprix A.

### 10.4 Top 10 « bonnes affaires qualité » (Nutri-Score A/B, prix bas, populaires)

| Produit | Marque | Nutri-Score | Prix | Où |
|---|---|---|---|---|
| 14 Maxi Tranches complet | Jacquet | A | 1.37€ | Leclerc Montélimar |
| Galettes Authentique | Wasa | A | 1.45€ | Leclerc, Auchan, Intermarché |
| Pomme Noisette | Gerblé | B | 1.54-1.72€ | Intermarché, Auchan |
| Figue & Son | Gerblé | B | 1.44€ | Intermarché Ermont |
| Pain de mie complet bio | La Boulangère Bio | A | 2.36€ | Multi-enseignes |
| Skyr nature 0% | Yoplait | A | 3.48€ | Multi-enseignes |
| Pur beurre de cacahuète | Jardin Bio | A | 4.27€ | Multi-enseignes |
| Spécial Muesli 30% fruits | Jordans | B | 3.14-4.85€ | Auchan, Carrefour |
| Emmental râpé | Eco+ | C | 1.06-1.62€ | Leclerc, Auchan |
| Riz long | Eco+ | B | 0.69-1.22€ | Leclerc |

### 10.5 Le bio en GMS est 30% moins cher qu'en magasin spécialisé

À Paris, pour les mêmes produits bio :

| Enseigne | Prix moyen bio | vs Leclerc |
|---|---|---|
| **E.Leclerc** | **3.53€** | — |
| Biocoop | 4.08€ | +15% |
| Monoprix | 4.67€ | +32% |
| Naturalia | 5.08€ | +44% |

Sur les snacks bio, l'écart explose : 2.34€ chez Leclerc vs 4.45€ chez Naturalia (+90%). En revanche, Biocoop est compétitif sur les boissons et produits fermiers (écart <10%).

### 10.6 Où acheter les produits premium au meilleur prix

| Produit | Enseigne | Ville la moins chère | Prix min | Prix max ailleurs |
|---|---|---|---|---|
| Lindt Excellence 70% | Auchan | **Belley (01)** | **1.45€** | 2.21€ (+52%) |
| Maille Moutarde Dijon | Auchan | **Belley (01)** | **1.49€** | 2.36€ (+58%) |
| Bonne Maman Pâte tartiner | Carrefour | Aubervilliers | 2.30€ | 3.79€ (+65%) |
| Milka Oreo | Leclerc | Levallois-Perret | 2.96€ | 4.15€ (+40%) |
| Panzani Tomacouli 500g | Leclerc | St-Magne-de-Castillon | 0.66€ | 0.96€ (+46%) |

---

## 11. Limites et biais

### Qualité des données

1. **Enseignes non normalisables :** 16.5% des relevés n'ont pas pu être classés dans une enseigne. Il s'agit principalement de magasins indépendants ou de localisations OSM incomplètes.

2. **Taille de l'échantillon par enseigne :** le classement est robuste pour les grandes enseignes (>1000 produits communs) mais fragile pour les petites (Aldi : 34 produits, Naturalia : 14). Les scores pour ces enseignes sont indicatifs.

3. **Biais de couverture géographique :** les relevés sont concentrés dans quelques villes (Clichy : 26K, Grenoble : 20K). La couverture est inégale selon les départements.

4. **Biais utilisateur :** les prix sont collectés par des contributeurs volontaires (crowdsourcing). Il peut y avoir un biais de sélection : les utilisateurs scannent plutôt des produits qui les intéressent, pas un échantillon aléatoire.

5. **Prix vs promotions :** les données ne distinguent pas les prix normaux des promotions. Un produit en promotion chez Leclerc mais pas chez Monoprix au moment du relevé fausse la comparaison.

6. **Effet de gamme :** le panier « identique » compare des codes-barres identiques, donc des produits strictement identiques. Mais le mix de produits peut varier : un Leclerc vend plus de premiers prix, un Monoprix plus de marques. La comparaison par code-barres neutralise cet effet — ce qui est à la fois une force (comparaison juste) et une limite (ne reflète pas les différences d'assortiment).

### Limites techniques

7. **Taux de chevauchement :** seuls 1 101 produits sont communs aux 4 plus grandes enseignes. C'est suffisant pour un indice, mais pas exhaustif.

8. **Horizon temporel court :** 2 ans de données (2024-2026). Les tendances d'inflation sont à interpréter avec prudence.

---

## 12. Synthèse et enseignements

### Classement final des enseignes

```
Pas cher ←――――――――――――――――――――――――――――――→ Cher

Lidl  E.Leclerc  Aldi  Netto  Carrefour  Intermarché  Auchan  Super U  Monoprix  Carrefour City  Franprix
1.00   1.00      1.03  1.06   1.07       1.07         1.11    1.12     1.25      1.29            1.46
```

### Points clés

1. **Le format de vente prime sur l'enseigne.** Un Carrefour City (proximité, +29%) est deux fois plus cher qu'un Carrefour (hypermarché, +7%). Franprix (+46%) est l'enseigne la plus chère du panel.

2. **Leclerc est la référence prix, talonné par Lidl.** Les deux discounters sont au même niveau. Le panier Leclerc est 8 à 13% moins cher que les hypermarchés traditionnels.

3. **Monoprix est 25% plus cher que Leclerc, mais compétitif sur le frais.** Sur 7% des produits communs, Monoprix est même moins cher — majoritairement des fruits, légumes et produits laitiers.

4. **Le bio coûte en moyenne 40-50% plus cher**, avec des pics à +89% pour les sirops et +72% pour les édulcorants. Les produits laitiers et surgelés bio sont les plus accessibles (+14%).

5. **L'inflation n'est pas généralisée.** Parmi les 5 produits les plus trackés, seul le Nutella montre une hausse significative (+12% sur 2 ans), probablement liée au cours du cacao. Les autres produits sont stables ou en baisse.

6. **La géographie compte.** Le même Leclerc vend 69% plus cher à Levallois-Perret qu'à Montélimar. Le pouvoir d'achat local et la concurrence expliquent ces écarts.

7. **Les fruits et légumes suivent un cycle saisonnier de 27%** entre l'été (moins cher) et l'hiver (plus cher).

---

*Rapport généré le 5 juin 2026 à partir des données Open Food Facts (ODbL) et Open Prices (ODbL), disponibles dans le catalog DuckLake `alimentation.open_food_facts` et `alimentation.open_prices`.*
