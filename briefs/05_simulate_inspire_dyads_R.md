# Brief 05 — Simulate an INSPIRE-like mother–infant dyad dataset in R from the catalogued summary statistics

**Date issued:** 2026-10-10
**Inputs:** `data/inspire/catalog.md`, `data/inspire/summary_stats/*.csv` (verified by the supervisor
against the PDFs), and the PDFs themselves (read-only, same folder as brief 04) if you need a detail.
**Downstream use:** an R Shiny dashboard (next brief) for teaching visualizations of milk components
and microbiome by population group. Write everything in **R** so it carries straight into Shiny.

## How to work (read first)

Unattended run. **No human will reply to you.** Do not stop to summarize or ask; keep working until
every deliverable exists. Scratch files only in `scratch/brief05/`. Deliverables in `R/` and
`data/simulated/`. Nothing in the repository root. R 4.5.1 is installed (`Rscript` on PATH); install
any packages you need into the user library with `install.packages()` (CRAN mirror
`https://cloud.r-project.org`). Keep dependencies small: base R, `dplyr`, `tidyr`, `readr`,
`MASS` or `mvtnorm`, `jsonlite`. Set `set.seed(2026)` once at the top so the output is reproducible.

If a previous partial run left files in `R/` or `data/simulated/`, read them first and continue from
where they stop rather than starting over.

## MANDATORY DISCLOSURE — applies to every output file

This dataset is **SIMULATED** from published summary statistics. It is **not** the original INSPIRE data
and must never be presented as such. Every deliverable must carry this notice prominently:

> SIMULATED DATA. Values were generated from summary statistics published in the INSPIRE study papers
> (McGuire 2017 AJCN; Ruiz 2017 Front Immunol; Lackey 2019 Front Nutr; Lane 2019 AJPA; McGuire 2021
> Front Immunol; Pace 2021 Microorganisms; Caffé 2023 AJHB). No individual-level INSPIRE data were used.
> Individual values are synthetic; only group-level patterns resemble the published results.

Put it (a) as the first lines of `data/simulated/README.md`, (b) as a comment header in every R script,
(c) in the validation report header, and (d) prefix every data file name with `simulated_`.

## Design

**Units.** One row per mother–infant dyad. Cohorts and n per cohort as in McGuire 2017 Table 1/2:
ETR 40, ETU 40, GBR 40, GBU 40, GN 40, KE 42, PE 43, SP 41, SW 24, USW 41, USC 19 (total 410).
Give each dyad `dyad_id` (e.g. `INS-ETR-001`), `cohort` (11-level factor with full names as well as codes),
`country`, `region_income` (LMIC vs HIC as used in McGuire 2021), and `setting` (rural/urban where defined).

**Layers to simulate (all per dyad, linked by `dyad_id`):**

1. **Maternal & infant characteristics** — age, parity, BMI, weight, height, days postpartum (mean ± SEM
   per cohort from McGuire 2017 T1 / Lackey 2019 T1 → SD = SEM·√n; truncate to plausible ranges);
   delivery mode (vaginal % per site from Ruiz 2017 T1; overall 86% from Pace 2021 where a site is missing);
   infant sex (50/50); exclusive breastfeeding (60% overall, Pace 2021); household size and sibling
   presence (Lane 2019 T1 by population; USC missing → use pooled values and flag).
2. **Secretor status** — per-cohort % where printed (McGuire 2017 Fig 3 text: PE 98, USC 95, GN 68, USW 68,
   GBR/ETR ~65); for cohorts without a printed value use 80% and flag the assumption in provenance.
   Non-secretors: set 2'FL, LNFP I, LDFT, DFLac to near-zero (≤2% of secretor mean) and increase LNT/LNFP II
   modestly, as the paper describes.
3. **HMOs (19 + total)** — per-cohort mean ± SEM, nmol/mL (McGuire 2017 T2). Simulate **log-normal**
   (paper analysed log values): derive SD = SEM·√n on the raw scale, convert to log-scale parameters by
   method of moments. Impose published correlations with a **Gaussian copula**: 2'FL~LNFP I 0.74,
   6'SL~LSTc 0.65, LNT~LNnT 0.75, LNFP I~LNFP II −0.46, LNT~DSLNT 0.60, LNnT~DSLNT 0.62, 2'FL~small-HMO
   sum 0.98 (approximate), plus the maternal-trait correlations listed in `mcguire2017_correlations_text.csv`.
   Compute total HMO as the sum; check it lands near the published total.
4. **Immune factors (23 analytes)** — median + IQR per site (Ruiz 2017 T3–T5), **zero-inflated log-normal**:
   detection probability from Ruiz T2 detection %; detected values log-normal with log-median = log(median)
   and log-SD from IQR (IQR/1.349 on the log scale). ETR has no immune data → `NA` for all 23 analytes with
   an `immune_measured = FALSE` flag. Impose Caffé 2023 directions lightly (IgG higher with infant female × DDS);
   do not over-engineer.
5. **Milk microbiome (29 genera, relative abundance %)** — per-cohort mean ± SEM (Lackey 2019 T5) and
   % prevalence (T3). Simulate per dyad: presence by prevalence; abundances from a **logit-normal** or
   **Dirichlet** draw centred on cohort means with dispersion matched to the SEMs; renormalise rows to 100%.
   Also simulate the diversity indices (Lackey T4) consistently, or compute richness/Shannon from the
   simulated abundances and report how they compare to T4.
6. **Infant fecal microbiome (28 genera)** — same approach from Lackey 2019 T2/T3/T4.
   Impose dyad links: milk~fecal Lactobacillus rho ≈ 0.36, milk~fecal Bifidobacterium rho ≈ −0.18 (Pace 2021).
7. **Milk antibodies** — IgA and IgG breadth score and reactivity for 8 pathogens, mean [SEM] per cohort
   (McGuire 2021 T1/T2); normal, truncated to the valid range.
8. **Macronutrients** — lactose and protein (g/L) from Pace 2021 overall mean ± SD only (no per-cohort
   values printed); simulate from the overall distribution and **flag as not cohort-specific**.

Normalise analyte names when loading: replace `#` with `'` (e.g. `2#FL` → `2'FL`, `3#SL` → `3'SL`,
`6#SL` → `6'SL`); fix `INFγ` → `IFNγ`. Use consistent, plot-friendly column names (ASCII, snake_case,
e.g. `hmo_2fl_nmol_ml`, `imm_il6_ng_l`, `milk_g_streptococcus_pct`, `fecal_g_bifidobacterium_pct`).

## Deliverables

- `R/01_load_summary_stats.R` — reads the catalog CSVs, normalises names, builds tidy parameter tables.
- `R/02_simulate_dyads.R` — the simulation; writes the data files below. Must run end-to-end with
  `Rscript R/02_simulate_dyads.R` from the project root in under ~2 minutes.
- `R/03_validate_simulation.R` — recomputes per-cohort mean/SEM (or median/IQR, prevalence) from the
  simulated data for every simulated variable and compares with the published value; writes
  `data/simulated/validation_report.md` with a table (variable, cohort, published, simulated, relative
  error) and a summary of how many variables are within 10% / 25% of target, plus the realised
  correlations vs the imposed ones.
- `data/simulated/simulated_dyads.csv` — one row per dyad, **wide**: metadata + all layers (~150 columns).
- Long tidy versions for plotting: `simulated_hmo_long.csv`, `simulated_immune_long.csv`,
  `simulated_milk_microbiome_long.csv`, `simulated_fecal_microbiome_long.csv`,
  `simulated_antibodies_long.csv` (columns: dyad_id, cohort, analyte/taxon, value, unit).
- `data/simulated/provenance.csv` — one row per simulated variable: variable, layer, source paper, table,
  statistic used, distribution assumed, assumptions/flags (e.g. "secretor % assumed 80%",
  "not cohort-specific").
- `data/simulated/data_dictionary.csv` — every column in the wide file: name, layer, unit, description.
- `data/simulated/README.md` — the disclosure notice first, then: what the dataset is, how it was made
  (one paragraph per layer, plain language suitable for a presentation slide), the cohort table, the
  known limitations (figure-only values not used, assumed secretor rates, macronutrients not by cohort,
  ETR immune NA), how to regenerate (`Rscript` commands), and full citations of the seven papers.

Finish by running all three scripts in order from a clean state and confirming they succeed. The run is
complete only when `data/simulated/validation_report.md` exists and the README is written.
