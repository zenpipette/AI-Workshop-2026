# Brief 04 — Extraction log

Every PDF page/table read and every extraction attempt, in execution order. Tools:
`pdfplumber` for text-layer dumps and embedded-table detection; `PyMuPDF (fitz)` for
rotated/borderless tables. Raw dumps: `scratch/brief04/<paper>.txt` (pdfplumber) and
`<paper>_fitz.txt` (PyMuPDF). Parser scripts: `scratch/brief04/parse_*.py`. All file-name
matching against the source folder was done with prefix globs (two 2017 PDFs contain the
Unicode right-single-quote U+2019 in "What’s"; hardcoded ASCII apostrophes failed — logged).

## Setup passes
1. `extract_all.py` — pdfplumber text + table detection for all 8 PDFs.
   - mcguire2017, ruiz2017 failed on first pass (`FileNotFoundError`) → root cause: U+2019
     in filenames; fixed via `os.listdir` prefix matching. Second pass: all 8 opened.
   - Detected tables: mcguire2017 **0** (landscape-rotated pages — text reversed); lackey2019 **0**;
     pace2021 **0**; lane2019 14 (p7–8, partly rotated); mcguire2021 1; ruiz2017 15; caffe2023 34 (fragmented); ambalavanan 18.
2. `dump_rot.py` — PyMuPDF plain-text dump of all pages for all 8 papers (recovered the
   rotated AJCN tables for mcguire2017/lane2019 as upright reading order).

## mcguire2017 (AJCN 105:1086–1100) — pages 1–15
3. Read all 15 pages (p1 abstract/intro … p15 references). Tables 1–3 found rotated (p4, p5, p7);
   Tables 5–9 upright (p11–13).
4. `parse_mcguire2017.py` — wrote `mcguire2017_Table1.csv` (132 rows: 6 characteristics × 11 cohorts × mean+SEM).
   - Value row check vs printed text: Age ETR 24.6±0.8 ✓; BMI SP 28.1±0.8 ✓.
5. Table 2 parse: first pass missed "Total" header merged with `nmol/mL`, recovered by
   splitting merged value lines; final 440 rows (20 analytes × 11 cohorts × mean+SEM).
   Checks vs text: 2'FL USC 7043±858 ✓; LNnT GBR 1423±117 ✓; Total ETR 9748±626 ✓.
6. Table 3 parse: Type 1 header merged with first values — fixed via prefix match + multi-token
   splitter; 176 rows (8 groupings × 11 × 2). Checks: Type 1 ETR 4222±281 ✓, USC 4400±297 ✓.
7. `parse_mcguire2017b.py` — Tables 5–9 (NMF scores): T5 228 rows (19 × 12 groups) ✓;
   T6/T7 (p12, side-by-side) fixed off-by-one chunk alternation; T8/T9 (p13). Spot checks:
   T6 2'FL underweight 0.48 ✓; T7 2'FL parity1 0.99 ✓; T8 2'FL 20–46d 0.80 ✓; T9 2'FL 15–22y 0.97 ✓.
8. Figure 3 secretor percentages extracted only where printed in text (p8): PE 98%, GN 68%,
   USW 68%, USC 95%, "65% in GBR and ETR" (exact split **UNVERIFIED**). Other cohorts
   **NOT EXTRACTABLE** (figure-only). `mcguire2017_Figure3_secretors.csv` (6 rows).
9. Figure 4 + text correlations: 29 rows (20 maternal-trait↔HMO, 9 HMO↔HMO), exact r values
   as printed in Results text. Full matrix **NOT EXTRACTABLE** (heatmap without numbers).
10. Figures 1–2 (HMO by secretor status) and diversity metrics — numbers only in supplement
    (Tables 10–15/Suppl. 12) = **NOT EXTRACTABLE**; noted in catalog.
11. Weight-based (µg/mL) data — Suppl. Tables 1–9 not in PDF = **NOT EXTRACTABLE**.

## ruiz2017 (Front Immunol 8:696) — pages 1–17
12. Read all pages; tables on p4 (T1), p6 (T2), p7 (T3), p8 (T4+T5) — fully readable in
    pdfplumber text layer.
13. `parse_ruiz2017.py` — T1 240 rows (24 characteristics × 10 sites); T2 230 rows (23 analytes
    × 10 sites detection %; first pass 170 because Greek-letter analytes corrupted by an ANSI
    round-trip through PowerShell — repaired; regression verified counts 230 ✓).
14. T3/T4/T5: median (IQR) parsing; T4 initially collided with T5 on same page (row-iteration
    continued into the next table) — fixed by stopping at first repeated site label.
    Outputs: T3 146 (10 sites × 5 analytes × 3 stats − 2 nd ×2?), T4 290, T5 204.
    Checks: TNFα GBR median 8.63 (5.23–13.50) ✓; EGF SW 8.29 (6.12–10.78) µg/L ✓; USC IL2/IL12/IFNγ `nd` ✓.
    Unit map verified per analyte (cytokines ng/L; Igs mg/L; TGFβ2 & EGF µg/L).
15. Detection-limit table is supplementary (S1) = **NOT EXTRACTABLE**; heatmaps/PCA figures
    lack numeric dumps = **NOT EXTRACTABLE**.

## lackey2019 (Front Nutr 6:45) — pages 1–20
16. Read all pages; tables T1 (p5), T2 (p10), T3+T4 (p12), T5 (p15) readable in PyMuPDF text.
17. `parse_lackey2019.py` (first pass) → wrong row counts because value tokens carry fused
    significance letters and some headers wrap (`Clostridium sensu` + `stricto 1`) and one
    column-header line masqueraded as a genus. Rewrote as `parse_lackey2019_fix.py` with an
    explicit expected-genus list. Final: T2 616 (28 × 11 × 2) ✓, T3 192 (6 feces + 10 milk
    genera × 12 groups), T4 176 (4 indices × 11 sites × 2 sample types × mean+SEM), T5 638
    (29 × 11 × 2) ✓. Checks: milk Streptococcus ETR 15.3±2.2 ✓; feces Richness milk ETR 85±1 ✓.
18. `parse_lackey2019_t1b.py` — T1 subject characteristics: 187 rows (6 maternal + 4 infant
    metrics; mean±SEM with 95% CI in notes, % rows for delivery mode/sex/exclusive BF).
    Fixed: wrapped headers (`(% vaginal)` continuation) and U+2212 minus in WLZ row.
19. `lackey2019_correlations_text.csv` (7 rows): KE richness r=0.31; canonical Lactobacillus
    rs=−0.498; ANOSIM R=0.1318; Jaccard/Bray–Curtis p-values. Exact ρ behind Fig 5 heatmap
    beyond threshold statements = **NOT EXTRACTABLE**; Suppl. Table 2 (mean RA used for pie
    charts) and Suppl. Table 4 (per-cohort diversity correlations except KE) = **NOT EXTRACTABLE**.

## lane2019 (Am J Phys Anthropol 169:526–539) — pages 1–14
20. Read all pages; Table 1 (p7–8) rotated in PDF — readable via PyMuPDF; Table 2 and Table 3
    readable on p8.
21. `parse_lane2019.py` — T1: 130 rows (10 populations × 9 household metrics × mean←SD/proportion
    + SD; USC excluded per footnote ✓ captured). Fixed wrapped range `(0–10` truncation.
22. T2: fitz interleaves sub-table columns awkwardly — settled on transcribing the 7 covariates
    × 3 sub-metrics into code after programmatic verification that every number string appears
    in the page text; 24 rows incl. 3 random-intercept SDs.
23. T3 + text: 14 rows (9 ANCOM associations + 4 follow-up regression ß + 1 redundant filtered).
    Follow-up ß values cross-checked against p9 text (0.54 p=.04; 0.71 p=.01; 0.27 p<.01; 0.17 p=.01 ✓).
    Suppl. Table S1 (rarefied LME) = **NOT EXTRACTABLE**.

## mcguire2021 (Front Immunol 11:614372) — pages 1–16
24. Read all pages; Tables 1 (p7) and 2 (p8–9) readable in PyMuPDF text.
25. `parse_mcguire2021.py` — first draft state machine leaked values across wrapped markers;
    rewrote with marker-boundary block parsing (handles wrapped `Top 10`/`antigens`,
    `S. enterica`/`Typhi`, `S.`/`pneumoniae`, `M.`/`tuberculosis` and split `-0.02`/`[0.01]`
    values). Final: T1 528 rows (8 pathogens × 3 metrics × 11 cohorts × mean+SEM) ✓;
    T2 528 ✓. Checks: Shigella IgG top-10 KE 4.24[0.23] ✓, Sweden −0.02[0.01] ✓; ETEC IgA
    breadth ETR 0.21[0.01] ✓.
26. `mcguire2021_associations_text.csv` (7 rows): LMIC vs HIC breadth differences with P as
    printed (≥5% Shigella IgA/IgG, S. pneumoniae IgG, S. aureus IgA lower; Peru>Spain Shigella
    IgG P<10⁻²⁸; global breadth ≈0.25 Shigella/S. pneumoniae, ≈0.70 S. aureus — approximations
    flagged **UNVERIFIED**). Suppl. Tables S1–S4 per-antigen data = **NOT EXTRACTABLE**.

## pace2021 (Microorganisms 9:1153) — pages 1–17
27. Read all pages. **No by-group numeric tables in the main text** (all in supplements). All
    captured statistics quoted in §3.1–3.6 text — `pace2021_text_stats.csv` (46 rows), with
    strings programmatically verified present in the fitz text (lactose 79.2±11.0 g/L ✓, protein
    15.0±2.8 ✓, total HMO 12,913±4,039 ✓, envfit R² phrases ✓, all 11 printed Spearman ρ ✓).
28. Figure 2 (per-population lactose/protein), Figures 1, 3, 4 numeric content, Suppl. Tables
    S1, S4–S7 = **NOT EXTRACTABLE** from this PDF. Bias note preserved: n=357 dyads for
    composition summaries; n=340 for correlations.

## caffe2023 (Am J Hum Biol 35:e23943) — pages 1–14
29. Read all pages; Tables 1–3 on p6–7 readable in PyMuPDF text (minus signs stored as byte 0x01
    — normalized).
30. `parse_caffe2023.py` — T1 49 rows (5 maternal + 2 infant metrics + p-values);
    T2 36 rows (6 covariates × 6 analytes β/P); T3 36 rows. Fixed two-line wrapped covariate
    labels (`Infant Sex:`/`Maternal BMI`, `Infant sex:`/`Maternal`/`DDS`). Random-effect
    variance components captured separately (`caffe2023_random_effects.csv`, 12 rows).
    Checks: IgG×(sex×DDS) β=0.099 P=0.037 ✓; IgA intercept β=5.992 ✓.
    Suppl. Tables S1–S2 = **NOT EXTRACTABLE**.

## ambalavanan (Nat Commun 15:7735) — pages 1–15
31. Read all pages; Table 1 (p4) + replication/GxE values quoted in text/Fig 5–6 captions.
32. `parse_ambalavanan.py` — Table 1: 23 lead SNPs parsed (locus/SNP/P/EAF/gene/feature
    direction) → 38 long rows. Text stats 11 rows (CHILD secretor %, INSPIRE replication
    survivors, GxE P values). Verification: rs601338, 73.7%, 2.48e-10 strings ✓.
    Supplementary data (per-SNP stats, HMO distributions, TABLES 2–5) = **NOT EXTRACTABLE**.
    Note: this paper has no INSPIRE-site-level summary statistics; INSPIRE HMO values must
    come from McGuire 2017 (documented in catalog).

## Concatenation & audit
33. `concat_all.py` — `ALL_summary_stats.csv` = **5,662 rows** over 34 tidy CSVs, columns:
    `paper, table, page, data_type, analyte, group, group_type, n, statistic, value, unit, notes`.
34. Value integrity rules enforced: every numeric value parsed from the PDF text layer of the
    specified page; spot checks logged above; items quoted only as "≈/higher/lower" captured
    with `UNVERIFIED` or qualitative values; figure/supplement-only numbers recorded as
    **NOT EXTRACTABLE** here and in `catalog.md` rather than guessed.

### Known limitations / deferred
- Lane 2019 Table 2 transcribed to code after failing structural parse (numbers verified in page text).
- mcguire2017 Figure 3: exact 65% assignment between GBR and ETR **UNVERIFIED**.
- Group-letter (post-hoc) information preserved in `notes` where extractable; letters fused to
  values in some milk-RA rows (e.g., `20.6 ± 3.0abc 27.7 ± 3.4abc ...`) — captured per value.
- Page numbers refer to PDF page order (1-indexed).
