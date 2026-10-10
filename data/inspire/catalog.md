# Brief 04 — Catalog of summary statistics in the INSPIRE study papers

**Date:** 2026-10-10
**Scope:** every by-population / by-group summary statistic extractable from the eight
INSPIRE-related PDFs, plus cross–data-type association statistics and sample-overlap notes.
Every value in `summary_stats/*.csv` was extracted programmatically from the PDF text layer
(pdfplumber; PyMuPDF for rotated/borderless tables). Nothing was transcribed from memory.
Statistics stated only in figure images but quoted numerically in the text/legend are captured
and flagged; figure-only quantities with no printed numbers are marked **NOT EXTRACTABLE**.
Uncertain items are marked **UNVERIFIED** in the `notes` column.

All papers draw on the same parent cohort — the **INSPIRE study**: 410–413 breastfeeding
mother–infant dyads sampled May 2014–April 2016 at 11 sites: rural Ethiopia (ETR), urban
Ethiopia (ETU), rural Gambia (GBR), urban Gambia (GBU), Ghana (GN), Kenya (KE), Peru (PE),
Spain (SP), Sweden (SW), US–Washington (USW), US–California/Hispanic (USC). The same mothers
and samples were reused across the papers (documented per paper below), so summary statistics
for different data types describe **the same dyads** — this is what makes joint simulation
feasible.

---

## 1. McGuire et al. 2017 — What's normal? HMO concentrations vary geographically (AJCN 105:1086–1100)

- **Populations & n:** ETR 40, ETU 40, GBR 40, GBU 40, GN 40, KE 42, PE 43, SP 41, SW 24, USW 41, USC 19 (10 sites... 11 cohorts; total 410 analyzed of 413 enrolled).
- **Data types:** HMO (19 individual HMOs, total, 8 structural groupings), maternal characteristics (age, parity, time postpartum, weight, height, BMI), secretor status, microbial-diversity-style metrics for HMOs (not bacteria).
- **Sample overlap:** parent cohort description; states milk was also analyzed for immune factors (Ruiz 2017) and microbiomes (Lackey 2019) in "subsequent publications".
- **Extracted tables** (CSVs unless noted):
  - Table 1 (p4) — maternal characteristics by cohort, mean±SEM → `mcguire2017_Table1.csv` (132 rows)
  - Table 2 (p5) — 19 HMOs + total by cohort, mean±SEM, nmol/mL → `mcguire2017_Table2.csv` (440)
  - Table 3 (p7) — 8 HMO groupings (HMO-bound sialic acid, fucose, small HMOs, type 1/2, α-1,2/α-1,3/α-2,6) by cohort, mean±SEM → `mcguire2017_Table3.csv` (176)
  - Table 5 (p11) — NMF feature scores per HMO by cohort + overall → `mcguire2017_Table5.csv` (228)
  - Tables 6–9 (p12–13) — NMF scores by BMI category / parity / time-postpartum quartiles / maternal-age quartiles → `mcguire2017_Table6.csv`–`Table9.csv` (57+57+76+76)
  - Figure 3 (values in text, p8) — % secretors by cohort (65–98%) → `mcguire2017_Figure3_secretors.csv` (6; only cohorts with printed % captured; GBR/ETR exactly 65% is **UNVERIFIED** which one) — other cohorts' percentages only in the figure image = **NOT EXTRACTABLE**
  - Figure 4 + text (p8) — Spearman correlations: maternal traits vs HMOs (e.g. age~LNnT r=−0.14; weight~DFLac r=0.21; BMI~DSLNT r=−0.24; time-postpartum~LSTc r=−0.40) and HMO~HMO (2'FL~small HMOs r=0.98; LNT~LNnT r=0.75; LNFP I~II r=−0.46; LNT/LNnT~DSLNT r=0.60/0.62) → `mcguire2017_correlations_text.csv` (29); full correlation matrix exists only as heat map = **NOT EXTRACTABLE**
  - Figures 1–2 (mean±SEM and relative abundance of HMOs by cohort & secretor status) — numbers only match Table 2 for "all women"; secretor/non-secretor breakdown is figure-and-supplement-only = **NOT EXTRACTABLE** (Suppl. Tables 10–13)
  - Diversity metrics (richness/Shannon/etc. for HMO profiles) — stated to "differ by cohort"; values only in Suppl. Tables 14–15 = **NOT EXTRACTABLE**
  - n per cohort also recorded in every table's `n` column.
- **Weight-based HMO data (µg/mL)** — Suppl. Tables 1–9, not in PDF = **NOT EXTRACTABLE**

## 2. Ruiz et al. 2017 — Immune profiling of milk across geographical settings (Front Immunol 8:696)

- **Populations & n (immune factors):** ETU 40, GBR 40, GBU 40, GN 40, KE 42, PE 43, SP 41, SW 24, USC 19, USW 41 — **ETR excluded** (chemically preserved milk unsuitable for immunoassay).
- **Data types:** immune factor (23 analytes: IL1β, IL6, IL12, IFNγ, TNFα, IL2, IL4, IL10, IL13, IL17, IL5, IL7, IgA, IgM, IgG, TGFβ2, IL8, Groα, MCP1, MIP1β, GCSF, GMCSF, EGF), population characteristics (delivery mode, health, medication, BMI/age/postpartum categories).
- **Extracted tables:**
  - Table 1 (p4) — % of subjects per category per site → `ruiz2017_Table1.csv` (240)
  - Table 2 (p6) — detection frequency (%) per analyte per site, Kruskal–Wallis/Nemenyi → `ruiz2017_Table2.csv` (230)
  - Table 3 (p7) — innate factors, median (IQR) ng/L → `ruiz2017_Table3.csv` (146; 10 sites × 5 analytes × median+IQR1+IQR3 minus 2 `nd` cells for USC)
  - Table 4 (p8) — acquired factors + immunoglobulins + TGFβ2, median (IQR) → `ruiz2017_Table4.csv` (290)
  - Table 5 (p8) — chemokines + growth factors, median (IQR) → `ruiz2017_Table5.csv` (204)
  - Global text notes captured inside notes: IgA & EGF detected in 100% of samples; Groα 100–500× more abundant than other chemokines.
- **NOT EXTRACTABLE:** detection limits (Suppl. Table S1); Sørensen–Dice co-occurrence matrix and PCA loadings (figures/heatmaps without numeric dumps).

## 3. Lackey et al. 2019 — Microbiomes in milk and infant feces vary geographically (Front Nutr 6:45)

- **Populations & n:** milk n = 40/34/39/38/37/42/43/40/23/19/39 (ETR…USW; **GN milk n=37**, USC milk n=19); infant feces n = 40/32/38/38/32/42/42/37/23/12/41.
- **Data types:** milk microbiome + infant fecal microbiome (relative abundance of 29/28 aggregated genera, % prevalence of core genera, alpha-diversity indices), maternal/infant characteristics.
- **Extracted tables:**
  - Table 1 (p5) — subject characteristics by cohort, model-based mean±SEM (95% CI) + category % → `lackey2019_Table1.csv` (187)
  - Table 2 (p10) — relative abundance (%) of 28 genera in infant feces by cohort, mean±SEM → `lackey2019_Table2.csv` (616)
  - Table 3 (p12) — % of samples with quantifiable "core" genera by cohort + overall → `lackey2019_Table3.csv` (192)
  - Table 4 (p12) — diversity indices (richness, Shannon, inverse Simpson, Fisher) in milk & feces by cohort → `lackey2019_Table4.csv` (176)
  - Table 5 (p15) — relative abundance (%) of 29 genera in milk by cohort, mean±SEM → `lackey2019_Table5.csv` (638)
  - Figure 5/6 + text — milk~feces correlations: milk vs fecal Lactobacillus positively correlated (|rs|>0.3, exact value **UNVERIFIED/not printed**); canonical first component milk Lactobacillus rs=−0.498; KE fecal~milk richness r=0.31 (P=0.0453); dyad-level Jaccard P=0.0258 / Bray–Curtis P=0.0936 (ETU only, P=0.0185); ANOSIM R=0.1318 → `lackey2019_correlations_text.csv` (7)
- **NOT EXTRACTABLE:** mean relative abundances behind Figures 2–4 pie/bar charts (Suppl. Table 2); per-cohort correlation coefficients in Fig 5 heatmap and Fig 6 canonical axes (only threshold ±0.3 shown); Suppl. Table 4 milk~feces diversity correlations per cohort except KE.

## 4. Lane et al. 2019 — Household composition and the infant fecal microbiome (Am J Phys Anthropol 169:526–539)

- **Populations & n (household data):** ETR 39, ETU 32, GBR 36, GBU 38, GN 32, KE 40, PE 42, SP 37, SW 23, USW 41 — **USC excluded** (incomplete household data); LME analyses n=360.
- **Data types:** household composition & infant characteristics; infant fecal microbiome (diversity + 4 ANCOM-associated genera).
- **Extracted tables:**
  - Table 1 (p7–8) — household composition by population (mean±SD with range; proportions) → `lane2019_Table1.csv` (130)
  - Table 2 (p8) — LME coefficients (β, SE, p) for household predictors of Shannon H/evenness/richness + random-intercept SDs → `lane2019_Table2.csv` (24)
  - Table 3 (p8) — ANCOM significant genus~household associations; + text follow-up regressions (Lactobacillus~sibling presence ß=0.54 p=.04; Klebsiella~extended-family presence ß=0.71 p=.01; Klebsiella~number of extended family ß=0.27 p<.01; Klebsiella~household size ß=0.17 p=.01) → `lane2019_Table3_and_text.csv` (14)
- **NOT EXTRACTABLE:** rarefied LME models (Suppl. Table S1); full genus-level ANCOM W statistics.

## 5. McGuire et al. 2021 — IgA and IgG antigen specificity in milk (Front Immunol 11:614372)

- **Populations & n:** all 11 cohorts (same n as Lackey milk / McGuire 2017).
- **Data types:** antibody (IgA, IgG) — breadth scores and mean [SEM] normalized intensity per pathogen (8 primary pathogens × 3 metrics × 11 cohorts).
- **Extracted tables:**
  - Table 1 (p7) — IgA: breadth score, top-10 antigen reactivity, all-antigen reactivity, mean[SEM] → `mcguire2021_Table1_IgA.csv` (528)
  - Table 2 (p8–9) — same for IgG → `mcguire2021_Table2_IgG.csv` (528)
  - Text associations — LMIC vs HIC differences (Shigella IgA/IgG breadth ≥5% higher, P<10⁻⁴/10⁻¹³²; S. pneumoniae IgG P<10⁻¹⁰; S. aureus IgA ≥5% lower, P<10⁻¹⁰; Peru vs Spain Shigella IgG P<10⁻²⁸) → `mcguire2021_associations_text.csv` (7)
- **NOT EXTRACTABLE:** per-antigen reactivities (Suppl. Tables S1–S4); secondary-pathogen breadth scores (Figure 2B,C boxplots only); per-cohort boxplot medians in Figures 1–2 (not printed numerically).

## 6. Pace et al. 2021 — Variation in milk composition related to milk and infant fecal microbes (Microorganisms 9:1153)

- **Populations & n:** 357 maternal–infant dyads retained after microbiome QC (all 11 cohorts pooled for most analyses; n=340 dyads for correlation analyses).
- **Data types:** macronutrient (lactose, protein), HMO, milk microbiome, infant fecal microbiome, maternal/infant characteristics — this is the key **cross-data-type** paper.
- **Extracted (text-stated statistics → `pace2021_text_stats.csv`, 46 rows):**
  - Overall: lactose 79.2±11.0 g/L (range 26.7–118.3, IQR 72.7–84.3); protein 15.0±2.8 g/L (range 9.4–32.6, IQR 13.2–16.6); total HMOs 12,913±4,039 nmol/mL (range 4,053–22,884, IQR 9,735–15,847); maternal age 27.4±6.1 y; time postpartum 64.6±21.9 d; 86% vaginal; 60% exclusively breastfed.
  - By-group tests: lactose & protein differ by population (both p<0.001, Fig 2A); lactose differs by lactotype (p=0.008); protein by enterotype trend (p=0.051).
  - envfit (Fig 3): cohort & CSTs explain 20–37% of milk/fecal community variance; lactotype→fecal structure ~8%; lactose→milk ~4%; protein→fecal ~3%; HMO-bound fucose→milk ~7%; HMO-bound Fuc:Sia ratio→fecal ~12%; 3FL/DSLNT/2'FL each >4% in both.
  - Spearman correlations (Fig 4, n=340): 2'FL~LNFP I ρ=0.74; 6'SL~LSTc ρ=0.65; Bacteroides~Streptococcus (feces) ρ=−0.40; Dyella~Rhizobium (milk) ρ=−0.38; Gemella(milk)~Lactobacillus(feces) ρ=−0.29; Dyella~uncl. Xanthomonadaceae ρ=0.68; Corynebacterium 1~Kocuria ρ=0.43; Bacteroides~Parabacteroides ρ=0.42; Bifidobacterium~Kocuria (milk) ρ=0.41; milk~fecal Lactobacillus ρ=0.36; milk~fecal Bifidobacterium ρ=−0.18; plus qualitative directions (milk/fecal Lactobacillus inversely ~ fucosylated HMOs; Veillonella inversely ~ sialylated HMOs; etc.).
- **NOT EXTRACTABLE:** per-population lactose/protein values (Figure 2 panels are non-numeric); HMO concentrations by lactotype/enterotype (Suppl. Tables S6–S7); full correlation matrix values (Fig 4 shows only significant cells by size/color); Suppl. Table S1 dyad demographics by cohort; indicator-species values (Suppl. S4–S5).
- **Sample overlap statement:** explicitly the same milk/fecal samples as Lackey 2019, HMOs as McGuire 2017, immune factors as Ruiz 2017.

## 7. Caffé et al. 2023 — Milk immune factors, maternal nutritional status, infant sex (Am J Hum Biol 35:e23943)

- **Populations & n:** 358 mothers (182 female infants, 176 male) — ETR excluded (preservation), plus 12 dropped for missing data.
- **Data types:** immune factor (IgA, IgG, IgM, EGF, TGFβ2, IL-10), maternal BMI/DDS/age, infant sex/age.
- **Extracted tables:**
  - Table 1 (p6) — characteristics by infant sex, mean±SD + p → `caffe2023_Table1.csv` (49)
  - Table 2 (p6) — LME β and P for immune factors ~ infant sex × maternal BMI → `caffe2023_Table2.csv` (36)
  - Table 3 (p7) — LME β and P for immune factors ~ infant sex × maternal DDS → `caffe2023_Table3.csv` (36)
  - Random-effect variance components (T2/T3) → `caffe2023_random_effects.csv` (12)
  - Key findings in table values: IgG×(sex×DDS) β=0.099 P=0.037; IgM interaction β=0.137 P=0.051; IL-10 interaction β=−0.249 P=0.052.
- **NOT EXTRACTABLE:** concentration distributions by cohort (Suppl. Table S1 description only); BMI-categorical LME (Suppl. Table S2).

## 8. Ambalavanan et al. — HMOs, maternal genetics, respiratory health (Nat Commun 15:7735; CHILD discovery + INSPIRE replication)

- **Populations & n:** CHILD cohort Canada — 980 genotyped mothers with HMOs; 880 dyads breastfed ≥6 mo (640 secretor mothers in sensitivity analysis); 2,835 children for GRS analyses. **INSPIRE replication sub-cohort N=395.**
- **Data types:** HMO (19), maternal genetics (GWAS SNPs, GRS), infant respiratory outcome (recurrent wheeze).
- **Extracted tables:**
  - Table 1 (p4) — 23 lead SNPs: locus, SNP, P, effect-allele frequency, nearest gene, HMO features lower/higher with effect allele → `ambalavanan_Table1_gwas.csv` (38 rows)
  - Text stats → `ambalavanan_text_stats.csv` (11): CHILD secretor prevalence 73.7% (727/980); INSPIRE replication survivors (rs4234598→6'SL & LSTc; 4 SNPs 7q31.32→LNT; rs16869462→LNH; 41 SNPs chr19→all HMOs except 6'SL/LNnT); GRS~wheeze P=2.48e-10 / 1e-7; HMO×GRS unadjusted P (2'FL 0.004, LNFP1 0.01, DFLNH 0.002, LNFP2 0.03, LNFP3 0.02).
- **NOT EXTRACTABLE / not in this PDF's set:** per-cohort HMO concentrations in INSPIRE (insufficient detail — the INSPIRE HMO data are fully covered by McGuire 2017); Supplementary Tables 1–5 (HMO distributions, GxE full statistics); Manhattan-plot per-SNP P values (figures only); no INSPIRE-cohort-specific summary statistics beyond replication P-value threshold statements = largely **NOT EXTRACTABLE** for INSPIRE-specific values.

---

## Feasibility assessment — simulation per population

Populations are identical across papers (INSPIRE), with these analyzable n per site
(milk / feces / immune where available):

| Cohort | McGuire 2017 HMO n | Ruiz 2017 immune n | Lackey 2019 milk/feces n | Lane 2019 n | Pace 2021 dyads |
|---|---|---|---|---|---|
| ETR | 40 | — (excluded) | 40/40 | 39 | in 357 |
| ETU | 40 | 40 | 34/32 | 32 | ✓ |
| GBR | 40 | 40 | 39/38 | 36 | ✓ |
| GBU | 40 | 40 | 38/38 | 38 | ✓ |
| GN | 40 | 40 | 37/32 | 32 | ✓ |
| KE | 42 | 42 | 42/42 | 40 | ✓ |
| PE | 43 | 43 | 43/42 | 42 | ✓ |
| SP | 41 | 41 | 40/37 | 37 | ✓ |
| SW | 24 | 24 | 23/23 | 23 | ✓ |
| USC | 19 | 19 | 19/12 | excluded | ✓ |
| USW | 41 | 41 | 39/41 | 41 | ✓ |

| Data type | center + spread + n per population? | sufficient? | source |
|---|---|---|---|
| **HMO (19 + total + 8 groupings)** | mean + SEM + n per cohort (Table 2/3); NMF scores per cohort | **YES — best-resolved type** (SEM is parametric; log-normal per methods) | mcguire2017 |
| **Immune factors (23 analytes)** | median + IQR + n per site + detection % (Tables 2–5) | **YES** for 10 sites (not ETR); zero-inflated handling possible via detection % | ruiz2017 |
| **Milk microbiome (29 genera RA)** | model mean + SEM + n per cohort; core-genus prevalence; diversity mean±SEM | **YES** (RA modeled on beta distribution per paper) | lackey2019 |
| **Infant fecal microbiome (28 genera RA)** | same as above | **YES** | lackey2019 |
| **Antibodies IgA/IgG (8 pathogens)** | breadth score + top-10 & all-antigen reactivity, mean[SEM], n | **YES** for all 11 cohorts | mcguire2021 |
| **Maternal characteristics (age, parity, BMI, weight, height, postpartum time)** | mean + SEM (± 95% CI for Lackey T1) + n per cohort | **YES** | mcguire2017 T1, lackey2019 T1 |
| **Household composition** | mean + SD + range + n per population | **YES** (except USC) | lane2019 T1 |
| **Macronutrients (lactose, protein)** | overall mean+SD+range+IQR, but **per-population values figure-only** | **NO by population** (overall only) | pace2021 |
| **Immune factors by infant sex / maternal BMI / DDS** | mean+SD by sex (T1); LME β coefficients | **Partial** (by sex overall, not by site) | caffe2023 |
| **HMO genetics (secretor status)** | % secretors per site (printed only for PE 98%, GN/USW 68%, USC 95%, GBR/ETR ~65%) | **Partial** (5 of 11 sites printed; rest figure-only) | mcguire2017 |
| **Subject sequencing read counts** | overall mean ± SD + range | **NO by population** | lackey2019 / lane2019 / pace2021 |

**≥3 data types simulatable for the same populations (all 11 cohorts):**
1. HMO concentrations (19 analytes, mean±SEM) — mcguire2017
2. Milk microbiome genus RA (29 genera, mean±SEM) — lackey2019
3. Infant fecal microbiome genus RA (28 genera, mean±SEM) — lackey2019
4. Antibody breadth/reactivity (8 pathogens × IgA/IgG, mean[SEM]) — mcguire2021
5. Maternal characteristics (age/parity/BMI/weight/height/postpartum, mean±SEM) — mcguire2017 & lackey2019
(1–5 all have full per-cohort center+spread+n. Immune factors cover 10 of 11 sites.)

**Correlation structure available for joint simulation:**
- **HMO ↔ HMO:** 9 quantitative ρ pairs + Figure 4 heat map (mcguire2017); 2'FL~LNFP I 0.74, 6'SL~LSTc 0.65 (pace2021).
- **HMO ↔ microbiome:** qualitative directions + envfit R² (pace2021 Fig 3/4).
- **Milk microbiome ↔ infant fecal microbiome:** Lactobacillus milk~feces positive (ρ=0.36 pace2021; |rs|>0.3 lackey2019); Bifidobacterium inverse (−0.18); KE richness r=0.31; dyad-level similarity (Jaccard p=0.026).
- **Maternal traits ↔ HMO:** 20 quantitative ρ (mcguire2017 Fig 4).
- **Immune factor ↔ infant sex/BMI/DDS:** LME β with P (caffe2023 Tables 2–3).
- **Household ↔ fecal microbiome:** LME β + ANCOM taxa (lane2019 Tables 2–3).
- **Microbiome diversity macronutrients:** lactose→milk ~4%, protein→feces ~3% envfit R² (pace2021).
- **Missing/weak:** immune factor ↔ microbiome quantitative ρ (only co-occurrence/PCA qualitative in Ruiz 2017); HMO ↔ antibody ρ (none printed); per-cohort HMO↔microbiome ρ values beyond printed extrema (Fig 4 heat map cells not numeric); immune-factor raw concentration SDs (only median/IQR).

**Notes / caveats for simulation planning:**
- McGuire 2017 HMO stats are mean ± SEM **of raw nmol/mL values**, but inference was on log-transformed data → simulate log-normal, back-transform (means will be approximate).
- Ruiz 2017 immune factors are median + IQR with many `nd` (below-detection) cells — detection % is separately tabulated and should drive zero-inflation.
- ETR samples were chemically preserved; excluded from Ruiz 2017, Caffé 2023, and cautioned in Lackey 2019 (different extraction) — a 10-site joint dataset excluding ETR maximizes completeness.
- Lane 2019 household data exclude USC (n=360 total).
- Caffé 2023 and Pace 2021 are deliberately secondary analyses of the same dyads; their LME/envfit coefficients provide the cross-data-type covariance needed for joint simulation.
