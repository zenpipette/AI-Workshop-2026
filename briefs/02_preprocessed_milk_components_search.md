# Brief 02 — Find PRE-PROCESSED mother–infant dyad datasets with ≥3 milk components and ≥2 comparison groups

**Supersedes:** the search that produced `data/dyad_dataset_report.md` (2026-10-09).
**Date issued:** 2026-10-10

## How to work (read first)

This is an unattended run. **No human will reply to you.** Do not stop to summarize your plan,
ask questions, or wait for confirmation. Begin searching immediately and keep working, turn after
turn, until the deliverable file below exists with all four sections filled in. Your only final
message should be a two-line summary written after the report file is saved.

On this Windows machine use `curl.exe` (the real binary, not the PowerShell alias) and `python`
for downloads and for opening XLSX/CSV files (`pip install openpyxl pandas` if needed).

## What changed and why

The first search ranked datasets mainly by raw sequencing availability (SRA/ENA accessions).
That is not what we need. The goal is example visualizations for a teaching workshop, so we
need tables that can be plotted directly, with no sequence processing. **Raw reads do not count.**

## Hard requirements (all must be met)

1. **Pre-processed, downloadable tables.** Per-sample (or per-dyad) numeric values already
   computed, in a file we can open: CSV/TSV/XLSX, a journal supplementary table, Zenodo,
   Figshare, Dryad, OSF, MetaboLights/Metabolomics Workbench processed results, Qiita/MGnify
   abundance tables, or a GitHub data folder. A BioProject/SRA accession with raw FASTQ only
   does **not** satisfy this.
2. **At least 3 distinct milk component layers**, each as a per-sample table. Acceptable layers
   include (any combination):
   - milk microbiome (taxonomic abundance table, 16S or shotgun — must be the processed table)
   - human milk oligosaccharides (HMOs; concentrations per HMO per sample)
   - milk fatty acids / lipid profile
   - milk proteins / immune factors (sIgA, lactoferrin, cytokines)
   - milk metabolome (NMR / MS metabolite table)
   - milk macronutrients (fat, protein, lactose, energy)
   - milk hormones (leptin, adiponectin, insulin, cortisol)
   - milk minerals / vitamins
3. **At least 2 comparison groups** defined in the metadata, so plots can contrast groups.
   Examples: delivery mode (vaginal vs C-section), intervention vs control, geographic
   region/country, maternal BMI class, secretor vs non-secretor, term vs preterm,
   lactation stage/time point, allergy or disease outcome.
4. **Mother–infant dyads** with the mother ID (or dyad ID) present in the tables so milk and
   infant samples can be linked.
5. **Open access**: downloadable today without an application or data-use agreement.

## Nice to have (rank higher if present)

- Infant stool microbiome **processed abundance table** (not raw reads) for the same dyads.
- Longitudinal sampling (≥2 time points).
- ≥40 dyads.
- Metadata in a machine-readable file rather than inside a PDF.

## Where to look (do not limit yourself to these)

- Zenodo, Figshare, Dryad, OSF — search "human milk" + oligosaccharide / fatty acid / microbiome.
- MetaboLights and Metabolomics Workbench — look for studies with *processed* result tables
  (e.g. Metabolomics Workbench "Data" tab, MetaboLights `m_*_maf.tsv` files).
- Qiita and MGnify — processed microbiome tables for milk studies.
- Journal supplementary files of dyad papers (Cell Rep Med, Nat Commun, Gut Microbes, Am J Clin
  Nutr, J Nutr, Nutrients, Front Nutr, mSystems, Microbiome). Download and open the supplement to
  confirm the values are actually there.
- Re-check the candidates from report 01 under the new criteria: MILK (Zenodo 17317218), MAMI,
  Karampatsas 2022 Gambia (PRJEB41404, milk metabolomics), Corona-Cervantes 2026 Mexico,
  Masi 2024 preterm NEC, Arishi/Stinson Western Australia (fatty acids + HMOs + protein).
- Consider multi-country milk composition studies that may not have infant stool but have
  rich milk tables (e.g. INSPIRE / McGuire multi-population milk study; Gridneva/Geddes lab
  WA cohorts; Danish SKOT/COPSAC; Finnish STEP; Norwegian; Chinese MING).

## Verification rules (same as report 01)

- Actually download or open each table and confirm: rows = samples, columns = components,
  group variable present, dyad/mother ID present. Record file name, size, and the exact URL.
- Mark anything you could not open as **UNVERIFIED**.
- Keep a numbered verification log of every query and download attempted.

## Deliverable

Write `data/milk_components_preprocessed_report.md` containing:

1. **Ranked table** — one row per dataset with columns:
   dataset/paper | n dyads | component layers present (list) | group variable(s) |
   infant stool processed table? (Y/N) | time points | where the files live (URL) |
   file format | dyad ID column name | access | notes/caveats.
2. **Top 3 in detail** — for each: exact download links for every table, what each file
   contains (rows × columns), the group variable and group sizes, and anything missing.
3. **Verification log**.
4. **Ruled out** — candidates checked and why they failed (which requirement).

Do **not** download raw sequencing data. Keep downloaded tables (if any) under
`data/raw_downloads/<dataset_name>/` and list them in the report.
