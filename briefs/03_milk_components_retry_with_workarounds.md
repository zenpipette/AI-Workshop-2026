# Brief 03 — Retry the pre-processed milk-components search with working download routes

**Builds on:** brief 02 and its report `data/milk_components_preprocessed_report.md` (2026-10-10).
Read that report first; do not repeat work it already verified.
**Date issued:** 2026-10-10

## How to work (read first)

This is an unattended run. **No human will reply to you.** Do not stop to summarize your plan or
wait for confirmation. Start immediately and keep working until the deliverable exists.

- Scratch scripts, downloaded HTML/JSON, and temp files go **only** in `scratch/brief03/`.
  Deliverables go in `data/`. Verified data tables go in `data/raw_downloads/<dataset>/`.
  Put **nothing** in the repository root.
- Use `curl.exe` and `python` (pandas, openpyxl installed; `pip install pdfplumber` if needed).

## What changed since brief 02

1. **New hard requirement: a microbiome layer is mandatory.** Every candidate must have a
   processed per-sample microbiome abundance table (16S or shotgun, milk and/or infant stool).
   Milk microbiome counts as one of the milk component layers; infant stool microbiome is
   required for dyad plots but does not count as a *milk* layer.
2. The ≥3 milk component layers, ≥2 groups, dyad ID, and open-access rules still apply.
3. **Also report the best ≥2-layer fallbacks** (microbiome + one other milk component) in a
   separate section, so the supervisor can decide whether to relax the 3-layer rule.
4. **Tables inside supplementary PDFs now count** *if* they are per-sample (one row per
   sample/dyad) and you can extract them to CSV with `pdfplumber`. Summary-statistics tables
   (means ± SD per group) do not count.

## Download routes that work (verified by the supervisor today)

Brief 02 was blocked by PMC and publisher anti-bot pages. These routes bypass that:

- **Europe PMC supplementary bundle** — one zip with every supplementary file of an article:
  `https://www.ebi.ac.uk/europepmc/webservices/rest/<PMCID>/supplementaryFiles`
  Verified on PMC13589485 (MAMI): returned mmc1.pdf, mmc2.xlsx, mmc3.csv, mmc4.csv, mmc5.pdf.
  It is **slow** (about 5 minutes for 5 MB). Use `curl.exe -sL --max-time 900 -o file.zip`.
  Run several in parallel via subagents. Check the zip is complete with `python -c "import zipfile;zipfile.ZipFile('f.zip').testzip()"`.
- **DataCite search** for dataset discovery (Zenodo search is rate-limited from this machine):
  `https://api.datacite.org/dois?query=<terms>&resource-type-id=dataset&page[size]=25`
  Covers Zenodo, Figshare, Dryad, Mendeley Data, Dataverse, OSF records.
- **Zenodo record-by-ID API** still works: `https://zenodo.org/api/records/<id>`.
- **Figshare API** works: `https://api.figshare.com/v2/articles/<id>` lists files with download URLs.
- Europe PMC full-text XML works: `.../rest/<PMCID>/fullTextXML` — use it to find PMCIDs,
  supplementary file names, and data-availability statements.

## Specific leads to run down (in priority order)

1. **Johnson et al. 2024, Cell Genomics (MILK cohort HMOs).** Report 01 found 4 figshare links in
   its full text. Individual-level data is dbGaP-controlled, but check whether any figshare file
   holds per-sample HMO values or milk composition. If yes, MILK (already verified, 195 dyads,
   milk+stool metagenome in `data/raw_downloads/MILK_zenodo/`) gains a second layer. Also check
   whether MILK has any other open milk tables (fatty acids, macronutrients) in that or other
   companion papers (Fields, Demerath, Blekhman labs).
2. **MAMI (PMC13589485)** — the supplement zip is in the supervisor's scratch and the brief-02 report
   describes its contents. mmc1.pdf holds Tables S1 and S4 (HMO-bearing). Download via Europe PMC,
   extract with pdfplumber, and determine whether the HMO table is per-sample or summary-only.
   Also fetch the companion Rio-Aige 2023 Front Nutr (sIgA/cytokines) and Cortes-Macías 2021 J Nutr
   (milk 16S) supplements the same way and check for per-sample tables.
3. **Masi et al. 2024 (PMC11524953)** — fetch mmc1.pdf/mmc2.pdf via Europe PMC and check with
   pdfplumber whether per-sample HMO or taxonomy tables are inside. Also check its companion milk
   microbiome paper (PRJEB39610; Masi/Stewart/Embleton lab, Newcastle) for processed tables.
4. **Figshare 29923796** — "Supplementary Materials and Source Data for 'Human Milk Oligosaccharides
   and Infant Gut Microbiome...'". List files via the Figshare API and open them.
5. **Davis 2017 Gambia (PMC5227965)** and **Karampatsas 2022 (find PMCID)** — fetch supplements via
   Europe PMC; these may give HMO + microbiome, or metabolome + microbiome, as ≥2-layer fallbacks.
6. **Corona-Cervantes 2026 (PMC12818807)** — report 01 says HMO values are in a supplementary .docx.
   Fetch via Europe PMC and open with python-docx. Check for per-sample values.
7. **Arishi/Stinson 2025 Nutrients and 2026 Front Cell Infect Microbiol** — find PMCIDs via Europe PMC
   search, fetch supplements. This lab reports HMOs + fatty acids + protein + milk 16S.
8. Run **DataCite** queries: "human milk" + (oligosaccharide | fatty acid | metabolome | microbiome)
   + (infant | dyad), resource type dataset. Open every hit that looks like a mother–infant cohort.

## Verification rules

Same as brief 02: open every table, record rows × columns, confirm a sample/dyad ID column and a
group column, record the exact URL and file size. Mark anything not opened as **UNVERIFIED**.
Numbered verification log of every query and download.

## Deliverable

Write `data/milk_components_report_03.md` with:

1. **Ranked table** of candidates meeting all hard requirements (microbiome + ≥3 milk layers +
   ≥2 groups + dyad ID + open), same columns as brief 02.
2. **Fallback table** of candidates with microbiome + ≥2 milk layers (or microbiome + 1 milk layer
   if that is all that exists), same columns.
3. **Top picks in detail** — exact files, rows × columns, group sizes, dyad ID column, what is missing.
4. **Verification log.**
5. **Ruled out**, with the requirement each failed.
6. **One-paragraph recommendation** for which dataset to use for workshop visualizations.

Save every verified table under `data/raw_downloads/<dataset>/` and list it in the report.
