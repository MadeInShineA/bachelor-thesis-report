#import "@preview/isc-hei-bthesis:0.8.0" : *
#import "@preview/acrostiche:0.7.0": *

#page-title("Résumé")

#v(1fr)

Le résumé d’un mémoire de bachelor doit fournir un aperçu concis de l’ensemble du travail. Il inclut généralement :

- Le contexte et la motivation de la recherche.
- L’objectif principal ou la question de recherche.
- Une brève description de la méthodologie ou de l’approche utilisée.
- Les principaux résultats ou découvertes.
- La conclusion principale ou les implications du travail.

Le résumé doit être autonome, clair et ne pas dépasser habituellement 250 à 300 mots. Il permet aux lecteurs de comprendre rapidement le but et les résultats du mémoire sans lire l’intégralité du document.

Le résumé doit être rédigé en français *et* en anglais.

#reset-all-acronyms()

#todo("Double check")

Alors que les pipelines de prétraitement IRM deviennent de plus en plus lourdes en calculs, nécessitant des opérations de haute dimension, il est crucial d'évaluer comment une faible variabilité numérique introduite par plusieurs facteurs différents comme le #acr("SE") utilisé , les stratégies de parallélisation et l'architecture matérielle impactent le résultat du prétraitement.

S'inspirant de "Numerical Variability of functional MRI Graph Measures" Alizadeh2025#super[@Alizadeh2025.12.22.695524], ce travail va plus loin que les mesures de graphes IRM en examinant également les biomarqueurs du #acr("TDM").

Les différents résultats ont été obtenus en exécutant le pipeline de prétraitement fMRIPrep#super[@fMRIPrep] (v25.2.5) à travers un conteneur Docker personnalisé avec une des calculs à virgule flottante introduites par les bibliothèques Verificarlo#super[@verificarlo] et Fuzzy#super[@fuzzy]. Après le prétraitement, les #acr("FC") matrices ont été obtenues via Nilearn#super[@Nilearn] (v0.13.1). Des seuils absolus de 0.05, 0.1, 0.2, 0.3, 0.4, et 0.5 ont été appliqués aux #acr("FC") matrices, et les métriques de graphes ont été calculées avec NetworkX#super[@SciPyProceedings_11] (v3.6.1).

#todo("Add Biomarker section")

#todo("Add results section")

#todo("Add conclusion section")

#abstract-footer("fr")
