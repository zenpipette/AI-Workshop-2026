# =============================================================================
# R/03_validate_simulation.R
# Brief 05 - INSPIRE-like simulated dataset
#
# SIMULATED DATA NOTICE: this report describes SIMULATED data. It is NOT the
# original INSPIRE data and must never be presented as such. Values were
# generated from summary statistics published in the INSPIRE study papers
# (McGuire 2017 AJCN; Ruiz 2017 Front Immunol; Lackey 2019 Front Nutr;
# Lane 2019 AJPA; McGuire 2021 Front Immunol; Pace 2021 Microorganisms;
# Caffé 2023 AJHB). No individual-level INSPIRE data were used. Individual
# values are synthetic; only group-level patterns resemble the published
# results.
#
# Usage (from project root):  Rscript R/03_validate_simulation.R
# Recomputes per-cohort summary statistics from data/simulated/simulated_*.csv
# and compares them with the published values in data/simulated/params_*.csv.
# Writes data/simulated/validation_report.md.
# =============================================================================

set.seed(2026)

suppressPackageStartupMessages({
  library(dplyr)
  library(tidyr)
  library(readr)
})

OUT_DIR <- file.path("data", "simulated")
SS <- function(f) file.path(OUT_DIR, f)

wide <- read_csv(SS("simulated_dyads.csv"), show_col_types = FALSE)
params <- list(
  cohorts = read_csv(SS("params_cohorts.csv"), show_col_types = FALSE),
  maternal = read_csv(SS("params_maternal.csv"), show_col_types = FALSE),
  secretor = read_csv(SS("params_secretor.csv"), show_col_types = FALSE),
  hmo = read_csv(SS("params_hmo.csv"), show_col_types = FALSE),
  immune = read_csv(SS("params_immune.csv"), show_col_types = FALSE),
  milk_mic = read_csv(SS("params_milk_microbiome.csv"), show_col_types = FALSE),
  fecal_mic = read_csv(SS("params_fecal_microbiome.csv"), show_col_types = FALSE),
  diversity = read_csv(SS("params_diversity.csv"), show_col_types = FALSE),
  antibodies = read_csv(SS("params_antibodies.csv"), show_col_types = FALSE),
  macronutrients = read_csv(SS("params_macronutrients.csv"), show_col_types = FALSE),
  household = read_csv(SS("params_household.csv"), show_col_types = FALSE),
  correlations = read_csv(SS("params_correlations.csv"), show_col_types = FALSE),
  delivery = read_csv(SS("params_delivery.csv"), show_col_types = FALSE),
  ebf = read_csv(SS("params_ebf.csv"), show_col_types = FALSE)
)

sem_of <- function(x) sd(x, na.rm = TRUE) / sqrt(sum(!is.na(x)))

# generic comparison frame builder ---------------------------------------------
compare_mean_sem <- function(param_df, layer_label) {
  rows <- lapply(seq_len(nrow(param_df)), function(i) {
    p <- param_df[i, ]
    v <- wide[[p$analyte_id]][wide$cohort == p$cohort]
    tibble(
      layer = layer_label, variable = p$analyte_id, cohort = p$cohort,
      statistic = "mean", published = p$mean, simulated = mean(v, na.rm = TRUE),
      sem_published = p$sem, sem_simulated = sem_of(v)
    )
  }) %>% bind_rows()
  rows
}

cat("Building validation tables...\n")
# Fisher diversity is not simulated - cannot be computed from 28-29 printed
# genera; excluded from the comparison and documented as a limitation.
diversity_cmp_params <- params$diversity %>% filter(!grepl("fisher", analyte_id))
cmp <- bind_rows(
  compare_mean_sem(params$maternal, "maternal_characteristics"),
  compare_mean_sem(params$hmo, "hmo"),
  compare_mean_sem(params$milk_mic, "milk_microbiome"),
  compare_mean_sem(params$fecal_mic, "fecal_microbiome"),
  compare_mean_sem(params$antibodies, "antibodies"),
  compare_mean_sem(diversity_cmp_params, "diversity_indices")
)

# SEM comparison on a common scale (relative to published mean)
cmp <- cmp %>%
  mutate(
    rel_error_mean = (simulated - published) / ifelse(abs(published) < 1e-9, NA_real_, published),
    rel_error_sem = (sem_simulated - sem_published) / ifelse(sem_published < 1e-9, NA_real_, sem_published),
    within_10 = abs(rel_error_mean) <= 0.10,
    within_25 = abs(rel_error_mean) <= 0.25
  )

# ---- immune: median / IQR / detection ---------------------------------------
immune_cmp <- lapply(seq_len(nrow(params$immune)), function(i) {
  p <- params$immune[i, ]
  v <- wide[[p$analyte_id]][wide$cohort == p$cohort]
  vv <- v[v > 0]
  tibble(
    layer = "immune_factors", variable = p$analyte_id, cohort = p$cohort,
    statistic = c("median", "iqr_width", "detection_pct"),
    published = c(p$median, p$iqr_u - p$iqr_l, p$det_pct),
    simulated = c(median(vv, na.rm = TRUE),
                  IQR(vv, na.rm = TRUE),
                  100 * mean(v > 0, na.rm = TRUE))
  )
}) %>% bind_rows() %>%
  mutate(rel_error = (simulated - published) / ifelse(abs(published) < 1e-9, NA_real_, published))

# ---- binary / compositional prevalence-style comparisons --------------------
delivery_cmp <- params$delivery %>%
  mutate(simulated = sapply(cohort, function(co)
    100 * mean(wide$delivery_mode[wide$cohort == co] == "vaginal", na.rm = TRUE))) %>%
  transmute(layer = "maternal_characteristics", variable = "delivery_vaginal_pct",
            cohort, statistic = "percent vaginal", published = vaginal_pct, simulated)
ebf_cmp <- params$ebf %>%
  mutate(simulated = sapply(cohort, function(co)
    100 * mean(wide$exclusive_breastfed[wide$cohort == co], na.rm = TRUE))) %>%
  transmute(layer = "maternal_characteristics", variable = "exclusive_breastfed_pct",
            cohort, statistic = "percent exclusively breastfed", published = ebf_pct, simulated)
secretor_cmp <- params$secretor %>%
  mutate(simulated = sapply(cohort, function(co)
    100 * mean(wide$secretor_status[wide$cohort == co], na.rm = TRUE)),
    rel_error = (simulated - secretor_pct) / pmax(secretor_pct, 1)) %>%
  transmute(layer = "secretor_status", variable = "secretor_status_pct", cohort,
            statistic = "percent secretors", published = secretor_pct, simulated)

hh_long <- params$household %>%
  pivot_longer(c(mean, prop), names_to = "stat", values_to = "published") %>%
  filter(!is.na(published), analyte_id %in% names(wide)) %>%
  mutate(simulated = NA_real_)
for (i in seq_len(nrow(hh_long))) {
  p <- hh_long[i, ]
  v <- wide[[p$analyte_id]][wide$cohort == p$cohort]
  if (p$stat == "prop") v <- as.logical(v)
  v <- v[!is.na(v)]
  if (length(v)) hh_long$simulated[i] <- mean(v)
}
hh_cmp <- hh_long %>%
  transmute(layer = "household_composition", variable = analyte_id, cohort,
            statistic = paste0("per-population ", stat), published, simulated)

pct_cmp <- bind_rows(delivery_cmp, ebf_cmp, secretor_cmp, hh_cmp) %>%
  mutate(rel_error = (simulated - published) / ifelse(abs(published) < 1e-9, NA_real_, published))

# ---- macronutrients (overall) -------------------------------------------------
macro_cmp <- params$macronutrients %>%
  transmute(layer = "macronutrients", variable = analyte_id, cohort = "overall",
            statistic = "mean (overall)",
            published = mean,
            simulated = sapply(analyte_id, function(id) mean(wide[[id]], na.rm = TRUE)),
            rel_error = (simulated - published) / published)

# ---- microbiome prevalence ----------------------------------------------------
prev_cmp <- bind_rows(
  params$milk_mic %>% filter(!is.na(prev_pct)) %>%
    transmute(layer = "milk_microbiome", variable = analyte_id, cohort,
              statistic = "prevalence %",
              published = prev_pct,
              simulated = sapply(seq_len(nrow(.)), function(i)
                100 * mean(wide[[analyte_id[i]]][wide$cohort == cohort[i]] > 1e-4, na.rm = TRUE))),
  params$fecal_mic %>% filter(!is.na(prev_pct)) %>%
    transmute(layer = "fecal_microbiome", variable = analyte_id, cohort,
              statistic = "prevalence %",
              published = prev_pct,
              simulated = sapply(seq_len(nrow(.)), function(i)
                100 * mean(wide[[analyte_id[i]]][wide$cohort == cohort[i]] > 1e-4, na.rm = TRUE)))
) %>%
  mutate(rel_error = (simulated - published) / pmax(published, 1))

# ---- HMO total ----------------------------------------------------------------
hmo_total_cmp <- params$hmo %>%
  filter(analyte_id == "hmo_total_nmol_ml") %>%
  mutate(simulated = sapply(cohort, function(co)
    mean(wide$hmo_total_nmol_ml[wide$cohort == co], na.rm = TRUE)),
    rel_error = (simulated - mean) / mean) %>%
  transmute(layer = "hmo", variable = "hmo_total_nmol_ml (computed sum)", cohort,
            statistic = "mean", published = mean, simulated, rel_error)

# ---- realised vs imposed correlations ----------------------------------------
cors <- params$correlations
get_small <- function() wide$hmo_2fl_nmol_ml + wide$hmo_3fl_nmol_ml + wide$hmo_dflac_nmol_ml
small_sum <- get_small()
corr_rows <- lapply(seq_len(nrow(cors)), function(i) {
  a <- cors$var1[i]; b <- cors$var2[i]; tgt <- cors$rho[i]
  va <- if (a == "hmo_grp_small_hmos_nmol_ml") small_sum else wide[[a]]
  vb <- if (b == "hmo_grp_small_hmos_nmol_ml") small_sum else wide[[b]]
  if (is.null(va) || is.null(vb)) return(NULL)
  tibble(var1 = a, var2 = b, target_rho = tgt,
         realised_rho = cor(va, vb, method = "spearman", use = "complete.obs"),
         where = cors$where[i], source_paper = cors$source_paper[i])
}) %>% bind_rows()
corr_rows$abs_diff <- abs(corr_rows$realised_rho - corr_rows$target_rho)

# ---- summary stats -------------------------------------------------------------
n_vars <- n_distinct(cmp$variable)
within10 <- mean(cmp$within_10, na.rm = TRUE)
within25 <- mean(cmp$within_25, na.rm = TRUE)
n_rows10 <- sum(cmp$within_10, na.rm = TRUE)
n_rows25 <- sum(cmp$within_25, na.rm = TRUE)

by_layer <- cmp %>%
  group_by(layer) %>%
  summarise(n_rows = n(),
            n_vars = n_distinct(variable),
            median_abs_rel_err = median(abs(rel_error_mean), na.rm = TRUE),
            mean_abs_rel_err = mean(abs(rel_error_mean), na.rm = TRUE),
            max_abs_rel_err = max(abs(rel_error_mean), na.rm = TRUE),
            within_10pct = sum(within_10, na.rm = TRUE),
            within_25pct = sum(within_25, na.rm = TRUE),
            .groups = "drop")

worst <- cmp %>%
  filter(!is.na(rel_error_mean)) %>%
  arrange(desc(abs(rel_error_mean))) %>%
  head(20)

# diversity comparisons separated (richness/Fisher are known limitations;
# Fisher's alpha requires count data and is not simulated)
div_cmp <- cmp %>% filter(layer == "diversity_indices")
cmp_main <- cmp %>% filter(layer != "diversity_indices")

# ---- write report --------------------------------------------------------------
md <- file(SS("validation_report.md"), open = "wt")
w <- function(...) cat(paste0(...), "\n", file = md)

w("# Validation report — SIMULATED INSPIRE-like dyad dataset\n")
w("> **SIMULATED DATA.** This report describes **SIMULATED** data. Values were generated\n")
w("> from summary statistics published in the INSPIRE study papers (McGuire 2017 AJCN;\n")
w("> Ruiz 2017 Front Immunol; Lackey 2019 Front Nutr; Lane 2019 AJPA; McGuire 2021\n")
w("> Front Immunol; Pace 2021 Microorganisms; Caffé 2023 AJHB). **No individual-level\n")
w("> INSPIRE data were used.** Individual values are synthetic; only group-level\n")
w("> patterns resemble the published results.\n")
w("\nGenerated: ", format(Sys.time(), "%Y-%m-%d %H:%M %Z"),
  "  |  seed: 2026  |  dyads: ", nrow(wide),
  "  |  script: `R/03_validate_simulation.R`\n")

w("\n## 1. Summary: simulated vs published per-cohort means\n")
w("\nRelative error = (simulated - published) / published, computed per variable x cohort.\n")
w("Variables with published mean == 0 are excluded from the *relative*-error tallies.\n\n")
w("| layer | variables | cohort x var rows | median |rel err| | mean |rel err| | max |rel err| | within 10% | within 25% |\n")
w("|---|---|---|---|---|---|---|---|\n")
for (i in seq_len(nrow(by_layer))) {
  r <- by_layer[i, ]
  w(sprintf("| %s | %d | %d | %.3f | %.3f | %.3f | %d/%d | %d/%d |\n",
            r$layer, r$n_vars, r$n_rows, r$median_abs_rel_err, r$mean_abs_rel_err,
            r$max_abs_rel_err, r$within_10pct, r$n_rows, r$within_25pct, r$n_rows))
}
w(sprintf("\n**Overall (mean-based layers incl. diversity rows): %d/%d rows (%.0f%%) within 10%%; %d/%d (%.0f%%) within 25%%.**\n",
          n_rows10, nrow(cmp), 100 * n_rows10 / nrow(cmp),
          n_rows25, nrow(cmp), 100 * n_rows25 / nrow(cmp)))

w("\n## 2. Means / SEMs: per-variable detail (non-diversity layers)\n")
per_var <- cmp_main %>%
  group_by(layer, variable) %>%
  summarise(median_abs_rel_err = median(abs(rel_error_mean), na.rm = TRUE),
            max_abs_rel_err = max(abs(rel_error_mean), na.rm = TRUE),
            median_abs_err_units = median(abs(simulated - published), na.rm = TRUE),
            within_10pct = sum(within_10, na.rm = TRUE),
            within_25pct = sum(within_25, na.rm = TRUE), n = n(), .groups = "drop") %>%
  arrange(layer, desc(max_abs_rel_err))
w("| layer | variable | median |rel err| | max |rel err| | median abs err (units/pp) | within 10% | within 25% |\n|---|---|---|---|---|---|---|\n")
for (i in seq_len(nrow(per_var))) {
  r <- per_var[i, ]
  w(sprintf("| %s | %s | %.3f | %.3f | %.4g | %d/%d | %d/%d |\n",
            r$layer, r$variable, r$median_abs_rel_err, r$max_abs_rel_err,
            r$median_abs_err_units, r$within_10pct, r$n, r$within_25pct, r$n))
}
w("\n*For milk/fecal genera with tiny published means (<=0.1%%), relative errors look\n")
w("large even when the absolute deviation is a fraction of a percentage point -\n")
w("see the abs-err column.*\n")

w("\n### 20 largest mean deviations\n")
w("| layer | variable | cohort | published | simulated | rel error |\n|---|---|---|---|---|---|\n")
for (i in seq_len(min(20, nrow(worst)))) {
  r <- worst[i, ]
  w(sprintf("| %s | %s | %s | %.4g | %.4g | %+.1f%% |\n",
            r$layer, r$variable, as.character(r$cohort), r$published, r$simulated,
            100 * r$rel_error_mean))
}

w("\n## 3. SEM reproduction\n")
w("The published SEMs (SEM = SD/sqrt(n)) are compared with the simulated cohort SEMs.\n")
w("Relative errors on the SEM measure how well the simulated *spread* matches.\n\n")
sem_sum <- cmp %>%
  filter(!is.na(rel_error_sem)) %>%
  group_by(layer) %>%
  summarise(median_abs_sem_err = median(abs(rel_error_sem), na.rm = TRUE),
            mean_abs_sem_err = mean(abs(rel_error_sem), na.rm = TRUE),
            max_abs_sem_err = max(abs(rel_error_sem), na.rm = TRUE), .groups = "drop")
w("| layer | median |SEM err| | mean |SEM err| | max |SEM err| |\n|---|---|---|---|\n")
for (i in seq_len(nrow(sem_sum))) {
  r <- sem_sum[i, ]
  w(sprintf("| %s | %.3f | %.3f | %.3f |\n", r$layer, r$median_abs_sem_err,
            r$mean_abs_sem_err, r$max_abs_sem_err))
}

w("\n## 4. Immune factors (Ruiz 2017) — median / IQR width / detection %\n")
w("ETR is excluded (chemically preserved milk); its analytes are NA by design.\n\n")
imm_sum <- immune_cmp %>%
  group_by(statistic) %>%
  summarise(median_abs_rel_err = median(abs(rel_error), na.rm = TRUE),
            mean_abs_rel_err = mean(abs(rel_error), na.rm = TRUE),
            within_10pct = mean(abs(rel_error) <= 0.10, na.rm = TRUE),
            within_25pct = mean(abs(rel_error) <= 0.25, na.rm = TRUE), .groups = "drop")
w("| statistic | median |rel err| | mean |rel err| | within 10% | within 25% |\n|---|---|---|---|---|\n")
for (i in seq_len(nrow(imm_sum))) {
  r <- imm_sum[i, ]
  w(sprintf("| %s | %.3f | %.3f | %.0f%% | %.0f%% |\n", r$statistic, r$median_abs_rel_err,
            r$mean_abs_rel_err, 100 * r$within_10pct, 100 * r$within_25pct))
}
worst_imm <- immune_cmp %>% filter(!is.na(rel_error)) %>%
  arrange(desc(abs(rel_error))) %>% head(12)
w("\nLargest immune deviations:\n\n| statistic | analyte | cohort | published | simulated | rel err |\n|---|---|---|---|---|---|\n")
for (i in seq_len(nrow(worst_imm))) {
  r <- worst_imm[i, ]
  w(sprintf("| %s | %s | %s | %.4g | %.4g | %+.1f%% |\n", r$statistic, r$variable,
            as.character(r$cohort), r$published, r$simulated, 100 * r$rel_error))
}

w("\n## 5. Proportions: delivery mode, exclusive breastfeeding, secretor status, household\n")
pct_cmp <- pct_cmp %>% filter(!is.na(simulated))
prop_sum <- pct_cmp %>%
  group_by(variable) %>%
  summarise(n = n(),
            median_abs_err_pct_pts = median(abs(simulated - published), na.rm = TRUE),
            max_abs_err_pct_pts = max(abs(simulated - published), na.rm = TRUE), .groups = "drop") %>%
  filter(n > 0)
w("| variable | n cohorts | median abs err (pct-pts) | max abs err (pct-pts) |\n|---|---|---|---|\n")
for (i in seq_len(nrow(prop_sum))) {
  r <- prop_sum[i, ]
  w(sprintf("| %s | %d | %.1f | %.1f |\n", r$variable, r$n,
            r$median_abs_err_pct_pts, r$max_abs_err_pct_pts))
}
w("\n*Note: secretor status and delivery mode were drawn stratified by cohort ",
  "(exact integer counts), so their per-cohort percentages match the published ",
  "values up to rounding to the nearest dyad (+/- 1/n). Other proportions are ",
  "Bernoulli draws at the published cohort rates, so binomial sampling error ",
  "(~2-8 pct-pts at these n) is expected.*\n")

w("\n## 6. Microbiome prevalence (Lackey 2019 Table 3)\n")
prev_sum <- prev_cmp %>%
  group_by(layer) %>%
  summarise(n = n(),
            median_abs_err_pct_pts = median(abs(simulated - published), na.rm = TRUE),
            max_abs_err_pct_pts = max(abs(simulated - published), na.rm = TRUE), .groups = "drop")
w("| layer | rows | median abs err (pct-pts) | max abs err (pct-pts) |\n|---|---|---|---|\n")
for (i in seq_len(nrow(prev_sum))) {
  r <- prev_sum[i, ]
  w(sprintf("| %s | %d | %.1f | %.1f |\n", r$layer, r$n,
            r$median_abs_err_pct_pts, r$max_abs_err_pct_pts))
}

w("\n## 7. Macronutrients (Pace 2021, overall only — not cohort-specific)\n")
w("| variable | published mean | simulated mean | rel err |\n|---|---|---|---|\n")
for (i in seq_len(nrow(macro_cmp))) {
  r <- macro_cmp[i, ]
  w(sprintf("| %s | %.2f | %.2f | %+.1f%% |\n", r$variable, r$published, r$simulated, 100 * r$rel_error))
}

w("\n## 8. Total HMO (sum of the 19 individual HMOs)\n")
w("| cohort | published total | simulated total | rel err |\n|---|---|---|---|\n")
for (i in seq_len(nrow(hmo_total_cmp))) {
  r <- hmo_total_cmp[i, ]
  w(sprintf("| %s | %.0f | %.0f | %+.2f%% |\n", as.character(r$cohort), r$published,
            r$simulated, 100 * r$rel_error))
}

w("\n## 9. Realised vs imposed correlations (Spearman, pooled across dyads)\n")
w("| var1 | var2 | target rho | realised rho | abs diff | source |\n|---|---|---|---|---|---|\n")
for (i in seq_len(nrow(corr_rows))) {
  r <- corr_rows[i, ]
  w(sprintf("| %s | %s | %+.2f | %+.2f | %.2f | %s |\n",
            r$var1, r$var2, r$target_rho, r$realised_rho, r$abs_diff, r$source_paper))
}
w(sprintf("\nMedian |diff| = %.2f; %d/%d pairs within ±0.15 of target; %d/%d within ±0.25.\n",
          median(corr_rows$abs_diff),
          sum(corr_rows$abs_diff <= 0.15), nrow(corr_rows),
          sum(corr_rows$abs_diff <= 0.25), nrow(corr_rows)))

w("\n## 10. Diversity indices vs Lackey 2019 Table 4 (**known limitation**)\n")
w("Lackey 2019 rarefied to 1,000 reads and counted *all* sequenced genera, whereas the\n")
w("simulation generates the 28-29 printed core genera only; richness here is the number\n")
w("of simulated genera with relative abundance >= 1% and is therefore systematically\n")
w("lower. Shannon and inverse-Simpson computed from the simulated compositions track\n")
w("the published cohort means reasonably (median |rel err| below).\n\n")
div_sum <- div_cmp %>%
  group_by(variable) %>%
  summarise(median_abs_rel_err = median(abs(rel_error_mean), na.rm = TRUE),
            mean_abs_rel_err = mean(abs(rel_error_mean), na.rm = TRUE), .groups = "drop")
w("| index | median |rel err| | mean |rel err| |\n|---|---|---|\n")
for (i in seq_len(nrow(div_sum))) {
  r <- div_sum[i, ]
  w(sprintf("| %s | %.3f | %.3f |\n", r$variable, r$median_abs_rel_err, r$mean_abs_rel_err))
}

w("\n## 11. Known limitations\n")
w("- Figure-only values (per-cohort secretor % for 5 cohorts, per-cohort lactose/protein,\n")
w("  secretor x HMO breakdowns) were **not** simulated from figure images; assumptions\n")
w("  are flagged in `provenance.csv`.\n")
w("- Lactose and protein are simulated from the **overall** Pace 2021 distribution only\n")
w("  (per-cohort values are figure-only); they cannot validate per cohort.\n")
w("- ETR has no immune data (`immune_measured = FALSE`; all 23 analytes NA).\n")
w("- Diversity indices: see section 10 (coverage limitation of printed tables).\n")
w("- Antibody `breadth score = 0` cells were simulated at a floor of 0.01; those\n")
w("  cohorts contribute large *relative* errors against a published 0 and are excluded\n")
w("  from relative-error tallies (absolute errors are <= 0.01 breadth units).\n")
w("- Fisher's alpha (Lackey 2019 T4) cannot be computed from 28-29 printed genera\n")
w("  (it requires read-count data) and is not simulated.\n")

close(md)
cat("validation_report.md written to", SS("validation_report.md"), "\n")
