# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repository is

Materials and exercises for the AI Workshop 2026 (see `readme.txt`). It is an
early-stage, data-and-documents repository, not a software project. As of
October 2026 there is no source code, no build system, no package manager, no
linter, and no test suite. Do not invent build or test commands; if code is
added later, add the real commands here at that time.

Remote: `https://github.com/zenpipette/AI-Workshop-2026.git` (branch `main`).

## Layout

- `readme.txt` – one-paragraph description of the repo.
- `data/` – research outputs and datasets. Currently untracked by git (shows as
  `?? data/`); check with the user before committing anything under it, since
  it may be intended to stay local or may contain large files.
  - `data/dyad_dataset_report.md` – a compiled, verified survey of public
    mother–infant dyad datasets (infant gut microbiome + human milk components:
    HMOs, milk microbiome, fatty acids). Contains ranked accessions
    (NCBI BioProject / ENA), a per-query verification log, and a list of
    ruled-out cohorts. Treat it as the reference for which datasets are open
    vs. controlled access.

## Working conventions for this repo

- The content is biology/bioinformatics research material. When adding reports,
  follow the existing pattern in `data/dyad_dataset_report.md`: record the
  compile date, mark anything not confirmed as **UNVERIFIED**, and keep a
  verification log of the queries actually run.
- Dataset accessions (PRJNA/PRJEB IDs, DOIs) in the report were verified live
  on the stated date. Re-verify before relying on them in new work rather than
  assuming they are still current.

## Running Goose (the workhorse agent)

Claude acts as supervisor; Goose (Kimi via the MindRouter gateway) does research and coding.
Task briefs live in `briefs/NN_<name>.md`. Launch a brief with the wrapper, from the project root:

```powershell
.\tools\run_goose_brief.ps1 -Brief briefs\NN_x.md -Session <name> -Deliverable data\<report>.md
```

The wrapper sets `GOOSE_SHELL=powershell` (cmd.exe truncates multi-line commands) and keeps
resuming the session until the deliverable file exists, because Kimi tends to end its turn with
a progress note instead of a tool call. Logs go to `scratch/goose_logs/` (gitignored).
Goose scratch work belongs in `scratch/`, never the repo root.

## Data provenance notice (mandatory)

All INSPIRE-based data in this project is **simulated** from summary statistics published in the
INSPIRE study papers. It is not the original INSPIRE data. Every file, figure, dashboard view,
and report that uses it must state this prominently, for example:
"Simulated data generated from published INSPIRE summary statistics (McGuire 2017, Ruiz 2017,
Lackey 2019, ...). Not the original study data." The Shiny app must show this on every tab.

## Real data stays out of git

`data/raw_downloads/` holds real datasets (MILK cohort, Mongolian dyads) and is gitignored. Any
future real dataset goes there too. Only simulated data, reports, briefs, and code are committed.
