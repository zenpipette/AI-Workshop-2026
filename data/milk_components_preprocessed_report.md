# Pre-processed mother–infant dyad datasets with ≥3 milk components and ≥2 comparison groups

**As of:** 2026-10-10. **Brief:** `briefs/02_preprocessed_milk_components_search.md` (supersedes `data/dyad_dataset_report.md`, 2026-10-09).
**Network environment:** Windows; `curl.exe` + Python 3.13 (`pandas`, `openpyxl` installed). Verification downloads were made with `curl.exe`/Python; tables were opened with `pandas` to confirm rows × columns and key columns. Repository JSON APIs (Zenodo record API, GitHub API, Europe PMC, Dryad) worked; **Zenodo's `search` endpoint and most publisher supplement CDNs (OUP, Nature, MDPI, Elsevier/Cell Press `/bin/`, PMC) returned 403/HTML stubs to `curl`** in this environment, which is the binding constraint on "verify by opening" for supplement-held tables. Anything not actually opened is marked **UNVERIFIED** below.

**Bottom line up front.** Under the strict new criteria (≥3 distinct milk component layers, *each* as an open, downloadable, machine-readable per-sample table; ≥2 groups; dyad/mother ID present; open access), **no candidate fully passed verification this run.** Exactly **one** dataset (the MILK cohort on Zenodo) was downloaded and opened and is a genuine pre-processed mother–infant dyad resource — but it only yields **1 milk component layer** as a processed table (milk metagenome via MetaPhlAn/HUMAnN); its HMO values are in **controlled-access dbGaP `phs003408`**, so it fails requirement #2. Every cohort that plausibly *does* have ≥3 milk layers (MAMI, Masi NEC, INSPIRE/McGuire, BLOSOM/Stinson/Geddes, Davis 2017 Gambia, Corona-Cervantes, Karampatsas, COPSAC/SKOT, STEP, MING) keeps those tables either inside anti-bot-blocked journal supplements, inside PDFs (not machine-readable), in `.Rdata` (not openable with the allowed tools), or behind controlled access.

This is a narrower and more honest answer than report 01: the earlier report conflated *"sequencing is open"* with *"processed component values are downloadable."* Under brief 02 the two are different, and most open-sequencing dyad cohorts do **not** publish ≥3 milk-component layers as open per-sample tables.

---

## 1. Ranked table

Ranking follows the brief: (a) each of ≥3 milk layers present *as an open per-sample table*; (b) ≥2 comparison groups in metadata; (c) dyad/mother ID present; (d) open access; nice-to-haves (processed infant-stool table, longitudinal, ≥40 dyads, machine-readable metadata) break ties. "Layers ✅" counts only layers confirmed present *as a downloadable processed table*; unconfirmed-but-claimed layers are noted in caveats. A BioProject/SRA/ENA accession with raw FASTQ only does **not** count toward any layer.

| # | Dataset / paper | n dyads | Milk component layers **as processed tables** | Group variable(s) | Infant stool **processed** table? | Time points | Where files live (URL) | Format | Dyad/mother ID column | Access | Notes / caveats |
|---|------------------|---------|------------------------------------------------|-------------------|-----------------------------------|-------------|------------------------|--------|-----------------------|--------|-----------------|
| 1 | **MILK cohort** — Ferretti et al. 2025 *Nat Commun* (10.1038/s41467-025-66497-y) | 195 dyads | **1 confirmed**: milk **metagenome** taxonomic (MetaPhlAn4, STable3) + pathway (HUMAnN3, STable5). HMOs exist for cohort but are in **controlled dbGaP phs003408** (companion Johnson 2024) → not counted | Delivery mode (SVD 122 / CS 48 / AVD 2), maternal BMI, infant exclusive-BF, abx exposure, race | **Yes** (infant stool MetaPhlAn4 + HUMAnN in same STable3/STable5 matrices) | Milk 1M & 3M; stool 1M & 6M | `https://doi.org/10.5281/zenodo.17317218` (+ GitHub `blekhmanlab/milk_infant_microbiome`) | CSV/TSV | `Mother Infant Pair` (STable2) | **Fully open** | ✅ **Verified by download+open.** The only confirmed processed dyad resource this run — but technically fails brief's ≥3-milk-layers rule (only milk metagenome layer is open). STable6 (2.3 GB gene-family matrix) not downloaded. ~27 of 173 milk samples only at 3M; milk QC-high host DNA. |
| 2 | **MAMI cohort** — Samarra et al. 2026 *Cell Rep Med* (10.1016/j.xcrm.2026.103007) | ~120 dyads | Claimed **3+** (milk shotgun metagenome; per-sample **HMOs** by Bode lab; milk **sIgA/cytokines** from companion Rio-Aige 2023) — but only the ARG/resistome + sequencing-QC supplements (mmc2/3/4) are present, and the HMO values are locked in **mmc1.pdf / narrative**. Sequencing open at **PRJEB74322 + PRJNA1227883** (raw) | Maternal secretor (FUT2) status, delivery/feeding mode | Raw shotgun (ENA); no processed per-sample stool abundance table confirmed | Milk & stool, longitudinal | Paper supplements `https://pmc.ncbi.nlm.nih.gov/articles/PMC13589485/` | PDF (mmc1) + XLSX/CSV (mmc2-4) | Mother ID in BioSample attrs | **Fully open (seq); HMO table UNVERIFIED** | ⚠️ **UNVERIFIED** — supplement binaries bot-blocked (PMC `/bin/` returned HTML stubs, deleted). MAMI milk metagenome + HMO + sIgA/cytokines would satisfy ≥3 layers *if* the per-sample tables are reachable in a browser. Highest-value target for a JS-browser re-fetch. |
| 3 | **Masi et al. 2024 NEC** — *Cell Rep Med* (10.1016/j.xcrm.2024.101708) | 110 dyads (48 NEC / 62 control) | Claimed **3** (milk 16S **microbiome** PRJEB72536/PRJEB39610; per-sample milk **HMOs** (Bode); infant stool 16S) — but supplementary files are **PDFs only** (mmc1.pdf / mmc2.pdf); raw 16S in ENA. No machine-readable per-sample HMO/taxonomy table confirmed | NEC vs control (primary outcome); gestational age | Raw 16S (ENA PRJEB72536/PRJEB39610); processed stool table not confirmed | Longitudinal | Paper supplements `https://pmc.ncbi.nlm.nih.gov/articles/PMC11524953/` | PDF only | (in supplement/clinical data) | **Seq open; tables in PDF** | ⚠️ **Ruled out as a *table* source** (fails req #1: supplements are PDF narrative, data-avail says extra info "from lead contact"). Best multi-layer *design* (milk microbiome + milk HMOs + stool, NEC group) but values are not in an open machine-readable file. |
| 4 | **GitHub `pomnoob/hmMetabo`** — Chinese breast-milk metabolome + peptide study | unclear (per-sample rows present; dyad link unclear) | Claimed **2** (milk **metabolome**, milk **peptides**) as `.Rdata`; questionnaire metadata | city, lactation month (M1..M6+) | No | Yes (M1/M6) | `https://github.com/pomnoob/hmMetabo` tree `data/` | `.Rdata` (not openable with pandas) + questionnaire CSV | sample-city-month CSV (no infant/dyad ID) | **Open** | ⚠️ **Ruled out** — fails req #2 (only metabolome+peptide, not ≥3 distinct milk layers), req #4 (no mother/infant dyad linkage column confirmed), and the actual component tables are `.Rdata` (can't be opened with the allowed stack). |
| 5 | **Barile-Lab `MilkOligoDB`** — harmonized HMO literature reference | n/a (aggregated across many studies) | **1** (HMO concentrations, literature-derived) | species/study (not within-cohort groups) | No | n/a | `https://github.com/Barile-Lab/MilkOligoDB` (`MilkOligoDB.csv`) | CSV | n/a | **Open** | ⚠️ **Ruled out** — a cross-study harmonized HMO database, not a mother–infant dyad cohort; no infant samples, no within-cohort groups, only the HMO layer. Useful as a reference table, not a dyad dataset. |

### Additional candidate cohorts checked — summary
These were investigated for open processed tables and are **UNVERIFIED** (could not be opened this run, mostly due to anti-bot supplement blocking or controlled access). They are listed with the specific failure reason in §4.

- **INSPIRE / McGuire / Bode** AJCN 2017 multi-population HMO study (PMC5402033) — supplemental tables behind OUP paywall/CDN; not in PMC OA subset.
- **BLOSOM / Arishi / Stinson / Geddes** Western-Australia dyads (Nutrients 2025; Front Cell Infect Microbiol 2026) — MDPI/Frontiers pages JS/bot-blocked; no repository deposit found; thesis PDF is narrative.
- **Gridneva / Geddes lab** WA milk hormones/HMOs/macronutrients — no public per-sample deposit; IMiC data under agreement.
- **Danish SKOT / COPSAC** — data by signed agreement only.
- **Finnish STEP / Norwegian (HUMMI)** — no open processed dyad milk table found.
- **Chinese MING** — Nestlé multi-country study; HMO values in publications, no open per-sample table found.
- **Davis et al. 2017 Gambia** (PRJEB15633) — infant 16S open (raw); per-dyad HMO values in Sci Rep supplementary (machine-readable status unconfirmed); no milk microbiome layer → ≤2 layers anyway.
- **Karampatsas 2022 Gambia** (PRJEB41404) — 16S open (raw); milk NMR/GC-MS metabolome claimed, but the cited figshare DOI (`10.24376/rd.sgul.14045945`) resolves to a *different* study (GAMI clinical data); processed metabolite table not reachable → ≤2 layers anyway.
- **Corona-Cervantes** — only the 2020 *PLOS ONE* Mexico milk-microbiota paper and an unrelated 2025 *Gut Microbes* Mexico HMO/obesity cohort were found; no 2026 processed-table deposit located (raw shotgun SRA PRJNA1260751 only).

---

## 2. Top 3 in detail

Because **only one dataset passed full download-and-open verification** and **no candidate met all four hard requirements**, this section gives (a) the single fully-verified resource, and (b) the two best *near-miss* multi-layer dyad candidates with precisely what is reachable vs. not.

### 2.1 — VERIFIED: MILK cohort (Ferretti et al. 2025, *Nat Commun*)  ✅ downloaded & opened

- **Record:** <https://doi.org/10.5281/zenodo.17317218> → API <https://zenodo.org/api/records/17317218>
- **Title:** "Assembly of the infant gut microbiome and resistome are linked to bacterial strains in mother's milk"
- **Sequence accessions (raw, for reference only — not counted):** SRA `PRJNA1019702` (milk + infant stool metagenomes), re-seq `PRJNA1198101`.
- **Code:** `https://github.com/blekhmanlab/milk_infant_microbiome`
- **Downloaded to:** `data/raw_downloads/MILK_zenodo/`

| File (exact URL `https://zenodo.org/api/records/17317218/files/<name>/content`) | Size | Rows × Cols | What it contains | Key columns |
|---|---|---|---|---|
| `STable1.csv` | 514 B | 21 × 4 | Cohort summary (delivery-mode counts etc.) | `…, type, number of samples, percentage` |
| `STable2.csv` | 51,530 B | **507 × 14** | **Per-sample metadata** — 507 samples across Milk_1M (146), Milk_3M (27), Stool_1M (175), Stool_6M (159) | `Sample_ID, Sample_type, Mother Infant Pair, Post_filtering_QC, Maternal_age, Maternal_bmi, Infant_sex, Delivery_mode, Infant_exclusive_bf, Solid_food_6M, Abx_exposure_any, Prenatal_abx, Ethnicity, Race` |
| `STable3.tsv` | 1,969,874 B | **1,395 × 508** | **MetaPhlAn4 taxonomic-clade abundance matrix** (rows = clades incl. `UNCLASSIFIED`, `k__Bacteria`, …; 507 sample cols) | `clade_name`, then sample IDs e.g. `4M30015MILK_S389`, `…MILK3_S390`, `…MO1_S387`, `…MO6_S388` |
| `STable4.txt` | 20,590 B | 180 × 8 | Per-taxon mother↔infant strain-sharing pairs | `taxon, sample1, sample2, sample1_coupleID, sample2_coupleID, sample1_sample_type, sample2_sample_type, type` |
| `STable5.txt` | 29,486,906 B | **21,770 × 508** | **HUMAnN3 pathway abundance matrix** (507 sample cols, same IDs as STable3) | `Pathway`, then sample IDs |
| `STable6.tsv` (NOT downloaded) | 2,363,339,473 B (2.3 GB) | — | Gene-family / strain-level matrix (too large; borderline-raw) | — |

- **Group variable(s) present (verified):** `Delivery_mode` (milk rows: SVD 122, CS 48, AVD 2, blank 1) → **≥2 groups ✅**; also `Maternal_bmi`, `Infant_exclusive_bf`, `Abx_exposure_any`, `Race`.
- **Dyad ID column (verified):** `Mother Infant Pair` (e.g. `Mother_Infant_Pair_1`) → **195 unique dyads ✅**; also `sample1_coupleID` in STable4.
- **Infant stool processed table (verified):** ✅ Yes — infant stool MetaPhlAn4 + HUMAnN abundances are columns in the same STable3/STable5 matrices (`…MO1`, `…MO6`).
- **Time points:** ✅ Longitudinal — Milk 1M & 3M; stool 1M & 6M.
- **≥40 dyads:** ✅ 195.
- **Machine-readable metadata:** ✅ CSV.
- **Milk component layers as processed tables:** **1** — milk **metagenome** (taxonomy STable3 + function STable5). ⚠️ Milk **HMOs** for this cohort exist but are in **controlled dbGaP `phs003408`** (Johnson 2024 companion) → **do not count** under the open-access rule.
- **What's missing to fully satisfy the brief:** open per-sample **HMO**, **fatty-acid/lipid**, and **protein/immune-factor** tables (these were not openly deposited for this cohort).
- **Access:** Fully open (CC-BY Zenodo). ℹ️ *This is the strongest immediately-usable processed dyad resource, but it is a 1-milk-layer dataset, so it is a partial (not full) match to brief 02's "≥3 milk components."*

### 2.2 — NEAR-MISS / UNVERIFIED: MAMI cohort (Samarra et al. 2026, *Cell Rep Med*)

- **Paper:** <https://pmc.ncbi.nlm.nih.gov/articles/PMC13589485/> (10.1016/j.xcrm.2026.103007)
- **Sequence accessions (raw):** `PRJEB74322`, `PRJNA1227883` (milk + stool shotgun, open).
- **Supplementary files declared in JATS XML:** `mmc1.pdf` (Document S1, Tables S1 & S4 — *the HMO-bearing tables*), `mmc2.xlsx` (Table S2 sequencing QC), `mmc3.csv` (Table S3 infant-fecal **ARG** abundance), `mmc4.csv` (Table S5 milk **ARG** abundance), `mmc5.pdf` (Document S2).
- **Component layers claimed (≥3):** milk shotgun **metagenome**; per-sample **HMOs** (Bode lab, UPLC-MS/MS); milk **sIgA / cytokine immunotypes** (Rio-Aige 2023 companion). 
- **Group variable(s):** maternal **secretor (FUT2)** status; delivery/feeding mode. 
- **Infant stool processed table:** raw shotgun only; no processed per-sample stool abundance table confirmed.
- **Download attempt:** `https://www.ncbi.nlm.nih.gov/pmc/articles/PMC13589485/bin/mmc2.xlsx` (and mmc3.csv, mmc4.csv) all returned **HTML stubs** (anti-bot), confirmed by magic bytes `<!doctyp`; files deleted. The real binaries sit on the Cell Press CDN behind JS.
- **Exact URLs to retry with a JS-capable browser:** the PMC article page's "Supplementary Material" anchors → `…/PMC13589485/bin/mmc1.pdf`, `mmc2.xlsx`, `mmc3.csv`, `mmc4.csv`, `mmc5.pdf` (Cell Press `cms.elsevier-cms.com` equivalents).
- **What's missing:** direct machine-readable **HMO concentrations per milk sample** (they are inside the `mmc1.pdf` narrative/tables, not a clean CSV); an open per-sample milk-taxonomy/stool-taxonomy abundance matrix (only raw ENA).
- **Status:** ⚠️ **UNVERIFIED** — would very likely satisfy ≥3 milk layers + ≥2 groups + dyads *if* the supplement tables can be fetched; cannot be confirmed by opening in this environment.

### 2.3 — NEAR-MISS / ruled out as a *table* source: Masi et al. 2024 preterm NEC (*Cell Rep Med*)

- **Paper:** <https://pmc.ncbi.nlm.nih.gov/articles/PMC11524953/> (10.1016/j.xcrm.2024.101708)
- **Sequence accessions (raw):** milk 16S `PRJEB72536` (124 runs) + `PRJEB39610`.
- **Component layers claimed (3):** milk 16S **microbiome**; per-sample milk **HMOs** (Bode lab); infant **stool** 16S. 
- **Group variable:** **NEC vs control** (48 / 62), gestational-age-matched — a clean 2-group contrast.
- **Time points:** longitudinal (preterm NICU).
- **Supplementary files:** `mmc1.pdf` (Document S1, Table S1) and `mmc2.pdf` (Document S2) — **PDFs only** (no `.xlsx`/`.csv`/`.tsv` per JATS). Data-availability: extra info "from the lead contact upon request."
- **Machine-readable per-sample table found?** ❌ No — milk HMO and milk-taxonomy values are only in the article PDF / available on request; raw 16S in ENA.
- **Status:** ⚠️ **Ruled out under requirement #1** (values not available as an open machine-readable table despite having the ideal ≥3-layer design and a clear group contrast).

---

## 3. Verification log (numbered — every query/download actually executed)

*Orchestrator (this session) direct actions:*

1. Read `briefs/02_preprocessed_milk_components_search.md` and `data/dyad_dataset_report.md` in full.
2. Installed `openpyxl` + `pandas` for Python 3.13 (initial `import` failed → `pip install` succeeded).
3. **`curl https://zenodo.org/api/records/17317218` → 200 JSON.** Parsed `metadata.title` ("Assembly of the infant gut microbiome and resistome … in mother's milk") and 6 files with sizes + content URLs (STable1/2/3/4/5, STable6=2.3 GB).
4. Downloaded MILK `STable1.csv`, `STable2.csv`, `STable3.tsv`, `STable4.txt` via `curl.exe -L` into `data/raw_downloads/MILK/`; `dir` confirmed sizes.
5. Opened each with `pandas` (`inspect_milk.py`): STable1 = 21×4 (delivery-mode summary); STable2 = **507×14** (`Sample_ID`, `Sample_type`, `Mother Infant Pair`, `Delivery_mode`, …); STable3 = **1395×508** MetaPhlAn clade abundance; STable4 = 180×8 strain-sharing. ✅
6. Computed STable2 value counts (`inspect_milk2.py`): Sample_type Milk_1M=146 / Milk_3M=27 / Stool_1M=175 / Stool_6M=159; Delivery_mode (milk) SVD=122 / CS=48 / AVD=2; **unique dyads = 195**. ✅
7. Fetched MAMI full text: `curl https://www.ebi.ac.uk/europepmc/webservices/rest/PMC13589485/fullTextXML` → OK (208 KB). Parsed supplementary refs (`mmc1.pdf`, `mmc2.xlsx`, `mmc3.csv`, `mmc4.csv`, `mmc5.pdf`) + captions; accession counts (PRJEB ×4, PRJNA ×4); no Zenodo/figshare/MetaboLights.
8. Download attempt MAMI `mmc2.xlsx`/`mmc3.csv`/`mmc4.csv` from `…/PMC13589485/bin/` → returned HTML stubs (magic bytes `<!doctyp`). `oa.fcgi?id=PMC13589485` → 404. **UNVERIFIED**; stubs deleted.
9. Fetched Masi full text: `curl …/PMC11524953/fullTextXML` → OK (133 KB). Parsed: only `mmc1.pdf`/`mmc2.pdf` supplements (PDFs, no xlsx/csv); data-availability says extra data "from lead contact"; accessions PRJEB72536/PRJEB39610. **Ruled out (req #1).**
10. Zenodo **search** API `…/api/records?q=…` → **403 Forbidden** (rate-limit HTML), so broad Zenodo discovery via search endpoint was blocked (record-by-ID endpoint still works).
11. GitHub API `…/repos/pomnoob/hmMetabo/contents/` and `…/repos/Barile-Lab/MilkOligoDB/contents/` → OK. Listed hmMetabo `data/` (7 `.Rdata` + 1 CSV) and its questionnaire-CSV header (city/id/month questionnaire columns, no infant/dyad ID); MilkOligoDB → single `MilkOligoDB.csv` (literature-aggregated HMO DB). Both ruled out (see §4).
12. Reconciled duplicate MILK folders: MD5-confirmed `data/raw_downloads/MILK/` ≡ `data/raw_downloads/MILK_zenodo/` (byte-identical for STable1–4); kept the more complete `MILK_zenodo` (has STable5), deleted `MILK`. Opened `STable5.txt` = **21,770 × 508** HUMAnN pathway matrix. ✅
13. Removed non-usable `data/raw_downloads/MAMI/` (HTML stubs only).

*Delegated verification agents (read-only research; summaries returned):*

14. **Agent A (report-01 re-checks):** MILK Zenodo 17317218 ✅ (independently downloaded & opened all tables incl. STable5; produced the §2.1 file table). MAMI → UNVERIFIED (database vs. cohort confusion; no processed tables located). Karampatsas 2022 → figshare DOI resolves to wrong study (GAMI clinical); only raw ENA PRJEB41404 reachable; processed metabolome UNVERIFIED. Corona-Cervantes 2026 → only 2020 PLOS ONE + unrelated 2025 Mexican cohort found; **no 2026 dataset**. Masi 2024 → paper found, processed tables not downloaded.
15. **Agent B (multi-country cohorts):** INSPIRE/McGuire AJCN 2017 → supplementary tables behind OUP CDN; not in PMC OA. BLOSOM/Arishi/Stinson → MDPI/Frontiers bot-blocked; only thesis PDF; no repo deposit. Gridneva/Geddes → no public per-sample deposit (IMiC under agreement). SKOT/COPSAC → data by agreement. Finnish STEP / Norwegian HUMMI → no open deposit. Chinese MING → no open per-sample table. All **UNVERIFIED**; environment blocked publisher supplements.
16. **Agent C (open-discovery of *new* dyad datasets):** reached its turn budget before returning a usable report; no additional open ≥3-layer dyad dataset was surfaced beyond the `pomnoob/hmMetabo` and `Barile-Lab/MilkOligoDB` GitHub references (both evaluated in step 11).

---

## 4. Ruled out — candidates checked and why they failed (which requirement)

| Candidate | Hard requirement(s) failed | Specific reason |
|-----------|----------------------------|-----------------|
| **MILK cohort (Ferretti 2025)** | **#2 (≥3 milk layers)** | Fully verified as open processed dyad resource, but only **1 milk layer** (metagenome: STable3 taxonomy + STable5 pathways) is openly downloadable; the cohort's **HMO** values are in controlled **dbGaP phs003408** (Johnson 2024). No open milk fatty-acid/protein/immune tables. *Best partial match.* |
| **MAMI cohort (Samarra 2026)** | **#1 (verifiable open table) — UNVERIFIED** | ≥3 layers claimed (metagenome + HMO + sIgA/cytokines) but the value-bearing tables (`mmc1.pdf`/narrative) are not a clean machine-readable deposit; PMC `/bin/` binaries bot-blocked this run. Raw seq (PRJEB74322/PRJNA1227883) is not a processed table. |
| **Masi 2024 NEC** | **#1 (open machine-readable table)** | Ideal ≥3-layer design (milk microbiome + milk HMOs + stool, NEC vs control) but supplements are **PDFs only** and raw 16S is ENA; no per-sample CSV/TSV/XLSX. ("From lead contact.") |
| **INSPIRE / McGuire / Bode AJCN 2017** | **#1, #4 (dyads), UNVERIFIED** | ≥3 milk layers only in OUP supplemental tables (paywalled/bot-blocked, not in PMC OA); it is a *milk-composition reference* across populations, not clearly a mother–infant dyad set with infant samples. |
| **BLOSOM / Arishi / Stinson / Geddes (WA)** | **#1, #4, UNVERIFIED** | Rich milk layers (HMOs + fatty acids + protein + sIgA) but only in MDPI/Frontiers articles (bot-blocked) or a narrative PhD thesis; no open per-sample repository deposit; infant *oral* (not stool) emphasis. |
| **Gridneva / Geddes WA cohorts** | **#1, #5 (open access)** | Milk hormones/HMOs/macronutrients not deposited openly; IMiC data under data-sharing agreement (not "downloadable today without a DUA"). |
| **Danish SKOT / COPSAC** | **#5 (open access)** | Data require a signed access agreement; no direct-download per-sample milk table. |
| **Finnish STEP / Norwegian (HUMMI)** | **#1, #4, UNVERIFIED** | No open per-sample mother–infant milk table found; STEP is controlled. |
| **Chinese MING** | **#1, #4, UNVERIFIED** | Nestlé multi-country study; HMO values summarized in publications only; no open per-sample dyad table on Zenodo/Dryad/figshare/OSF/GitHub. |
| **Davis et al. 2017 Gambia (PRJEB15633)** | **#2 (≥3 layers)** | Per-dyad HMO + infant 16S only → ≤2 milk layers max, and **no milk microbiome**; raw 16S in ENA. |
| **Karampatsas 2022 Gambia (PRJEB41404)** | **#2, #1 (UNVERIFIED)** | 16S (raw) + milk metabolome claimed → at most 2 open layers, and the processed metabolome table was not reachable (cited figshare `10.24376/rd.sgul.14045945` resolves to a different study, GAMI). |
| **Corona-Cervantes 2026** | **UNVERIFIED / #2** | No 2026 processed-table deposit located (only 2020 PLOS ONE milk-microbiota and an unrelated 2025 *Gut Microbes* obesity/HMO cohort with raw SRA PRJNA1260751). Single milk HMO layer at best. |
| **GitHub `pomnoob/hmMetabo`** | **#2, #4** | Milk metabolome + peptide `.Rdata` (2 layers, not openable with allowed tools) and questionnaire metadata by city/month; **no infant/dyad linkage column**, so not a dyad dataset. |
| **GitHub `Barile-Lab/MilkOligoDB`** | **#2, #4** | Cross-study harmonized **HMO** reference DB (single layer); no within-cohort mother–infant dyads or groups. A reference table, not a dyad cohort. |
| **Lifelines NEXT (Sinha 2026), CHILD (Azad/Bode/Miliku)** | **#5 (open access)** | Large dyad shotgun cohorts, but per-sample milk-component + phenotype tables route through controlled access (Lifelines proposal / CHILD application / dbGaP). Carried over from report 01. |

---

### Recommendation for the teaching workshop
For immediate, downloadable plotting of a mother–infant dyad with **groups**, use **MILK (Zenodo 17317218, `data/raw_downloads/MILK_zenodo/`)**: it has a verified per-sample milk **metagenome** (taxonomy + pathways), infant **stool** abundances, **195 dyads**, **longitudinal** sampling, machine-readable **metadata**, and the key **Delivery_mode** group contrast. It only falls short of "≥3 milk *component* layers." If a genuine multi-component milk table is required, the **MAMI cohort** is the single best next target and should be re-fetched with a **JS-capable browser** to obtain `mmc1.pdf`/the per-sample HMO values and any machine-readable supplement that anti-bot blocking hid from `curl`.

*Downloaded artifacts (verified) are under `data/raw_downloads/MILK_zenodo/`: `STable1.csv`, `STable2.csv`, `STable3.tsv`, `STable4.txt`, `STable5.txt`.*
