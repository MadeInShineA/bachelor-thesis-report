#import "@preview/isc-hei-bthesis:0.8.0": *
#import "@preview/acrostiche:0.7.0": *

#page-title("Abstract")

#v(1fr)


- The context and motivation for the research.
- The main objective or research question.
- A brief description of the methodology or approach used.
- The key results or findings.
- The main conclusion or implications of the work.

The abstract should be self-contained, clear, and usually does not exceed 250–300 words. It allows readers to quickly understand the purpose and outcomes of the thesis without reading the full document.

The abstract *must* be written in both French and English.

#todo("Double check")

As #acr("fMRI") pipelines become more computationally heavy, requiring high-dimensional computations, it is crucial to assess how small numerical variability introduced by several different factors like the running #acr("OS"), parallelization strategies, and hardware architecture affects the results of these pipelines.


Building upon the paper "Numerical Variability of #acr("fMRI") Graph Measures" #super[@Alizadeh2025.12.22.695524], this work goes a step further than looking at different #acr("MRI") graph measures by also looking at #acr("MDD") biomarkers, specifically the #acr("PCA") based biomarkers proposed by the paper "Extraction of robust functional connectivity patterns across psychiatric disorders using principal component analysis-based feature selection" #super[#cite(label("10.1162/IMAG.a.1121"))] by perturbing several steps of the pipeline. It also assesses the impact of numerically perturbated fMRIPrep preprocessing on FC #acr("FC") matrices using the #acr("NPVR") metric.


To reproduce the results of the original study #super[@Alizadeh2025.12.22.695524], the results were obtained by running the fMRIPrep #super[@fMRIPrep] (25.2.5) preprocessing pipeline through a #link("https://hub.docker.com/r/madeinshinea/fuzzy-fmriprep", [custom Docker container]) with floating-point arithmetic perturbations introduced by the Verificarlo #super[@verificarlo] and Fuzzy #super[@fuzzy] libraries. After preprocessing, #acr("FC") matrices were obtained using Nilearn #super[@Nilearn] (0.13.1). Different absolute thresholds were applied to the #acr("FC") matrices, and graph metrics were computed using NetworkX #super[@SciPyProceedings_11] (3.6.1).

For the assessment of the #acr("PCA") feature selection, two steps of the pipeline were perturbated using a #link("https://hub.docker.com/layers/verificarlo/fuzzy/v2.5.1-lapack-python3.12.13-numpy-scipy-sklearn/images/sha256-5fd0dff51fd585689ec2ab200c38f89c3cb58138a4604d41c92849ec8e619f5c", [specific Fuzzy Docker image]), the correlation coefficient computation and principal component analysis.

The results given by the original work reproduction closely matched the original ones, except for a specific graph where the Y-axis values were hardcoded inside the original code. The #acr("PCA") feature extraction appeared to be very stable under the introduced numerical perturbations, simulating #acr("OS") level numerical variability. Giving the exact same results.

These findings suggest that the PCA features extraction is not only stable across different imaging sites and datasets, but also robust to numerical variability.


#abstract-footer("en")
