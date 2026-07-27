#import "@preview/acrostiche:0.7.0": *


#let acronyms = (
  // English
  "fMRI": (
    link("https://en.wikipedia.org/wiki/Functional_magnetic_resonance_imaging")[functional Magnetic Resonance Imaging],
  ),
  "OS": (link("https://en.wikipedia.org/wiki/Operating_system")[Operating System],),
  "MDD": (link("https://en.wikipedia.org/wiki/Major_depressive_disorder")[Major Depressive Disorder],),
  "FC": ("Functional Connectivity",),
  "MRI": (link("https://en.wikipedia.org/wiki/Magnetic_resonance_imaging")[Magnetic Resonance Imaging],),
  "NPVR": "Numerical Population Variability Ratio",
  "PCA": (link("https://en.wikipedia.org/wiki/Principal_component_analysis")[Principal Component analysis],),
  "PR": "Pull Request",
  "ATR": (link("https://www.atr.jp/index_e.html")[Advanced Telecommunications Research Institute International],),

  // French
  "IRMf": (
    link(
      "https://fr.wikipedia.org/wiki/Imagerie_par_r%C3%A9sonance_magn%C3%A9tique_fonctionnelle",
    )[imagerie par résonance magnétique fonctionnelle],
  ),
  "SE": (link("https://fr.wikipedia.org/wiki/Syst%C3%A8me_d%27exploitation")[Système d'Exploitation],),
  "TDM": ("Trouble Dépressif Majeur",),
  "CF": ("Connectivité Fonctionnelle",),
  "IRM": (
    link(
      "https://fr.wikipedia.org/wiki/Imagerie_par_r%C3%A9sonance_magn%C3%A9tique",
    )[Imagerie par Résonance Magnétique],
  ),
  "ACP": (
    link("https://fr.wikipedia.org/wiki/Analyse_en_composantes_principales")[Analyse en Composantes Principales],
  ),
)

#init-acronyms(acronyms)
