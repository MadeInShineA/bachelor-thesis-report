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
  keywords: ("medical data science", "fMRI", "fMRIPrep", "numerical stability", "benchmark", "PCA", "neuro imaging"),
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

Using these tools, the impact of numerical variability has been investigated across several neuroimaging domains such as functional, structural and diffusion imaging. As introduced in @intro, Alizadeh et al., 2026 #super[@Alizadeh2025.12.22.695524] evaluated the numerical variability of different graph measures derived from the #acr("FC") matrices resulting from the widely used #link("https://fmriprep.org/en/stable/", "fMRIPrep") Esteban et al., 2019 #super[@fMRIPrep] preprocessing pipeline. Using the #acr("NPVR") metric, they obtained values ranging from 0.1 to 0.2 for most graph metrics. These results were found to vary across brain regions, #acr("FC") thresholds and confound regression strategies.

In structural imaging pipelines, Mirhakimi et al., 2025 #super[@mirhakimi2025numericaluncertaintylinearregistration] investigated numerical uncertainty in linear registration algorithms, demonstrating that small floating-point variations can lead to measurable differences in image alignment. Similarly, Chatelain et al., 2026 #super[@Chatelain2026.01.09.698203] quantified the impact of numerical variability on structural #acr("MRI") measures in Parkinson's disease, finding that numerical variation reached nearly one-third of population variability in multiple cortical and subcortical regions.

In diffusion imaging pipelines, Kiar et al., 2021 #super[@kiar2021] showed that numerical uncertainty in analytical workflows leads to impactful variability in brain network measurements, revealing that different computational environments can produce substantially different connectivity results.

Interestingly, numerical variability has also been used as a resource rather than a limitation. Gonzalez-Pepe et al., 2026 #super[@gonzalezpepe2026fuzzypytorchrapidnumerical] established that controlled numerical perturbations can serve as an effective data augmentation strategy for deep learning models, artificially expanding training datasets and improving model generalization.

However, these stability conclusions cannot be generalized across pipelines due to heterogeneous methodologies and implementations. While graph-theoretical metrics have been studied by Alizadeh et al., 2026 #super[@Alizadeh2025.12.22.695524], edge-wise #acr("FC") matrix stability remains unexplored. Additionally, the #acr("PCA")-based feature extraction proposed by Yamashita et al., 2026 #super[#cite(label("10.1162/IMAG.a.1121"))] has shown robustness across different sites and datasets, making its numerical stability verification crucial. This thesis addresses these gaps through edge-wise #acr("FC") analysis and #acr("PCA")-based extraction evaluation.

= Development and Methodology

This section describes the development process and methodology underlying this thesis. Beyond the thesis-specific code, this work included contributions to external repositories via pull requests, including fixes to the #link("https://github.com/ISC-HEI/isc-hei-typst-templates")[ISC-HEI Typst thesis template], enhancements to #link("https://github.com/Ayumu722/pca-based-feature-extraction")[Yamashita et al.'s PCA-based feature extraction package], and a correction to the #acr("NPVR") simulation in #link("https://github.com/mina94az/Numerical-Variability-of-functional-MRI-Graph-Measures")[Alizadeh et al.'s repository].

== Code availability

The code developed during this bachelor thesis is publicly available on #link("https://github.com/madeinshinea/bachelor-thesis", "GitHub"). The repository is organized using #link("https://git-scm.com/book/en/v2/Git-Tools-Submodules", "git submodules") to separate concerns: the `bachelor-thesis-report` submodule contains this Typst report, while the `bachelor-thesis-project` submodule contains all analysis code, including preprocessing pipelines, analysis notebooks, and job submission scripts for the #acr("ATR") #link("https://en.wikipedia.org/wiki/High-performance_computing", acr("HPC")) cluster.

An interactive project website is available at #link("https://olivier.amacker.dev/bachelor-thesis")[olivier.amacker.dev/bachelor-thesis], providing browsable access to the four analysis notebooks developed with #link("https://marimo.io/", "Marimo") and their respective outputs, a daily journal documenting the project's progress, and the different presentations delivered during the thesis.

The development environment is managed via #link("https://nixos.org/", "Nix") and #link("https://docs.astral.sh/uv/", "uv"), ensuring its reproducibility. The fuzzy fMRIPrep #link("https://www.docker.com/", "Docker") container, built on #link("https://github.com/verificarlo/verificarlo", "Verificarlo") and the Fuzzy libmath library, is published on #link("https://hub.docker.com/repository/docker/madeinshinea/fuzzy-fmriprep/general", "DockerHub") for reproducibility.

== Reproduction of Alizadeh et al., 2026

=== NPVR Simulation

=== Graph Metrics Stability Assessment

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
