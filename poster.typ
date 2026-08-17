// ─────────────────────────────────────────────────────────────────────────────
// ISC Poster — Numerical Stability of Functional MRI Connectivity Biomarkers
// ─────────────────────────────────────────────────────────────────────────────

#import "@preview/isc-hei-poster:0.8.1": isc-poster, isc-card, isc-colbreak

#import "@preview/acrostiche:0.7.0": *
#include "acronyms.typ"

#let poster-orientation = "portrait"

#show: isc-poster.with(
  title: "Numerical Stability of Functional MRI\nConnectivity Biomarkers",
  subtitle: none,
  student: "Olivier Amacker",
  permanent-email: "olivier.amacker@netplus.ch",
  supervisor: "Prof. Dr Oscar Esteban",
  co-supervisor: "Dr Okito Yamashita",
  expert: "Dr Ayumu Yamashita",
  thesis-id: "ISC-ID-26-1",
  academic-year: "2025-2026",
  school: "Haute École d'Ingénierie de Sion",
  programme: "Informatique et Systèmes de communication",
  major: "Data Engineering",
  orientation: poster-orientation,
  language: "en",
  num-columns: 2,
  distribute-columns: false,
  hide-completeness-warning: true,
  project-website-url: "https://olivier.amacker.dev/bachelor-thesis",
)

// ─── Column 1 ────────────────────────────────────────────────────────────────

#isc-card(title: "Context and Motivation")[
  #acr("fMRI") enables non-invasive observation of brain activity. A key application is #acr("FC") analysis, which constructs connectivity matrices serving as biomarkers for conditions such as #acr("MDD").

  As pipelines become more computationally intensive, small perturbations from #acr("OS") differences, hardware, and parallelization can propagate and affect results.

  #figure(
    image("figs/os_result_difference.png", height: 13.5cm),
    caption: [Same program, different results across operating systems.],
  )
]

#isc-card(title: "Methodology")[
  Monte Carlo Arithmetic via Fuzzy introduces controlled random perturbations to every floating-point operation during fMRIPrep (25.2.5) preprocessing, simulating numerical variability across different computers.

  The first two analyses reused the perturbed preprocessing outputs:
  + *Graph metrics*: the #acr("NPVR") was used to assess the stability of network summary measures on perturbed FC matrices across thresholds and brain regions (Alizadeh et al., 2026).
  + *Edge-wise #acr("FC")*: #acr("NPVR") was computed for each of the 4,950 edges, and the effect of global signal regression on numerical stability was quantified.

  The third analysis perturbed a separate feature extraction pipeline:
  + *#acr("PCA") biomarkers*: the numerical stability of the #acr("PCA")-based feature extraction method of Yamashita et al., 2026 was assessed by perturbing `np.corrcoef` with MCA and forcing the #acr("PCA") to 32-bit inputs, on SRPB and BMB datasets.
]

#isc-card(title: "Graph Metrics Reproduction")[
  Reproduced on a different multi-site dataset furnished by ATR (Kyoto) with more extensive confound regression (15 vs. 6 regressors), the graph metrics displayed broadly similar trends to the original study, but with consistently higher #acr("NPVR") values across all metrics and thresholds.

  The confound regression effect was considerably larger and more variable across thresholds than originally reported, with differences spanning a much wider range.

  *Finding:* Graph metrics reproduce similar trends but with higher numerical sensitivity. A more extensive confound regression strategy amplifies variability beyond what was originally reported.
]

#isc-card(title: "Edge-wise FC Stability")[
  Edge-wise #acr("NPVR") ranged from 0.036 to 0.297 (mean ~0.11), with clear spatial patterns of numerical sensitivity across the brain. Global signal regression halved variability across most of the 4,950 connections, with the reduction widespread rather than concentrated in specific regions.

  #figure(
    grid(
      columns: (1fr, 1fr),
      gutter: 6pt,
      image("figs/fuzzy-fc-matrices/npvr_heatmap.png", height: 3cm),
      image("figs/fuzzy-fc-matrices/npvr_delta_heatmap.png", height: 3cm),
    ),
    caption: [Left: #acr("NPVR") heatmap. Right: delta #acr("NPVR") after removing global signal regression.],
  )

  #figure(
    grid(
      columns: (1fr, 1fr),
      gutter: 6pt,
      image("figs/fuzzy-fc-matrices/npvr_histogram.png", height: 3cm),
      image("figs/fuzzy-fc-matrices/npvr_delta_histogram.png", height: 3cm),
    ),
    caption: [Left: edge-wise #acr("NPVR") distribution. Right: delta #acr("NPVR") distribution.],
  )

  *Finding:* Edge-wise stability is uneven; global signal regression reduces numerical variability across most connections.
]



#isc-card(title: "PCA Biomarker Stability")[
  Reproduced on complete SRPB and BMB datasets, both showed consistent #acr("MDD") under-connectivity across prefrontal, motor, and subcortical networks, though regional dominance varied.

  #acr("PCA") biomarkers were identical across all perturbed runs (100 SRPB, 15 BMB), even with MCA-perturbed `np.corrcoef` and 32-bit inputs.

  #figure(
    grid(
      columns: (1fr, 1fr),
      gutter: 6pt,
      align(center)[
        #text(size: 0.75em)[SRPB: single run]
        #image("figs/fuzzy-pca-analysis/srpb_original_fc_plot.png", height: 5cm)
      ],
      align(center)[
        #text(size: 0.75em)[SRPB: 100 perturbed runs]
        #image("figs/fuzzy-pca-analysis/srpb_fc_100_consensus.png", height: 5cm)
      ],
    ),
    caption: [Identical SRPB biomarkers from a single run (left) and 100 perturbed runs (right). Red = over-connected, blue = under-connected in #acr("MDD").],
  )

  *Finding:* #acr("PCA") biomarkers are numerically stable: identical connections across all perturbed runs, with the same #acr("MDD") under-connectivity pattern generalizing across datasets despite varying regional importance.
]

#isc-card(title: "Key Takeaways")[
  - *Graph metrics* reproduce similar trends but with higher #acr("NPVR") than originally reported; more extensive confound regression (15 vs. 6 regressors) amplifies variability more than originally reported.
  - *Edge-wise #acr("FC")* shows uneven stability (NPVR 0.036–0.297, mean ~0.11). Global signal regression halves variability across most connections, with widespread rather than region-specific reduction.
  - *#acr("PCA") biomarkers* are completely stable within each dataset (identical connections across all perturbed runs). The same #acr("MDD") under-connectivity pattern generalizes across SRPB and BMB, but regional importance and specific connections vary.

  *Open questions*: how do other PCA pipeline steps respond to perturbation, and what is each confound's precise effect on #acr("NPVR")?
]
