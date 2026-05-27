#import "@preview/touying:0.7.3": *
#import themes.university: *

#show: university-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: text(font: "Times New Roman", size: 0.9em)[Kinetic-scale solar wind current sheets],
    subtitle: [Statistical characteristics and their role in energetic particle transport],
    author: [Zijin Zhang],
    date: datetime.today(),
    institution: [
      Supervisor: Vassilis Angelopoulos

      Committee: Anton Artemyev, Marco Velli, Hao Cao, Paulo Alves
    ],
  ),
  config-common(
    new-section-slide-fn: none,
  ),
  // Shrink the section label in the top-right header
  header-right: self => text(
    size: 0.8em,
    utils.display-current-heading(level: 1, style: auto),
  ),
)

// Paint over the footer bar with white so the colored strip is invisible
#set page(foreground: place(bottom, rect(fill: white, width: 100%, height: 1.6em)))

// ── helpers ──────────────────────────────────────────────────────────────────
#let img(path, width: 100%, height: auto) = image(path, width: width, height: height, fit: "contain")

#import "utils.typ": citet

#let quote-block(body, attribution) = block(
  width: 100%,
  inset: (left: 0.8em, top: 0.25em, bottom: 0.25em, right: 0.4em),
  // stroke: (left: 1.5pt + luma(160)),
)[
  #text(size: 0.78em, style: "italic", fill: luma(60))[#body]
  #linebreak()
  #text(size: 0.7em, fill: luma(110))[#h(1fr) --- #attribution]
]

#let toc-content(active: 0) = {
  let entries = (
    [Part 0: Research Context and Background],
    [Part 1: Observational Analysis of Current Sheets],
    [Part 2: Quantitative Modeling of Particle Scattering],
    [Appendix A: JuliaSpacePhysics Software Ecosystem],
    [Appendix B: Multifluid Current Sheet Model],
    [Conclusion],
  )
  for (i, p) in entries.enumerate() {
    if i == active {
      text(weight: "bold", fill: blue)[#sym.bullet #p]
    } else {
      text(fill: gray)[#sym.bullet #p]
    }
    linebreak()
  }
}

#let fcap(body) = text(size: 0.9em, style: "oblique", weight: "bold")[( #body )]

#title-slide()

= Part 0: Research Context and Background

== Outline

#set text(size: 22pt)

#quote-block(
  [You don't have to know everything. You simply need to know where to find it when necessary.],
  [John Brunner],
)
#v(0.5em)
#toc-content(active: 0)

// Slide 3 — Motivation
== Energetic Particles in the Heliosphere

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  [
    Understanding how energetic particles are transported in the heliosphere remains one of the central problems in space physics & astrophysics.

    *Four main transport processes:* Spatial diffusion, Advection with the solar wind, Drifts (gradient and curvature), Adiabatic energy change
  ],
  [
    #img("figures/ref/en_parts_helio.jpg", height: 4.5cm)

    #v(0.3em)
    #img("figures_extracted/slide03_img02_92e32c43.png", height: 4cm)
    @desaiLargeGradualSolar2016 @mewaldtLongtermFluencesEnergetic2001
  ],
)

$
  (partial f) / (partial t) = (partial) / (partial x_i) [kappa_(i j) (partial f) / (partial x_j)] - U_i (partial f) / (partial x_i) - V_(d comma i) (partial f) / (partial x_i) + 1/3 (partial U_i) / (partial x_i) [(partial f) / (partial ln p)] + "Sources" - "Losses"
$ <eq-parker>

== Dropouts

#grid(
  columns: (1fr, 1fr, 1fr),
  img("figures/ref/tanTurbulentOriginsParticle2023-fig1b.png", height: 7.5cm),
  img("figures/ref/tanTurbulentOriginsParticle2023-fig4.png", height: 7.5cm),
  img("sources/papers/thomasProbingCosmicRayTransport2020/fig2_p3.png", height: 7.5cm),
)

@thomasProbingCosmicRayTransport2020

#v(0.3em)

Time profiles of low-energy He ion intensities. A dropout in ion intensity lasting about 2 hr #fcap[Tan 2023]


// ══════════════════════════════════════════════════════════════════════════════
// Slide 5 — Reservoir
// ══════════════════════════════════════════════════════════════════════════════
== Reservoir --- Anomalous Transport and Non-Markovian Phenomena

#grid(
  columns: (1.2fr, 1fr),
  gutter: 1em,
  [
    The intensities and energy spectra throughout much of the inner heliosphere at different azimuthal, radial, and latitudinal locations are nearly identical.

    #v(0.5em)
    $=>$ Effective cross-field and non-diffusive transport (Lario 2010)
  ],
  [
    #img("figures/ref/reamesTwoSourcesSolar2013-fig6.png")
    #text(
      size: 0.7em,
      style: "italic",
    )[Intensity-time profiles for protons in the 1979 March 1 event at 3 spacecraft (Reames 2013)]
  ],
)

// == Turbulent Magnetic Fluctuations

// #grid(
//   columns: (1fr, 1fr),
//   gutter: 1em,
//   [
//     #img("figures/ref/grecoPartialVarianceIncrements2017-fig1.png", height: 6cm)
//     #text(size: 0.7em, style: "italic")[(Greco et al. 2017)]
//   ],
//   [
//     Nonlinear energy cascade results in coherent structures: current sheets, rotational discontinuities, tangential discontinuities, magnetic holes, switchbacks...

//     #v(0.5em)
//     // #img("figures/baleHighlyStructuredSlow2019-fig5.png", height: 4.5cm)
//   ],
// )

== Transport Theory

#text(size: 18pt)[

  The omnidirectional distribution $f(t, bold(x), p)$ obeys the Parker transport equation @parkerPassageEnergeticCharged1965
  $
    (partial f) / (partial t) = nabla dot (bold(kappa) dot nabla f) - bold(U) dot nabla f - bold(V)_d dot nabla f + 1/3 (nabla dot bold(U)) (partial f) / (partial ln p) + S - L
  $

  #cols(columns: (1fr, 1fr))[
    Diffusion tensor decomposes as
    $
      kappa_(i j) = kappa_perp delta_(i j) + (kappa_parallel - kappa_perp) hat(b)_i hat(b)_j
    $
    Two scalar coefficients control transport:
    $kappa_parallel$ and $kappa_perp$.
  ][
    *Microphysics enters through pitch-angle diffusion* $D_(mu mu)$:

    #set text(size: 17pt)

    $
      kappa_parallel = v^2 / 8 integral_(-1)^(1) (1-mu^2)^2 / D_(mu mu) thin d mu
    $
    $D_(mu mu) (mu)$ integrates over magnetic power spectrum.
  ]

  === Quasi-linear theory (QLT)

  #cols(columns: (1.5fr, 1fr))[

    #set text(size: 17pt)

    *Assumption:* small-amplitude, randomly-phased waves

    Particle scatters resonantly with wave at $k_parallel rho_g approx 1$.

    Predicts $kappa_perp \/ kappa_parallel approx 2-4 %$,
    *roughly energy-independent* @shalchiPerpendicularDiffusionEnergetic2021.
  ][
    *Known limitations*
    - Mean free paths disagree with observations.
    - Fails to explain reservoirs / broad longitudinal spread.
  ]
]

// == Turbulence Transport Models (TTMs)

// #grid(
//   columns: (1fr, 1fr),
//   gutter: 1em,
//   [
//     *Quasilinear theory*

//     Wavelet-based synthetic turbulence model (Juneja et al. 1994) similar to p-model (Meneveau and Sreenivasan 1987).
//   ],
//   img("figures_extracted/slide07_img01_d9878c98.png"),
// )

#set text(size: 18pt)
== *Why?* Solar wind turbulence is not small-amplitude. \  Large-amplitude turbulence with ubiquitous field reversals

#v(3em)

#cols(columns: (1fr, 1.6fr))[

  #v(2em)
  The magnetic field geometry:

  - field-line curvature: $K_parallel equiv \| hat(upright(bold(b))) dot.op nabla hat(upright(bold(b))) \|$
  - inverse perpendicular reversal scale: $K_perp equiv \| hat(upright(bold(b))) times \( hat(upright(bold(b))) times nabla ln B \) \|$
  - $l_B$ is the parallel coherence length

  $K_perp^(- 1) lt.double l_B$ indicates #emph[fold]-like structures.
][
  #image("figures/ref/kempskiCosmicRayTransport2023-fig7.jpeg", height: 205pt)
  #fcap[Schematic of particle transport in a magnetic fold, elongated regions of roughly straight field connected by tight bends where $K_parallel tilde.op K_perp$ @kempskiCosmicRayTransport2023.]
]

Particle transport is very different from the strong guide-field case. Low-energy particles are better confined than high-energy particles, despite less efficient pitch-angle isotropization at small energies @kempskiCosmicRayTransport2023.

== Why? Solar wind is not a sea of random waves \ It is highly intermittent, with coherent structures.

#slide(composer: (1.3fr, 1fr))[
  #v(1.5em)
  #image("figures/ref/grecoPartialVarianceIncrements2017-fig1.png", width: 70%)
  #text(
    size: 16pt,
  )[PDF of out-of-plane electric current density from MHD simulation @grecoPartialVarianceIncrements2017.]
][
  #pause

  Magnetic energy and current density concentrate
  into thin *current sheets*: small fraction of volume,
  disproportionate share of dissipation
  @borovskyContributionStrongDiscontinuities2010.

  *Kinetic-scale current sheets* in the solar wind:
  - thickness $L tilde.op$ a few ion inertial lengths $d_i$
  - $L$ overlaps the gyroradii of *suprathermal–MeV* ions
]

== The Role of Coherent Structure in Particle Transport

#cols()[
  #img("figures_extracted/slide08_img02_c1b665d9.png", height: 100%)
  @moraalCosmicRayModulationEquations2013
][
  #image("figures/scattering/fig-B_diagram_particle_trajectory.pdf", width: 100%)
  Three trajectories, same initial pitch angle, different gyrophases $psi_0 = 163.3 degree, 164.4 degree, 165.6 degree$., in a current sheet
]
#set text(size: 22pt)

== Main Scientific Objective

*Motivation / Gap:* Energetic-particle transport models need microscopic scattering rates, but current sheets are usually folded into "turbulence" rather than treated as explicit scatterers.

#v(0.5em)
*Goals:* Quantitative understanding of how current sheets influence energetic particle transport

1. Observational characterization of solar wind current sheets across the heliosphere

2. Development of data-driven theoretical models for current sheet-induced particle scattering and transport

== Why Observational Current-Sheet Studies Are Needed

#grid(
  columns: (1.05fr, 1fr),
  gutter: 1em,
  [
    Transport coefficients depend on quantities that are not fixed by QLT:
    - current-sheet occurrence rate and spacing
    - thickness $L$ relative to ion scales and particle gyroradius $rho$
    - magnetic-field rotation angle and normal field $B_n / B$
    - radial evolution from the near-Sun solar wind to several AU

    #v(0.5em)
    These parameters determine whether particles stay magnetized, scatter in pitch angle, reflect, or jump across field lines.
  ],
  [
    #img("figures/ref/sodingRadialLatitudinalDependencies2001-fig11.png", height: 7cm)
    #text(size: 0.7em, style: "italic")[
      Earlier discontinuity surveys found radial trends, but often mixed different missions, epochs, resolutions, and identification thresholds @sodingRadialLatitudinalDependencies2001.
    ]
  ],
)

== How to characterize the properties of current sheets?

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  [
    Similar to the role of turbulence level, spectral index, anisotropy and intermittency in turbulence transport models?

    #v(0.5em)
    Current sheets detected by PSP, Juno, STEREO and near-Earth ARTEMIS satellite.

    #v(0.5em)
    As a first-order approximation, we use a simple magnetic field configuration.
  ],
  img("figures/fig-ids_examples.png"),
)

= Part 1: Observational Analysis of Current Sheets

== Outline

#quote-block()[
  The dinosaurs became extinct because they didn't have a space programme.
][Larry Niven]

#quote-block()[
  Wanderer, there is no path --- the path is forged as you wander.
][Antonio Machado]

#v(0.5em)
#toc-content(active: 1)

== From MHD Discontinuities to Kinetic-Scale Current Sheets

#grid(
  columns: (1.05fr, 1fr),
  [
    Early solar-wind measurements found abrupt rotations of the interplanetary magnetic field embedded in otherwise slowly varying plasma.

    #v(0.45em)
    In the original language these were *MHD discontinuities*: spatial boundaries separating two plasma regions, constrained by Rankine--Hugoniot jump conditions.

    #v(0.45em)
    The useful MHD categories were:
    - *Tangential discontinuity:* $B_n approx 0$, separates distinct flux tubes
    - *Rotational discontinuity:* finite $B_n$, propagating Alfvénic structure

    #v(0.45em)
    This classification framed decades of work on solar-wind topology and particle transport.
  ],
  [
    #img("figures/ref/nessPreliminaryResultsPioneer1966-fig6.png", height: 11.0cm)
    #text(
      size: 0.7em,
      style: "italic",
    )[Pioneer 6: large directional IMF changes at nearly constant magnitude @nessPreliminaryResultsPioneer1966.]
  ],
)

== Why the MHD Labels Become Insufficient

#grid(
  columns: (1fr, 1.05fr),
  gutter: 1em,
  [
    #img("figures/ref/artemyevKineticNatureSolar2019-fig3.jpg", height: 7.4cm)
    #text(
      size: 0.7em,
      style: "italic",
    )[ARTEMIS/MMS current-sheet crossings with magnetic, plasma, and electron pitch-angle structure @artemyevKineticNatureSolar2019.]
  ],
  [
    High-cadence observations resolve internal structure on ion scales, where single-fluid MHD assumptions weaken.

    #v(0.55em)
    Many events combine signatures that ideal MHD would separate:
    - RD-like: tangential velocity jumps correlate with Alfvén-speed jumps
    - TD-like: density and temperature change across the layer
    - kinetic: electron pitch-angle distributions and ion pressure tensor effects vary through the crossing

    #v(0.55em)
    The object is therefore better treated as a *current layer* with finite thickness, not a mathematical discontinuity.
  ],
)

== Current Sheets Set the Scale for the Thesis

The key organizing scale is the ion inertial length
$
  d_i = c / omega_(p i)
$
and the corresponding Alfvén current density
$
  J_A = e n V_A = B / (mu_0 d_i).
$

#v(0.55em)
Across the heliosphere, observed current sheets tend to keep:
- thickness $L$ of a few $d_i$
- current density below or comparable to $J_A$
- strong scale dependence: thinner sheets carry stronger currents

#v(0.55em)
This motivates the rest of Part 1: measure current-sheet occurrence, thickness, current density, orientation, and rotation in local plasma units.

== What do we know about these parameters across the heliosphere?

#v(2em)

Past studies often:
- Lacked simultaneous multi-point measurements
- Employed different identification and quantification methods
- Did not sufficiently separate temporal variability from spatial trends

Leading to significant uncertainties.

== Observation Strategy

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  [
    *Juno + ARTEMIS, 1--5 AU*
    - same spacecraft samples broad radial range
    - simultaneous 1-AU references: Wind, ARTEMIS, STEREO-A
    - separates radial evolution from temporal variability
  ],
  [
    *PSP + ARTEMIS, 0.1--1 AU*
    - near-Sun high-cadence magnetic fields
    - same detection/fitting pipeline as 1-AU missions
    - resolves inner-heliosphere thickness, current density, rotation, and duration distributions
  ],
)

== Dataset and Methods

#align(center)[
  #img("figures/psp/overview-7-all.pdf", width: 90%, height: 8cm)
]
#text(
  size: 0.7em,
  style: "italic",
)[Overview of solar wind properties during encounter 8 (PSP aligned with Earth observations)]

== Current Sheet Identification Methods

#text(size: 13pt)[

  #table(
    columns: (18%, 38%, 44%),
    align: (left, left, left),
    fill: (_, row) => if row == 5 { rgb("#dff0d8") } else { none },
    table.header(strong[Method], strong[Criterion], strong[References]),
    table.hline(),
    [Directional change],
    [$Delta theta_(bold(B)) > theta_"min"$],
    [#citet(<burlagaDirectionalDiscontinuitiesInterplanetary1969>); #citet(<sodingRadialLatitudinalDependencies2001>)],
    [Relative field change],
    [$|Delta bold(B)| \/ B > epsilon$],
    [#citet(<tsurutaniInterplanetaryDiscontinuitiesTemporal1979>); #citet(<sodingRadialLatitudinalDependencies2001>)],
    [Correlation / angle],
    [Angle-change distribution over lag $tau$],
    [#citet(<liIdentifyingCurrentSheetlikeStructures2007>); #citet(<liAreThereCurrentsheetlike2008>)],
    [PVI],
    [$"PVI"(tau) = |Delta bold(B)(tau)| \/ sqrt(lr(chevron.l |Delta bold(B)(tau)|^2 chevron.r)) > "PVI"_"min"$],
    [#citet(<grecoPartialVarianceIncrements2017>); #citet(<vaskoKineticscaleCurrentSheets2021>); #citet(
        <vaskoKineticScaleCurrentSheets2024>,
      )],
    table.hline(stroke: (dash: "dashed")),
    [*Rel. std dev* ✓],
    [$"RSD"_w (t) = sigma_w (|bold(B)|) \/ lr(chevron.l |bold(B)| chevron.r)_w > "RSD"_"min"$],
    [#citet(<liuMagneticDiscontinuitiesSolar2022>); #citet(<zhangSolarWindDiscontinuities2025a>); #citet(
        <zhangComparisonSolarWind2026>,
      )],
  )
]

#v(0.3em)
#text(
  size: 12pt,
  fill: luma(80),
)[✓ Method used in this work. $sigma_w$, $lr(chevron.l dot chevron.r)_w$: std dev and mean over sliding window $w$. Resolution-independent → consistent cross-mission comparison (Juno ~1 s · Wind 0.092 s · PSP 0.007 s).]

== Dataset and Methods

#grid(
  columns: (1.5fr, 1fr),
  gutter: 1em,
  img("figures/juno/fig_juno_sw_comparision.pdf", height: 8cm),
  [
    Comparison of solar wind properties (top) and discontinuity properties (bottom) using model (x-axis) vs. JADE observations.
  ],
)


// ══════════════════════════════════════════════════════════════════════════════
// Slide 18 — Current density and thickness
// ══════════════════════════════════════════════════════════════════════════════
== Discontinuity Properties: Current Density and Thickness

#align(center)[
  #img("figures/juno/juno_distribution_r_sw.pdf", width: 95%, height: 8cm)
]
#text(
  size: 0.7em,
  style: "italic",
)[Distribution of various SWD properties observed by Juno, grouped by radial distance from the Sun.]

== Discontinuity Properties: Current Density and Thickness

#align(center)[
  #img("figures_extracted/slide19_img01_f0135a4b.png", width: 90%)
]

== Discontinuity Properties: Waiting time

#img("figures/juno/fig_wt_dist_no_duplicates.pdf", width: 95%)

== Discontinuity Properties: Occurrence Rate

#grid(
  columns: (1.5fr, 1fr),
  gutter: 1em,
  img("figures/juno/fig_occurence_rate.pdf"),
  [
    *Left:* Occurrence rate measured by Juno, STEREO-A, THEMIS-B, and Wind.

    *Right:* Normalized occurrence rate as a function of radial distance.
  ],
)

== Inner-Heliosphere Constraints from PSP

#grid(
  columns: (1.25fr, 1fr),
  gutter: 1em,
  [
    #img("figures/psp/properties_hist-mva.pdf", height: 7.7cm)
  ],
  [
    PSP, ARTEMIS, and Wind show different absolute field strengths and spatial scales, but normalized distributions are much more stable.
  ],
)

== Scale Dependence: Thin Sheets Carry Strong Currents

#grid(
  columns: (1.2fr, 1fr),
  gutter: 1em,
  [
    #img("figures/psp/joint_properties-mva.pdf", height: 7.6cm)
  ],
  [
    Main result for transport model:

    - normalized current density and normalized thickness occupy similar ranges at 0.1 AU and 1 AU
    - thinner sheets carry stronger currents
    - statistics cover kinetic-scale and larger MHD-scale structures

    #v(0.5em)
    Thus current sheets are not rare special cases; they form a broad parameter ensemble that energetic particles repeatedly sample.
  ],
)

== Critical Empirical Constraints for Particle Transport Modeling

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
)[
  #img("figures/scattering/wind_hist3d.png")

  Solar wind current sheets maintain *kinetic-scale thicknesses* throughout the inner heliosphere: normalized thickness and current density remain nearly constant from 0.1 to 5 AU.
][
  #v(0.3em)
  #text(size: 0.8em, style: "italic")[
    #cite(<zhangSolarWindDiscontinuities2025aa>, form: "full")

    #cite(<zhangComparisonSolarWind2026>, form: "full")
  ]
]

= Part 2: Quantitative Modeling of Particle Scattering

== Outline

#quote-block(
  [In physics, you don't have to go around making trouble for yourself --- nature does it for you.],
  [Frank Wilczek],
)
#v(0.5em)
#toc-content(active: 2)

== Equations of Motion

#grid(
  columns: (1.05fr, 1fr),
  gutter: 1em,
  [
    #set text(size: 17pt)
    *Lorentz force:*
    $
      m (d bold(v)) / (d t) = q (bold(E) + bold(v) times bold(B))
    $

    #v(0.3em)
    Compare the two terms:
    $
      (|q bold(E)|) / (|q bold(v) times bold(B)|) tilde.op (E) / (v_p B)
    $

    #v(0.3em)
    Two sources of $bold(E)$ in the solar wind:
    - *convective*, $bold(E)_"conv" = - bold(U)_"sw" times bold(B)$:
      $ (E_"conv") / (v_p B) tilde.op (U_"sw") / (v_p) $
    - *inductive*, $bold(E)_"ind" tilde.op (partial bold(A)) / (partial t) tilde.op (L B) / (tau_B)$:
      $ (E_"ind") / (v_p B) tilde.op (L \/ v_p) / (tau_B) = (tau_"cross") / (tau_B) $

    #v(0.3em)
    For *energetic particles*:
    $v_p tilde.op 4000$ km/s ($100$ keV $p^+$) $gt.double U_"sw" tilde.op 400$ km/s,
    crossing time $tau_"cross" tilde.op$ ms $lt.double tau_B tilde.op$ min

    #v(0.2em)
    $arrow.r.double quad U_"sw" \/ v_p tilde.op 10^(-1), thick tau_"cross" \/ tau_B tilde.op 10^(-4)$ --- both small.
  ],
  [
    #image("figures/scattering/fig-B_diagram_particle_trajectory.pdf", width: 100%)
    #text(
      size: 0.7em,
    )[Three trajectories, same initial pitch angle, different gyrophases $psi_0 = 163.3 degree, 164.4 degree, 165.6 degree$, in a current sheet.]

    #v(0.3em)
    #set text(size: 15pt)
    *Reduction:* drop $bold(E)$, keep $bold(B)(bold(r))$ static $arrow.r$ energy conserved, $|bold(v)| = "const"$; only pitch angle and gyrophase evolve.
  ],
)

== Hamiltonian Formulation

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  [
    #set text(size: 16pt)
    With $bold(B) = nabla times bold(A)$, the Lagrangian
    $
      cal(L) = 1/2 m v^2 + q bold(v) dot bold(A)(bold(r))
    $
    gives canonical momentum $bold(P) = m bold(v) + q bold(A)$ and Hamiltonian
    $
      H = (bold(P) - q bold(A)(bold(r)))^2 / (2 m)
    $

    #v(0.3em)
    *Hamilton's equations:*
    $
      dot(bold(r)) = (partial H) / (partial bold(P)), quad dot(bold(P)) = - (partial H) / (partial bold(r))
    $

    If the field varies slowly over a gyroradius ($l_B gt.double rho$),
    the *first adiabatic invariant*
    $ mu = (m v_perp^2) / (2 B) $ is approximately conserved.
  ],
  [
    #set text(size: 17pt)
    For the 1-D force-free sheet
    $
      bold(B) = B (cos theta thick hat(bold(e))_z + sin theta thick(sin phi(z) thick hat(bold(e))_x + cos phi(z) thick hat(bold(e))_y))
    $
    with $phi(z) = beta tanh(z\/L)$, choose
    $
      bold(A) = L B_t (f_1(z) hat(bold(e))_x + f_2(z) hat(bold(e))_y) + x B_n hat(bold(e))_y.
    $

    #v(0.3em)
    Then $partial H \/ partial y = 0 arrow.r p_y$ conserved; fast $(z, p_z)$ at slowly varying $(kappa x, p_x)$, $kappa = cot theta$ --- the reduced phase plane used next.
  ],
)

== The Problem: Scattering by Current Sheets (Geometrical Chaotization)

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  [
    Key references:
    - Malara et al. (2023); Malara, Perri & Zimbardo (2021)
    - Artemyev et al. (2020); Artemyev, Neishtadt & Zelenyi (2013)
    - Zelenyi et al. (2013); Neishtadt (2000)
    - Buchner & Zelenyi (1989); Chen (1986); Tennyson et al. (1986)
  ],
  img("figures/ref/artemyevRapidGeometricalChaotization2014-fig3.png"),
)

== Destruction of Adiabatic Invariance: Separatrix and Uncertainty Curve

Two distinct types of particle trajectories in ($z,p_z$) plane separated by a curve called Separatrix.

The separatrix corresponds to a point on a certain curve in the ($x,p_x$) plane, called Uncertainty Curve.

Near the separatrix, the instantaneous period of motion increases logarithmically.

Particle accumulates a nonvanishing change in the adiabatic invariant: dynamical jump and geometric jump


#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  [
    #img("figures_extracted/slide24_img01_8186bf68.gif")
    #text(size: 0.7em)[One solution (left) $arrow$ Two solutions (right)]
  ],
  [
    #img("figures_extracted/slide24_img02_791fd195.png")
    #text(size: 0.7em, style: "italic")[Uncertainty curve]
  ],
)

== Why the Period Diverges Near the Separatrix

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  [
    #img("figures/scattering/fig-bcPlot.pdf", height: 6.4cm)
    #text(size: 0.7em, style: "italic")[
      Potential wells and phase portraits from the current-sheet Hamiltonian.
    ]
  ],
  [
    #set text(size: 18pt)
    Near the saddle of the effective potential, particle motion slows down:
    $
      U(z) approx U_s - 1/2 lambda^2 (z - z_s)^2
    $

    #v(0.5em)
    The time spent near the saddle scales as
    $
      T(E) prop ln(1 / abs(E - U_s)).
    $

    #v(0.5em)
    Logarithmic delay breaks fast/slow scale separation.

    #v(0.4em)
    Result: $I_z$ jumps at separatrix crossing, producing large pitch-angle changes.
  ],
)

== Uncertainty Curve

#align(center)[
  #img("figures/scattering/UCLength.jpg", width: 80%)
]

== Examples of Pitch Angle Scattering

#grid(
  columns: (1.5fr, 1fr),
  gutter: 1em,
  [
    #img("figures_extracted/slide27_img01_6200b1a8.png")
    #text(size: 0.7em, style: "italic")[Malara, Perri & Zimbardo (2021)]
  ],
  [
    The trajectories of two particles starting with slightly different gyrophases.
  ],
)

== Test-particle simulations: Transition matrices reveal scattering modes

#slide(composer: (1fr, 1fr))[
  #v(3em)
  #set text(size: 18pt)
  For each magnetic field configuration $(theta, beta, L)$:

  - Initialize particles far from the sheet with all $(alpha_0, psi_0)$ uniformly:
    $alpha_0 in [0, pi]$ in $1 degree$ bins, $psi_0$ in $3 degree$ bins.
  - Integrate until each particle exits the sheet.
  - Record final pitch angle $alpha_1$.
  - Bin $(alpha_0 -> alpha_1)$ → *transition matrix (TM)*.

  A TM gives the probability distribution of pitch-angle change for *one*
  encounter with that current sheet.
][
  #image("figures/scattering/example_subset.pdf", width: 90%)
][#grid.cell(colspan: 2)[
  #set text(size: 18pt)
  Bright diagonal $-->$ weak scattering. Spreading $-->$ diffusive scattering.

  Off-diagonal blocks $-->$ *large pitch-angle jumps*; sign reversal of $cos alpha$ $-->$ reflection.
]]


== Observed distribution of current-sheet parameters

#cols(columns: (1fr, 1.6fr))[
  #image("figures/scattering/thc.pdf", width: 100%)

  ARTEMIS observation matching a $tanh$ rotation profile.
][
  100,000 current sheets at 1 AU from ARTEMIS + WIND.

  #image("figures/scattering/wind_hist3d.png", width: 100%)

  Most-probable parameters: $beta tilde.op 50 degree$, $theta tilde.op 85 degree$ (small $B_n$).

  The TM for an *individual* sheet is one realization; what matters for transport is the *ensemble*.
]

== Weighted transition matrix and long-term evolution

#slide()[
  #set text(size: 15pt)

  Average TMs over the observed population:
  $
    p(alpha_1 | alpha_0) = sum_i p(alpha_1 | alpha_0, Pi_i) thin w_i
  $
  with $w_i$ the empirical probabilities of CS configurations $Pi_i$.

  // 100 keV protons, 1 AU:
  // - bright diagonal (most encounters weak)
  // - significant *non-diagonal* probability

  #figure(
    image("figures/scattering/tm_stats_100keV.pdf", width: 90%),
  )

  Strong jumps come from sheets with $L <= rho_g$ and large $beta$.
][
  #pause
  #set text(size: 15pt)
  Iterate the WTM as a Markov chain over CS encounters:
  $
    alpha_(n+1, i) = W_Pi (alpha_(n, i), xi_(n, i))
  $
  $xi_(n, i)$: uniform random for the gyrophase.

  #figure(
    image("figures/scattering/pa_jump_history_high.pdf", width: 82%),
  )

  #text(size: 16pt)[Pitch angle evolves through *infrequent but large jumps* — non-Brownian.]
]

== Pitch Angle Scattering by Typical Discontinuity

#align(center)[
  #img("figures/scattering/pa_jump_history_high.pdf", width: 85%, height: 8cm)
]

== Effective Pitch-Angle Diffusion from Current Sheets

#grid(
  columns: (1.25fr, 1fr),
  gutter: 1em,
  [
    #img("figures/scattering/mixing_rate.pdf", height: 6.7cm)
  ],
  [
    #set text(size: 18pt)
    Single-sheet transition matrices are weighted by observed 1-AU current-sheet distributions.

    #v(0.5em)
    Results:
    - rare large jumps rapidly mix pitch angle
    - current-sheet scattering can be represented by an effective $cal(D)_(mu mu)$ for transport models
    - because $B L$ stays nearly constant with radius, strong scattering remains heliospheric
  ],
)

== From Scattering to Spatial Transport

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  [
    #img("figures/transport/dR_perp_v2.png", height: 7.4cm)
  ],
  [
    A current-sheet encounter can do two things:

    - change pitch angle
    - demagnetize the particle and move its guiding center to another field line

    #v(0.5em)
    This gives a cross-field transport channel that does not require field-line random walk.
  ],
)


== Monte Carlo transport: scheme & trajectories

#set text(size: 17pt)
Chain encounters: (1) Pick CS params $Pi_i$; (2) run test particle → extract $Delta alpha_i$, $Delta bold(r)_(perp, i)$; (3) *free stream* distance $d$ along $hat(bold(b))$; (4) apply random rotation $bold(R)_i$; (5) track $chevron.l Delta z^2 chevron.r$, $chevron.l Delta r_perp^2 chevron.r$  → $D_parallel$, $D_perp$.


#figure(
  image("figures/transport/trajectories_1MeV.pdf", height: 60%),
  caption: [Parallel and perpendicular displacements for 1-MeV particles interacting with near-Earth current sheets. Gray lines: individual particle trajectories; Blue line: standard deviation of the ensemble; Black line: a representative trajectory.],
)

== Current-Sheet-Driven Diffusion Coefficients

#grid(
  columns: (1.25fr, 1fr),
  gutter: 1em,
  [
    #img("figures/transport/diffusion.pdf", height: 7.5cm)
  ],
  [
    Main transport result:
    - $D_parallel$ is comparable to QLT at low energies but diverges at higher energies
    - $D_perp$ grows faster because jump size scales with demagnetized gyroradius
    - $D_perp / D_parallel$ is energy dependent, not fixed at the usual $2$--$4%$

    #v(0.5em)
    This helps explain broad SEP longitudinal/latitudinal spreads and reservoir-like behavior.
  ],
)

+ #cite(<zhangQuantificationIonScattering2025>, form: "full")

== Part 2 Takeaway

#v(3em)

#align(center + horizon)[
  #set text(size: 22pt)
  #block(width: 85%)[
    Kinetic-scale current sheets effectively scatter energetic particles via *geometrical chaotization*, beyond the conventional diffusion framework.
    Large pitch-angle jumps lead to rapid particle mixing in pitch angles.
    Demagnetization could drive large cross-field jumps and an *energy-dependent* $D_perp \/ D_parallel$.
  ]
]


= Appendix A: JuliaSpacePhysics Software Ecosystem

== Outline

#quote-block(
  [The best way to predict the future is to invent it.],
  [Alan Kay],
)
#v(0.5em)

#quote-block()[Programming is not about typing, it’s about thinking.][Rich Hickey]

#toc-content(active: 3)

== JuliaSpacePhysics: Enabling This Thesis

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  [
    The multi-mission surveys ($>$ 175,000 CS) and test-particle simulations in this thesis were enabled by a modular Julia software ecosystem.

    #v(0.5em)
    *Design principles:*
    - Abstract interfaces decouple analysis from file format / memory layout
    - Mapping-based metadata interoperability (ISTP, SPASE, HAPI)
    - Interoperability with Python (PySPEDAS, SunPy) and Fortran (IRBEM)
    - Decentralized, community-driven package architecture

    #v(0.5em)
    #cite(<zhangJuliaSpacePhysicsGeoCotransjl2026>, form: "full")
  ],
  [
    #img("figures/spedas/fig1_tplot.pdf", height: 8cm)
    #text(size: 0.7em, style: "italic")[Interactive tplot-style visualization with on-demand recomputation.]
  ],
)

== JuliaSpacePhysics: 31 Composable Packages

From data access to analysis to visualization in a few lines of code.

== Performance: 10--1000$times$ Speedups over Existing Tools

#text(size: 14pt)[
  #table(
    columns: (25%, 30%, 25%, 12%),
    align: (left, left, left, right),
    table.header(strong[Task], strong[Julia Package], strong[Reference], strong[Speedup]),
    table.hline(),
    [Moment calculation], [VelocityDistributionFunctions.jl], [PySPEDAS], [$tilde.op 100 times$],
    [Minimum variance analysis], [MinimumVarianceAnalysis.jl], [PySPEDAS], [$tilde.op 1000 times$],
    [Coordinate transforms], [GeoCotrans.jl / IRBEM.jl], [IRBEM, PySPEDAS], [$10$--$20 times$],
    [Wave polarization], [WaveAnalysis.jl], [PySPEDAS], [$tilde.op 250 times$],
    [Tsyganenko B models], [Tsyganenko.jl], [geopack], [$100$--$250 times$],
    [Multi-S/C gradients], [MultiSpacecraftAnalysis.jl], [PySPEDAS], [$tilde.op 100 times$],
  )
]

VelocityDistributionFunctions.jl: Efficient plasma moment, directional flux spectra calculation and distribution sampling.


#v(0.3em)
Performance gains from JIT compilation, fused loops, reduced allocations, and parallelization --- enabling interactive exploration and large-scale statistical studies that were previously impractical.

= Appendix B: Multifluid Current Sheet Model

== Outline

#quote-block()[Everything should be made as simple as possible, but not simpler.][Albert Einstein]

#quote-block()[The goal of physics is to find the simplest possible description that accounts for all observations.][Steven Weinberg]

#v(0.5em)
#toc-content(active: 4)

== Sub-Alfvénic Velocity Jumps: The Observational Puzzle

#grid(
  columns: (1.1fr, 1fr),
  gutter: 1em,
  [
    #img("figures/cs_theory/fig_examples.pdf", height: 8cm)
  ],
  [
    Current sheets observed by PSP, ARTEMIS, and Wind consistently show:
    - $|Delta bold(U)| \/ |Delta bold(V)_A| < 1$ (sub-Alfvénic)
    - Single-fluid MHD requires $|Delta bold(U)| = |Delta bold(V)_A|$ for rotational discontinuities with $B_z eq.not 0$

    #v(0.5em)
    *Question:* What controls the Alfvénicity of current sheets?

    #v(0.5em)
    *Answer:* Counter-streaming ion beams. Density contrast between populations sets the velocity-jump ratio.
  ],
)

== Multifluid Equilibrium: Key Result

#set text(size: 18pt)

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  [
    For two ion populations with equal mass and opposite normal velocities:
    $
      lr(|frac(Delta U_x, Delta V'_(A,x))|) = lr(|frac(n_1(infinity) - n_2(infinity), n_1(infinity) + n_2(infinity))|)
    $

    #v(0.3em)
    - $n_1 = n_2$: symmetric beams $arrow.r$ zero velocity jump
    - $n_1 gt.double n_2$: single-fluid RD limit recovered
    - Intermediate: sub-Alfvénic, matching observations

    #v(0.3em)
    Model: 1-D force-free ($|bold(B)| = "const"$), $B_z eq.not 0$, gyrotropic pressure, steady-state in deHoffmann--Teller frame.
  ],
  [
    #img("figures/cs_theory/profiles_sym.pdf", height: 5.2cm)
    #text(
      size: 0.7em,
      style: "italic",
    )[Symmetric case ($n_1 = n_2$): zero velocity jump, current carried entirely by counter-streaming beams.]
  ],
)

== Density Contrast Controls Velocity Structure

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  [
    #img("figures/cs_theory/UxNormBx.pdf", height: 7cm)
  ],
  [
    #img("figures/cs_theory/UyNormBy.pdf", height: 7cm)
  ],
)

#v(0.3em)
$U_x \/ V_(A,x)$ and $U_y \/ V_(A,y)$ depend only on $n_1(infinity)$. As $n_1 arrow.r 0$ (single population), ratio $arrow.r 1$ (single-fluid RD limit).


= Conclusion

== Outline

#quote-block(
  [The important thing is not to stop questioning.],
  [Albert Einstein],
)

#v(0.5em)
#toc-content(active: 5)

== Summary: Observations (Part 1)

#set text(size: 18pt)

#v(2em)

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  [
    *Multi-mission survey, 0.1--5 AU*
    - PSP, ARTEMIS, Wind, STEREO, Juno
    - Consistent detection algorithm across all missions
    - $>$ 175,000 current sheets identified

    #v(0.5em)
    *Central finding:* normalized CS properties are *radially invariant*
    - thickness $L tilde.op 1$--$10 thin d_i$
    - current density $J tilde.op 0.1 thin J_A$
    - inverse power law: $J\/J_A prop (L\/d_i)^(-1)$

    #v(0.5em)
    Intrinsic spread of CS properties $gt.double$ any systematic radial trend.
  ],
  [
    *Additional results:*
    - Alfvénicity controlled by ambient turbulence ($sigma_c$, $sigma_r$), not by CS internal properties
    - characteristic velocity $tilde(v)_B prop B L approx "const"$ with $r$

    #v(0.5em)
    *Implication:* current sheets form a *universal parameter ensemble* that can serve as direct input to particle transport models at any heliocentric distance.
  ],
)

== Summary: Scattering and Transport (Part 2)

#set text(size: 18pt)

#v(2em)


#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  [
    *Single-sheet physics*
    - Hamiltonian formulation retaining full vector potential
    - Scattering via *geometrical chaotization*: separatrix crossings produce order-unity $Delta alpha$
    - Transition matrices capture diffusion + large jumps + reflections

    #v(0.5em)
    *Ensemble scattering*
    - Weighted TM over $tilde.op 10^5$ observed CS at 1 AU
    - Non-Brownian pitch-angle evolution: rare large jumps dominate mixing
    - Effective $cal(D)_(mu mu)$ increases with particle energy
  ],
  [
    *Spatial transport*
    - New cross-field channel: demagnetization $arrow.r$ field-line jumping (no FLRW needed)
    - Monte Carlo simulation $arrow.r$ $D_parallel$, $D_perp$

    #v(0.5em)

    *Key result:* $D_perp \/ D_parallel$ is *energy-dependent*, not the constant $2$--$4%$ of QLT

    - high energy: $rho_g tilde.op L$ $arrow.r$ strong perpendicular jumps $arrow.r$ reservoirs, broad longitudinal spread

    #v(0.5em)
    Since $tilde(v)_B prop B L approx "const"$, scattering remains efficient throughout the heliosphere.
  ],
)

== Future Directions

#set text(size: 17pt)

+ *Origins and evolution of current sheets* \
  Are they generated near the Sun and advected outward, or produced locally by turbulence? Tracking propagation velocities vs. $r$ and decomposing the population by generation mechanism (Alfvén-wave steepening vs. cascade).

+ *Curvature and reversal-scale statistics* \
  Unify the current-sheet picture with the broader curvature-scattering framework (Lemoine 2023; Kempski 2023). Measure perpendicular reversal-scale distributions; determine whether power-law curvature tails are dominated by current sheets or other structures.

+ *Beyond Fokker--Planck: non-diffusive transport* \
  Heavy-tailed jump distributions violate the Markovian assumption. Explore fractional diffusion, Lévy walks, and multiphase solar-wind models where different plasma types host distinct CS populations.

+ *Beyond 1-D force-free sheets* \
  Multi-dimensional internal structure, plasma gradients, and other coherent structures (flux ropes, magnetic holes, Alfvén vortices) may modify scattering. Test-particle simulations in more realistic field configurations.

== Thank You

#align(center)[
  #v(2em)
  #text(size: 24pt, weight: "bold")[Thank you!]

  #v(1em)
  #text(size: 18pt)[I'm happy to take your questions.]

  #v(2em)
  #text(size: 14pt, fill: luma(100))[
    Published work:\
    #cite(<zhangSolarWindDiscontinuities2025aa>, form: "full") \
    #cite(<zhangComparisonSolarWind2026>, form: "full") \
    #cite(<zhangQuantificationIonScattering2025>, form: "full")
  ]
]

== References <touying:hidden>

#set text(size: 12pt)
#bibliography("research.bib", title: none, style: "apa")


= Backup

== Phase Portraits and Potential Energy Profiles

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  img("figures/scattering/fig-bcPlot.pdf"),
  // img("figures/scattering/zPz_phase_portraits.pdf"),
)

== PSP Alfvénicity: Departure from Ideal RD

#grid(
  columns: (1.25fr, 1fr),
  [
    #img("figures/psp/Alfvenicities.pdf")
  ],
  [
    Ideal rotational discontinuity expectation:
    $
      Delta bold(V) = plus.minus Delta bold(V)_A
    $
    and weak compressibility.

    #v(0.5em)
    Observed current sheets are usually sub-Alfvénic:
    - velocity-jump ratio mostly below 1
    - PSP has tighter alignment than Wind/ARTEMIS
    - magnetic-field magnitude changes are small
  ],
)

== PSP Alfvénicity: Controlled by Background Turbulence


#img("figures/psp/Q_sonnerup_joint_dist_den.pdf", height: 7.5cm)


The Sonnerup $Q^plus.minus$ parameter combines magnitude and angular mismatch between $Delta bold(V)$ and $Delta bold(V)_A$.

#v(0.5em)
Key result:
- $Q$ correlates with ambient cross helicity $sigma_c$
- $Q$ correlates with residual energy $sigma_r$
- little correlation with plasma beta or alpha abundance

#v(0.5em)
Interpretation: current-sheet Alfvénicity is set mainly by surrounding turbulent state.


== Current-Sheet Spacing and Duration Matter for Transport

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  [
    #img("figures/psp/duration_dist.pdf", height: 7.2cm)
    #text(size: 0.7em, style: "italic")[Duration distributions from PSP and 1-AU spacecraft.]
  ],
  [
    Duration and waiting-time statistics set the encounter cadence:
    $
      t_d = d / |v_parallel|
    $

    #v(0.5em)
    Short-duration kinetic-scale sheets evolve fastest with radial distance; longer-duration structures are more stable.

    #v(0.5em)
    For particle transport, this means scattering is controlled by both *single-interaction physics* and *how often particles meet sheets*.
  ],
)


== What Was Known, What Was Missing

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  [
    *Before this work*
    - Discontinuities/current sheets are ubiquitous from the inner heliosphere to the outer heliosphere.
    - Kinetic-scale sheets are linked to intermittency, heating, reconnection, and suprathermal-particle enhancements.
    - Previous surveys measured occurrence rates, durations, and current densities at selected radial distances.
  ],
  [
    *Problem to solve*
    - Are radial trends spatial evolution or solar-cycle/stream variability?
    - Do normalized sheet parameters remain tied to local plasma scales?
    - Which observed distributions should feed particle-scattering and transport models?
    - How do near-Sun and 1-AU current-sheet populations differ for energetic particles?
  ],
)
