# UCLA-thesis

*Kinetic-scale solar wind current sheets: statistical characteristics and their role in energetic particle transport*: Zijin Zhang, PhD dissertation, UCLA, 2026.

PDF and defense slides: [Releases](https://github.com/Beforerr/UCLA-thesis/releases/latest).

```sh
typst compile main.typ
```

## Template

`lib.typ` is a standalone Typst template for UCLA theses and dissertations, following the [filing requirements](https://grad.ucla.edu/academics/graduate-study/thesis-and-dissertation-filing-requirements/) (Oct 2023). It handles the preliminary pages and page numbering for you. See `main.typ` for a full example.

```typst
#import "lib.typ": uclathesis, appendices, citet

#show: uclathesis.with(
  title: [...], author: "...", major: "...", year: 2026,
  doc-type: "dissertation",          // or "thesis"
  committee-chair: "...", committee-members: ("...",),
  abstract: [...], bibliography: bibliography("refs.bib"),
)

= Introduction
...
#show: appendices
= Extra material
```

`citet` gives prose citations, e.g. "Author (2020)".
