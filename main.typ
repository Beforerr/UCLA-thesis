#import "lib.typ": uclathesis

#show: uclathesis.with(
  title: [Kinetic-scale Solar Wind Current Sheets: Statistical Characteristics and Their Role in Energetic Particle Transport],
  author: "Zijin Zhang",
  degree: "Doctor of Philosophy",
  major: "Planetary Science",
  year: 2026,
  doc-type: "dissertation", // or "thesis" for master's
  committee-chair: "Vassilis Angelopoulos",
  committee-members: (
    "Anton Artemyev", // aartemyev@igpp.ucla.edu
    "Marco Velli", // mvelli@ucla.edu
    "Hao Cao", // hcao@epss.ucla.edu
    "Paulo Alves", // epalves@physics.ucla.edu
  ),
  abstract: [
    The transport of solar energetic particles (SEPs) through the heliosphere is governed by their interaction with the turbulent interplanetary magnetic field, yet standard quasi-linear models---which assume scattering by small-amplitude, randomly phased fluctuations---fail to account for the coherent, intermittent structures that pervade the solar wind. This dissertation provides a quantitative, observation-informed framework for understanding how kinetic-scale current sheets scatter energetic particles and shape their transport across the inner heliosphere. On the observational side, we analyze more than 175,000 current sheets identified by Parker Solar Probe (0.17 AU), Juno (1--5 AU), ARTEMIS, WIND, and STEREO using a robust, time-resolution-independent detection algorithm. The central finding is that current sheet properties---normalized thickness (2--4 ion inertial lengths) and current density (0.05--0.15 Alfvén current densities)---are largely invariant across 0.17--5 AU, with a universal inverse correlation between current density and spatial scale extending over several orders of magnitude. On the theoretical side, we develop an exact Hamiltonian formulation for particle motion in force-free current sheets and conduct extensive test-particle simulations parameterized by the observed distributions of current sheet properties at 0.1 and 1 AU. The scattering is dominated by geometrical chaotization---the destruction of the quasi-adiabatic invariant at separatrix crossings---which produces order-unity pitch-angle jumps within single interactions, a mechanism qualitatively distinct from resonant wave--particle diffusion. By chaining these interactions through a Monte Carlo transport model, we show that both parallel and perpendicular diffusion coefficients exhibit asymptotically diffusive behavior, but with a perpendicular-to-parallel ratio that increases with particle energy and exceeds standard quasi-linear predictions above ~1 MeV. These results identify current sheets as efficient drivers of energetic particle scattering throughout the inner heliosphere, offering a natural explanation for SEP transport phenomena that have long challenged purely wave-based models, including broad particle reservoirs and rapid longitudinal spreading.
  ],
  bibliography: bibliography("research.bib"),
  acknowledgments: [
    I owe my deepest gratitude to my advisors, Professor Vassilis Angelopoulos and Dr. Anton Artemyev, for their guidance, patience, and unwavering support throughout my doctoral studies. They granted me the freedom to pursue my own research interests and encouraged me to explore the broader scientific landscape, while always providing the insight and direction I needed to move forward.

    I am profoundly grateful to my parents for their unconditional love and support. They gave me the freedom to explore the world and the confidence to chart my own path. Their spirit of curiosity and perseverance has been a lasting source of inspiration.

    I also wish to thank my friends, roommates (Kyle Webster, Travis Gilmore, Saeed), and climbing partners (Jiabang Chen and many others) for making these years not only productive but genuinely joyful. Their companionship, humor, and shared adventures have been an essential part of this journey.
  ],
  dedication: [],
)

// Chapter 1: Introduction (general intro + review subsections + thesis organization)
#include "_intro.typ"
#include "_thesis_org.typ"
#[
  #set heading(offset: 1)
  #include "_review_current_sheet.typ"
  #include "_review_energetic_particles.typ"
]

#include "_juno.typ"

#include "_psp.typ"

#include "_scattering.typ"

#include "_transport.typ"

#include "_summary.typ"

// Appendices
#counter(heading).update(0)
#set heading(numbering: "A.1", supplement: [Appendix])
#set figure(numbering: (..num) =>
  numbering("A.1", counter(heading).get().first(), num.pos().first())
)
#show heading.where(level: 1): it => {
  pagebreak(weak: true)
  v(0.5in)
  counter(figure.where(kind: image)).update(0)
  set text(size: 14pt, weight: "bold")
  if it.numbering != none {
    [Appendix ]
    counter(heading).display("A")
    linebreak()
  }
  it.body
  v(0.3in)
}

#include "_multifluid.typ"

#include "_spedas.typ"
