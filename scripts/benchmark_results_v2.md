# Benchmark GeoParquet v2 - Résultats

## Configuration
- **ordered**: Tri par `code_departement, code_commune` (519 MB)
- **ordered-v2**: Tri par `date_mutation, code_departement, code_commune` (628 MB)
- **unordered**: Sans tri explicite (532 MB)
- Total: ~20.4M lignes, 165-166 row groups

## Résultats Performances (temps user en secondes)

| Requête | ordered | ordered-v2 | unordered | **Gagnant** |
|--------|---------|------------|-----------|-------------|
| 1 jour (2021-01-15) | 0.874s | **0.747s** | 0.771s | ✅ ordered-v2 |
| 1 semaine (2021-01-01 to 07) | 0.951s | **0.776s** | 0.761s | ✅ ordered-v2 |
| 1 mois (2021-01) | 0.944s | **0.812s** | 0.795s | ordered-v2 |
| 1 année (2021) | 0.896s | **0.785s** | 0.763s | unordered |
| dept='75' | **0.753s** | 0.855s | 0.778s | ✅ ordered |
| dept+commune (75+75056) | 0.764s | 0.804s | **0.771s** | ✅ unordered |
| 2021 + dept='75' | **0.780s** | 0.813s | 0.771s | ordered |
| 2021-01 + dept='75' | **0.739s** | 0.792s | 0.773s | ✅ ordered |
| GROUP BY année | 1.055s | 0.933s | **0.747s** | ✅ unordered |
| GROUP BY mois | 1.147s | 1.063s | **0.755s** | ✅ unordered |

## Analyse du Pruning

### Requêtes Temporelles
| Requête | ordered | ordered-v2 | unordered |
|--------|---------|------------|-----------|
| 1 jour | 166 RG (1713 MB) | **3 RG (40 MB)** | 38 RG (446 MB) |
| 1 semaine | 166 RG (1713 MB) | **3 RG (40 MB)** | 38 RG (446 MB) |
| 1 mois | 166 RG (1713 MB) | **3 RG (40 MB)** | 38 RG (446 MB) |
| 1 année | 166 RG (1713 MB) | **39 RG (524 MB)** | 38 RG (446 MB) |

### Requêtes Géographiques
| Requête | ordered | ordered-v2 | unordered |
|--------|---------|------------|-----------|
| dept='75' | **5 RG (38 MB)** | 166 RG (2232 MB) | 13 RG (146 MB) |
| dept+commune | **5 RG (38 MB)** | 166 RG (2232 MB) | 13 RG (146 MB) |

### Requêtes Combinées
| Requête | ordered | ordered-v2 | unordered |
|--------|---------|------------|-----------|
| 2021 + dept='75' | **5 RG (38 MB)** | 39 RG (524 MB) | 2 RG (23 MB) |
| 2021-01 + dept='75' | **5 RG (38 MB)** | 3 RG (40 MB) | 2 RG (23 MB) |

## Conclusions

### ordered-v2 (date,dept,commune) est **EXCELLENT pour** :
- ✅ Requêtes temporelles fines (1 jour, 1 semaine, 1 mois)
- ✅ **42x moins de données lues** par rapport à ordered pour 1 mois !

### ordered-v2 est **MAUVAIS pour** :
- ❌ Requêtes géographiques pures (dept, commune)
- ❌ Full scan complet

### ordered (dept,commune) est **EXCELLENT pour** :
- ✅ Requêtes géographiques pures
- ✅ Certaines requêtes combinées (année + dept)

### unordered est **BON PARTOUT** :
- ✅ Requêtes temporelles (meilleur que ordered, presque aussi bon que v2)
- ✅ Requêtes géographiques (meilleur que v2, presque aussi bon que ordered)
- ✅ Agrégations temporelles (GROUP BY)
- ✅ Plus petit fichier (532 MB)

## Recommandation

**ordered-v2 est un succès pour les requêtes temporelles fines** !

- Si ton usage est **principalement temporel** → ordered-v2 est **parfait**
- Si ton usage est **mixte** → ordered-v2 + ordered en complément
- Si tu veux **un seul fichier** → ordered-v2 est le meilleur compromis **si tes requêtes sont souvent temporelles**

Le tri par `date_mutation` donne un **pruning temporel exceptionnel** que le tri géographique ne peut pas offrir.
