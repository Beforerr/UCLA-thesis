// Simple numbering for non-book documents
#let equation-numbering = "(1)"
#let callout-numbering = "1"
#let subfloat-numbering(n-super, subfloat-idx) = {
  numbering("1a", n-super, subfloat-idx)
}

// Theorem configuration for theorion
// Simple numbering for non-book documents (no heading inheritance)
#let theorem-inherited-levels = 0

// Theorem numbering format (can be overridden by extensions for appendix support)
// This function returns the numbering pattern to use
#let theorem-numbering(loc) = "1.1"

// Default theorem render function
#let theorem-render(prefix: none, title: "", full-title: auto, body) = {
  if full-title != "" and full-title != auto and full-title != none {
    strong[#full-title.]
    h(0.5em)
  }
  body
}
// Some definitions presupposed by pandoc's typst output.
#let content-to-string(content) = {
  if content.has("text") {
    content.text
  } else if content.has("children") {
    content.children.map(content-to-string).join("")
  } else if content.has("body") {
    content-to-string(content.body)
  } else if content == [ ] {
    " "
  }
}

#let horizontalrule = line(start: (25%,0%), end: (75%,0%))

#let endnote(num, contents) = [
  #stack(dir: ltr, spacing: 3pt, super[#num], contents)
]

// Use nested show rule to preserve list structure for PDF/UA-1 accessibility
// See: https://github.com/quarto-dev/quarto-cli/pull/13249#discussion_r2678934509
#show terms: it => {
  show terms.item: item => {
    set text(weight: "bold")
    item.term
    block(inset: (left: 1.5em, top: -0.4em))[#item.description]
  }
  it
}

// Prevent breaking inside definition items, i.e., keep term and description together.
#show terms.item: set block(breakable: false)

// Some quarto-specific definitions.

#show raw.where(block: true): set block(
    fill: luma(230),
    width: 100%,
    inset: 8pt,
    radius: 2pt
  )

#let block_with_new_content(old_block, new_content) = {
  let d = (:)
  let fields = old_block.fields()
  fields.remove("body")
  if fields.at("below", default: none) != none {
    // TODO: this is a hack because below is a "synthesized element"
    // according to the experts in the typst discord...
    fields.below = fields.below.abs
  }
  return block.with(..fields)(new_content)
}

#let empty(v) = {
  if type(v) == str {
    // two dollar signs here because we're technically inside
    // a Pandoc template :grimace:
    v.matches(regex("^\\s*$")).at(0, default: none) != none
  } else if type(v) == content {
    if v.at("text", default: none) != none {
      return empty(v.text)
    }
    for child in v.at("children", default: ()) {
      if not empty(child) {
        return false
      }
    }
    return true
  }

}

// Subfloats
// This is a technique that we adapted from https://github.com/tingerrr/subpar/
#let quartosubfloatcounter = counter("quartosubfloatcounter")

#let quarto_super(
  kind: str,
  caption: none,
  label: none,
  supplement: str,
  position: none,
  subcapnumbering: "(a)",
  body,
) = {
  context {
    let figcounter = counter(figure.where(kind: kind))
    let n-super = figcounter.get().first() + 1
    set figure.caption(position: position)
    [#figure(
      kind: kind,
      supplement: supplement,
      caption: caption,
      {
        show figure.where(kind: kind): set figure(numbering: _ => {
          let subfloat-idx = quartosubfloatcounter.get().first() + 1
          subfloat-numbering(n-super, subfloat-idx)
        })
        show figure.where(kind: kind): set figure.caption(position: position)

        show figure: it => {
          let num = numbering(subcapnumbering, n-super, quartosubfloatcounter.get().first() + 1)
          show figure.caption: it => block({
            num.slice(2) // I don't understand why the numbering contains output that it really shouldn't, but this fixes it shrug?
            [ ]
            it.body
          })

          quartosubfloatcounter.step()
          it
          counter(figure.where(kind: it.kind)).update(n => n - 1)
        }

        quartosubfloatcounter.update(0)
        body
      }
    )#label]
  }
}

// callout rendering
// this is a figure show rule because callouts are crossreferenceable
#show figure: it => {
  if type(it.kind) != str {
    return it
  }
  let kind_match = it.kind.matches(regex("^quarto-callout-(.*)")).at(0, default: none)
  if kind_match == none {
    return it
  }
  let kind = kind_match.captures.at(0, default: "other")
  kind = upper(kind.first()) + kind.slice(1)
  // now we pull apart the callout and reassemble it with the crossref name and counter

  // when we cleanup pandoc's emitted code to avoid spaces this will have to change
  let old_callout = it.body.children.at(1).body.children.at(1)
  let old_title_block = old_callout.body.children.at(0)
  let children = old_title_block.body.body.children
  let old_title = if children.len() == 1 {
    children.at(0)  // no icon: title at index 0
  } else {
    children.at(1)  // with icon: title at index 1
  }

  // TODO use custom separator if available
  // Use the figure's counter display which handles chapter-based numbering
  // (when numbering is a function that includes the heading counter)
  let callout_num = it.counter.display(it.numbering)
  let new_title = if empty(old_title) {
    [#kind #callout_num]
  } else {
    [#kind #callout_num: #old_title]
  }

  let new_title_block = block_with_new_content(
    old_title_block,
    block_with_new_content(
      old_title_block.body,
      if children.len() == 1 {
        new_title  // no icon: just the title
      } else {
        children.at(0) + new_title  // with icon: preserve icon block + new title
      }))

  block_with_new_content(old_callout,
    block(below: 0pt, new_title_block) +
    old_callout.body.children.at(1))
}

// 2023-10-09: #fa-icon("fa-info") is not working, so we'll eval "#fa-info()" instead
#let callout(body: [], title: "Callout", background_color: rgb("#dddddd"), icon: none, icon_color: black, body_background_color: white) = {
  block(
    breakable: false, 
    fill: background_color, 
    stroke: (paint: icon_color, thickness: 0.5pt, cap: "round"), 
    width: 100%, 
    radius: 2pt,
    block(
      inset: 1pt,
      width: 100%, 
      below: 0pt, 
      block(
        fill: background_color,
        width: 100%,
        inset: 8pt)[#if icon != none [#text(icon_color, weight: 900)[#icon] ]#title]) +
      if(body != []){
        block(
          inset: 1pt, 
          width: 100%, 
          block(fill: body_background_color, width: 100%, inset: 8pt, body))
      }
    )
}




#let article(
  title: none,
  subtitle: none,
  authors: none,
  keywords: (),
  date: none,
  abstract-title: none,
  abstract: none,
  thanks: none,
  cols: 1,
  lang: "en",
  region: "US",
  font: none,
  fontsize: 11pt,
  title-size: 1.5em,
  subtitle-size: 1.25em,
  heading-family: none,
  heading-weight: "bold",
  heading-style: "normal",
  heading-color: black,
  heading-line-height: 0.65em,
  mathfont: none,
  codefont: none,
  linestretch: 1,
  sectionnumbering: none,
  linkcolor: none,
  citecolor: none,
  filecolor: none,
  toc: false,
  toc_title: none,
  toc_depth: none,
  toc_indent: 1.5em,
  doc,
) = {
  // Set document metadata for PDF accessibility
  set document(title: title, keywords: keywords)
  set document(
    author: authors.map(author => content-to-string(author.name)).join(", ", last: " & "),
  ) if authors != none and authors != ()
  set par(
    justify: true,
    leading: linestretch * 0.65em
  )
  set text(lang: lang,
           region: region,
           size: fontsize)
  set text(font: font) if font != none
  show math.equation: set text(font: mathfont) if mathfont != none
  show raw: set text(font: codefont) if codefont != none

  set heading(numbering: sectionnumbering)

  show link: set text(fill: rgb(content-to-string(linkcolor))) if linkcolor != none
  show ref: set text(fill: rgb(content-to-string(citecolor))) if citecolor != none
  show link: this => {
    if filecolor != none and type(this.dest) == label {
      text(this, fill: rgb(content-to-string(filecolor)))
    } else {
      text(this)
    }
   }

  place(
    top,
    float: true,
    scope: "parent",
    clearance: 4mm,
    block(below: 1em, width: 100%)[

      #if title != none {
        align(center, block(inset: 2em)[
          #set par(leading: heading-line-height) if heading-line-height != none
          #set text(font: heading-family) if heading-family != none
          #set text(weight: heading-weight)
          #set text(style: heading-style) if heading-style != "normal"
          #set text(fill: heading-color) if heading-color != black

          #text(size: title-size)[#title #if thanks != none {
            footnote(thanks, numbering: "*")
            counter(footnote).update(n => n - 1)
          }]
          #(if subtitle != none {
            parbreak()
            text(size: subtitle-size)[#subtitle]
          })
        ])
      }

      #if authors != none and authors != () {
        let count = authors.len()
        let ncols = calc.min(count, 3)
        grid(
          columns: (1fr,) * ncols,
          row-gutter: 1.5em,
          ..authors.map(author =>
              align(center)[
                #author.name \
                #author.affiliation \
                #author.email
              ]
          )
        )
      }

      #if date != none {
        align(center)[#block(inset: 1em)[
          #date
        ]]
      }

      #if abstract != none {
        block(inset: 2em)[
        #text(weight: "semibold")[#abstract-title] #h(1em) #abstract
        ]
      }
    ]
  )

  if toc {
    let title = if toc_title == none {
      auto
    } else {
      toc_title
    }
    block(above: 0em, below: 2em)[
    #outline(
      title: toc_title,
      depth: toc_depth,
      indent: toc_indent
    );
    ]
  }

  doc
}

#set table(
  inset: 6pt,
  stroke: none
)
#let brand-color = (:)
#let brand-color-background = (:)
#let brand-logo = (:)

#set page(
  paper: "us-letter",
  margin: (x: 1.25in, y: 1.25in),
  numbering: "1",
  columns: 1,
)

#show: doc => article(
  title: [Kinetic-scale solar wind current sheets: statistical characteristics and their role in energetic particle transport],
  subtitle: [Thesis],
  authors: (
    ( name: [Zijin Zhang],
      affiliation: [],
      email: [] ),
    ),
  date: [2026-03-05],
  sectionnumbering: "1.1.a",
  toc_title: [Table of contents],
  toc_depth: 3,
  doc,
)

= Acknowledgments
<acknowledgments>
== Thesis Organization
<thesis-organization>
The overall goal of this thesis is to quantify and model the impact of solar wind current sheets on energetic particle transport. This research is structured around two primary objectives:

- Observational characterization of solar wind current sheets across the heliosphere

- Development of data-driven theoretical models for current sheet-induced particle scattering and transport

This thesis is organized into three main parts, progressing from observational characterization of solar wind current sheets, to their impact on energetic particle transport, and finally to methodological and modeling developments that support and extend the primary scientific results.

#pagebreak()
= Observations of Solar Wind Current Sheets
<observations-of-solar-wind-current-sheets>
== From MHD Discontinuities to Kinetic-Scale Current Sheets
<from-mhd-discontinuities-to-kinetic-scale-current-sheets>
Early observations from the Pioneer 6 mission revealed that the direction of the IMF is highly variable, an unexpected finding at the time @nessPreliminaryResultsPioneer1966. As shown in #ref(<fig-ness1966-fig6>, supplement: [Figure]), on hour-long timescales, these abrupt directional changes are clearly distinguishable from the comparatively quiet background in which the magnetic field evolves slowly. Such rapid variations in the magneto-plasma parameters were recognized as fundamental solar wind features @colburnDiscontinuitiesSolarWind1966 and were identified as magnetohydrodynamic discontinuities---spatial boundaries separating two distinct plasma regions.

MHD theory permits such discontinuities but constrains the changes allowed across them through the Rankine--Hugoniot jump conditions. The early solar wind measurements spurred the development of theory for anisotropic plasmas @hudsonDiscontinuitiesAnisotropicPlasma1970. Five distinct types are possible, the most relevant here being tangential discontinuities (TDs), rotational discontinuities (RDs), and shocks (relatively rare in the solar wind). Classifying observed discontinuities as RDs or TDs attracted considerable early research interest because the distinction carries physical implications for the topology of the IMFs @knetterNewPerspectiveSolar2005. A TD separates two topologically distinct plasma regions with no field-normal component, whereas an RD is a propagating structure that connects magnetically linked regions. This distinction has consequences for energetic particle diffusion coefficients and bears on possible generation mechanisms operating in the solar corona. The relative abundance of RDs and TDs in the solar wind has been the subject of longstanding debate @smithIdentificationInterplanetaryTangential1973@neugebauerReexaminationRotationalTangential1984@neugebauerCommentAbundancesRotational2006.

#figure([
#box(image("figures/ref/nessPreliminaryResultsPioneer1966-fig6.png"))
], caption: figure.caption(
position: bottom, 
[
Two-hour example of 1-minute averages of the interplanetary magnetic field for which the magnitude is average, but the direction is highly variable and principally inclined at large angles ($theta approx 90^compose$) to the ecliptic plane @nessPreliminaryResultsPioneer1966
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)
<fig-ness1966-fig6>


At smaller scales (on the order of seconds), many discontinuities retain their sharp character, though some reveal resolvable internal structure even in early measurements @siscoePowerSpectraDiscontinuities1968@burlagaDirectionalDiscontinuitiesInterplanetary1969. At these scales, the term "discontinuity" becomes inappropriate: the structure width is comparable to the ion inertial length, and MHD theory may no longer be applicable. The term #emph[current sheet] is adopted instead, emphasizing the current layer that maintains the field rotation. In this dissertation, we use "current sheet" throughout to emphasize the kinetic nature of these structures. The kinetic scale generally refers to structures with widths comparable to the ion inertial length, corresponding roughly to temporal scales below 30 seconds at 1 AU. (Four scale regimes were introduced by #cite(<burlagaDirectionalDiscontinuitiesInterplanetary1969>, form: "prose"): macro-scale (\> 100 h), meso-scale (1--100 h), micro-scale (30 s -- 1 h), and kinetic-scale (\< 30 s).)

Recent observations from multiple missions have confirmed that many solar wind current sheets possess fundamentally kinetic properties that defy a purely MHD description (see #ref(<fig-artemyevKineticNatureSolar2019-fig3>, supplement: [Figure]) for an example). #cite(<artemyevKineticNatureSolar2019>, form: "prose") analyzed discontinuities observed by the ARTEMIS and MMS missions and found that these structures exhibit characteristics of both TDs and RDs simultaneously: tangential velocity jumps correlate well with Alfvén speed jumps (an RD signature), yet electron density and temperature vary significantly across them (a TD signature).

#figure([
#box(image("figures/ref/artemyevKineticNatureSolar2019-fig3.jpg"))
], caption: figure.caption(
position: bottom, 
[
Discontinuity observations by two ARTEMIS (at ∼ 07:38:00 and ∼ 07:38:30) and the MMS 1 (at ∼ 07:53:00) spacecraft. (a) The magnetic field $B_l$ (left axis) and plasma velocity $v_l$ (right axis). (b1 and b2) The electron density $n_e$ (left axis) and temperature $T_e$ (right axis). (c1, c2, d1, and d2) The electron pitch angle distributions for two energy ranges. (e1 and e2) The electron flux anisotropy.
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)
<fig-artemyevKineticNatureSolar2019-fig3>


Complementary statistical work by #cite(<artemyevKineticPropertiesSolar2019>, form: "prose") using ARTEMIS data revealed that ion-scale discontinuities are accompanied by density and temperature variations extending over tens of ion inertial lengths. The inversely correlated density and temperature variations suggest a nearly force-free configuration. These structures exhibit two characteristic spatial scales: an intense inner current layer (\> 1 nA/m²) enveloped by a broader outer structure. The magnetic field rotation occurs at the outer scale, while plasma pressure gradients provide pressure balance at the inner scale. The electron kinetic behavior around these structures is strongly energy-dependent: near-thermal electrons (10--30 eV) exhibit significant pitch-angle changes across the discontinuity, whereas hot electrons (100--1000 eV) retain their distribution properties on both sides, suggesting they can cross the structure freely.

Further insight into the kinetic nature of current sheets was provided by #cite(<artemyevIonNongyrotropySolar2020>, form: "prose"). Rotational discontinuities are typically accompanied by velocity jumps $Delta v_l$ that are systematically smaller than the corresponding Alfvén speed jumps $Delta v_A$, contrary to the stationary MHD prediction of equality. Previous explanations invoked either pressure anisotropy reducing $Delta v_A$ or non-stationarity from residual magnetic energy. #cite(<artemyevIonNongyrotropySolar2020>, form: "prose") proposed an alternative: nonadiabatic ion interactions with intense thin discontinuities produce nongyrotropic ion distributions with a nondiagonal pressure tensor component whose cross-discontinuity gradient reduces $Delta v_A$. ARTEMIS observations confirmed the existence of such an ion population with sufficient amplitude and spatial profile to account for the discrepancy, demonstrating that ion kinetic effects fundamentally shape the internal structure of solar wind current sheets.

Consequently, investigating the formation, evolution, and particle interactions of current sheets requires moving beyond MHD theory and into the realm of ion and electron kinetics.

== Analysis Methods: Normal Determination and the Planar Approximation
<analysis-methods-normal-determination-and-the-planar-approximation>
Solar wind current sheets are commonly approximated as one-dimensional structures in which the dominant variation occurs along the direction normal to the sheet. Under this approximation, the most important spatial parameter is the thickness---the scale over which the magnetic field rotates across the structure. Estimating the thickness requires knowledge of the current sheet normal, and the accuracy of this estimate depends critically on the method used to determine it.
A detailed treatment and comprehensive review of both single-spacecraft and multi-spacecraft analysis techniques can be found in #cite(<knetterNewPerspectiveSolar2005>, form: "prose"). In this section, we do not attempt to reproduce that earlier review. Instead, we focus on developments that have emerged since then.

=== Single-Spacecraft Methods
<single-spacecraft-methods>
For single-spacecraft observations, two methods are most widely used. The first is minimum variance analysis (MVA) of the magnetic field, based on the continuity of the normal component of the magnetic field. This method identifies the direction of minimum magnetic field variance in the transition layer and interprets it as the sheet normal @sonnerupMagnetopauseStructureAttitude1967@sonnerupMinimumMaximumVariance1998. The second is the cross-product method, which estimates the normal from the cross product of the upstream and downstream magnetic field vectors @burlagaTangentialDiscontinuitiesSolar1969@wangSolarWindCurrent2024.

MVA has been the dominant technique in the literature, and much of the global statistical picture of solar wind discontinuities has been built upon it. A key advantage of MVA is that it makes no a priori assumption about the magnetic field geometry---it can in principle recover the normal direction for both TDs and RDs. The method is designed to handle realistic deviations from an ideal one-dimensional layer---including 2D or 3D internal structure, temporal fluctuations in normal orientation, and measurement uncertainties---provided there is no systematic change in the normal direction during the spacecraft traversal @sonnerupMinimumMaximumVariance1998. In practice, however, these non-ideal effects can be severe enough to cause MVA to fail. Systematic comparisons with multi-spacecraft determinations have revealed that MVA can be inaccurate for solar wind current sheets. #cite(<horburyThreeSpacecraftObservations2001>, form: "prose"), using three-spacecraft timing with Geotail, Wind, and IMP-8, found that many MVA normal estimates lie far from the timing-derived normals. In their dataset, 77% of events were likely TDs based on timing, yet single-spacecraft MVA would have classified a much larger fraction as RDs---a discrepancy they attributed partly to surface waves on the discontinuities (which may cause the minimum variance directions approximately perpendicular to discontinuity normals).

The nature of these MVA failures has been clarified by subsequent work. #cite(<tehLocalStructureDirectional2011>, form: "prose"), applying Grad--Shafranov reconstruction (based on the ideal 2D MHD equations in steady state) to Cluster observations, showed that internal structures such as magnetic islands (flux ropes) within the transition layer can cause MVA to fail as a predictor of the normal direction. Since MVA assumes a planar, one-dimensional geometry, any two-dimensional substructure may shift the minimum variance direction away from the true normal. (Good agreement with timing methods can be achieved by imposing the additional constraint $chevron.l B_N chevron.r = 0$ on MVA.) #cite(<liuFailuresMinimumVariance2023>, form: "prose") conducted a comprehensive statistical assessment using 6,752 Cluster discontinuities with timing-derived normals as a benchmark. They found that while increasing the eigenvalue ratio $lambda_2 \/ lambda_3$ and narrowing the analysis window can reduce scatter, MVA suffers from an inherent geometric defect: discontinuities with small normal magnetic field component ($\| B_N \| \/ \| B \| < 0.2$) and small magnitude change ($Delta \| B \| \/ \| B \| < 0.05$) are systematically misidentified. In these cases, MVA confuses the dominant in-plane magnetic field component with the normal component, producing a spurious large $\| B_N \|$ and an apparent in-plane rotation angle of $tilde.op 180 degree$. This mechanism causes genuine TDs and EDs to be misclassified as RDs with dominant normal fields, explaining the false RD predominance reported in many earlier MVA-based studies. Despite these limitations, #cite(<liuFailuresMinimumVariance2023>, form: "prose") showed that MVA can achieve acceptable accuracy under favorable geometric conditions. Since the magnitude change $Delta \| B \| \/ \| B \|$ and the rotation angle $omega$ do not depend on knowledge of the normal and are known a priori, they can serve as pre-selection criteria: MVA errors remain generally below $30 degree$ when either $Delta \| B \| \/ \| B \| > 0.05$ or $omega > 60 degree$. The problematic population is therefore confined to small-angle, nearly constant-magnitude current sheets.

The cross-product method, by contrast, has been shown to perform substantially better in accuracy. #cite(<wangSolarWindCurrent2024>, form: "prose"), comparing single-spacecraft estimates against four-spacecraft Cluster timing for 1,831 current sheets, demonstrated that the cross-product normal agrees with the timing normal to within $15 degree$ at the 90% confidence level, whereas MVA normals frequently deviate by more than $60 degree$---likely due to contamination by #emph[anisotropic] turbulent fluctuations. Combined with the Taylor frozen-in hypothesis (validated by the finding that current sheet propagation velocities agree with local ion flow velocities within \~20%), the cross-product method delivers current sheet thickness and current density amplitude within 20% of their multi-spacecraft values at the 90% confidence level. However, the cross-product method has an important limitation: it assumes a vanishing normal magnetic field component ($B_N = 0$), which is strictly valid only for tangential discontinuities. For structures with a significant normal field component, the cross product of the boundary fields does not coincide with the true normal. In practice, this limitation is mitigated by the observational finding that the vast majority of kinetic-scale current sheets have very small $\| B_N \| \/ \| B \|$ @erdosDensityDiscontinuitiesHeliosphere2008@wangSolarWindCurrent2024, making the assumption a good approximation for the bulk of the population. This single-spacecraft methodology has been widely adopted in recent statistical studies of kinetic-scale current sheets @vaskoKineticscaleCurrentSheets2021@vaskoKineticscaleCurrentSheets2022@lotekarKineticscaleCurrentSheets2022@vaskoKineticScaleCurrentSheets2024.

#cite(<erdosDensityDiscontinuitiesHeliosphere2008>, form: "prose") reached a partially reconciling conclusion from the Ulysses dataset: for the subset of well-defined discontinuities with reliable normals, MVA and the cross-product technique yield consistent results. They advocated retaining only such well-defined events for further analysis, noting that the vast majority of these have a small magnetic field component parallel to the normal. The practical implication is that MVA can be used reliably when applied with appropriate quality filters, but uncritical application to the full population of discontinuities introduces systematic biases that have historically distorted the statistical picture---particularly the RD/TD classification.

==== Multi-Spacecraft Methods and Higher-Dimensional Structure
<multi-spacecraft-methods-and-higher-dimensional-structure>
Multi-spacecraft observations have played a crucial role in advancing our understanding of current sheets, as they allow improved determination of the normal direction and direct separation of spatial structure from temporal evolution @knetterNewPerspectiveSolar2005@knetterFourpointDiscontinuityObservations2004@knetterDiscontinuityObservationsCluster2003@horburyThreeSpacecraftObservations2001@nessSimultaneousMeasurementsInterplanetary1966. The timing method compares the arrival times of the same structure at several spacecraft with known relative positions, enabling geometric inference of the sheet orientation and propagation velocity @vogtAnalysisDataMultisatellite2020@paschmannMultispacecraftAnalysisMethods2008@knetterNewPerspectiveSolar2005@paschmannAnalysisMethodsMultispacecraft2000. Missions such as Cluster and MMS have greatly expanded the use of these techniques.

Beyond providing more accurate normals, multi-spacecraft observations have revealed that many solar wind current sheets are not perfectly planar. #cite(<leppingTwodimensionalCurvatureLarge2003>, form: "prose"), using Wind and IMP-8 data for 134 large-angle ($omega > 90 degree$) discontinuities, estimated a weighted-average radius of curvature of $tilde.op 380 thin R_E$ (with a most probable value of $tilde.op 290 thin R_E$\; however, their analysis is unable to distinguish real curvature from shorter-scale surface variations using only two-spacecraft data sets), and an average thickness of $tilde.op 14 thin R_E$ (most probable $tilde.op 6 thin R_E$). These results caution against the simplistic use of the planar assumption when projecting a distantly observed discontinuity to predict its arrival characteristics at a downstream location. #cite(<malaspinaTwoSpacecraftObservations2012>, form: "prose"), exploiting the variable separation of the twin STEREO spacecraft, studied tens of thousands of discontinuities and found that the distributions of thickness, normal orientation, shear angle, and waiting times differ systematically between discontinuities observed by both spacecraft and those seen by only one. The population observed by both spacecraft---those with sufficient lateral extent to be intercepted at two separated points---was most consistently interpreted as the walls of solar wind flux tubes.

#cite(<sodingMinimumVarianceAnalysis1999>, form: "prose") proposed a method to determine the orientation and propagation velocity of two-dimensional structures using two-spacecraft data under the assumption of a steady-state, divergence-free magnetic field. While no clear 2D structures were identified on the \~10-hour scales examined with Wind and IMP-8, the method established a framework for probing departures from planarity at smaller scales. #cite(<tehLocalStructureDirectional2011>, form: "prose") subsequently demonstrated with Grad--Shafranov reconstruction that directional discontinuities can contain internal magnetic islands, making them irreducible to simple TD or RD classifications and underscoring the importance of accounting for multidimensional geometry when interpreting spacecraft crossings.

== Statistical surveys and identification methods
<statistical-surveys-and-identification-methods>
Following the initial discovery of solar wind current sheets, research shifted toward systematic statistical surveys. This section reviews general statistical properties and the methods used to identify current sheets. Parameters central to understanding both their physical nature and their dynamical influence on energetic particles --- magnetic field configuration, spatial scale #ref(<sec-scale_density>, supplement: [Section]), and occurrence rate #ref(<sec-occurrence-rate>, supplement: [Section]) --- are discussed in the subsequent sections.

A key point that must be emphasized at the outset is that statistical properties depend critically on the identification method. Different selection criteria---thresholds on magnetic field rotation angle, magnetic field increments, partial variance of increments (PVI), or relative standard deviation---introduce systematic biases into the sampled population. Methods optimized for large-amplitude, well-defined discontinuities preferentially select broader, MHD-scale structures, whereas gradient-based or increment-based approaches are more sensitive to thinner, kinetic-scale current sheets. Reported distributions of thickness, current density, and occurrence rate are therefore inherently method-dependent, and care must be taken when comparing results across studies.

To process the vast amounts of spacecraft data, various automated identification algorithms have been developed. #ref(<tbl-identification-methods>, supplement: [Table]) summarizes the primary quantitative criteria utilized in the literature.

#figure([
#table(
  columns: (15.69%, 23.53%, 33.33%, 27.45%),
  align: (auto,auto,auto,auto,),
  table.header([Method], [Description], [Method Reference], [Applications],),
  table.hline(),
  [Directional change], [Change in the direction of #strong[B]], [#cite(<burlagaDirectionalDiscontinuitiesInterplanetary1969>, form: "prose")], [#cite(<sodingRadialLatitudinalDependencies2001>, form: "prose")],
  [Relative field change], [Relative change in magnetic field #strong[B]], [#cite(<tsurutaniInterplanetaryDiscontinuitiesTemporal1979>, form: "prose")], [#cite(<sodingRadialLatitudinalDependencies2001>, form: "prose")],
  [Correlation / angle distribution], [Two-time correlation functions and distribution of angle change over a time lag], [#cite(<liIdentifyingCurrentSheetlikeStructures2007>, form: "prose")], [#cite(<liAreThereCurrentsheetlike2008>, form: "prose")],
  [PVI], [Partial Variance of Increments], [#cite(<grecoPartialVarianceIncrements2017>, form: "prose")], [#cite(<vaskoKineticscaleCurrentSheets2021>, form: "prose")\; #cite(<vaskoKineticscaleCurrentSheets2022>, form: "prose")\; #cite(<vaskoKineticScaleCurrentSheets2024>, form: "prose")],
  [Relative standard deviation], [Relative standard deviation of #strong[B]], [#cite(<liuMagneticDiscontinuitiesSolar2022>, form: "prose")], [#cite(<zhangSolarWindDiscontinuities2025a>, form: "prose")],
)
], caption: figure.caption(
position: top, 
[
Summary of current sheet identification methods used in the literature.
]), 
kind: "quarto-float-tbl", 
supplement: "Table", 
)
<tbl-identification-methods>


Most early statistical studies focused on large-scale or mesoscale current sheets that are readily identifiable in lower-cadence data. While these works provide essential context, their results cannot be directly compared with statistics derived from high-cadence measurements targeting kinetic-scale structures. Differences in scale selection, detection thresholds, and instrumental resolution introduce subtleties that must be carefully navigated. For instance, as demonstrated by #cite(<vasquezNumerousSmallMagnetic2007>, form: "prose"), current sheets become exponentially more numerous at smaller spread angles, a population often missed by earlier methods which focus on isolated, large-angle events and exclude structures in close proximity to one another. Therefore, while prior studies inform the broader landscape, the results presented in this thesis pertain specifically to the kinetic-scale population and should be interpreted within the framework of the identification methodology employed herein.

=== Small Intensity jump, Δ|B|
<small-intensity-jump-δb>
While it is possible for a current sheet to exhibit a large jump in magnetic field magnitude, the vast majority are predominantly characterized by a rotation of the magnetic field across the sheet, with the magnitude remaining nearly constant. This was first recognized by #cite(<burlagaDirectionalDiscontinuitiesInterplanetary1969>, form: "prose"), who observed that most sharp changes in the IMF are primarily directional and introduced the term #emph[directional discontinuity] (DD). Quantitatively, the change in $\| B \|$ is less than 20% for approximately 75% of the discontinuities in their study.

More recent high-resolution analyses confirm this near-constant magnitude at smaller scales. Using 1/3-second resolution ACE data, #cite(<vasquezNumerousSmallMagnetic2007>, form: "prose") found that most discontinuities have ramp-like internal profiles---the field varies nearly monotonically within the layer, with no evidence of rapid compression or dissipation @tsurutaniRapidEvolutionMagnetic2005. Furthermore, the intensity jump distribution for solar wind discontinuities is best fit with a lognormal function and is narrowly confined about unity, in contrast to the much broader distribution found in phase-randomized surrogate fields. This difference implies that the layer is regulated by specific physical processes (e.g., nonlinear wave magnetic pressure and Landau damping) rather than random superposition of fluctuations.

This conclusion is further reinforced by #cite(<lotekarKineticscaleCurrentSheets2022>, form: "prose") and #cite(<vaskoKineticScaleCurrentSheets2024>, form: "prose"), who analyzed 11200 proton kinetic-scale current sheets near the sun By Parker Solar Probe and 16903 current sheets at 5 AU observed by Ulysses. The magnetic field rotates through a shear angle with only weak magnitude variation. The maximum variation of $\| B \|$ within a current sheet is statistically larger than the variation between its boundaries, and larger magnitude variations are typical at higher plasma $beta$ (#ref(<fig-vasko2024-fig4>, supplement: [Figure])).

#figure([
#box(image("figures/ref/vaskoKineticScaleCurrentSheets2024-fig4.png"))
], caption: figure.caption(
position: bottom, 
[
Probability and cumulative distributions of parameters $Delta B \/ 〈 B 〉$, $Delta B_max \/ 〈 B 〉$ and $Delta B \/ 〈 B 〉 Delta theta$ for subsets of the current sheets (CSs) observed at different plasma betas, β \< 1 and β \> 3. The bottom panels also present the cumulative distributions corresponding to all the CSs in our data set. Note that parameter $Delta B \/ 〈 B 〉 Delta theta$ quantifies the ratio between average perpendicular and parallel current densities within CS.
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)
<fig-vasko2024-fig4>


=== Field Rotation Angle
<field-rotation-angle>
The field rotation angle $omega$ (also referred to as the spread angle, shear angle, or directional change) is one of the most fundamental parameters characterizing current sheets. Its distribution depends on the statistical ensemble (i.e., the identification criteria), solar activity level, radial distance from the Sun, and the type of discontinuity. A robust finding across all studies is that discontinuities become more abundant at smaller spread angles.

#cite(<burlagaDirectionalDiscontinuitiesInterplanetary1969>, form: "prose") first showed that the number of discontinuities falls off rapidly with increasing $omega$. Subsequent studies confirmed this behavior and characterized the distribution quantitatively \[#cite(<burlagaHydromagneticWavesDiscontinuities1971>, form: "prose")\; #cite(<burlagaNatureOriginDirectional1971>, form: "prose") #cite(<marianiVariationsOccurrenceRate1973>, form: "prose")\;\]. For $omega gt.eq 30 degree$, the distribution is well described by $N \( omega \) prop exp [- (omega / omega_s)^2]$, where the scale parameter $omega_s$ encodes the characteristic width of the distribution. #cite(<burlagaDirectionalDiscontinuitiesInterplanetary1969>, form: "prose") found $omega_s = 75 degree$ during a solar minimum period (December 1965--January 1966), while #cite(<marianiVariationsOccurrenceRate1973>, form: "prose") obtained a significantly smaller $omega_s = 44 degree$ during a period of higher solar activity. This difference likely reflects a dependence on solar cycle phase @marianiVariationsOccurrenceRate1973. #cite(<knetterNewPerspectiveSolar2005>, form: "prose"), using our coordinated spacecraft (Cluster) for four different periods between 2001 and 2003, further demonstrated that $omega$ depends on solar wind type: the spread angle tends to be smaller in slow solar wind from active regions and larger in fast solar wind originating from coronal holes.

Extending the analysis to small rotation angles, #cite(<vasquezNumerousSmallMagnetic2007>, form: "prose") showed that the small-spread-angle population forms a smooth continuation of the larger-angle distribution, which is best fit by a #emph[lognormal] function. For most discontinuities, the maximum spread angle within the layer is nearly equal to the net edge-to-edge value, confirming that the field rotation is approximately monotonic across the structure. This finding was subsequently cited by #cite(<neugebauerProgressStudyInterplanetary2010>, form: "prose") as evidence that the method of #cite(<vasquezNumerousSmallMagnetic2007>, form: "prose") captures a previously unexamined but physically continuous population.

A radial dependence of $omega_s$ was established by #cite(<sodingRadialLatitudinalDependencies2001>, form: "prose"), who found that the distribution steepens with increasing heliocentric distance: $omega_s$ decreases from \~82° to \~50° between the inner heliosphere and several AU (see #ref(<fig-soding2001-fig11>, supplement: [Figure])). Fewer events with $omega > 60 degree$ are observed at larger distances, indicating that discontinuities evolve during their outward propagation. Whether this evolution leads to eventual annihilation of current sheets remains unclear. Notably, the radial dependence of $omega_s$ differs depending on the identification criterion: it is present for the Tsurutani--Smith (TS) criterion but absent for the Burlaga (B) criterion inside 2.3 AU, suggesting that the evolution is driven by the additionally identified population of anisotropic RDs. For TDs alone, the mean rotation angle $chevron.l omega chevron.r approx 78 degree$ shows no radial dependence, whereas for RDs, smaller $omega$ is more probable and fewer large-$omega$ events survive at greater distances.

#figure([
#box(image("figures/ref/sodingRadialLatitudinalDependencies2001-fig11.png"))
], caption: figure.caption(
position: bottom, 
[
Relative frequency of $omega$ for Helios 2 (top) and Voyager 2 (bottom) as a histogram; thin solid line is a fit to the distribution proportional to $exp [- (omega / omega_s)^2]$
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)
<fig-soding2001-fig11>


=== Occurrence rate
<sec-occurrence-rate>
The occurrence rate of current sheets is important from both plasma-physics and particle-transport perspectives. From the standpoint of solar wind physics, occurrence statistics constrain the generation mechanisms of current sheets---including their relation to turbulence intermittency, flux-tube boundaries, and large-scale solar wind structuring---and provide information about their stability and evolution during outward propagation. From the standpoint of energetic particle transport, the frequency with which particles encounter current sheets determines the cumulative scattering rate and therefore influences large-scale diffusion properties in both momentum and configuration space.

A central question is whether current sheets are formed close to the Sun and subsequently convected outward by the solar wind, or whether they are generated in situ at all heliocentric distances, for example in colliding solar wind streams. As summarized by #cite(<knetterDiscontinuityObservationsCluster2003>, form: "prose"), early radial surveys spanning approximately 0.3 to 10 AU consistently reported a decrease in occurrence rate with increasing radial distance. However, interpreting this trend is not straightforward. The observed decrease may indicate genuine disintegration of current sheets during their outward propagation. Alternatively, it could reflect a changing balance between local generation and destruction processes. It may also arise from observational effects: as structures evolve, their orientation relative to the radial direction may change, reducing the locally detected occurrence rate. In addition, current sheets may thicken with increasing distance, causing them to fall below instrumental detection thresholds and thereby introducing an observational bias @leppingMagneticFieldDirectional1986.

The earliest radial studies established the basic phenomenology. #cite(<burlagaNatureOriginDirectional1971>, form: "prose"), using Pioneer 6 data, found that the occurrence rate at 0.82 AU is only slightly lower than at 1 AU ("this may be due to the lower data quality and increase in the number of data gaps when the spacecraft is far from the earth"), and that the distributions of rotation angle and discontinuity normals are very similar across the range 0.8--1.0 AU. This suggested that most discontinuities originate inside 0.8 AU and do not evolve appreciably over this distance range. Importantly, the occurrence rate in regions of increasing bulk speed was only slightly higher than elsewhere, arguing against stream collision as the primary generation mechanism. #cite(<marianiVariationsOccurrenceRate1973>, form: "prose"), analyzing over 16,000 events from Pioneer 8, reported an average occurrence rate of approximately 3.6 per hour near 1 AU (with \~1.6 per hour identified as TD-like) and found a correlation with the directional change $omega$ and a decrease with increasing heliocentric distance. However, they also noted a possible dependence on heliographic latitude.

#cite(<tsurutaniInterplanetaryDiscontinuitiesTemporal1979>, form: "prose") made a major contribution by using simultaneous Pioneer 10 and 11 data to separate spatial from temporal variations. This distinction was essential, as occurrence rates display substantial day-to-day and solar-rotation-scale fluctuations well outside #emph[Poisson] expectations. They found that the rates averaged over Bartels rotations were strongly correlated between the two spacecraft despite their \~2 AU separation, and that the statistical properties of discontinuities at 1 and 5 AU were remarkably similar. Both findings support a scenario in which discontinuities originate within 1 AU and are subsequently convected outward by the solar wind. The radial dependence of the occurrence rate follows $rho = 50 thin e^(- \( R - 1 \) \/ 4)$ per day, corresponding to an apparent decrease of about 25% per AU. However, they argued that this radial gradient may not represent true physical decay: it could arise from progressive thickening of current sheets such that they no longer satisfy identification criteria. Finally, they demonstrated that temporal variations, persisting over several months, had likely been misinterpreted as latitudinal gradients in earlier Pioneer 8 results @marianiVariationsOccurrenceRate1973.

The picture was enriched by Ulysses observations at high heliographic latitudes. #cite(<tsurutaniInterplanetaryDiscontinuitiesAlfven1996>, form: "prose") found a radial decrease from 1 to 5 AU following $e^(- \( r - 1 \) \/ 5)$. More strikingly, the occurrence rate increased by a factor of \~5 as Ulysses moved from Jupiter at 5 AU to 2.5 AU over the south pole (from the ecliptic plane to −80° heliographic latitudes), with a one-to-one correspondence between high occurrence rates and high-speed streams from coronal holes. In these streams, nonlinear outward-propagating Alfvén waves with large transverse fluctuations are ubiquitous, and rotational discontinuities frequently form the edges of phase-steepened Alfvén waves---offering a natural explanation for the elevated occurrence rates.

#cite(<sodingRadialLatitudinalDependencies2001>, form: "prose") synthesized data from five missions spanning 0.3--19 AU and $- 80 degree$ to $+ 10 degree$ latitude during solar minimum. They found that the occurrence rate depends linearly on solar wind velocity (a geometric effect: faster wind sweeps more plasma volume past the spacecraft per unit time) and decreases radially as $r^(- 0.78)$ (TS criterion) or $r^(- 1.28)$ (B criterion). After normalizing to 400 km/s and 1 AU, approximately 64 discontinuities per day were identified with both criteria, and no residual dependence on heliographic latitude or solar wind structure type was observed---indicating that current sheets are uniformly distributed on spherical shells. Nonetheless, large day-to-day variations persisted even after normalization. The RD-to-TD ratio depended on solar wind structure, with relatively more RDs in high-speed streams, but showed no radial or latitudinal dependence in the inner heliosphere ($r < 10$ AU).

#cite(<vasquezNumerousSmallMagnetic2007>, form: "prose"), using their method sensitive to small-spread-angle events, found dramatically higher rates than earlier surveys: an average exceeding 243 per day for all discontinuities, 117 per day above $15 degree$, and 52 per day above $30 degree$ (comparable to the \~30 per day above $30 degree$ reported by classical methods). These rates exhibit pronounced temporal variability on both daily and hourly timescales, and discontinuities occur in spatial groupings with #emph[lognormally] distributed separations. Even excluding active periods (interplanetary shocks, solar ejections), the rates were only weakly correlated with solar wind speed.

A methodological subtlety that pervades all occurrence rate studies was highlighted by #cite(<erdosDensityDiscontinuitiesHeliosphere2008>, form: "prose"), who used the extensive Ulysses magnetometer dataset to critically examine the role of the identification method. They showed in #ref(<fig-erdos2008-fig4>, supplement: [Figure]) that occurrence rates differ dramatically depending on whether events are selected by their temporal rate of change (in the spacecraft frame) or by their spatial gradient (transformed into the solar wind frame): the temporal criterion systematically overestimates the number of discontinuities in fast solar wind, because structures convect more rapidly past the observer. After correcting for this bias, they confirmed the radial decrease in spatial density with increasing distance from the Sun. And surprisingly, they found that at a given radial distance, periods with slower solar wind tended to contain more discontinuities.

#figure([
#box(image("figures/ref/erdosDensityDiscontinuitiesHeliosphere2008-fig4.png"))
], caption: figure.caption(
position: bottom, 
[
The number of discontinuities as a function of the distance from the Sun (horizontal scale) and the velocity of solar wind (color coded). Upper panel: selection of events by time rate of change. Lower panel: selection of events by spatial gradients.
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)
<fig-erdos2008-fig4>


Recent inner-heliosphere measurements from Parker Solar Probe and Solar Orbiter have extended these statistics closer to the Sun than previously possible. #cite(<liuCharacteristicsInterplanetaryDiscontinuities2021>, form: "prose") analyzed 3,948 discontinuities between 0.13 and 0.9 AU and found a steep radial decrease following $r^(- 2.00)$. A particularly interesting finding was that the RD occurrence rate decreases more steeply ($r^(- 2.17)$) than the TD rate, so that the RD-to-TD ratio drops sharply from \~8 at $r < 0.3$ AU to \~1 at $r > 0.4$ AU, exhibiting distinct evolution with distance.

#cite(<madarDirectionalDiscontinuitiesInner2024>, form: "prose"), combining Solar Orbiter and Parker Solar Probe data, identified over 140,000 discontinuities between 0.06 and 1.01 AU and confirmed the power-law decrease in spatial density, fitting an exponent of $- 0.93$---somewhat shallower than the $r^(- 2.00)$ of #cite(<liuCharacteristicsInterplanetaryDiscontinuities2021>, form: "prose"), likely reflecting differences in identification criteria and the correction for solar wind velocity effects. They identified several competing mechanisms that shape the radial profile: the increasing Parker spiral angle with distance affects how many TD-like flux-tube boundaries are swept past the spacecraft; the smaller cross-section of flux tubes near the Sun makes boundary crossings more probable; and any radial evolution of current sheet thickness introduces selection biases for gradient-based detection methods.

Taken together, these studies establish that current sheet occurrence rates decrease with heliocentric distance, but the precise radial scaling depends sensitively on identification criteria and the population of discontinuity types sampled with corrections for solar wind velocity effects. The much higher rates found by methods sensitive to small rotation angles @vasquezNumerousSmallMagnetic2007 underscore that the total population of current sheets is substantially larger than suggested by classical surveys restricted to large-angle events. The differential radial evolution of RDs and TDs points to fundamentally different origins and lifetimes for these two populations---a distinction with direct implications for understanding how they are generated and sustained by solar wind turbulence.

=== Spatial Scale and Current Density
<sec-scale_density>
In the classical MHD framework, current sheets are treated as infinitely thin discontinuities---mathematical step functions across which plasma parameters change instantaneously. In reality, however, the transition between upstream and downstream regions occurs over a finite thickness, requiring a treatment beyond the MHD approximation. The impact of a current sheet on the plasma --- and specifically on the dynamical process of particles within the sheet @yamadaMagneticReconnection2010 --- is fundamentally governed by this spatial scale @sergeevCurrentSheetThickness1990 and the associated internal current density (the ratio between gyroradius and the characteristic scale of magnetic inhomogeneity). These two closely coupled parameters (usually compared to local proton inertial length and Alfvén current density) dictate the transition from fluid-like MHD behavior to kinetic physics and are therefore central to understanding the role of current sheets in both turbulence dissipation and particle transport.

The thickness of a current sheet determines the physical regime in which the structure operates. The critical threshold occurs when the thickness approaches fundamental kinetic length scales: the ion inertial length $d_i = c \/ omega_(p i)$ or the thermal ion gyroradius $rho_i$. When $lambda tilde.op rho_i$, the assumptions of ideal MHD break down: ions become demagnetized within the sheet while electrons---with their much smaller gyroradius---remain magnetized. Test particle simulations reveal the kinetic consequences of this intermittent structure: #cite(<dmitrukTestParticleEnergization2004>, form: "prose") found that the current sheets spontaneously formed by MHD turbulence produce differential energization, with electrons developing large parallel velocities within current sheets while protons are energized preferentially in the perpendicular direction by nonuniform electric fields varying on proton kinetic scales. This differential response generates Hall electric fields and enables the onset of collisionless magnetic reconnection, which requires current sheet thicknesses comparable to $d_i$ to proceed at sufficiently fast rates. #cite(<cassakModelSpontaneousOnset2006>, form: "prose") showed that as a Sweet--Parker dissipation region dynamically thins during reconnection, a critical transition occurs when its width drops below $d_i$: the Hall effect becomes dominant, the resistive MHD solution ceases to exist, and the system transitions abruptly to fast collisionless reconnection with rates orders of magnitude higher. #cite(<papiniFastMagneticReconnection2019>, form: "prose") extended this picture by investigating the tearing instability in both the MHD and Hall-MHD regimes. They showed that when a current sheet achieves a sufficiently small aspect ratio ($a \/ L tilde.op S^(- 1 \/ 3)$ for Lundquist number $S gt.double 1$), reconnection proceeds on ideal Alfvén timescales independent of $S$. In the nonlinear phase, secondary current sheets spontaneously form and, at high $S$, naturally adjust to this critical aspect ratio, driving very rapid reconnection. When the Hall term is included---appropriate once the resistive layer width $delta$ becomes comparable to $d_i$---the secondary reconnection rate is enhanced by up to a factor of two relative to the pure MHD case and up to ten times faster than the linear phase, leading to explosive energy release on super-Alfvénic timescales.

The interplay between reconnection and the turbulent cascade is now recognized as fundamental @boldyrevTearingInstabilityAlfven2020@boldyrevRoleReconnectionInertial2019. In dynamically aligned Alfvénic turbulence, magnetic fluctuations naturally form progressively thinner sheet-like structures at smaller scales @boldyrevSpectrumMagnetohydrodynamicTurbulence2006. Analytic theories predict that below a critical thickness these sheets become tearing-unstable, disrupting the classical cascade. #cite(<malletDisruptionAlfvenicTurbulence2017>, form: "prose") calculated the disruption scale $lambda_D$ at which this onset occurs in a low-$beta$ collisionless plasma, showing that $lambda_D$ can exceed the ion sound scale $rho_s$ and produce a spectral break at $lambda_D$ rather than at $rho_s$, with a steepened "transition range" between them---a feature sometimes observed in solar wind turbulence intervals. #cite(<boldyrevMagnetohydrodynamicTurbulenceMediated2017>, form: "prose") proposed a complementary picture in which the tearing instability modifies the effective alignment of field lines, balancing the eddy turnover rate at all scales below the critical threshold and yielding a reconnection-mediated energy spectrum steeper than the classical prediction. These theoretical expectations have been confirmed numerically. #cite(<dongRolePlasmoidInstability2018>, form: "prose"), in high-resolution 2D MHD simulations at magnetic Reynolds number $R_m = 10^6$, showed that the combined effects of dynamic alignment and turbulent intermittency produce copious plasmoid formation in intense current sheets; the resulting disruption steepens the energy spectrum toward a spectral index near $- 2.2$, consistent with the analytic predictions. #cite(<dongReconnectiondrivenEnergyCascade2022>, form: "prose") extended this to three dimensions, demonstrating that rapid reconnection breaks elongated current sheets into chains of plasmoids and opens a previously unrecognized range of energy cascade in which the transfer rate is controlled by plasmoid growth, again producing a $- 2.2$ spectral index accompanied by modified turbulence anisotropy. #cite(<franciMagneticReconnectionDriver2017>, form: "prose"), using high-resolution hybrid-kinetic simulations that retain ion kinetic effects, provided further confirmation: reconnection at current sheets with $a tilde.eq d_i$ actively drives the sub-ion-scale cascade, generating a stable power-law spectrum below the ion break as soon as the first reconnection events occur---regardless of the state of the large-scale cascade. Taken together, these results establish that current sheets at kinetic scales actively shape the turbulence spectrum, mediate the energy cascade across the ion break, and control the pathway by which magnetic energy is ultimately converted into particle heating.

For energetic particle transport, the spatial scale is equally decisive. When particles encounter a broad MHD-scale structure ($lambda gt.double rho_(upright(S E P))$), their motion remains adiabatic and they smoothly follow guiding-center trajectories. When $lambda tilde.op rho_(upright(S E P))$, however, the magnetic field changes too abruptly for adiabaticity to be maintained, leading to strong pitch-angle scattering, temporary trapping, or reflection. The implications of this resonance condition for SEP transport will be examined in detail in the following sections.

Current density is inextricably linked to spatial scale through Ampère's law: $upright(bold(J)) = nabla times upright(bold(B)) \/ mu_0$. A thin magnetic field rotation necessarily implies an intense current layer. In the context of magnetic turbulence, the energy cascading from large to small scales is not dissipated uniformly but is concentrated within coherent structures---predominantly thin, high-current-density sheets. Numerical simulations have quantified this intermittency in detail. #cite(<zhdankinStatisticalAnalysisCurrent2013>, form: "prose"), analyzing current sheets in driven reduced-MHD turbulence, found that structures with peak current density exceeding eight times the rms value occupy less than 1% of the simulation volume yet account for more than 25% of all Ohmic dissipation. They also showed that while not all intense current sheets contain magnetic X-points (about 55% do not), the most intense structures are preferentially reconnecting ones, with the probability of containing an X-point rising to \~90% for the strongest events.

Spacecraft observations corroborate this picture. Current sheets are correlated with enhanced electron and ion temperatures @osmanEvidenceInhomogeneousHeating2011, and these structures, while constituting only \~19% of the data, can account for \~50% of the total plasma internal energy @osmanIntermittencyLocalHeating2012. If reconnection is triggered within an intense current sheet, the contracting magnetic islands can further accelerate particles to high energies. Recent Parker Solar Probe observations have provided direct evidence of proton acceleration up to \~400 keV within the reconnection exhaust of the heliospheric current sheet at \~16 $R_dot.circle$ @desaiMagneticReconnectionDriven2025.

Understanding how thickness and current density of current sheets evolve with heliocentric distance is therefore crucial for revealing their role in the thermodynamics of solar wind turbulence and dynamics of energetic paticles: whether these structures maintain their kinetic-scale character and whether their current density weakens in tandem with the radial drop in magnetic field constrains theories of their local generation, evolution, and overall contribution to energy dissipation and particle transport throughout the heliosphere.

==== Thickness
<thickness>
The earliest thickness estimates, necessarily limited by instrumental resolution, revealed structures with spatial scales of thousands of kilometers or tens of proton inertial lengths @burlagaDirectionalDiscontinuitiesInterplanetary1969.

The radial evolution of current sheet thickness was first systematically studied by #cite(<sodingRadialLatitudinalDependencies2001>, form: "prose"), who analyzed discontinuities from five missions spanning 0.3--19 AU. They found that the mean thickness in kilometers increases with heliocentric distance, as expected from the radial decrease in magnetic field strength and the associated expansion of kinetic length scales. However, when normalized to the local proton gyroradius, the thickness decreases dramatically---by a factor of \~50, from $chevron.l d_(rho_g) chevron.r approx 201 thin rho_g$ at 0.3 AU down to $chevron.l d_(rho_g) chevron.r approx 4.3 thin rho_g$ at 19 AU. A similar decrease, from $127 thin d_i$ to $2.6 thin d_i$, was found when normalizing to the ion inertial length. RDs were consistently thicker than TDs by a factor of \~1.5. This strong radial thinning in normalized units indicates that current sheets do not simply expand passively with the solar wind but evolve dynamically, progressively approaching kinetic scales at larger distances.

Parker Solar Probe has extended these measurements into the pristine inner heliosphere. #cite(<liuCharacteristicsInterplanetaryDiscontinuities2021>, form: "prose"), analyzing discontinuities between 0.13 and 0.9 AU, found distinct behavior for the two types: TD thicknesses normalized by $d_i$ show no clear spatial scaling and range broadly from 5--35 $d_i$, whereas RD thicknesses decrease as $r^(- 1.09)$ in normalized units. In absolute terms, the average RD thickness of \~574 km changes little with distance, implying that the normalized thinning reflects the radial increase of $d_i$ itself. #cite(<madarDirectionalDiscontinuitiesInner2024>, form: "prose"), using combined Solar Orbiter and PSP data from 0.06 to 1.01 AU, reported a more nuanced picture: RD thickness first #emph[decreases] between 0.06 and 0.30 AU, then increases beyond 0.30 AU in proportion to the local ion inertial length. TD thickness, by contrast, scales with $d_i$ throughout the entire distance range. The authors interpreted these trends as evidence for different physical origins of the two types of discontinuities. RDs are thought to arise from the nonlinear steepening of Alfvén waves, a process that tends to generate structures with a significant magnetic-field component normal to the discontinuity surface. As the steepening progresses, the characteristic thickness decreases until it approaches ion kinetic scales, where dispersive and kinetic effects limit further steepening. TDs, on the other hand, are more likely associated with boundaries between magnetic flux tubes, whose widths tracks the local kinetic scale.

High-cadence measurements have made it possible to resolve the kinetic-scale population directly. #cite(<vaskoKineticscaleCurrentSheets2022>, form: "prose"), using Wind data at 11 samples/s, characterized 17,043 current sheets at 1 AU with thicknesses from a few tens to \~1,000 km, corresponding to \$$0.1 dash.en 10$,\_p\$ with typical values around 100 km (\~a few $lambda_p$). Near the Sun, #cite(<lotekarKineticscaleCurrentSheets2022>, form: "prose") analyzed 11,200 current sheets around PSP's first perihelion, finding thicknesses from a few to \~200 km (typical value \~30 km), or \$\$0.1--10 $lambda_p$ with a typical value of \~2 $lambda_p$. At 5 AU, #cite(<vaskoKineticScaleCurrentSheets2024>, form: "prose") found half-thicknesses of 200--2,000 km for non-bifurcated current sheets and 500--5,000 km for bifurcated ones, corresponding to 0.5--5 $lambda_p$ and 0.7--15 $lambda_p$ respectively. Despite the enormous difference in absolute scale across these distances, the remarkable consistency in normalized thickness---typically a few proton inertial lengths---indicates that current sheets at all heliocentric distances are predominantly kinetic-scale structures whose width is set by the local plasma conditions.

==== Current Density and Scale-Dependent Properties
<current-density-and-scale-dependent-properties>
The current density within kinetic-scale current sheets is not independent of their spatial scale. #cite(<vaskoKineticscaleCurrentSheets2022>, form: "prose") found at 1 AU that the current density increases systematically for thinner structures, following $J_0 approx 6 #h(0em) upright(n A \/ m^2) dot.op \( lambda \/ 100 #h(0em) upright(k m) \)^(- 0.56)$, but does not statistically exceed a critical value $J_A$ corresponding to an ion-electron drift at the local Alfvén speed. In normalized units, this becomes $J_0 \/ J_A approx 0.17 dot.op \( lambda \/ lambda_p \)^(- 0.51)$. A corresponding power-law correlation was observed near the Sun by #cite(<lotekarKineticscaleCurrentSheets2022>, form: "prose"), who found $J_0 approx 0.15 #h(0em) mu upright(A \/ m^2) dot.op \( lambda \/ 100 #h(0em) upright(k m) \)^(- 0.76)$ with current densities in the range 0.1--10 $mu$A/m², and at 5 AU by #cite(<vaskoKineticScaleCurrentSheets2024>, form: "prose"), who reported $J_0 \/ J_A approx 0.14 dot.op \( lambda \/ lambda_p \)^(- 0.66)$ with typical current densities of 0.05--0.5 nA/m².

These current sheets are statistically force-free: the current density is dominated by its magnetic-field-aligned component, consistent with the observation that $\| B \|$ does not vary substantially across them. The magnetic shear angle is also correlated with spatial scale: #cite(<vaskoKineticscaleCurrentSheets2022>, form: "prose") found $Delta theta approx 19 degree dot.op \( lambda \/ lambda_p \)^0.5$ at 1 AU, while #cite(<vaskoKineticScaleCurrentSheets2024>, form: "prose") found $Delta theta approx 16.6 degree dot.op \( lambda \/ lambda_p \)^0.34$ at 5 AU. These scale-dependent correlations---thinner sheets carrying proportionally stronger currents with smaller shear angles---are a natural consequence of the turbulent cascade, in which magnetic field gradients steepen as energy is transferred to smaller scales. The approximate scale-invariance of these relationships across heliocentric distances (from 0.17 AU to 5 AU), together with the matching of magnetic field rotation and compressibility between current sheets and the ambient turbulence, provides strong evidence that the majority of kinetic-scale current sheets are produced by the turbulent cascade.

The observation that current density does not exceed the Alfvén current density $J_A$ is physically significant but not yet fully understood. From the standpoint of reconnection, #cite(<vaskoKineticscaleCurrentSheets2021>, form: "prose") showed that essentially all 18,785 kinetic-scale current sheets in their dataset satisfy the necessary condition for reconnection not to be suppressed by diamagnetic drift of the X-line. This condition, $Delta beta lt.tilde 2 \( L \/ lambda_p \) tan \( Delta theta \/ 2 \)$, is automatically met due to the geometry of the current sheets as dictated by the turbulent cascade, rather than being a coincidence of local plasma parameters. The same conclusion was reached near the Sun @lotekarKineticscaleCurrentSheets2022 and at 5 AU @vaskoKineticScaleCurrentSheets2024.

=== Alfvénicity, Walén Relation and Propagation Direction
<alfvénicity-walén-relation-and-propagation-direction>
The relationship between velocity and magnetic field variations across current sheets---their degree of Alfvénicity---has been a central and persistently debated topic, bearing directly on the classification of discontinuities as RDs or TDs and on their dynamical role in the solar wind.

The pioneering observation by #cite(<neugebauerAlignmentVelocityField1985>, form: "prose"), using IMP 8 and Voyager 2 data, revealed that velocity and magnetic field jumps ($Delta upright(bold(v))$ and $Delta upright(bold(B)) \/ sqrt(rho)$) across tangential discontinuities (a large change in magnetic field strength) are closely aligned---either parallel or antiparallel---in the sense associated with outward-propagating Alfvén waves. This alignment was found to be independent of solar wind stream structure and heliocentric distance between 1 and 2.2 AU. The result was unexpected for structures classified as TDs, and several explanations were proposed, including interplanetary turbulence, large-amplitude Alfvénic fluctuations propagating independently on both sides of the discontinuity, and surface waves on TDs.

#cite(<neugebauerTangentialDiscontinuitiesSolar1986>, form: "prose") confirmed using Helios data that this alignment is already well established inside 0.4 AU, suggesting it is not a product of in situ evolution but may instead reflect a selection effect: TDs for which $Delta upright(bold(v))$ and $Delta upright(bold(B))$ are not aligned are destroyed by the Kelvin--Helmholtz instability, so that only Alfvénically aligned TDs survive. The observed decrease in the total number of discontinuities with increasing heliocentric distance may be associated with the growth of this instability as the Alfvén speed declines.

An earlier comprehensive study by #cite(<neugebauerReexaminationRotationalTangential1984>, form: "prose"), using ISEE 3 data, showed that the relative directions of velocity and field changes across all three discontinuity types (RD, TD, and the intermediate "either" category, ED) are consistent with outward propagation. The magnitude of the velocity change at RDs was found to be systematically smaller than the MHD prediction --- a discrepancy only partially reduced by using a two-stream proton fit --- foreshadowing the broader $R < 1$ puzzle discussed below. Further, the plasma jump conditions at EDs showed closer resemblance to RDs than to TDs.

Quantitative assessment of Alfvénicity relies on the Walén relation, which states that the velocity jump across an RD should equal the corresponding Alfvén velocity jump. Two complementary approaches have been developed (see the bottom panels of #ref(<fig-paschmann2013-fig2>, supplement: [Figure])). The first evaluates the Walén relation as a jump condition by comparing velocity and Alfvén velocity changes between two carefully chosen measurement times on opposite sides of the discontinuity. The second checks the level of Alfvénicity continuously for all measurements between those two points: plasma velocity components, after transformation into the de Hoffmann--Teller (HT) frame, are plotted against the corresponding Alfvén velocity components, and the slope of the regression line, $W_(upright(s l))$, serves as the quality index, with $W_(upright(s l)) = plus.minus 1$ indicating perfect Alfvénic agreement.

#figure([
#box(image("figures/ref/paschmannDiscontinuitiesAlfvenicFluctuations2013-fig2case1.png"))
], caption: figure.caption(
position: bottom, 
[
Overview plots for DD crossings. For each case, the five panels at the top show the magnetic field magnitude, the plasma density, followed by a comparison between the three components of $upright(bold(v))' = \( upright(bold(v)) - upright(bold(V))_(upright(H T)) \)$ (in black) and (in red) the three components of $- upright(bold(V))_A$ or $upright(bold(V))_A$ (depending on the sign of the Walén slope), all from Cluster C1, with the DD at the center of the time series. The panels along the bottom show the HT scatterplot for the 10 min interval, and the Walén scatterplots for the full 10 min and for the 1 min interval centered on the DD. In these scatterplots the vector components are distinguished by their color (black for x, red for y, and green for z).
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)
<fig-paschmann2013-fig2>


#cite(<neugebauerCommentAbundancesRotational2006>, form: "prose") reported that the magnitude ratio $R = \| Delta upright(bold(v)) \| \/ \| Delta upright(bold(v))_A \|$ from the jump approach is commonly around 0.6---systematically less than unity. #cite(<paschmannDiscontinuitiesAlfvenicFluctuations2013>, form: "prose"), using Cluster data, performed a comprehensive Walén analysis on 188 directional discontinuities and found that a substantial fraction (77 out of 127 with a good de Hoffmann--Teller frame) exhibited plasma flow speeds exceeding 80% of the Alfvén speed, with 33 cases exceeding 90%. Their analysis also established that the degree of Alfvénicity of the coherent current sheets is nearly the same as that of the fluctuations in which they are embedded, suggesting that whatever process causes deviations from ideal Alfvénicity operates equally on both. This result places current sheets on a continuum with the ambient Alfvénic turbulence rather than as dynamically distinct structures.

A critical complication in using the Walén test for RD/TD classification was identified by #cite(<madarDirectionalDiscontinuitiesInner2024>, form: "prose"), who analyzed over 140,000 directional discontinuities between 0.06 and 1.01 AU using Parker Solar Probe and Solar Orbiter data. They showed that Alfvén waves propagating along the surface of TDs can produce positive Walén test results, mimicking RD signatures. To disentangle the two populations, they examined the velocity in the HT frame: for surface waves on TDs, the residual velocity $\( upright(bold(V)) - upright(bold(V))_(upright(H T)) \)$ lies close to the discontinuity plane, whereas for genuine RDs it is quasi-perpendicular to the surface. A scatter plot of $B_n \/ B_max$ against $\( upright(bold(V)) - upright(bold(V))_(upright(H T)) \) dot.op hat(n) \/ \| upright(bold(V)) - upright(bold(V))_(upright(H T)) \|$ revealed two clearly distinct populations, confirming that many apparent RD candidates are in fact TDs with surface Alfvén waves. After this reclassification, they found that most discontinuities with small normal magnetic field components are TDs, regardless of the jump in field magnitude.

The systematic shortfall $R < 1$ has remained a longstanding puzzle. As noted by #cite(<paschmannDiscontinuitiesAlfvenicFluctuations2013>, form: "prose"), this deficiency mirrors the behavior of Alfvénic fluctuations more broadly: the Alfvén ratio $r_A = delta v^2 \/ delta v_A^2$ is known to decrease systematically with heliocentric distance, reaching approximately 0.5 at 1 AU @belcherLargeamplitudeAlfvenWaves1971@borovskyVelocityMagneticField2012.

Refined scalar measures for evaluating Alfvénicity have been developed to disentangle directional and magnitude deviations. #cite(<sonnerupQualityMeasureWalen2018>, form: "prose") introduced a quality index $Q$ that incorporates both the angular deviation and the magnitude ratio between $Delta upright(bold(v))$ and $Delta upright(bold(v))_A$, with $Q = plus.minus 1$ indicating perfect agreement. #cite(<paschmannComparisonQualityMeasures2020>, form: "prose") systematically compared the jump-based index $Q$ with the regression slope $W_(upright(s l))$ across nearly 1,000 magnetopause crossings, finding that a substantially higher threshold is needed for $\| Q \|$ than for $\| W_(upright(s l)) \|$ to yield comparable numbers of RD candidates, and that the events selected by the two methods are not identical. They concluded that a complete evaluation of Alfvénicity requires two scalar quality measures: the magnitude ratio $R = \| Delta upright(bold(v)) \| \/ \| Delta upright(bold(v))_A \|$ and the angle $Theta$ between $Delta upright(bold(v))$ and $Delta upright(bold(v))_A$ @paschmannLargeScaleSurveyStructure2018.

=== Additional Statistical Properties
<additional-statistical-properties>
This subsection briefly summarizes several additional properties of solar wind current sheets that, while not the primary focus of this thesis, form an important part of the broader observational picture and provide useful context for interpreting the current sheet population.

==== Orientation
<orientation>
The orientation of current sheet normals relative to the local magnetic field depends on both the type of discontinuity and heliocentric distance. In the inner heliosphere, #cite(<marianiVariationsOccurrenceRate1973>, form: "prose") analyzed Pioneer 8 data (10 s cadence) and found that TD normals are predominantly perpendicular to the local Parker Archimedean spiral field, consistent with TDs separating adjacent flux tubes. #cite(<sodingRadialLatitudinalDependencies2001>, form: "prose") corroborated this and highlighted a contrasting behavior for rotational discontinuities (RDs): inner heliospheric RD normals are primarily parallel to the mean field, $upright(bold(B))_0$ (i.e., the normal-to-field angle $gamma approx 0^compose$). This aligns with Alfvén waves propagating along the field, although obliquely propagating RDs are also present. Conversely, in the middle heliosphere (10--40 AU), the distribution of $gamma$ becomes nearly uniform across all directions, with a notable depletion of RDs propagating parallel to $upright(bold(B))_0$. To explain this radial evolution, #cite(<sodingRadialLatitudinalDependencies2001>, form: "prose") suggested that field-aligned RDs are unstable over large spatial and temporal scales so the effects of this instability are absent in the inner heliosphere (0.3--2.3 AU) but become pronounced at greater distances.

==== Plasma Beta Dependence
<plasma-beta-dependence>
The properties of current sheets depend on the local plasma $beta$. #cite(<shaikhBetadependentPropertiesSolar2026>, form: "prose"), using interplanetary coronal mass ejections as a natural laboratory spanning a broad range of beta ($10^(- 2) lt.tilde beta_e lt.tilde 10$, $10^(- 3) lt.tilde beta_p lt.tilde 10$), showed that both the shear angle $Delta theta$ and the normalized thickness $lambda \/ lambda_p$ of current sheets depend on electron and proton beta. They argued that the beta dependence of the shear angle is an intrinsic feature of solar wind turbulence arising from the natural correlation between turbulence intensity and plasma beta. According to recent theory, current sheets formed in turbulence are disrupted by the electron tearing instability once their thickness falls below a critical scale, mediating the transition from the inertial to the kinetic cascade @malletDisruptionSheetlikeStructures2017. #cite(<shaikhBetadependentPropertiesSolar2026>, form: "prose") demonstrated that normalizing current sheet thickness by this critical scale eliminates the beta dependence across the entire measured range.

==== Bifurcated Current Sheets and Reconnection Exhausts
<bifurcated-current-sheets-and-reconnection-exhausts>
A distinctive subclass of solar wind current sheets exhibits bifurcated structure---a double-step magnetic field rotation rather than as a single monotonic rotation @goslingMagneticReconnectionSolar2012@neugebauerProgressStudyInterplanetary2010. As reviewed by #cite(<goslingMagneticReconnectionSolar2012>, form: "prose"), these bifurcated current sheets are the observational signature of magnetic reconnection in the solar wind. When reconnection occurs, the reconnecting current sheet splits into a pair of back-to-back rotational discontinuities that bound a wedge of accelerated plasma---the reconnection exhaust. The exhaust plasma flows at roughly the local Alfvén speed, with correlated changes in $upright(bold(V))$ and $upright(bold(B))$ at one boundary and anti-correlated changes at the other, reflecting the oppositely propagating Alfvénic disturbances generated by the reconnection process.

The observational picture of reconnection in the solar wind has developed rapidly since the first unambiguous identification of reconnection exhausts by #cite(<goslingDirectEvidenceMagnetic2005>, form: "prose"). Using Wind 3-second data, #cite(<goslingMagneticReconnectionSolar2012>, form: "prose") reported typical occurrence rates of 40--80 exhausts per month at 1 AU near solar minimum, with most events having temporal widths of tens of seconds (local widths of order $10^4$ km). Reconnection occurs most frequently at current sheets with field shear angles below $90 degree$---simply because such current sheets are the dominant type in the solar wind---and has been observed at shear angles as small as $11 degree$ @goslingBifurcatedCurrentSheets2008. The narrowest exhaust identified had a local width of $tilde.op 10^3$ km ($tilde.op 18 thin lambda_i$), and current sheets thinner than $tilde.op 3 thin lambda_i$ were absent from the dataset, suggesting that such ultrathin structures are quickly disrupted by reconnection.

Multi-spacecraft observations have revealed that reconnection in large-scale current sheets typically occurs in a quasi-stationary fashion at a single dominant, extended X-line. The most extensive event documented involved five spacecraft and demonstrated continuous reconnection persisting for over 5 hours along an X-line extending at least $4.26 times 10^6$ km @goslingMagneticReconnectionSolar2012. Exhaust boundaries are roughly planar on large scales, though finer-scale corrugations are sometimes observed. The occurrence of reconnection depends on a combination of magnetic shear angle and the plasma $beta$ difference across the current sheet: for low $beta$, reconnection occurs at essentially all shear angles, whereas for high $beta$ it is restricted to large shear angles---consistent with the theoretical prediction that diamagnetic drift of the X-line suppresses reconnection at low-shear, high-$beta$ current sheets.

#cite(<goslingBifurcatedCurrentSheets2008>, form: "prose"), examining an interval containing 11 reconnection exhausts and 27 thin current sheets within a magnetic cloud and its trailing high-speed stream, found that at least three of the thin sheets also exhibited bifurcated structure, indicating that they had been disrupted by reconnection. The relative absence of ultrathin current sheets was interpreted as evidence that such structures are rapidly disrupted once they form. More recently, #cite(<yoonCollisionlessRelaxationDisequilibrated2021>, form: "prose") showed through particle-in-cell simulations that bifurcated current sheets can also arise naturally from the collisionless equilibration of a disequilibrated current sheet, through transitions among single-particle orbit classes, without requiring active reconnection. This suggests that not all observed bifurcated structures necessarily indicate ongoing or recent reconnection, and that collisionless relaxation may be an additional pathway to bifurcation.

It should be noted that the reconnection exhausts described above are observed at relatively large-scale current sheets resolvable with 3-second plasma cadence ($gt.tilde 10^3$ km). Whether reconnection at kinetic-scale current sheets---the focus of this thesis---produces qualitatively similar or distinct signatures remains an active area of investigation, as discussed in the context of reconnection onset conditions earlier in this chapter.

==== Contribution to the Magnetic Fluctuation Spectrum
<contribution-to-the-magnetic-fluctuation-spectrum>
Current sheets contribute significantly to the power of magnetic field fluctuations in the solar wind. #cite(<borovskyContributionStrongDiscontinuities2010>, form: "prose"), analyzing 8.5 years of ACE magnetometer data, constructed an artificial time series preserving only the timing and amplitudes of strong (large-rotation-angle) discontinuities. The power spectrum of this discontinuity series follows a power law in the inertial subrange with spectral index near the Kolmogorov $- 5 \/ 3$ value, and accounts for approximately half of the total spectral power of the solar wind magnetic field over this range. This result warns that the measured spectral properties of solar wind turbulence are heavily influenced by the discrete contribution of current sheets, complicating the interpretation of spectral indices.

#cite(<liEffectCurrentSheets2011>, form: "prose") provided complementary evidence from three years of Ulysses data in which over 28,000 current sheets were identified. They showed that during the longest current-sheet-free intervals, the magnetic field power spectra are consistently described by the Iroshnikov--Kraichnan $k^(- 3 \/ 2)$ scaling, whereas during the most current-sheet-abundant intervals, the spectra exhibit Kolmogorov $k^(- 5 \/ 3)$ scaling. This finding implies that the commonly observed Kolmogorov scaling in the solar wind may be a consequence of the ubiquitous presence of current sheets rather than an intrinsic property of the underlying turbulent cascade, and that a proper analysis of solar wind power spectra must account for the contribution of intermittent structures.

==== Other Plasma Jump Conditions
<other-plasma-jump-conditions>
Beyond the magnetic field signatures discussed above, the behavior of plasma parameters across current sheets provides additional constraints on their nature and on the validity of the RD/TD classification.

#cite(<neugebauerReexaminationRotationalTangential1984>, form: "prose") conducted a comprehensive examination of plasma jump conditions across 221 discontinuities using ISEE 3 magnetic field and proton data. They found that the first and second adiabatic invariants ($T_(p perp) \/ B$ and $T_(p parallel) B^2 \/ n^2$) are approximately conserved across RDs but not across TDs, confirming that the MVA-based classification into these two types captures a genuine physical distinction. The product of plasma density and the anisotropy factor, $rho A$, tends to be conserved across all three discontinuity types (RDs, TDs, and EDs)---a result expected for RDs but not required by MHD theory for TDs. The helium abundance $n_alpha \/ n_p$ is generally conserved across RDs but can change substantially across TDs; however, a broad tail in the $n_alpha \/ n_p$ distribution for RDs indicates that the helium abundance does change at a small fraction of them.

The multi-species dynamics at RDs proved particularly revealing. #cite(<neugebauerReexaminationRotationalTangential1984>, form: "prose") showed that the primary and secondary proton beams flow through RDs in opposite directions with oppositely directed velocity changes, while alpha particles interact much more weakly---with velocity changes clustered near zero and no preferred direction. They proposed a simple model in which the RD moves through the primary proton fluid at slightly less than the local Alfvén speed; because the alpha particles drift relative to the primary protons at approximately this same speed, they effectively co-move with the RD and do not cross it. Under these conditions, the jump conditions for alphas resemble those across a contact discontinuity, explaining how the helium abundance can change even across a genuine RD. When this multi-stream model was used to recalculate the Walén ratio $R_(V B)$, it increased from $0.59 plus.minus 0.03$ (single-stream proton moments) to $0.74 plus.minus 0.02$, and further inclusion of alpha particle anisotropy and estimated electron contributions raised it to $0.77 plus.minus 0.03$---diminishing but not eliminating the longstanding $R_(V B) < 1$ discrepancy.

The properties of the magnetically ambiguous EDs were found to resemble those of RDs much more closely than those of TDs across essentially all parameters: adiabatic invariants, density conservation, helium abundance, Walén ratio, and mean solar wind speed. This led #cite(<neugebauerReexaminationRotationalTangential1984>, form: "prose") to conclude that the ED population consists predominantly of obliquely propagating RDs with small but finite $B_n$, rather than TDs with coincidentally small $Delta \| B \|$.

== Open Questions
<open-questions>
and highlight several open questions that motivate further investigation.

In light of the discussions in the previous sections, several questions naturally arise. One key issue concerns the #strong[evolution of current sheets throughout the heliosphere]. Previous investigations have typically focused either on large-scale discontinuities or on kinetic-scale current sheets, often using different identification methods and observational datasets. As a result, a unified picture of how current sheets evolve across multiple spatial scales remains incomplete. Developing a detection approach capable of capturing current sheets across a broad range of scales and heliocentric distances would therefore be highly valuable. Such an approach would also allow the separation of #strong[temporal variability] from #strong[radial evolution], which is difficult to achieve with single-point measurements.

Another important question follows from the inherently #strong[multi-scale nature of current sheets]. It is plausible that structures at different scales originate from different physical mechanisms---for example, coronal flux-tube boundaries, nonlinear wave steepening, or turbulence-driven intermittency. If so, these different populations of current sheets may follow distinct evolutionary paths as they propagate outward with the solar wind. A more refined perspective would therefore involve identifying distinct #strong[sub-populations of current sheets], characterizing their generation mechanisms, and determining how each group evolves with heliocentric distance.

Finally, understanding how these different classes of current sheets influence the #strong[dynamics of the solar wind plasma] remains an important open problem. Their presence may affect processes such as turbulence dissipation, particle scattering, and energy transport. Establishing the statistical properties and evolutionary behavior of these structures is therefore a necessary step toward a more comprehensive understanding of solar wind turbulence and heliospheric plasma dynamics.

In light of this literature review, we find it prudent to address the following science questions:

#pagebreak()
= Observational Analysis of Current Sheets
<sec-obs>
#strong[Context:] A critical first step in understanding the role of current sheets in energetic particle transport is to characterize their statistical properties and quantify the parameters most relevant to particle scattering. Although current sheets have been extensively observed---especially near $1$ AU---our knowledge of how their properties evolve across heliocentric distances, and how key scattering-related parameters vary with radial distance, has remained incomplete. Previous studies @sodingRadialLatitudinalDependencies2001[#cite(<lotekarKineticscaleCurrentSheets2022>, form: "prose"), #cite(<liuCharacteristicsInterplanetaryDiscontinuities2021>, form: "prose"), #cite(<vaskoKineticscaleCurrentSheets2022>, form: "prose"), #cite(<vaskoKineticScaleCurrentSheets2024>, form: "prose")] often lacked simultaneous, multi-point measurements and did not adequately separate temporal variability from spatial trends, leading to persistent uncertainties regarding their role in particle transport, their origin, and their evolution within the turbulent solar wind.

#strong[Approach:] To bridge this observational gap, we conducted a detailed statistical analysis using continuous solar wind data from multiple spacecraft: Parker Solar Probe (PSP) at distances down to 0.1 AU, Wind, ARTEMIS, and STEREO at 1 AU, and Juno during its cruise phase out to 5 AU near Jupiter. This combination allowed us to track the evolution of current sheet properties across a wide radial distance, from near Alfvénic critical surface to the outer inner heliosphere.

#figure([
#box(image("figures/fig-ids_examples.png", alt: "Current sheets detected by PSP, Juno, STEREO and near-Earth ARTEMIS satellite: red, blue, and black lines are 𝐵_𝑙, 𝐵_𝑚, and 𝐵"))
], caption: figure.caption(
position: bottom, 
[
Current sheets detected by PSP, Juno, STEREO and near-Earth ARTEMIS satellite: red, blue, and black lines are $𝐵_𝑙$, $𝐵_𝑚$, and $𝐵$
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)


#strong[Results:] Our analysis reveals that solar wind current sheets maintain kinetic-scale thicknesses throughout the inner heliosphere, with occurrence rates decreasing approximately as $1 \/ r$ with radial distance between 1 and 5 AU. When normalized to the local ion inertial length and Alfvén current, both the current density and thickness of these structures remain nearly constant over the range from 0.1 to 5 AU (see #strong[?\@fig-juno-distribution-r-sw]). This suggests that current sheets consistently influence energetic particle transport across heliocentric distances, with their higher occurrence rates closer to the Sun indicating a more pronounced role in shaping particle dynamics in the inner heliosphere. Furthermore, by leveraging simultaneous observations from spacecraft at different radial distances, we demonstrate that the observed radial trends reflect genuine spatial evolution rather than temporal or solar-cycle effects. In particular, we propose that the observed reduction in current sheet occurrence rate at larger heliocentric distances is partly attributable to a geometric effect---namely, the decreasing probability that a spacecraft intersects inclined structures as distance from the Sun increases. This represents an observational bias that must be accounted for when interpreting occurrence statistics. However, even after correcting for this geometric effect, a modest residual decrease remains, which we attribute to possible physical dissipation or annihilation of current sheets as they propagate outward through the solar wind.

Together, these results provide critical empirical constraints for particle transport modeling and establish a robust observational foundation for the theoretical and numerical components of this thesis. This work is presented in #emph["Solar wind discontinuities in the outer heliosphere: Spatial distribution between 1 and 5 AU"] (Zhang et al., submitted to JGR Space Physics, 2025, manuscript is available at #link("https://www.authorea.com/users/814634/articles/1283652-solar-wind-discontinuities-in-the-outer-heliosphere-spatial-distribution-between-1-and-5-au")[10.22541/essoar.174431869.93012071/v1]).

= Quantitative Modeling of Particle Scattering
<sec-modeling>
#strong[Context:] While it is well established that turbulence governs energetic particle transport in the heliosphere, the specific role of coherent structures---particularly current sheets---in shaping scattering processes remained under-explored. A central objective of this thesis is to develop a physics-based, observation-informed model that directly links solar wind current sheet properties to pitch-angle scattering rates of energetic particles.

#strong[Approach:] To this end, we combined statistical measurements of current sheets at 1 AU with a Hamiltonian analytical framework and test particle simulations to investigate how particle scattering efficiency varies with current sheet geometry and particle energy, using a realistic magnetic field configuration:

$ upright(bold(B)) = B_0 \( cos theta med upright(bold(e_z)) + sin theta \( sin phi \( z \) med upright(bold(e_x)) + cos phi \( z \) med upright(bold(e_y)) \) \) $

where $B_0$ is the magnitude of the magnetic field, $theta$ is the azimuthal angle between the normal and the magnetic field, and $phi \( z \)$ is the rotation profile of the magnetic field as a function of $z$.

#strong[Results:] Using a newly formulated Hamiltonian framework (see dimensionless form in #strong[?\@eq-Hamiltonian], below) that incorporates the effects of magnetic field shear angle $beta$ and particle energy $H$, we demonstrate that scattering rates depend strongly on the current density---which is directly tied to $beta$---as well as on the ratio of the particle gyroradius to the current sheet thickness. Notably, our results show that current sheets can induce rapid, non-diffusive pitch-angle jumps, particularly for SEPs in the 100 keV to 1 MeV energy ranges (see #strong[?\@fig-example-subset]). This behavior deviates significantly from classical quasilinear predictions and highlights the need to account for coherent structures in transport models. To describe long-term pitch-angle evolution, we developed a simplified probabilistic model of pitch-angle scattering due to current sheets and derived an effective pitch-angle diffusion coefficient $D_(mu mu)$ (see #strong[?\@fig-mixing-rate]).

These diffusion rate estimates enable direct comparison with other scattering mechanisms, facilitate the incorporation of SWD-induced scattering into global SEP transport models, and directly support the broader goal of this thesis to improve our understanding of how energetic particles interact with turbulence in the solar wind. This work is presented in "Quantification of Ion Scattering by Solar Wind Current Sheets: Pitch-Angle Diffusion Rates" (Zhang et al., submitted to Physical Review E, 2025, manuscript is available at #link("https://github.com/Beforerr/ion_scattering_by_SWD/blob/ec33d3d082bcd463faf7a233ba80138414231b51/files/2024PRE_Scattering_Zijin.pdf")[GitHub]).

#pagebreak()
= Solar wind discontinuities in the outer heliosphere: spatial distribution between 1 and 5 AU
<solar-wind-discontinuities-in-the-outer-heliosphere-spatial-distribution-between-1-and-5-au>
#pagebreak()
= Evolution of solar wind current sheets in the inner heliosphere
<evolution-of-solar-wind-current-sheets-in-the-inner-heliosphere>
#pagebreak()
= Energetic Particle Transport driven by Solar Wind Current Sheets
<energetic-particle-transport-driven-by-solar-wind-current-sheets>
= Summary and Future Perspectives
<summary-and-future-perspectives>
The work completed in this thesis has established that solar wind current sheets are persistent, kinetic-scale structures whose statistical properties evolve predictably with heliocentric distance (see #ref(<sec-obs>, supplement: [Section])). We have demonstrated---both theoretically and through numerical modeling---that SWDs play a significant role in modulating particle transport, particularly by enhancing pitch-angle scattering beyond quasilinear expectations (see #ref(<sec-modeling>, supplement: [Section])). Furthermore, we have shown that their internal structure, including multifluid effects and Alfvénicity variations, are essential to understanding their properties and thereby their transport-modifying capacity (see #strong[?\@sec-multifluid]).

== Relevance and Broader Implications
<relevance-and-broader-implications>
This thesis substantially advances our understanding of particle transport mechanisms within turbulent space plasmas, offering significant enhancements to SEP prediction models. By accurately quantifying the influence of coherent structures such as current sheets, the research outcomes have direct applications to improving space weather forecasting, enhancing spacecraft operational safety, and contributing to the broader understanding of energetic particles transport and acceleration in the solar wind.

== Opportunities for Future Research
<opportunities-for-future-research>
Completion of this thesis opens several avenues for future investigations:

- Exploration of current sheet interactions in other astrophysical environments, such as planetary magnetospheres.

- Advanced integration of mapping techniques with numerical simulations to further refine SEP transport models.

- Expanded observational campaigns utilizing upcoming spacecraft missions designed to probe heliospheric turbulence and particle dynamics at unprecedented resolution.

Although much progress has been made in the past decades since the first report on solar wind discontinuities \[Ness et al., 1966\], the most basic question is still waiting for a conclusive answer: why is the solar wind discontinuous?

#pagebreak()



#set bibliography(style: "apa")

#bibliography(("../../../../files/bibliography/research.bib"))

