# Renders diagrams/*.mmd to assets/*.svg with pinned mermaid-cli. Windows.
# Same contract as tools/render-mermaid.sh. Run from the repo root.
# Usage: powershell -File tools/render-mermaid.ps1 [-Atlas docs/atlas]
# Needs: node 18+ (npx), network once for the mermaid-cli download and its browser.
# Without node, falls back to headless Edge plus a vendored mermaid.min.js.
param(
  [string]$Atlas = "docs/atlas",
  [string]$Version = "12.0.0",
  [string]$Config = "tools/mermaid-config.json",
  [string]$MermaidJs = "third_party/mermaid.min.js",
  [string]$Edge = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
)
$ErrorActionPreference = "Stop"
$diagDir = Join-Path $Atlas "diagrams"
$outDir = Join-Path $Atlas "assets"
$files = Get-ChildItem -Path $diagDir -Filter *.mmd -ErrorAction Stop
if ($files.Count -eq 0) { throw "no .mmd files in $diagDir" }
$useNpx = $null -ne (Get-Command npx -ErrorAction SilentlyContinue)
foreach ($f in $files) {
  $svg = Join-Path $outDir ($f.BaseName + ".svg")
  if ($useNpx) {
    $args = @("-y", "@mermaid-js/mermaid-cli@$Version", "-i", $f.FullName, "-o", $svg, "--scale", "2")
    if (Test-Path $Config) { $args += @("--configFile", $Config) }
    & npx @args
  } else {
    if (!(Test-Path $MermaidJs)) { throw "no npx and no vendored $MermaidJs. Install node 18+." }
    if (!(Test-Path $Edge)) {
      $cand = Get-Command msedge -ErrorAction SilentlyContinue
      if ($cand) { $Edge = $cand.Source } else { throw "Edge not found. Install Edge or node." }
    }
    $src = (Get-Content $f.FullName -Raw) -replace '</', '<\/'
    $tmp = Join-Path $outDir ($f.BaseName + ".html")
    "<!doctype html><meta charset=`"utf-8`"><body><pre class=`"mermaid`">$src</pre><script src=`"file:///$($MermaidJs -replace '\\','/')`"></script><script>mermaid.initialize({startOnLoad:true, theme:'neutral'});</script>" | Out-File -Encoding utf8 $tmp
    $png = Join-Path $outDir ($f.BaseName + ".png")
    & $Edge --headless --disable-gpu --screenshot="$png" --window-size=1600,1000 "file:///$($tmp -replace '\\','/')" | Out-Null
    Write-Output "$($f.Name) -> $png (edge fallback)"
    continue
  }
  Write-Output "$($f.Name) -> $svg"
}
Write-Output "done: $($files.Count) renders in $outDir"
