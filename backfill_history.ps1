# Config Local Identity
git config user.name "5haiqin"
git config user.email "5haiqin.tech@gmail.com"
Write-Host "Local Git Identity Configured: 5haiqin <5haiqin.tech@gmail.com>"

# Check if git repo exists
if (!(Test-Path .git)) {
    Write-Host "Initializing local git repository..."
    git init
}

# Create simulated folder
$simFolder = "simulated-portfolio"
if (!(Test-Path $simFolder)) {
    New-Item -ItemType Directory -Path $simFolder | Out-Null
}

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
        # 15% chance of weekend activity
        if ((Get-Random -Minimum 0 -Maximum 100) -lt 15) {
            $activeDays += $d
        }
    } else {
        # 82% chance of weekday activity
        if ((Get-Random -Minimum 0 -Maximum 100) -lt 82) {
            $activeDays += $d
        }
    }
}

Write-Host "Total scope: $($dates.Count) days. Active days scheduled: $($activeDays.Count)."

# Define granular project files and commit messages corresponding to different progress milestones
$phaseTasks = @(
    # Phase 0: Setup & Config (Progress < 0.15)
    @{ phase = 0; file = "$simFolder/package.json"; msg = "chore: initialize project with react and vite dependencies"; content = '{
  "name": "shaiqin-portfolio-react",
  "private": true,
  "version": "1.0.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build"
  },
  "dependencies": {
    "react": "^18.3.1",
    "react-dom": "^18.3.1",
    "gsap": "^3.12.5",
    "tailwindcss": "^3.4.1"
  }
}' },
    @{ phase = 0; file = "$simFolder/vite.config.js"; msg = "feat: configure vite and react entrypoint plugins"; content = 'import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
export default defineConfig({
  plugins: [react()],
  server: { port: 3000 }
});' },
    @{ phase = 0; file = "$simFolder/tailwind.config.js"; msg = "feat: add tailwindcss style guide configuration"; content = 'export default {
  content: ["./index.html", "./src/**/*.{js,ts,jsx,tsx}"],
  theme: { extend: {} },
  plugins: []
};' },
    @{ phase = 0; file = "$simFolder/README.md"; msg = "docs: initialize project layout plan and documentation"; content = '# Shaiqin Portfolio
Interactive React + Tailwind + GSAP Canvas.' },

    # Phase 1: Layout & Context (0.15 <= Progress < 0.40)
    @{ phase = 1; file = "$simFolder/src/index.css"; msg = "style: add custom tailwind directives and baseline fonts"; content = '@tailwind base;
@tailwind components;
@tailwind utilities;
body {
  background-color: #030303;
  color: #fff;
}' },
    @{ phase = 1; file = "$simFolder/src/main.jsx"; msg = "feat: assemble standard vite react entry DOM root"; content = 'import React from "react";
import ReactDOM from "react-dom/client";
import App from "./App.jsx";
import "./index.css";
ReactDOM.createRoot(document.getElementById("root")).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);' },
    @{ phase = 1; file = "$simFolder/src/context/ThemeContext.jsx"; msg = "feat: implement modular light/dark mode context provider"; content = 'import React, { createContext, useContext, useState } from "react";
const ThemeContext = createContext();
export const ThemeProvider = ({ children }) => {
  const [darkMode, setDarkMode] = useState(true);
  return (
    <ThemeContext.Provider value={{ darkMode, setDarkMode }}>
      {children}
    </ThemeContext.Provider>
  );
};
export const useTheme = () => useContext(ThemeContext);' },
    @{ phase = 1; file = "$simFolder/src/components/Navbar.jsx"; msg = "feat: design custom floating navbar component with routes"; content = 'import React from "react";
export default function Navbar() {
  return (
    <nav className="fixed w-full z-50 bg-[#030303]/80 backdrop-blur-md px-6 py-4 flex justify-between">
      <div className="font-mono">HELLO_WORLD</div>
    </nav>
  );
}' },

    # Phase 2: Core Components (0.40 <= Progress < 0.70)
    @{ phase = 2; file = "$simFolder/src/data/projectsData.js"; msg = "chore: populate responsive project metadata arrays"; content = 'export const projects = [
  { id: 1, title: "Pixelize Agency", desc: "A creative web app.", tags: ["React", "Tailwind"] }
];' },
    @{ phase = 2; file = "$simFolder/src/components/Hero.jsx"; msg = "feat: construct responsive hero layout structure"; content = 'import React from "react";
export default function Hero() {
  return (
    <section className="min-h-screen flex justify-center items-center">
      <h1 className="text-6xl font-black">Design Dimensions</h1>
    </section>
  );
}' },
    @{ phase = 2; file = "$simFolder/src/components/Projects.jsx"; msg = "feat: implement project showcases masonry card layout"; content = 'import React from "react";
import { projects } from "../data/projectsData";
export default function Projects() {
  return (
    <section id="projects" className="py-20">
      {projects.map(p => <div key={p.id}>{p.title}</div>)}
    </section>
  );
}' },
    @{ phase = 2; file = "$simFolder/src/components/Experience.jsx"; msg = "feat: construct academic progress vertical timeline nodes"; content = 'import React from "react";
export default function Experience() {
  return <section id="experience">Academic Timeline</section>;
}' },
    @{ phase = 2; file = "$simFolder/src/components/Contact.jsx"; msg = "feat: design feedback validation structures in contact form"; content = 'import React from "react";
export default function Contact() {
  return <section id="contact">Contact Form</section>;
}' },
    @{ phase = 2; file = "$simFolder/src/App.jsx"; msg = "feat: compose full app layout with core page wrappers"; content = 'import React from "react";
import Navbar from "./components/Navbar";
import Hero from "./components/Hero";
import Projects from "./components/Projects";
import Experience from "./components/Experience";
import Contact from "./components/Contact";
export default function App() {
  return (
    <div>
      <Navbar />
      <Hero />
      <Projects />
      <Experience />
      <Contact />
    </div>
  );
}' },

    # Phase 3: GSAP Animations & Motion (0.70 <= Progress < 0.90)
    @{ phase = 3; file = "$simFolder/src/hooks/useGsapTimeline.js"; msg = "feat: craft gsap timeline wrapper with auto-revert contexts"; content = 'import { useEffect, useRef } from "react";
import gsap from "gsap";
export default function useGsapTimeline(callback) {
  const el = useRef();
  useEffect(() => {
    const ctx = gsap.context(callback, el);
    return () => ctx.revert();
  }, [callback]);
  return el;
}' },
    @{ phase = 3; file = "$simFolder/src/components/CustomCursor.jsx"; msg = "feat: build custom tracking cursor container"; content = 'import React, { useEffect, useRef } from "react";
import gsap from "gsap";
export default function CustomCursor() {
  const cursor = useRef();
  useEffect(() => {
    const onMove = (e) => {
      gsap.to(cursor.current, { x: e.clientX, y: e.clientY, duration: 0.1 });
    };
    window.addEventListener("mousemove", onMove);
    return () => window.removeEventListener("mousemove", onMove);
  }, []);
  return <div ref={cursor} className="fixed w-6 h-6 border-2 border-yellow-400 rounded-full pointer-events-none z-50 transform -translate-x-1/2 -translate-y-1/2 bg-yellow-400/10" />;
}' },
    @{ phase = 3; file = "$simFolder/src/App.jsx"; msg = "feat: integrate custom cursor tracker inside top layout"; content = 'import React from "react";
import Navbar from "./components/Navbar";
import Hero from "./components/Hero";
import Projects from "./components/Projects";
import Experience from "./components/Experience";
import Contact from "./components/Contact";
import CustomCursor from "./components/CustomCursor";
export default function App() {
  return (
    <div>
      <CustomCursor />
      <Navbar />
      <Hero />
      <Projects />
      <Experience />
      <Contact />
    </div>
  );
}' },

    # Phase 4: Polish & Documentation (0.90 <= Progress <= 1.0)
    @{ phase = 4; file = "$simFolder/src/components/CustomCursor.jsx"; msg = "fix: resolve cursor jitter and lag using xPercent offsets"; content = 'import React, { useEffect, useRef } from "react";
import gsap from "gsap";
export default function CustomCursor() {
  const cursor = useRef();
  useEffect(() => {
    const node = cursor.current;
    gsap.set(node, { xPercent: -50, yPercent: -50 });
    const onMove = (e) => {
      gsap.to(node, { x: e.clientX, y: e.clientY, duration: 0.08, ease: "power3.out" });
    };
    window.addEventListener("mousemove", onMove);
    return () => window.removeEventListener("mousemove", onMove);
  }, []);
  return <div ref={cursor} className="fixed w-6 h-6 border-2 border-yellow-400 rounded-full pointer-events-none bg-yellow-400/10" />;
}' },
    @{ phase = 4; file = "$simFolder/README.md"; msg = "docs: polish markdown documentation with features and setup guides"; content = '# Shaiqin Portfolio
Interactive React + Tailwind + GSAP Canvas.

## Features
- Advanced GSAP motion timelines and custom easing
- Magnetic cursor tracking follower' }
)

# Iterate through active days to generate commits
$commitIndex = 0
for ($i = 0; $i -lt $activeDays.Count; $i++) {
    $date = $activeDays[$i]
    $progress = $i / ($activeDays.Count - 1)
    
    # Determine the phase index (0 to 4)
    $phase = 0
    if ($progress -lt 0.15) { $phase = 0 }
    elseif ($progress -lt 0.40) { $phase = 1 }
    elseif ($progress -lt 0.70) { $phase = 2 }
    elseif ($progress -lt 0.90) { $phase = 3 }
    else { $phase = 4 }
    
    # Select tasks in matching phase
    $tasksInPhase = $phaseTasks | Where-Object { $_.phase -eq $phase }
    
    # Determine commit frequency for this day (1 to 4 commits)
    $commitsCount = Get-Random -Minimum 1 -Maximum 5
    
    for ($c = 0; $c -lt $commitsCount; $c++) {
        $task = $tasksInPhase[($commitIndex + $c) % $tasksInPhase.Count]
        
        # Format timestamps organically between 09:00:00 and 22:00:00
        $hour = Get-Random -Minimum 9 -Maximum 22
        $min = Get-Random -Minimum 0 -Maximum 60
        $sec = Get-Random -Minimum 0 -Maximum 60
        
        $dateStr = "$($date.ToString('yyyy-MM-dd'))T$("{0:D2}" -f $hour):$("{0:D2}" -f $min):$("{0:D2}" -f $sec)"
        
        # Modify target file with unique tag comment so Git registers differences
        $filePath = $task.file
        $dir = Split-Path -Path $filePath
        if (!(Test-Path $dir)) {
            New-Item -ItemType Directory -Path $dir -Force | Out-Null
        }
        
        $uniqueComment = "`n// Commit marker: $commitIndex | Date: $dateStr"
        $fileContent = $task.content + $uniqueComment
        Set-Content -Path $filePath -Value $fileContent -Encoding UTF8
        
        # Stage only this specific file
        git add $filePath
        
        # Build backdated commit
        $env:GIT_AUTHOR_DATE = $dateStr
        $env:GIT_COMMITTER_DATE = $dateStr
        
        # Apply descriptive commit messages
        $msg = $task.msg
        if ($c -gt 0) {
            # Alternate helper logs for multiple commits on same day
            $altMsgs = @(
                "refactor: polish CSS formatting inside $(Split-Path $filePath -Leaf)",
                "style: optimize responsive design alignments inside $(Split-Path $filePath -Leaf)",
                "perf: stream rendering timelines in $(Split-Path $filePath -Leaf)",
                "docs: add descriptions inside $(Split-Path $filePath -Leaf)"
            )
            $msg = $altMsgs | Get-Random
        }
        
        git commit -m $msg
        Write-Host "Committed: $dateStr -> $msg"
        
        $commitIndex++
    }
}

# Clear backdating environment variables
Remove-Item env:GIT_AUTHOR_DATE -ErrorAction SilentlyContinue
Remove-Item env:GIT_COMMITTER_DATE -ErrorAction SilentlyContinue
Write-Host "Backdating variables cleared successfully."
Write-Host "--------------------------------------------------------"
Write-Host "Backfill completed! run the verification command next:"
Write-Host "git log --graph --oneline --decorate --all"
Write-Host "--------------------------------------------------------"
