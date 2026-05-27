#import "lib.typ": appendices, uclathesis

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
    "Marco CM Velli", // mvelli@ucla.edu
    "Hao Cao", // hcao@epss.ucla.edu
    "Eduardo Paulo Jorge Da Costa Alves", // epalves@physics.ucla.edu
  ),
  abstract: [
    The transport of solar energetic particles (SEPs) through the heliosphere is governed by their interaction with the highly variable interplanetary magnetic field. Yet standard quasi-linear models, which assume scattering by small-amplitude, randomly phased fluctuations, fail to account for current sheets, coherent, intermittent structures that pervade the solar wind. This dissertation develops a quantitative, observation-informed framework for understanding how kinetic-scale current sheets scatter energetic particles and shape their transport across the inner heliosphere. On the observational side, we analyze more than 175,000 current sheets identified by Parker Solar Probe (0.17 AU), Juno (1--5 AU), ARTEMIS, WIND, and STEREO using a robust, time-resolution-independent detection algorithm. We find that their normalized thicknesses (2--4 ion inertial lengths) and current densities (0.05--0.15 Alfvén current densities) remain broadly invariant across 0.17--5 AU and follow an inverse current density--scale relation spanning several orders of magnitude. Theoretically, we develop an exact Hamiltonian description of particle motion in force-free current sheets and conduct extensive test-particle simulations parameterized by the observed property distributions at 0.1 and 1 AU. We find that the scattering is dominated by geometrical chaotization, the destruction of the quasi-adiabatic invariant at separatrix crossings, which produces order-unity pitch-angle jumps within single interactions, a mechanism qualitatively distinct from resonant wave--particle diffusion. By evaluating the aggregate effect of multiple, sequential interactions through a Monte Carlo transport model, we show that both parallel and perpendicular diffusion coefficients exhibit asymptotically diffusive behavior, but with a perpendicular-to-parallel ratio that increases with particle energy and exceeds standard quasi-linear predictions above ~1 MeV. These results identify current sheets as efficient drivers of energetic particle scattering throughout the inner heliosphere, offering a natural explanation for SEP transport phenomena that have long challenged purely wave-based models, including broad particle reservoirs and rapid longitudinal spreading.
  ],
  bibliography: bibliography("research.bib"),
  acknowledgments: include "_acknowledgments.typ",
  dedication: [
    To my parents, \
    for my mother's kind heart and quiet courage, \
    for my father's steady strength and quiet faith in me, \
    and for the love that has carried me further than I will ever know.

    #v(1em)

    献给我的父母 \
    感谢母亲的善良与坚韧， \
    感谢父亲的沉稳与信任， \
    是您们的爱伴我走过此生最远的路。
  ],
  vita: include "_vita.typ",
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

#show: appendices

#include "_multifluid.typ"

#include "_spedas.typ"
