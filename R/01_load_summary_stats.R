# =============================================================================
# R/01_load_summary_stats.R
# Brief 05 - INSPIRE-like simulated dataset
#
# SIMULATED DATA NOTICE: this script builds parameter tables used to generate
# SIMULATED data. The resulting dataset is NOT the original INSPIRE data and
# must never be presented as such. Values were generated from summary
# statistics published in the INSPIRE study papers (McGuire 2017 AJCN;
# Ruiz 2017 Front Immunol; Lackey 2019 Front Nutr; Lane 2019 AJPA;
# McGuire 2021 Front Immunol; Pace 2021 Microorganisms; Caffé 2023 AJHB).
# No individual-level INSPIRE data were used. Individual values are synthetic;
# only group-level patterns resemble the published results.
#
# Reads data/inspire/summary_stats/*.csv, normalises names, and builds tidy
# parameter tables in data/simulated/. Run from the project root:
#   Rscript R/01_load_summary_stats.R
# =============================================================================

set.seed(2026)

suppressPackageStartupMessages({
  library(dplyr)
  library(tidyr)
  library(readr)
})

SUM_DIR <- file.path("data", "inspire", "summary_stats")
OUT_DIR <- file.path("data", "simulated")
dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)

read_stats <- function(file) {
  read_csv(file.path(SUM_DIR, file), col_types = cols(.default = col_character()),
           na = character(), locale = locale(encoding = "UTF-8"),
           show_col_types = FALSE) %>%
    mutate(n = suppressWarnings(as.numeric(n)),
           value_num = suppressWarnings(as.numeric(value)))
}

# Normalise an analyte name: '#' -> "'", INFγ -> IFNγ, ASCII-ish snake_case id
normalise_name <- function(x) {
  x <- gsub("#", "'", x, fixed = TRUE)
  x <- gsub("INFγ", "IFNγ", x, fixed = TRUE)
  x <- gsub("IFNΓ", "IFNγ", x, fixed = TRUE)
  x
}

# Plot-friendly ASCII snake_case id for analytes / genera
snake <- function(x) {
  x <- gsub("β", "b", x, fixed = TRUE)
  x <- gsub("α", "a", x, fixed = TRUE)
  x <- gsub("γ", "g", x, fixed = TRUE)
  x <- gsub("&", " and ", x, fixed = TRUE)
  x <- gsub("[^A-Za-z0-9]+", "_", x)
  x <- gsub("_+", "_", x)
  x <- gsub("^_|_$", "", x)
  tolower(x)
}

# Canonical cohort table -------------------------------------------------------
cohorts <- tibble::tribble(
  ~cohort, ~country,                     ~region_income, ~setting, ~n_dyads,
  "ETR",  "Ethiopia rural",              "LMIC",         "rural",  40L,
  "ETU",  "Ethiopia urban",              "LMIC",         "urban",  40L,
  "GBR",  "Gambia rural",                "LMIC",         "rural",  40L,
  "GBU",  "Gambia urban",                "LMIC",         "urban",  40L,
  "GN",   "Ghana",                       "LMIC",         "urban",  40L,
  "KE",   "Kenya",                       "LMIC",         "urban",  42L,
  "PE",   "Peru",                        "LMIC",         "urban",  43L,
  "SP",   "Spain",                       "HIC",          "urban",  41L,
  "SW",   "Sweden",                      "HIC",          "urban",  24L,
  "USW",  "United States Washington",    "HIC",          "urban",  41L,
  "USC",  "United States California",    "HIC",          "urban",  19L
) %>%
  mutate(cohort_name = paste0(country, " (", cohort, ")"))

stopifnot(sum(cohorts$n_dyads) == 410L)

# The published tables use full country names (case varies between papers)
# McGuire 2017 uses Title Case ("Ethiopia Rural"), others use lower case.
country_to_cohort <- setNames(cohorts$cohort, cohorts$country)
cohort_of <- function(group_chr) {
  # case-insensitive match against country names; tolerate "US ..." spelling and /Idaho
  g <- trimws(group_chr)
  g <- sub("Washington/Idaho", "Washington", g, fixed = TRUE)
  hit <- country_to_cohort[match(tolower(g), tolower(cohorts$country))]
  # papers also name "US California" / "US Washington"
  alt <- sub("^US ", "United States ", g)
  hit <- ifelse(is.na(hit), country_to_cohort[match(tolower(alt), tolower(cohorts$country))], hit)
  unname(hit)
}

# Helper: pivot a long (analyte, group, statistic, value) stat file to wide ----
pivot_stats <- function(df, paper, table_name) {
  df %>%
    mutate(cohort = cohort_of(group), analyte = normalise_name(analyte)) %>%
    filter(!is.na(cohort), !is.na(value_num)) %>%
    # keep source columns; some source files contain exact duplicate rows
    distinct(analyte, data_type, cohort, statistic, value_num, n, unit, .keep_all = FALSE) %>%
    mutate(statistic = case_when(
      statistic == "mean" ~ "mean",
      statistic == "SEM" ~ "sem",
      statistic == "median" ~ "median",
      statistic == "median (IQR)" ~ "median",
      statistic == "IQR lower" ~ "iqr_l",
      statistic == "IQR upper" ~ "iqr_u",
      statistic == "detection frequency" ~ "det_pct",
      statistic == "relative abundance (mean)" ~ "mean",
      statistic == "% of samples with quantifiable amount" ~ "prev_pct",
      statistic == "% of subjects" ~ "pct",
      statistic == "proportion" ~ "prop",
      statistic == "SD" ~ "sd",
      statistic == "% secretors (2'FL above natural break)" ~ "secretor_pct",
      statistic == "%" ~ "pct",
      TRUE ~ statistic
    )) %>%
    # if duplicates remain after normalisation (e.g. 'mean' from 'median (IQR)'), keep first
    distinct(analyte, data_type, cohort, statistic, .keep_all = TRUE) %>%
    group_by(analyte, data_type, cohort) %>%
    mutate(n = dplyr::first(n[!is.na(n)])) %>% ungroup() %>%
    select(-unit) %>%
    pivot_wider(names_from = statistic, values_from = value_num) %>%
    mutate(paper = paper, table = table_name)
}

# 1) Maternal characteristics (McGuire 2017 T1) --------------------------------
maternal <- read_stats("mcguire2017_Table1.csv") %>%
  pivot_stats("mcguire2017", "Table 1") %>%
  filter(!is.na(mean), !is.na(sem)) %>%
  mutate(analyte_id = case_when(
    analyte == "Age" ~ "maternal_age_y",
    analyte == "Parity" ~ "parity_n",
    analyte == "Time postpartum" ~ "postpartum_d",
    analyte == "Weight" ~ "maternal_weight_kg",
    analyte == "Height" ~ "maternal_height_cm",
    analyte == "BMI" ~ "maternal_bmi_kg_m2",
    TRUE ~ snake(analyte)
  )) %>%
  select(analyte, analyte_id, cohort, n, mean, sem, paper, table)

stopifnot(nrow(maternal) == 66L)  # 6 traits x 11 cohorts

# 2) Secretor status (McGuire 2017 Fig 3 text) ---------------------------------
secretor_printed <- read_stats("mcguire2017_Figure3_secretors.csv") %>%
  mutate(cohort = cohort_of(group), value_num = as.numeric(value)) %>%
  filter(!is.na(cohort)) %>%
  transmute(cohort, secretor_pct = value_num, distribution = "binomial(published p)",
            flag = ifelse(grepl("UNVERIFIED", notes, fixed = TRUE),
                          "GBR/ETR exact split unverified (text: 65% in both)", NA_character_),
            source_paper = "mcguire2017", source_table = "Figure 3 (text)")
# cohorts without a printed value -> assume 80%
secretor <- cohorts %>%
  select(cohort) %>%
  left_join(secretor_printed, by = "cohort") %>%
  mutate(secretor_pct = ifelse(is.na(secretor_pct), 80, secretor_pct),
         flag = ifelse(is.na(source_paper),
                       "secretor % not printed for this cohort; assumed 80%", flag),
         source_paper = ifelse(is.na(source_paper), "mcguire2017 (assumed)", source_paper),
         source_table = ifelse(is.na(source_table), "Figure 3 (text)", source_table),
         distribution = ifelse(is.na(distribution), "binomial(assumed p)", distribution)) %>%
  select(cohort, secretor_pct, distribution, flag, source_paper, source_table)

# HMO id helper: "2'FL" -> "2fl", "LNFP I" -> "lnfp_i"
hmo_snake <- function(x) snake(gsub("'", "", x, fixed = TRUE))

# 3) HMOs (19 + total, McGuire 2017 T2) ---------------------------------------
hmo <- read_stats("mcguire2017_Table2.csv") %>%
  pivot_stats("mcguire2017", "Table 2") %>%
  filter(!is.na(mean), !is.na(sem)) %>%
  mutate(analyte_id = paste0("hmo_", hmo_snake(analyte), "_nmol_ml")) %>%
  select(analyte, analyte_id, cohort, n, mean, sem, paper, table)

# also the HMO structural groupings (Table 3) - used for the small-HMO sum check
hmo_groups <- read_stats("mcguire2017_Table3.csv") %>%
  pivot_stats("mcguire2017", "Table 3") %>%
  filter(!is.na(mean), !is.na(sem)) %>%
  mutate(analyte_id = paste0("hmo_grp_", hmo_snake(analyte), "_nmol_ml")) %>%
  select(analyte, analyte_id, cohort, n, mean, sem, paper, table)

stopifnot(nrow(hmo) == 20L * 11L)  # 19 HMOs + Total, x 11 cohorts

# small HMO grouping = 2'FL + 3FL + DFLac (McGuire 2017 footnote of Table 3)
small_hmo_members <- c("2'FL", "3FL", "DFLac")

# 4) Immune factors (Ruiz 2017 T2-T5) ------------------------------------------
imm_med <- bind_rows(
  read_stats("ruiz2017_Table3.csv"),
  read_stats("ruiz2017_Table4.csv"),
  read_stats("ruiz2017_Table5.csv")
) %>%
  filter(statistic %in% c("median", "IQR lower", "IQR upper"))

imm_det <- read_stats("ruiz2017_Table2.csv")

# keep the full 23 x 10 grid; median='nd' combos are back-filled with the pooled
# median across cohorts and flagged (they are below detection anyway, and the
# zero-inflation from detection % largely governs the visible median)
immune <- imm_med %>%
  pivot_stats("ruiz2017", "Tables 3-5") %>%
  tidyr::complete(analyte, cohort) %>%
  left_join(
    imm_det %>% mutate(cohort = cohort_of(group), analyte = normalise_name(analyte)) %>%
      filter(!is.na(cohort), !is.na(value_num)) %>%
      select(analyte, cohort, det_pct = value_num),
    by = c("analyte", "cohort")
  ) %>%
  group_by(analyte) %>%
  mutate(
    pooled_med = 10^mean(log10(median), na.rm = TRUE),
    median_was_nd = is.na(median),
    median = ifelse(is.na(median), pooled_med, median),
    iqr_l = ifelse(is.na(iqr_l), median / 2, iqr_l),
    iqr_u = ifelse(is.na(iqr_u), median * 2, iqr_u)
  ) %>%
  ungroup() %>%
  mutate(analyte_id = paste0("imm_", snake(analyte), "_ng_l")) %>%
  filter(!is.na(cohort))

stopifnot(nrow(immune) == 23L * 10L)  # 23 analytes x 10 cohorts (ETR excluded)

# 5) Milk microbiome (Lackey 2019 T5, T3, T4) ----------------------------------
milk_mic <- read_stats("lackey2019_Table5.csv") %>%
  pivot_stats("lackey2019", "Table 5") %>%
  filter(!is.na(mean), !is.na(sem)) %>%
  mutate(analyte_id = paste0("milk_g_", snake(analyte), "_pct")) %>%
  select(analyte, analyte_id, cohort, n, mean, sem, paper, table)

stopifnot(nrow(milk_mic) == 29L * 11L)

prev <- read_stats("lackey2019_Table3.csv") %>%
  filter(statistic == "% of samples with quantifiable amount") %>%
  mutate(cohort = cohort_of(group)) %>%
  filter(!is.na(cohort)) %>%
  select(analyte, data_type, cohort, prev_pct = value_num)

fecal_mic <- read_stats("lackey2019_Table2.csv") %>%
  pivot_stats("lackey2019", "Table 2") %>%
  filter(!is.na(mean), !is.na(sem)) %>%
  mutate(analyte_id = paste0("fecal_g_", snake(analyte), "_pct")) %>%
  select(analyte, analyte_id, cohort, n, mean, sem, paper, table)

stopifnot(nrow(fecal_mic) == 28L * 11L)

milk_mic <- milk_mic %>%
  left_join(prev %>% filter(data_type == "milk microbiome") %>% select(analyte, cohort, prev_pct),
            by = c("analyte", "cohort"))
fecal_mic <- fecal_mic %>%
  left_join(prev %>% filter(data_type == "infant fecal microbiome") %>% select(analyte, cohort, prev_pct),
            by = c("analyte", "cohort"))

# diversity indices (Lackey T4) - kept as parameter table for the validation
diversity <- read_stats("lackey2019_Table4.csv") %>%
  pivot_stats("lackey2019", "Table 4") %>%
  filter(!is.na(mean), !is.na(sem)) %>%
  mutate(layer = ifelse(grepl("fecal", data_type), "fecal_microbiome", "milk_microbiome"),
         analyte_id = paste0(ifelse(grepl("fecal", data_type), "fecal", "milk"), "_div_", snake(analyte))) %>%
  select(analyte, analyte_id, layer, cohort, n, mean, sem, paper, table)

# 6) Antibodies IgA / IgG (McGuire 2021 T1/T2) ---------------------------------
parse_ab <- function(file, isotype) {
  read_stats(file) %>%
    pivot_stats(paste0("mcguire2021"), paste0("Table ", ifelse(isotype == "IgA", "1", "2"))) %>%
    filter(!is.na(mean), !is.na(sem)) %>%
    mutate(
      pathogen = sub(paste0(" ", isotype, ".*$"), "", analyte),
      metric = case_when(
        grepl("Breadth score", analyte) ~ "breadth_score",
        grepl("Top 10 antigens", analyte) ~ "reactivity_top10",
        grepl("All antigens", analyte) ~ "reactivity_all",
        TRUE ~ snake(analyte)
      ),
      isotype = tolower(isotype),
      analyte_id = paste0("ab_", tolower(isotype), "_", snake(pathogen), "_",
                          gsub("reactivity_", "react_", metric))
    ) %>%
    select(analyte, analyte_id, isotype, pathogen, metric, cohort, n, mean, sem, paper, table)
}
antibodies <- bind_rows(parse_ab("mcguire2021_Table1_IgA.csv", "IgA"),
                        parse_ab("mcguire2021_Table2_IgG.csv", "IgG"))
stopifnot(nrow(antibodies) == 48L * 11L)

# 7) Macronutrients (Pace 2021, overall only) ----------------------------------
split_mean_sd <- function(x) {
  parts <- strsplit(gsub(",", "", x), "±", fixed = TRUE)[[1]]
  as.numeric(trimws(parts))
}
mac <- read_stats("pace2021_text_stats.csv") %>%
  filter(data_type == "macronutrient") %>%
  select(analyte, statistic, value)

macronutrients <- tibble::tribble(
  ~analyte_id,             ~analyte,   ~mean, ~sd,  ~range_lo, ~range_hi, ~unit,
  "macro_lactose_g_l",     "lactose",  79.2,  11.0, 26.7, 118.3, "g/L",
  "macro_protein_g_l",     "protein",  15.0,  2.8,  9.4,  32.6,  "g/L"
) %>%
  mutate(distribution = "truncated normal (overall; not cohort-specific)",
         flag = "overall distribution only - per-cohort values not printed (figure-only)",
         source_paper = "pace2021", source_table = "text (sec 3.3)")

# 8) Household composition (Lane 2019 T1) --------------------------------------
household <- read_stats("lane2019_Table1.csv") %>%
  mutate(cohort = cohort_of(group)) %>%
  filter(!is.na(cohort), !is.na(value_num)) %>%
  mutate(analyte_id = case_when(
    analyte == "mean household size" ~ "household_size_n",
    analyte == "mean number of siblings" ~ "siblings_n",
    analyte == "proportion infants with siblings present" ~ "sibling_present",
    analyte == "mean number of extended family" ~ "extended_family_n",
    analyte == "proportion infants with extended family present" ~ "extended_family_present",
    analyte == "proportion infants with father present" ~ "father_present",
    analyte == "mean infant age" ~ "infant_age_weeks",
    TRUE ~ snake(analyte)
  )) %>%
  mutate(statistic = case_when(
    statistic == "mean" ~ "mean", statistic == "SD" ~ "sd",
    statistic == "proportion" ~ "prop", TRUE ~ statistic
  )) %>%
  select(analyte_id, cohort, statistic, value_num, n) %>%
  pivot_wider(names_from = statistic, values_from = value_num) %>%
  mutate(paper = "lane2019", table = "Table 1")

# 9) Published correlations used by the simulator ------------------------------
correlations <- tibble::tribble(
  ~var1,              ~var2,               ~rho,  ~where,                       ~source_paper,
  "hmo_2fl_nmol_ml",  "hmo_lnfp_i_nmol_ml", 0.74, "overall",                    "pace2021",
  "hmo_6sl_nmol_ml",  "hmo_lstc_nmol_ml",   0.65, "overall",                    "pace2021",
  "hmo_lnt_nmol_ml",  "hmo_lnnt_nmol_ml",   0.75, "overall",                    "mcguire2017",
  "hmo_lnfp_i_nmol_ml","hmo_lnfp_ii_nmol_ml", -0.46, "overall",                 "mcguire2017",
  "hmo_lnt_nmol_ml",  "hmo_dslnt_nmol_ml",  0.60, "overall",                    "mcguire2017",
  "hmo_lnnt_nmol_ml", "hmo_dslnt_nmol_ml",  0.62, "overall",                    "mcguire2017",
  "hmo_2fl_nmol_ml",  "hmo_lnfp_ii_nmol_ml", -0.52, "overall",                  "mcguire2017",
  "hmo_lstb_nmol_ml", "hmo_dslnt_nmol_ml",  0.55, "overall",                    "mcguire2017",
  "hmo_2fl_nmol_ml",  "hmo_grp_small_hmos_nmol_ml", 0.98, "overall (approx)",   "mcguire2017",
  # milk ~ fecal microbiome links (Pace 2021)
  "milk_g_lactobacillus_pct",    "fecal_g_lactobacillus_pct",    0.36,  "overall", "pace2021",
  "milk_g_bifidobacterium_pct",  "fecal_g_bifidobacterium_pct", -0.18, "overall", "pace2021",
  # maternal trait correlations (McGuire 2017 Fig 4 text)
  "maternal_age_y",        "hmo_lnnt_nmol_ml",  -0.14, "overall", "mcguire2017",
  "maternal_age_y",        "hmo_lstc_nmol_ml",  -0.17, "overall", "mcguire2017",
  "maternal_age_y",        "hmo_dslnh_nmol_ml", -0.15, "overall", "mcguire2017",
  "maternal_age_y",        "hmo_flnh_nmol_ml",   0.15, "overall", "mcguire2017",
  "maternal_weight_kg",    "hmo_dflac_nmol_ml",  0.21, "overall", "mcguire2017",
  "maternal_bmi_kg_m2",    "hmo_dflac_nmol_ml",  0.21, "overall", "mcguire2017",
  "maternal_weight_kg",    "hmo_grp_small_hmos_nmol_ml", 0.21, "overall", "mcguire2017",
  "maternal_bmi_kg_m2",    "hmo_grp_small_hmos_nmol_ml", 0.23, "overall", "mcguire2017",
  "maternal_weight_kg",    "hmo_lnfp_iii_nmol_ml", 0.20, "overall", "mcguire2017",
  "maternal_weight_kg",    "hmo_dflnt_nmol_ml",  0.14, "overall", "mcguire2017",
  "maternal_weight_kg",    "hmo_lnnt_nmol_ml",  -0.16, "overall", "mcguire2017",
  "maternal_bmi_kg_m2",    "hmo_lnnt_nmol_ml",  -0.20, "overall", "mcguire2017",
  "maternal_weight_kg",    "hmo_dslnt_nmol_ml", -0.21, "overall", "mcguire2017",
  "maternal_bmi_kg_m2",    "hmo_dslnt_nmol_ml", -0.24, "overall", "mcguire2017",
  "postpartum_d",          "hmo_6sl_nmol_ml",   -0.31, "overall", "mcguire2017",
  "postpartum_d",          "hmo_lnfp_iii_nmol_ml", -0.23, "overall", "mcguire2017",
  "postpartum_d",          "hmo_lstc_nmol_ml",  -0.40, "overall", "mcguire2017",
  "postpartum_d",          "hmo_lnh_nmol_ml",   -0.26, "overall", "mcguire2017",
  "postpartum_d",          "hmo_dslnt_nmol_ml", -0.13, "overall", "mcguire2017"
)

# 10) Delivery mode / EBF / infant sex parameter values -----------------------
# C-section % by site (Ruiz 2017 T1); vaginal = 100 - csection. ETR missing ->
# Pace 2021 overall 86% vaginal.
csection <- read_stats("ruiz2017_Table1.csv") %>%
  filter(analyte == "C-section", statistic == "% of subjects") %>%
  mutate(cohort = cohort_of(group)) %>%
  filter(!is.na(cohort)) %>%
  transmute(cohort, csection_pct = value_num)

delivery <- cohorts %>%
  select(cohort) %>%
  left_join(csection, by = "cohort") %>%
  mutate(
    vaginal_pct = ifelse(is.na(csection_pct), 86, 100 - csection_pct),
    flag = ifelse(is.na(csection_pct),
                  "ETR not in Ruiz 2017; vaginal % assumed = Pace 2021 overall 86%", NA_character_),
    source_paper = ifelse(is.na(csection_pct), "pace2021 (assumed)", "ruiz2017"),
    source_table = ifelse(is.na(csection_pct), "text (sec 3.1)", "Table 1")
  )

# exclusive breastfeeding: Lane 2019 T1 per-population where available, else 60% (Pace 2021)
ebf <- read_stats("lane2019_Table1.csv") %>%
  filter(analyte == "proportion exclusively breastfed") %>%
  mutate(cohort = cohort_of(group)) %>%
  filter(!is.na(cohort)) %>%
  transmute(cohort, ebf_pct_prop = value_num)

ebf_table <- cohorts %>%
  select(cohort) %>%
  left_join(ebf, by = "cohort") %>%
  mutate(
    ebf_pct = ifelse(is.na(ebf_pct_prop), 60, 100 * ebf_pct_prop),
    flag = ifelse(is.na(ebf_pct_prop),
                  "cohort % not in Lane 2019; assumed Pace 2021 overall 60%", NA_character_),
    source_paper = ifelse(is.na(ebf_pct_prop), "pace2021 (assumed)", "lane2019"),
    source_table = ifelse(is.na(ebf_pct_prop), "text (sec 3.1)", "Table 1")
  ) %>%
  select(cohort, ebf_pct, flag, source_paper, source_table)

# infant sex: 50/50 everywhere (approx; Lackey 2019 reports per-cohort % female ~42-56%)

# 11) Caffe 2023 LME betas used to tilt immune values --------------------------
caffe_betas <- read_stats("caffe2023_Table3.csv") %>%
  filter(statistic == "LME beta coefficient") %>%
  mutate(value_num = as.numeric(value)) %>%
  filter(grepl("Infant Sex:Maternal DDS", analyte, fixed = TRUE)) %>%
  mutate(analyte_name = sub(" \\~ .*$", "", analyte),
         analyte_name = gsub("log ", "", analyte_name, fixed = TRUE),
         analyte_id = paste0("imm_", snake(gsub("-", "", sub(" \\(.*\\)$", "", analyte_name))), "_ng_l")) %>%
  select(analyte_id, beta_value = value_num) %>%
  filter(!is.na(beta_value))

# write parameter tables -------------------------------------------------------
write_csv(cohorts,        file.path(OUT_DIR, "params_cohorts.csv"))
write_csv(maternal,       file.path(OUT_DIR, "params_maternal.csv"))
write_csv(secretor,       file.path(OUT_DIR, "params_secretor.csv"))
write_csv(hmo,            file.path(OUT_DIR, "params_hmo.csv"))
write_csv(hmo_groups,     file.path(OUT_DIR, "params_hmo_groups.csv"))
write_csv(immune,         file.path(OUT_DIR, "params_immune.csv"))
write_csv(milk_mic,       file.path(OUT_DIR, "params_milk_microbiome.csv"))
write_csv(fecal_mic,      file.path(OUT_DIR, "params_fecal_microbiome.csv"))
write_csv(diversity,      file.path(OUT_DIR, "params_diversity.csv"))
write_csv(antibodies,     file.path(OUT_DIR, "params_antibodies.csv"))
write_csv(macronutrients, file.path(OUT_DIR, "params_macronutrients.csv"))
write_csv(household,      file.path(OUT_DIR, "params_household.csv"))
write_csv(correlations,   file.path(OUT_DIR, "params_correlations.csv"))
write_csv(delivery,       file.path(OUT_DIR, "params_delivery.csv"))
write_csv(ebf_table,      file.path(OUT_DIR, "params_ebf.csv"))
write_csv(caffe_betas,    file.path(OUT_DIR, "params_caffe_betas.csv"))

# small lookup lists for the simulator -----------------------------------------
params <- list(
  cohorts = cohorts,
  small_hmo_members = small_hmo_members,
  hmo_ids = hmo$analyte_id %>% unique(),
  hmo_analyte = hmo %>% distinct(analyte, analyte_id) %>% tibble::deframe(),
  immune_ids = immune$analyte_id %>% unique(),
  milk_ids = milk_mic$analyte_id %>% unique(),
  fecal_ids = fecal_mic$analyte_id %>% unique(),
  ab_ids = antibodies$analyte_id %>% unique()
)
jsonlite::write_json(params, file.path(OUT_DIR, "params_lookup.json"),
                     pretty = TRUE, auto_unbox = TRUE)

cat("01_load_summary_stats.R complete. Parameter tables written to", OUT_DIR, "\n")
cat("  maternal rows:", nrow(maternal), " | hmo rows:", nrow(hmo),
    " | immune rows:", nrow(immune), "\n",
    " milk_mic rows:", nrow(milk_mic), " | fecal_mic rows:", nrow(fecal_mic),
    " | antibodies rows:", nrow(antibodies), "\n",
    " diversity rows:", nrow(diversity), " | household rows:", nrow(household), "\n")
