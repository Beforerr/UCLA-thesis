# Speech Script — PhD Dissertation Defense

**"Kinetic-scale solar wind current sheets: Statistical characteristics and their role in energetic particle transport"**
Zijin Zhang · ~50 minutes

_Timing guide: Part 0 ≈ 15 min · Part 1 ≈ 15 min · Part 2 ≈ 15 min · Conclusion ≈ 5 min_

---

## TITLE SLIDE (~1 min)

Good morning, everyone. Thank you all for coming, and thank you to my committee for your time and guidance throughout this work.

My dissertation is about solar wind current sheets — thin magnetic structures that permeate the interplanetary medium — and the question of whether these structures play a significant, quantifiable role in transporting energetic charged particles through the heliosphere. The short answer is yes, and the mechanisms turn out to be qualitatively different from what standard theory predicts.

---

## OUTLINE (~1 min)

Here is the road map for the next fifty minutes.

I'll start with Part 0 — research context. I want to make sure everyone has a shared picture of the observational puzzles, the standard theoretical framework, and exactly where that framework falls short.

Part 1 covers my observational work: a multi-mission statistical survey of current sheets from 0.1 AU out to 5 AU, using Parker Solar Probe near the Sun, and Juno, ARTEMIS, Wind, and STEREO in the outer heliosphere.

Part 2 covers the modeling work: how I turn those observed current-sheet distributions into quantitative predictions for particle scattering and spatial diffusion.

I'll close with a brief synthesis and outlook.

## ENERGETIC PARTICLES IN THE HELIOSPHERE (~2 min)

Let me set the stage.

The heliosphere is filled with energetic charged particles. For the purposes of this talk, I want to focus on the ones originating from the Sun — **solar energetic particles**, or SEPs. These are primarily protons, but also heavier ions and electrons, accelerated to energies from a few kiloelectronvolts up to several gigaelectronvolts by solar flares and by the shock waves driven ahead of coronal mass ejections.

SEP events represent a major space-weather hazard. They are a threat to astronauts and can damage spacecraft electronics. So understanding how they travel through the heliosphere is not just a scientific question — it has practical stakes.

The governing equation for this transport is the Parker transport equation, written here. The distribution function f evolves under spatial diffusion — described by the tensor κ — solar wind advection, particle drifts, and adiabatic energy changes. The entire challenge of the field is to determine the components of κ from first principles, or at least from observation-informed models.

The diffusion tensor decomposes into two scalars: κ*∥, parallel diffusion along field lines, and κ*⊥, perpendicular diffusion across them. Parallel diffusion is controlled by pitch-angle scattering: how rapidly a particle's angle relative to the field is randomized.

---

## DROPOUTS (~1.5 min)

One of the sharpest observational constraints on transport comes from **SEP dropouts**.

These are abrupt, factor-of-hundred drops in particle intensity, lasting minutes to hours, that occur without any corresponding drop in the solar wind or field. The intensity can fall from a strong event level to near-background essentially instantaneously.

The interpretation is topological: particles are strongly confined to individual magnetic flux tubes. When a spacecraft crosses a tube boundary, it sees the dropout. Because the boundaries are sharp on gyroradius scales, the particles must have had very little perpendicular transport — they stayed within their original flux tube over the transit time from the Sun.

Dropouts tell us that perpendicular diffusion can be extremely small, at least in certain conditions. That constraint will matter when I show you our transport results.

---

## RESERVOIR — ANOMALOUS TRANSPORT (~2 min)

Now here is what makes this field genuinely puzzling. While dropouts imply low perpendicular transport, there is a completely different class of observation that seems to demand the opposite.

The **reservoir effect**: in the declining phase of large SEP events — days after the initial impulse — proton intensities measured by widely separated spacecraft become nearly identical. Not just roughly similar — nearly identical in both intensity and spectral shape. This figure from Reames (2013) shows the 1979 March 1 event: the energy spectra at three spacecraft at different radial distances and longitudes collapse onto a single curve.

For this to happen, particles must have been redistributed across a large fraction of the inner heliosphere within a few days. That requires substantial cross-field transport — much more than quasi-linear theory typically predicts.

So we have two seemingly contradictory observations from two different phases of the same class of events. Dropouts say κ_⊥ is tiny. Reservoirs say it must be large. The resolution likely lies in the spatial and energy structure of perpendicular transport — and current sheets are a natural candidate for providing that structure.

---

## TRANSPORT THEORY (~2 min)

Let me be more precise about what the standard theory actually predicts and where it breaks down.

**Quasi-linear theory**, or QLT, is the foundation of essentially all operational SEP transport models. The core assumption is that magnetic fluctuations are small in amplitude relative to the background field — δB/B₀ ≪ 1 — and that they are composed of many randomly phased, small-amplitude waves. Under these conditions, particles undergo resonant scattering when the wave's parallel wavenumber satisfies k_∥ ρ_g ≈ 1, where ρ_g is the gyroradius.

The pitch-angle diffusion coefficient D*μμ is then an integral of the magnetic power spectrum over the resonant wavenumbers. The parallel diffusion coefficient κ*∥ follows from a weighted integral of 1/D*μμ. And the perpendicular coefficient — under the nonlinear guiding-center theory, which is the best we have — comes out to roughly 2–4% of κ*∥, with essentially no energy dependence.

Two problems. First, mean free paths computed from QLT consistently disagree with observations — sometimes by an order of magnitude. Second, QLT provides no natural mechanism for either the reservoir effect or the broad longitudinal spread of SEPs, unless you invoke injection geometries that independently don't fit the data.

The reason, I'll argue, is that QLT assumes the wrong picture of the solar wind.

---

## WHY? LARGE-AMPLITUDE TURBULENCE WITH FIELD REVERSALS (~1.5 min)

The solar wind is not a superposition of small-amplitude waves. It is a highly structured medium in which the magnetic field can reverse direction on scales much smaller than the correlation length.

Recent theoretical work by Kempski and collaborators has analyzed particle transport in this regime — large-amplitude turbulence with ubiquitous field reversals. The key geometric object is what they call a **magnetic fold**: a long, roughly straight segment of field line, connected at its ends to neighboring segments by tight bends where the field curvature is large.

The geometry is characterized by two scales: the parallel coherence length l_B, and the inverse perpendicular reversal scale K_perp, which measures how sharply the field bends across field lines. When K_perp⁻¹ ≪ l_B, the structure is fold-like — long straight segments with sharp bends.

The key result: at the bends, the particle gyroradius can become comparable to the curvature radius. The particle temporarily demagnetizes. And — counterintuitively — **lower-energy particles are better confined** than higher-energy ones, because higher-energy particles have larger gyroradii and interact more strongly at the bends. This is the opposite of the QLT ordering.

This is the theoretical context for understanding why current sheets — which are precisely these sharp bends in the field — matter for transport.

---

## WHY? INTERMITTENT SOLAR WIND (~1.5 min)

The solar wind is also highly **intermittent**. Magnetic energy and current density are not smoothly distributed — they concentrate into thin, intense current sheets separated by quieter regions.

This simulation plot, from Greco and collaborators, shows the probability distribution of the out-of-plane current density in MHD turbulence. The non-Gaussian tail — the excess probability at high current densities — is exactly the signature of intermittency. Most of the volume has weak fluctuations; a small fraction contains intense, sheet-like structures.

In the actual solar wind, these kinetic-scale current sheets have thicknesses of a few ion inertial lengths — maybe a few hundred kilometers at 1 AU. And this matters enormously for energetic particles, because the gyroradii of suprathermal to multi-MeV ions are precisely in this range.

So when an SEP encounters a current sheet, the field changes on the scale of its orbit. Standard QLT — which assumes the field varies on scales much larger than the gyroradius — is simply inapplicable.

---

## THE ROLE OF COHERENT STRUCTURE IN PARTICLE TRANSPORT (~1 min)

Let me make the contrast concrete.

On the left is a schematic from Moraal (2013) of the classical picture: particles diffusing through a smooth, stochastic field. On the right are actual test-particle trajectories in a current sheet — three protons with the same initial pitch angle but slightly different gyrophases. One passes through almost unscattered. One is substantially deflected. One is reflected.

This gyrophase sensitivity is not present in QLT, where the outcome depends only on the wave power spectrum, not on the detailed phase of the fluctuation. Current sheets act as individual scattering events with strongly nonlinear outcomes. That's a fundamentally different physics.

---

## MAIN SCIENTIFIC OBJECTIVE (~1 min)

This brings me to the central question of this dissertation.

Current sheets are clearly present. They clearly interact with energetic particles. But they have been either ignored or folded into an effective "turbulence" in existing transport models. What we lack is a quantitative, observation-informed description of what current sheets actually do to particles, and how that feeds into macroscopic transport coefficients.

My two main goals were: first, to observationally characterize solar wind current sheets across the heliosphere — what their statistical properties are, how they depend on heliocentric distance, and what parameters matter for particle interaction. And second, to build data-driven theoretical models that convert those observed distributions into quantitative predictions for pitch-angle scattering and spatial transport.

---

## WHY OBSERVATIONAL CURRENT-SHEET STUDIES ARE NEEDED (~1 min)

The transport coefficients in the Parker equation don't just depend on the turbulence power spectrum. They depend on the full statistical ensemble of current sheet properties: occurrence rates and spatial spacing, sheet thickness relative to ion inertial lengths and particle gyroradii, magnetic field rotation angles, and the normal component of the field.

These parameters determine whether a particle passing through a sheet stays magnetized, scatters in pitch angle, reflects, or jumps across field lines.

Previous surveys — like this one from Söding (2001) — did find radial trends in discontinuity properties. But they often mixed different missions, different solar cycles, different identification thresholds. It was impossible to cleanly separate true radial evolution from temporal variability or method differences.

---

<!--
## WHAT WAS KNOWN, WHAT WAS MISSING (~1 min)

Before this work, the community knew that discontinuities and current sheets are ubiquitous throughout the heliosphere. Kinetic-scale sheets had been linked to intermittency, plasma heating, magnetic reconnection, and enhancements of suprathermal particles. Individual studies had measured occurrence rates or current densities at specific distances.

But the open questions were: Are the radial trends we see in absolute quantities a result of spatial evolution — the solar wind actually changing — or just solar cycle variability that happened to correlate with radial distance? Do the normalized parameters — thickness in ion inertial lengths, current density in Alfvén current units — stay constant across the heliosphere? And which specific distributions should feed into particle transport calculations?

These are the questions Part 1 addresses.

--- -->

## HOW TO CHARACTERIZE CURRENT SHEET PROPERTIES (~0.5 min)

The approach is analogous to characterizing turbulence: just as turbulence models need the spectral index, amplitude, and anisotropy, current-sheet transport models need the occurrence rate, thickness distribution, rotation angle distribution, and normal field statistics.

I'll show you how we extracted these from data spanning 0.1 to 5 AU, using a consistent detection algorithm across all missions.

---

## PART 1 OUTLINE (~0.5 min)

Part 1 of the dissertation. I'll take you through the historical context first — why we moved from MHD discontinuity language to kinetic current sheets — then the observational datasets, detection methods, and results across the heliosphere.

---

## FROM MHD DISCONTINUITIES TO KINETIC-SCALE CURRENT SHEETS (~1.5 min)

Solar wind discontinuities have a long history. The first spacecraft measurements in the 1960s — including Pioneer 6 data shown here — revealed abrupt rotations of the interplanetary magnetic field embedded in otherwise slowly varying plasma. These were classified using MHD jump conditions as either **tangential discontinuities**, where the normal component B_n ≈ 0 and two distinct plasma regions are separated, or **rotational discontinuities**, which are propagating Alfvénic structures with finite B_n.

This MHD classification framed decades of work on solar wind topology and, critically, on particle transport — because the distinction between a TD and an RD has different implications for whether particles can cross the structure.

But here's the limitation: these are discontinuities in the mathematical sense — infinitely thin boundaries. Real solar wind structures have finite thickness, and with modern high-cadence instruments, we can resolve their internal structure.

---

## WHY THE MHD LABELS BECOME INSUFFICIENT (~1.5 min)

When we look at actual high-resolution crossings from ARTEMIS and MMS — like the examples shown here from Artemyev (2019) — the picture is richer than MHD allows.

Many events show simultaneous signatures that ideal MHD would categorize as different types: Alfvén-like velocity jumps, density and temperature variations across the layer, and kinetic features in the electron pitch-angle distributions and ion pressure tensor. The structure isn't a mathematical discontinuity — it's a **current layer with finite thickness, internal structure, and kinetic effects**.

The key scale that emerges is the ion inertial length d_i = c/ω_pi, and the associated Alfvén current density J_A = B/(μ₀ d_i). These are the natural normalizations for describing kinetic-scale sheets. And once you normalize by these plasma scales, something striking appears: the normalized thickness and current density are remarkably stable across a huge range of heliocentric distances.

---

## CURRENT SHEETS SET THE SCALE FOR THE THESIS (~1.5 min)

The ion inertial length d_i is what sets the relevant scale throughout this work. This is not arbitrary: d_i is the length below which Hall and electron-kinetic effects become important, and above which the fluid approximation is reasonable. Current sheets with thickness L ~ a few d_i sit right at the boundary between MHD and kinetic physics.

What we see observationally — and this dataset from Vasko (2024) at 5 AU is one example — is that current sheets consistently have:

- thickness of a few d_i
- current densities below or comparable to J_A
- a clear inverse relationship: thinner sheets carry stronger currents.

This scale dependence is robust across the heliosphere. It means the parameter space that matters for particle transport — which depends on ρ/L, the ratio of gyroradius to sheet thickness — is well-defined and measurable. That's what makes an observation-informed model possible.

---

## WHAT DO WE KNOW ACROSS THE HELIOSPHERE? (~0.5 min)

The problem with previous surveys was methodological inconsistency. Different teams used different identification algorithms — threshold-based, minimum variance, timing methods — applied to different spacecraft, at different cadences, in different solar cycle phases. Comparing their results to extract a clean radial trend was essentially impossible.

My approach was to apply a single, consistent algorithm across all missions, covering 0.1 to 5 AU simultaneously.

---

## OBSERVATION STRATEGY (~1.5 min)

Let me describe the observational strategy.

For the **outer heliosphere component**, I used the Juno spacecraft during its 2011–2016 cruise phase from 1 to 5 AU. Juno's trajectory gave us, for the first time, a single spacecraft sampling a broad continuous radial range in a comparable solar wind environment — no mixing of different mission epochs or operational modes. To separate radial evolution from temporal variability, I simultaneously used Wind, ARTEMIS, and STEREO-A near 1 AU as contemporaneous references.

For the **inner heliosphere component**, Parker Solar Probe provided high-cadence magnetic field measurements down to 0.1 AU during its early science encounters. I applied the same detection and fitting pipeline to PSP data and compared directly with near-Earth missions operating simultaneously.

This paired strategy — same algorithm, same solar wind conditions, different radial locations — is what allowed clean separation of spatial evolution from temporal effects.

---

## DATASET AND METHODS (~1.5 min)

The table on this slide summarizes the main identification methods used in the literature. The field has used at least five distinct approaches: threshold on the directional change of B; threshold on the relative field change |ΔB|/B; correlation functions and angle-change distributions; the PVI — partial variance of increments — which flags intermittent structures statistically; and relative standard deviation of B.

The method we use is the **relative standard deviation** approach, introduced by Liu et al. (2022) and applied here consistently across all missions. In brief: we compute the standard deviation of the magnetic field magnitude over a sliding window and flag intervals where it exceeds a threshold relative to the local mean. This is resolution-independent — unlike threshold methods that depend on the cadence of the data — which is essential when comparing spacecraft that sample at very different rates: Juno at roughly one-second cadence, PSP at up to 150 samples per second.

Once a candidate event is flagged, we apply minimum variance analysis to determine the local coordinate system and extract the sheet normal. For each detected sheet we then extract: the rotation angle ω_in; the half-thickness L from the rotation duration and estimated phase velocity; the peak current density J from Ampère's law; and the ratio B_n/B_t distinguishing tangential from rotational character.

The resolution-independence of the detection step is what makes cross-mission comparison meaningful — we are not comparing apples and oranges.

I'll now show you the results across the heliosphere.

---

## DISCONTINUITY PROPERTIES: CURRENT DENSITY AND THICKNESS — JUNO (~2 min)

This is the central observational result of Part 1.

The four panels show distributions of normalized thickness L/d_i and normalized current density J/J_A, grouped by radial distance in bins from 1 to 5 AU. Look at what doesn't change: the peak of the L/d_i distribution sits at 2–4 ion inertial lengths at every distance from 1 to 5 AU. The normalized current density J/J_A peaks at 0.05–0.15 at every distance.

What does change is the absolute field strength, the plasma density, and therefore the absolute sheet thickness in kilometers — but these cancel when you normalize to local plasma scales.

This is the first clean demonstration that solar wind current sheets are kinetically self-similar across the outer heliosphere. The structures adapt to the local plasma environment, maintaining the same normalized properties even as that environment changes dramatically between 1 and 5 AU.

---

## DISCONTINUITY PROPERTIES: CURRENT DENSITY AND THICKNESS — CONTINUED (~1 min)

This second panel shows the joint distribution of L/d_i and J/J_A — the current density-thickness plane. The key feature is the power-law inverse relationship: J/J_A ∝ (L/d_i)^{-1}. Thinner sheets carry proportionally stronger currents. This is a signature of the underlying constraint that the total magnetic shear — the field rotation times thickness — stays approximately constant.

This relationship spans two orders of magnitude in thickness, covering both kinetic-scale sheets and larger, MHD-scale structures. The continuum matters for particle transport because particles at different energies — and therefore different gyroradii — interact selectively with sheets of matching thickness.

---

## DISCONTINUITY PROPERTIES: WAITING TIME (~1 min)

Beyond the properties of individual sheets, the **spatial distribution** of sheets along a particle's trajectory matters for transport. Heavy-tailed waiting-time distributions — clustered sheets rather than randomly spaced ones — can produce anomalous, non-Fickian transport where diffusion is not described by a simple coefficient.

This waiting-time distribution from Juno is well described by a power law in the tail, indicating that clustering is present. Long gaps with no sheets are more common than a Poisson distribution would predict. In our transport model, we use a fixed mean spacing as a first approximation, but I'll return to this as an important future direction.

---

## DISCONTINUITY PROPERTIES: OCCURRENCE RATE (~1 min)

The occurrence rate of current sheets — how many per unit time or distance the solar wind contains — decreases with heliocentric distance. This panel shows the rate measured by Juno, STEREO-A, Wind, and ARTEMIS simultaneously. The radial dependence is approximately n ∝ r^{-1.3}, broadly consistent with the expansion of the solar wind volume.

The absolute rate at 1 AU is roughly 100–200 current sheets per day in fast solar wind, or about one every 7–15 minutes. This high encounter frequency is what makes current sheets a significant cumulative scatterer — even if each interaction is individually weak or moderate, the sheer number of encounters over an SEP propagation time of days adds up.

---

## INNER-HELIOSPHERE CONSTRAINTS FROM PSP (~1 min)

Parker Solar Probe gives us the inner boundary condition, close to the Sun.

This panel shows the normalized property distributions from PSP at 0.1–0.3 AU compared with near-Earth missions. The normalized thickness and current density distributions are remarkably similar — the same 2–4 d_i thickness, the same 0.05–0.15 J_A current density range.

The absolute occurrence rate is higher near the Sun — roughly a factor of five more sheets per unit time at 0.1 AU than at 1 AU — consistent with the radial trend seen in the Juno data. This higher encounter rate means particles near the Sun undergo more frequent interactions, even if each interaction has similar properties.

---

## SCALE DEPENDENCE: THIN SHEETS CARRY STRONG CURRENTS

The joint distribution from PSP confirms the same L/d_i – J/J_A inverse power law seen at 1 AU and out to 5 AU. This is an important consistency check: despite operating in a completely different solar wind environment — faster, denser, with stronger fields — the normalized statistics are the same.

For transport modeling, this means we can define a universal parameter space for current sheet properties and a universal scattering model that applies at all heliocentric distances, with the absolute rates and scales provided by the distance-dependent plasma parameters.

---

## CRITICAL EMPIRICAL CONSTRAINTS FOR PARTICLE TRANSPORT MODELING (~1 min)

To summarize Part 1: solar wind current sheets maintain **kinetic-scale, self-similar properties** from 0.1 to 5 AU. The normalized thickness stays at 2–4 ion inertial lengths. The normalized current density stays at 0.05–0.15 Alfvén current densities. These properties are not artifacts of solar cycle variability — they are established by comparing Juno's radial sweep against simultaneous 1-AU references.

The three-dimensional histogram shown here — the joint distribution of thickness, rotation angle, and current density at 1 AU — is the direct input to the particle transport calculations in Part 2. This is what I mean by data-driven: the scattering model is not parameterized by theoretical expectations but by the actual distribution of structures that particles encounter.

---

## PART 2 OUTLINE (~0.5 min)

Part 2: quantitative modeling. I'll build from the single-particle physics — what happens when one particle crosses one current sheet — all the way up to macroscopic diffusion coefficients for populations of particles crossing many sheets.

---

## THE PROBLEM: SCATTERING BY CURRENT SHEETS (~1.5 min)

The study of particle dynamics in current sheets has a long history, rooted in magnetospheric physics. The foundational work goes back to Buchner & Zelenyi (1989), who identified the quasi-adiabatic invariant I_z as the relevant conserved quantity when the adiabatic invariant μ fails. More recent work by Artemyev, Neishtadt, and collaborators quantified the specific mechanism — geometrical chaotization — that operates in force-free sheets.

The key references for this chapter are shown here. I want to be explicit about what is prior work and what is new, because this is a case where building on a strong theoretical foundation is part of the contribution.

What is new in this dissertation: applying the geometrical chaotization framework to an ensemble of current sheets with **statistically observed parameters**, converting the single-sheet outcomes into diffusion coefficients for transport, and computing — for the first time — the perpendicular transport driven by this mechanism.

---

## DESTRUCTION OF ADIABATIC INVARIANCE: SEPARATRIX AND UNCERTAINTY CURVE (~2 min)

Let me explain the mechanism.

In a smoothly varying field, the particle's magnetic moment μ = mv_⊥²/2B is conserved. In a current sheet, this fails — but a different approximate invariant takes over. If we treat the cross-sheet motion (z, p_z) as fast and the in-plane drift (x, p_x) as slow, the action of the fast motion

I_z = (1/2π) ∮ p_z dz

is approximately conserved.

The phase portrait of the fast system has two types of orbits: particles oscillating in one of two potential wells on either side of the field reversal, or figure-eight orbits that cross z = 0 and sample both sides. These two types are separated by a **separatrix**.

Now — as the slow drift moves the particle's trajectory through phase space, its orbit can reach the separatrix. Near the separatrix, the particle's period diverges logarithmically — the particle spends a long time near the saddle point of the potential. This logarithmic delay breaks the fast/slow separation that the adiabatic invariant requires, and I_z can jump by a finite amount.

There are two contributions to the jump: a **geometrical jump**, proportional to the area difference between the two separatrix loops, and a **dynamical jump**, proportional to κ ln κ, where κ is the small parameter measuring the field asymmetry. The geometrical jump is independent of κ — it doesn't get small in the limit of well-separated scales. That's what makes it so important.

The locus of phase-space points where the separatrix is reached is called the **uncertainty curve**, which I'll show next.

---

## WHY THE PERIOD DIVERGES NEAR THE SEPARATRIX (~1.5 min)

This panel shows the effective potential U(z) from our current-sheet Hamiltonian. Near the saddle point of the potential — the point where the particle would be in unstable equilibrium — the potential is locally quadratic: U ≈ U_s - ½λ²(z - z_s)².

The period of the motion near the saddle diverges logarithmically: T(E) ∝ ln(1/|E - U_s|). This logarithmic divergence is the mathematical reason why the adiabatic invariant fails. The standard proof of adiabatic invariance requires the period to be finite and well-defined. Near the separatrix, it isn't.

The practical consequence: every time a particle's slow drift brings it near the separatrix, I_z can jump by an amount that is not small. For force-free current sheets — which is what we observe in the solar wind — this produces order-unity pitch-angle changes in a single interaction.

---

## UNCERTAINTY CURVE (~1 min)

This figure shows the uncertainty curve — the set of initial conditions in (x, p_x) phase space where the separatrix is reached. Particles that start inside this curve will undergo a separatrix crossing during their interaction with the sheet; those outside will not.

The length of the uncertainty curve — normalized by the total available phase space — gives the probability of a large-jump event for a particle with given energy and geometry. I use this both as a diagnostic of the theory and as validation for the test-particle simulations.

---

## EXAMPLES OF PITCH-ANGLE SCATTERING (~1 min)

Before showing you the systematic results, let me show a case study from earlier work (Malara, Perri & Zimbardo 2021) that illustrates the mechanism clearly.

Two particles start with nearly identical initial conditions — differing only in gyrophase by a fraction of a degree. One particle's trajectory carries it to the separatrix; the other's does not. The particle that reaches the separatrix undergoes a large, abrupt pitch-angle change. The other continues almost unscattered. This extreme sensitivity is the hallmark of the geometrical chaotization mechanism, and it's what motivates the statistical approach I use.

---

## TRANSITION MATRIX (~2 min)

My approach to single-sheet scattering is the **transition matrix**. For a given current sheet configuration (thickness L, rotation angle β, normal field parameter θ), I launch many test particles covering the full grid of initial pitch angles α₀ ∈ [0°, 180°] and gyrophases ψ₀ ∈ [0°, 360°]. I integrate the full Newton-Lorentz equation through the sheet and record the final pitch angle α₁.

Binning (α₀ → α₁) gives the transition matrix: the conditional probability distribution P(α₁|α₀) for one encounter with that specific sheet.

The four example matrices shown here represent four different field configurations. The patterns are distinctive. The bright diagonal: weak scattering, the particle barely changes direction. The diffuse spreading around the diagonal: moderate diffusive scattering. And the off-diagonal blocks, where cos(α) changes sign — these are **reflections**, large pitch-angle jumps that reverse the particle's direction of motion along the field.

The relative weight of these modes depends on the ratio ρ_g/L. When the gyroradius is much smaller than the sheet thickness, most particles are in the diagonal. When ρ_g ≈ L, the off-diagonal blocks become significant.

---

## PITCH ANGLE SCATTERING BY A TYPICAL DISCONTINUITY (~1 min)

This panel shows the long-term evolution of pitch angle for a particle encountering a sequence of typical 1-AU current sheets. The key observation is the non-Brownian character: the pitch angle is roughly stable for many consecutive encounters, then undergoes a sudden large jump.

This is fundamentally different from the smooth, incremental diffusion predicted by QLT. In QLT, every wave-particle interaction produces a small kick; the diffusion is the result of many small, uncorrelated kicks accumulating. Here, most encounters produce negligible change, and the pitch-angle evolution is dominated by the rare encounters where the particle happens to be near a separatrix crossing.

Higher and lower energy particles do not show obviously different jump rates in individual trajectory histories — the stochasticity is large — but the statistical picture, averaged over many particles, does show energy dependence, as I'll show next.

---

## TRANSITION MATRIX: WEIGHTED ENSEMBLE (~1 min)

Now I average the transition matrices over the full observed distribution of current-sheet parameters from Part 1. This weighted transition matrix is the probability distribution P(α₁|α₀) for a particle encountering a _randomly selected_ sheet from the actual solar wind population.

The result for 100 keV protons at 1 AU is shown here. You can see: a bright diagonal (most encounters are weak); a spread into neighboring bins (moderate diffusion); and measurable off-diagonal probability (large jumps, including reflections). The strong jumps come specifically from sheets where L ≤ ρ_g and where β — the rotation angle — is large.

This weighted matrix is the kernel of the Markov chain that I use for long-term pitch-angle evolution.

---

## EFFECTIVE PITCH-ANGLE DIFFUSION FROM CURRENT SHEETS (~1.5 min)

By iterating the weighted transition matrix as a Markov chain over many sequential encounters, I extract an effective pitch-angle diffusion coefficient D_μμ(E).

The procedure: run an ensemble of particles through many successive sheets, track the variance of the pitch-angle distribution as a function of the number of encounters, and fit M₂(n) = d − ae^{−D\_{μμ}n} to extract the mixing rate.

The results show that D_μμ **increases with particle energy**. The reason: higher-energy particles have larger gyroradii and are therefore geometrically resonant with a larger fraction of the current sheet population. At low energy, most sheets are too thin relative to the gyroradius for strong scattering; at high energy, many sheets satisfy ρ_g ≈ L and produce large jumps.

This energy dependence is consistent with what Lemoine (2023) predicted analytically for transport near sharp magnetic field reversals: enhanced scattering at higher energies driven by the field curvature statistics. Our numerical result provides the quantitative transport coefficient.

---

## FROM SCATTERING TO SPATIAL TRANSPORT (~1.5 min)

Now I turn from pitch-angle scattering to spatial transport. And here is the key new result.

A current-sheet encounter doesn't just change the pitch angle — it can also move the particle **perpendicular to the magnetic field**. The mechanism is demagnetization.

This figure shows an example trajectory. The particle approaches gyrating around a field line — shown in green. Inside the sheet, the field reversal occurs on the scale of the gyroradius. The particle cannot maintain a clean circular orbit and temporarily demagnetizes — it is no longer tied to a specific field line. When it exits the interaction region, it reattaches to a neighboring field line — shown in pink. The perpendicular separation between the entry and exit field lines is a real, physical cross-field displacement.

The crucial point: **no field-line random walk is required**. The particle doesn't wander because the field lines wander. It jumps because it temporarily loses contact with its field line and reattaches to a different one. This is an entirely different mechanism from what quasi-linear or FLRW-based models assume.

The scale of the jump is set by the demagnetized gyroradius — larger for higher-energy particles. So this perpendicular transport channel has a built-in energy dependence.

---

## MONTE CARLO TRANSPORT: SCHEME AND TRAJECTORIES (~1.5 min)

To compute macroscopic diffusion coefficients, I chain many single-sheet interactions into a Monte Carlo transport simulation.

The scheme: pick current sheet parameters from the observed distribution; run the test particle through the sheet; extract the pitch-angle change Δα and perpendicular displacement Δr*⊥; let the particle free-stream for a distance d along the field (the mean inter-sheet spacing); apply a random rotation R_i to account for the field-line direction changing between successive sheets in the Parker spiral geometry; repeat. I track 512 particles simultaneously and measure the mean-square displacements ⟨Δz²⟩ and ⟨Δr*⊥²⟩ over time.

The trajectories for 1-MeV protons are shown here. Parallel transport — left panel — is mostly steady streaming, but with occasional sharp reversals where a single current-sheet interaction flips the particle's direction of motion along the field. These are the reflections from the transition matrices, now visible as abrupt kinks.

Perpendicular transport — right panel — shows an almost completely different character. Between sheet encounters, the particle barely moves perpendicular to the field. At each encounter, there is a discrete jump. The stochastic accumulation of these jumps produces a random walk that is macroscopically diffusive.

---

## CURRENT-SHEET-DRIVEN DIFFUSION COEFFICIENTS (~2 min)

Finally, the main transport result.

Panel (a): parallel diffusion coefficient D*∥ as a function of particle energy, at 1 AU and at 0.1 AU (PSP). At low energies, D*∥ from current-sheet scattering is comparable to QLT predictions derived from turbulence power spectra. At high energies — above roughly 100 keV — D_∥ increases more steeply than QLT, reflecting the growing fraction of sheets with ρ_g ≈ L.

Panel (b): perpendicular diffusion coefficient D*⊥. This grows even more steeply with energy than D*∥. The reason: the cross-field jump size scales with the demagnetized gyroradius, giving D*⊥ an extra power of energy compared to D*∥.

Panel (c): **this is the central result**. The ratio D*⊥/D*∥ as a function of energy. Quasi-linear theory predicts 2–4%, roughly independent of energy. Our simulation shows that D*⊥/D*∥ increases with energy, exceeding the QLT range for particles above approximately 1 MeV at 1 AU.

This energy dependence has direct observational implications. Higher-energy particles spread faster in the perpendicular direction relative to their parallel motion. This provides a natural explanation for why SEP reservoirs form preferentially at high energies, and why broad longitudinal spread is more commonly observed for higher-energy events. It also explains why low-energy particles show dropouts — at low energy, ρ_g ≪ L for most sheets, so perpendicular transport is suppressed and particles remain confined to their original flux tubes.

The 0.1 AU result shows both coefficients enhanced by a factor of a few compared to 1 AU, consistent with the higher encounter rate and similar normalized sheet properties close to the Sun.

---

## CONCLUSION (~3 min)

Let me bring everything together.

This dissertation addressed two questions. Are solar wind current sheets statistically characterized well enough to serve as input to transport models? And do they produce quantitatively significant transport effects that are distinct from what quasi-linear theory predicts?

The answer to both is yes.

**On the observational side**: current sheets maintain kinetic-scale, self-similar properties from 0.1 to 5 AU. Normalized thickness of 2–4 ion inertial lengths. Normalized current density of 0.05–0.15 Alfvén current densities. These are not sensitive to solar cycle phase or solar wind stream structure — they are controlled by local plasma physics. The inverse current density-thickness relationship spans two orders of magnitude and is robust across all missions and distances.

**On the transport side**: when particle gyroradii match sheet thickness — which happens for suprathermal to multi-MeV ions — the dominant scattering mechanism is geometrical chaotization, producing order-unity pitch-angle jumps in a single encounter. This is qualitatively distinct from quasi-linear resonance broadening. The resulting pitch-angle diffusion coefficient increases with energy, rather than peaking at resonance. And current sheets introduce a perpendicular transport channel — direct field-line jumping during demagnetization — that has no analog in wave-based models.

The macroscopic consequence is a perpendicular-to-parallel diffusion ratio that is **not constant** but increases with energy, exceeding the standard 2–4% above ~1 MeV. This may naturally explain SEP reservoirs, broad longitudinal spread at high energies, and flux-tube confinement at low energies — three phenomena that have separately motivated ad hoc extensions of quasi-linear theory for decades.

**Open questions**: the waiting-time distribution between current sheets is power-law tailed, which could drive anomalous transport not captured by a simple diffusion coefficient. Radial coupling — how transport evolves as particles propagate from 0.1 to 1 AU through an evolving current-sheet population — is the natural next step. And three-dimensional current sheet structure, including reconnection sites and flux ropes, may modify both the scattering physics and the perpendicular jump mechanism.

Thank you. I'm happy to take your questions.

---

_[Timing: Title+Outline ≈ 2 min · Part 0 background ≈ 13 min · Part 1 ≈ 15 min · Part 2 ≈ 15 min · Conclusion ≈ 5 min. Total ≈ 50 min.]_
