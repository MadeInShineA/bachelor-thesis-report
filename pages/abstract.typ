#import "@preview/isc-hei-bthesis:0.8.0" : *
#import "@preview/acrostiche:0.7.0": *

#page-title("Abstract")

#v(1fr)

The abstract of a bachelor thesis should provide a concise summary of the entire work. It typically includes:

- The context and motivation for the research.
- The main objective or research question.
- A brief description of the methodology or approach used.
- The key results or findings.
- The main conclusion or implications of the work.

The abstract should be self-contained, clear, and usually does not exceed 250–300 words. It allows readers to quickly understand the purpose and outcomes of the thesis without reading the full document.

The abstract *must* be written in both French and English.

As fMRI preprocessing pipelines become more computationally heavy, requiring high-dimensional computations, it is crucial to assess how small numerical variability introduced by several different factors like the running #acr("OS"), parallelization strategies, and hardware architecture impacts the result of the preprocessing.

Taking inspiration from "Numerical Variability of functional #acr("MRI") Graph Measures" Alizadeh2025#super[@Alizadeh2025.12.22.695524], this work goes a step further than MRI graph measures by also looking at #acr("MDD") biomarkers.


The different results were obtained by running the fMRIPrep#super[@fMRIPrep] (25.2.5) preprocessing pipeline through a custom Docker container with floating-point arithmetic perturbations introduced by the Verificarlo#super[@verificarlo] and Fuzzy#super[@fuzzy] libraries. After preprocessing, #acr("FC") matrices were obtained using Nilearn#super[@Nilearn] (0.13.1). Absolute thresholds of 0.05, 0.1, 0.2, 0.3, 0.4 and 0.5 were applied to the #acr("FC") matrices, and graph metrics were computed using NetworkX#super[@SciPyProceedings_11] (3.6.1).

#todo("Add Biomarker section")

#todo("Add results section")

#todo("Add conclusion section")

#abstract-footer("en")
