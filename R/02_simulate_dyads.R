# =============================================================================
# R/02_simulate_dyads.R
# Brief 05 - INSPIRE-like simulated dataset
#
# SIMULATED DATA NOTICE: this script generates SIMULATED data. It is NOT the
# original INSPIRE data and must never be presented as such. Values were
# generated from summary statistics published in the INSPIRE study papers
# (McGuire 2017 AJCN; Ruiz 2017 Front Immunol; Lackey 2019 Front Nutr;
# Lane 2019 AJPA; McGuire 2021 Front Immunol; Pace 2021 Microorganisms;
# Caffé 2023 AJHB). No individual-level INSPIRE data were used. Individual
# values are synthetic; only group-level patterns resemble the published
# results.
#
# Usage (from project root):  Rscript R/02_simulate_dyads.R
# =============================================================================

set.seed(2026)

suppressPackageStartupMessages({
  library(dplyr)
  library(tidyr)
  library(readr)
  library(purrr)
  library(MASS)   # mvrnorm
})

OUT_DIR <- file.path("data", "simulated")
SS <- function(f) file.path(OUT_DIR, f)

# ---- load parameter tables ---------------------------------------------------
cohorts       <- read_csv(SS("params_cohorts.csv"), show_col_types = FALSE)
maternal      <- read_csv(SS("params_maternal.csv"), show_col_types = FALSE)
secretor      <- read_csv(SS("params_secretor.csv"), show_col_types = FALSE)
hmo           <- read_csv(SS("params_hmo.csv"), show_col_types = FALSE)
hmo_groups    <- read_csv(SS("params_hmo_groups.csv"), show_col_types = FALSE)
immune        <- read_csv(SS("params_immune.csv"), show_col_types = FALSE)
milk_mic      <- read_csv(SS("params_milk_microbiome.csv"), show_col_types = FALSE)
fecal_mic     <- read_csv(SS("params_fecal_microbiome.csv"), show_col_types = FALSE)
diversity     <- read_csv(SS("params_diversity.csv"), show_col_types = FALSE)
antibodies    <- read_csv(SS("params_antibodies.csv"), show_col_types = FALSE)
macronutrients <- read_csv(SS("params_macronutrients.csv"), show_col_types = FALSE)
household     <- read_csv(SS("params_household.csv"), show_col_types = FALSE)
correlations  <- read_csv(SS("params_correlations.csv"), show_col_types = FALSE)
delivery      <- read_csv(SS("params_delivery.csv"), show_col_types = FALSE)
ebf_table     <- read_csv(SS("params_ebf.csv"), show_col_types = FALSE)

lookup <- jsonlite::read_json(SS("params_lookup.json"), simplifyVector = TRUE)

# ---- provenance collector ----------------------------------------------------
provenance <- tibble(
  variable = character(), layer = character(), source_paper = character(),
  source_table = character(), statistic_used = character(),
  distribution = character(), notes = character()
)
add_prov <- function(variable, layer, source_paper, source_table, statistic_used,
                     distribution, notes = "") {
  provenance <<- bind_rows(provenance,
    tibble(variable = variable, layer = layer, source_paper = source_paper,
           source_table = source_table, statistic_used = statistic_used,
           distribution = distribution, notes = notes))
  invisible(NULL)
}

rtruncnorm <- function(n, mean, sd, lo = -Inf, hi = Inf) {
  sd <- pmax(sd, 1e-9)
  lo_q <- pnorm((lo - mean) / sd); hi_q <- pnorm((hi - mean) / sd)
  hi_q <- pmax(hi_q, lo_q + 1e-9)
  u <- lo_q + (hi_q - lo_q) * runif(n)
  qnorm(u, mean = mean, sd = sd)
}

# =============================================================================
# 1) Dyad scaffold
# =============================================================================
dyads <- cohorts %>%
  mutate(row = list(seq_len(sum(cohorts$n_dyads)))) %>% pull(row) %>% unlist()

dyad_tab <- bind_rows(lapply(seq_len(nrow(cohorts)), function(i) {
  co <- cohorts[i, ]
  tibble(
    dyad_id = sprintf("INS-%s-%03d", co$cohort, seq_len(co$n_dyads)),
    cohort = co$cohort,
    cohort_name = co$cohort_name,
    country = co$country,
    region_income = co$region_income,
    setting = co$setting
  )
})) %>%
  mutate(cohort = factor(cohort, levels = cohorts$cohort))
N <- nrow(dyad_tab)
stopifnot(N == 410L)

# per-cohort row index for fast lookups
idx_by_cohort <- split(seq_len(N), dyad_tab$cohort)

# =============================================================================
# 2) Maternal & infant characteristics (McGuire 2017 T1 + Lane 2019 T1 +
#    Ruiz 2017 T1 + Pace 2021 text)
# =============================================================================
# draw each maternal trait from a cohort-specific truncated normal.
# plausible truncation ranges (documented assumptions):
plausible <- list(
  maternal_age_y = c(16, 45),
  parity_n = c(1, 10),
  postpartum_d = c(14, 120),
  maternal_weight_kg = c(35, 120),
  maternal_height_cm = c(140, 200),
  maternal_bmi_kg_m2 = c(14, 40)
)

mat_wide <- as_tibble(lapply(split(maternal, maternal$analyte_id), function(df) {
  v <- numeric(N)
  for (co in cohorts$cohort) {
    d <- df[df$cohort == co, ]
    ii <- idx_by_cohort[[co]]
    v[ii] <- rtruncnorm(length(ii), d$mean, d$sem * sqrt(d$n),
                        plausible[[d$analyte_id[1]]][1], plausible[[d$analyte_id[1]]][2])
  }
  v
}))

# enforce internal consistency: BMI ~ weight/height^2 (recompute BMI from
# weight & height, blended with drawn BMI so cohort mean/sem stay close)
bmi_calc <- mat_wide$maternal_weight_kg / (mat_wide$maternal_height_cm / 100)^2
mat_wide$maternal_bmi_kg_m2 <- pmin(pmax(0.6 * bmi_calc + 0.4 * mat_wide$maternal_bmi_kg_m2,
                                         plausible$maternal_bmi_kg_m2[1]),
                                    plausible$maternal_bmi_kg_m2[2])

dyad_tab <- bind_cols(dyad_tab, mat_wide)
walk(unique(maternal$analyte_id), ~add_prov(
  .x, "maternal_characteristics", "mcguire2017", "Table 1",
  "mean, SEM per cohort (SD = SEM*sqrt(n))",
  "truncated normal (cohort-specific)",
  ifelse(.x == "maternal_bmi_kg_m2",
         "BMI recomputed for internal consistency with weight & height, then blended (60/40)",
         "")))

# delivery mode: vaginal probability per cohort (Ruiz 2017 T1; ETR = 86% assumed)
dyad_tab$delivery_mode <- {
  p <- delivery$vaginal_pct[match(dyad_tab$cohort, delivery$cohort)] / 100
  ifelse(runif(N) < p, "vaginal", "cesarean")
}
add_prov("delivery_mode", "maternal_characteristics", "ruiz2017", "Table 1",
         "% of subjects (C-section) per site; vaginal = 1 - C-section",
         "Bernoulli",
         "ETR not in Ruiz 2017; assumed Pace 2021 overall 86% vaginal")

# infant sex 50/50
dyad_tab$infant_sex <- ifelse(runif(N) < 0.5, "female", "male")
add_prov("infant_sex", "maternal_characteristics", "pace2021 / lackey2019 Table 1",
         "approx. 50/50 in all cohorts (Lackey 2019 T1: 42-56% female)",
         "Bernoulli(0.5)", "per-cohort % female varies 42-56% in Lackey 2019; assumed 50/50")

# exclusive breastfeeding: Lane 2019 per-cohort where printed, else 60% overall (Pace 2021)
p_ebf <- ebf_table$ebf_pct[match(dyad_tab$cohort, ebf_table$cohort)] / 100
dyad_tab$exclusive_breastfed <- runif(N) < p_ebf
add_prov("exclusive_breastfed", "maternal_characteristics", "lane2019 / pace2021",
         "Lane 2019 Table 1 (per-population proportion); Pace 2021 text (overall 60%)",
         "proportion per population; Bernoulli", "Binomial draw",
         "USC missing in Lane 2019 - pooled overall 60% (Pace 2021) used and flagged")

# household composition (Lane 2019 T1; USC = pooled)
hh_draw <- function(id) {
  d <- household[household$analyte_id == id, ]
  v <- numeric(N)
  pooled_mean <- weighted.mean(d$mean, d$n, na.rm = TRUE)
  pooled_sd   <- sqrt(weighted.mean(d$sd^2, d$n, na.rm = TRUE))
  for (co in cohorts$cohort) {
    dc <- d[d$cohort == co, ]
    ii <- idx_by_cohort[[co]]
    if (nrow(dc) == 0 || is.na(dc$mean)) {  # USC
      v[ii] <- rtruncnorm(length(ii), pooled_mean, pooled_sd, 0, Inf)
    } else {
      v[ii] <- rtruncnorm(length(ii), dc$mean, dc$sd, 0, Inf)
    }
  }
  v
}
hh_prop <- function(id) {
  d <- household[household$analyte_id == id, ]
  p <- d$prop[match(dyad_tab$cohort, d$cohort)]
  pooled <- weighted.mean(d$prop, d$n, na.rm = TRUE)
  p[is.na(p)] <- pooled
  p
}
dyad_tab$household_size_n <- round(pmax(2, hh_draw("household_size_n")))
sib_pres <- runif(N) < hh_prop("sibling_present")
sib_n <- round(hh_draw("siblings_n"))
sib_n[sib_pres & sib_n < 1] <- 1
dyad_tab$siblings_n <- ifelse(sib_pres, sib_n, 0)
dyad_tab$sibling_present <- sib_pres
dyad_tab$extended_family_n <- round(hh_draw("extended_family_n"))
dyad_tab$extended_family_present <- runif(N) < hh_prop("extended_family_present")
dyad_tab$father_present <- runif(N) < hh_prop("father_present")
add_prov(c("household_size_n", "siblings_n", "sibling_present",
           "extended_family_n", "extended_family_present", "father_present"),
         rep("household_composition", 6),
         rep("lane2019", 6), rep("Table 1", 6),
         rep("mean +/- SD per population (proportions where applicable)", 6),
         rep("truncated normal (>=0) / Bernoulli", 6),
         "USC excluded from Lane 2019 - pooled-population values used and flagged")

# =============================================================================
# 3) Secretor status (McGuire 2017 Fig 3 text; assumed 80% where not printed)
# =============================================================================
p_sec <- secretor$secretor_pct[match(dyad_tab$cohort, secretor$cohort)] / 100
dyad_tab$secretor_status <- runif(N) < p_sec
add_prov("secretor_status", "secretor_status", "mcguire2017", "Figure 3 (text)",
         "% secretors per cohort where printed (PE 98, USC 95, GN 68, USW 68, GBR/ETR ~65)",
         "Bernoulli(p)",
         "cohorts without a printed value assumed 80% (flag); GBR/ETR exact split unverified")

# =============================================================================
# 4) HMOs (19 individually; total = sum). Log-normal marginals + Gaussian copula
# =============================================================================
# joint latent layout: [maternal traits used in correlations] + [19 HMOs] +
# [small-HMO latent] + [milk Lactobacillus, milk Bifido, fecal Lactobacillus,
# fecal Bifido]. We first build a Gaussian copula for the maternal+HMO block,
# then extend to the microbiome block sharing the milk/fecal latent columns.

hmo_ids <- setdiff(unique(hmo$analyte_id), "hmo_total_nmol_ml")
trait_ids <- c("maternal_age_y", "maternal_weight_kg", "postpartum_d")
small_id <- "hmo_grp_small_hmos_nmol_ml"
latent_names <- c(trait_ids, hmo_ids, small_id,
                  "milk_g_lactobacillus_pct", "milk_g_bifidobacterium_pct",
                  "fecal_g_lactobacillus_pct", "fecal_g_bifidobacterium_pct",
                  "maternal_bmi_kg_m2")
K <- length(latent_names)

# Start from a weak baseline correlation so the matrix is PD, then write the
# published Spearman correlations (converted to Pearson-ish via 2 sin(rho*pi/6))
Rbase <- diag(K)
dimnames(Rbase) <- list(latent_names, latent_names)
sp2r <- function(rho) 2 * sin(rho * pi / 6)
for (i in seq_len(nrow(correlations))) {
  a <- correlations$var1[i]; b <- correlations$var2[i]; r <- correlations$rho[i]
  if (a %in% latent_names && b %in% latent_names) {
    rr <- sp2r(r)
    Rbase[a, b] <- rr; Rbase[b, a] <- rr
  }
}
# ensure positive-definite
eig <- eigen(Rbase, symmetric = TRUE)
if (min(eig$values) < 1e-6) {
  eig$values <- pmax(eig$values, 1e-6)
  Rpd <- eig$vectors %*% diag(eig$values) %*% t(eig$vectors)
  Rpd <- cov2cor(Rpd)
} else {
  Rpd <- Rbase
}
Z <- mvrnorm(n = N, mu = rep(0, K), Sigma = Rpd)
colnames(Z) <- latent_names
# convert each latent to a uniform (its own rank-based mapping)
U <- apply(Z, 2, function(z) pnorm(z))

# ---- map to marginal distributions ------------------------------------------
# maternal traits we correlate with: override age / weight / postpartum with
# copula-mapped values blended with the cohort draws via ranks so cohort
# means/SEMs are preserved and trait-HMO correlations emerge
blend_copula <- function(latent_z, base_draws) {
  # use latent to re-order base_draws within each cohort -> preserves cohort
  # marginal exactly while inducing the copula correlation
  out <- numeric(N)
  for (co in cohorts$cohort) {
    ii <- idx_by_cohort[[co]]
    out[ii] <- sort(base_draws[ii])[rank(latent_z[ii])]
  }
  out
}
dyad_tab$maternal_age_y <- blend_copula(Z[, "maternal_age_y"], dyad_tab$maternal_age_y)
dyad_tab$maternal_weight_kg <- blend_copula(Z[, "maternal_weight_kg"], dyad_tab$maternal_weight_kg)
dyad_tab$postpartum_d <- blend_copula(Z[, "postpartum_d"], dyad_tab$postpartum_d)
dyad_tab$maternal_bmi_kg_m2 <- blend_copula(Z[, "maternal_bmi_kg_m2"], dyad_tab$maternal_bmi_kg_m2)

# HMO log-normal marginals: derive log-SD from SEM*sqrt(n) on raw scale via MoM
hmo_wide <- matrix(NA_real_, nrow = N, ncol = length(hmo_ids),
                   dimnames = list(NULL, hmo_ids))
for (id in hmo_ids) {
  df <- hmo[hmo$analyte_id == id, ]
  for (co in cohorts$cohort) {
    d <- df[df$cohort == co, ]
    ii <- idx_by_cohort[[co]]
    sd_raw <- d$sem * sqrt(d$n)
    cv2 <- (sd_raw / d$mean)^2
    sig2 <- log1p(cv2)
    mu_log <- log(d$mean) - sig2 / 2
    # map the rank-preserving latent through the log-normal quantile function
    hmo_wide[ii, id] <- qlnorm(U[ii, id], meanlog = mu_log, sdlog = sqrt(sig2))
  }
}

# ---- secretor adjustment -----------------------------------------------------
# Peptide details from McGuire 2017 (non-secretors lack a1-2 fucosylated HMOs):
# near-zero: 2'FL, LNFP I, DFLac; increased: LNT and LNFP II (milk compensates).
# For each cohort, the non-secretor cap = 2% of that cohort's secretor mean.
nonsec <- !dyad_tab$secretor_status
sec_cap_vec <- function(col) {
  df <- hmo[hmo$analyte_id == col, ]
  df$mean[match(as.character(dyad_tab$cohort), df$cohort)]
}
hmo_wide[nonsec, "hmo_2fl_nmol_ml"]   <- 0.02 * sec_cap_vec("hmo_2fl_nmol_ml")[nonsec]
hmo_wide[nonsec, "hmo_lnfp_i_nmol_ml"] <- pmin(hmo_wide[nonsec, "hmo_lnfp_i_nmol_ml"],
                                               0.02 * sec_cap_vec("hmo_lnfp_i_nmol_ml")[nonsec])
hmo_wide[nonsec, "hmo_dflac_nmol_ml"] <- pmin(hmo_wide[nonsec, "hmo_dflac_nmol_ml"],
                                              0.02 * sec_cap_vec("hmo_dflac_nmol_ml")[nonsec])
hmo_wide[nonsec, "hmo_lnt_nmol_ml"]    <- hmo_wide[nonsec, "hmo_lnt_nmol_ml"] * 1.3
hmo_wide[nonsec, "hmo_lnfp_ii_nmol_ml"] <- hmo_wide[nonsec, "hmo_lnfp_ii_nmol_ml"] * 1.3

hmo_df <- as_tibble(hmo_wide)
hmo_df$hmo_total_nmol_ml <- rowSums(hmo_df[, hmo_ids])
walk(hmo_ids, ~add_prov(
  .x, "hmo", "mcguire2017", "Table 2",
  "mean, SEM per cohort (nmol/mL); SD=SEM*sqrt(n)",
  "log-normal, method of moments on raw mean/SEM; Gaussian copula across HMOs",
  ifelse(.x %in% c("hmo_2fl_nmol_ml", "hmo_lnfp_i_nmol_ml", "hmo_dflac_nmol_ml"),
         "non-secretors forced near-zero (<=2% of secretor mean)",
         ifelse(.x %in% c("hmo_lnt_nmol_ml", "hmo_lnfp_ii_nmol_ml"),
                "increased ×1.3 in non-secretors (McGuire 2017 p8)", ""))))
add_prov("hmo_total_nmol_ml", "hmo", "mcguire2017", "Table 2",
         "sum of 19 individual HMOs; checked vs published Total",
         "derived (sum)", "")

# =============================================================================
# 5) Immune factors (23 analytes): zero-inflated log-normal + Caffé 2023 tilt
# =============================================================================
# per-cohort detection probability & log-normal params from Ruiz 2017 T2-T5;
# ETR -> NA + flag (immune_measured = FALSE)
immune_df <- as_tibble(matrix(NA_real_, nrow = N, ncol = length(unique(immune$analyte_id)),
                              dimnames = list(NULL, unique(immune$analyte_id))))
imm_ids <- unique(immune$analyte_id)
for (id in imm_ids) {
  df <- immune[immune$analyte_id == id, ]
  for (co in cohorts$cohort) {
    ii <- idx_by_cohort[[co]]
    if (co == "ETR") next  # stays NA
    d <- df[df$cohort == co, ]
    if (nrow(d) == 0) next
    det <- pmin(pmax(d$det_pct, 0), 100) / 100
    detected <- runif(length(ii)) < det
    lsigma <- (log(pmax(d$iqr_u, d$median * 1.01)) - log(pmax(d$iqr_l, d$median * 0.25))) / (2 * 0.6745)
    lsigma <- pmax(lsigma, 0.05)
    vals <- rlnorm(length(ii), meanlog = log(d$median), sdlog = lsigma)
    vals[!detected] <- 0
    immune_df[ii, id] <- vals
  }
  add_prov(id, "immune_factors", "ruiz2017",
           "Tables 2-5",
           "detection % (Table 2); median + IQR (ng/L, Tables 3-5)",
           "zero-inflated log-normal; log-SD = (log IQR_u - log IQR_l)/1.349",
           ifelse(isTRUE(immune$median_was_nd[immune$analyte_id == id][1]),
                  "some cohorts median='nd' (below detection) - pooled median used",
                  ifelse(id == "imm_ifng_ng_l", "INFγ normalised to IFNγ in CSV", "")))
}
dyad_tab$immune_measured <- dyad_tab$cohort != "ETR"
add_prov("immune_measured", "immune_factors", "ruiz2017", "Table 1/Methods",
         "ETR excluded (chemically preserved milk)", "flag",
         "all 23 immune analytes NA for ETR")

# Caffé 2023: maternal DDS per pooled mean/SD, then tilt IgG/IgM/IL-10 by
# female-infant x DDS interaction (beta from Table 3); light touch per brief.
caffe_dds_pool <- list(mean = 5.0, sd = 1.7)  # Caffé 2023 Table 1 (maternal DDS approx)
# try to read actual value if present
caffe_t1 <- tryCatch(
  read_csv(file.path("data", "inspire", "summary_stats", "caffe2023_Table1.csv"),
           col_types = cols(.default = col_character()), locale = locale(encoding = "UTF-8"),
           show_col_types = FALSE),
  error = function(e) NULL)
if (!is.null(caffe_t1)) {
  dds_row <- caffe_t1 %>%
    filter(analyte == "maternal diet diversity score", statistic == "mean")
  dds_row_sd <- caffe_t1 %>%
    filter(analyte == "maternal diet diversity score", statistic == "SD")
  if (nrow(dds_row) == 1) caffe_dds_pool$mean <- as.numeric(dds_row$value)
  if (nrow(dds_row_sd) == 1) caffe_dds_pool$sd <- as.numeric(dds_row_sd$value)
}
# read betas from params
caffe_betas <- read_csv(SS("params_caffe_betas.csv"), show_col_types = FALSE) %>%
  mutate(analyte_id = recode(analyte_id,
                             "imm_iga_ng_l" = "imm_iga_ng_l",
                             "imm_igg_ng_l" = "imm_igg_ng_l",
                             "imm_igm_ng_l" = "imm_igm_ng_l",
                             "imm_egf_ng_l" = "imm_egf_ng_l",
                             "imm_tgfb2_ng_l" = "imm_tgfb2_ng_l",
                             "imm_il10_ng_l" = "imm_il10_ng_l",
                             .default = analyte_id))
mat_dds <- rtruncnorm(N, caffe_dds_pool$mean, caffe_dds_pool$sd, 1, 10)
dyad_tab$maternal_dds <- mat_dds
add_prov("maternal_dds", "maternal_characteristics", "caffe2023", "Table 1",
         "maternal diet diversity score, overall mean +/- SD",
         "truncated normal (range 1-10)",
         "not cohort-specific; pooled value (Caffé 2023 excludes ETR)")
female_ind <- as.numeric(dyad_tab$infant_sex == "female")
dds_c <- mat_dds - mean(mat_dds)
apply_caffe <- function(id) {
  b <- caffe_betas$beta_value[caffe_betas$analyte_id == id]
  if (length(b) == 0 || is.na(b)) return(invisible(NULL))
  mask <- !is.na(immune_df[[id]])
  immune_df[mask, id] <<- exp(log(pmax(immune_df[[id]][mask], 1e-3)) +
                                b * female_ind[mask] * dds_c[mask])
  add_prov(paste0(id, " | Caffé tilt"), "immune_factors", "caffe2023",
           "Table 3 (LME beta, infant sex x maternal DDS)",
           "Published LME beta coefficient on log-scale",
           paste0("deterministic log-scale shift for female x DDS-centred; beta=", round(b, 3)))
}
invisible(lapply(c("imm_igg_ng_l", "imm_igm_ng_l", "imm_il10_ng_l"), apply_caffe))

# =============================================================================
# 6) Milk microbiome (29 genera): presence by prevalence + logit-normal +
#    row renormalisation to 100 %
# =============================================================================
sim_microbiome <- function(df_mic, link_cohort_latent = NULL, id_prefix = "milk_g_") {
  genera <- unique(df_mic$analyte_id)
  # latent normal per genus x dyad via AR(1)-free: independent, but for the two
  # linked genera use the copula latent
  L <- matrix(NA_real_, nrow = N, ncol = length(genera), dimnames = list(NULL, genera))
  for (g in genera) {
    d <- df_mic[df_mic$analyte_id == g, ]
    for (co in cohorts$cohort) {
      ii <- idx_by_cohort[[co]]
      dd <- d[d$cohort == co, ]
      mu <- pmin(pmax(dd$mean / 100, 1e-5), 0.999)  # fraction
      sd_raw <- pmax(dd$sem * sqrt(dd$n) / 100, 1e-4)
      # dispersion on logit scale (approx delta method): sd_logit ~ sd/(p(1-p))
      sig_logit <- pmax(sd_raw / (mu * (1 - mu)), 0.05)
      if (!is.null(link_cohort_latent) && g %in% names(link_cohort_latent)) {
        z <- link_cohort_latent[[g]][ii]
      } else {
        z <- rnorm(length(ii))
      }
      L[ii, g] <- qlogis(mu) + sig_logit * z
      # presence (zero-inflate) by prevalence where a prevalence % was published
      if (!is.na(dd$prev_pct)) {
        pres <- runif(length(ii)) < pmin(pmax(dd$prev_pct, 0), 100) / 100
        L[ii[!pres], g] <- -Inf
      }
    }
  }
  P <- plogis(L); P[is.infinite(L)] <- 0
  rs <- rowSums(P)
  P <- P / rs * 100
  as_tibble(P)
}
link_lacto <- Z[, "milk_g_lactobacillus_pct"]
link_bifido <- Z[, "milk_g_bifidobacterium_pct"]
link_fec_lacto <- Z[, "fecal_g_lactobacillus_pct"]
link_fec_bifido <- Z[, "fecal_g_bifidobacterium_pct"]

milk_df <- sim_microbiome(milk_mic,
  link_cohort_latent = list(milk_g_lactobacillus_pct = link_lacto,
                            milk_g_bifidobacterium_pct = link_bifido))
fecal_df <- sim_microbiome(fecal_mic,
  link_cohort_latent = list(fecal_g_lactobacillus_pct = link_fec_lacto,
                            fecal_g_bifidobacterium_pct = link_fec_bifido))

walk(unique(milk_mic$analyte_id), ~add_prov(
  .x, "milk_microbiome", "lackey2019", "Table 5 (mean/SEM) + Table 3 (prevalence)",
  "mean, SEM (relative abundance %) + % prevalence where published",
  "logit-normal centred on cohort mean, SEM-based dispersion; presence = Bernoulli(prev)",
  "rows renormalised to 100% after presence masking"))
walk(unique(fecal_mic$analyte_id), ~add_prov(
  .x, "fecal_microbiome", "lackey2019", "Table 2 (mean/SEM) + Table 3 (prevalence)",
  "mean, SEM (relative abundance %) + % prevalence where published",
  "logit-normal centred on cohort mean, SEM-based dispersion; presence = Bernoulli(prev)",
  "rows renormalised to 100% after presence masking"))

# diversity indices computed from simulated abundances
shannon <- function(P) -rowSums(P * log(P + 1e-12), na.rm = TRUE) / 100
richness <- function(P) rowSums(P > 1e-4)
inv_simpson <- function(P) 1 / rowSums((P / 100)^2)
milk_df$milk_div_richness <- richness(as.matrix(milk_df[, unique(milk_mic$analyte_id)]))
milk_df$milk_div_shannon_diversity <- shannon(as.matrix(milk_df[, unique(milk_mic$analyte_id)]))
milk_df$milk_div_inverse_simpson_diversity <- inv_simpson(as.matrix(milk_df[, unique(milk_mic$analyte_id)]))
fecal_df$fecal_div_richness <- richness(as.matrix(fecal_df[, unique(fecal_mic$analyte_id)]))
fecal_df$fecal_div_shannon_diversity <- shannon(as.matrix(fecal_df[, unique(fecal_mic$analyte_id)]))
fecal_df$fecal_div_inverse_simpson_diversity <- inv_simpson(as.matrix(fecal_df[, unique(fecal_mic$analyte_id)]))
walk(c("milk_div_richness", "milk_div_shannon_diversity", "milk_div_inverse_simpson_diversity",
       "fecal_div_richness", "fecal_div_shannon_diversity", "fecal_div_inverse_simpson_diversity"),
     ~add_prov(.x, gsub("^(milk|fecal).*", "\\1_microbiome", .x), "lackey2019", "Table 4",
               "computed from simulated relative abundances; validated vs published T4 mean/SEM",
               "derived (Shannon / richness / inverse Simpson)"))

# =============================================================================
# 7) Antibodies IgA / IgG (McGuire 2021 T1/T2): normal, truncated to range
# =============================================================================
ab_ids <- unique(antibodies$analyte_id)
ab_df <- as_tibble(matrix(NA_real_, nrow = N, ncol = length(ab_ids),
                          dimnames = list(NULL, ab_ids)))
for (id in ab_ids) {
  df <- antibodies[antibodies$analyte_id == id, ]
  metric <- df$metric[1]
  for (co in cohorts$cohort) {
    ii <- idx_by_cohort[[co]]
    d <- df[df$cohort == co, ]
    sd <- d$sem * sqrt(d$n)
    if (metric == "breadth_score") {
      ab_df[ii, id] <- rtruncnorm(length(ii), d$mean, sd, 0.01, 0.99)
    } else {
      ab_df[ii, id] <- pmax(0, rtruncnorm(length(ii), d$mean, sd, 0, d$mean + 4 * sd))
    }
  }
  add_prov(id, "antibodies", "mcguire2021", df$table[1],
           "mean, SEM per cohort (mean [SEM])",
           ifelse(metric == "breadth_score",
                  "truncated normal in (0.01, 0.99)",
                  "truncated normal in (0, mean+4SD)"))
}

# =============================================================================
# 8) Macronutrients (overall only; flag as not cohort-specific)
# =============================================================================
macro_df <- as_tibble(matrix(NA_real_, nrow = N, ncol = nrow(macronutrients),
                             dimnames = list(NULL, macronutrients$analyte_id)))
for (i in seq_len(nrow(macronutrients))) {
  m <- macronutrients[i, ]
  macro_df[[m$analyte_id]] <- rtruncnorm(N, m$mean, m$sd, m$range_lo, m$range_hi)
  add_prov(m$analyte_id, "macronutrients", m$source_paper, m$source_table,
           "overall mean +/- SD + range (g/L)", m$distribution, m$flag)
}

# =============================================================================
# 9) Assemble wide table + long tables
# =============================================================================
wide <- dyad_tab %>%
  dplyr::select(dyad_id, cohort, cohort_name, country, region_income, setting,
         maternal_age_y, parity_n, maternal_weight_kg, maternal_height_cm,
         maternal_bmi_kg_m2, postpartum_d, delivery_mode, infant_sex,
         exclusive_breastfed, maternal_dds,
         household_size_n, siblings_n, sibling_present,
         extended_family_n, extended_family_present, father_present,
         secretor_status, immune_measured) %>%
  bind_cols(hmo_df, immune_df, milk_df, fecal_df, ab_df, macro_df)

write_csv(wide, SS("simulated_dyads.csv"))

# long tables ------------------------------------------------------------------
unit_of <- function(id) {
  case_when(
    grepl("_nmol_ml$", id) ~ "nmol/mL",
    grepl("_pct$", id) ~ "%",
    grepl("^imm_", id) ~ "ng/L",
    grepl("^ab_.*breadth_score$", id) ~ "breadth score (proportion reactive)",
    grepl("^ab_.*react_", id) ~ "mean normalized intensity score",
    grepl("^macro_", id) ~ "g/L",
    grepl("_n$", id) ~ "count",
    grepl("_y$", id) ~ "years",
    grepl("_kg_m2$", id) ~ "kg/m2",
    grepl("_kg$", id) ~ "kg",
    grepl("_cm$", id) ~ "cm",
    grepl("_d$", id) ~ "days",
    TRUE ~ ""
  )
}
long_of <- function(df_wide, cols, analyte_label_pretty) {
  df_wide %>%
    dplyr::select(dyad_id, cohort, dplyr::all_of(cols)) %>%
    pivot_longer(-c(dyad_id, cohort), names_to = "analyte", values_to = "value") %>%
    mutate(unit = unit_of(analyte)) %>%
    dplyr::select(dyad_id, cohort, analyte, value, unit)
}
pretty_from_params <- function(param_df, layer) {
  param_df %>% distinct(analyte, analyte_id) %>% mutate(layer = layer)
}
write_csv(long_of(wide, c(hmo_ids, "hmo_total_nmol_ml")), SS("simulated_hmo_long.csv"))
write_csv(long_of(wide, imm_ids), SS("simulated_immune_long.csv"))
write_csv(long_of(wide, unique(milk_mic$analyte_id)), SS("simulated_milk_microbiome_long.csv"))
write_csv(long_of(wide, unique(fecal_mic$analyte_id)), SS("simulated_fecal_microbiome_long.csv"))
write_csv(long_of(wide, ab_ids), SS("simulated_antibodies_long.csv"))

# =============================================================================
# 10) provenance + data dictionary
# =============================================================================
write_csv(provenance, SS("provenance.csv"))

layer_of <- function(id) {
  case_when(
    id %in% c("dyad_id", "cohort", "cohort_name", "country", "region_income",
              "setting") ~ "identifier/metadata",
    id %in% c("maternal_age_y", "parity_n", "maternal_weight_kg",
              "maternal_height_cm", "maternal_bmi_kg_m2", "postpartum_d",
              "delivery_mode", "infant_sex", "exclusive_breastfed",
              "maternal_dds") ~ "maternal_characteristics",
    id %in% c("household_size_n", "siblings_n", "sibling_present",
              "extended_family_n", "extended_family_present", "father_present") ~ "household_composition",
    id == "secretor_status" ~ "secretor_status",
    grepl("^hmo_", id) ~ "hmo",
    id == "immune_measured" ~ "immune_factors",
    grepl("^imm_", id) ~ "immune_factors",
    grepl("^milk_g_", id) | grepl("^milk_div_", id) ~ "milk_microbiome",
    grepl("^fecal_g_", id) | grepl("^fecal_div_", id) ~ "fecal_microbiome",
    grepl("^ab_", id) ~ "antibodies",
    grepl("^macro_", id) ~ "macronutrients",
    TRUE ~ "other"
  )
}
descr_of <- function(id) {
  case_when(
    id == "dyad_id" ~ "unique dyad identifier (SIMULATED, e.g. INS-ETR-001)",
    id == "cohort" ~ "11-level cohort factor (code)",
    id == "cohort_name" ~ "cohort full name (code)",
    id == "country" ~ "country/population name as in McGuire 2017 Table 1",
    id == "region_income" ~ "LMIC vs HIC grouping as used in McGuire 2021",
    id == "setting" ~ "rural/urban where defined in the parent study",
    id == "maternal_age_y" ~ "maternal age",
    id == "parity_n" ~ "parity (number of births)",
    id == "maternal_weight_kg" ~ "maternal weight",
    id == "maternal_height_cm" ~ "maternal height",
    id == "maternal_bmi_kg_m2" ~ "maternal body mass index",
    id == "postpartum_d" ~ "days postpartum at milk sampling",
    id == "delivery_mode" ~ "vaginal / cesarean",
    id == "infant_sex" ~ "female / male",
    id == "exclusive_breastfed" ~ "exclusively breastfed at sampling (TRUE/FALSE)",
    id == "maternal_dds" ~ "maternal dietary diversity score (Caffé 2023)",
    id == "household_size_n" ~ "household size (individuals, Lane 2019)",
    id == "siblings_n" ~ "number of siblings in household",
    id == "sibling_present" ~ "any sibling present in household (TRUE/FALSE)",
    id == "extended_family_n" ~ "number of extended-family members",
    id == "extended_family_present" ~ "extended family present (TRUE/FALSE)",
    id == "father_present" ~ "father present in household (TRUE/FALSE)",
    id == "secretor_status" ~ "maternal secretor status (TRUE = secretor, McGuire 2017 Fig 3)",
    id == "immune_measured" ~ "FALSE for ETR (chemically preserved milk, Ruiz 2017); immune analytes NA",
    grepl("_nmol_ml$", id) ~ gsub("_", " ", sub("^hmo_", "HMO ", sub("_nmol_ml$", "", id))),
    grepl("^imm_.*_ng_l$", id) ~ paste("immune factor", sub("_ng_l$", "", sub("^imm_", "", id)), "(ng/L)"),
    grepl("^milk_g_.*_pct$", id) ~ paste("milk genus relative abundance", sub("_pct$", "", sub("^milk_g_", "", id)), "(%)"),
    grepl("^fecal_g_.*_pct$", id) ~ paste("infant fecal genus relative abundance", sub("_pct$", "", sub("^fecal_g_", "", id)), "(%)"),
    grepl("^milk_div_", id) ~ paste("milk microbiome diversity index", sub("^milk_div_", "", id)),
    grepl("^fecal_div_", id) ~ paste("infant fecal microbiome diversity index", sub("^fecal_div_", "", id)),
    grepl("^ab_.*breadth_score$", id) ~ paste("antibody breadth score", sub("_breadth_score$", "", sub("^ab_", "", id))),
    grepl("^ab_.*react_", id) ~ paste("antibody reactivity", sub("^ab_", "", id)),
    grepl("^macro_", id) ~ paste("macronutrient", sub("_g_l$", "", sub("^macro_", "", id))),
    TRUE ~ id
  )
}
dict <- tibble(
  column_name = names(wide),
  layer = layer_of(names(wide)),
  unit = unit_of(names(wide)),
  description = descr_of(names(wide))
)
write_csv(dict, SS("data_dictionary.csv"))

cat("02_simulate_dyads.R complete.\n")
cat("  wide:", nrow(wide), "rows x", ncol(wide), "cols\n")
cat("  long tables + provenance + data dictionary written to", OUT_DIR, "\n")
