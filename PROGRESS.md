# Project progress and resume notes

Last updated: 2026-10-10 02:46 (brief 05 interrupted mid-run; see step 5 and resume instructions). Keep this file current; it is the hand-off between sessions.

## Working model

Claude Code is the supervisor. It writes briefs in `briefs/`, launches Goose (Kimi via the University
of Idaho MindRouter gateway) with `tools/run_goose_brief.ps1`, reviews what comes back, and decides the
next step. Goose does the research and coding. See `CLAUDE.md` for the launch command and rules.

## Goal

Build an R Shiny dashboard for teaching visualizations of human milk components and infant/milk
microbiome across population groups. Because no fully open dataset had ≥3 milk data types with
per-sample tables, the user decided (2026-10-10) to **simulate** a dyad dataset from the summary
statistics published in the INSPIRE study papers. **All INSPIRE-derived data in this repo is simulated;
this must be stated prominently everywhere it is used** (see `CLAUDE.md`).

## Steps completed

| # | Step | Output | Status |
|---|------|--------|--------|
| 1 | Survey of open dyad datasets (raw sequencing focus) | `data/dyad_dataset_report.md` | done 2026-10-09 |
| 2 | Re-survey for pre-processed milk tables (brief 02) | `data/milk_components_preprocessed_report.md` | done; no full match. MILK cohort tables saved in `data/raw_downloads/MILK_zenodo/` |
| 3 | Retry with download workarounds (brief 03) | partial; stopped by supervisor when the INSPIRE decision was made | Mongolian dyad tables saved in `data/raw_downloads/Davaanyam_figshare/` |
| 4 | Catalogue INSPIRE PDF summary statistics (brief 04) | `data/inspire/catalog.md`, `data/inspire/summary_stats/` (5,662 rows), `data/inspire/extraction_log.md` | done; supervisor spot-checked 3 tables against PDFs, all exact |
| 5 | Simulate dyad dataset in R (brief 05) | `R/01..03_*.R`, `data/simulated/` | **in progress, interrupted by laptop shutdown 2026-10-10 02:46**. Done: `R/01_load_summary_stats.R`, `R/02_simulate_dyads.R`, all `params_*.csv`, all `simulated_*.csv`, `provenance.csv`, `data_dictionary.csv`. NOT done: `R/03_validate_simulation.R`, `validation_report.md`, full `README.md` (placeholder only). Goose session `brief05_simulate` was at 69 tool calls, debugging in `scratch/brief05/dbg*.R`. |
| 6 | Shiny dashboard (brief 06) | `app/` | not started; needs the user's list of desired visualizations |

## How to resume after a shutdown

1. Open the project in RStudio or Positron (`AI-Workshop-2026.Rproj`) and start Claude Code there.
2. Check whether brief 05 finished: `data/simulated/validation_report.md` exists → finished.
   If not, re-launch from the project root; Goose will resume its session and the brief tells it to
   continue from any partial files:
   ```powershell
   .\tools\run_goose_brief.ps1 -Brief briefs\05_simulate_inspire_dyads_R.md -Session brief05_simulate -Deliverable data\simulated\validation_report.md
   ```
   Logs: `scratch/goose_logs/`.
3. Supervisor review of brief 05: run `Rscript R/03_validate_simulation.R`, read the validation
   report, check that the simulated-data notice is in README, scripts, and report, and spot-check a
   few cohort means against `data/inspire/summary_stats/`.
4. Ask the user for the specific visualizations they want, then write brief 06 (Shiny app in `app/`,
   persistent simulated-data banner on every tab, reads from `data/simulated/`).

## Known issues and decisions

- Kimi often ends its turn with a progress note instead of a tool call; the wrapper auto-resumes.
- Goose's cmd.exe shell truncated multi-line commands; wrapper sets `GOOSE_SHELL=powershell`.
- PMC and publisher sites block curl; Europe PMC `supplementaryFiles` endpoint and DataCite search work.
- PDF font encodes the prime symbol as `#` (`2#FL`); brief 05 normalises names on load.
- INSPIRE PDFs stay in OneDrive; `*.pdf` is gitignored. Do not copy them into the repo.
- Nothing has been committed to git yet. User decision 2026-10-10: **all real downloaded data is gitignored**
  (`data/raw_downloads/`). Only simulated data, reports, briefs, and code go into git.
