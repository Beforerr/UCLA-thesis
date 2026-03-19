#let NormalTok(s) = text(fill: rgb("#003b4f"), raw(s))

= The JuliaSpacePhysics Ecosystem: High-Performance, Modular, and Scalable Software for Space Physics Data Analysis

== Introduction

The continued expansion of space physics missions---particularly multi-spacecraft constellations with increasingly high-cadence measurements---presents growing challenges for data discovery, access, processing, and analysis. Modern missions routinely generate large, heterogeneous datasets whose volume and complexity place substantial demands on existing analysis workflows, making scalable, efficient, and sustainable software frameworks essential for the community.

Historically, space physics data analysis has relied on programming environments such as IDL, MATLAB, and, more recently, Python. While these tools have enabled significant scientific advances, each exhibits notable limitations. IDL is proprietary, restricting free distribution and long-term sustainability, and suffers from a single-namespace design that leads to conflicts when combining multiple libraries. MATLAB faces similar licensing constraints---a practical barrier for scaling to clusters, continuous integration, containers, or broad distribution---and encounters performance bottlenecks when moving beyond built-in vectorized operations to custom loops, complex data structures, or user-defined logic. Python has become the dominant open-source language in heliophysics due to its extensive ecosystem and accessibility, but its interpreted execution model imposes performance limitations for computationally intensive tasks; achieving high performance typically requires pushing work into vectorized libraries, JIT frameworks, or compiled-language extensions.

This chapter presents the #strong[JuliaSpacePhysics ecosystem], a modular and interoperable software framework for space physics data analysis built on the Julia programming language. Julia combines high-level expressiveness with near-compiled-language performance through just-in-time compilation, multiple dispatch, and strong support for abstract interfaces, enabling both rapid development and efficient execution within a single language. Rather than replacing existing community tools, JuliaSpacePhysics is designed to complement them: the ecosystem provides native, high-performance implementations for core analysis tasks alongside thin wrappers around established Python and Fortran libraries to maximize code reuse.

A defining feature of the ecosystem is its abstraction-driven design. Analysis routines are defined against abstract interfaces for time series and multi-dimensional data, decoupling scientific computation from file format, metadata standard, mission, and memory layout. A mapping-based metadata strategy ensures interoperability across ISTP, SPASE, and related conventions. This approach, combined with optimized I/O layers supporting lazy loading, memory mapping, and parallel processing, yields performance improvements of one to three orders of magnitude relative to common scripting-language implementations for tasks including moment calculations, coordinate transformations, wave analysis, dispersion solvers, and multi-spacecraft methods. These gains enable not only faster processing but qualitatively new workflows---interactive recomputation during visualization, large parameter sweeps, and ensemble-scale statistical studies---that are impractical in traditional scripting environments.

The ecosystem's decentralized architecture distributes functionality across interoperable packages built upon stable base APIs, promoting community-driven development, reducing maintenance burden, and providing a scalable foundation for future missions and analysis techniques. The remainder of this chapter introduces the core design principles, surveys the key packages, and demonstrates how this framework addresses both current and anticipated data-analysis challenges in space physics research.

== Data Discovery, Access, and Loading
<data-discovery-access-and-loading>
Historically, space physics mission data were often distributed directly by individual instrument teams or host institutions. While this model enabled early access and mission-specific expertise, it also posed challenges for data discovery, cross-mission/cross-instrument analysis, and long-term usability. Over time, a broad community consensus emerged recognizing the value of centralized data repositories or virtual observatories, which significantly lower barriers for users seeking to locate, access, and combine observations from multiple missions @erardVESPACommunitydrivenVirtual2018@genotAutomatedMultidatasetAnalysis2021.

These efforts have led to the establishment of several major space physics data archives. Notable examples in the United States include NASA Coordinated Data Analysis Web (CDAWeb) @nasacdawebdevelopmentteamCDAWebCoordinatedData2019, which provides a comprehensive repository for non-solar heliophysics data, the MADRIGAL Database, which serves upper atmospheric science observations from a wide range of ground-based and space-borne instruments, and virtual solar observatory (VSO) @hillVirtualSolarObservatory2009, which provides access to data and images from the major sources of solar data. In Europe, comparable initiatives such as Automated Multi-Dataset Analysis (AMDA) have centralized multi-mission datasets and provided advanced tools for data analysis and visualization @genotAutomatedMultidatasetAnalysis2021. Together, these archives form the backbone of modern space physics data access @burrellSnakesSpaceshipOverview2018.

Within the JuliaSpacePhysics ecosystem, these existing data infrastructures are leveraged to provide data access. Dedicated Julia client packages are developed to interface directly with established repositories, providing unified programmatic access to metadata queries, data discovery, and file retrieval across missions and instruments. For example, CDAWeb.jl provides a native Julia interface to NASA CDAWeb using their RESTful Web Service API, enabling users to query available datasets, inspect metadata, and download mission data products in a reproducible and scriptable manner. Similarly, Madrigal.jl supports access to the Madrigal Database, facilitating retrieval of ionospheric and thermospheric measurements and associated experiment metadata.
Beyond Julia-native clients, the ecosystem emphasizes wrapping and reusing mature external libraries to maximize interoperability and avoid redundant development. For solar and heliospheric data access, Julia wrappers around the Python-based SunPy ecosystem enable interaction with solar virtual observatories and related services.
This approach allows users to rely on well-established community tools for data discovery and retrieval, while performing subsequent analysis and computation within Julia.
Likewise, Speasy.jl provides access to the AMDA database and other supported services by wrapping the underlying Speasy library and exposing its functionality through idiomatic Julia interfaces.
Complementing archive-specific interfaces, the ecosystem also supports the Heliophysics Application Programming Interface (HAPI), a modern, standardized protocol for dataset discovery and access. HAPI enables browsing of distributed data catalogs, retrieval of parameter metadata, and streaming of time series data from heterogeneous web services, independent of the underlying archive implementation. #ref(<tbl-data-access>, supplement: [Table]) summarizes the data access interfaces supported by the ecosystem.

#figure(
  [
    #table(
      columns: (31.51%, 26.03%, 23.97%, 18.49%),
      align: (auto, auto, auto, auto),
      table.header([Data source / service], [Scope], [Julia package], [Data delivery]),
      table.hline(),
      [NASA CDAWeb],
      [Heliospheric & magnetospheric missions],
      [#NormalTok("CDAWeb.jl");],
      [CDF files (RESTful web services)],
      [Madrigal Database], [Ionosphere & thermosphere], [#NormalTok("Madrigal.jl");], [Experiment-specific formats],
      [AMDA], [Multi-mission plasma data], [#NormalTok("Speasy.jl");], [CDF / derived products],
      [Heliophysics Application Programming Interface],
      [Distributed time series],
      [#NormalTok("HAPIClient.jl");],
      [Streamed arrays],
      [SunPy], [Solar observatories & VO services], [#NormalTok("SunPy.jl");], [FITS / mission formats],
    )
  ],
  caption: figure.caption(
    position: top,
    [
      Data Access Interfaces in the JuliaSpacePhysics Ecosystem. All retrieved data files are cached locally to support efficient reuse and reproducible workflows.
    ],
  ),
  kind: "quarto-float-tbl",
  supplement: "Table",
)
<tbl-data-access>


A central technical foundation of many space physics archives is the Common Data Format (CDF), which remains one of the most widely used formats for in situ observations. Recognizing its importance, the JuliaSpacePhysics ecosystem includes a modern, high-performance CDF reader that exploits multi-threading and lazy access to both data and metadata. While several CDF readers already exist---notably NASA's reference C implementation and the Python package cdflib---these widely used tools do not support multi-threaded access and can become performance bottlenecks for large datasets. More recent efforts, such as CDFpp, demonstrate that substantial performance gains are possible with modern design choices. Rather than eagerly loading all variables contained in a CDF file, the Julia CDF implementation accesses only those variables explicitly requested by the user like CDFpp. This design is particularly advantageous for complex datasets containing dozens or hundreds of variables, many of which are irrelevant to a given analysis. Building on this idea, lazy loading is extended beyond the variable level to the temporal dimension.
When an analysis targets a restricted time interval, only the subset of samples within that interval is retrieved from disk, rather than loading the full time series. This fine-grained data access strategy substantially reduces I/O overhead and memory usage, leading to significant acceleration in analysis workflows.

Together, these archive-aware clients, standardized streaming interfaces, and high-performance I/O capabilities enable efficient and scalable interaction with distributed space physics data repositories. Moreover, by combining Julia-native packages with thin wrappers around established external libraries, the JuliaSpacePhysics ecosystem remains closely aligned with evolving community standards while fully leveraging Julia's performance and abstraction capabilities. Collectively, these design choices provide a robust foundation for multi-mission integration, upon which the higher-level analysis and visualization capabilities of the JuliaSpacePhysics ecosystem are built.

== Data and metadata model
<data-and-metadata-model>
=== Abstract Interfaces for Heterogeneous Data Formats and Representations
<abstract-interfaces-for-heterogeneous-data-formats-and-representations>
Space physics datasets are not only geographically and administratively distributed, but also stored in a wide range of file formats. While the Common Data Format (CDF) remains dominant for in situ time series data, many missions distribute products in additional formats. Upper-atmosphere observations are frequently provided in NetCDF @rewNetCDFInterfaceScientific1990, solar imaging data commonly use FITS @penceDefinitionFlexibleImage2010, and derived or summary products often appear in plain-text formats such as CSV. Each format reflects specific scientific and operational requirements and carries its own conventions for metadata, dimensionality, and data organization. Supporting integrative, multi-mission science across this diversity remains a fundamental technical challenge.

Existing software frameworks typically address format heterogeneity by loading disparate data products into framework-specific internal data structures. SPEDAS maps data into #emph[tplot] variables, spacepy uses #emph[datamodel] objects, and pysat employs #emph[instrument] containers @angelopoulosSpacePhysicsEnvironment2019@grimesSpacePhysicsEnvironment2022@niehofSpacePySpaceScience2022@stonebackPYSATPythonSatellite2018@stonebackPysatEcosystem2023@caiGeospaceLABPythonPackage2022. Each encapsulates both data and metadata in a file-format agnostic manner, providing consistent user interfaces and standardized access patterns. However, this approach tightly couples file format, in-memory representation, and analysis routines, making it difficult to extend to new storage backends or computational environments without substantial adaptation.

Beyond file-format heterogeneity, modern workflows introduce a second layer of diversity: runtime data representations. Data may reside in conventional CPU memory, on accelerators such as GPUs, or in distributed or memory-mapped arrays for large-scale analysis. These distinctions are largely orthogonal to file format, yet they strongly influence performance, scalability, and the feasibility of advanced workflows. Ecosystems built around fixed array abstractions (e.g., NumPy or xarray) often require refactoring or format-specific code paths to accommodate such variation.

The JuliaSpacePhysics ecosystem adopts a fundamentally different strategy. Rather than coercing all data into a single internal container, it defines analysis routines in terms of abstract interfaces for multi-dimensional time series. These interfaces preserve the semantic and structural characteristics of native data formats while exposing a common set of operations. Beyond Julia's standard array interface (#NormalTok("axes");, #NormalTok("ndims");, #NormalTok("size");, #NormalTok("similar");), domain-specific accessors are provided: #NormalTok("tdimnum(x)"); and #NormalTok("times(x)"); retrieve the time dimension and timestamps, while #NormalTok("dim(x, i)"); or #NormalTok("dim(x, name)"); access dimension-specific coordinate information.

By programming against this interface rather than concrete types, the same analysis code operates uniformly on data from different file formats and memory spaces. Julia's native support for abstract array types and multiple dispatch enables scientific routines to be decoupled from both file format and memory layout.
This abstraction-first design yields several advantages. First, it eliminates the need to normalize datasets into a framework-specific representation, reducing conversion overhead and preserving structural flexibility. Second, it allows routines to operate transparently on CPU arrays, GPU arrays, or other specialized storage backends without modification. Third, it promotes extensibility: functions written against the abstract interface automatically generalize to new formats and storage mechanisms as they are introduced. Together, these properties provide a scalable foundation for integrative space physics research as datasets grow in size, complexity, and computational demand.

=== Metadata Interoperability and Mapping Across Standards
<metadata-interoperability-and-mapping-across-standards>
Metadata are essential for the correct interpretation, visualization, and transformation of scientific measurements. Over time, multiple metadata conventions have emerged to serve different communities and infrastructures. Prominent examples include the International Solar Terrestrial Physics (ISTP) metadata conventions embedded in CDF files @lewisISTPnextMetadataGuidelines2023, which underpin a large fraction of heliospheric and magnetospheric mission products. More recently, community initiatives such as the SPASE Data Model have sought to standardize data discovery and access across archives @robertsSPASEDataModel2018.

Rather than collapsing these heterogeneous standards into a single unified schema, the JuliaSpacePhysics ecosystem adopts a mapping-based approach. Metadata originating from different sources are interpreted and translated into a small set of semantically meaningful abstract attributes consumed by analysis, visualization, and coordinate-transformation routines. Similar mapping strategies have been employed by other systems---for example, the AMDA team maps EPNcore (Europlanet core metadata) data model and SPASE dictionary elements within their internal database @genotAutomatedMultidatasetAnalysis2021.

This approach preserves the richness and intent of existing metadata standards while avoiding the rigidity and maintenance burden associated with enforcing a single global schema. In practice, high-level functions---such as plotting, unit handling, and coordinate transformations---operate consistently across datasets obtained from disparate archives. As illustrated in #ref(<fig-tplot>, supplement: [Figure]), identical visualization and transformation routines can be applied to time series retrieved from a HAPI-enabled server and from a local CDF file. Despite differences in underlying metadata formats and storage representations, physical context such as units, coordinate systems, and time bases is interpreted correctly in each case.

#figure(
  image("figures/spedas/fig1_tplot.pdf"),
  caption: [
    Time series plots from different data sources
  ],
)
<fig-tplot>


By focusing on metadata mapping rather than schema unification, the JuliaSpacePhysics ecosystem decouples scientific analysis from both data format and metadata standard. This design enhances flexibility, robustness, and forward compatibility as new archives, protocols, and metadata conventions continue to emerge.

== Accelerated Computation and Interactive Exploration
<accelerated-computation-and-interactive-exploration>
A key advantage of adopting Julia is the substantial acceleration of computational workflows, coupled with strong support for interactive scientific exploration. Julia code is just-in-time compiled via LLVM @bezansonJuliaFreshApproach2017, enabling performance comparable to statically compiled languages such as C and Fortran for many numerical workloads. At the same time, Julia preserves a high-level, expressive syntax that is well suited to mathematical and physical modeling and offers a highly developed read--eval--print loop (REPL) environment. This combination enables rapid prototyping, exploratory data analysis, and iterative refinement---capabilities that are essential when working with complex, multi-instrument space physics datasets.

These language-level advantages do not require that an entire space physics workflow be reimplemented in Julia from the outset. In a mature scientific domain, effective acceleration is more naturally achieved by first integrating with existing, well-established software ecosystems. Julia's interoperability with Python, Fortran, and C @PythonCall.jl enables a development strategy in which trusted community tools are reused for data discovery and legacy functionality, while performance-critical analysis and interactive exploration are incrementally migrated to Julia.
In this sense, interoperability serves as the first stage of acceleration: it lowers the barrier to entry, preserves continuity with existing workflows while revealing the specific computational bottlenecks that motivate targeted Julia-native development.

=== Leveraging Existing Ecosystems through Interoperability
<leveraging-existing-ecosystems-through-interoperability>
Building on this strategy, a core design principle of the JuliaSpacePhysics ecosystem is to extend, rather than replace, the extensive software infrastructure within the space physics community. By directly calling mature, well-tested libraries from other languages, the ecosystem preserves decades of domain expertise while selectively introducing Julia-native abstractions and implementations where improved performance, flexibility, or extensibility are required.

The development of this interoperability layer initially focused on enabling access to existing analysis workflows provided by the Python-based SPEDAS framework @grimesSpacePhysicsEnvironment2022. Early implementations emphasized lightweight wrappers that allowed Julia users to invoke SPEDAS functionality directly. As these hybrid workflows were applied in active research, however, performance bottlenecks and architectural constraints became apparent---particularly for large-scale, iterative analyses. (For example, although PySPEDAS heavily depends on the numpy arrays or xarray objects, the interface it exposed to users is a string where corresponding data is stored in global objects). These limitations, together with evolving requirements for extensibility, motivated a gradual expansion beyond a pure wrapper model. Over time, Julia-native components were introduced to complement existing tools, leading to a system that selectively diverges from, rather than mirrors, its Python counterparts.

Within the ecosystem, several packages provide thin, idiomatic Julia interfaces to widely used external libraries. For Python-based tools, packages such as Speasy.jl and SunPy.jl expose core functionality directly to Julia users, enabling access to established virtual observatories and data services. In these workflows, Python is typically used for data discovery and retrieval, while the resulting data arrays are transferred into Julia for subsequent processing. Utilizing the fast non-copying conversion of numeric arrays from Python to Julia in PythonCall.jl, the overhead of data transfer is neglible. This approach avoids unnecessary reimplementation of complex access logic while enabling integration with fast Julia libraries. The conceptual similarity between Julia and Python further reduces friction, allowing users to adopt these tools with minimal syntactic adaptation.
Besides python-based tools, #link("https://github.com/JuliaSpacePhysics/IRBEM.jl")[#NormalTok("IRBEM.jl");] packages provide native bindings to established Fortran libraries while simplifying installation and cross-platform distribution through Julia's package and binary management infrastructure. These interfaces expose both low-level library calls and higher-level abstractions suitable for interactive data analysis, enabling magnetic field models and coordinate transformations to be incorporated naturally into Julia workflows.

#ref(<fig-sunpy>, supplement: [Figure]) presents a sample use case of contour detection of 2D images map for AIA data using SunPy.jl. In this workflow,
The sunpy function Fido, an unified data search interface, provides the data acquisition and loading, while all subsequent analysis is performed in Julia. The data is directly memory-mapped to Julia arrays, and we utilize a Julia library #NormalTok("Contour"); to perform the contour detection. This example achieves performance improvements of approximately 20 times faster compared to equivalent operations executed within Python. This example illustrates how interoperability enables Julia to function as a high-performance analysis layer atop existing community tools.

#figure(
  image("figures/spedas/fig2_sunpy_contours.png"),
  caption: [
    Contour detection of AIA data using SunPy.jl
  ],
)
<fig-sunpy>


=== Julia-Native implementations and Performance-Critical Kernels
<julia-native-implementations-and-performance-critical-kernels>
As hybrid workflows matured, recurring performance bottlenecks became increasingly apparent, motivating the development of Julia-native implementations for core analysis routines. By reimplementing performance-critical components in Julia, the ecosystem can fully exploit just-in-time compilation, multiple dispatch, and native array semantics, while preserving a high-level and extensible programming model. Many commonly used analysis routines have therefore been translated from legacy implementations and refactored or rewritten entirely to improve both generality and performance. In many cases, these Julia-native versions are syntactically simpler and more flexible than their predecessors, while delivering substantial speedups.

A representative and nontrivial example is the Julia implementation of moment calculations provided by #NormalTok("VelocityDistributionFunctions.jl");. This implementation achieves speedups of up to two orders of magnitude compared to Python-based implementations in PySPEDAS, while supporting a wide range of input data formats in a uniform and readable manner. Velocity distribution functions may be provided as either two-dimensional (energy, angle) or three-dimensional (energy, ϕ, θ) arrays, with energy binning that can vary across angles and time or remain fixed. Using #NormalTok("CartesianIndices");, the Julia implementation expresses the underlying multidimensional algorithms directly, without requiring data reshaping or separate code paths for different dimensionalities. The resulting performance gains arise from Julia's ability to execute explicit loops at near--C speed. Unlike Python/NumPy, where performance typically depends on vectorization and the avoidance of explicit loops, Julia allows moment calculations of different orders to be fused naturally within a single loop. In Python, such loop fusion is difficult to achieve, often leading to repeated intermediate computations, less readable code, and reduced generality. In contrast, the Julia implementation simultaneously improves performance, clarity, and extensibility.

Similarly, a matrix-based plasma wave dispersion solver---originally developed in MATLAB---has been fully translated into open-source Julia implementations @zhangJuliaSpacePhysicsGeoCotransjl2026@baiBOKMComprehensiveSolver2025@xieEfficientFrameworkSolving2025@xiePDRFGeneralDispersion2014. In addition to achieving performance improvements of approximately a factor of two, the Julia version introduces a unified interface supporting multiple solver formulations, including multi-fluid models, arbitrary or analytic kinetic distributions, and analytic Product-Bi-Kappa distributions. This unified design simplifies switching between physical models and significantly reduces code duplication, improving both usability and long-term maintainability.

Comparable improvements are observed across a broad range of commonly used analysis tasks (see #ref(<tbl-speedup>, supplement: [Table]) for a summary of representative benchmarks). Coordinate transformations are approximately an order of magnitude faster than Fortran-based IRBEM routines @boscherPRBEMIRBEM2022 and up to twenty times faster than their PySPEDAS counterparts. Minimum variance analysis achieves speedups of up to three orders of magnitude relative to Python implementations while also generalizing naturally to arbitrary dimensionality. Wave polarization analysis is accelerated by approximately 250× compared to PySPEDAS @santolikSingularValueDecomposition2003 benefiting from parallelization and optimized memory management that reduce repeated allocations and redundant computations. Magnetic field model evaluations for Tsyganenko models are 100--250× faster than geopack @tsyganenkoMagnetosphericMagneticField1989, in part through lazy interpolation strategies. ulti-spacecraft analysis workflows, including spatial gradient estimation @paschmannMultispacecraftAnalysisMethods2008, similarly exhibit speedups of roughly two orders of magnitude by minimizing heap allocations and leveraging fused linear algebra operations. Across the JuliaSpacePhysics ecosystem, performance improvements of one to two orders of magnitude are typical for core computational routines, reflecting a combination of just-in-time compilation, algorithmic refactoring, reduced memory allocation, and effective parallel execution.

#figure(
  [
    #table(
      columns: (35.71%, 23.38%, 16.23%, 17.53%, 7.14%),
      align: (auto, auto, auto, auto, auto),
      table.header([Analysis Task], [Julia Package], [Reference Implementation], [Typical Data Size], [Speedup (×)]),
      table.hline(),
      [Moment calculation (density, velocity, pressure tensor)],
      [#NormalTok("VelocityDistributionFunctions.jl");],
      [PySPEDAS (NumPy-based)],
      [3D VDF, time series],
      [\~100×],
      [Minimum variance analysis (MVA)],
      [#NormalTok("MinimumVarianceAnalysis.jl");],
      [PySPEDAS],
      [Multi-component time series],
      [\~1000×],
      [Coordinate transformations],
      [#NormalTok("GeoCotrans.jl"); / #NormalTok("IRBEM.jl");],
      [IRBEM (Fortran), PySPEDAS],
      [Large time series],
      [10--20×],
      [Wave polarization analysis],
      [#NormalTok("WaveAnalysis.jl");],
      [PySPEDAS],
      [High-cadence waveform data],
      [\~250×],
      [Tsyganenko magnetic field models],
      [#NormalTok("Tsyganenko.jl"); (via IRBEM bindings)],
      [geopack],
      [Large trajectory arrays],
      [100--250×],
      [Plasma wave dispersion solver], [Julia dispersion solver], [MATLAB version], [k--ω grid sweep], [\~2×],
      [Multi-spacecraft gradient estimation],
      [#NormalTok("MultiSpacecraftAnalysis.jl");],
      [PySPEDAS],
      [4-spacecraft time series],
      [\~100×],
    )
  ],
  caption: figure.caption(
    position: top,
    [
      Performance comparison between Julia-native implementations in the JuliaSpacePhysics ecosystem and commonly used reference implementations. Benchmarks were performed on identical datasets and hardware. Reported speedups represent median wall-clock runtime ratios (reference / Julia) over multiple runs.
    ],
  ),
  kind: "quarto-float-tbl",
  supplement: "Table",
)
<tbl-speedup>


=== Tplot
<tplot>
These performance gains directly enable new modes of interactive data exploration that were previously impractical due to computational cost. One illustrative example is the extended design of the tplot-style visualization interface, originally introduced in SPEDAS. In its IDL and Python implementations, Tplot primarily supports stacked time-series visualizations composed of line and spectrogram panels. In the Julia implementations, this concept is generalized to support functions that operate directly on user-defined time intervals. This enables interactive plots in which data retrieval and derived quantities are computed on demand. This functionality is implemented using modern, high-performance plotting libraries such as Makie.jl @danischMakiejlFlexibleHighperformance2021, allowing responsive interactivity and publication-quality figure generation within a unified framework.

#ref(<fig-tplot>, supplement: [Figure]) shows a demonstration of interactive analysis where we use multi-parameter solar wind data from the OMNI dataset. In this example, multiple physical variables are visualized simultaneously, while minimum variance analysis and associated coordinate transformations are computed dynamically and displayed alongside the original time series. Users can interactively adjust the temporal range of interest, triggering on-demand data loading and recomputation of derived quantities. Owing to aggressive caching strategies and efficient data access through Julia-based CDAWeb and SPEDAS interfaces, these interactions occur with minimal latency, enabling near real-time exploratory analysis.

Together, these capabilities illustrate how high-performance computation, combined with an interactive programming environment, enables not only faster data analysis but also qualitatively new scientific workflows. The JuliaSpacePhysics ecosystem therefore supports both efficient large-scale processing and interactive, hypothesis-driven research. Importantly, these performance gains enable entire classes of analyses that were previously impractical, rather than merely accelerating existing workflows. Such analyses include large parameter sweeps, on-the-fly visualization and diagnostic evaluation for large datasets, and large ensemble or statistical studies that were often avoided due to their computational cost.

== Decentralized Development, Modular Architecture, and Ecosystem Sustainability
<decentralized-development-modular-architecture-and-ecosystem-sustainability>
Another defining feature of the JuliaSpacePhysics ecosystem is its decentralized, modular, and layered software architecture. Rather than concentrating functionality within a single, monolithic codebase, individual capabilities---such as data access, calibration, analysis methods, and visualization---are implemented as independent, focused packages that address well-defined tasks. This composable design allows each component to evolve autonomously while remaining interoperable through shared abstractions and well-defined interfaces.

This approach stands in contrast to the centralized architecture historically employed by systems such as SPEDAS in both its IDL and Python implementations. In those frameworks, mission-specific routines, calibration procedures, and data-processing pipelines are typically embedded directly within a unified package structure. While this model simplifies distribution and onboarding for end users, it can also lead to tightly coupled code, increased maintenance burden, and reduced flexibility as the scope of supported missions and instruments grows.

By contrast, the JuliaSpacePhysics ecosystem encourages decentralized development by establishing a small set of stable, extensible base APIs upon which higher-level packages can be built. New missions, instruments, or analysis techniques can be supported by developing independent modules that conform to these shared interfaces, without requiring modification of a central codebase. This separation of concerns not only improves maintainability but also lowers the barrier for community contributions, as developers can focus on domain-specific functionality within self-contained packages.

Several examples illustrate this structure. For example, mission-focused DMSPData.jl @zhangJuliaSpacePhysicsDMSPDatajl2025@redmonNewDMSPDatabase2017 provides convenient utilities for accessing and processing Defense Meteorological Satellite Program (DMSP) data (such as precipitating particle fluxes and plasma data), while Madrigal.jl serves as the foundational package for querying metadata and downloading files from the Madrigal Database. It is ready to use #NormalTok("IRBEM.jl"); to compute magnetic field coordinates for conjunction study. Similarly, ELFINData.jl (as an example of a CDF-based loader) are built atop the ecosystem's CDF handling libraries, which provide efficient access to CDF files and utilize #NormalTok("VelocityDistributionFunctions.jl"); to derives directionally resolved flux spectra (omni, para, anti) and/or pitch-angle spectra.

In the heliospheric domain, packages dedicated to energetic particle (EP) analysis---such as #NormalTok("SolarEnergeticParticles.jl");---leverage lower-level data-access tools #NormalTok("Speasy.jl"); to retrieve measurements from missions including Parker Solar Probe, Solar Orbiter, and STEREO via NASA CDAWeb. It contains onset determination analysis and velocity Dispersion Analysis for determining solar particle release times and propagation characteristics by analyzing the energy-dependent arrival times of EPs. By relying on the shared I/O layer, these packages can focus exclusively on mission-specific variable conventions, derived products and analysis functions, without reimplementing file-format logic.

This decentralized model aligns well with the collaborative and evolving nature of space physics research. As new missions are launched and new analysis requirements emerge, the ecosystem can grow organically through the addition of interoperable modules, rather than through continual expansion of a single centralized framework. In this way, JuliaSpacePhysics provides a scalable and sustainable software foundation for long-term community-driven development.

== Summary and Outlook
<summary-and-outlook>
In this paper, we have introduced the JuliaSpacePhysics ecosystem, an effort to provide modern, high-performance tools for space physics data access, analysis, and visualization. By leveraging the capabilities of the Julia programming language---including just-in-time compilation, multiple dispatch, and abstract array interfaces---the ecosystem delivers accelerated data processing while preserving flexibility and interoperability with existing community infrastructure.

The ecosystem's design philosophy emphasizes modularity, abstraction, and interoperability. Dedicated client packages provide access to major space physics data repositories, while high-performance I/O layers enable efficient handling of widely used formats such as CDF. Analysis routines are implemented against abstract interfaces rather than concrete data containers, allowing them to operate transparently across heterogeneous data formats and memory backends. This approach decouples file format, metadata standard, and computational representation, thereby facilitating integrative, multi-mission studies. The resulting architecture enables not merely improved execution speed, but entirely new scientific workflows: accelerated computation and efficient data access support interactive exploratory analysis, large-scale statistical studies, and parameter sweeps that would be computationally prohibitive in traditional environments.

Currently, the JuliaSpacePhysics ecosystem focuses on observational data analysis and does not yet support numerical modeling or large-scale simulation. Nevertheless, many of the abstractions and analysis interfaces developed here are sufficiently general to extend to simulation outputs. The same time series interfaces, coordinate transformation utilities, and analysis routines can naturally support model--data comparisons and advanced system-level studies.

Looking forward, continued community engagement and modular development will be essential for broadening mission coverage and expanding into simulation and modeling domains. By combining high performance, decentralized package design, and strong interoperability with existing tools, the JuliaSpacePhysics ecosystem provides a scalable and sustainable computational foundation for next-generation space physics research, particularly for processing data from multi-spacecraft and high-cadence missions.
