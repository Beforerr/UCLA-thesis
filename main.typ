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
    I owe my deepest gratitude to my advisors, Professor Vassilis Angelopoulos and Dr. Anton Artemyev, for their guidance, patience, and unwavering support throughout my doctoral studies. They granted me the freedom to pursue my own research interests and encouraged me to explore the broader scientific landscape, while always providing the insight and direction I needed to move forward.

    I am profoundly grateful to my parents for their unconditional love and support. They gave me the freedom to explore the world and the confidence to chart my own path. Their spirit of curiosity and perseverance has been a lasting source of inspiration.

    I also wish to thank my friends, roommates (Kyle Webster, Travis Gilmore, Saeed), and climbing partners (Jiabang Chen and many others) for making these years not only productive but genuinely joyful. Their companionship, humor, and shared adventures have been an essential part of this journey.
  ],
  dedication: [],
)

#include "_intro.typ"

#include "_review_current_sheet.typ"

#include "_review_energetic_particles.typ"

#include "_juno.typ"

#include "_psp.typ"

#include "_scattering.typ"

#include "_transport.typ"

#include "_multifluid.typ"

#include "_spedas.typ"

#include "_summary.typ"
