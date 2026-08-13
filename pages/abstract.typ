#import "@preview/isc-hei-bthesis:0.8.0": *
#import "@preview/acrostiche:0.7.0": *

#page-title("Abstract")

#v(1fr)

#todo("Double check")

As #link("https://en.wikipedia.org/wiki/Functional_magnetic_resonance_imaging")[#acr("fMRI")] pipelines become more computationally heavy, requiring high-dimensional computations, it is crucial to assess how small numerical variability introduced by several different factors like the running #link("https://en.wikipedia.org/wiki/Operating_system")[#acr("OS")], parallelization strategies, and hardware architecture affects the results of these pipelines.


Building upon the paper "Numerical Variability of #link("https://en.wikipedia.org/wiki/Magnetic_resonance_imaging")[#acr("MRI")] Graph Measures" #super[@Alizadeh2025.12.22.695524], this work goes a step further than looking at different #acr("MRI") graph measures by also looking at #link("https://en.wikipedia.org/wiki/Major_depressive_disorder")[#acr("MDD")] biomarkers, specifically the #link("https://en.wikipedia.org/wiki/Principal_component_analysis")[#acr("PCA")] based biomarkers proposed by the paper "Extraction of robust functional connectivity patterns across psychiatric disorders using principal component analysis-based feature selection" #super[#cite(label("10.1162/IMAG.a.1121"))] by perturbing several steps of the pipeline. It also assesses the impact of numerically perturbated fMRIPrep preprocessing on FC #acr("FC") matrices using the #acr("NPVR") metric.


To reproduce the results of the original study #super[@Alizadeh2025.12.22.695524], the results were obtained by running the fMRIPrep #super[@fMRIPrep] (25.2.5) preprocessing pipeline through a #link("https://hub.docker.com/r/madeinshinea/fuzzy-fmriprep", [custom Docker container]) with floating-point arithmetic perturbations introduced by the #link("https://github.com/verificarlo/verificarlo", "Verificarlo") #super[@denis2018verificarlocheckingfloatingpoint] and #link("https://github.com/verificarlo/fuzzy", "Fuzzy") #super[@greg_kiar_2026_20906259] libraries. After preprocessing, #acr("FC") matrices were obtained using Nilearn #super[@Nilearn] (0.13.1). Different absolute thresholds were applied to the #acr("FC") matrices, and graph metrics were computed using NetworkX #super[@SciPyProceedings_11] (3.6.1).

For the assessment of the #acr("PCA") feature selection, two steps of the pipeline were perturbated: the correlation coefficient computation using a #link("https://hub.docker.com/layers/verificarlo/fuzzy/v2.5.1-lapack-python3.12.13-numpy-scipy-sklearn/images/sha256-5fd0dff51fd585689ec2ab200c38f89c3cb58138a4604d41c92849ec8e619f5c", [specific Fuzzy Docker image]), and the principal component analysis by forcing it to use 32-bit floating-point inputs rather than 64-bit.

The results given by the original work reproduction closely matched the original ones, except for a specific graph where the Y-axis values were hardcoded inside the original code. The #acr("PCA") feature extraction appeared to be very stable under the introduced numerical perturbations, simulating #acr("OS") level numerical variability. Giving the exact same results.

These findings suggest that the PCA features extraction is not only stable across different imaging sites and datasets, but also robust to numerical variability.


#abstract-footer("en")
