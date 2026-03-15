// UCLA Thesis and Dissertation Template for Typst
// Based on UCLA Thesis and Dissertation Filing Requirements (Updated October 2023)
// https://grad.ucla.edu/academics/graduate-study/thesis-and-dissertation-filing-requirements/

#let _builtin_bibliography = bibliography

/// Create the UCLA thesis title page.
///
/// - title (content): The thesis/dissertation title.
/// - author (str): The author's official name as registered with UCLA.
/// - degree (str): The full degree name (e.g., "Doctor of Philosophy").
/// - major (str): The official major name as approved by the Academic Senate.
/// - year (int): The year the degree is awarded.
/// - doc-type (str): Either "dissertation" or "thesis".
#let title-page(
  title: none,
  author: none,
  degree: none,
  major: none,
  year: none,
  doc-type: "dissertation",
) = {
  set page(numbering: none)
  set par(leading: 0.65em, justify: false)

  align(center)[
    #v(1fr)

    UNIVERSITY OF CALIFORNIA

    Los Angeles

    #v(2fr)

    #title

    #v(2fr)

    #if doc-type == "dissertation" [
      A dissertation submitted in partial satisfaction of the

      requirements for the degree #degree

      in #major
    ] else [
      A thesis submitted in partial satisfaction

      of the requirements for the degree #degree

      in #major
    ]

    #v(1fr)

    by

    #v(1fr)

    #author

    #v(2fr)

    #str(year)

    #v(1fr)
  ]
  pagebreak(weak: true)
}

/// Create the copyright page.
///
/// - author (str): The author's official name.
/// - year (int): The year of the copyright (same as degree year).
#let copyright-page(author: none, year: none) = {
  set page(numbering: none)
  set par(justify: false)

  align(center + bottom)[
    \u{00A9} Copyright by

    #author

    #str(year)
  ]
  pagebreak(weak: true)
}

/// Create a blank page (alternative to copyright page).
#let blank-page() = {
  set page(numbering: none)
  pagebreak(weak: true)
}

/// Create the abstract page.
///
/// - title (content): The thesis/dissertation title.
/// - author (str): The author's official name.
/// - degree (str): The full degree name.
/// - major (str): The official major name.
/// - university (str): University name.
/// - year (int): The year the degree is awarded.
/// - chair (str): Committee chair name (prefixed with "Professor").
/// - co-chair (str): Committee co-chair name, if any.
/// - doc-type (str): Either "dissertation" or "thesis".
/// - body (content): The abstract text.
#let abstract-page(
  title: none,
  author: none,
  degree: none,
  major: none,
  university: "University of California, Los Angeles",
  year: none,
  chair: none,
  co-chair: none,
  doc-type: "dissertation",
  body,
) = {
  set par(justify: false)

  align(center)[
    #if doc-type == "dissertation" [
      ABSTRACT OF THE DISSERTATION
    ] else [
      ABSTRACT OF THE THESIS
    ]

    #v(2em)

    #title

    #v(1em)

    by

    #v(1em)

    #author

    #degree in #major

    #university, #str(year)

    #if co-chair != none [
      Professor #co-chair, Co-Chair

      Professor #chair, Co-Chair
    ] else [
      Professor #chair, Chair
    ]
  ]

  v(2em)

  set par(justify: true)
  body
}

/// Create the committee page.
///
/// - author (str): The author's official name.
/// - year (int): The year the degree is awarded.
/// - members (array): Array of committee member name strings.
///   The chair (or co-chairs) should be listed last.
/// - chair (str): Committee chair name.
/// - co-chair (str): Committee co-chair name, if any.
/// - doc-type (str): Either "dissertation" or "thesis".
#let committee-page(
  author: none,
  year: none,
  members: (),
  chair: none,
  co-chair: none,
  doc-type: "dissertation",
) = {
  set par(justify: false)

  align(center)[
    The #doc-type of #author is approved.

    #v(3em)

    #for member in members [
      #member

    ]

    #if co-chair != none [
      #co-chair, Committee Co-Chair

      #v(1.5em)

      #chair, Committee Co-Chair
    ] else [
      #chair, Committee Chair
    ]

    #v(5em)

    University of California, Los Angeles

    #str(year)
  ]
}

/// The main UCLA thesis template function.
///
/// Apply this using `#show: uclathesis.with(...)`.
///
/// - title (content): The thesis/dissertation title.
/// - author (str): The author's official name as registered with UCLA.
/// - degree (str): Full degree name (e.g., "Doctor of Philosophy", "Master of Science").
/// - major (str): Official major name as approved by the Academic Senate.
/// - year (int): Year the degree is awarded.
/// - month (str): Month the degree is awarded (for metadata).
/// - doc-type (str): "dissertation" (for doctoral) or "thesis" (for master's).
/// - committee-chair (str): Committee chair's name.
/// - committee-co-chair (str): Committee co-chair's name (if applicable).
/// - committee-members (array): Array of other committee member name strings.
/// - abstract (content): The abstract text.
/// - dedication (content): Optional dedication page content.
/// - acknowledgments (content): Optional acknowledgments content.
/// - preface (content): Optional preface content (alternative to acknowledgments).
/// - vita (content): Optional vita/biographical sketch (required for doctoral, max 2 pages).
/// - copyright (bool): Whether to include a copyright page (true) or blank page (false).
/// - bibliography (bibliography): Optional bibliography.
/// - body (content): The main document body.
#let uclathesis(
  title: [Untitled],
  author: "Author Name",
  degree: "Doctor of Philosophy",
  major: "Major",
  year: datetime.today().year(),
  month: none,
  doc-type: "dissertation",
  committee-chair: none,
  committee-co-chair: none,
  committee-members: (),
  abstract: none,
  dedication: none,
  acknowledgments: none,
  preface: none,
  vita: none,
  copyright: true,
  bibliography: none,
  body,
) = {
  // Document metadata
  set document(
    title: if title != none {
      title
        .fields()
        .at("children", default: (title,))
        .filter(c => c != [ ])
        .map(c => {
          if type(c) == str { c } else if c.has("text") { c.text } else { "" }
        })
        .join(" ")
    },
    author: author,
  )

  // Global page setup: US Letter, 1" margins on all sides
  set page(
    paper: "us-letter",
    margin: (
      top: 1in,
      bottom: 1in,
      left: 1in,
      right: 1in,
    ),
    // Page number centered, 0.75" from bottom
    footer: context {
      let num = page.numbering
      if num != none {
        align(center)[
          #counter(page).display(num)
        ]
      }
    },
    footer-descent: 0.25in, // footer at 0.75" from bottom (1" - 0.25" = 0.75")
  )

  // Global text settings: 12pt, double-spaced
  set text(
    font: "New Computer Modern",
    size: 12pt,
    lang: "en",
  )
  set par(
    leading: 1em, // double spacing
    first-line-indent: 0pt,
    justify: true,
    spacing: 2em,
  )

  // Heading styles
  set heading(numbering: "1.1")
  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    v(0.5in)
    set text(size: 14pt, weight: "bold")
    if it.numbering != none {
      [Chapter ]
      counter(heading).display()
      linebreak()
    }
    it.body
    v(0.3in)
  }
  show heading.where(level: 2): it => {
    v(1.5em)
    set text(size: 12pt, weight: "bold")
    if it.numbering != none {
      counter(heading).display()
      h(0.5em)
    }
    it.body
    v(0.75em)
  }
  show heading.where(level: 3): it => {
    v(1em)
    set text(size: 12pt, weight: "bold")
    if it.numbering != none {
      counter(heading).display()
      h(0.5em)
    }
    it.body
    v(0.5em)
  }

  // Figure and table captions
  set figure(gap: 1em)
  show figure.caption: set text(size: 10pt)

  // Footnotes: single-spaced with blank line between
  show footnote.entry: set text(size: 10pt)
  set footnote.entry(gap: 1.2em)

  // ============================================================
  // PRELIMINARY PAGES (Roman numeral numbering)
  // ============================================================

  // Title Page (counted as page i, but not numbered)
  title-page(
    title: title,
    author: author,
    degree: degree,
    major: major,
    year: year,
    doc-type: doc-type,
  )

  // Copyright Page or Blank Page (not counted or numbered)
  if copyright {
    copyright-page(author: author, year: year)
  } else {
    blank-page()
  }

  // Start Roman numeral numbering at ii (abstract page)
  set page(numbering: "i")
  counter(page).update(2)

  // Abstract Page
  if abstract != none {
    abstract-page(
      title: title,
      author: author,
      degree: degree,
      major: major,
      year: year,
      chair: committee-chair,
      co-chair: committee-co-chair,
      doc-type: doc-type,
      abstract,
    )
    pagebreak(weak: true)
  }

  // Committee Page
  committee-page(
    author: author,
    year: year,
    members: committee-members,
    chair: committee-chair,
    co-chair: committee-co-chair,
    doc-type: doc-type,
  )
  pagebreak(weak: true)

  // Dedication Page (optional)
  if dedication != none {
    v(1fr)
    align(center, dedication)
    v(1fr)
    pagebreak(weak: true)
  }

  // Table of Contents
  {
    show outline.entry.where(level: 1): it => {
      v(0.5em, weak: true)
      strong(it)
    }
    outline(
      title: [Table of Contents],
      indent: auto,
      depth: 3,
    )
    pagebreak(weak: true)
  }

  // List of Figures (if any figures exist)
  context {
    let figs = query(figure.where(kind: image))
    if figs.len() > 0 {
      outline(
        title: [List of Figures],
        target: figure.where(kind: image),
      )
      pagebreak(weak: true)
    }
  }

  // List of Tables (if any tables exist)
  context {
    let tbls = query(figure.where(kind: table))
    if tbls.len() > 0 {
      outline(
        title: [List of Tables],
        target: figure.where(kind: table),
      )
      pagebreak(weak: true)
    }
  }

  // Acknowledgments (optional)
  if acknowledgments != none {
    heading(outlined: true, numbering: none, [Acknowledgments])
    acknowledgments
    pagebreak(weak: true)
  }

  // Preface (optional, alternative to acknowledgments)
  if preface != none {
    heading(outlined: true, numbering: none, [Preface])
    preface
    pagebreak(weak: true)
  }

  // Vita/Biographical Sketch (required for doctoral, optional for master's)
  if vita != none {
    heading(outlined: true, numbering: none, [Vita])
    vita
    pagebreak(weak: true)
  }

  // ============================================================
  // BODY TEXT (Arabic numeral numbering, starting at 1)
  // ============================================================
  set page(numbering: "1")
  counter(page).update(1)

  body

  // ============================================================
  // BIBLIOGRAPHY (always last section)
  // ============================================================
  if bibliography != none {
    set _builtin_bibliography(title: [Bibliography], style: "apa")
    bibliography
  }
}
