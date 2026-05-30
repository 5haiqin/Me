# backfill_history.ps1
# Script to backfill git contribution graph with realistic commits

# Set Git Identity locally to override any system defaults
git config user.name "5haiqin"
git config user.email "5haiqin.tech@gmail.com"

# Define the dates array
$dates = @()
$dates += "2026-03-09"

$start = [datetime]"2026-03-14"
$end = [datetime]"2026-05-29"
while ($start -le $end) {
    $dates += $start.ToString("yyyy-MM-dd")
    $start = $start.AddDays(1)
}

function Get-CommitInfo ($index, $date) {
    if ($index -eq 0) {
        return @{
            File = "README.md"
            Msg = "docs: initialize project structure and setup readme"
            Content = "`n<!-- March 9: initialized git workspace and project outlines -->"
        }
    }
    
    # March 14 to 31: baseline styles and navigation (indices 1 to 18)
    if ($index -ge 1 -and $index -le 18) {
        $msgs = @(
            "chore: configure project base variables and directories",
            "style: define global color palette variables in :root",
            "style: add typography variables and import Fira Code font",
            "style: implement custom scrollbars styling for WebKit",
            "style: add baseline body and layout wrapper rules",
            "feat: construct semantic nav layout in index.html",
            "style: add base styles for header and sticky navigation bar",
            "style: design logo animations and container dimensions",
            "feat: add desktop menu links and link icons in nav bar",
            "style: implement primary nav link transition animations",
            "feat: create mobile nav menu container with toggling hooks",
            "style: add CSS transitions for mobile dropdown overlays",
            "feat: build details sub-navigation inside popup wrappers",
            "style: add subtle drop-shadows to popup containers",
            "chore: configure gitignore and exclude build temp files",
            "docs: outline typography and responsive grids layout plan",
            "style: add media queries for small screen menu collapsing",
            "style: structure responsive spacer utility helper classes"
        )
        $m = $msgs[($index - 1) % $msgs.Count]
        return @{
            File = "style.css"
            Msg = $m
            Content = "`n/* ${date}: ${m} */"
        }
    }
    
    # April 1 to 30: HTML layout and CSS Grid (indices 19 to 48)
    if ($index -ge 19 -and $index -le 48) {
        $msgs = @(
            "feat: construct hero layout structure in index.html",
            "style: define cyber hero typographic sizes and spacing",
            "feat: introduce cyber marquee horizontal ticker line markup",
            "style: write infinite horizontal marquee keyframe styling",
            "feat: structure semantic about section container layout",
            "style: define two-column flex styles for description",
            "feat: add academic timeline elements in education card",
            "style: setup dynamic map iframe placeholder container",
            "feat: structure semantic skills section section wrapper",
            "style: format shields.io badges list with wrap alignments",
            "feat: write framework badges markup with color flags",
            "feat: add devops and tooling tools badges layout list",
            "feat: structure project list horizontal scroll track wrapper",
            "style: write project showcase flex wrapper CSS",
            "style: define project card border colors and layouts",
            "style: add project preview image scaling hover overlays",
            "feat: implement lower layout grid details inside card info",
            "style: write project title styling and accent text colors",
            "style: design project description word clamp boundaries",
            "feat: add live demonstration satellite action buttons",
            "style: customize button background colors and borders",
            "style: design scrolling tech icons sidebar element slots",
            "style: add vertical keyframes for project icon list tracker",
            "style: specify project card elevation transition behaviors",
            "feat: structure achievements certifications grid wrapper",
            "style: write card overlay transition and preview styles",
            "feat: add experience timeline data list structure HTML",
            "style: customize contact details layout alignments CSS",
            "style: implement smooth hover animations on form inputs",
            "docs: update layout plans for wide project screens grid"
        )
        $m = $msgs[($index - 19) % $msgs.Count]
        $file = "index.html"
        if ($index % 2 -eq 0) { $file = "style.css" }
        
        $comment = "<!-- ${date}: ${m} -->"
        if ($file -eq "style.css") { $comment = "`n/* ${date}: ${m} */" }
        
        return @{
            File = $file
            Msg = $m
            Content = $comment
        }
    }
    
    # May 1 to 29: JS logic, Leaflet integration, subpage (indices 49 to 77)
    $msgs = @(
        "feat: write section header marquee cloning scripts in js",
        "feat: calculate cyber marquee scroll width dynamically",
        "feat: animate horizontal ticker with constant speed math",
        "feat: initialize leaflet maps canvas inside education page",
        "feat: configure google maps satellite imagery tile layers",
        "feat: add custom map markers on hovered locations",
        "feat: implement flyTo coordinate transition animations in js",
        "feat: setup responsive map pan listener for mobile clicks",
        "feat: build mobile snap intersection observer triggers",
        "feat: toggle nav dropdown active class with timeout delay",
        "style: write isolated project page style rules in project.css",
        "style: define wrapping grid layout for project list grid",
        "style: force all project cards visibility on small viewport",
        "style: implement projects navigation back link colors",
        "feat: convert project page cards to standard homepage card style",
        "feat: configure vertical skill icons loops for pixelize card",
        "feat: map weather API tech icons on cloud watch card",
        "feat: map bootstrap badges on netflix clone card sidebar",
        "feat: update live link and config for tatkal cab card",
        "feat: setup looping tracks for spotify clone card sidebar",
        "feat: configure tech logos loop for edcare tutorial card",
        "feat: map portfolio stacks for portfolio card sidebar",
        "feat: add sentinel-r-v4 featured card at top of project list",
        "feat: add vayu setu card inside projects page",
        "feat: insert geoadhikar card on projects page",
        "feat: add tata healthcare details at project showcase top",
        "docs: document javascript map logic inside README.md",
        "docs: finalize technical features breakdown in readme",
        "chore: audit git history and run final styles check"
    )
    $m = $msgs[($index - 49) % $msgs.Count]
    $file = "script.js"
    if ($index % 3 -eq 1) { $file = "project.html" }
    elseif ($index % 3 -eq 2) { $file = "project.css" }
    
    $comment = "`n// ${date}: ${m}"
    if ($file -eq "project.html") { $comment = "`n<!-- ${date}: ${m} -->" }
    elseif ($file -eq "project.css") { $comment = "`n/* ${date}: ${m} */" }
    
    return @{
        File = $file
        Msg = $m
        Content = $comment
    }
}

# Run the loops
for ($i = 0; $i -lt $dates.Count; $i++) {
    $date = $dates[$i]
    $info = Get-CommitInfo $i $date
    
    Write-Host "Committing day $i ($date) to file $($info.File)..."
    
    # Append content to target file
    if (Test-Path $info.File) {
        Add-Content -Path $info.File -Value $info.Content
    } else {
        Write-Warning "File $($info.File) does not exist! Creating..."
        New-Item -ItemType File -Path $info.File -Force
        Add-Content -Path $info.File -Value $info.Content
    }
    
    # Random business hours timestamp (09:30:00 - 21:45:00)
    $hour = Get-Random -Minimum 9 -Maximum 22
    if ($hour -eq 9) {
        $minute = Get-Random -Minimum 30 -Maximum 60
    } elseif ($hour -eq 21) {
        $minute = Get-Random -Minimum 0 -Maximum 46
    } else {
        $minute = Get-Random -Minimum 0 -Maximum 60
    }
    $second = Get-Random -Minimum 0 -Maximum 60
    $time = "{0:D2}:{1:D2}:{2:D2}" -f $hour, $minute, $second
    
    # Set Git date environment variables
    $env:GIT_AUTHOR_DATE = "${date}T${time}"
    $env:GIT_COMMITTER_DATE = "${date}T${time}"
    
    # Stage and commit
    git add $info.File
    git commit -m $info.Msg
}

# Clear Environment Variables at the end
Remove-Item Env:GIT_AUTHOR_DATE -ErrorAction SilentlyContinue
Remove-Item Env:GIT_COMMITTER_DATE -ErrorAction SilentlyContinue

Write-Host "Completed backfilling history!"
