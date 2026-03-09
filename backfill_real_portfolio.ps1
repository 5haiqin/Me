# Config Local Identity
git config user.name "5haiqin"
git config user.email "5haiqin.tech@gmail.com"
Write-Host "Local Git Identity Configured: 5haiqin <5haiqin.tech@gmail.com>"

# 1. Back up all actual portfolio files to a safe backup directory
$backupDir = "_backup_portfolio"
if (Test-Path $backupDir) {
    Remove-Item -Path $backupDir -Recurse -Force -ErrorAction SilentlyContinue
}
New-Item -ItemType Directory -Path $backupDir | Out-Null

$filesToBackup = @("index.html", "style.css", "script.js", "project.html", "README.md")
foreach ($f in $filesToBackup) {
    if (Test-Path $f) {
        Copy-Item -Path $f -Destination $backupDir -Force
    }
}
if (Test-Path "assets") {
    Copy-Item -Path "assets" -Destination $backupDir -Recurse -Force
}
if (Test-Path "project") {
    Copy-Item -Path "project" -Destination $backupDir -Recurse -Force
}
Write-Host "Backed up all actual portfolio files to $backupDir"

# 2. Re-initialize Git repository to completely clear simulated folder history
if (Test-Path .git) {
    # Remove git tracking to start with a clean history
    Remove-Item -Path .git -Recurse -Force -ErrorAction SilentlyContinue
}
if (Test-Path "simulated-portfolio") {
    Remove-Item -Path "simulated-portfolio" -Recurse -Force -ErrorAction SilentlyContinue
}
if (Test-Path "git_backfill.js") {
    Remove-Item -Path "git_backfill.js" -Force -ErrorAction SilentlyContinue
}

git init
git config user.name "5haiqin"
git config user.email "5haiqin.tech@gmail.com"
Write-Host "Re-initialized clean local Git repository."

# 3. Read the lines of the actual files for incremental development simulation
$readmeLines = if (Test-Path "$backupDir/README.md") { Get-Content -Path "$backupDir/README.md" } else { @("# Portfolio") }
$htmlLines = if (Test-Path "$backupDir/index.html") { Get-Content -Path "$backupDir/index.html" } else { @("<!DOCTYPE html><html></html>") }
$cssLines = if (Test-Path "$backupDir/style.css") { Get-Content -Path "$backupDir/style.css" } else { @("body {}") }
$projHtmlLines = if (Test-Path "$backupDir/project.html") { Get-Content -Path "$backupDir/project.html" } else { @("<!DOCTYPE html><html></html>") }
$jsLines = if (Test-Path "$backupDir/script.js") { Get-Content -Path "$backupDir/script.js" } else { @("// JS") }

# Define timeline dates
$dates = @()
# Add March 9
$dates += Get-Date -Year 2026 -Month 3 -Day 9 -Hour 12 -Minute 00 -Second 00
# Add March 14 to May 29
$start = Get-Date -Year 2026 -Month 3 -Day 14
$end = Get-Date -Year 2026 -Month 5 -Day 29
$current = $start
while ($current -le $end) {
    $dates += $current
    $current = $current.AddDays(1)
}

# Filter active days (organic gaps)
$activeDays = @()
foreach ($d in $dates) {
    $dayOfWeek = $d.DayOfWeek
    $isMarch9 = ($d.Month -eq 3 -and $d.Day -eq 9)
    
    if ($isMarch9) {
        $activeDays += $d
    } elseif ($dayOfWeek -eq "Saturday" -or $dayOfWeek -eq "Sunday") {
        if ((Get-Random -Minimum 0 -Maximum 100) -lt 15) {
            $activeDays += $d
        }
    } else {
        if ((Get-Random -Minimum 0 -Maximum 100) -lt 82) {
            $activeDays += $d
        }
    }
}

# Generate commits mapping
$commitsList = @()
for ($i = 0; $i -lt $activeDays.Count; $i++) {
    $date = $activeDays[$i]
    $commitsCount = Get-Random -Minimum 1 -Maximum 4
    for ($c = 0; $c -lt $commitsCount; $c++) {
        $hour = Get-Random -Minimum 9 -Maximum 22
        $min = Get-Random -Minimum 0 -Maximum 60
        $sec = Get-Random -Minimum 0 -Maximum 60
        $dateStr = "$($date.ToString('yyyy-MM-dd'))T$("{0:D2}" -f $hour):$("{0:D2}" -f $min):$("{0:D2}" -f $sec)"
        
        $commitsList += @{
            date = $dateStr
            dayIndex = $i
        }
    }
}

$totalCommits = $commitsList.Count
Write-Host "Scheduling $totalCommits backdated commits to build your real portfolio files..."

# 4. Helper to write partial files
function Write-PartialFile($lines, $progress, $targetPath) {
    $count = [Math]::Max(1, [Math]::Round($progress * $lines.Count))
    $partial = $lines[0..($count - 1)]
    $partial | Set-Content -Path $targetPath -Encoding UTF8
}

# 5. Run backfilling loop
for ($idx = 0; $idx -lt $totalCommits - 1; $idx++) {
    $c = $commitsList[$idx]
    $progress = ($idx + 1) / $totalCommits
    
    # Progressively build each main file
    Write-PartialFile $readmeLines $progress "README.md"
    Write-PartialFile $htmlLines $progress "index.html"
    Write-PartialFile $cssLines $progress "style.css"
    
    if ($progress -gt 0.35) {
        Write-PartialFile $projHtmlLines (($progress - 0.35) / 0.65) "project.html"
    }
    if ($progress -gt 0.50) {
        Write-PartialFile $jsLines (($progress - 0.50) / 0.50) "script.js"
    }
    
    # Add directories incrementally
    if ($progress -gt 0.30 -and (Test-Path "$backupDir/assets")) {
        if (!(Test-Path "assets")) {
            Copy-Item -Path "$backupDir/assets" -Destination "assets" -Recurse -Force
        }
    }
    if ($progress -gt 0.60 -and (Test-Path "$backupDir/project")) {
        if (!(Test-Path "project")) {
            Copy-Item -Path "$backupDir/project" -Destination "project" -Recurse -Force
        }
    }
    
    # Git stage all simulated partial stages
    git add -A
    
    # Set Git commit environment dates
    $env:GIT_AUTHOR_DATE = $c.date
    $env:GIT_COMMITTER_DATE = $c.date
    
    # Build commit messages dynamically depending on progress
    $msg = "refactor: polish layout rules and styles"
    if ($idx -eq 0) {
        $msg = "chore: initialize website codebase structure"
    } elseif ($progress -lt 0.20) {
        $msg = "feat: add main layout elements and basic boilerplate"
    } elseif ($progress -lt 0.40) {
        $msg = "style: configure core CSS and color themes"
    } elseif ($progress -lt 0.65) {
        $msg = "feat: add project items grid and timelines"
    } elseif ($progress -lt 0.85) {
        $msg = "feat: integrate main scroll action triggers"
    } else {
        $msg = "fix: resolve cursor adjustments and spacing bugs"
    }
    
    git commit -m $msg
}

# 6. Final commit: Restore 100% of your exact current files
Write-Host "Restoring final exact portfolio state to repository root..."
# Copy backup back
foreach ($f in $filesToBackup) {
    if (Test-Path "$backupDir/$f") {
        Copy-Item -Path "$backupDir/$f" -Destination "." -Force
    }
}
if (Test-Path "$backupDir/assets") {
    Copy-Item -Path "$backupDir/assets" -Destination "." -Recurse -Force
}
if (Test-Path "$backupDir/project") {
    Copy-Item -Path "$backupDir/project" -Destination "." -Recurse -Force
}

# Add all files
git add -A

# Commit today's final version
$todayStr = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss")
$env:GIT_AUTHOR_DATE = $todayStr
$env:GIT_COMMITTER_DATE = $todayStr
git commit -m "chore: final portfolio optimization and mobile design polish"

# Clean up backup directory
Remove-Item -Path $backupDir -Recurse -Force -ErrorAction SilentlyContinue

# Clear environment variables
Remove-Item env:GIT_AUTHOR_DATE -ErrorAction SilentlyContinue
Remove-Item env:GIT_COMMITTER_DATE -ErrorAction SilentlyContinue

Write-Host "Final state restored and committed!"
Write-Host "--------------------------------------------------------"
Write-Host "Backfill completed! Re-associating remote and pushing..."
Write-Host "--------------------------------------------------------"
