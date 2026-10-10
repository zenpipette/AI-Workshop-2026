# Validation report — SIMULATED INSPIRE-like dyad dataset
 
> **SIMULATED DATA.** This report describes **SIMULATED** data. Values were generated
 
> from summary statistics published in the INSPIRE study papers (McGuire 2017 AJCN;
 
> Ruiz 2017 Front Immunol; Lackey 2019 Front Nutr; Lane 2019 AJPA; McGuire 2021
 
> Front Immunol; Pace 2021 Microorganisms; Caffé 2023 AJHB). **No individual-level
 
> INSPIRE data were used.** Individual values are synthetic; only group-level
 
> patterns resemble the published results.
 

Generated: 2026-10-10 04:06 PDT  |  seed: 2026  |  dyads: 410  |  script: `R/03_validate_simulation.R`
 

## 1. Summary: simulated vs published per-cohort means
 

Relative error = (simulated - published) / published, computed per variable x cohort.
 
Variables with published mean == 0 are excluded from the *relative*-error tallies.

 
| layer | variables | cohort x var rows | median |rel err| | mean |rel err| | max |rel err| | within 10% | within 25% |
 
|---|---|---|---|---|---|---|---|
 
| antibodies | 48 | 528 | 0.047 | 0.089 | 1.725 | 383/528 | 485/528 |
 
| diversity_indices | 6 | 66 | 0.306 | 0.378 | 0.854 | 9/66 | 25/66 |
 
| fecal_microbiome | 28 | 308 | 0.006 | 0.029 | 0.128 | 255/308 | 308/308 |
 
| hmo | 20 | 220 | 0.000 | 0.000 | 0.002 | 220/220 | 220/220 |
 
| maternal_characteristics | 6 | 66 | 0.019 | 0.027 | 0.104 | 65/66 | 66/66 |
 
| milk_microbiome | 29 | 319 | 0.010 | 0.052 | 1.000 | 257/319 | 315/319 |
 

**Overall (mean-based layers incl. diversity rows): 1189/1507 rows (79%) within 10%; 1419/1507 (94%) within 25%.**
 

## 2. Means / SEMs: per-variable detail (non-diversity layers)
 
| layer | variable | median |rel err| | max |rel err| | median abs err (units/pp) | within 10% | within 25% |
|---|---|---|---|---|---|---|
 
| antibodies | ab_igg_s_enterica_typhi_react_all | 0.204 | 1.725 | 0.006758 | 3/11 | 7/11 |
 
| antibodies | ab_igg_shigella_react_all | 0.059 | 1.366 | 0.02731 | 6/11 | 7/11 |
 
| antibodies | ab_iga_eaec_react_all | 0.458 | 1.315 | 0.03242 | 0/11 | 4/11 |
 
| antibodies | ab_igg_shigella_react_top10 | 0.050 | 0.878 | 0.09501 | 8/11 | 9/11 |
 
| antibodies | ab_igg_epec_react_all | 0.095 | 0.798 | 0.01471 | 6/11 | 8/11 |
 
| antibodies | ab_igg_etec_react_all | 0.049 | 0.585 | 0.005212 | 8/11 | 10/11 |
 
| antibodies | ab_igg_eaec_react_all | 0.134 | 0.537 | 0.01012 | 2/11 | 8/11 |
 
| antibodies | ab_iga_epec_react_all | 0.141 | 0.395 | 0.03779 | 2/11 | 9/11 |
 
| antibodies | ab_igg_epec_breadth_score | 0.093 | 0.349 | 0.005332 | 7/11 | 10/11 |
 
| antibodies | ab_iga_s_aureus_react_all | 0.147 | 0.322 | 0.07312 | 4/11 | 9/11 |
 
| antibodies | ab_igg_m_tuberculosis_breadth_score | 0.000 | 0.321 | 0 | 8/11 | 8/11 |
 
| antibodies | ab_iga_s_enterica_typhi_react_all | 0.093 | 0.299 | 0.03909 | 6/11 | 10/11 |
 
| antibodies | ab_igg_m_tuberculosis_react_top10 | 0.044 | 0.274 | 0.01661 | 9/11 | 10/11 |
 
| antibodies | ab_iga_s_pneumoniae_react_all | 0.061 | 0.249 | 0.03465 | 7/11 | 11/11 |
 
| antibodies | ab_iga_m_tuberculosis_react_all | 0.086 | 0.245 | 0.04436 | 7/11 | 11/11 |
 
| antibodies | ab_igg_s_pneumoniae_breadth_score | 0.051 | 0.231 | 0.00817 | 10/11 | 11/11 |
 
| antibodies | ab_iga_etec_react_all | 0.114 | 0.227 | 0.04348 | 5/11 | 11/11 |
 
| antibodies | ab_igg_m_tuberculosis_react_all | 0.066 | 0.220 | 0.00795 | 7/11 | 11/11 |
 
| antibodies | ab_igg_s_enterica_typhi_react_top10 | 0.036 | 0.218 | 0.01097 | 7/11 | 11/11 |
 
| antibodies | ab_igg_eaec_react_top10 | 0.061 | 0.188 | 0.01518 | 6/11 | 11/11 |
 
| antibodies | ab_igg_s_aureus_react_all | 0.039 | 0.170 | 0.03725 | 10/11 | 11/11 |
 
| antibodies | ab_iga_etec_breadth_score | 0.032 | 0.163 | 0.004827 | 9/11 | 11/11 |
 
| antibodies | ab_igg_s_pneumoniae_react_all | 0.043 | 0.162 | 0.02486 | 8/11 | 11/11 |
 
| antibodies | ab_igg_etec_react_top10 | 0.065 | 0.150 | 0.03081 | 10/11 | 11/11 |
 
| antibodies | ab_igg_epec_react_top10 | 0.028 | 0.150 | 0.02763 | 10/11 | 11/11 |
 
| antibodies | ab_igg_shigella_breadth_score | 0.048 | 0.147 | 0.008386 | 8/11 | 10/11 |
 
| antibodies | ab_igg_s_aureus_breadth_score | 0.043 | 0.145 | 0.01514 | 10/11 | 11/11 |
 
| antibodies | ab_iga_etec_react_top10 | 0.056 | 0.143 | 0.07091 | 8/11 | 11/11 |
 
| antibodies | ab_iga_m_tuberculosis_breadth_score | 0.050 | 0.139 | 0.01202 | 9/11 | 11/11 |
 
| antibodies | ab_iga_epec_breadth_score | 0.040 | 0.138 | 0.006872 | 9/11 | 11/11 |
 
| antibodies | ab_igg_s_pneumoniae_react_top10 | 0.021 | 0.138 | 0.05097 | 9/11 | 11/11 |
 
| antibodies | ab_iga_s_aureus_breadth_score | 0.053 | 0.135 | 0.01201 | 9/11 | 11/11 |
 
| antibodies | ab_iga_m_tuberculosis_react_top10 | 0.040 | 0.134 | 0.06939 | 9/11 | 11/11 |
 
| antibodies | ab_iga_eaec_breadth_score | 0.056 | 0.132 | 0.004999 | 8/11 | 11/11 |
 
| antibodies | ab_iga_shigella_react_top10 | 0.038 | 0.123 | 0.05983 | 10/11 | 11/11 |
 
| antibodies | ab_iga_eaec_react_top10 | 0.027 | 0.115 | 0.0265 | 10/11 | 11/11 |
 
| antibodies | ab_iga_s_enterica_typhi_react_top10 | 0.045 | 0.114 | 0.07087 | 10/11 | 11/11 |
 
| antibodies | ab_iga_s_enterica_typhi_breadth_score | 0.028 | 0.112 | 0.005652 | 10/11 | 11/11 |
 
| antibodies | ab_iga_shigella_react_all | 0.032 | 0.109 | 0.0223 | 9/11 | 11/11 |
 
| antibodies | ab_iga_epec_react_top10 | 0.037 | 0.102 | 0.08017 | 10/11 | 11/11 |
 
| antibodies | ab_iga_s_pneumoniae_breadth_score | 0.030 | 0.095 | 0.006548 | 11/11 | 11/11 |
 
| antibodies | ab_iga_shigella_breadth_score | 0.050 | 0.087 | 0.01311 | 11/11 | 11/11 |
 
| antibodies | ab_iga_s_pneumoniae_react_top10 | 0.040 | 0.080 | 0.09724 | 11/11 | 11/11 |
 
| antibodies | ab_igg_s_aureus_react_top10 | 0.038 | 0.066 | 0.1078 | 11/11 | 11/11 |
 
| antibodies | ab_iga_s_aureus_react_top10 | 0.015 | 0.056 | 0.01883 | 11/11 | 11/11 |
 
| antibodies | ab_igg_etec_breadth_score | 0.000 | 0.025 | 0 | 10/11 | 10/11 |
 
| antibodies | ab_igg_eaec_breadth_score | 0.000 | 0.000 | 0 | 8/11 | 8/11 |
 
| antibodies | ab_igg_s_enterica_typhi_breadth_score | 0.000 | 0.000 | 0 | 7/11 | 7/11 |
 
| fecal_microbiome | fecal_g_leuconostoc_pct | 0.007 | 0.128 | 0.0013 | 9/11 | 11/11 |
 
| fecal_microbiome | fecal_g_paucisalibacillus_pct | 0.006 | 0.127 | 0.00276 | 9/11 | 11/11 |
 
| fecal_microbiome | fecal_g_erysipelatoclostridium_pct | 0.007 | 0.126 | 0.005384 | 9/11 | 11/11 |
 
| fecal_microbiome | fecal_g_gemella_pct | 0.011 | 0.125 | 0.003385 | 9/11 | 11/11 |
 
| fecal_microbiome | fecal_g_acinetobacter_pct | 0.008 | 0.125 | 0.001532 | 10/11 | 11/11 |
 
| fecal_microbiome | fecal_g_rothia_pct | 0.005 | 0.125 | 0.002193 | 9/11 | 11/11 |
 
| fecal_microbiome | fecal_g_bacteroides_pct | 0.004 | 0.125 | 0.04463 | 9/11 | 11/11 |
 
| fecal_microbiome | fecal_g_lactobacillus_pct | 0.005 | 0.125 | 0.04704 | 9/11 | 11/11 |
 
| fecal_microbiome | fecal_g_tyzzerella_4_pct | 0.010 | 0.124 | 0.004093 | 10/11 | 11/11 |
 
| fecal_microbiome | fecal_g_enterococcus_pct | 0.004 | 0.124 | 0.006451 | 9/11 | 11/11 |
 
| fecal_microbiome | fecal_g_clostridium_sensu_stricto_1_pct | 0.003 | 0.123 | 0.009353 | 9/11 | 11/11 |
 
| fecal_microbiome | fecal_g_prevotella_9_pct | 0.002 | 0.123 | 0.001951 | 9/11 | 11/11 |
 
| fecal_microbiome | fecal_g_campylobacter_pct | 0.007 | 0.122 | 0.005059 | 9/11 | 11/11 |
 
| fecal_microbiome | fecal_g_megasphaera_pct | 0.005 | 0.122 | 0.004793 | 9/11 | 11/11 |
 
| fecal_microbiome | fecal_g_acetobacter_pct | 0.008 | 0.121 | 0.0008293 | 9/11 | 11/11 |
 
| fecal_microbiome | fecal_g_parabacteroides_pct | 0.003 | 0.121 | 0.006934 | 9/11 | 11/11 |
 
| fecal_microbiome | fecal_g_streptococcus_pct | 0.002 | 0.121 | 0.0241 | 9/11 | 11/11 |
 
| fecal_microbiome | fecal_g_bifidobacterium_pct | 0.004 | 0.121 | 0.02132 | 9/11 | 11/11 |
 
| fecal_microbiome | fecal_g_veillonella_pct | 0.002 | 0.120 | 0.02341 | 9/11 | 11/11 |
 
| fecal_microbiome | fecal_g_escherichia_shigella_pct | 0.004 | 0.120 | 0.0671 | 9/11 | 11/11 |
 
| fecal_microbiome | fecal_g_klebsiella_pct | 0.004 | 0.120 | 0.009873 | 9/11 | 11/11 |
 
| fecal_microbiome | fecal_g_lachnoclostridium_pct | 0.002 | 0.119 | 0.005294 | 9/11 | 11/11 |
 
| fecal_microbiome | fecal_g_lactococcus_pct | 0.015 | 0.119 | 0.005962 | 9/11 | 11/11 |
 
| fecal_microbiome | fecal_g_akkermansia_pct | 0.003 | 0.118 | 0.001419 | 9/11 | 11/11 |
 
| fecal_microbiome | fecal_g_staphylococcus_pct | 0.005 | 0.116 | 0.003666 | 9/11 | 11/11 |
 
| fecal_microbiome | fecal_g_citrobacter_pct | 0.006 | 0.116 | 0.003069 | 9/11 | 11/11 |
 
| fecal_microbiome | fecal_g_blautia_pct | 0.010 | 0.113 | 0.00357 | 9/11 | 11/11 |
 
| fecal_microbiome | fecal_g_enterobacter_pct | 0.004 | 0.110 | 0.004038 | 10/11 | 11/11 |
 
| hmo | hmo_lnfp_i_nmol_ml | 0.000 | 0.002 | 0.07862 | 11/11 | 11/11 |
 
| hmo | hmo_2fl_nmol_ml | 0.000 | 0.001 | 0 | 11/11 | 11/11 |
 
| hmo | hmo_dflac_nmol_ml | 0.000 | 0.001 | 0 | 11/11 | 11/11 |
 
| hmo | hmo_6sl_nmol_ml | 0.000 | 0.000 | 0 | 11/11 | 11/11 |
 
| hmo | hmo_total_nmol_ml | 0.000 | 0.000 | 1 | 11/11 | 11/11 |
 
| hmo | hmo_3sl_nmol_ml | 0.000 | 0.000 | 0 | 11/11 | 11/11 |
 
| hmo | hmo_flnh_nmol_ml | 0.000 | 0.000 | 0 | 11/11 | 11/11 |
 
| hmo | hmo_dslnt_nmol_ml | 0.000 | 0.000 | 0 | 11/11 | 11/11 |
 
| hmo | hmo_lnfp_ii_nmol_ml | 0.000 | 0.000 | 0 | 11/11 | 11/11 |
 
| hmo | hmo_lnfp_iii_nmol_ml | 0.000 | 0.000 | 0 | 11/11 | 11/11 |
 
| hmo | hmo_fdslnh_nmol_ml | 0.000 | 0.000 | 0 | 11/11 | 11/11 |
 
| hmo | hmo_3fl_nmol_ml | 0.000 | 0.000 | 0 | 11/11 | 11/11 |
 
| hmo | hmo_dflnh_nmol_ml | 0.000 | 0.000 | 0 | 11/11 | 11/11 |
 
| hmo | hmo_lstb_nmol_ml | 0.000 | 0.000 | 0 | 11/11 | 11/11 |
 
| hmo | hmo_dflnt_nmol_ml | 0.000 | 0.000 | 0 | 11/11 | 11/11 |
 
| hmo | hmo_lnt_nmol_ml | 0.000 | 0.000 | 0 | 11/11 | 11/11 |
 
| hmo | hmo_lstc_nmol_ml | 0.000 | 0.000 | 0 | 11/11 | 11/11 |
 
| hmo | hmo_lnnt_nmol_ml | 0.000 | 0.000 | 0 | 11/11 | 11/11 |
 
| hmo | hmo_dslnh_nmol_ml | 0.000 | 0.000 | 0 | 11/11 | 11/11 |
 
| hmo | hmo_lnh_nmol_ml | 0.000 | 0.000 | 0 | 11/11 | 11/11 |
 
| maternal_characteristics | parity_n | 0.020 | 0.104 | 0.0515 | 10/11 | 11/11 |
 
| maternal_characteristics | postpartum_d | 0.037 | 0.092 | 2.305 | 11/11 | 11/11 |
 
| maternal_characteristics | maternal_age_y | 0.030 | 0.083 | 0.8635 | 11/11 | 11/11 |
 
| maternal_characteristics | maternal_bmi_kg_m2 | 0.019 | 0.044 | 0.4323 | 11/11 | 11/11 |
 
| maternal_characteristics | maternal_weight_kg | 0.025 | 0.043 | 1.61 | 11/11 | 11/11 |
 
| maternal_characteristics | maternal_height_cm | 0.005 | 0.016 | 0.8382 | 11/11 | 11/11 |
 
| milk_microbiome | milk_g_achromobacter_pct | 0.034 | 1.000 | 0.01006 | 6/11 | 8/11 |
 
| milk_microbiome | milk_g_kocuria_pct | 0.017 | 1.000 | 0.03677 | 8/11 | 10/11 |
 
| milk_microbiome | milk_g_enterobacter_pct | 0.010 | 0.156 | 0.005051 | 9/11 | 11/11 |
 
| milk_microbiome | milk_g_pseudomonas_pct | 0.010 | 0.154 | 0.00404 | 9/11 | 11/11 |
 
| milk_microbiome | milk_g_bifidobacterium_pct | 0.010 | 0.153 | 0.008081 | 9/11 | 11/11 |
 
| milk_microbiome | milk_g_chryseobacterium_pct | 0.010 | 0.152 | 0.00303 | 9/11 | 11/11 |
 
| milk_microbiome | milk_g_acidocella_pct | 0.010 | 0.152 | 0.00303 | 9/11 | 11/11 |
 
| milk_microbiome | milk_g_janthinobacterium_pct | 0.010 | 0.151 | 0.005051 | 9/11 | 11/11 |
 
| milk_microbiome | milk_g_klebsiella_pct | 0.010 | 0.151 | 0.02323 | 9/11 | 11/11 |
 
| milk_microbiome | milk_g_bacillus_pct | 0.010 | 0.151 | 0.008081 | 9/11 | 11/11 |
 
| milk_microbiome | milk_g_acinetobacter_pct | 0.010 | 0.151 | 0.01313 | 9/11 | 11/11 |
 
| milk_microbiome | milk_g_lactobacillus_pct | 0.010 | 0.151 | 0.03737 | 9/11 | 11/11 |
 
| milk_microbiome | milk_g_dyella_pct | 0.010 | 0.151 | 0.01313 | 9/11 | 11/11 |
 
| milk_microbiome | milk_g_tatumella_pct | 0.010 | 0.151 | 0.007071 | 9/11 | 11/11 |
 
| milk_microbiome | milk_g_streptococcus_pct | 0.010 | 0.150 | 0.2596 | 9/11 | 11/11 |
 
| milk_microbiome | milk_g_rothia_pct | 0.010 | 0.150 | 0.02121 | 9/11 | 11/11 |
 
| milk_microbiome | milk_g_staphylococcus_pct | 0.010 | 0.150 | 0.2626 | 9/11 | 11/11 |
 
| milk_microbiome | milk_g_anaerococcus_pct | 0.010 | 0.150 | 0.00404 | 9/11 | 11/11 |
 
| milk_microbiome | milk_g_propionibacterium_pct | 0.010 | 0.150 | 0.03737 | 9/11 | 11/11 |
 
| milk_microbiome | milk_g_bacteroides_pct | 0.010 | 0.150 | 0.00303 | 9/11 | 11/11 |
 
| milk_microbiome | milk_g_corynebacterium_1_pct | 0.010 | 0.150 | 0.03232 | 9/11 | 11/11 |
 
| milk_microbiome | milk_g_psychrobacter_pct | 0.010 | 0.150 | 0.00202 | 9/11 | 11/11 |
 
| milk_microbiome | milk_g_clostridium_sensu_stricto_18_pct | 0.010 | 0.149 | 0.00114 | 9/11 | 11/11 |
 
| milk_microbiome | milk_g_enterococcus_pct | 0.010 | 0.149 | 0.008081 | 9/11 | 11/11 |
 
| milk_microbiome | milk_g_gemella_pct | 0.010 | 0.149 | 0.01717 | 9/11 | 11/11 |
 
| milk_microbiome | milk_g_veillonella_pct | 0.010 | 0.149 | 0.01818 | 9/11 | 11/11 |
 
| milk_microbiome | milk_g_escherichia_shigella_pct | 0.010 | 0.149 | 0.01313 | 9/11 | 11/11 |
 
| milk_microbiome | milk_g_stenotrophomonas_pct | 0.010 | 0.148 | 0.008081 | 9/11 | 11/11 |
 
| milk_microbiome | milk_g_rhizobium_pct | 0.010 | 0.147 | 0.01414 | 9/11 | 11/11 |
 

*For milk/fecal genera with tiny published means (<=0.1%%), relative errors look
 
large even when the absolute deviation is a fraction of a percentage point -
 
see the abs-err column.*
 

### 20 largest mean deviations
 
| layer | variable | cohort | published | simulated | rel error |
|---|---|---|---|---|---|
 
| antibodies | ab_igg_s_enterica_typhi_react_all | USC | -0.02 | 0.01451 | -172.5% |
 
| antibodies | ab_igg_shigella_react_all | SP | 0.02 | 0.04731 | +136.6% |
 
| antibodies | ab_iga_eaec_react_all | GBU | 0.04 | -0.01262 | -131.5% |
 
| milk_microbiome | milk_g_kocuria_pct | USC | 1 | 0 | -100.0% |
 
| milk_microbiome | milk_g_achromobacter_pct | KE | 0.3 | 0 | -100.0% |
 
| milk_microbiome | milk_g_achromobacter_pct | SP | 0.3 | 0 | -100.0% |
 
| milk_microbiome | milk_g_achromobacter_pct | SW | 0.3 | 0 | -100.0% |
 
| antibodies | ab_igg_shigella_react_top10 | USW | 0.18 | 0.3381 | +87.8% |
 
| diversity_indices | milk_div_richness | ETR | 85 | 12.45 | -85.4% |
 
| diversity_indices | milk_div_richness | KE | 59 | 10.62 | -82.0% |
 
| antibodies | ab_igg_epec_react_all | ETR | 0.08 | 0.01616 | -79.8% |
 
| diversity_indices | milk_div_richness | GBU | 56 | 12.6 | -77.5% |
 
| diversity_indices | milk_div_richness | GBR | 57 | 12.9 | -77.4% |
 
| diversity_indices | milk_div_richness | ETU | 52 | 12.07 | -76.8% |
 
| diversity_indices | milk_div_richness | PE | 42 | 9.907 | -76.4% |
 
| diversity_indices | milk_div_richness | USW | 44 | 11.24 | -74.4% |
 
| diversity_indices | milk_div_richness | SW | 36 | 9.75 | -72.9% |
 
| diversity_indices | milk_div_richness | SP | 39 | 10.61 | -72.8% |
 
| diversity_indices | fecal_div_richness | KE | 42 | 11.45 | -72.7% |
 
| diversity_indices | fecal_div_richness | GBU | 38 | 10.6 | -72.1% |
 

## 3. SEM reproduction
 
The published SEMs (SEM = SD/sqrt(n)) are compared with the simulated cohort SEMs.
 
Relative errors on the SEM measure how well the simulated *spread* matches.

 
| layer | median |SEM err| | mean |SEM err| | max |SEM err| |
|---|---|---|---|
 
| antibodies | 0.090 | 0.117 | 1.000 |
 
| diversity_indices | 0.803 | 0.801 | 0.982 |
 
| fecal_microbiome | 0.345 | 0.363 | 1.586 |
 
| hmo | 0.127 | 0.161 | 0.980 |
 
| maternal_characteristics | 0.150 | 0.177 | 0.582 |
 
| milk_microbiome | 0.337 | 0.479 | 3.187 |
 

## 4. Immune factors (Ruiz 2017) — median / IQR width / detection %
 
ETR is excluded (chemically preserved milk); its analytes are NA by design.

 
| statistic | median |rel err| | mean |rel err| | within 10% | within 25% |
|---|---|---|---|---|
 
| detection_pct | 0.001 | 0.017 | 97% | 99% |
 
| iqr_width | 0.157 | 0.195 | 37% | 72% |
 
| median | 0.000 | 0.054 | 89% | 93% |
 

Largest immune deviations:

| statistic | analyte | cohort | published | simulated | rel err |
|---|---|---|---|---|---|
 
| iqr_width | imm_il10_ng_l | USW | 6.618 | 4.528e-05 | -100.0% |
 
| iqr_width | imm_il10_ng_l | SW | 6.618 | 0.0001434 | -100.0% |
 
| iqr_width | imm_il10_ng_l | USC | 6.618 | 0.0001573 | -100.0% |
 
| median | imm_il10_ng_l | USC | 4.412 | 0.0009859 | -100.0% |
 
| median | imm_il10_ng_l | SW | 4.412 | 0.001 | -100.0% |
 
| median | imm_il10_ng_l | USW | 4.412 | 0.001 | -100.0% |
 
| iqr_width | imm_il12_ng_l | ETU | 2206 | 61.35 | -97.2% |
 
| median | imm_gmcsf_ng_l | GBR | 9.99 | 1 | -90.0% |
 
| iqr_width | imm_il12_ng_l | SW | 37.1 | 7.488 | -79.8% |
 
| iqr_width | imm_il10_ng_l | KE | 2.32 | 4.075 | +75.6% |
 
| iqr_width | imm_mcp1_ng_l | USW | 115.6 | 36.13 | -68.7% |
 
| detection_pct | imm_il10_ng_l | ETU | 63 | 100 | +58.7% |
 

## 5. Proportions: delivery mode, exclusive breastfeeding, secretor status, household
 
| variable | n cohorts | median abs err (pct-pts) | max abs err (pct-pts) |
|---|---|---|---|
 
| delivery_vaginal_pct | 11 | 0.2 | 1.0 |
 
| exclusive_breastfed_pct | 11 | 3.5 | 18.9 |
 
| extended_family_n | 10 | 0.6 | 1.1 |
 
| extended_family_present | 10 | 0.0 | 0.1 |
 
| father_present | 10 | 0.0 | 0.1 |
 
| household_size_n | 10 | 0.1 | 0.8 |
 
| infant_age_weeks | 10 | 0.5 | 1.3 |
 
| secretor_status_pct | 11 | 0.3 | 1.0 |
 
| sibling_present | 10 | 0.1 | 0.2 |
 
| siblings_n | 10 | 0.1 | 0.8 |
 

*Note: secretor status and delivery mode were drawn stratified by cohort (exact integer counts), so their per-cohort percentages match the published values up to rounding to the nearest dyad (+/- 1/n). Other proportions are Bernoulli draws at the published cohort rates, so binomial sampling error (~2-8 pct-pts at these n) is expected.*
 

## 6. Microbiome prevalence (Lackey 2019 Table 3)
 
| layer | rows | median abs err (pct-pts) | max abs err (pct-pts) |
|---|---|---|---|
 
| fecal_microbiome | 66 | 0.2 | 2.6 |
 
| milk_microbiome | 99 | 0.0 | 1.2 |
 

## 7. Macronutrients (Pace 2021, overall only — not cohort-specific)
 
| variable | published mean | simulated mean | rel err |
|---|---|---|---|
 
| macro_lactose_g_l | 79.20 | 78.86 | -0.4% |
 
| macro_protein_g_l | 15.00 | 15.26 | +1.7% |
 

## 8. Total HMO (sum of the 19 individual HMOs)
 
| cohort | published total | simulated total | rel err |
|---|---|---|---|
 
| ETR | 9748 | 9747 | -0.01% |
 
| ETU | 12187 | 12187 | -0.00% |
 
| GBR | 13732 | 13733 | +0.01% |
 
| GBU | 13435 | 13432 | -0.02% |
 
| GN | 11307 | 11307 | -0.00% |
 
| KE | 12480 | 12479 | -0.01% |
 
| PE | 14474 | 14474 | -0.00% |
 
| SP | 13349 | 13345 | -0.03% |
 
| SW | 15998 | 15998 | +0.00% |
 
| USW | 13035 | 13036 | +0.01% |
 
| USC | 15606 | 15604 | -0.01% |
 

## 9. Realised vs imposed correlations (Spearman, pooled across dyads)
 
| var1 | var2 | target rho | realised rho | abs diff | source |
|---|---|---|---|---|---|
 
| hmo_2fl_nmol_ml | hmo_lnfp_i_nmol_ml | +0.74 | +0.75 | 0.01 | pace2021 |
 
| hmo_6sl_nmol_ml | hmo_lstc_nmol_ml | +0.65 | +0.65 | 0.00 | pace2021 |
 
| hmo_lnt_nmol_ml | hmo_lnnt_nmol_ml | +0.75 | +0.70 | 0.05 | mcguire2017 |
 
| hmo_lnfp_i_nmol_ml | hmo_lnfp_ii_nmol_ml | -0.46 | -0.40 | 0.06 | mcguire2017 |
 
| hmo_lnt_nmol_ml | hmo_dslnt_nmol_ml | +0.60 | +0.50 | 0.10 | mcguire2017 |
 
| hmo_lnnt_nmol_ml | hmo_dslnt_nmol_ml | +0.62 | +0.61 | 0.01 | mcguire2017 |
 
| hmo_2fl_nmol_ml | hmo_lnfp_ii_nmol_ml | -0.52 | -0.34 | 0.18 | mcguire2017 |
 
| hmo_lstb_nmol_ml | hmo_dslnt_nmol_ml | +0.55 | +0.51 | 0.04 | mcguire2017 |
 
| hmo_2fl_nmol_ml | hmo_grp_small_hmos_nmol_ml | +0.98 | +0.99 | 0.01 | mcguire2017 |
 
| milk_g_lactobacillus_pct | fecal_g_lactobacillus_pct | +0.36 | +0.36 | 0.00 | pace2021 |
 
| milk_g_bifidobacterium_pct | fecal_g_bifidobacterium_pct | -0.18 | -0.16 | 0.02 | pace2021 |
 
| maternal_age_y | hmo_lnnt_nmol_ml | -0.14 | -0.27 | 0.13 | mcguire2017 |
 
| maternal_age_y | hmo_lstc_nmol_ml | -0.17 | -0.26 | 0.09 | mcguire2017 |
 
| maternal_age_y | hmo_dslnh_nmol_ml | -0.15 | -0.14 | 0.01 | mcguire2017 |
 
| maternal_age_y | hmo_flnh_nmol_ml | +0.15 | +0.40 | 0.25 | mcguire2017 |
 
| maternal_weight_kg | hmo_dflac_nmol_ml | +0.21 | +0.19 | 0.02 | mcguire2017 |
 
| maternal_bmi_kg_m2 | hmo_dflac_nmol_ml | +0.21 | +0.22 | 0.01 | mcguire2017 |
 
| maternal_weight_kg | hmo_grp_small_hmos_nmol_ml | +0.21 | +0.24 | 0.03 | mcguire2017 |
 
| maternal_bmi_kg_m2 | hmo_grp_small_hmos_nmol_ml | +0.23 | +0.20 | 0.03 | mcguire2017 |
 
| maternal_weight_kg | hmo_lnfp_iii_nmol_ml | +0.20 | +0.17 | 0.03 | mcguire2017 |
 
| maternal_weight_kg | hmo_dflnt_nmol_ml | +0.14 | +0.29 | 0.15 | mcguire2017 |
 
| maternal_weight_kg | hmo_lnnt_nmol_ml | -0.16 | -0.24 | 0.08 | mcguire2017 |
 
| maternal_bmi_kg_m2 | hmo_lnnt_nmol_ml | -0.20 | -0.22 | 0.02 | mcguire2017 |
 
| maternal_weight_kg | hmo_dslnt_nmol_ml | -0.21 | -0.24 | 0.03 | mcguire2017 |
 
| maternal_bmi_kg_m2 | hmo_dslnt_nmol_ml | -0.24 | -0.23 | 0.01 | mcguire2017 |
 
| postpartum_d | hmo_6sl_nmol_ml | -0.31 | -0.28 | 0.03 | mcguire2017 |
 
| postpartum_d | hmo_lnfp_iii_nmol_ml | -0.23 | -0.33 | 0.10 | mcguire2017 |
 
| postpartum_d | hmo_lstc_nmol_ml | -0.40 | -0.40 | 0.00 | mcguire2017 |
 
| postpartum_d | hmo_lnh_nmol_ml | -0.26 | -0.27 | 0.01 | mcguire2017 |
 
| postpartum_d | hmo_dslnt_nmol_ml | -0.13 | -0.11 | 0.02 | mcguire2017 |
 

Median |diff| = 0.03; 28/30 pairs within ±0.15 of target; 29/30 within ±0.25.
 

## 10. Diversity indices vs Lackey 2019 Table 4 (**known limitation**)
 
Lackey 2019 rarefied to 1,000 reads and counted *all* sequenced genera, whereas the
 
simulation generates the 28-29 printed core genera only; richness here is the number
 
of simulated genera with relative abundance >= 1% and is therefore systematically
 
lower. Shannon and inverse-Simpson computed from the simulated compositions track
 
the published cohort means reasonably (median |rel err| below).

 
| index | median |rel err| | mean |rel err| |
|---|---|---|
 
| fecal_div_inverse_simpson_diversity | 0.214 | 0.192 |
 
| fecal_div_richness | 0.626 | 0.636 |
 
| fecal_div_shannon_diversity | 0.125 | 0.120 |
 
| milk_div_inverse_simpson_diversity | 0.395 | 0.338 |
 
| milk_div_richness | 0.764 | 0.734 |
 
| milk_div_shannon_diversity | 0.285 | 0.250 |
 

## 11. Known limitations
 
- Figure-only values (per-cohort secretor % for 5 cohorts, per-cohort lactose/protein,
 
  secretor x HMO breakdowns) were **not** simulated from figure images; assumptions
 
  are flagged in `provenance.csv`.
 
- Lactose and protein are simulated from the **overall** Pace 2021 distribution only
 
  (per-cohort values are figure-only); they cannot validate per cohort.
 
- ETR has no immune data (`immune_measured = FALSE`; all 23 analytes NA).
 
- Diversity indices: see section 10 (coverage limitation of printed tables).
 
- Antibody `breadth score = 0` cells were simulated at a floor of 0.01; those
 
  cohorts contribute large *relative* errors against a published 0 and are excluded
 
  from relative-error tallies (absolute errors are <= 0.01 breadth units).
 
- Fisher's alpha (Lackey 2019 T4) cannot be computed from 28-29 printed genera
 
  (it requires read-count data) and is not simulated.
 
