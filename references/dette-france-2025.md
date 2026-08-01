# Dette et taux français — édition 2025

Cette édition sépare les comptes annuels 2025, publiés par l’Insee le 29 mai 2026, de la mise à jour trimestrielle 2026 et du millésime de marché des OAT au 1er août 2026.

La série 2019–2025 sert à visualiser les évolutions. Pour préserver le repère de l’édition, l’intérêt 2025 est celui publié par l’Insee hors correction SIFIM ; les années précédentes reprennent le poste D41 des comptes APU.

## Sources

- [Comptes des administrations publiques](https://www.data.gouv.fr/datasets/comptes-des-administrations-publiques) et [publication Insee 2025](https://www.insee.fr/fr/statistiques/8997691) : série annuelle 2019–2025. La dette et le PIB historiques sont rapprochés des T4 Insee ; déficit et intérêts viennent des comptes annuels APU. Les sous-secteurs détaillés restent limités à 2025.
- [Dette trimestrielle Maastricht](https://www.insee.fr/fr/statistiques/2830301) : encours et ratio au PIB jusqu’au premier trimestre 2026.
- [Eurostat, taux à dix ans](https://ec.europa.eu/eurostat/databrowser/view/irt_lt_mcby_m/default/table) : moyenne annuelle des observations mensuelles 2019–2025.
- [Rapport d’activité 2025 de l’AFT](https://www.aft.gouv.fr/fr/publications/communiques-presse/07072026-lagence-france-tresor-publie-son-rapport-dactivite-2025) et pages d’encours [OAT](https://www.aft.gouv.fr/fr/encours-detaille-oat), [OATi](https://www.aft.gouv.fr/fr/encours-detaille-oati), [OAT€i](https://www.aft.gouv.fr/fr/encours-detaille-oatei).

Le site AFT étant protégé par Cloudflare pour les clients automatisés, le script récupère une représentation texte de ces pages via `r.jina.ai`. Le manifeste conserve l’URL officielle, l’URL effectivement téléchargée et son SHA-256.

## Contrôles de référence

| Indicateur | Publié | Recalculé |
|---|---:|---:|
| Dette fin 2025 | 3 460,5 Md€ | 3 460,5 Md€ |
| Dette / PIB | 115,7 % | 115,69 % |
| Déficit 2025 | 152,5 Md€ | 152,5 Md€ |
| Déficit / PIB | 5,1 % | 5,10 % |

La génération échoue au-delà de 0,1 point ou 0,1 Md€. Elle contrôle aussi les schémas, les périodes trimestrielles uniques, les valeurs obligatoires, les ISIN uniques et la somme des quatre sous-secteurs.

Le taux apparent est calculé comme `intérêts 2025 / moyenne(dette fin 2024, dette fin 2025)`. Le coupon des OAT n’est jamais présenté comme le coût de la dette. Aucune projection de charge à 2029 n’est produite.
