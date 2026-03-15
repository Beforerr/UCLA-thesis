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
    "Anton Artemyev",
    "Marco Velli",
    "Hao Cao",
  ),
  abstract: [Your abstract text here.],
  bibliography: bibliography("research.bib"),
  acknowledgments: [
    Acknowledgments must be included if any of the following apply; otherwise, they are optional.
  ],
  dedication: [],
)

#include "_intro.typ"

#include "_review_current_sheet.typ"

#include "_review_energetic_particles.typ"

#include "_juno.typ"

#include "_psp.typ"

#include "_scattering.typ"

#include "_summary.typ"