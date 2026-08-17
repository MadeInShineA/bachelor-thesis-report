//        ___ ____   ____      _   _ _____ ___
//       |_ _/ ___| / ___|    | | | | ____|_ _|     Informatique et
//        | |\___ \| |   ___  | |_| |  _|  | |       systèmes de communication
//        | | ___) | |__|___| |  _  | |___ | |       HEI Sion · HES-SO Valais / mui 24-26
//       |___|____/ \____|    |_| |_|_____|___|
//
//   52 65 61 64 69 6e 67 20 68 65 78 20 66 6f 72 20 66 75 6e 3f 20 49 53 43 20 66 6f 72 65 76 65 72
//
// Adapted from the BFH year book idea at https://www.bfh.ch/dam/jcr:e512ae31-a3ed-4b65-b589-870383d794b0/abschlussarbeiten-bsc-informatik.pdf

#import "@preview/isc-hei-bthesis:0.8.1"

// Must be <= 365 characters long.
#let summary = "This thesis investigates the numerical stability of fMRI connectivity biomarkers. Using floating-point perturbations, it assesses graph metrics, connectivity matrices, and PCA-based feature extraction, demonstrating that key biomarkers for depression research remain robust despite computational variability."

#let content = [

== Context
Functional magnetic resonance imaging (fMRI) enables non-invasive observation of brain activity, making it a cornerstone of modern neuroscience. A key application is the analysis of functional connectivity (FC), which examines temporal correlations between brain regions to construct connectivity matrices. These matrices serve as the foundation for deriving biomarkers used in clinical research, particularly for conditions such as major depressive disorder (MDD).

Small numerical perturbations introduced by factors such as operating system differences, hardware architecture, and parallelization strategies can propagate through the pipeline, potentially affecting downstream results. In clinical applications, where reproducibility is essential, understanding and quantifying this numerical variability is critical.



== Approach
This thesis investigates the numerical stability of fMRI connectivity biomarkers at three levels using Monte Carlo Arithmetic (MCA) to introduce controlled floating-point perturbations. A custom Docker container ran the fMRIPrep preprocessing pipeline with MCA instrumentation.

First, the stability of graph-theoretical metrics was assessed by reproducing Alizadeh et al., 2026#footnote[M. Alizadeh, Y. Chatelain, G. Kiar, and T. Glatard, “Numerical Variability of functional MRI Graph Measures,” bioRxiv, 2026, doi: #link("doi.org/10.64898/2025.12.22.695524", "10.64898/2025.12.22.695524").]'s work on a different multi-site dataset with a more extensive confound regression strategy (15 vs. 6 confounds), using perturbed fMRIPrep outputs. FC matrices were thresholded at multiple values (0.05 to 0.5) before computing graph metrics.
#linebreak()
Second, the analysis was extended to individual edges of the FC matrices to assess edge-wise numerical variability and compare the impact of different confound strategies, particularly global signal regression.
#linebreak()
Finally, the stability of Yamashita et al., 2026's#footnote[A. Yamashita et al., “Extraction of robust functional connectivity patterns across psychiatric disorders using principal component analysis-based feature selection,” Imaging Neuroscience, vol. 4, p. IMAG.a.1121, 2026, doi: #link("https://direct.mit.edu/imag/article/doi/10.1162/IMAG.a.1121/134875/Extraction-of-robust-functional-connectivity", "10.1162/IMAG.a.1121").] PCA-based feature extraction method for MDD biomarkers was evaluated. The method was applied to the complete SRPB and BMB datasets to assess cross-dataset stability, and then tested under targeted perturbations of FC matrix computation and PCA dimensionality reduction, with inputs cast from 64-bit to 32-bit precision.


#colbreak()

== Results
Graph metrics reproduction showed consistent trends with the original study across thresholds, but with Numerical-Population Variability Ratio (NPVR) values exceeding the 0.1–0.2 range originally reported. The more extensive confound regression (15 vs. 6 confounds) amplified this variability substantially.

At the edge level, FC matrices exhibited substantial variability, with a mean NPVR of approximately 11% using 15 confounds. Notably, the inclusion of global signal regression halved this variability across most edges, suggesting it acts as a strong stabilizer against floating-point perturbations.


PCA-based feature extraction proved robust across datasets and perturbations. The pattern of MDD under-connectivity remained consistent (prefrontal, motor, and subcortical regions), and selected biomarkers were identical across all 100 perturbed runs on the SRPB dataset and 15 on the BMB one.

#figure(
  grid(
    columns: 2,
    gutter: 0.5em,
    align(center)[
      #image("./figs/fuzzy-pca-analysis/srpb_original_fc_plot.png", height: 3cm)
    ],
    align(center)[
      #image("./figs/fuzzy-pca-analysis/srpb_fc_100_consensus.png", height: 3cm)
    ],
  ),
  caption: [SRPB dataset PCA-selected biomarkers: original (left) versus consensus after 100 perturbed runs (right)],
)

== Conclusion
Graph metrics were successfully reproduced with consistent trends, though at higher variability than previously reported. Edge-level analysis revealed substantial floating-point sensitivity, mitigated by global signal regression. PCA-based feature extraction proved remarkably robust. Across both datasets, biomarkers showed the same under-connectivity patterns and involved the same brain areas, and under numerical perturbations, the selected biomarkers remained perfectly stable within each dataset. Future work could examine all individual confound effects or apply additional perturbations to the PCA features extraction pipeline.

// This is the end !
]

// TODO: please modify the following to suit your needs.
#show: project.with(
  title: "Numerical Stability of Functional MRI\n Connectivity Biomarkers",
  subtitle: none, // Optional, use none if not needed
  language: "en", // Valid values are [en, fr]
  authors: "Olivier Amacker",
  student-picture: image("figs/me.png"), // [Optional], put none if not used
  permanent-email: "olivier.amacker@netplus.ch", // [Optional], put none if not used. Prefer a long term viable address!
  video-url: none, // A link to the video of you project, or none
  project-website-url: "https://olivier.amacker.dev/bachelor-thesis/site/index.html",

  hide-completeness-warning: true,

  // DISCLAIMER: Your picture and email address will be used in the printed
  // ISC bachelor thesis brochure. Unless you opt out below, they will also
  // appear on the ISC web page. Set the relevant flag to true to opt out.
  picture-web-opt-out: false, // set to true to keep your picture off the web
  email-web-opt-out: false,   // set to true to keep your email off the web

  summary: summary, // Not to be changed
  content: content, // Not to be changed

  thesis-supervisor: "Prof. Dr Oscar Esteban",
  thesis-co-supervisor: "Dr Okito Yamashita", // Optional, use none if not needed
  thesis-expert: "Dr Ayumu Yamashita", // Optional, use none if not needed
  academic-year: "2025-2026", // Optional, use none if not needed

  doc-type: "exec-summary", // This is an executive summary, not a full thesis

  school: "Haute École d'Ingénierie de Sion",
  programme: "Informatique et systèmes de communication",

  // Some keywords related to your thesis
  keywords: ("medical data science", "fMRI", "fMRIPrep", "numerical stability", "bio-markers", "PCA", "neuroimaging", "MDD"),
  major : "Data engineering", // "Software engineering", "Networks and systems", "Embedded systems", "Computer security", "Data engineering""

  bind: right, // Bind the left side of the page
  footer: none, // align(right, text(0.9em)[This is some content for the footer])
)
