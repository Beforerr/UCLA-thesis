#import "@local/uclathesis:0.1.0": uclathesis
#import "@preview/cmarker:0.1.8"

#let citet(..citation) = cite(..citation, form: "prose")

#show: uclathesis.with(
  title: [Kinetic-scale solar wind current sheets: statistical characteristics and their role in energetic particle transport],
  author: "Zijin Zhang",
  degree: "Doctor of Philosophy",
  major: "Your Major",
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

#pagebreak()

#include "_review_current_sheet.typ"

#pagebreak()

#include "_review_energetic_particles.typ"

#pagebreak()

#include "_juno.typ"

#pagebreak()

#include "_psp.typ"

#pagebreak()

#include "_scattering.typ"

#pagebreak()

#include "_summary.typ"

#pagebreak()

