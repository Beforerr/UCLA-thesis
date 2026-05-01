#import "@preview/touying:0.7.3": *
#import themes.metropolis: *

#show: metropolis-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [Energetic Particle Transport driven by Solar Wind Current Sheets],
    subtitle: [How kinetic-scale magnetic structures scatter and transport SEPs],
    author: [Zijin Zhang],
    date: datetime.today(),
  ),
)

#let muted = rgb("#5d6570")

#set text(size: 18pt)
#let citep(body) = cite(body, form: "prose")
#let fcap(body) = text(size: 14pt, fill: muted)[#body]

#title-slide()

= Motivation: Energetic Particles in the Heliosphere

== Energetic particles fill the heliosphere

#cols(columns: (0.9fr, 1.25fr))[
  Three populations of energetic particles:
  - *Galactic cosmic rays* — extra-solar, modulated by solar wind.
  - *Anomalous cosmic rays* — pickup ions accelerated at the termination shock.
  - *Solar energetic particles (SEPs)* — keV to GeV, accelerated at/near the Sun.

  SEPs are *episodic*: intensity varies by orders of magnitude on minutes,
  with strong variability in spectrum, composition, and spatial extent.
][
  #image("figures/ref/desaiLargeGradualSolar2016-fig3.png", height: 130%)

  #fcap[Two-class picture of SEP events @desaiLargeGradualSolar2016]
]

== Observational puzzles that drive this work

#slide(composer: (1fr, 1fr))[
  - *Reservoir effect:* late-phase SEP equalize across widely separated
    spacecraft (similar spectra and intensitie) → efficient spatial redistribution ( large cross-field transport) or trapping.
  #pause
  - *Dropouts:* abrupt intensity drops at flux-tube boundaries on gyroradius
    scales → particles confined to flux tubes @mazurInterplanetaryMagneticField2000.
  #pause
  - *Broad longitudinal spread:* SEPs detected $> 180 degree$ apart in longitude
    [STEREO/SOHO/PSP @anastasiadisSolarEnergeticParticles2019].
][
  #meanwhile
  #v(-2em)

  #image("figures/ref/reamesTwoSourcesSolar2013-fig6.png", width: 100%)

  #fcap[
    Upper left panel: Intensity-time profiles;
    upper right panel: Energy spectra in the “reservoir” at time R @reamesTwoSourcesSolar2013
    // bottom panel: Paths of the spacecraft through a sketch of the CME
  ]

  // Left: proton intensities at several energies measured by Wind/LEMT during the 1997 November 6 event, showing uniform decay profiles across energies after the initial rise. Right: energy spectra at successive times remain nearly identical in shape (invariant spectra), indicating that particles have filled a large heliospheric volume and are decaying uniformly. Bottom: schematic of spacecraft positions relative to the Sun. Such spatially uniform distributions imply substantial cross-field transport, potentially mediated by interactions with current sheets and other coherent structures @reamesTwoSourcesSolar2013.

][#grid.cell(colspan: 2)[
  #jump(3, relative: true)
  *Common thread:* magnetic structure mediates particle transport (#emph[barriers, scatterers, mixers])
]]

== Background: Transport Theory — The Parker transport equation

The omnidirectional distribution $f(t, bold(x), p)$ obeys @parkerPassageEnergeticCharged1965
$
  (partial f) / (partial t) = nabla dot (bold(kappa) dot nabla f) - bold(U) dot nabla f - bold(V)_d dot nabla f + 1/3 (nabla dot bold(U)) (partial f) / (partial ln p) + S - L
$

#pause

#cols(columns: (1fr, 1fr))[
  #set text(size: 17pt)

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
  $D_(mu mu) (mu)$ is an integral over magnetic power spectrum.
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

== *Why?* Solar wind turbulence is not small-amplitude

Alternative regime of large-amplitude turbulence with ubiquitous field reversals

#cols(columns: (1fr, 1.6fr))[
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

// Regions of large curvature have systematically weaker fields, with $chevron.l B \( K_parallel \) chevron.r prop K_parallel^(- 1 \/ 2)$.

// ---consistent with approximate constancy of the magnetic tension $upright(bold(B)) dot.op nabla upright(bold(B))$. This anti-correlation between curvature and field strength appears to be a robust feature of MHD turbulence: similar curvature statistics have been measured in diverse simulation settings @schekochihinStructureSmallscaleMagnetic2001@yangRoleMagneticField2019@yuenCurvatureMagneticField2020, and confirmed #emph[in situ] in the Earth's magnetosheath @bandyopadhyaySituMeasurementCurvature2020@huangObservationsMagneticField2020 and solar wind @huInterplanetaryMagneticField2025.

== *Why?* Solar wind is *not* a sea of random waves — it is highly intermittent, with coherent structures.

#slide(composer: (1.3fr, 1fr))[
  #image("figures/ref/grecoPartialVarianceIncrements2017-fig1.png", width: 80%)
  #text(
    size: 12pt,
  )[PDF of  out-of-plane electric current density from MHD simulation @grecoPartialVarianceIncrements2017.]
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

// A physically appealing interpretation emerges: region I consists of very low values of fluctuations that lie mainly in the lanes between magnetic islands. Region II consists of sub-Gaussian current cores that populate the central regions of the magnetic islands (or flux tubes). Region III is composed of the coherent small-scale current sheet-like structures that form the sharp boundaries between the magnetic flux tubes. This classification provides a real-space picture of the nature of intermittent MHD turbulence.

= Background: Particle Dynamics

== Adiabatic invariant: foundation of guiding-center theory

A charged particle gyrates with
$ Omega_c = (q B) / (m c), quad rho = v_perp / Omega_c. $

If the field varies slowly over a gyroradius ($l_B gt.double rho$),
the *first adiabatic invariant*
$ mu = (m v_perp^2) / (2 B) $
is approximately conserved.

// Underlies mirroring, radiation belts, magnetic bottles.

#pause

=== When the magnetic moment fails

When a particle encounters a structure of thickness $lambda tilde.op rho$:
- particle cannot complete a gyration in uniform field
- $mu$ ceases to be conserved
- *guiding-center description breaks down*.

== The quasi-adiabatic invariant $I_z$

This is exactly the regime of solar-wind kinetic current sheets!
Need a *different* invariant — the *quasi-adiabatic invariant* $I_z$.

#v(0.5em)

Treat motion across the sheet ($z$, $p_z$) as the *fast* d.o.f., in-plane drift ($x$, $p_x$) as *slow*, with small parameter $kappa = B_n \/ B_t sqrt(L \/ rho_0)$.

For a 1-D current sheet with normal $hat(bold(z))$ and reversing
in-plane field, the *fast* motion is bounce in $z$.

Action of the fast motion:
$
  I_z = 1 / (2 pi) integral.cont p_z thin d z
$

For frozen slow variables, the $(z, p_z)$ phase plane has
*two types* of orbits:
- oscillation in *one* of two potential wells (one side of the sheet)
- *figure-eight* orbit crossing $z=0$ (across the sheet).

These types are separated by a *separatrix*.

== Separatrix crossings destroy adiabaticity

#side-by-side(columns: (0.85fr, 1.15fr))[
  When slow variables drift, a particle's orbit can hit the separatrix.

  Two contributions to the jump in $I_z$:

  *Geometrical jump $tilde.op cal(O)(1)$* — area difference between the
  two separatrix loops; *independent of $kappa$*.

  *Dynamical jump $tilde.op kappa ln kappa$* — phase-dependent random kick
  from the logarithmic divergence of the period.
][
  #image("figures/ref/neishtadtMechanismsDestructionAdiabatic2019-fig3.png", height: 230pt)

  #text(size: 10pt)[Fast-system phase portrait with separatrix @neishtadtMechanismsDestructionAdiabatic2019.]
]

== Geometrical chaotization: superfast scattering

In *symmetric* current sheets ($B_m = 0$), the two geometrical jumps cancel
over a full period → only slow dynamical diffusion ($t tilde.op kappa^(-3)$).

In *force-free* sheets observed in the solar wind,
$|bold(B)| approx upright("const")$ requires a peak in the *intermediate* component
$B_m$ at the sheet center.

This breaks the symmetry of the $(z, p_z)$ phase portrait.
*Geometrical jumps no longer cancel:*
$
  Delta I_z^upright("geom") tilde.op cal(O)(1) quad upright("each crossing")
$

→ *Order-unity pitch-angle change* in a single interaction
@artemyevSuperfastIonScattering2020 @artemyevRapidGeometricalChaotization2014.

This mechanism is *qualitatively distinct* from QLT diffusion.

== Results I: Pitch-Angle Scattering by a Current Sheet

$
  bold(B)(z) = B [cos theta thin hat(bold(e))_z + sin theta (sin phi(z) hat(bold(e))_x + cos phi(z) hat(bold(e))_y)], "        " phi(z) = beta tanh(z \/ L)
$

with $L$ — half-thickness, $beta$ — shear angle, $theta$ angle between $bold(B)$ and $z$ axis.

#cols(columns: (1.5fr, 1fr))[

  #image("figures/scattering/fig-B_diagram_particle_trajectory.pdf", width: 100%)

  Three trajectories, same initial pitch angle, in a current sheet with $beta = 75 degree$, $theta = 85 degree$.
][
  Three protons with $alpha_0 = 90 degree$, $v_p = 8 v_B$,
  gyrophases $psi_0 = 163.3 degree, 164.4 degree, 165.6 degree$.

  - T1: weak scattering ($Delta alpha approx 0$).
  - T2: deflection.
  - T3: *reflection* by the current sheet.

  *Sensitivity to initial gyrophase* → treat the outcome statistically.
]

== Test-particle simulations:  Transition matrices reveal scattering modes

#slide(composer: (1fr, 1fr))[
  For each magnetic field configuration $(theta, omega_(i n), tilde(v)_B)$:

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
  Bright diagonal $-->$ weak scattering. Spreading $-->$ diffusive scattering.


  Off-diagonal blocks $-->$ *large pitch-angle jumps*; sign reversal of $cos alpha$ $-->$ reflection.
]]

== Observed distribution of current-sheet parameters: One-dimensional current sheet model

#cols(columns: (1fr, 1.6fr))[
  #image("figures/scattering/thc.pdf", width: 100%)

  ARTEMIS observation matching a $tanh$ rotation profile.
][
  100,000 current sheets at 1 AU from ARTEMIS + WIND.

  #image("figures/scattering/wind_hist3d.png", width: 100%)

  Most-probable parameters: $omega_(i n) tilde.op 100 degree$, $theta tilde.op 85 degree$ (small $B_n$).

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
  // Strong jumps come from sheets with $L tilde.op rho_g$.

  #figure(
    image("figures/scattering/tm_stats_100keV.pdf", width: 100%),
  )
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


== Effective $D_(mu mu)$ from the second moment


#cols(columns: (1fr, 1.3fr))[
  // #set text(size: 16pt)
  Track variance of the pitch-angle distribution:
  $
    M_2(n) = N^(-1) sum_i (alpha_(n, i) - alpha_(0, i))^2 - M_1^2(n)
  $
  Fit $M_2(n) = d - a e^(-D_(mu mu) n)$ → effective mixing rate.
][
  #figure(
    image("figures/scattering/mixing_rate.pdf"),
  )
]

$D_(mu mu)$ increases with energy: higher-energy particles have $rho_g$ comparable to more sheets.
// - Convert from per-encounter to per-time using observed CS occurrence rate.

= Results II: Spatial Transport

== Cross-field jump: a new perpendicular transport channel

// The particle approaches gyrating around the *green* field line, becomes demagnetized while interacting, and reattaches to the *pink* field line on exit.

#figure(image("figures/transport/dR_perp_v2.png", width: 50%))

Jump scale set by the *demagnetized* gyroradius, which *grows with energy*.

*No field-line random walk required* — the field line itself does not need to wander.


== From scattering to transport — two channels

Each current-sheet encounter changes *two* things about the particle:

#side-by-side(columns: (0.85fr, 1.25fr))[
  *Pitch-angle change $Delta alpha$*
  - parallel transport
  - reflection if $|Delta alpha|$ is large
  - $-->$ controls $D_parallel$.
][
  *Perpendicular guiding-center jump $Delta bold(r)_perp$*
  - particle *demagnetizes* inside the sheet
  - exits gyrating around a *different* field line
  - cross-field jump *without* field-line random walk
  - $-->$ controls $D_perp$.
]

#text(size: 18pt)[*Both* channels arise from the same magnetic structure, and *both* depend strongly on $rho_g \/ L$.]


== Monte Carlo transport: scheme & trajectories

#set text(size: 17pt)
Chain encounters: (1) Pick CS params $Pi_i$; (2) run test particle → extract $Delta alpha_i$, $Delta bold(r)_(perp, i)$; (3) *free stream* distance $d$ along $hat(bold(b))$; (4) apply random rotation $bold(R)_i$; (5) track $chevron.l Delta z^2 chevron.r$, $chevron.l Delta r_perp^2 chevron.r$  → $D_parallel$, $D_perp$.


#figure(image("figures/transport/trajectories_1MeV.pdf", height: 68%))


== Diffusion coefficients and the key result

#cols(columns: (1.35fr, 1fr))[
  #figure(image("figures/transport/diffusion.pdf", height: 280pt))
][
  - $D_parallel$: comparable to QLT at low $E$, *diverges* at high $E$.

  - $D_perp$: *steeper* energy dependence than $D_parallel$.

  - The ratio $D_perp / D_parallel$ *increases with energy*, exceeds QLT above $tilde.op 1$ Me

]

// = Summary & Outlook

== Summary

#text(size: 19pt)[
  // + Solar-wind current sheets are *abundant kinetic-scale structures* whose properties are largely invariant from 0.17 to 5 AU.

  + When $rho_g tilde.op L$, the magnetic moment fails. The right invariant is
    $I_z$, and its destruction at separatrix crossings — *geometrical chaotization* —
    produces *order-unity pitch-angle jumps* in a single encounter.

  + Test-particle simulations parameterized by *observed* CS distributions
    yield effective $D_(mu mu)(E)$ that captures both diffusion and large jumps.

  + Cross-field transport occurs through *direct field-line jumps* during
    demagnetization — a channel absent from QLT/FLRW models.

  + $D_perp \/ D_parallel$ *increases with energy*, exceeding QLT predictions above
    $tilde.op 1$ MeV — may explain SEP reservoirs and broad longitudinal spread.
]

== Open questions and future directions

- *Waiting-time statistics:* clustered, heavy-tailed distributions of CS
  separations could give anomalous (non-Fickian) transport, $chevron.l Delta x^2 chevron.r prop t^alpha$
  with $alpha eq.not 1$ @effenbergerOpenIssuesNongaussian2025.

- *Radial evolution:* couple transport models to radially evolving CS
  statistics and Parker-spiral geometry.

- *3-D current sheet structure:* reconnection sites, flux ropes, plasmoid chains
  may modify both scattering and perpendicular jumps @pezziCurrentSheetsPlasmoids2021.

- *Origin of solar-wind current sheets:* turbulent cascade vs. solar / coronal imprint?

== Thank you!

== References <touying:hidden>

#set text(size: 12pt)
#bibliography("research.bib", title: none, style: "apa")

#show: appendix

= Backup

== Implications for SEP observations

Strong, *energy-dependent* perpendicular transport offers a natural
explanation for long-standing puzzles:

- *Reservoir effect:* efficient cross-field mixing equalizes intensities
  across widely separated spacecraft.

- *Broad longitudinal spread* of high-energy SEPs: high-energy particles
  diffuse perpendicular more efficiently than QLT predicts — no need to
  invoke extreme coronal injection geometries.

- *Dropouts:* low-energy particles (small $rho_g$) interact weakly with
  most sheets → tangential discontinuities still act as flux-tube boundaries.

== Exact Hamiltonian formulation

Hamiltonian $H = (bold(p) - q bold(A))^2 \/ 2 m$ with vector potential
$
  A_x = L B_t f_1(z), quad A_y = L B_t f_2(z) + x B_n
$
where $f_1, f_2$ are *exact* combinations of cosine/sine integrals
of $beta(1 plus.minus tanh(z \/ L))$.

Normalize $tilde(H) = H / h$, $h = q^2 L^2 B_t^2 \/ m c^2$:
$
  tilde(H) = 1/2 [(tilde(p)_x - f_1(z))^2 + (tilde(x) cot theta + f_2(z))^2 + tilde(p)_z^2]
$

#text(size: 18pt)[
  Unlike previous studies that Taylor-expand around $z=0$, *we keep the full nonlinear form*.
  The two key dimensionless parameters are
  $beta$ (shear) and the *characteristic velocity* $tilde(v)_B = q B L \/ (m c^2)$.]

== Adiabatic invariants in slow–fast Hamiltonian systems

For a Hamiltonian with fast $(p, q)$ and slow $(y, x)$ d.o.f. controlled by $epsilon lt.double 1$:
$
  dot(p) = -(partial E)/(partial q), thick dot(q) = (partial E)/(partial p), thick
  dot(y) = -epsilon (partial E)/(partial x), thick dot(x) = epsilon (partial E)/(partial y)
$

The action $I = (2 pi)^(-1) integral.cont p thin d q$ of the fast motion is
conserved with accuracy $O(epsilon)$ over times $O(1 / epsilon)$.

When the fast phase portrait contains *no* separatrix (Arnold), conservation
becomes *perpetual*: $|I(t) - I(0)| = O(epsilon)$ for all $t$.

Separatrices break this and allow $I$ to change by $cal(O)(1)$ at crossings.

== Symmetric vs. asymmetric stochastization rates

Time to destroy $I_z$ ($kappa lt.double 1$):

#table(
  columns: 3,
  stroke: 0.5pt,
  [*System*], [*Mechanism*], [*Stochastization time*],
  [Symmetric Harris ($s = 0$)], [dynamical jumps only, $chevron.l Delta I_z chevron.r = 0$], [$tilde.op kappa^(-3)$],
  [With guide field $s eq.not 0$],
  [$chevron.l Delta I_z chevron.r eq.not 0$ from dynamical jumps],
  [$tilde.op kappa^(-2)$],

  [Force-free + $B_m$ peak (asymmetric $z -> -z$)],
  [*geometrical chaotization*, $Delta I_z^upright("geom") tilde.op 1$],
  [$tilde.op kappa^(0)$ — superfast],
)

#v(0.5em)
Force-free solar-wind current sheets sit in the *third row*: a particle's
adiabatic invariant can be destroyed in *one* gyration through the sheet.


== New models: localized field reversals

#cols(columns: (0.85fr, 1.25fr))[
  *Lemoine (2023)* @lemoineParticleTransportLocalized2023
  - Transport near *sharp magnetic field bends* — localized $bold(B)$ reversals.
  - Curvature statistics have *power-law tails* ($p prop kappa^(-2)$).
  - Intermittent scattering: rare but *order-unity* $Delta alpha$ jumps.
  - Both $D_parallel$ and $D_perp$ enhanced.
][
  #image("figures/ref/lemoineParticleTransportLocalized2023_fig3.png", width: 100%)

  #text(size: 10pt)[Power-law magnetic-curvature tails @lemoineParticleTransportLocalized2023.]
]

*Point:* scattering dominated by *a few special locations*, not many weak waves.
