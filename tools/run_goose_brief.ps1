<#
Run a Goose brief unattended and keep resuming until the deliverable file exists.

Why: Kimi (via Goose) tends to end its turn with a progress note instead of a tool
call, which makes Goose exit before the task is done. This wrapper checks for the
deliverable after each run and, if it is missing, resumes the same session with a
nudge. It also forces Goose to use PowerShell instead of cmd.exe on Windows.

Usage (from the project root):
  .\tools\run_goose_brief.ps1 -Brief briefs\03_x.md -Session brief03 -Deliverable data\report_03.md
Optional: -MaxResumes 4 -MaxTurns 250 -Resume (continue an interrupted session instead of starting fresh)
#>
param(
    [Parameter(Mandatory = $true)] [string] $Brief,
    [Parameter(Mandatory = $true)] [string] $Session,
    [Parameter(Mandatory = $true)] [string] $Deliverable,
    [int] $MaxResumes = 4,
    [int] $MaxTurns = 250,
    [switch] $Resume   # skip the fresh run; resume the existing session straight away
)

$ErrorActionPreference = "Continue"
$goose = "C:\Users\sharo\Downloads\Goose-win32-x64\dist-windows\resources\bin\goose.exe"
if (-not (Test-Path $goose)) { Write-Error "goose.exe not found at $goose"; exit 2 }
if (-not (Test-Path $Brief)) { Write-Error "Brief not found: $Brief"; exit 2 }

# Make Goose run shell commands through PowerShell, not cmd.exe (cmd truncates at newlines).
$env:GOOSE_SHELL = "powershell"

$logDir = Join-Path (Get-Location) "scratch\goose_logs"
New-Item -ItemType Directory -Force $logDir | Out-Null
$stamp = Get-Date -Format "yyyyMMdd_HHmmss"

function Invoke-GooseRun([string] $label, [string[]] $gooseArgs) {
    $log = Join-Path $logDir ("{0}_{1}_{2}.log" -f $Session, $stamp, $label)
    Write-Host ("[{0}] {1}: goose {2}" -f (Get-Date -Format "HH:mm:ss"), $label, ($gooseArgs -join " "))
    & $goose @gooseArgs *> $log
    Write-Host ("[{0}] {1} finished (exit {2}); log: {3}" -f (Get-Date -Format "HH:mm:ss"), $label, $LASTEXITCODE, $log)
}

# Initial run from the brief file (skipped with -Resume, e.g. after an interrupted run).
if (-not $Resume) {
    Invoke-GooseRun "run0" @("run", "-i", $Brief, "-n", $Session, "--max-turns", "$MaxTurns", "--stats")
} else {
    Write-Host "Resume mode: skipping fresh run, resuming session '$Session'."
}

$resumes = 0
while (-not (Test-Path $Deliverable) -and $resumes -lt $MaxResumes) {
    $resumes++
    $nudge = "You ended your turn but the deliverable '$Deliverable' does not exist yet. " +
             "This is an unattended run; nobody will reply to you. Resume the task described in " +
             "'$Brief' immediately, re-launch any subagents you still need, and do not end your turn " +
             "again until '$Deliverable' has been written in full. (Automatic resume $resumes of $MaxResumes.)"
    Invoke-GooseRun ("resume" + $resumes) @("run", "-r", "-n", $Session, "-t", $nudge, "--max-turns", "$MaxTurns", "--stats")
}

if (Test-Path $Deliverable) {
    Write-Host ("DONE: deliverable exists after {0} resume(s): {1}" -f $resumes, $Deliverable)
    exit 0
} else {
    Write-Host ("GAVE UP: deliverable still missing after {0} resume(s). Check logs in {1}" -f $resumes, $logDir)
    exit 1
}
