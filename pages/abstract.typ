#import "@preview/isc-hei-bthesis:0.8.1": *
#import "@preview/acrostiche:0.7.0": *

#page-title("Abstract")

#v(1fr)

As #link("https://en.wikipedia.org/wiki/Functional_magnetic_resonance_imaging")[#acr("fMRI")] pipelines become more computationally intensive, requiring high-dimensional computations, it is crucial to assess how small numerical variability introduced by factors such as the running #link("https://en.wikipedia.org/wiki/Operating_system")[#acr("OS")], parallelization strategies, and hardware architecture affects the results of these pipelines.

Building upon the paper "Numerical Variability of #acr("fMRI") Graph Measures" #super[@Alizadeh2025.12.22.695524], this work reproduces the original analysis on a different multi-site dataset and extends the assessment beyond graph measures. It evaluates the impact of numerically perturbed fMRIPrep preprocessing on #acr("FC") matrices using the #acr("NPVR") metric, including the effect of global signal regression, and examines #link("https://en.wikipedia.org/wiki/Major_depressive_disorder")[#acr("MDD")] biomarkers, specifically those based on #link("https://en.wikipedia.org/wiki/Principal_component_analysis")[#acr("PCA")] proposed by Yamashita et al., 2026 #super[#cite(label("10.1162/IMAG.a.1121"))].

To reproduce the findings of the original study, the results were obtained by running the fMRIPrep #super[@fMRIPrep] (25.2.5) preprocessing pipeline on a different multi-site dataset through a #link("https://hub.docker.com/r/madeinshinea/fuzzy-fmriprep", [custom Docker container]) with floating-point arithmetic perturbations introduced by #link("https://github.com/verificarlo/verificarlo", "Verificarlo") #super[@denis2018verificarlocheckingfloatingpoint] and #link("https://github.com/verificarlo/fuzzy", "Fuzzy") #super[@greg_kiar_2026_20906259]. After preprocessing, 15 confounds instead of 6 were applied, as the data appeared noisier, and #acr("FC") matrices were obtained using Nilearn #super[@Nilearn] (0.13.1) with different absolute thresholds applied. Graph metrics were then computed using NetworkX #super[@SciPyProceedings_11] (3.6.1).

 The graph metrics assessment showed consistent trends, though with higher #acr("NPVR") values, and revealed that applying more confounds increases the #acr("NPVR") as well as the variability of this effect across thresholds. The edge-wise #acr("FC") analysis extended this work by quantifying numerical noise at the individual connection level and comparing the effect of including versus excluding the global signal confound. This comparison revealed substantial variability (mean #acr("NPVR") of approximately 11% with all confounds), and was more than doubled when the global signal confound was excluded.

The #acr("PCA") feature selection was applied to the complete SRPB and BMB datasets rather than solely a split version of the SRPB dataset as in the original study. To assess its numerical stability, two steps of the pipeline were perturbed: the correlation coefficient computation using a #link("https://hub.docker.com/layers/verificarlo/fuzzy/v2.5.1-lapack-python3.12.13-numpy-scipy-sklearn/images/sha256-5fd0dff51fd585689ec2ab200c38f89c3cb58138a4604d41c92849ec8e619f5c", [specific Fuzzy Docker image]), and the principal component analysis by forcing it to use 32-bit floating-point inputs rather than 64-bit.

Although the specific biomarkers selected differ between datasets, they consistently originate from the same brain regions (prefrontal, motor, and subcortical networks), though their relative importance varies. The #acr("PCA") feature extraction proved to be highly stable under the introduced numerical perturbations, yielding identical results across all perturbed runs within each dataset. These findings suggest that the #acr("PCA") features extraction is not only stable across different imaging sites and datasets, but also robust to numerical variability, supporting its reliability for clinical applications.

#abstract-footer("en")
