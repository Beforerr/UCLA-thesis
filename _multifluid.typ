#let equation-numbering = "(1)"

= Multifluid equilibrium model of current sheets with interpenetrating ion beams

== Introduction

Solar wind discontinuities are localized, transient, and intense coherent structures widely observed in the heliosphere @vasquezNumerousSmallMagnetic2007@grecoComplexStructureMagnetic2016@podestaMostIntenseCurrent2017@vaskoKineticscaleCurrentSheets2022@zhangSolarWindDiscontinuities2025a. They exhibit characteristics similar to nonlinear Alfvén waves, as evidenced by the strong correlations between fluctuations of the plasma velocity and the Alfvén velocity @dekeyserFlowShearSolar1998@paschmannDiscontinuitiesAlfvenicFluctuations2013@artemyevKineticPropertiesSolar2019@damicisAlfvenicSlowWind2021. Theoretical models predict that discontinuities may originate from Alfvén wave nonlinear evolution @medvedevDissipativeDynamicsCollisionless1997@medvedevFluidModelsKinetic1996 or plasma turbulence @servidioStatisticalAssociationDiscontinuities2011. The magnetic structure of most solar wind discontinuities are best described as current sheets characterized by an approximately constant magnetic field magnitude $B$, and a strong rotation of the magnetic field direction @neukirchFamilyVlasovMaxwell2020. Similar current-sheet configurations have been observed in the night-side magnetospheres of Earth @nakamuraClusterObservationsIonscale2008@kamaletdinovThinCurrentSheets2024, Mars @dibraccioMagnetotailDynamicsMars2015@artemyevMarssMagnetotailNatures2017, Venus @rongFlappingMotionVenusian2015, Mercury @rongMagneticFieldStructure2018, and Jupiter @artemyevThinCurrentSheets2014, as well as at magnetosphere boundaries (magnetopause). Being quasi-one-dimensional plasma structures, these current sheets contain two main magnetic field components, $B_x \( z \)$ reversing sign across the sheet, and $B_y \( z \)$ reaching a local maximum at the $B_x$ reversal, where $z$ denotes the coordinate along the current sheet normal. This magnetic configuration is of particular interest for magnetic reconnection and for scattering of energetic charged particles @artemyevSuperfastIonScattering2020@malaraChargedparticleChaoticDynamics2021@malaraEnergeticParticleDynamics2023@zhangQuantificationIonScattering2025.

#figure(
  image("figures/cs_theory/fig_examples.pdf"),
  caption: [
    Three examples of current sheets (discontinuities) observed by the Parker Solar Probe (PSP) @foxSolarProbeMission2016, ARTEMIS @angelopoulosARTEMISMission2011, and Wind @acunaGlobalGeospaceScience1995 spacecraft in the $upright(bold(l m n))$ coordinate system, each with sub-Alfvénic velocity jumps, where $upright(bold(l))$ represents the maximum variance direcction, $upright(bold(m))$ the intermediate variance direction, and $upright(bold(n))$ the minimum variance direction. From top to bottom, the panels display the magnetic field components, the plasma velocity, the Alfvén velocity in the $x$-direction (maximum variance direction) with the mean value subtracted (shifted Alfvén velocity), the similarly shifted plasma velocity, and the plasma density. Details about the instruments and data sets are provided in the Appendix.
  ],
)
<fig-multifluid-examples>

#ref(<fig-multifluid-examples>, supplement: [Figure]) presents three examples of current sheets observed in the solar wind and at Earth's distant magnetotail. These examples show similar magnetic field configurations, where the reversal in $B_x$ is accompanied by a peak in $B_y$ that compensates for the reduction in magnetic pressure, $B_x^2 \/ 2 mu_0$ (i.e., the stress balance across the sheet is $B_x^2 + B_y^2 = upright("const")$). Several models describe force-free current sheets with $B_z = 0$, where the current sheet configuration resembles a tangential discontinuity @harrisonOnedimensionalVlasovmaxwellEquilibrium2009@neukirchFamilyVlasovMaxwell2020. However, when $B_z eq.not 0$, tangential-discontinuity models are no longer applicable and an additional stress balance must be satisfied beyond $B_x^2 + B_y^2 = upright("const")$ @hudsonDiscontinuitiesAnisotropicPlasma1970, namely: $\| Delta v_(A \, x) \| = \| Delta U_x \|$, where $Delta$ denotes the change across the current sheet, and $v_(A \, x)$ and $U_x$ are the Alfvén and plasma velocities in the $x$-direction, respectively. This equality, expected within ideal single-fluid MHD, can be violated in multi-component and/or anisotropic plasmas. Indeed, spacecarft observations show that the Alfvénicity---defined as the ratio of $\| Delta U \| \/ \| Delta v_A \|$---is frequently less than unity in current sheets (see #ref(<fig-multifluid-examples>, supplement: [Figure]) and Refs. ). These deviations motivate extensions beyond the single-fluid MHD framework.

One important generalization involves considering a multi-component plasma. Spacecraft observations frequently reveal counter-streaming ion populations in and around solar wind current sheets @artemyevIonNongyrotropySolar2020@shenComparingPlasmaAnisotropy2024, and such interpenetrating beams can significantly modify the stress balance and internal structure of the current sheet @vaskoThinCurrentSheets2014. These kinetic features---the partitioning between thermal and drift energy, and the distinct dynamics of each ion population---cannot be captured by single-fluid models. In this study, we develop a multifluid model to describe the 1D structure of force-free current sheets (discontinuities) with $B_z eq.not 0$. This model is analytically tractable while retaining key multi-species effects.

== Multifluid Model

We used a multifluid model for the one-dimensional, quasi-neutral, current sheet equilibrium where the force free condition (a zero plasma pressure gradient) is satisfied for the bulk plasma. This approach, inspired by #cite(<steinhauerMultifluidModelOnedimensional2008>, form: "prose"), has the advantage of being analytically tractable while capturing key features of kinetic behavior, such as the partitioning between thermal and drift energy in each ion population. The fully kinetic approach, which examines the evolution of the velocity distribution function in phase space, is in principle more accurate, but hard to solve analytically for force-free current sheets with $B_n eq.not 0$ (see the discussion in Refs. ). Recent efforts to construct exact kinetic equilibria using action integrals with analytical approximations @egedalAnalyticalApproximationsCurrent2025@egedalPlasmaSheathSmall2023 represent a promising formulation that has a potential to be generalized on force-free equilibrium in order to address the observed discrepancies. The multifluid model is a good compromise between the simplicity of the MHD model and the complexity of the fully kinetic model.

In this model, we assume that the asymptotic boundary conditions are known (e.g., determined from spacecraft measurements far away from the discontinuity), including the normal component of the magnetic field ($B_z$), the magnitude of the magnetic field ($B$), and the asymptotic properties of the incident fluid streams. It should be noted that while the velocity space boundary between different ion populations may be clearly distinguishable in the uniform field region outside the current sheet @artemyevIonNongyrotropySolar2020, this boundary becomes more subtle, diffuse, and less tractable within the current sheet. For instance, an individual ion may transition from one population to another, and some ions may even become trapped within the current sheet. These complexities, particularly ion behavior within the sheet, are beyond the scope of this paper and will not be addressed in the current analysis.

The governing equations for the multifluid collisionless plasma model can be expressed in conservation law form as follows:

#math.equation(block: true, numbering: equation-numbering, [ $
  (frac(partial, partial t) + upright(bold(u))_alpha dot.c nabla) n_alpha = - n_alpha nabla dot.c upright(bold(u))_alpha
$ ])<eq-density>

#math.equation(block: true, numbering: equation-numbering, [ $
  m_alpha n_alpha (frac(partial, partial t) + upright(bold(u))_alpha dot.c nabla) upright(bold(u))_alpha = - nabla dot.c upright(bold(P))_alpha + q_alpha n_alpha (upright(bold(E)) + upright(bold(u))_alpha times upright(bold(B)))
$ ])<eq-velocity>

#math.equation(block: true, numbering: equation-numbering, [ $
  nabla times upright(bold(B)) = mu_0 (upright(bold(J)) + epsilon.alt_0 frac(partial upright(bold(E)), partial t))
$ ])<eq-Ampere>

#math.equation(block: true, numbering: equation-numbering, [ $ nabla dot.c upright(bold(B)) = 0 $ ])<eq-Gauss>

where $alpha$ indicates the particle species (electron and different ion populations), $n_alpha$ the number density, $m_alpha$ the mass, $q_alpha$ the charge, $upright(bold(u))_alpha$ the bulk velocity, $upright(bold(P))_alpha$ the pressure tensor, $upright(bold(E))$ the electric field, $upright(bold(B))$ the magnetic induction (magnetic field), $upright(bold(J))$ the current density, $epsilon.alt_0$ the vacuum permittivity, and $mu_0$ the vacuum permeability.

This work focuses on steady-state solutions in the deHoffman-Teller frame, where all partial derivatives with respect to time vanish, i.e., $frac(partial, partial t) = 0$. We further assume that the magnetic field varies only along a single Cartesian coordinate, $z$. Under these assumptions, conservation of mass for each species, expressed as $d \( n_alpha u_(alpha z) \) \/ d z = 0$, integrates to a constant, $Gamma_alpha = n_alpha u_(alpha z)$. Gauss's law for magnetism requires that $B_z$ remains constant throughout the current sheet. The steady-state Faraday's law further implies that the electric field can be derived from an electrostatic potential $phi.alt$. Additionally, electrons can be approximated as a massless, charge-neutralizing background. In this case, the electron momentum equation implies that electrons move along magnetic field lines, i.e., $upright(bold(u))_e times upright(bold(B)) = 0$. For further simplification, we assume an isotropic pressure model, eliminating all non-diagonal components of the pressure tensor for each ion species. Furthermore, we consider the ions to be single-charged, meaning that $q_alpha = e$ for all species.

The momentum equations for each ion species are then given by:

#math.equation(block: true, numbering: equation-numbering, [ $
  m_alpha Gamma_alpha frac(d u_(alpha x), d z) & = e \( n_alpha u_(alpha y) B_z - Gamma_alpha B_y \)\
  m_alpha Gamma_alpha frac(d u_(alpha y), d z) & = e \( Gamma_alpha B_x - n_alpha u_(alpha x) B_z \)\
  m_alpha Gamma_alpha frac(d u_(alpha z), d z) & = - frac(d p_alpha, d z) + n_alpha e \( - frac(d phi.alt, d z) + u_(alpha x) B_y - u_(alpha y) B_x \)
$ ])<eq-momentum>

Ampere's law connects the fields and the flow components:

#math.equation(block: true, numbering: equation-numbering, [ $
  1 / mu_0 frac(d B_y, d z) = - J_x = - sum_alpha e n_alpha u_(alpha x) + e n_e u_(e x)
$ ])<eq-Jx>

#math.equation(block: true, numbering: equation-numbering, [ $
  1 / mu_0 frac(d B_x, d z) = J_y = sum_alpha e n_alpha u_(alpha y) - e n_e u_(e y)
$ ])<eq-Jy>

#math.equation(block: true, numbering: equation-numbering, [ $
  0 = J_z = sum_alpha e n_alpha u_(alpha z) - e n_e u_(e z)
$ ])<eq-Jz>

#ref(<eq-Jz>, supplement: [Equation]) allows the elimination of electron variables $Gamma_e = sum_alpha Gamma_alpha$.

In the asymptotic region (far from the current sheet), as all variables approach constant values, the derivatives must vanish. For the $y$-component of the momentum equation (#ref(<eq-momentum>, supplement: [Equation])), this means $Gamma_alpha B_x \( oo \) - n_alpha \( oo \) u_(alpha x) \( oo \) B_z = 0$. This relates the asymptotic velocity of each species to the asymptotic magnetic field.

Combining the $x$-component of the momentum equation (#ref(<eq-momentum>, supplement: [Equation])) for different ion populations and Ampere's law in the $y$-direction (#ref(<eq-Jy>, supplement: [Equation])), under the condition that the constant of integration vanishes at the center of the current sheet (which holds when the $x$-components of both the magnetic field and flow velocity are odd functions of $z$), we obtain:

#math.equation(block: true, numbering: equation-numbering, [ $
  B_x B_z = mu_0 sum_alpha m_alpha Gamma_alpha u_(alpha x)
$ ])<eq-balance>

Evaluating the above equation in the asymptotic limit and substituting $u_(alpha x) \( oo \)$, we have

#math.equation(block: true, numbering: equation-numbering, [ $
  B_z^2 = mu_0 sum_alpha m_alpha Gamma_alpha^2 \/ n_alpha \( oo \)
$ ])<eq-asym1>

This imposes a constraint on the constant parameters of the system $B_z \, Gamma_alpha$ and $n_alpha \( oo \)$. For instance, once $Gamma_alpha$ and $n_alpha \( oo \)$ are defined from boundary conditions, $B_z$ is also determined.

Using this equation, we may express the jump in velocities across the current sheet as:

$
         Delta U_x & = (sum_alpha m_alpha n_alpha \( oo \))^(- 1) sum_alpha m_alpha n_alpha \( oo \) Delta u_(alpha x) \
  Delta v_(A \, x) & = frac(Delta B_x, sqrt(mu_0 sum_alpha m_alpha n_alpha \( oo \))) \,
$

where $Delta u_(alpha x) = u_(alpha x) \( + oo \) - u_(alpha x) \( - oo \)$ and $Delta B_x = B_x \( + oo \) - B_x \( - oo \)$ are evaluated in the $z arrow.r plus.minus oo$ limits. By substituting the expressions for $u_(alpha x) \( oo \)$ and $B_z$ (#ref(<eq-asym1>, supplement: [Equation])), we derive a simplified relation that links the jump in Alfvén velocity to the jump in plasma bulk velocity along the $x$-direction:

#math.equation(block: true, numbering: equation-numbering, [ $
  (sum_alpha Gamma_alpha m_alpha) Delta v_(A \, x) = sqrt(sum_alpha m_alpha n_alpha \( oo \) sum_alpha frac(m_alpha Gamma_alpha^2, n_alpha \( oo \))) Delta U_x
$ ])<eq-vRatio>

In the case of a single-fluid plasma, this expression reduces to the simpler $Delta v_(A \, x) = Delta U_x$ force balance condition for a rotational discontinuity. In the case of a system consisting of two ion fluids with equal mass and equal but opposite velocities in the $z$-direction, i.e., $m_1 = m_2 \, u_(z \, 1) \( oo \) = - u_(z \, 2) \( oo \)$, the above expression can be further simplified to:

#math.equation(block: true, numbering: equation-numbering, [ $
  \| n_1 \( oo \) - n_2 \( oo \) \| Delta v_(A \, x) = \( n_1 \( oo \) + n_2 \( oo \) \) Delta U_x
$ ])<eq-vRatio2>

== Results
<results>
The above multifluid model is applied here to study a specific plasma system consisting of multiple proton populations, where the ion mass is $m_alpha = m_p$ and the charge is $q_alpha = e$ for each species $alpha$. We focus on analyzing the effects of the model parameters on the plasma system.

Under the force-free condition, the sum of the squared magnetic field components remains constant, $B_x^2 + B_y^2 = B^2 - B_z^2 = upright("const")$. Thus, the magnetic field can be parameterized by a rotation angle $theta$ and $B_0$, such that $B_x = B_0 cos theta$ and $B_y = B_0 sin theta$. By multiplying Ampere's law for the $x$-component (#ref(<eq-Jx>, supplement: [Equation])) by $B_y$ and for the $y$-component (#ref(<eq-Jy>, supplement: [Equation])) by $B_x$, and then adding the two equations, we find:

$
  sum_alpha q_alpha n_alpha \( u_(alpha y) B_x - u_(alpha x) B_y \) = frac(1, 2 mu_0) frac(d \( B_x^2 + B_y^2 \), d z) = 0 .
$

To satisfy this condition, we require that

#math.equation(block: true, numbering: equation-numbering, [ $ u_(alpha y) B_x - u_(alpha x) B_y = 0 $ ])<eq-alpha>

Combining this relation with the first two components of the momentum equation (#ref(<eq-momentum>, supplement: [Equation])), we obtain: $u_(alpha x)^2 + u_(alpha y)^2 = upright("const")$. This allows us to express the velocity of each species in terms of the rotation angle $theta_alpha$ as $u_(alpha x) \( z \) = u_alpha cos theta_alpha \( z \)$ and $u_(alpha y) \( z \) = u_alpha sin theta_alpha \( z \)$, where $u_alpha$ is a constant for each species. By substituting the above expression into our assumption (#ref(<eq-alpha>, supplement: [Equation])), we have:

$ tan theta = tan theta_alpha $

Here we consider the case where $theta_alpha = theta$ for all species, but the same procedure can be applied to the case where $theta_alpha = theta + pi$.

Ampere's law (#ref(<eq-Jy>, supplement: [Equation])) after substitution becomes:

$ - B_0 sin theta med theta' = mu_0 e (sum_alpha n_alpha u_alpha sin theta - Gamma_e sin theta B_0 / B_z) $

#math.equation(block: true, numbering: equation-numbering, [ $
  arrow.r.double theta' = mu_0 e (Gamma_e / B_z - frac(sum_alpha n_alpha u_alpha, B_0))
$ ])<eq-theta>

The $x$-component of the momentum equation (#ref(<eq-momentum>, supplement: [Equation])) after substitution becomes:

$ - u_alpha sin theta med theta' = e / m_alpha \( n_alpha u_alpha sin theta med B_z \/ Gamma_alpha - B_0 sin theta \) $

#math.equation(block: true, numbering: equation-numbering, [ $
  arrow.r.double theta' = e / m_alpha (B_0 / u_alpha - frac(n_alpha B_z, Gamma_alpha))
$ ])<eq-theta1>

where $' = d \/ d z$. By equating the above two equations of $theta'$, we could get a relation connecting the plasma bulk property $sum_alpha n_alpha u_alpha$ to one specific species:

$
  sum_alpha n_alpha u_alpha = B_0 (Gamma_e / B_z + frac(1, mu_0 m_alpha) (frac(n_alpha B_z, Gamma_alpha) - B_0 / u_alpha))
$

In the asymptotic region, the derivative must vanish, leading to condition $- frac(n_alpha \( oo \) B_z, Gamma_alpha) + B_0 / u_alpha = 0$. This allows us to rewrite the above Equation (#ref(<eq-theta1>, supplement: [Equation])) in terms of asymptotic values:

#math.equation(block: true, numbering: equation-numbering, [ $
  theta' = frac(e B_z, m_alpha Gamma_alpha) (n_alpha \( oo \) - n_alpha) .
$ ])<eq-theta1-asym>

Here, $theta$ and $n_alpha$ are dependent variables, while $B_z$, $m_alpha$, and $Gamma_alpha$ are constants predetermined by the system. Therefore, by specifying a profile for $n_alpha$ and imposing appropriate boundary conditions, one can solve this equation to determine the profile of $theta$.
Conveniently, the center of the current sheet is chosen as the origin $z = 0$, which corresponds to the lower boundary of Equation (#ref(<eq-theta1-asym>, supplement: [Equation])). As a result, the boundary condition for the rotation angle is given by $theta_alpha \( 0 \) = pi \/ 2$.

#math.equation(block: true, numbering: equation-numbering, [ $
  frac(d, d z) (frac(m_alpha Gamma_alpha^2, n_alpha) + p_alpha) = - e n_alpha frac(d phi.alt, d z) .
$ ])<eq-mom-z>

Notably, $n_alpha$ and $p_alpha$ are decoupled from the angle $theta$. The prescribed pressure model for ions and electrons introduces $N$ additional equations relating $p_alpha$ and $n_alpha$ and another equation connecting $phi.alt$ and $n_e$, making the system over-constrained when only a trivial solution is possible. Therefore, rather than imposing specific equations of state, we define the density profile for one of the ion species and treat it as a free parameter. By specifying this profile, the remaining equations can be solved. For this purpose, we adopt a Lorentzian function with a background density to describe the first ion population:

$ n_1 \( z \) arrow.r n_1 \( oo \) + frac(kappa Gamma_1, V_A) frac(1, 1 + \( z \/ L \)^2) $

where $L$ is the spatial scale of the current sheet, $Gamma_alpha equiv n_alpha \( oo \) u_(z \, alpha) \( oo \)$ is an integration constant, $V_A equiv B_z \/ sqrt(mu_0 m_p n \( oo \))$ is the Alfvén velocity in the $z$ direction, and $kappa$ is a dimensionless quantity that characterizes the magnitude of density variation.

By solving Equation (#ref(<eq-theta1-asym>, supplement: [Equation])) analytically, we obtain the rotation angle profile as:

$ theta \( z \) = pi / 2 - frac(e kappa L B_z tan^(- 1) (z \/ L), m_p V_A) $

where $e L B_z \/ m_p V_A = L \/ d_i$ and $d_i$ is ion (proton) inertial length.

Using this result, the density profiles for the other ion population and the total ion population can be expressed as:

$
  n_alpha \( z \) & = n_alpha \( oo \) + frac(Delta n_alpha, 1 + \( z \/ L \)^2) \
        n \( z \) & = n \( oo \) + frac(Delta n, 1 + \( z \/ L \)^2)
$

where $Delta n_alpha equiv n_alpha \( 0 \) - n_alpha \( oo \) = kappa Gamma_alpha \/ V_A$ and $Delta n equiv n \( 0 \) - n \( oo \) = kappa sum_alpha Gamma_alpha \/ V_A$.

The corresponding models for the magnetic field, current density, and plasma flows are given by:

$
                 B_x \( z \) & = B_0 cos (theta \( z \)) \
                 B_y \( z \) & = B_0 sin (theta \( z \)) \
    upright(bold(J)) \( z \) & = frac(e kappa B_z, mu_0 m_p V_A) frac(upright(bold(B)) \( z \), 1 + \( z \/ L \)^2) \
  upright(bold(J))_e \( z \) & = - e frac(upright(bold(B)) \( z \), B_z) sum_alpha Gamma_alpha \
  upright(bold(J))_i \( z \) & = upright(bold(J)) \( z \) - upright(bold(J))_e \( z \) \
    upright(bold(U)) \( z \) & = frac(upright(bold(J))_i \( z \), e n \( z \))
$

where $i$ and $e$ denote ion and electron currents, and the vectors $upright(bold(J))$, $upright(bold(B))$, $upright(bold(U))$ have two components, $x$ and $y$. Using the relation $Delta n_alpha \/ Delta n = Gamma_alpha \/ sum_alpha Gamma_alpha$ and (#ref(<eq-asym1>, supplement: [Equation])), $kappa$ and $sum_alpha Gamma_alpha$ can be expressed in a form that involves only densities of ion populations:

$
  kappa & = sqrt(sum_alpha frac(Delta n_alpha^2, n \( oo \) n_alpha \( oo \)))\
  sum_alpha Gamma_alpha & = sqrt(frac(B_z^2, mu_0 m_p) frac(Delta n^2, sum_alpha Delta n_alpha^2 \/ n_alpha \( oo \))) = frac(V_A Delta n, kappa)
$

To facilitate subsequent analysis and visualization, it is useful to adopt a dimensionless system by normalizing the variables with their characteristic values: in this study, the magnetic field is normalized by $B_(upright("ref")) = B_z$, the density by $n_(upright("ref")) = n \( oo \)$, the length by $L_(upright("ref")) = d_i$, and the velocity by $V_(upright("ref")) = V_A$. In these normalized units, the relevant variables take the following form:

$
  theta \( z \) & = & pi / 2 - frac(kappa L tan^(- 1) (z \/ L), d_i)\
  frac(upright(bold(J)), e V_A n (oo)) & = & frac(upright(bold(B)) (z), B_z) frac(kappa, 1 + (z \/ L)^2)\
  frac(upright(bold(J))_e, e V_A n (oo)) & = & - frac(upright(bold(B)) (z), B_z) frac(Delta n, kappa n (oo))\
  upright(bold(U)) / V_A = frac(upright(bold(B)) (z), B_z) frac(n (oo), n (z)) & dot.op & (frac(kappa, 1 + (z \/ L)^2) + frac(Delta n, kappa n (oo)))\
$

The system is fully determined given $kappa$, $sum_alpha Gamma_alpha$, $L$, and $B_0$ (or equivalently, $Delta n_alpha$, $n_alpha \( oo \)$, $L$, and $B_0$). For the simplest situation where we have two populations of ions of the same density but with oppositely directed bulk velocities in the asymptotic limit, i.e.~$n_1 \( oo \) = n_2 \( oo \) \, u_(1 z) \( oo \) = - u_(2 z) \( oo \)$, the profile of the magnetic field, plasma density, and plasma velocity for one specific case ($L = d_i \, kappa = 1 \, B_0 = 2 B_z$) is plotted in #ref(<fig-profiles>, supplement: [Figure]). Note that in this symmetric case with $sum_alpha Gamma_alpha = 0$, $Delta n = Delta n_1 + Delta n_2 = 0$ we have

$
  upright(bold(J)) = frac(upright(bold(B)) (z), B_z) frac(e V_A n (oo), 1 + (z \/ L)^2) \, quad upright(bold(J))_e = 0 \, quad upright(bold(U)) = frac(upright(bold(J)), e n (oo))
$

and

$ theta = pi / 2 - tan^(- 1) (z \/ L) $

Therefore, we have zero electron current across the current sheet and zero $B_y$ in the asymptotic limit, corresponding to a $180^compose$ rotation of the magnetic field across the current sheet. However, in general cases with $Delta n eq.not 0$, we would expect the electron current to be nonzero.

#ref(<fig-profiles>, supplement: [Figure]) (left) shows a constant density and zero $U_z$, because for $u_1 = - u_2$ we have $sum_alpha Gamma_alpha = 0$, which leads to $n = n \( oo \)$, $Delta n = 0$, and $U_z equiv sum_alpha Gamma_alpha \/ n = 0$. Plasma (ion) bulk flow velocities show profiles with $U_y$ peaked at the current sheet center and $U_x$ reversal across the current sheet center. The velocity magnitude goes to zero far away from the current sheet, and there is no velocity jump across the sheet (i.e., this is a current sheet with zero Alfvénicity).
This symmetric case represents the limiting configuration where the stress balance across the force-free current sheet with $B_z eq.not 0$ is maintained entirely by the counter-streaming ion beams with $n_1 \( oo \) = n_2 \( oo \)$, without requiring a net bulk velocity jump $Delta U_x$.

Substituting into the right side #ref(<eq-vRatio2>, supplement: [Equation]), one can show that the stress balance is satisfied.

#ref(<fig-profiles>, supplement: [Figure]) (right) shows that in the absence of electron currents, the current density components have the same symmetry as the ion bulk velocity components: $U_x tilde.op J_x$ and $U_x tilde.op J_y$.

#figure(
  [
    #grid(
      columns: 2,
      gutter: 2em,
      [
        #block[
          #box(image("figures/cs_theory/profiles_sym.pdf"))

        ]
      ],
      [
        #block[
          #box(image("figures/cs_theory/J_profiles_sym.pdf"))

        ]
      ],
    )
  ],
  caption: figure.caption(
    position: bottom,
    [
      Left: Magnetic field, ion density, and ion bulk velocity for the case where $n_1 = n_2 \, u_1 = - u_2$ and $L = d_i \, sum_alpha Gamma_alpha = Delta n V_A = 1 \, B_0 = 2 B_z$. Right: Current density profiles for the same case. Note that the blue line ($J_x$) coincides with the green line ($J_(x \, i)$), and the yellow line ($J_y$) coincides with the red line ($J_(y \, i)$).
    ],
  ),
)
<fig-profiles>


The structure of the bulk velocity profile across the current sheet is directly controlled by the density asymmetry between ion populations. To demonstrate this, we consider the current sheet with finite $B_y \( oo \)$. We set $B_y \( oo \) = B_0 \/ 2 \, B_0 = 2 B_z$, and consider two ion populations with opposite bulk velocities but with different densities. By varying $n_1 \( oo \)$, we find that the magnetic field profiles remain unchanged, while plasma density and velocity profiles exhibit significant variations.

#figure(
  [
    #grid(
      columns: 2,
      gutter: 2em,
      [
        #block[
          #box(image("figures/cs_theory/profiles_n1Inf=0.6.pdf"))

        ]
      ],
      [
        #block[
          #box(image("figures/cs_theory/J_profiles_n1Inf=0.6.pdf"))

        ]
      ],
    )
  ],
  caption: figure.caption(
    position: bottom,
    [
      Same as #ref(<fig-profiles>, supplement: [Figure]), but for two ion species with same bulk velocity but different densities $n_1 \( oo \) \/ n_2 \( oo \) = 1.5$ and $B_y \( oo \) = B_0 \/ 2 = B_z$.
    ],
  ),
)
<fig-profilesEx2>


#ref(<fig-profilesEx2>, supplement: [Figure]) shows the results for $n_1 \( oo \) \/ n_2 \( oo \) = 1.5$. The main (reversal) magnetic field component, $B_x$, has a profile similar to that of Fig. , whereas the peak of $B_y$ is embedded in a constant background. The plasma density and $U_z$ profiles have a small minimum in the current sheet center, and this minimum in density must be compensated by a maximum in ion temperature to maintain constant plasma pressure. Compared with Fig. , the ion velocity components do not go to zero at the current sheet boundaries, and we have a finite bulk velocity jump with $Delta U_x = lr(|frac(n_1 \( oo \) - n_2 \( oo \), n_1 \( oo \) + n_2 \( oo \))|) Delta v_(A \, x)$.

A finite $Delta n$ results in nonzero electron currents. Therefore, the ion current density and the total current density profiles are not identical. There are finite ion and electron currents at the current sheet boundaries, but these currents compensate each other outside the current sheet and leave a nonzero total current only inside the current sheet.

To illustrate how the relative density of ion populations controls the velocity structure, we show in #ref(<fig-UNormB0>, supplement: [Figure]) (left) profiles of normalized $U_x \/ v_A$ for different density values, $n_1 \( oo \)$ of the first ion population (note that $n_1 \( oo \) = 0.5$ is the symmetric case with $n_1 \( oo \) = n_2 \( oo \)$ and $Delta n = 0$). For $n_1 \( oo \) = 0.5$, we have zero bulk velocity change across the current sheet and the change increases as $n_1 \( oo \)$ decreases to zero. Therefore, the model allows regulation of $Delta U_x$ by the density of the ion beam. #ref(<fig-UNormB0>, supplement: [Figure]) (right) shows the normalized plasma velocity $U_y$ for different $n_1 \( oo \)$: There is no jump of $U_y$ across the sheet, but the asymptotic $U_y \( oo \)$ depends on $n_1$ and decreases to zero when $n_1 \( oo \) = n_2 \( oo \)$.

#figure(
  [
    #grid(
      columns: 2,
      gutter: 2em,
      [
        #block[
          #box(image("figures/cs_theory/UxNormB0.pdf"))

        ]
      ],
      [
        #block[
          #box(image("figures/cs_theory/UyNormB0.pdf"))

        ]
      ],
    )
  ],
  caption: figure.caption(
    position: bottom,
    [
      Plasma velocity $U_x$ (left) and $U_y$ (right) profiles normalized by asymptotic Alfvén velocity $V_A \( oo \) = B_0 \/ sqrt(mu_0 m_p n \( oo \))$ for different $n_1 \( oo \)$.
    ],
  ),
)
<fig-UNormB0>


The spatial profiles of $U_x$ and $U_y$ follow the profiles of $B_x$ and $B_y$. Consequently, the ratios $U_x \/ v_(A \, x)$ and $U_y \/ v_(A \, y)$ provide insight into the extent to which variations in the Alfvén velocity can be explained by variations in plasma flow. These ratios are plotted in #ref(<fig-UNormBlocal>, supplement: [Figure]). The normalized plasma velocity profiles are exactly the same for $U_x \/ v_(A \, x)$ and $U_y \/ v_(A \, y)$ and depend only on $n_1 \( oo \)$. As $n_1 \( oo \)$ approaches zero, the normalized plasma velocity at the current sheet boundaries tends to unity $U_x \/ v_(A \, x) arrow.r 1$. This corresponds to the single-fluid limit, where the stress balance reduces to that of a classical rotational discontinuity.

#figure(
  [
    #grid(
      columns: 2,
      gutter: 2em,
      [
        #block[
          #box(image("figures/cs_theory/UxNormBx.pdf"))

        ]
      ],
      [
        #block[
          #box(image("figures/cs_theory/UyNormBy.pdf"))

        ]
      ],
    )
  ],
  caption: [
    Plasma velocity $U_x$ (left) and $U_y$ (right) profiles normalized by local Alfvén velocity $v_(A \, x) \( z \) = B_x \( z \) \/ sqrt(mu_0 m_p n \( z \))$ and $v_(A \, y) \( z \) = B_y \( z \) \/ sqrt(mu_0 m_p n \( z \))$ for different $n_1 \( oo \)$.
  ],
)
<fig-UNormBlocal>


== Discussion
<discussion>
This work presents a phenomenological multifluid equilibrium model of current sheets with an arbitrary level of Alfvénicity. This model naturally accommodates interpenetrating ion beams and a tunable velocity structure controlled by the relative densities of ion populations.
The primary application of this model is to describe current sheets in the solar wind @artemyevKineticNatureSolar2019 and planetary magnetotails @kamaletdinovCharacteristicsThinMagnetotail2024. It should be noted that this model does not represent the unique equilibrium solution for a force-free current sheet, but rather shows one of many possible solutions. A detailed analysis of the dynamical properties of plasma equilibria is necessary to identify which subclass of solutions is most likely to be realized in space plasmas (see the discussion in Refs. ). Therefore, our study proposes one possible direction for describing solar wind current sheets using a multifluid 1D equilibrium model, but further investigation, particularly of the kinetic dynamics of such equilibria, is needed to fully understand their relevance to observations.

Within our model framework, the velocity ratio $Delta U_x \/ Delta v_(A \, x)$ across the current sheet can be controlled by the density asymmetry between ion populations (#ref(<eq-vRatio2>, supplement: [Equation])): configurations with $n_1 gt.double n_2$ approach the single-fluid limit with $Delta U_x \/ Delta v_(A \, x) arrow.r 1$, while more balanced densities ($n_1 approx n_2$) yield lower ratios. Previous observations have shown that this ratio is typically sub-unity in the solar wind @dekeyserFlowShearSolar1998@artemyevKineticPropertiesSolar2019, consistent with the presence of multiple ion populations with comparable densities, which creates an effective plasma pressure anisotropy ($P_parallel eq.not P_perp$) supported by two counter-streaming beams @steinhauerMultifluidModelOnedimensional2008. We note that the velocity ratio across current sheets is likely influenced by multiple physical effects beyond the multifluid structure described here. In particular, plasma pressure anisotropy ($P_parallel eq.not P_perp$) of each group can modify the effective Alfvén speed @hudsonDiscontinuitiesAnisotropicPlasma1970 and can independently affect the expected velocity ratio. A complete description of solar wind current sheets will likely require incorporating both multi-species effects and pressure anisotropy within a unified framework. The model presented here provides an analytically tractable foundation for such future work, while demonstrating that the presence of interpenetrating ion beams is a fundamental feature that shapes the internal structure and stress balance of force-free current sheets.

== Data Availability
<data-availability>
The codes and data supporting the findings of this study are available in the GitHub repository #link("https://github.com/Beforerr/cs_theory").

== Appendix
<appendix>
The appendix describes the procedures used to identify current sheets and to characterize their properties for #ref(<fig-multifluid-examples>, supplement: [Figure]).

We use three main data sets collected by the PSP, ARTEMIS, and Wind missions during PSP Encounter 7 from 2021-01-14 to 2021-01-21. Magnetic field measurements for PSP were obtained with the FIELDS instrument suite @baleFIELDSInstrumentSuite2016, while plasma velocity and density were provided by the electrostatic analyzer (SPAN-Ion) on the SWEAP suite @kasperSolarWindElectrons2016. For ARTEMIS, magnetic field data were acquired using the Fluxgate Magnetometer @austerTHEMISFluxgateMagnetometer2008, and plasma measurements were obtained from the Electrostatic Analyzers @mcfaddenTHEMISESAPlasma2009. The Wind spacecraft used the Magnetic Field Investigation instrument @leppingWINDMagneticField1995 for magnetic field measurements, and 3D Plasma Analyzer electrostatic analyzers on the Solar Wind Experiment @ogilvieSWEComprehensivePlasma1995 for proton velocity and density.

To identify current sheets in the solar wind, we employ the method of . For each sampling time $t$, we define three intervals: the pre-interval $\[ - 1 \, - 1 \/ 2 \] dot.op T + t$, the middle interval $\[ - 1 \/ 2 \, 1 \/ 2 \] dot.op T + t$, and the post-interval $\[ 1 \/ 2 \, 1 \] dot.op T + t$, where $T$ represents the time lag. The magnetic field time series within these intervals are labeled as $upright(bold(B))_(-)$, $upright(bold(B))_0$, and $upright(bold(B))_(+)$, respectively. We then apply three detection criteria to establish time intervals containing current sheet candidates: (1) $sigma \( upright(bold(B))_0 \) > 2 max [sigma \( upright(bold(B))_(-) \) \, sigma \( upright(bold(B))_(+) \)]$\; (2) $sigma (upright(bold(B))_(-) + upright(bold(B))_(+)) > sigma \( upright(bold(B))_(-) \) + sigma \( upright(bold(B))_(+) \)$\; and (3) $\| Delta upright(bold(B)) \| > \| upright(bold(B))_(b g) \| \/ 10$. Here, $sigma$ denotes the standard deviation, $upright(bold(B))_(b g)$ is the magnitude of the background magnetic field, and $Delta upright(bold(B)) = upright(bold(B)) \( t + T \/ 2 \) - upright(bold(B)) \( t - T \/ 2 \)$. The first two conditions ensure that field changes are distinguishable from stochastic fluctuations, while the third serves as an additional filter to reduce recognition uncertainty @liuMagneticDiscontinuitiesSolar2022.

After identifying current sheet candidates, we use the magnetic field time series to construct a distance matrix following @dokmanicEuclideanDistanceMatrices2015. The distance between two magnetic field vectors, $upright(bold(B)) \( t_i \)$ and $upright(bold(B)) \( t_j \)$, is defined as the Euclidean norm: $d \( t_i \, t_j \) = parallel upright(bold(B)) \( t_i \) - upright(bold(B)) \( t_j \) parallel$. The leading and trailing edges of the current sheet are located at times $t_1$ and $t_2$ (with $t_1 < t_2$), corresponding to the maximum value of $d \( t_i \, t_j \)$ within the interval. Subsequently, we apply maximum variance analysis (MVA) @sonnerupMinimumMaximumVariance1998 to transform the magnetic field into the local current sheet coordinate system ($upright(bold(l m n))$). Finally, we examine the plasma bulk velocity within the time interval $\[ t_1 \, t_2 \]$, project it onto the $l$-direction, and compare the change in plasma velocity with the corresponding change in Alfvén velocity along the same direction.
