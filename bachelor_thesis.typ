#import "@preview/isc-hei-bthesis:0.8.0": *

#import "@preview/acrostiche:0.7.0": *


#let doc_language = "en" // Valid values are en, fr

#show: project.with(
  title: "Numerical Stability of Functional MRI\n Connectivity Biomarkers", // Your thesis title
  subtitle: none, // Optional, use none if not needed
  authors: "Olivier Amacker",
  language: doc_language, // must be defined globally, see above

  signature: image("figs/signature.png", height: 40pt),

  thesis-supervisor: "Prof. Dr Oscar Esteban",
  thesis-co-supervisor: "Dr Okito Yamashita", // Optional, use none if not needed
  thesis-expert: "Dr Ayumu Yamashita", // Optional, use none if not needed
  thesis-id: "ISC-ID-26-1", // Your thesis ID (from the official project description)
  hide-completeness-warning: true,
  project-repos: "https://github.com/madeinshinea/bachelor-thesis", // Your project git repository.


  school: "Haute École d'Ingénierie de Sion",
  programme: "Informatique et Systèmes de communication (ISC)",
  academic-year: "2025-2026",

  // Some keywords related to your thesis
  keywords: ("medical data science", "fMRI", "fMRIPrep", "numerical stability", "bio-markers", "PCA", "neuroimaging", "MDD"),
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

#include "pages/honneur.typ"

#cleardoublepage()
#include "pages/acknowledgements.typ"

#let ai-notice(body) = {
   footnote(numbering: _ => [])[#body]
   counter(footnote).update(n => n - 1)
 }


// Enable headers and footers from this point on
#set-header-footer(true)

#reset-all-acronyms()


= Introduction <intro>

#ai-notice[#acrpl("LLM") were used during the writing of this report exclusively to reformulate sentences and correct typographical and grammatical errors. They were never used to generate text from scratch.]

#link("https://en.wikipedia.org/wiki/Functional_magnetic_resonance_imaging")[#acr("fMRI")] has revolutionized neuroscience by enabling non-invasive observation of brain activity through blood oxygenation level-dependent signals. A key application is the analysis of #acr("FC"), which examines temporal correlations between spatially distinct brain regions to construct connectivity matrices. These matrices serve as the foundation for deriving graph-theoretical metrics and biomarkers used in clinical research, particularly for conditions such as #link("https://en.wikipedia.org/wiki/Major_depressive_disorder")[#acr("MDD")].

As #acr("fMRI") pipelines become increasingly computationally intensive, involving high-dimensional matrix operations and complex preprocessing steps, the question of numerical reliability becomes crucial. Small numerical perturbations introduced by factors such as #link("https://en.wikipedia.org/wiki/Operating_system")[#acr("OS")] differences (as you can see on @os-differences), hardware architecture, and parallelization strategies can propagate through the pipeline, potentially affecting downstream results.

#figure(image("./figs/os_result_difference.png", height: 200pt), caption: [Example of the same program giving different results depending on the #acr("OS")])<os-differences>

#pagebreak()

In the context of multi-site studies and clinical applications, where reproducibility is essential, understanding and quantifying this numerical variability is critical. Unstable biomarkers could lead to unreliable clinical decisions or failed replication across research sites. However, systematic assessment of numerical stability in #acr("fMRI") pipelines remains limited, particularly for advanced feature extraction methods.

The goal of this bachelor thesis, conducted in collaboration with the #link("https://www.atr.jp/index.html", acr("ATR")), is to investigate the numerical stability of #acr("fMRI") connectivity biomarkers. This work was divided into three complementary parts.

First, the objective was to reproduce the results of Alizadeh et al., 2026 #super[@Alizadeh2025.12.22.695524], which examined how numerical variability affects the sample size required for statistical significance and the stability of #acr("FC") matrix graph metrics using the #acr("NPVR") metric.

Second, the focus shifted to the numerical stability of the #acr("FC") matrices themselves, rather than their derived graph metrics, providing edge-wise stability analysis.

Finally, the numerical stability of a feature extraction method based on #link("https://en.wikipedia.org/wiki/Principal_component_analysis")[#acr("PCA")] was assessed, building on the work of Yamashita et al., 2026 #super[#cite(label("10.1162/IMAG.a.1121"))]. This method extracts #acr("FC") biomarkers robust to different sites and datasets. The stability assessment involved perturbing the correlation coefficient computation (```Python np.corrcoef```) and forcing the #acr("PCA") to use 32-bit floating-point inputs rather than 64-bit.


= State of the Art

In recent years, different tools have been created to help the assessment of numerical variability. Notably #link("https://github.com/verificarlo/verificarlo", "Verificarlo") Denis et al., 2018 #super[@denis2018verificarlocheckingfloatingpoint] which is a tool used to compile programs with #link("https://en.wikipedia.org/wiki/LLVM", "LLVM") level arithmetic perturbations and #link("https://github.com/verificarlo/fuzzy", "Fuzzy") #super[@greg_kiar_2026_20906259] which consists of already perturbed #link("https://www.docker.com/resources/what-container/", "Docker containers") for certain #link("https://www.python.org/","Python") libraries like #link("https://numpy.org/","Numpy") or #link("https://scipy.org/","Scipy"). More recently #link("https://github.com/big-data-lab-team/fuzzy-pytorch", "Fuzzy PyTorch") Gonzalez-Pepe et al., 2026 #super[@gonzalezpepe2026fuzzypytorchrapidnumerical] has been released, which extends this approach to deep learning workflows.

These tools rely on #acr("MCA") Parker et al., 1997 #super[@Parker1997MonteCA], a technique that introduces controlled random perturbations to floating-point operations during program execution. By repeatedly running the same pipeline with #acr("MCA") instrumentation, researchers can quantify how numerical variability propagates through computational workflows.

Using these tools, the impact of numerical variability has been investigated across several neuroimaging domains such as functional, structural and diffusion imaging. As introduced in @intro, Alizadeh et al., 2026 #super[@Alizadeh2025.12.22.695524] evaluated the numerical variability of different graph measures derived from the #acr("FC") matrices resulting from the widely used #link("https://fmriprep.org/en/stable/", "fMRIPrep") Esteban et al., 2019 #super[@fMRIPrep] preprocessing pipeline. Using the #acr("NPVR") metric, they obtained values ranging from 0.1 to 0.2 for most graph metrics. These results were found to vary across brain regions, #acr("FC") thresholds and confound regression strategies.

In structural imaging pipelines, Mirhakimi et al., 2025 #super[@mirhakimi2025numericaluncertaintylinearregistration] investigated numerical uncertainty in linear registration algorithms, demonstrating that small floating-point variations can lead to measurable differences in image alignment. Similarly, Chatelain et al., 2026 #super[@Chatelain2026.01.09.698203] quantified the impact of numerical variability on structural #acr("MRI") measures in Parkinson's disease, finding that numerical variation reached nearly one-third of population variability in multiple cortical and subcortical regions.

In diffusion imaging pipelines, Kiar et al., 2021 #super[@kiar2021] showed that numerical uncertainty in analytical workflows leads to impactful variability in brain network measurements, revealing that different computational environments can produce substantially different connectivity results.


Interestingly, numerical variability has also been used as a resource rather than a limitation. Gonzalez-Pepe et al., 2026 #super[@gonzalezpepe2026fuzzypytorchrapidnumerical] established that controlled numerical perturbations can serve as an effective data augmentation strategy for deep learning models, artificially expanding training datasets and improving model generalization.

#pagebreak()

However, these stability conclusions cannot be generalized across pipelines due to heterogeneous methodologies and implementations. While graph-theoretical metrics have been studied by Alizadeh et al., 2026 #super[@Alizadeh2025.12.22.695524], edge-wise #acr("FC") matrix stability remains unexplored. Additionally, the #acr("PCA")-based feature extraction proposed by Yamashita et al., 2026 #super[#cite(label("10.1162/IMAG.a.1121"))] has shown robustness across different sites and datasets, making its numerical stability verification crucial. This thesis addresses these gaps through edge-wise #acr("FC") analysis and #acr("PCA")-based extraction evaluation.

= Development and Methodology <methodology>

This section describes the development process and methodology underlying this thesis. Beyond the thesis-specific code, this work included contributions to external repositories via #acrpl("PR"), enhancements to Yamashita et al.'s #link("https://github.com/Ayumu722/pca-based-feature-extraction")[PCA-based feature extraction package], and a correction to the #acr("NPVR") simulation in Alizadeh et al. 2026's #link("https://github.com/mina94az/Numerical-Variability-of-functional-MRI-Graph-Measures")[GitHub repository].

== Code availability

The code developed during this bachelor thesis is publicly available on #link("https://github.com/madeinshinea/bachelor-thesis", "GitHub"). The repository is organized using #link("https://git-scm.com/book/en/v2/Git-Tools-Submodules", "git submodules") to separate concerns: the `bachelor-thesis-report` submodule contains this #link("https://typst.app/", "Typst") report, while the `bachelor-thesis-project` submodule contains all analysis code, including preprocessing pipelines, analysis notebooks, and job submission scripts for the #acr("ATR") #link("https://en.wikipedia.org/wiki/High-performance_computing", acr("HPC")) cluster.

An interactive project website is available at #link("https://olivier.amacker.dev/bachelor-thesis")[olivier.amacker.dev/bachelor-thesis], providing browsable access to the four analysis notebooks developed with #link("https://marimo.io/", "Marimo") and their respective outputs, a daily journal documenting the project's progress, and the different presentations delivered during the thesis.

The development environment is managed via #link("https://nixos.org/", "Nix") and #link("https://docs.astral.sh/uv/", "uv"), ensuring its reproducibility. The fuzzy fMRIPrep #link("https://www.docker.com/", "Docker") container, built on #link("https://github.com/verificarlo/verificarlo", "Verificarlo") and the Fuzzy's libmath library, used for running perturbed preprocessing runs, is published on #link("https://hub.docker.com/repository/docker/madeinshinea/fuzzy-fmriprep/general", "DockerHub") for reproducibility.

#pagebreak()

== Reproduction of Alizadeh et al., 2026

This section details the reproduction of the two distinct analyses presented in Alizadeh et al., 2026 #super[@Alizadeh2025.12.22.695524]. The original code can be found #link("https://github.com/mina94az/Numerical-Variability-of-functional-MRI-Graph-Measures", "on GitHub"), and before starting the reproduction, a comprehensive summary of the paper was created to ensure a thorough understanding of the methodology, preprocessing pipeline, and graph metrics which is accessible #link("https://github.com/MadeInShineA/bachelor-thesis-project/tree/main/resources/alizadeh-2025-paper-summary", "here"). The first analysis involved implementing #acr("NPVR") calculation on simulated data to assess how #acr("NPVR") variation influences the sample size required for Cohen's $d$ coefficient. The second analysis used perturbed fMRIPrep outputs to evaluate #acr("NPVR") variation across different graph metrics, thresholds, and brain regions.

=== NPVR Simulation <npvr-simulation>

An interactive notebook for this simulation can be accessed #link("https://olivier.amacker.dev/bachelor-thesis/site/notebooks/npvr-simulation/", "online"), as it doesn't rely on any external data.

The simulation begins by generating two synthetic populations using normal distributions with the same means but different standard deviations: $sigma = 0.1$ for the low variability group and $sigma = 0.4$ for the high variability group. For each population, the #acr("NPVR") is calculated using the formula $text("NPVR") = sigma_"num" / sigma_"pop"$, where $sigma_"num"$ represents the numerical variability and $sigma_"pop"$ the population variability. The populations are then visualized in the $sigma_"num"$ / $sigma_"pop"$ space to assess their relative positions on #acr("NPVR") contour lines. Finally, the relationship between #acr("NPVR"), sample size, and Cohen's $d$ variations is visualized to assess how numerical noise propagates into statistical inference.

During this reproduction, the original source code was reviewed and an error was identified. The #acr("NPVR") values in the final visualization were hardcoded to `0.287` and `0.496` rather than computed from the generated distributions. This bug was fixed through a #link("https://github.com/mina94az/Numerical-Variability-of-functional-MRI-Graph-Measures/pull/3", acr("PR")) that was merged into the original repository.

=== Graph Metrics Stability Assessment <graph-section>

The notebook code developed for this step and its outputs are available as a #link("https://olivier.amacker.dev/bachelor-thesis/site/notebooks/fuzzy-fmriprep-graph-metrics-analysis.html", "static HTML page").


This reproduction step involved several changes to the original procedure.
First, a custom #link("https://hub.docker.com/r/madeinshinea/fuzzy-fmriprep", "Docker container") was created to perturb the latest version of fMRIPrep (25.2.5) instead of using the existing Fuzzy container, which used an older fMRIPrep version (23.2.1).
Second, the #acr("fMRI") data used for this section was provided by the #acr("ATR") and originates from a multi-site dataset Koike et al., 2021 #super[@KOIKE2021102600,] rather than the #link("https://www.ppmi-info.org/access-data-specimens/download-data", "publicly available PPMI dataset") that was originally used.
Third, when extracting the #acr("FC") matrices, the original paper used six confound regressors corresponding to the main motion parameters (translations and rotations). However, as the data used in this work appeared to be noisier, nine additional confounds were included following the recommendation of Dr. Yamashita: global signal, CSF, white matter, and six aCompCor components (`a_comp_cor_00` through `a_comp_cor_05`).
Fourth, due to computational constraints, the small-worldness graph metric was excluded from the analysis.
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

The remaining analysis followed the same procedure as the original study. After fMRIPrep preprocessing, the Schaefer 2018 parcellation #super[@Schaefer2018] with 100 cortical regions and 7 functional networks was used to extract regional time series using #link("https://nilearn.github.io", "Nilearn")'s NiftiLabelsMasker. Spatial smoothing of 6mm #link("https://en.wikipedia.org/wiki/Full_width_at_half_maximum", acr("FWHM")), temporal standardization, and detrending were applied during masking. The #acr("FC") matrices were computed as Pearson #link("https://en.wikipedia.org/wiki/Correlation_matrix", "correlation matrices") using Nilearn's ConnectivityMeasure, with both with-confound and without-confound versions generated. The matrices were thresholded using absolute correlation values at six thresholds: 0.05, 0.1, 0.2, 0.3, 0.4, and 0.5, retaining both strongly positive and strongly negative correlations. For each threshold, four local graph metrics were computed using #link("https://networkx.org", "NetworkX"): degree centrality, clustering coefficient, betweenness centrality, and eigenvector centrality. Additionally, one global metric was calculated: average shortest path length. The #acr("NPVR") was then computed for each metric and threshold. For visualization purposes, these values were normalized and plotted across brain regions by projecting regional values onto the Schaefer 2018 atlas to assess spatial variability in numerical stability. Furthermore, the #acr("NPVR") was computed on the difference between with-confound and without-confound matrices to assess the impact of confound regression, following the approach of the original study.


== Edge-wise FC Matrix Stability Analysis <fc-matrices-analyses>

The notebook code developed for this step and its outputs are available as a #link("https://olivier.amacker.dev/bachelor-thesis/site/notebooks/fuzzy-fmriprep-fc-matrices-analysis.html", "static HTML page").

Reusing the perturbed fMRIPrep runs from @graph-section, this section extends the analysis from graph-level metrics to individual edges of the #acr("FC") matrices. The pooled #acr("NPVR") was computed independently for each of the 4950 edges (upper triangle of the 100x100 matrix) using the same formula as before.

Two confound strategies were compared: the full set of 15 confounds and a filtered set excluding only the global signal. The global signal regression remains a debated practice in the neuroimaging community, as it may remove both nuisance signals and neural activity of interest Xu et al., 2018 #super[@xu2018], Xifra-Porxas et al., 2025 #super[@xifra2025]. To quantify its impact on edge-wise numerical stability, a delta #acr("NPVR") was computed for each edge as the difference between the two confound strategies.

The edge-wise #acr("NPVR") values were visualized as connectivity matrices, scatter plots, and histograms. To assess spatial patterns, edge-wise values were aggregated per brain region by computing the mean and median #acr("NPVR") across all connected edges and mapped onto the Schaefer 2018 atlas.

== PCA-based Feature Extraction Stability <PCA>

A browsable version of the analysis notebook is available #link("https://olivier.amacker.dev/bachelor-thesis/site/notebooks/fuzzy-pca-dim-reduction-analysis.html", "online").

This section had three objectives. First, reproduce the #acr("PCA")-based feature extraction method developed by Yamashita et al., 2026 #super[#cite(label("10.1162/IMAG.a.1121"))] on the complete #link("https://bicr-resource.atr.jp/srpbsopen/", "SRPB dataset") #super[@Tanaka2021], as opposed to the original paper which split the data into discovery and validation sets. Second, apply the same method to the complete #link("https://mridata-brainminds-beyond.atr.jp/dataset/bmbpt/", "BMB dataset") #super[@KOIKE2021102600]. Third, perturb different steps of the pipeline: the correlation computation using a #link("https://hub.docker.com/layers/verificarlo/fuzzy/v2.0.0-lapack-python3.8.5-numpy-scipy-sklearn/images/sha256-993543dcfc0f40aa5cd2de404b5dccdaeea5673c7fabd39505f47ac5da6eb466", [#acr("MCA")-instrumented Docker container]) and the #acr("PCA") dimensionality reduction by forcing 32-bit floating-point inputs instead of the standard 64-bit precision.

#pagebreak()

=== Reproduction on the SRPB and BMB Datasets <reproduction>

The original #acr("PCA") feature extraction code was publicly available on #link("https://github.com/Ayumu722/pca-based-feature-extraction/tree/9e6c907c623096fc08a02785fe64ab1baf6711ef", "GitHub") but organized as separate Python files, making integration challenging. A #link("https://github.com/Ayumu722/pca-based-feature-extraction/pull/1", acr("PR")) was submitted and merged to restructure it into the `pcafeat` package with #link("https://github.com/astral-sh/uv", "uv") as a dependency manager.

The #acr("FC") matrices used as inputs to the pipeline had already been preprocessed and harmonized across imaging sites by #acr("ATR") for both datasets using the method of Yamashita et al., 2019 #super[#cite(label("10.1371/journal.pbio.3000042"))], so they were used directly without any additional preprocessing or harmonization step.

The extraction pipeline was applied to six metrics: diagnosis (MDD vs. HC), BDI score, age, sex, imaging site, and mean #acr("FD"). The pipeline works as follows:
+ A #acr("PCA") reduces all $n$ subjects' #acr("FC") vectors to $n$ #acrpl("PC")
+ Each #acr("PC") is tested for association with the desired target variables using appropriate statistical tests, with results plotted during testing:
  - t-tests for binary categories (e.g., sex)
  - ANOVA for multi-level categories (e.g., site)
  - Pearson's correlation for continuous variables (e.g., age)
+ #acrpl("PC") significantly associated with the target after #link("https://en.wikipedia.org/wiki/False_discovery_rate#Benjamini%E2%80%93Hochberg_procedure", acr("FDR-BH")) correction ($q < 0.05$) are selected
+ Their #acr("FC") weights are tested via a #link("https://en.wikipedia.org/wiki/Chi-squared_test", "chi-squared test") with the same correction threshold
+ Only #acrpl("FC") surviving the corrections are retained as final biomarkers

During replication of the original paper's pipeline, the plots generated during #acr("PC") association testing were found to have missing labels and incomplete titles. This issue was fixed in another #link("https://github.com/Ayumu722/pca-based-feature-extraction/pull/3", acr("PR")).

After running the extraction pipeline on both datasets, the selected #acrpl("FC") for the second #acr("PC") were plotted on brain surface maps using a combined parcellation of 446 #acrpl("ROI"): 360 cortical regions from the Glasser et al., 2016 #super[@Glasser2016] atlas, 54 subcortical regions from the Tian et al., 2020 #super[@Tian2020] atlas, and 32 cerebellar regions from the Nettekoven et al., 2024 #super[@nettekoven2024] atlas. Functional network assignments were derived from the Yeo et al., 2011 #super[@Yeo2011] 7-network parcellation. Each selected #acr("FC") connection was visualized as an edge between brain regions, color-coded by direction of effect: red indicating over-connectivity in #acr("MDD") relative to healthy controls, and blue indicating under-connectivity. Nodes were colored according to their functional network assignment (Visual, SomatoMotor, DorsalAttention, DefaultMode, Limbic, Salience, PrefrontalControl, Subcortical, or Cerebellum).

Network statistics were also computed to quantify the distribution of selected connections across brain networks, including the number of participating nodes per network, the proportion of intra-network versus inter-network edges, and the most frequent inter-network connection pairs.

#pagebreak()

=== FC Matrix Regular Extraction and Harmonization Pipeline

While @reproduction used #acr("FC") matrices already preprocessed and harmonized, the perturbation strategy described in the next section targets the correlation coefficient computation (```Python np.corrcoef```) used during the #acr("FC") matrices extraction. Reproducing the extraction and harmonization pipeline from the raw parcellated time series was therefore necessary to establish a numerically consistent pipeline before introducing any perturbation.

The starting point was the preprocessed regional time series provided by #acr("ATR") for the SRPB dataset. These time series were parcellated according to the previously described combined parcellation (360 cortical, 54 subcortical, and 32 cerebellar regions, 446 #acrpl("ROI") in total), with global signal regression and band-pass filtering already applied.

#acr("FC") extraction proceeded as follows. First, the regional time series were scrubbed for motion by removing any frame with #acr("FD") exceeding 0.5 mm, together with the immediately subsequent frame. On the retained frames, Pearson correlation matrices were computed using `np.corrcoef` applied to the transposed time series array. The lower triangular elements of each correlation matrix were extracted, Fisher Z-transformed via `np.arctanh`, and flattened into a subject-level connectivity vector.

Before harmonization, the self-extracted #acr("FC") matrices were validated against the original #acr("ATR")-provided harmonized matrices. For each subject, the Pearson correlation and mean absolute error between the extracted and reference connectivity vectors were computed. The resulting per-subject correlation distribution showed near-perfect agreement, confirming that the extraction pipeline faithfully reproduced the original connectivity values prior to harmonization (@fc-extraction-validation).

#figure(image("./figs/srpb_fc_extraction_validation.png", height: 180pt), caption: [Per-subject Pearson correlation distribution between self-extracted and #acr("ATR")-provided #acr("FC") connectivity vectors before harmonization.])<fc-extraction-validation>

Cross-site harmonization was then performed using the traveling-subject method of Yamashita et al., 2019 #super[#cite(label("10.1371/journal.pbio.3000042"))]. This approach models unwanted variance as a linear combination of subject, site, sampling, and protocol biases. Dummy variables were created for each categorical factor, and the sampling dummies were orthogonalized against the site dummies using a weighted projection to ensure independence between site and sampling effects. The bias estimation was formulated as a constrained regularized least-squares problem. In the corresponding #link("https://en.wikipedia.org/wiki/Karush%E2%80%93Kuhn%E2%80%93Tucker_conditions", acr("KKT")) optimality conditions, the #link("https://en.wikipedia.org/wiki/Hessian_matrix", "Hessian matrix") encodes the second-order curvature of the regularized objective function. Rather than inverting this large matrix directly, the system was solved efficiently by first factorizing the Hessian via #link("https://en.wikipedia.org/wiki/Cholesky_decomposition", "Cholesky decomposition"), then applying a #link("https://en.wikipedia.org/wiki/Schur_complement", "Schur-complement") reduction to eliminate the primal variables and obtain a much smaller linear system for the #link("https://en.wikipedia.org/wiki/Lagrange_multiplier", "Lagrange multipliers"). Generalized cross-validation was used to select the regularization hyperparameter $lambda$.

Once the bias coefficients were estimated, the relevant site and protocol bias terms were subtracted from each regular subject's connectivity vector, yielding harmonized #acr("FC") matrices. The self-harmonized matrices were again compared against the #acr("ATR")-provided harmonized matrices. The near-zero mean difference and high per-subject correlation confirmed that the entire reproduction pipeline from scrubbed time series to harmonized connectivity was numerically consistent with the original processing, thereby establishing a valid baseline for the subsequent perturbation experiments (@fc-harmonization-validation). The identical procedure was subsequently applied to the BMB dataset.

#figure(image("./figs/srpb_fc_harmonization_validation.png", height: 180pt), caption: [Per-subject Pearson correlation distribution between self-harmonized and #acr("ATR")-provided harmonized #acr("FC") connectivity vectors.])<fc-harmonization-validation>


=== FC Matrix Perturbed Extraction <np-corrcoef>

Once the regular pipeline was validated, a perturbed version was implemented by executing `np.corrcoef` inside an #acr("MCA")-instrumented #link("https://hub.docker.com/layers/verificarlo/fuzzy/v2.0.0-lapack-python3.8.5-numpy-scipy-sklearn", [Docker container]) provided by Fuzzy. Within this container, Verificarlo introduces controlled random perturbations to each floating-point operation during correlation computation, simulating numerical noise arising from hardware and #acr("OS") variability. One hundred perturbed extractions were performed on the SRPB dataset ($n = 1667$), while fifteen perturbed extractions were performed on the provided subset of the BMB dataset ($n = 6371$). The lower number of runs for the BMB dataset reflects its larger subject count and corresponding computational cost. Each run yielded a complete set of subject-level connectivity vectors used for numerical stability comparison.

=== PCA Dimensionality Reduction Perturbation

Additionally, the #acr("PCA") feature extraction step was also perturbed by using the already #acr("MCA")-perturbed #acr("FC") matrices as inputs, cast to #link("https://en.wikipedia.org/wiki/Single-precision_floating-point_format", "single precision") (32 bits) instead of the default #link("https://en.wikipedia.org/wiki/Double-precision_floating-point_format", "double precision") (64 bits). This reduces the representable precision from approximately 16 to 7 significant decimal digits. The numerical stability assessment therefore reflects the combined effect of both perturbation sources on the same data.

= Results and Discussion

#todo("Explain graphs befor speaking of their meaning?")

This section showcases the results of the three complementary analyses described in @methodology and discusses their implications. First, the reproduction of Alizadeh et al., 2026 #super[@Alizadeh2025.12.22.695524] graph metrics assessment evaluates how numerical variability affects downstream graph measures. Second, the edge-wise #acr("FC") analysis quantifies numerical noise at the level of individual correlations before any graph construction. Third, the stability of the #acr("PCA")-based feature extraction pipeline is assessed under perturbations of both correlation computation and precision reduction.

== Reproduction of Alizadeh et al., 2026

This part reproduced both analyses of Alizadeh et al., 2026 #super[@Alizadeh2025.12.22.695524]. The NPVR simulation on synthetic data (@npvr-simulation) was reimplemented to verify how numerical variability propagates into statistical inference. The graph metrics assessment (@graph-section) was then rerun on fMRIPrep-preprocessed data from a different multi-site dataset, in order to test whether the original numerical stability findings generalize to other data sources.

=== NPVR Simulation

Because the NPVR simulation relies solely on randomly generated synthetic data and the different factors except the small amount of randomness were preserved, the results were expected to closely match those of the original paper. This is examined for each of the three visualisations below.

#pagebreak()

First, the synthetic populations generated in the reproduction closely resemble those presented in the original paper, this similarity is clearly illustrated by @population-fig.

#figure(
  grid(
    columns: (1fr, 1fr),
    align(center)[
      #text(size: 0.8em)[Original: population plot]
      #image("./figs/npvr-simulation-original/population.png", width: 100%)
    ],
    align(center)[
      #text(size: 0.8em)[Reproduced: population plot]
      #image("./figs/npvr-simulation/population.png", width: 100%)
    ],
  ),
  caption: [Comparison of the original and reproduced synthetic populations.],
) <population-fig>

Although the exact population values differ because `np.random.normal` produces independent random draws, the low and high variability groups display the same distributional characteristics as in the original analysis. This confirms that the population generation step is correctly implemented and reproducible.

Second, the #acr("NPVR") of both the low and the high variability populations was calculated and plotted relatively to how the #acr("NPVR") changes depending of the numerical and population variability.

#figure(
  grid(
    columns: (1fr, 1fr),
    align(center)[
      #text(size: 0.8em)[Original: #acr("NPVR") variation]
      #image("./figs/npvr-simulation-original/npvr.png", width: 100%)
    ],
    align(center)[
      #text(size: 0.8em)[Reproduced: #acr("NPVR") variation]
      #image("./figs/npvr-simulation/npvr.png", width: 100%)
    ],
  ),
  caption: [Comparison of the original and reproduced #acr("NPVR") variation plots.],
) <npvr-plot>

In @npvr-plot, the original and reproduced #acrpl("NPVR") are in close agreement: $0.077$ versus $0.080$ for the low-variability population and $0.253$ versus $0.263$ for the high-variability population. This confirms that, despite minor random differences in the initial populations, the #acr("NPVR") estimations are robust and the reproduction faithfully recovers the original values.

Third, the relationship between #acr("NPVR"), sample size, and Cohen's $d$ was also visualized. However, unlike the previous two plots, the original and reproduced figures are not expected to match. As detailed in @npvr-simulation, the original code hardcoded the #acr("NPVR") values to $0.287$ and $0.496$ rather than computing them from the generated distributions. The reproduced plot corrects this by using the actual #acr("NPVR") values calculated from the synthetic populations. Because no corrected version of the original figure has been released since the #link("https://github.com/mina94az/Numerical-Variability-of-functional-MRI-Graph-Measures/pull/3", acr("PR")) fixing this issue was merged, the original figure is shown here for reference only.

#figure(
  grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    align(center)[
      #text(size: 0.8em)[Original: hardcoded NPVR Cohen's $d$ effect]
      #image("./figs/npvr-simulation-original/cohens.png", width: 100%)
    ],
    align(center)[
      #text(size: 0.8em)[Reproduced: computed NPVR Cohen's $d$ effect]
      #image("./figs/npvr-simulation/cohens.png", width: 100%)
    ],
  ),
  caption: [Comparison of the original and reproduced effect of the #acr("NPVR") on Cohen's $d$ plots.],
) <cohens-fig>

Clearly visible in @cohens-fig, the differences between the two panels confirm that the original published figure was affected. The reproduced plot correctly reflects the computed relationship between the #acr("NPVR"), sample size, and Cohen's $d$.

=== Graph Metrics Stability Assessment <graph-metrics-assessment>

The reproduction of the graph metrics assessment differed from the original study in two notable ways, as detailed in @graph-section. First, a different multi-site dataset was used as input for the perturbed fMRIPrep runs. Second, a more extensive confound regression strategy was applied (15 confounds versus the original 6). These methodological differences make direct quantitative comparison of the #acr("NPVR") values difficult, as any observed difference could originate from the data characteristics or the confound strategy rather than from the reproduction itself. Nevertheless, across the five computed graph metrics, the reproduced #acr("NPVR") values computed by aggregating all runs, including both with-confound and without-confound matrices showed trends consistent with those reported by the original paper.

#figure(
  grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    align(center)[
      #text(size: 0.8em)[Original: Graph metrics variation across thresholds]
      #image("./figs/graph-metrics-original/graph_metrics_npvr.png", width: 100%)
    ],
    align(center)[
      #text(size: 0.8em)[Reproduced: Graph metrics variation across thresholds]
      #image("./figs/graph-metrics/graph_metrics_npvr.png", width: 100%)
    ],
  ),
  caption: [Comparison of the original and reproduced #acr("NPVR") values across graph metrics and thresholds],
) <graph-metrics-fig>

According to @graph-metrics-fig, although the reproduced graph metrics display broadly similar trends, notable differences remain. First, eigenvector centrality increases at the $0.5$ threshold in the reproduced data, whereas it remains at a lower level in the original results. Second, for the average shortest path length, the reproduced #acr("NPVR") at the $0.5$ threshold appears higher than at the $0.1$ threshold, a pattern not observed in the original analysis. Finally, despite the application of a more extensive confound regression strategy, the reproduced #acr("NPVR") values are consistently higher than those originally reported across the different thresholds and graph metrics.

Given the consistently higher #acr("NPVR") values observed in the reproduction, the effect of confound regression strategies was expected to differ from the original findings.
In the original paper, applying the six standard translation and rotation confounds consistently increased the #acr("NPVR") for most graph metrics, though betweenness centrality and average shortest path length showed decreased values at the $0.1$ threshold.

#figure(
  grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    align(center)[
      #text(size: 0.8em)[Original: Confound regression effect on #acr("NPVR")]
      #image("./figs/graph-metrics-original/graph_metrics_npvr_confound_difference.png", width: 100%)
    ],
    align(center)[
      #text(size: 0.8em)[Reproduced: Confound regression effect on #acr("NPVR")]
      #image("./figs/graph-metrics/graph_metrics_npvr_confound_difference.png", width: 100%)
    ],
  ),
  caption: [Comparison of the #acr("NPVR") difference between without-confound and with-confound strategies across graph metrics and thresholds.],
) <graph-metrics-confound-fig>

As @graph-metrics-confound-fig demonstrates, the reproduced confound regression effects differ substantially from those reported in the original paper. Unlike the original analysis, the reproduced data exhibits a consistently negative difference across all metrics and thresholds, indicating that confound regression uniformly increases the #acr("NPVR") without exception. Moreover, both the magnitude and the variation of this effect are considerably larger in the reproduced data, with differences spanning a much wider range, particularly for clustering coefficient and average shortest path length at higher thresholds. This amplification is likely attributable to the use of more confound regressors rather than to the different dataset, as the effect follows the same direction as the original study, suggesting that the more confounds applied, the greater the increase in #acr("NPVR").

#pagebreak()

Finally, the #acr("NPVR") was also evaluated across brain regions and found to vary spatially in both the reproduced and original data. For visualization purposes, these values were normalized per metric to enable comparison across different scales. However, @brain-regions-fig reveals that the substantial differences in #acr("NPVR") values between the two analyses result in distinct spatial patterns, making direct visual comparison of the brain surface plots difficult.

#todo("Fix scale")

#figure(
  grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    align(center)[
      #text(size: 0.8em)[Original: Degree centrality across brain regions]
      #image("./figs/graph-metrics-original/npvr_across_brain_regions.png", width:100%)
    ],
    align(center)[
      #text(size: 0.8em)[Reproduced: Degree centrality across brain regions]
      #image("./figs/graph-metrics/npvr_across_brain_regions.png", width: 100%)
    ],
  ),
  caption: [Comparison of the #acr("NPVR") across the different brain regions and thresholds for the degree centrality metric],
) <brain-regions-fig>

In summary, the reproduction of Alizadeh et al., 2026 #super[@Alizadeh2025.12.22.695524] produced interesting results. The NPVR simulation on synthetic data was faithfully reproduced, yielding results closely matching the original and enabling the identification and correction of a bug in the original code. The graph metrics assessment showed broadly consistent trends across thresholds and metrics, though the reproduced #acr("NPVR") values were consistently higher than those originally reported. The confound regression analysis revealed that the additional regressors applied in the reproduction uniformly increased the #acr("NPVR") across all metrics and thresholds. This is consistent with the original findings, which showed that even the six standard confounds increased the #acr("NPVR") for most metrics, suggesting that the more confounds applied, the greater the increase in #acr("NPVR"). Finally, while spatial variability of #acr("NPVR") across brain regions was observed in both analyses, the substantial differences in #acr("NPVR") values prevented direct visual comparison of the brain surface plots. Overall, these results suggest that while the general patterns of numerical variability are reproducible, the specific #acr("NPVR") values are sensitive to dataset characteristics and preprocessing choices, particularly the confound regression strategy.

#pagebreak()

== Edge-wise FC Matrix Stability Analysis

As described in @fc-matrices-analyses, the perturbed fMRIPrep outputs were reused to assess how the #acr("FC") matrices themselves were affected by numerical perturbations, rather than their derived graph metrics.

#figure(
  image("./figs/fuzzy-fc-matrices/npvr_heatmap.png", height: 200pt),
  caption: [Heatmap of #acr("NPVR") values across the edges of the #acr("FC") matrix.],
) <fc-matrices-heat-fig>

The heatmap in @fc-matrices-heat-fig confirms the spatial variability observed in @brain-regions-fig, illustrating that the #acr("NPVR") is not uniformly distributed across the #acr("FC") matrix, ranging from $0.0364$ to $0.2970$. Based on @fc-matrices-hist-fig, the mean and median values of $0.112$ and $0.118$ respectively represent a substantial amount of numerical variability, corresponding to approximately $11%$ of the population variability across edges.

#figure(
  image("./figs/fuzzy-fc-matrices/npvr_histogram.png", height: 200pt),
  caption: [Histogram of #acr("NPVR") values across the edges of the #acr("FC") matrix.],
) <fc-matrices-hist-fig>

#pagebreak()

We assumed in @graph-metrics-assessment that using more confounds would increase the #acr("NPVR"). However, by looking at the effect of the specific global-signal confound, we can confidently say that this is not the case for all confounds. In fact, this specific confound appears to reduce the #acr("NPVR") of the whole #acr("FC") matrix by more than half, as quantified in @fc-matrices-delta-fig, with a mean and median delta of $-0.126$ and $-0.119$ respectively, and values ranging from $+0.0362$ to $-0.4337$.

#figure(
  grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    align(center)[
      #text(size: 0.8em)[Delta #acr("NPVR") heatmap]
      #image("./figs/fuzzy-fc-matrices/npvr_delta_heatmap.png", width: 100%)
    ],
    align(center)[
      #text(size: 0.8em)[Delta #acr("NPVR") histogram]
      #image("./figs/fuzzy-fc-matrices/npvr_delta_histogram.png", width: 100%)
    ],
  ),
  caption: [Effect of global signal regression on the #acr("NPVR") values across the edges of the #acr("FC") matrix.],
) <fc-matrices-delta-fig>

The heatmap in @fc-matrices-delta-fig also demonstrates that the #acr("NPVR") reduction is widespread across the entire #acr("FC") matrix rather than concentrated in specific regions, with only a small fraction of edges showing increased variability.

To sum it up, the edge-wise analysis revealed substantial numerical variability across the #acr("FC") matrix, with mean and median #acr("NPVR") values of approximately $11%$ of the population variability. The global signal regression confound was found to significantly reduce this variability, halving the #acr("NPVR") across the vast majority of edges. However, this analysis only examined the effect of a single confound. A more comprehensive assessment of how each individual confound contributes to numerical stability would provide valuable insights into optimal preprocessing strategies and could be a promising direction for further analysis.

== PCA-based Feature Extraction Stability

This section presents the results of the #acr("PCA")-based feature extraction pipeline. First, the extraction is applied to both the SRPB and BMB datasets and compared against the findings of Yamashita et al., 2026 #super[#cite(label("10.1162/IMAG.a.1121"))]. The combined impact of numerical noise introduced during #acr("FC") matrix extraction and reduced input precision for the #acr("PCA") on the extracted features is then assessed.

=== Reproduction on the SRPB and BMB Datasets

The results obtained by the original paper already looked pretty consistent since they used a splitting of the SRPB dataset into a discovery and validation set, and obtained similar results. However, it is still important to see if these results stay similar when taking the entire dataset, or even a different one. The comparisons below focus on the second principal component (PC 2), as it consistently emerged as the most informative component across all analyses.

#figure(
  grid(
    columns: 2,
    gutter: 1em,
    grid.cell(colspan: 2, align: center)[
      #image("./figs/fuzzy-pca-analysis/original_fc_edges.jpeg", height: 150pt)
    ],
    align(center)[
      #text(size: 0.8em)[SRPB: Selected FC connections]
      #image("./figs/fuzzy-pca-analysis/srpb_original_fc_plot.png", height: 150pt)
    ],
    align(center)[
      #text(size: 0.8em)[BMB: Selected FC connections]
      #image("./figs/fuzzy-pca-analysis/bmb_original_fc_plot.png", height: 150pt)
    ],
  ),
  caption: [Selected FC connections for #acr("PC") 2 from the original paper (top) and from the SRPB and BMB datasets (bottom). Red edges indicate over-connectivity in #acr("MDD") relative to healthy controls, blue edges indicate under-connectivity.]
) <fc-edges-comparison>

@fc-edges-comparison compares the original results (top) with those obtained on the SRPB and BMB datasets (bottom). Red edges indicate over-connectivity in #acr("MDD") relative to healthy controls, blue edges indicate under-connectivity. The specific #acr("FC") connections selected by the #acr("PCA") feature extraction differ across all comparisons, whether considering the discovery and validation splits of the original dataset, the complete SRPB and BMB datasets, or each individual dataset against the original splits. However, analyzing the direction of the connectivity differences reveals a consistent pattern: the vast majority of connections show under-connectivity in #acr("MDD") subjects across all datasets. The distribution of these connections across functional networks for both full datasets is detailed in @network-stats-fig. While the original paper highlighted thalamic and motor regions as the primary drivers, our analysis reveals a broader and more variable involvement of prefrontal, motor, and subcortical networks. Although the relative dominance of these networks varies between the SRPB and BMB datasets, their consistent presence across analyses suggests they are key drivers of the identified connectivity patterns.

#figure(
  grid(
    columns: 2,
    gutter: 1em,
    align(center)[
      #text(size: 0.8em)[SRPB: Edges per network]
      #image("./figs/fuzzy-pca-analysis/srpb_edge_per_network_original.png", height: 150pt)
    ],
    align(center)[
      #text(size: 0.8em)[SRPB: Inter-connections]
      #image("./figs/fuzzy-pca-analysis/srpb_inter_connections_original.png", height: 150pt)
    ],
    align(center)[
      #text(size: 0.8em)[BMB: Edges per network]
      #image("./figs/fuzzy-pca-analysis/bmb_edge_per_network_original.png", height: 150pt)
    ],
    align(center)[
      #text(size: 0.8em)[BMB: Inter-connections]
      #image("./figs/fuzzy-pca-analysis/bmb_inter_connections_original.png", height: 150pt)
    ],
  ),
  caption: [Network statistics for SRPB and BMB datasets, showing edges per network and inter-network connections.]
) <network-stats-fig>


=== Results of the perturbed extraction

Comparing the results across the different perturbed runs allows us to assess whether the #acr("PCA") feature extraction is stable not only across different multi-site datasets, but also under numerical perturbations. We first examine the impact of the `np.corrcoef` perturbations detailed in @np-corrcoef, which target only the correlation computation step.

#figure(
  image("./figs/fuzzy-pca-analysis/fuzzy-np-corrcoef-effect.png", height: 200pt),
  caption: [Effect of numerical perturbation on correlation coefficient computation.],
) <fuzzy-corrcoef-effect-fig>

As @fuzzy-corrcoef-effect-fig illustrates, the #acr("MCA") perturbation of the `np.corrcoef` function introduces only minimal numerical noise into the resulting coefficients, with a mean absolute difference of $1.656 times 10^(-16)$ and a maximum of $2.419 times 10^(-8)$. These results are consistent with the findings of Denis et al., 2018 #super[@denis2018verificarlocheckingfloatingpoint], who demonstrated that Verificarlo's perturbations remain within the expected bounds of floating-point uncertainty. It is worth noting that the magnitude of these perturbations depends fundamentally on the numerical stability of the perturbed function itself. Less stable operations would be expected to amplify the perturbations more significantly.


#figure(
  grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    align(center)[
      #text(size: 0.8em)[SRPB: Original FC connections]
      #image("./figs/fuzzy-pca-analysis/srpb_original_fc_plot.png", height: 150pt)
    ],
    align(center)[
      #text(size: 0.8em)[SRPB: FC consensus (100 runs)]
      #image("./figs/fuzzy-pca-analysis/srpb_fc_100_consensus.png", height: 150pt)
    ],
    align(center)[
      #text(size: 0.8em)[BMB: Original FC connections]
      #image("./figs/fuzzy-pca-analysis/bmb_original_fc_plot.png", height: 150pt)
    ],
    align(center)[
      #text(size: 0.8em)[BMB: FC consensus (15 runs)]
      #image("./figs/fuzzy-pca-analysis/bmb_fc_100_consensus.png", height: 150pt)
    ],
  ),
  caption: [Comparison of original and consensus #acr("FC") connections for SRPB (top) and BMB (bottom) datasets.]
) <fc-consensus-fig>

@fc-consensus-fig displays the selected FC connections using the same color scheme: red for over-connectivity and blue for under-connectivity in #acr("MDD") subjects relative to healthy controls. It compares the original results with the consensus connections retained across all perturbed runs for both the SRPB (100 runs) and BMB (15 runs) datasets. The original and consensus plots are identical, demonstrating that the feature extraction process is entirely robust to the introduced numerical perturbations. This is further supported by examining not only the visual representation of the FC connections, but also the computed network statistics. Both the edges per network (@edge-network-consensus-fig) and the inter-connections (@inter-connections-consensus-fig) remain identical between the original and consensus results.

#figure(
  grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    align(center)[
      #text(size: 0.8em)[SRPB: Original edges per network]
      #image("./figs/fuzzy-pca-analysis/srpb_edge_per_network_original.png", height: 130pt)
    ],
    align(center)[
      #text(size: 0.8em)[SRPB: Edges per network consensus (100 runs)]
      #image("./figs/fuzzy-pca-analysis/srpb_edge_per_network_100_consensus.png", height: 130pt)
    ],
    align(center)[
      #text(size: 0.8em)[BMB: Original edges per network]
      #image("./figs/fuzzy-pca-analysis/bmb_edge_per_network_original.png", height: 130pt)
    ],
    align(center)[
      #text(size: 0.8em)[BMB: Edges per network consensus (15 runs)]
      #image("./figs/fuzzy-pca-analysis/bmb_edge_per_network_100_consensus.png", height: 130pt)
    ],
  ),
  caption: [Comparison of original and consensus edges per network for SRPB (top) and BMB (bottom) datasets.]
) <edge-network-consensus-fig>

#figure(
  grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    align(center)[
      #text(size: 0.8em)[SRPB: Original inter-connections]
      #image("./figs/fuzzy-pca-analysis/srpb_inter_connections_original.png", height: 150pt)
    ],
    align(center)[
      #text(size: 0.8em)[SRPB: Inter-connections consensus (100 runs)]
      #image("./figs/fuzzy-pca-analysis/srpb_inter_connections_100_consensus.png", height: 150pt)
    ],
    align(center)[
      #text(size: 0.8em)[BMB: Original inter-connections]
      #image("./figs/fuzzy-pca-analysis/bmb_inter_connections_original.png", height: 150pt)
    ],
    align(center)[
      #text(size: 0.8em)[BMB: Inter-connections consensus (15 runs)]
      #image("./figs/fuzzy-pca-analysis/bmb_inter_connections_100_consensus.png", height: 150pt)
    ],
  ),
  caption: [Comparison of original and consensus inter-connections for SRPB (top) and BMB (bottom) datasets.]
) <inter-connections-consensus-fig>

Overall, the reproduction of the #acr("PCA")-based feature extraction on the complete SRPB and BMB datasets confirmed the general pattern of under-connectivity in #acr("MDD") subjects observed in the original study, while revealing a broader and more variable involvement of prefrontal, motor, and subcortical networks. Crucially, the perturbation analysis demonstrated that this pipeline is highly numerically stable. The combined numerical noise introduced during both the correlation computation and the 32-bit #acr("PCA") dimensionality reduction did not propagate to the final selected biomarkers, which remained entirely unchanged across all perturbed runs. This robustness suggests that the method is reliable and resilient to the floating-point variations typically encountered across different computational environments.

= Conclusion

This bachelor thesis successfully achieved its three main objectives. First, it reproduced the findings of Alizadeh et al., 2026 #super[@Alizadeh2025.12.22.695524], identifying and correcting a bug in the original #acr("NPVR") simulation pipeline. The stability of graph metrics was further evaluated using a different multi-site dataset and a more extensive confound regression strategy. Despite these methodological changes, the analyzed graph metrics exhibited trends consistent with the original study, while notably demonstrating that applying a larger number of confounds significantly increases the overall #acr("NPVR") and amplifies its variability across thresholds. Second, it extended the stability analysis to the #acr("FC") matrices themselves, revealing a substantial numerical variability of approximately $11%$ of the population variability across individual edges when using all 15 confounds. While the graph metrics assessment suggested that adding confounds generally increases numerical variability, the global-signal regression proved to be a notable exception, as its inclusion effectively halved the #acr("NPVR") across the vast majority of edges. Third, it evaluated the numerical stability of the #acr("PCA") feature extraction of #acr("MDD") biomarkers proposed by Yamashita et al., 2026 #super(cite(label("10.1162/IMAG.a.1121"))) by perturbing two distinct steps of its pipeline, as well as its generalization when applied to the complete SRPB and BMB datasets. This method consistently selected #acr("FC") connections across similar but broader brain networks, characterized by widespread under-connectivity in #acr("MDD") subjects. However, the relative contribution of these networks varied between datasets. In the SRPB dataset, the Subcortical network was the most represented, with its connection to the PrefrontalControlA network being the most frequent. In the BMB dataset, the PrefrontalControlA network itself, along with its connections to the SomatoMotor network, emerged as the most significant. The perturbations introduced during the correlation computation and the 32-bit #acr("PCA") dimensionality reduction had no effect on the final extracted biomarkers. This confirms that while the specific connectivity patterns vary across datasets, the pipeline's results remain entirely robust to numerical perturbations.

Building on these findings, several promising directions for future research emerge. First, while this study highlighted the contrasting effects of global signal regression, a systematic assessment of the individual contributions of each confound to the #acr("NPVR") would be highly valuable. Understanding which specific regressors introduce the most numerical noise could guide the optimization of preprocessing pipelines for maximum stability. Second, the numerical robustness of the #acr("PCA") feature extraction pipeline could be further stress-tested. Beyond the correlation computation and precision reduction evaluated here, future work could introduce perturbations into the cross-site harmonization step, as well as the confound regression process itself. Ultimately, these extensions would further solidify the reliability of these biomarkers for clinical applications.


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
