#import "@preview/isc-hei-bthesis:0.8.0": *

#import "@preview/acrostiche:0.7.0": *


#let doc_language = "en" // Valid values are en, fr

#show: project.with(
  title: "Numerical Stability of Functional MRI\n Connectivity Biomarkers", // Your thesis title
  subtitle: none, // Optional, use none if not needed
  authors: "Olivier Amacker",
  language: doc_language, // must be defined globally, see above

  thesis-supervisor: "Prof. Dr Oscar Esteban",
  thesis-co-supervisor: "Dr Okito Yamashita", // Optional, use none if not needed
  thesis-expert: "Dr Ayumu Yamashita", // Optional, use none if not needed
  thesis-id: "ISC-ID-26-1", // Your thesis ID (from the official project description)
  hide-completeness-warning: false,
  project-repos: "https://github.com/madeinshinea/bachelor-thesis", // Your project git repository.

  school: "Haute École d'Ingénierie de Sion",
  programme: "Informatique et Systèmes de communication (ISC)",

  // Some keywords related to your thesis
  keywords: ("medical data science", "fMRI", "fMRIPrep", "numerical stability", "benchmark", "PCA", "neuroimaging"),
  major: "Data engineering", // "Software engineering", "Embedded systems", "Security", "something else"

  date: datetime.today(), // or datetime.today()

  doc-type: "thesis",
  split-chapters: true,
  revision: "0.0.1", // Or for instance "1.0", for the version of your thesis
  code-theme: "bluloco-light", // See directory themes/ for available themes
)

// // If using acronyms
#import "@preview/acrostiche:0.7.0": *
#include "acronyms.typ"

// Let's get started folks!

// The TB assignment sheet is a separate document filled in by the professor.
// Once compiled to PDF, include it here by uncommenting the lines below and
// placing the compiled PDF at pages/tb_assignment.pdf.
//
// #cleardoublepage()
// #image("pages/tb_assignment.pdf")

#cleardoublepage()
#include "pages/abstract.typ"

#cleardoublepage()
#include "pages/résumé.typ"

#cleardoublepage()
#include "pages/acknowledgements.typ"


// Enable headers and footers from this point on
#set-header-footer(true)

#todo("Remove")

Writing a report is an exercise that involves both *content* and *form*. In this document, we aim to simplify the formatting aspect without making any assumptions about the content, specifically in the context of the ISC degree programme#footnote[Here is how to add a footnote https://isc.hevs.ch].

== The content of a thesis

The general structure of a bachelor thesis typically includes the following sections:

1. *Abstract*: A concise summary of the thesis, including the research question, methodology, results, and conclusions.
2. *Résumé*: A summary of the thesis in French.
3. *Acknowledgements*: [Optional] A section to thank those who supported your work.
4. *Table of Contents*: An organized list of chapters and sections.
5. *Introduction*: Presents the background/context, motivation, objectives, and scope and plan of the thesis.
6. *State of the Art / Literature Review*: Reviews existing research and situates the thesis within the academic context, if relevant to your work.
7. *Development and Methodology*: Describes the methods, materials, and procedures used in the research/thesis.
8. *Results*: Presents the findings of the research, often with tables, figures, and analysis.
9. *Discussion*: Interprets the results, discusses implications, and relates findings to the research question.
10. *Conclusion*: Summarizes the main findings and contributions, and suggests future work.
11. *References / Bibliography*: Lists all sources cited in the thesis.
12. *Appendices*: (Optional) Contains supplementary material such as raw data, code, or additional explanations.

#reset-all-acronyms()

This structure may vary depending on the field of study, but these elements are commonly found in most bachelor theses. They are recommended for the _ISC Bachelor thesis_ and should be adapted to the specific requirements of your thesis (e.g., if you have a state of the art section or not).

You can also change the order or the names of the sections, for instance, if you want to put the state of the art before the introduction, or if you want to add a section on methodology before the results.

== Academic titles
Please note that the academic titles of your supervisors and experts are important.

They should be included on the cover page, and you should use the correct title when addressing them in the acknowledgements section. For instance, a professor should be addressed as "Prof. [Name]", while a doctor should be addressed as "Dr [Name]" (*without a colon!*). A professor who is also a doctor should be addressed as "Prof. Dr [Name]".

If you are unsure about the title of your supervisor, co-supervisor, or expert, you can ask them directly or check their profile on the university website.

== Compiling the thesis

If you compile your thesis using the `typst` command line tool, or by using the `typst` extension in Visual Studio Code, please note that you must install the fonts used in this template. You can do so by running the following command in your terminal:

```bash
./fonts/install_fonts.sh
```

= Introduction <intro>
#link("https://en.wikipedia.org/wiki/Functional_magnetic_resonance_imaging")[#acr("fMRI")] has revolutionized neuroscience by enabling non-invasive observation of brain activity through blood oxygenation level-dependent signals. A key application is the analysis of #acr("FC"), which examines temporal correlations between spatially distinct brain regions to construct connectivity matrices. These matrices serve as the foundation for deriving graph-theoretical metrics and biomarkers used in clinical research, particularly for conditions such as #link("https://en.wikipedia.org/wiki/Major_depressive_disorder")[#acr("MDD")].

As #acr("fMRI") pipelines become increasingly computationally intensive, involving high-dimensional matrix operations and complex preprocessing steps, the question of numerical reliability becomes crucial. Small numerical perturbations introduced by factors such as #link("https://en.wikipedia.org/wiki/Operating_system")[#acr("OS")] differences (as you can see on @os-differences), hardware architecture, and parallelization strategies can propagate through the pipeline, potentially affecting downstream results.

#figure(image("./figs/os_result_difference.png", height: 250pt), caption: [Example of the same program giving different results depending on the #acr("OS")])<os-differences>

In the context of multi-site studies and clinical applications, where reproducibility is essential, understanding and quantifying this numerical variability is critical. Unstable biomarkers could lead to unreliable clinical decisions or failed replication across research sites. However, systematic assessment of numerical stability in #acr("fMRI") pipelines remains limited, particularly for advanced feature extraction methods.

The goal of this bachelor thesis, conducted in collaboration with the #link("https://www.atr.jp/index.html", acr("ATR")), is to investigate the numerical stability of #acr("fMRI") connectivity biomarkers. This work was divided into three complementary parts.

First, the objective was to reproduce the results of Alizadeh et al., 2026 #super[@Alizadeh2025.12.22.695524], which examined how numerical variability affects the sample size required for statistical significance and the stability of #acr("FC") matrix graph metrics using the #acr("NPVR") metric.

Second, the focus shifted to the numerical stability of the #acr("FC") matrices themselves, rather than their derived graph metrics, providing edge-wise stability analysis.

Finally, the numerical stability of a feature extraction method based on #link("https://en.wikipedia.org/wiki/Principal_component_analysis")[#acr("PCA")] was assessed, building on the work of Yamashita et al., 2026 #super[#cite(label("10.1162/IMAG.a.1121"))]. This method extracts #acr("FC") biomarkers robust to different sites and datasets. The stability assessment involved perturbing the correlation coefficient computation (```Python np.corrcoef```) and forcing the #acr("PCA") to use 32-bit floating-point inputs rather than 64-bit.

= State of the Art

In recent years, different tools have been created to help the assessment of numerical variability. Notably #link("https://github.com/verificarlo/verificarlo", "Verificarlo") Denis et al., 2018 #super[@denis2018verificarlocheckingfloatingpoint] which is a tool used to compile programs with #link("https://en.wikipedia.org/wiki/LLVM", "LLVM") level arithmetic perturbations and #link("https://github.com/verificarlo/fuzzy", "Fuzzy") #super[@greg_kiar_2026_20906259] which consists of already perturbed #link("https://www.docker.com/resources/what-container/", "Docker containers") for certain #link("https://www.python.org/","Python") libraries like #link("https://numpy.org/","Numpy") or #link("https://scipy.org/","Scipy"), and more recently #link("https://github.com/big-data-lab-team/fuzzy-pytorch", "Fuzzy PyTorch") Gonzalez-Pepe et al., 2026 #super[@gonzalezpepe2026fuzzypytorchrapidnumerical] which extends this approach to deep learning workflows.

These tools rely on #acr("MCA") Parker et al., 1997 #super[@Parker1997MonteCA], a technique that introduces controlled random perturbations to floating-point operations during program execution. By repeatedly running the same pipeline with #acr("MCA") instrumentation, researchers can quantify how numerical variability propagates through computational workflows.

Using these tools, the impact of numerical variability has been investigated across several neuroimaging domains such as functional, structural and diffusion imaging. As introduced in @intro, Alizadeh et al., 2026 #super[@Alizadeh2025.12.22.695524] evaluated the numerical variability of different graph measures derived from the #acr("FC") matrices resulting from the widely used #link("https://fmriprep.org/en/stable/", "fMRIPrep") Esteban et al., 2019 #super[@fMRIPrep] preprocessing pipeline. Using the #acr("NPVR") metric, they obtained values ranging from 0.1 to 0.2 for most graph metrics. These results were found to vary across brain regions, #acr("FC") thresholds and confound regression strategies.

In structural imaging pipelines, Mirhakimi et al., 2025 #super[@mirhakimi2025numericaluncertaintylinearregistration] investigated numerical uncertainty in linear registration algorithms, demonstrating that small floating-point variations can lead to measurable differences in image alignment. Similarly, Chatelain et al., 2026 #super[@Chatelain2026.01.09.698203] quantified the impact of numerical variability on structural #acr("MRI") measures in Parkinson's disease, finding that numerical variation reached nearly one-third of population variability in multiple cortical and subcortical regions.

In diffusion imaging pipelines, Kiar et al., 2021 #super[@kiar2021] showed that numerical uncertainty in analytical workflows leads to impactful variability in brain network measurements, revealing that different computational environments can produce substantially different connectivity results.

#pagebreak()

Interestingly, numerical variability has also been used as a resource rather than a limitation. Gonzalez-Pepe et al., 2026 #super[@gonzalezpepe2026fuzzypytorchrapidnumerical] established that controlled numerical perturbations can serve as an effective data augmentation strategy for deep learning models, artificially expanding training datasets and improving model generalization.

However, these stability conclusions cannot be generalized across pipelines due to heterogeneous methodologies and implementations. While graph-theoretical metrics have been studied by Alizadeh et al., 2026 #super[@Alizadeh2025.12.22.695524], edge-wise #acr("FC") matrix stability remains unexplored. Additionally, the #acr("PCA")-based feature extraction proposed by Yamashita et al., 2026 #super[#cite(label("10.1162/IMAG.a.1121"))] has shown robustness across different sites and datasets, making its numerical stability verification crucial. This thesis addresses these gaps through edge-wise #acr("FC") analysis and #acr("PCA")-based extraction evaluation.

= Development and Methodology

This section describes the development process and methodology underlying this thesis. Beyond the thesis-specific code, this work included contributions to external repositories via pull requests, including fixes to the #link("https://github.com/ISC-HEI/isc-hei-typst-templates")[ISC-HEI Typst thesis template], enhancements to #link("https://github.com/Ayumu722/pca-based-feature-extraction")[Yamashita et al.'s PCA-based feature extraction package], and a correction to the #acr("NPVR") simulation in #link("https://github.com/mina94az/Numerical-Variability-of-functional-MRI-Graph-Measures")[Alizadeh et al.'s repository].

== Code availability

The code developed during this bachelor thesis is publicly available on #link("https://github.com/madeinshinea/bachelor-thesis", "GitHub"). The repository is organized using #link("https://git-scm.com/book/en/v2/Git-Tools-Submodules", "git submodules") to separate concerns: the `bachelor-thesis-report` submodule contains this #link("https://typst.app/", "Typst") report, while the `bachelor-thesis-project` submodule contains all analysis code, including preprocessing pipelines, analysis notebooks, and job submission scripts for the #acr("ATR") #link("https://en.wikipedia.org/wiki/High-performance_computing", acr("HPC")) cluster.

An interactive project website is available at #link("https://olivier.amacker.dev/bachelor-thesis")[olivier.amacker.dev/bachelor-thesis], providing browsable access to the four analysis notebooks developed with #link("https://marimo.io/", "Marimo") and their respective outputs, a daily journal documenting the project's progress, and the different presentations delivered during the thesis.

The development environment is managed via #link("https://nixos.org/", "Nix") and #link("https://docs.astral.sh/uv/", "uv"), ensuring its reproducibility. The fuzzy fMRIPrep #link("https://www.docker.com/", "Docker") container, built on #link("https://github.com/verificarlo/verificarlo", "Verificarlo") and the Fuzzy libmath library, is published on #link("https://hub.docker.com/repository/docker/madeinshinea/fuzzy-fmriprep/general", "DockerHub") for reproducibility.

#pagebreak()

== Reproduction of Alizadeh et al., 2026

This section details the reproduction of the two distinct analyses presented in Alizadeh et al., 2026 #super[@Alizadeh2025.12.22.695524]. The original code can be found #link("https://github.com/mina94az/Numerical-Variability-of-functional-MRI-Graph-Measures", "on GitHub"), and before starting the reproduction, a comprehensive summary of the paper was created to ensure a thorough understanding of the methodology, preprocessing pipeline, and graph metrics which is accessible #link("https://github.com/MadeInShineA/bachelor-thesis-project/tree/main/resources/alizadeh-2025-paper-summary", "here"). The first analysis involved implementing #acr("NPVR") calculation on simulated data to assess how #acr("NPVR") variation influences the sample size required for Cohen's $d$ coefficient. The second analysis used perturbed fMRIPrep outputs to evaluate #acr("NPVR") variation across different graph metrics, thresholds, and brain regions.

=== NPVR Simulation

An interactive notebook for this simulation can be accessed #link("https://olivier.amacker.dev/bachelor-thesis/site/notebooks/npvr-simulation/", "online"), as it doesn't rely on any external data.

The simulation begins by generating two synthetic populations using normal distributions with the same means but different standard deviations: $sigma = 0.1$ for the low variability group and $sigma = 0.4$ for the high variability group. For each population, the #acr("NPVR") is calculated using the formula $text("NPVR") = sigma_"num" / sigma_"pop"$, where $sigma_"num"$ represents the numerical variability and $sigma_"pop"$ the population variability. The populations are then visualized in the $sigma_"num"$ / $sigma_"pop"$ space to assess their relative positions on #acr("NPVR") contour lines. Finally, the relationship between #acr("NPVR"), sample size, and Cohen's $d$ variations is visualized to assess how numerical noise propagates into statistical inference.

During this reproduction, the original source code was reviewed and an error was identified. The #acr("NPVR") values in the final visualization were hardcoded to `0.287` and `0.496` rather than computed from the generated distributions. This bug was fixed through a #link("https://github.com/mina94az/Numerical-Variability-of-functional-MRI-Graph-Measures/pull/3", "pull request") that was merged into the original repository.

=== Graph Metrics Stability Assessment

The notebook code developed for this step and its outputs are available as a #link("https://olivier.amacker.dev/bachelor-thesis/site/notebooks/fuzzy-fmriprep-graph-metrics-analysis.html", "static HTML page").


This reproduction step involved several changes to the original procedure.
First, a custom #link("https://hub.docker.com/r/madeinshinea/fuzzy-fmriprep", "Docker container") was created to perturb the latest version of fMRIPrep (25.2.5) instead of using the existing Fuzzy container, which used an older fMRIPrep version (23.2.1).
Second, the #acr("fMRI") data used for this section was provided by the #acr("ATR") and originates from a multi-site dataset Koike et al., 2021 #super[@KOIKE2021102600,] rather than the #link("https://www.ppmi-info.org/access-data-specimens/download-data", "publicly available PPMI dataset") that was originally used.
Third, when extracting the #acr("FC") matrices, the original paper used six confound regressors corresponding to the main motion parameters (translations and rotations). However, as the data used in this work appeared to be noisier, nine additional confounds were included following the recommendation of Dr. Yamashita: global signal, CSF, white matter, and six aCompCor components (`a_comp_cor_00` through `a_comp_cor_05`).
Fourth, due to computational constraints, small-worldness was excluded from the analysis.
Finally, how the #acr("NPVR") is calculated based on the outputs of the different fMRIPrep runs was modified. In the original paper, they had the same number of runs per subject and the #acr("NPVR") was calculated as follows:

#pagebreak()

$$$
sigma_"num"^2 = 1/m sum_(j=1)^m [1/(n-1) sum_(i=1)^n (x_(i,j) - x-bar_(".,j"))^2]
$$$

$$$
sigma_"pop"^2 = 1/n sum_(i=1)^n [1/(m-1) sum_(j=1)^m (x_(i,j) - x-bar_(i,"."))^2]
$$$

$$$
text("NPVR") = sigma_"num" / sigma_"pop"
$$$

where $n$ is the number of MCA repetitions, $m$ is the number of subjects, and $x_(i,j)$ is the metric value for subject $j$ in MCA run $i$.

Initially, some preprocessing runs failed, resulting in varying numbers of MCA runs per subject. However, after rerunning the failed subjects, the final dataset contained 5 subjects with 5 fuzzy fMRIPrep runs each. Although the final dataset was balanced, the pooled approach was retained to handle potential missing data robustly. The pooled numerical variance accounts for the varying number of runs per subject:

$$$
sigma_"num pooled"^2(r) = 1/(sum_(j=1)^m (n_j - 1)) sum_(j=1)^m (n_j - 1) [1/(n_j - 1) sum_(i in Omega_j) (x_(i,j)(r) - x-bar_(".,j")(r))^2]
$$$

Similarly, the pooled population variance accounts for the varying number of subjects per run:

$$$
sigma_"pop pooled"^2(r) = 1/(sum_(i=1)^n (m_i - 1)) sum_(i=1)^n (m_i - 1) [1/(m_i - 1) sum_(j in Omega_i) (x_(i,j)(r) - x-bar_(i,".")(r))^2]
$$$

The pooled #acr("NPVR") for each region $r$ is then:

$$$
text("NPVR")_"pooled"(r) = sigma_"num pooled"(r) / sigma_"pop pooled"(r)
$$$

where $n_j$ is the number of runs for subject $j$, $m_i$ is the number of subjects in MCA run $i$, and $Omega_j$ and $Omega_i$ denote the sets of valid indices for subject $j$ and run $i$, respectively.

This approach ensures that all available data contributes to the variability estimates, even if some runs are missing.

The remaining analysis followed the same procedure as the original study. After fMRIPrep preprocessing, the Schaefer 2018 parcellation #super[@Schaefer2018] with 100 cortical regions and 7 functional networks was used to extract regional time series using #link("https://nilearn.github.io", "Nilearn")'s NiftiLabelsMasker. Spatial smoothing of 6mm #link("https://en.wikipedia.org/wiki/Full_width_at_half_maximum", acr("FWHM")), temporal standardization, and detrending were applied during masking. The #acr("FC") matrices were computed as Pearson #link("https://en.wikipedia.org/wiki/Correlation_matrix", "correlation matrices") using Nilearn's ConnectivityMeasure, with both with-confound and without-confound versions generated. The matrices were thresholded using absolute correlation values at six thresholds: 0.05, 0.1, 0.2, 0.3, 0.4, and 0.5, retaining both strongly positive and strongly negative correlations. For each threshold, four local graph metrics were computed using #link("https://networkx.org", "NetworkX"): degree centrality, clustering coefficient, betweenness centrality, and eigenvector centrality. Additionally, one global metric was calculated: average shortest path length. The #acr("NPVR") was then computed for each metric and threshold, and plotted across brain regions by projecting regional values onto the Schaefer 2018 atlas to assess spatial variability in numerical stability. Additionally, the #acr("NPVR") was computed on the difference between with-confound and without-confound matrices to assess the impact of confound regression, following the approach of the original study.


== Edge-wise FC Matrix Stability Analysis

== PCA-based Feature Extraction Stability

=== Reproduction on SRPB and BMB Datasets

=== FC Matrix Extraction Perturbation

=== PCA Dimensionality Reduction Perturbation

= Results and Discussion

= Conclusion

//#bibliography("bibliography.bib", full: true, style: "ieee", title)
#pagebreak()

#the-bibliography(
  bib-file: read("bibliography.bib", encoding: none),
  full: true,
  style: "ieee",
)

//////////////
// Appendices
//////////////
#cleardoublepage()
#appendix-page()
#pagebreak()

// Table of acronyms, NOT COMPULSORY
#print-index(
  title: page-title(i18n(doc_language, "acronym-table-title"), mult: 1, top: 1em, bottom: 1em),
  sorted: "up",
  delimiter: " : ",
  row-gutter: 0.7em,
  outlined: false,
)

#pagebreak()

// Table of listings
#table-of-figures()

// Code inclusion
#pagebreak()
#code-samples()

#let code_sample = read("code/sample.scala")

#figure(
  code()[
    #raw(code_sample, lang: "scala")
  ],
  caption: "Code included from the file example.scala",
)

#figure(
  code()[
    #raw(read("code/sort.py"), lang: "python")
  ],
  caption: "Second code included from the file example.scala",
)

#figure(
  code()[
    #raw(code_sample, lang: "scala")
  ],
  caption: "Second code included from the file example.scala",
)


// This is the end, folks!
