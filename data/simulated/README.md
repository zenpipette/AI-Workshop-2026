# data/simulated/ — SIMULATED INSPIRE-like mother–infant dyad dataset

> **SIMULATED DATA.** Values were generated from summary statistics published in the
> INSPIRE study papers (McGuire 2017 AJCN; Ruiz 2017 Front Immunol; Lackey 2019 Front
> Nutr; Lane 2019 AJPA; McGuire 2021 Front Immunol; Pace 2021 Microorganisms; Caffé
> 2023 AJHB). **No individual-level INSPIRE data were used.** Individual values are
> synthetic; only group-level patterns resemble the published results. This dataset
> must never be presented as the original INSPIRE data.

This folder contains a synthetic dataset of **410 mother–infant dyads** across the
**11 INSPIRE cohorts**, built for the *Teaching visualizations of milk components and
microbiome* Shiny dashboard (brief 06). It was simulated in R from the published
summary statistics catalogued in `data/inspire/summary_stats/` (see
`data/inspire/catalog.md`), following brief `briefs/05_simulate_inspire_dyads_R.md`.

## How the dataset was made (plain language)

**Study skeleton.** We created 410 virtual dyads at the same sample sizes as the real
study (McGuire 2017 Table 1): ETR 40, ETU 40, GBR 40, GBU 40, GN 40, KE 42, PE 43,
SP 41, SW 24, USW 41, USC 19. Each dyad gets an ID (e.g. `INS-ETR-001`), a cohort
code, a country, an income region (LMIC/HIC), and a rural/urban setting.

**Maternal & infant characteristics.** Age, parity, weight, height, BMI and days
postpartum are drawn from cohort-specific truncated normal distributions calibrated
to the published mean ± SEM (McGuire 2017 T1). Delivery mode and secretor status are
drawn at the exact per-cohort percentages printed in Ruiz 2017 T1 and McGuire 2017
Fig 3; exclusive breastfeeding at the Lane 2019 per-population proportions (Pace
2021 overall 60% where a cohort is missing, flagged). Household size, siblings,
extended family and father presence use the Lane 2019 Table 1 means/SDs (USC: pooled
value, flagged).

**Secretor status.** Each cohort's percentage of secretors follows the printed values
(PE 98%, USC 95%, GN 68%, USW 68%, GBR/ETR 65%; cohorts without a printed value are
set to 80% and flagged). In non-secretors, the α1-2-fucosylated HMOs 2'FL, LNFP I and
DFLac are set to near-zero (≤2% of the cohort mean) and LNT/LNFP II are increased
×1.3, exactly as described in McGuire 2017; cohort means are then re-calibrated to
match the published "all women" total means.

**HMOs (19 + total, nmol/mL).** Log-normal per cohort (mean/SEM from McGuire 2017
Table 2, SD = SEM·√n, method-of-moments on the raw scale), correlated across analytes
via a Gaussian copula reproducing the published Spearman correlations (2'FL~LNFP I
0.74, 6'SL~LSTc 0.65, LNT~LNnT 0.75, LNFP I~II −0.46, LNT/LNnT~DSLNT 0.60/0.62,
2'FL~small-HMOs 0.98) and the maternal-trait correlations from the McGuire 2017
Fig 4 text. The total is the computed sum and lands within 0.1% of the published
per-cohort totals.

**Immune factors (23 analytes, ng/L).** Zero-inflated log-normal: each analyte is
present with the published per-site detection frequency (Ruiz 2017 T2), and detected
values follow a log-normal matched to the published median and IQR (T3–T5); the ETR
cohort is NA by design (chemically preserved milk) with `immune_measured = FALSE`.
IgG/IgM/IL-10 are tilted slightly for the female-infant × maternal-DDS interaction
reported in Caffé 2023 (Table 3 LME betas).

**Milk & infant fecal microbiomes (29 / 28 genera, % relative abundance).** Genera
are drawn per cohort from a Dirichlet-style (gamma + renormalisation) composition
whose concentration is matched to the published SEMs (Lackey 2019 T5/T2) and whose
column means are raked to the published cohort means; presence is masked to the
printed prevalence % (T3) with an "unclassified remainder" bucket absorbing the
difference where printed means sum to less than 100%. Dyad links from Pace 2021 are
imposed with a rank-order copula: milk~fecal Lactobacillus ρ ≈ 0.36, Bifidobacterium
ρ ≈ −0.18. Richness/Shannon/inverse-Simpson are computed from the simulated
compositions and compared with Lackey 2019 T4 in the validation report (richness is
systematically lower — a known limitation).

**Milk antibodies (IgA/IgG; 8 pathogens × breadth / top-10 / all-antigen
reactivity).** Truncated-normal per cohort on the printed mean [SEM] (McGuire 2021
T1/T2): breadth in (0.01, 0.99), reactivity around the mean allowing the small
negative intensities printed in the paper.

**Macronutrients.** Lactose (79.2 ± 11.0 g/L) and protein (15.0 ± 2.8 g/L) come from
the **overall** Pace 2021 distributions only — per-cohort values are figure-only in
the paper, so these two variables are *not cohort-specific* (flagged in provenance).

## Files

| file | contents |
|---|---|
| `simulated_dyads.csv` | one row per dyad, wide: metadata + all layers (183 columns) |
| `simulated_hmo_long.csv` | tidy: dyad_id, cohort, analyte, value, unit (19 HMOs + total) |
| `simulated_immune_long.csv` | tidy immune analytes (23; `ng/L`, ETR = NA) |
| `simulated_milk_microbiome_long.csv` | tidy milk genera (29 printed + unclassified remainder) |
| `simulated_fecal_microbiome_long.csv` | tidy fecal genera (28 printed + unclassified remainder) |
| `simulated_antibodies_long.csv` | tidy antibody metrics (IgA/IgG × 8 pathogens × 3 metrics) |
| `provenance.csv` | one row per simulated variable: source paper, table, statistic used, distribution assumed, assumption flags |
| `data_dictionary.csv` | every column in the wide file: name, layer, unit, description |
| `validation_report.md` | simulated vs published per-cohort statistics, correlation recovery, and known limitations |
| `params_*.csv`, `params_lookup.json` | the published-parameter tables the simulation drew from (built by `R/01_load_summary_stats.R`) |

## How to regenerate

From the project root (R 4.5.1; packages: dplyr, tidyr, readr, purrr, MASS, jsonlite):

```r
Rscript R/01_load_summary_stats.R   # parse catalogued summary stats -> params_*.csv
Rscript R/02_simulate_dyads.R       # simulate (seed 2026) -> simulated_*.csv + provenance + dictionary
Rscript R/03_validate_simulation.R  # compare vs published -> validation_report.md
```

## Known limitations

- Figure-only values were **not** used: secretor % for 5 cohorts is assumed 80%
  (flagged); per-cohort lactose/protein are not printed anywhere and are simulated
  from the overall distributions only.
- ETR has no immune data (chemically preserved milk in Ruiz 2017) — its 23 immune
  analytes are NA with `immune_measured = FALSE`.
- Diversity indices are computed from the 28–29 printed genera plus a remainder
  bucket; rarefied richness in Lackey 2019 T4 counts *all* sequenced taxa, so
  simulated richness is lower by design (see validation report §10).
- Antibody breadth cells printed as 0 are floored at 0.01; immune cells printed `nd`
  (below detection) use the pooled cross-cohort median for their upper-tail draws.
- Individual values are synthetic. Only cohort-level patterns (means, dispersion,
  detection rates, printed correlations) resemble the published results; any
  dyad-level or between-analyte pattern beyond those printed is a modelling artefact,
  not a finding.

## Citations

1. McGuire MK, Meehan CL, McGuire MA, Williams JE, Foster J, Sellen DW, Kamau-Mbuthia EW, Kamundia EW, Mbugua S, Moore SE, Prentice AM, Kvist LJ, Otoo GE, Brooker SL, Price WJ, Shafii B, Placek CD, Lackey KA. *What's normal? Oligosaccharide concentrations and profiles in milk produced by healthy women vary geographically.* Am J Clin Nutr 2017;105:1086–1100.
2. Ruiz L, Espinosa EA, Ruiz MJ, et al. *Immune profiling of human milk across geographical settings: the INSPIRE Study.* Front Immunol 2017;8:696.
3. Lackey KA, Williams JE, Meehan CL, et al. *What's normal? Microbiomes in human milk and infant feces are related to each other and vary geographically.* Front Nutr 2019;6:45.
4. Lane AA, McGuire MK, McGuire MA, et al. *Household composition and the infant fecal microbiome: the INSPIRE Study.* Am J Phys Anthropol 2019;169:526–539.
5. McGuire MK, Randall AZ, Seppo AE, et al. *Breadth and functionality of antibody reactivity to enteric and systemic antigens in human milk.* Front Immunol 2021;11:614372.
6. Pace RM, Williams JE, Jahnke JR, et al. *Variation in milk composition related to milk and infant fecal microbiomes: the INSPIRE Study.* Microorganisms 2021;9:1153.
7. Caffé B, Williams JE, Meehan CL, et al. *Maternal nutritional status and infant sex interact to determine human milk immune factor concentrations in diverse geographic settings.* Am J Hum Biol 2023;35:e23943.
