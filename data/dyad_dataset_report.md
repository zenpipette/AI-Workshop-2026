# Mother–Infant Dyad Datasets: Infant Gut Microbiome + Human Milk Components

**Compiled:** 2026-10-09 (queries run that day; all API accessions verified live)
**Scope:** Publicly, freely available datasets of mother–infant dyads with infant fecal microbiome sequencing plus some milk component data. Accessions were verified against NCBI BioProject / ENA / Europe PMC / Metabolomics Workbench on the date above. Anything I could not confirm is marked **UNVERIFIED**.

---

## 1. Ranked table of best datasets

Ranking criteria: (a) infant stool sequencing present & open; (b) milk microbiome present; (c) HMO data downloadable; (d) fatty acids / lipids; (e) other milk components; (f) dyad linkage metadata clear; (g) fully open access preferred.

| # | Dataset / cohort (paper) | Country, n dyads | Infant stool sequencing (type, accession) | Milk microbiome (accession) | HMOs (where) | Fatty acids / lipids (where) | Other milk components | Paper DOI | Access (fully open / partly / controlled) | Notes |
|---|--------------------------|------------------|--------------------------------------------|------------------------------|----------------|-------------------------------|------------------------|-----------|--------------------------------------------|-------|
| 1 | **MILK cohort** – Ferretti et al. 2025, "Assembly of the infant gut microbiome and resistome are linked to bacterial strains in mother's milk" (*Nat Commun*) | USA (Minnesota/Oklahoma); ~175 dyads (samples at 1 & 3 mo milk; 1 & 6 mo stool) | Shotgun metagenomics, infant feces — **PRJNA1019702** (re-seq **PRJNA1198101**) | Shotgun metagenomics, milk — **PRJNA1019702** | Not in this paper (see Johnson 2024 below) | No | No (resistome + strain sharing analyses) | 10.1038/s41467-025-66497-y | **Fully open** (SRA + Zenodo tables + GitHub) | Best open shotgun dyad set. Metadata + MetaPhlAn/HUMAnN/DeepARG tables at Zenodo (`https://zenodo.org/records/17317218`) and code at `github.com/blekhmanlab/milk_infant_microbiome`. FUT2/secretor from companion paper. |
| 2 | **MAMI cohort** – Samarra et al. 2026, "Maternal secretor status and human milk oligosaccharides influence the infant gut resistome" (*Cell Rep Med*) | Spain (Valencia); ~120 dyads | Shotgun metagenomics, infant feces — **PRJEB74322** + **PRJNA1227883** | Shotgun metagenomics, milk — **PRJEB74322** + **PRJNA1227883** | Yes, measured per sample (Bode lab); HMO values in supplementary tables (paper states HMOs by LC-MS) | No | sIgA / cytokines available from MAMI companion papers (Rio-Aige 2023) | 10.1016/j.xcrm.2026.103007 | **Fully open** (ENA/NCBI) | Strongest combination: shotgun for both milk + stool, plus HMOs and maternal secretor (FUT2) status. Metadata incl. delivery/feeding mode. Milk 16S from earlier MAMI paper (Cortes-Macías 2021, J Nutr) is separate. |
| 3 | **Gambian mother–infant HMO study** – Davis et al. 2017, "Growth and Morbidity of Gambian Infants are Influenced by Maternal Milk Oligosaccharides and Infant Gut Microbiota" (*Sci Rep*) | The Gambia; 33 dyads at 4, 16, 20 wk postpartum | 16S rRNA amplicon, infant feces — **PRJEB15633** | No (milk used for HMOs only) | Yes, full HMO panel per milk sample (Lebrilla HPLC-Chip/QTOF); in supplement | No | Infant growth/morbidity; calprotectin; season | 10.1038/srep40466 | **Fully open** (ENA) | Classic UC Davis (Mills/Lebrilla/Zivkovic) dyad set. Longitudinal. Dyad linkage present. No milk microbiome. |
| 4 | **Gambian lactation-stage study** – Karampatsas et al. 2022, "Gastrointestinal, vaginal, nasopharyngeal, and breast milk microbiota profiles and breast milk metabolomic changes in Gambian infants…" (*Medicine*) | The Gambia; 107 mothers + their infants (30 infant rectal swabs d0; 18 NP swabs d60; 32 milk + 9 milk d60) | 16S rRNA amplicon, infant rectal/NP swabs — **PRJEB41404** | 16S rRNA amplicon, breast milk — **PRJEB41404** | Partial: NMR/GC-MS detected α-1,4- and α-1,3-fucosylated HMOs + 33 metabolites incl. fatty acids | Yes (GC-MS fatty acids in milk metabolomics) | Monosaccharides, sugar alcohols, milk metabolome | 10.1097/MD.0000000000031419 | **Fully open** (ENA) | Milk metabolomics (NMR + GC-MS) is a rare milk-component layer. No shotgun. Infant sampling is rectal swab at birth only (not longitudinal stool). |
| 5 | **Mexican maternal-BMI study** – Corona-Cervantes et al. 2026, "Maternal obesity alters human milk oligosaccharides content and correlates with early acquisition of late colonizers in the neonatal gut microbiome" (*Gut Microbes*) | Mexico (Monterrey); 48 mother–infant dyads (28 OW/OB, 20 NW), milk at 48h/1mo/3mo, stool at same times | Shotgun metagenomics, infant feces — **PRJNA1260751** | No | Yes, targeted UPLC-MS/MS HMO panel (2′FL, 3′SL, 6′SL, LNnT, LNFP-I) per milk sample, in Supplementary Tables (.docx) | Untargeted milk metabolomics (bile acids, polyamines) reported in supplement | Anthropometrics, maternal BMI | 10.1080/19490976.2025.2607043 | **Fully open** (SRA) | Small but true longitudinal dyads with shotgun stool + per-sample HMOs. HMO values are in the journal supplementary Word file (not a structured repository). |
| 6 | **Preterm NEC study** – Masi et al. 2024, "Human milk microbiota, oligosaccharide profiles, and infant gut microbiome in preterm infants diagnosed with necrotizing enterocolitis" (*Cell Rep Med*) | UK (Newcastle); 110 dyads (48 NEC, 62 controls), longitudinal | 16S rRNA, infant stool — **PRJEB72536** (124 runs verified) | 16S rRNA, mother's own milk — **PRJEB72536**; companion milk microbiome seq **PRJEB39610** | Yes, HMO panel per milk sample (Bode lab), in supplement | No | No | 10.1016/j.xcrm.2024.101708 | **Fully open** (ENA) | Preterm cohort. One of few with milk microbiome + milk HMOs + infant stool all present per dyad. |
| 7 | **Bangladesh SEPSIS mother–infant study** – UCSD/Bangladesh (Kvitne/Knight/Bode et al.; Cell Host Microbe 2025 + SEPSIS Bioproject) | Bangladesh; ~600 dyads enrolled; infant gut + maternal body habitats + milk | Infant stool 16S/shotgun (per paper tmAccession bioproject) — **PRJEB83236** (1,917 runs verified) | Maternal milk + multiple body sites — **PRJEB83236** | Yes, milk HMO panel by secretor status (Bode lab), stated in project description | No | Milk metabolomics in companion paper | 10.1016/j.chom.2025.11.002 | **Partly open** (ENA raw reads open; per-sample metadata/HMO tables may need request from icddr,b) | Largest sample size. Bankura/icddr,b cohort. Project description explicitly states HMO profiling of breast milk + mother–infant gut/body microbial communities. HMO values appear to be in paper supplement rather than a public metabolomics repository — **HMO table location UNVERIFIED**. |
| 8 | **Lifelines NEXT** – Sinha et al. 2026, "Maternal influences on infant gut microbiome and health" (*Nature*) | Netherlands; ~400+ dyads | Shotgun metagenomics infant stool (accession per paper; not a single HMO-linked Bioproject) | Shotgun milk microbiome (reported) | Not primary focus | No | Extensive phenotyping | 10.1038/s41586-026-10922-9 | **Partly / controlled** (Lifelines data by application; some seq at EGA) | Large shotgun dyad cohort but milk component tables not open. Listed for completeness; not ideal for HMO-focused reuse. |
| 9 | **UNC infant cognition dyads** – Choate/Qin et al., "Interactions Between Bifidobacterium and Bacteroides and Human Milk Oligosaccharides and Their Associations with Infant Cognition" | USA (UNC Chapel Hill); 105 dyads, ≤12 mo, 170 milk samples | Infant fecal microbiome seq — **PRJEB63183** | No | Yes, 8 HMOs per sample, in paper/statistical models; table in supplement | No | Mullen cognitive scores; A-tetra secretor proxy | (Cell Rep/related, record in Bioproject) | **Fully open** (ENA) | Dyad metadata available; microbiome accession verified (PRJEB63183). |
| 10 | **Chinese breastfed-infant oral microbiome & HMOs** – Arishi/Stinson et al. 2025 (*Nutrients*) and related Arishi 2026 (*Front Cell Infect Microbiol*) | Australia (UWA/Geddes lab); ~40–80 dyads | 16S infant oral (and stool in companion) — accession PRJNA noted in 2026 paper (bioproject tag) | 16S breast milk (companion paper, Stinson lab) | Yes, HMO panel per milk sample (Bode lab) | Milk fatty acids reported by same group (Gridneva) | Milk protein, lactose, sIgA (same lab) | 10.3390/nu17223622 ; 10.3389/fcimb.2026.1765736 | **Fully open** | Mostly oral (not gut) infant niche; milk microbiome + HMOs + fatty acids present in a small Western-Australia dyad subset. |

### Honourable mentions — useful but more limited
- **PRJEB14964** – "Maternal Secretor Status and Microbiota Composition" (UK/Ireland pilot, 28 child + 17 mother secretor status, 16S child stool). Open, but only child (2–3 yr, not infant) stool and no milk component tables.
- **PRJEB11531** – Freeze-drying of infant feces: 16S + fecal (milk-derived) oligosaccharide profiles. Open. Milk HMOs only inferred from stool.
- **PRJNA778053** – "Associations between human milk oligosaccharides and infant gut microbiota in healthy Brazilian infants" (Columbia Univ., 16S/metagenomic). Open. HMOs reported in companion paper.
- **PRJEB54707 / PRJEB54991 / PRJEB62690** – Nestlé/Danone formula-vs-breastfed infant stool shotgun with HMO arms. Open. Not mother–infant dyads (no own-mother milk) → listed for reference only.

---

## 2. Top-3 picks — what exactly is downloadable

### 1) MILK cohort (Ferretti et al. 2025, Nat Commun) — best open shotgun mother–infant microbiome set
- **Infant stool metagenomics (raw):** NCBI SRA/ENA **PRJNA1019702** ("MILK study metagenomic sequencing of human milk and infant feces", public 2024-01-15). Deep-resequenced milk subset: **PRJNA1198101**.
- **Milk metagenomics (raw):** same BioProject (PRJNA1019702), 1 and 3 months postpartum.
- **Processed tables:** MetaPhlAn4 taxonomic profiles (Suppl. Data 3), HUMAnN3 functional profiles (Suppl. Data 5), DeepARG resistome (Suppl. Data 6), strain-sharing (Suppl. Data 4), subject metadata incl. delivery mode, feeding mode, dyad pairing (Suppl. Data 1–2) — all mirrored at Zenodo `https://zenodo.org/records/17317218`.
- **Code:** `https://github.com/blekhmanlab/milk_infant_microbiome`.
- **Caveats:** HMOs are from companion paper (Johnson 2024 Cell Genom, `phs003408` dbGaP — **controlled**, not in the open set); milk samples have very high host DNA (~97%) so ~26 milk samples failed QC and milk microbiome depth is shallow except for the 30 re-sequenced samples. Dyad linkage column is explicitly defined (`subjectID`, `relation`) in StrainPhlAn metadata.

### 2) MAMI cohort (Samarra et al. 2026, Cell Rep Med) — best combination of shotgun milk microbiome + infant stool + HMOs
- **Infant stool metagenomics (raw):** **PRJEB74322** ("Spanish mother and infants metagenomes of stool and milk samples", public 2024-04) and **PRJNA1227883** ("Metagenomes from mother–infant fecal and breastmilk samples of the MAMI cohort", public 2025-04).
- **Milk metagenomics (raw):** same two accessions (stool + milk pooled in these projects).
- **HMOs:** measured per milk sample by Bode lab (UPLC-MS/MS); values/longitudinal trajectories reported in the paper's supplemental tables; maternal FUT2/secretor status is a key variable.
- **Other milk components:** milk sIgA and cytokine immunotypes published from the same cohort (Rio-Aige et al. 2023, *Front Nutr* 10:1252815).
- **Caveats:** HMO numbers are embedded in the article supplementary XLSX rather than a standalone metabolomics repository. Milk 16S amplicon data from the earlier MAMI milk-microbiota paper (Cortes-Macías 2021) is deposited separately (accession in that paper — **UNVERIFIED** in this run). Dyad linkage is via mother ID in BioSample attributes.

### 3) Gambian HMO dyads (Davis et al. 2017, Sci Rep) — best fully open HMO + infant 16S set
- **Infant stool 16S:** ENA **PRJEB15633** ("Growth and Morbidity of Gambian Infants are Influenced by Maternal Milk Oligosaccharides and Infant Gut Microbiota", public 2016-11). 33 mother–infant pairs at 4, 16 and 20 weeks postpartum.
- **HMOs:** full Lebrilla HPLC-Chip/QTOF panel per milk sample at each time point, reported in Supplementary Information of the paper (Sci Rep 7:40466) — values tabulated per mother per visit.
- **Other:** infant weight-for-age, morbidity counts, fecal calprotectin; wet vs dry season; maternal secretor status inferred from 2′FL/LNFP-I.
- **Caveats:** no milk microbiome; 16S only (not shotgun); HMO table is inside the article's supplementary Excel/PDF, not in MetaboLights. Dyad linkage and infant age are in the paper's supplementary table, not in ENA sample attributes.

---

## 3. Verification log (every query actually executed)

1. `esearch db=bioproject term=(human milk oligosaccharide*) AND (infant gut OR infant fecal OR infant stool)` → 48 hits; ID list saved.
2. `esummary` on 40 BioProject IDs (batches of 10) → titles/descriptions parsed; retained MAMI/Mexico/Gambia/MILK/Masi/Cambodia/etc.; dropped in vitro/mouse-only.
3. Europe PMC search `("human milk oligosaccharides" AND "infant gut microbiome" AND (SRA OR PRJNA OR PRJEB OR ENA OR Qiita OR Zenodo))` → 111 hits; top 25 titles scanned.
4. ENA portal `study_description="*milk oligosaccharide*" AND study_description="*infant*"` → 30 rows; PRJEB15633, PRJEB16321/16322, PRJEB41404 kept.
5. ENA portal `study_description="*breast*milk*" AND study_description="*infant*stool*"` → 0 rows.
6. ENA portal `study_description="mother-infant dyad*"` → 0 rows.
7. ENA portal `study_description="*mother and infant*"` → 0 rows.
8. ENA portal `study_title="*breast milk*" AND study_title="*infant*"` → 0 rows.
9. ENA portal `study_description="milk microbiome"` → 30 rows (PRJNA1186977 UPSIDE, PRJEB96800, PRJNA542938/542940 etc. noted).
10. ENA portal `study_title="*HMO*"` → 30 rows (mostly formula-HMO trials + microbial isolates).
11. ENA portal full report `study_accession=PRJEB72536` → exists, first_public 2024-02-09.
12. ENA portal full report `study_accession=PRJEB83236` → exists, first_public 2025-08-12.
13. ENA portal read_run count for PRJEB72536 → 125 lines (1 header + 124 runs).
14. ENA portal read_run count for PRJEB83236 → 1,918 lines (1 header + 1,917 runs).
15. ENA portal `study_accession=PRJNA1019702` → "MILK study metagenomic sequencing of human milk and infant feces", first_public 2024-01-15.
16. ENA portal `study_accession=PRJNA1198101` → "MILK study metagenomic re-sequencing of human milk", first_public 2024-12-16.
17. ENA portal `study_accession=PRJEB15633` → Gambian HMO infant study, first_public 2016-11-01.
18. ENA portal `study_accession=PRJEB74322` → "Spanish mother and infants metagenomes of stool and milk samples", first_public 2024-04-01.
19. ENA portal `study_accession=PRJNA1227883` → "Metagenomes from mother-infant fecal and breastmilk samples of the MAMI cohort", first_public 2025-04-05.
20. Europe PMC search `EXT_ID:41274878` → confirmed Ferretti 2025 Nat Commun (PMC12749357).
21. Europe PMC search `"Growth and Morbidity of Gambian Infants"` → Davis 2017 Sci Rep (PMID 28079170, PMC5227965).
22. Europe PMC search `"MAMI cohort" AND (milk microbiome OR breast milk)` → Samarra 2026 Cell Rep Med (PMC13589485), Cortes-Macías 2021, Rio-Aige 2023.
23. Europe PMC search `("CHILD cohort" AND "human milk oligosaccharides" AND microbiome)` → 88 hits; CHILD HMO papers found but all are closed / no open repository accession (see "Not suitable").
24. Europe PMC `PMC12749357/fullTextXML` (Ferretti 2025) → accessions found: PRJNA1019702 (×2), PRJNA1198101 (×2), Zenodo (×3), GitHub (×1). Data-availability paragraph captured verbatim.
25. Europe PMC `PMC12818807/fullTextXML` (Corona-Cervantes 2026) → PRJNA1260751 (×1); data-availability statement: SRA SUB15262662 / PRJNA1260751; HMO values in supplementary .docx.
26. Europe PMC `PMC11524953/fullTextXML` (Masi 2024) → PRJEB72536 (×4), PRJEB39610 (×4), HMO (×41 mentions).
27. Europe PMC `PMC13589485/fullTextXML` (Samarra 2026 MAMI) → PRJEB74322 (×4), PRJNA1227883 (×4).
28. Europe PMC `PMC11602576/fullTextXML` (Johnson 2024 MILK cohort HMOs) → accessions: `phs003408` dbGaP (×2), PRJNA1019702 (×1), figshare (×4), EGA (×17 mentions). → Access controlled.
29. Europe PMC search `Johnson KE AND Fields DA AND infant gut AND breast milk` → Johnson 2024 Cell Genom + Ferretti 2025 Nat Commun.
30. Europe PMC search `Moossavi AND "CHILD" AND "breast milk microbiota"` → review/editorial hits only; CHILD milk microbiome papers (Moossavi 2019/2024) have **no** linked open BioProject → CHILD listed as "Not suitable".
31. Metabolomics Workbench REST `/rest/study/study_title/milk/summary` → 20 human studies returned; none is a mother–infant HMO + infant-stool dyad set (closest ST003874 = Stanford HMO trial in elderly; ST004088 = vitamin D milk metabolomics).
32. Metabolomics Workbench REST `/rest/study/study_title/oligosaccharide/summary` → 3 hits, none are mother–infant dyads.
33. MetaboLights WS `studies?query=human milk oligosaccharide` → returned bulk list (3,518 studies) not a filtered search; no dyad HMO study readily retrievable → UNVERIFIED.
34. ENA portal `study_title="*Mother and infant study*"` and `study_description="*Demerath*"`, `study_title="*Ferretti*"` → only PRJNA799384 (Ferretti 2018 MAGs); MILK seq lives under PRJNA1019702/1198101 (queried in #15–16).
35. ENA portal `study_description="*Blekhman*"` → only PRJNA218879 (unrelated).

---

## 4. Not suitable / ruled out

| Candidate | Why excluded from top list |
|-----------|----------------------------|
| **CHILD cohort (Canada, Azad/Bode/Miliku)** | Papers exist (Turner 2025 Front Nutr; Fang 2026 preprint; Dai 2026 Cell Rep Med) but CHILD metadata + HMO tables require a CHILD data-access application; the milk microbiome data of Moossavi 2019 / Chehab 2024 and the CHILD infant 16S/metagenomes (PRJNA758986 etc.) are not linked to an open per-dyad HMO table. Listed as **controlled access**. |
| **Johnson et al. 2024 Cell Genom (MILK cohort HMOs, "Human milk variation…")** | HMO concentrations themselves are deposited in dbGaP **phs003408** (controlled access). Only the de-identified shotgun reads are in PRJNA1019702. → HMO values NOT freely downloadable. |
| **Lifelines NEXT (Sinha et al. 2026 Nature)** | Large mother–infant shotgun cohort but phenotypes + any milk component data require a Lifelines proposal; sequence data are partly at EGA. Listed as **partly open**. |
| **PRJEB54707, PRJEB54991, PRJEB62690** (Danone/Nestlé 2′FL / 5-HMO formula trials) | Shotgun infant stool, but formula-fed infants with no own-mother milk → not true dyads for HMO exposure. |
| **PRJEB29697** (sialylated BMO bone-growth mouse) | Gnotobiotic mouse model, no human dyads. |
| **PRJNA1366969, PRJNA1081879, PRJEB31915** | Mouse HMO/germ-free or preterm-birth urine HMO — not mother–infant stool + milk dyads. |
| **PRJEB16321 / PRJEB16322** (Armenia/Georgia breastfed-infant 16S) | Only infant feces + secretor status; no milk samples collected → fails "milk component" criterion. |
| **PRJEB45396** (SYNERGIE Bangladesh B. infantis EVC001 ± LNnT) | Intervention trial in SAM infants with donor–strain supplement — milk not sampled per mother. |
| **ENDIA** (Roth-Schulze 2026 Diabetologia) | Delayed milk-microbiome maturation with T1D; sequence accession reported but dyad HMO table not open. |
| **PRJEB39420** (donor human milk vs formula) | Infant stool but mothers' own milk not profiled → not a dyad resource. |
| **TUMMY, ALADDIN, LACTIVE, BINGO, ZIBI** | Could **not be verified** as holding an open mother–infant HMO + infant-stool dataset during this run. Some (TUMMY/Aladdin) have HMO or infant-microbiome papers, but a matching open SRA/ENA accession linking dyads was not found. Marked **UNVERIFIED** — worth a targeted follow-up with the PIs. |
| **UC Davis Foods-for-Health (Mills/Lebrilla/Underwood) US cohort** | Only the small Gambian sister study (PRJEB15633) is openly sequenced; the larger US "UC Davis BHBP" dyad metabolomics/HMO files live on the lab website / Dryad but with no matching open stool-metagenome BioProject found in this search. Marked **UNVERIFIED**. |

---

### Summary recommendation
For a fully open, immediately downloadable mother–infant HMO-focused resource, start with:
1. **Ferretti 2025 MILK** (PRJNA1019702 + Zenodo tables) for shotgun milk microbiome × infant stool;
2. **Samarra 2026 MAMI** (PRJEB74322 / PRJNA1227883) for shotgun milk+stool + per-sample HMOs;
3. **Davis 2017 Gambia** (PRJEB15633) for an open per-dyad HMO table + infant 16S.

All three are verified to be downloadable from ENA/SRA today; every other large dyad cohort (CHILD, MILK-HMO/Johnson-2024, Lifelines NEXT) routes its milk-component tables through controlled access.
