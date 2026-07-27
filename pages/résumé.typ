#import "@preview/isc-hei-bthesis:0.8.0": *
#import "@preview/acrostiche:0.7.0": *

#page-title("Résumé")

#v(1fr)

#reset-all-acronyms()

#todo("Double check")

Alors que les pipelines d'#acr("IRMf") deviennent de plus en plus lourdes computationnellement, nécessitant des calculs en haute dimension, il est crucial d'évaluer comment de petites variations numériques introduites par plusieurs facteurs tels que le #acr("SE") utilisé, les stratégies de parallélisation et l'architecture matérielle affectent les résultats de ces dernières.

S'appuyant sur le papier « Numerical Variability of functional #acr("IRM") Graph Measures » #super[@Alizadeh2025.12.22.695524], ce travail va plus loin que l'examen de différentes mesures de graphes d'#acr("IRM") en examinant également les biomarqueurs du #acr("TDM"), notamment les biomarqueurs basés sur l'#acr("ACP") proposés par le papier "Extraction of robust functional connectivity patterns across psychiatric disorders using principal component analysis-based feature selection" #super[#cite(label("10.1162/IMAG.a.1121"))], en perturbant plusieurs étapes du pipeline. Il évalue également l'impact du prétraitement fMRIPrep numériquement perturbé sur les matrices de #acr("CF") en utilisant la métrique #acr("NPVR").

Pour reproduire les résultats de l'étude originale #super[@Alizadeh2025.12.22.695524], les résultats ont été obtenus en exécutant le pipeline de prétraitement fMRIPrep #super[@fMRIPrep] (25.2.5) dans un #link("https://hub.docker.com/r/madeinshinea/fuzzy-fmriprep", [conteneur Docker personnalisé]) avec des perturbations arithmétiques en virgule flottante introduites par les bibliothèques Verificarlo #super[@verificarlo] et Fuzzy #super[@fuzzy]. Après prétraitement, les matrices de #acr("CF") ont été obtenues à l'aide de Nilearn #super[@Nilearn] (0.13.1). Différents seuils absolus ont été appliqués aux matrices de #acr("CF"), et les métriques de graphes ont été calculées à l'aide de NetworkX #super[@SciPyProceedings_11] (3.6.1).

Pour l'évaluation de la sélection de caractéristiques par #acr("ACP"), deux étapes du pipeline ont été perturbées à l'aide d'une #link("https://hub.docker.com/layers/verificarlo/fuzzy/v2.5.1-lapack-python3.12.13-numpy-scipy-sklearn/images/sha256-5fd0dff51fd585689ec2ab200c38f89c3cb58138a4604d41c92849ec8e619f5c", [image Docker Fuzzy spécifique]) le calcul des coefficients de corrélation et l'analyse en composantes principales.

Les résultats de la reproduction de l'étude originale correspondent étroitement aux résultats originaux, à l'exception d'un graphe spécifique dont les valeurs de l'axe Y étaient codées en dur dans le code original. L'extraction de caractéristiques par #acr("ACP") s'est avérée très stable sous les perturbations numériques introduites, simulant la variabilité numérique au niveau du #acr("SE"), tout en produisant des résultats strictement identiques.

Ces résultats suggèrent que l'extraction de caractéristiques par #acr("ACP") est non seulement stable entre différents sites d'imagerie et jeux de données, mais également robuste face à la variabilité numérique.

#abstract-footer("fr")
