# Brief 04 — Catalog the summary statistics reported in the INSPIRE study papers

**Date issued:** 2026-10-10
**Context:** The supervisor decided to build the workshop dataset by **simulating** mother–infant
dyad data from the summary statistics published in the INSPIRE study papers, instead of obtaining
real per-sample data. This brief is step 1: find and extract every usable summary statistic.
Do **not** simulate anything yet; that is the next brief.

## How to work (read first)

This is an unattended run. **No human will reply to you.** Do not stop to summarize your plan or
wait for confirmation. Start immediately and keep working until the deliverable exists.

- Scratch scripts and temp files go **only** in `scratch/brief04/`. Deliverables go in `data/inspire/`.
  Put nothing in the repository root.
- Use `python` with `pdfplumber` (installed) for text and table extraction. If `pdfplumber` cannot
  read a table (e.g. it is an image), try `pymupdf` (`pip install pymupdf`) to render the page to PNG
  and record that the table is not machine-extractable. Do not guess numbers you cannot read.
- Write multi-line Python to files in `scratch/brief04/` and run them; do not inline multi-line
  code in the shell.

## Input (read-only)

Eight PDFs in this folder. **Read them in place. Do not copy them into the repository.**

`C:\Users\sharo\OneDrive\Graduate school\Research\Papers\Inspire Study\`

1. McGuire et al. 2017 — HMO concentrations and profiles vary geographically (AJCN)
2. Ruiz et al. 2017 — Immune profiling of milk across geographical settings (Front Immunol)
3. Lackey et al. 2019 — Microbiomes in milk and infant feces vary geographically (Front Nutr)
4. Lane et al. 2019 — Household composition and the infant fecal microbiome
5. McGuire et al. 2021 — IgA and IgG antigen specificity in milk
6. Pace et al. 2021 — Variation in milk composition related to milk and infant fecal microbes
7. Caffé et al. 2023 — Milk immune factors, maternal nutritional status, infant sex
8. Ambalavanan — HMOs, maternal genetics, and respiratory health

## What to extract

For **every** table, and every figure whose numbers are stated in the text or legend, that reports
a summary statistic **by population/site/group**, capture:

- data type (milk microbiome, infant fecal microbiome, HMO, immune factor, antibody, macronutrient,
  mineral, maternal/infant characteristic, other)
- analyte or taxon name, exactly as printed
- group (population/site name as printed; also any other grouping such as secretor status, infant sex)
- n for that group
- statistic type (mean, median, geometric mean, SD, SE, IQR, range, % prevalence/detection, relative abundance)
- value and unit
- paper and table/figure number, page number

Also capture, per paper:
- the list of populations/sites and the n per site
- any reported **correlations or associations between data types** (e.g. HMO vs milk microbiome,
  immune factor vs HMO), with the statistic reported (r, rho, p, effect size) — these matter for
  simulating realistic joint data
- any statement that the same mothers/samples were used across papers (sample overlap)
- the HMO list, immune-factor list, and taxon list used, in full

## Deliverables

1. `data/inspire/catalog.md` — one section per paper: citation, populations and n, data types,
   a list of every summary-stat table/figure with what it contains, and whether it was extracted
   to CSV or marked **NOT EXTRACTABLE**. End with a **feasibility section**: for each data type,
   is there enough (center + spread + n per population) to simulate per-sample values by population?
   Which ≥3 data types can be simulated for the same populations? What correlation information exists?
2. `data/inspire/summary_stats/<paper_short>_<table>.csv` — one tidy CSV per extracted table, with
   columns: `paper, table, page, data_type, analyte, group, group_type, n, statistic, value, unit, notes`.
   Long format: one row per analyte × group × statistic.
3. `data/inspire/summary_stats/ALL_summary_stats.csv` — all of the above concatenated.
4. `data/inspire/extraction_log.md` — numbered log of every PDF page/table read and every extraction
   attempt, including failures.

Mark anything uncertain as **UNVERIFIED** and anything unreadable as **NOT EXTRACTABLE**.
Never invent or round-trip numbers from memory; every value must come from the PDF text or tables.
