# =============================================================================
#  Lab 4.5 — Guide Update Script
#  Run this once from PowerShell to update your local lab guide files.
#  Command: irm <raw-github-url-to-this-script> | iex
# =============================================================================

# ── CONFIGURE THIS before uploading ──────────────────────────────────────────
# Replace with the raw GitHub URL of the folder where you uploaded the 3 files.
# Example: https://raw.githubusercontent.com/YashKapoor/lab45-guides/main
$BASE_URL = "https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main"
# ─────────────────────────────────────────────────────────────────────────────

$FILES = @(
    "Workbook.ipynb",
    "LAB_GUIDE.html",
    "PARTICIPANT_GUIDE.html"
)

# Possible project folder locations on lab VMs
$CANDIDATES = @(
    "C:\Users\$env:USERNAME\Desktop\Project",
    "C:\Users\labuser\Desktop\Project",
    "C:\Users\Administrator\Desktop\Project"
)

# ── Find the project folder ───────────────────────────────────────────────────
$projectDir = $null
foreach ($path in $CANDIDATES) {
    if (Test-Path "$path\pom.xml") {
        $projectDir = $path
        break
    }
}

if (-not $projectDir) {
    Write-Host ""
    Write-Host "  ERROR: Could not find the Lab 4.5 project folder." -ForegroundColor Red
    Write-Host "  Expected to find pom.xml inside one of these locations:" -ForegroundColor Red
    foreach ($path in $CANDIDATES) {
        Write-Host "    - $path" -ForegroundColor DarkGray
    }
    Write-Host ""
    Write-Host "  Make sure your project folder is on the Desktop and try again." -ForegroundColor Yellow
    Write-Host ""
    exit 1
}

# ── Download and replace files ────────────────────────────────────────────────
Write-Host ""
Write-Host "  Lab 4.5 — Guide Update" -ForegroundColor Cyan
Write-Host "  Project folder : $projectDir" -ForegroundColor DarkGray
Write-Host "  Source         : $BASE_URL" -ForegroundColor DarkGray
Write-Host ""

$success = 0
$failed  = 0

foreach ($file in $FILES) {
    $url  = "$BASE_URL/$file"
    $dest = Join-Path $projectDir $file
    try {
        Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing -ErrorAction Stop
        Write-Host "  [OK]  $file" -ForegroundColor Green
        $success++
    } catch {
        Write-Host "  [FAIL] $file  — $($_.Exception.Message)" -ForegroundColor Red
        $failed++
    }
}

Write-Host ""
if ($failed -eq 0) {
    Write-Host "  All $success file(s) updated successfully." -ForegroundColor Green
    Write-Host "  Reload LAB_GUIDE.html and PARTICIPANT_GUIDE.html in your browser." -ForegroundColor Cyan
} else {
    Write-Host "  $success updated, $failed failed." -ForegroundColor Yellow
    Write-Host "  Check your internet connection and try again." -ForegroundColor Yellow
}
Write-Host ""
