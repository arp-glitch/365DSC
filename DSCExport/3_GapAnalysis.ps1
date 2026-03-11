#Requires -Version 5.1
<#
.SYNOPSIS
    Compares a Microsoft365DSC tenant export against the NCSC Golden Blueprint
    and generates an HTML gap-analysis report with CSV export.

.DESCRIPTION
    This script:
      1. Parses the exported DSC configuration (.ps1) from Step 2.
      2. Parses the NCSC Golden Blueprint (.ps1).
      3. Runs a property-level comparison between the exported state and the
         blueprint to identify drift / gaps.
      4. Generates a branded HTML report with colour-coded findings.
      5. Exports findings as CSV for programmatic consumption.

    This is Step 3 of the 3-step NCSC assessment process:
      Step 1: Setup Service Principal (1_Setup-DSCServicePrincipal.ps1)
      Step 2: Export tenant configuration (2_DSC-Export.ps1)
      Step 3: Gap analysis against NCSC blueprint (this script)

.PARAMETER ExportPath
    Path to the exported DSC configuration .ps1 file from Step 2.

.PARAMETER BlueprintPath
    Path to the NCSC Golden Blueprint .ps1 file.
    Defaults to ..\Blueprints\NCSC_M365_Baseline.ps1

.PARAMETER ReportDir
    Output directory for the HTML and CSV reports.
    Defaults to ..\Reports

.PARAMETER CompanyName
    Company name to display in the report header.

.PARAMETER Author
    Author name to display in the report header.

.EXAMPLE
    .\3_GapAnalysis.ps1 -ExportPath .\ar-net.biz_min_export.ps1

.EXAMPLE
    .\3_GapAnalysis.ps1 -ExportPath .\ar-net.biz_min_export.ps1 -CompanyName "Ar-Net" -Author "Andre"

.NOTES
    Author  : M365 NCSC Audit Pipeline
    Version : 1.0.0
    Date    : 2026-03-10
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$ExportPath,

    [string]$BlueprintPath = (Join-Path $PSScriptRoot '..\Blueprints\NCSC_M365_Baseline.ps1'),

    [string]$ReportDir = (Join-Path $PSScriptRoot '..\Reports'),

    [string]$CompanyName = '',

    [string]$Author = ''
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# ─── Helpers ────────────────────────────────────────────────────────────────

function Write-Step { param([string]$M) Write-Host "`n► $M" -ForegroundColor Cyan }
function Write-Ok   { param([string]$M) Write-Host "  ✔ $M" -ForegroundColor Green }
function Write-Warn { param([string]$M) Write-Host "  ⚠ $M" -ForegroundColor Yellow }
function Write-Err  { param([string]$M) Write-Host "  ✘ $M" -ForegroundColor Red }

# ─── 0. Validate Inputs ────────────────────────────────────────────────────

Write-Step 'Validating inputs'

$ExportPath = (Resolve-Path $ExportPath -ErrorAction Stop).Path
if (-not (Test-Path $ExportPath)) { throw "Export file not found: $ExportPath" }
Write-Ok "Export file: $ExportPath"

if (-not (Test-Path $BlueprintPath)) { throw "Blueprint not found: $BlueprintPath" }
Write-Ok "Blueprint:   $BlueprintPath"

if (-not (Test-Path $ReportDir)) {
    New-Item -ItemType Directory -Path $ReportDir -Force | Out-Null
}

$Timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$ReportFile = Join-Path $ReportDir "NCSC_GapReport_$Timestamp.html"
$CsvFile    = Join-Path $ReportDir "NCSC_GapReport_$Timestamp.csv"

# Try to extract tenant name from export filename or content for the report header
if ([string]::IsNullOrWhiteSpace($CompanyName)) {
    $CompanyName = [System.IO.Path]::GetFileNameWithoutExtension($ExportPath) -replace '_min_export$|_export$', ''
}

# ─── 1. Parse DSC Resource Blocks ──────────────────────────────────────────

Write-Step 'Parsing exported state and golden blueprint'

function Get-DscResourceBlocks {
    <#
    .SYNOPSIS
        Extracts M365DSC resource instances from a .ps1 configuration file,
        returning each as a hashtable of property = value.
    #>
    param([string]$FilePath)

    $Ast = [System.Management.Automation.Language.Parser]::ParseFile(
        $FilePath, [ref]$null, [ref]$null
    )

    $Resources = @()

    $AllCommandAsts = $Ast.FindAll({
            param($n)
            $n.GetType().Name -eq 'DynamicKeywordStatementAst'
        }, $true)

    foreach ($Cmd in $AllCommandAsts) {
        $Elements = $Cmd.CommandElements
        if ($Elements.Count -ge 3) {
            $ResourceType = $Elements[0].Extent.Text
            if ($ResourceType -match '^(AAD|EXO|SPO|SC|Intune|Teams|O365)') {
                $ResourceName = $Elements[1].Extent.Text -replace "['\`"]", ''

                $HashtableAst = $Elements | Where-Object {
                    $_ -is [System.Management.Automation.Language.HashtableAst]
                } | Select-Object -First 1

                $Props = @{}
                if ($HashtableAst) {
                    foreach ($KvPair in $HashtableAst.KeyValuePairs) {
                        $Key = $KvPair.Item1.Extent.Text
                        $Value = $KvPair.Item2.Extent.Text -replace '^\$', ''
                        $Value = $Value -replace '^[''"]' -replace '[''"]$'
                        $Props[$Key] = $Value
                    }
                }

                $Resources += [PSCustomObject]@{
                    ResourceType = $ResourceType
                    ResourceName = $ResourceName
                    Properties   = $Props
                    Identity     = if ($Props.ContainsKey('DisplayName')) { $Props['DisplayName'] }
                                   elseif ($Props.ContainsKey('Identity')) { $Props['Identity'] }
                                   elseif ($Props.ContainsKey('IsSingleInstance')) { "$ResourceType (Singleton)" }
                                   else { $ResourceName }
                }
            }
        }
    }

    return $Resources
}

$CurrentResources   = @(Get-DscResourceBlocks -FilePath $ExportPath)
$BlueprintResources = @(Get-DscResourceBlocks -FilePath $BlueprintPath)

Write-Ok "Current state:  $($CurrentResources.Count) resource(s) parsed"
Write-Ok "Blueprint:      $($BlueprintResources.Count) resource(s) defined"

# Check which blueprint resource types are missing from the export
$ExportedResourceTypes = @($CurrentResources | ForEach-Object { $_.ResourceType } | Sort-Object -Unique)
$MissingWorkloads = [System.Collections.Generic.List[string]]::new()

foreach ($BpRes in $BlueprintResources) {
    if ($BpRes.ResourceType -notin $ExportedResourceTypes) {
        if ($BpRes.ResourceType -notin $MissingWorkloads) {
            $MissingWorkloads.Add($BpRes.ResourceType)
        }
    }
}

if ($MissingWorkloads.Count -gt 0) {
    Write-Warn "The following blueprint resource types are MISSING from the export:"
    foreach ($Mw in $MissingWorkloads) {
        Write-Host "    - $Mw" -ForegroundColor Yellow
    }
}

# ─── Normalisation helper (reused in matching and comparison) ───────────────

function Get-NormalisedValue {
    param([string]$Value)
    $n = ($Value -replace '^[''"]' -replace '[''"]$' -replace '\s+', ' ').Trim().ToLower()
    $n = $n -replace '[''"]', ''
    $n = $n -replace ',\s*', ','
    $n = $n -replace '^@\(([^,)]+)\)$', '$1'
    $n = $n -replace '^\$?true$', 'true'
    $n = $n -replace '^\$?false$', 'false'
    return $n
}

# ─── 2. Match & Compare: Blueprint vs Current State ─────────────────────────
#
# Matching strategy:
#   1. Try exact match on ResourceType + Identity/DisplayName.
#   2. If no exact match, find the best content match among same-type
#      resources by scoring how many blueprint property values overlap.
#      This handles tenants where policy names differ from the blueprint
#      (e.g. "Require MFA for All Users" vs "[NCSC] CA-001: Require MFA
#      for All Users") but the functional configuration is equivalent.
#   3. Only declare MISSING if no candidate scores above a minimum threshold.

Write-Step 'Matching tenant resources to blueprint (content-aware)'

# Properties that are identity/auth metadata — skip for matching and comparison
$PropsToSkip = @(
    'ApplicationId', 'TenantId', 'CertificateThumbprint',
    'Credential', 'Ensure', 'IsSingleInstance', 'OdataType',
    'Id', 'ResourceName'
)

# Properties that are just names/labels — skip for content scoring but keep for reporting
$NameProps = @('DisplayName', 'Identity')

function Get-ContentScore {
    <#
    .SYNOPSIS
        Scores how well a candidate resource matches a blueprint resource
        by counting matching property values (ignoring auth/name props).
    #>
    param(
        [PSCustomObject]$Blueprint,
        [PSCustomObject]$Candidate
    )

    $Matchable = 0
    $Matched   = 0

    foreach ($Prop in $Blueprint.Properties.GetEnumerator()) {
        if ($Prop.Key -in $PropsToSkip) { continue }
        if ($Prop.Key -in $NameProps)   { continue }

        $Matchable++
        $BpNorm = Get-NormalisedValue $Prop.Value

        if ($Candidate.Properties.ContainsKey($Prop.Key)) {
            $CandNorm = Get-NormalisedValue $Candidate.Properties[$Prop.Key]
            if ($BpNorm -eq $CandNorm) { $Matched++ }
        }
    }

    if ($Matchable -eq 0) { return 0 }
    return [math]::Round($Matched / $Matchable * 100, 1)
}

# Track which export resources have been claimed so we don't double-match
$ClaimedExportResources = @{}

# Build the match map: blueprint resource → best tenant resource
$MatchMap = @{}

foreach ($BpRes in $BlueprintResources) {
    # 1. Exact name match
    $ExactMatch = $CurrentResources | Where-Object {
        $_.ResourceType -eq $BpRes.ResourceType -and
        $_.Identity -eq $BpRes.Identity -and
        -not $ClaimedExportResources.ContainsKey("$($_.ResourceType)|$($_.Identity)")
    } | Select-Object -First 1

    if ($ExactMatch) {
        $Key = "$($ExactMatch.ResourceType)|$($ExactMatch.Identity)"
        $ClaimedExportResources[$Key] = $true
        $MatchMap[$BpRes] = @{ Resource = $ExactMatch; Score = 100; MatchType = 'Exact' }
        continue
    }

    # 2. Content-based scoring across all same-type resources
    $Candidates = @($CurrentResources | Where-Object {
        $_.ResourceType -eq $BpRes.ResourceType -and
        -not $ClaimedExportResources.ContainsKey("$($_.ResourceType)|$($_.Identity)")
    })

    if ($Candidates.Count -eq 0) {
        $MatchMap[$BpRes] = $null
        continue
    }

    $BestScore = 0
    $BestCandidate = $null

    foreach ($Cand in $Candidates) {
        $Score = Get-ContentScore -Blueprint $BpRes -Candidate $Cand
        if ($Score -gt $BestScore) {
            $BestScore = $Score
            $BestCandidate = $Cand
        }
    }

    # Minimum threshold: at least 30% of properties must match to avoid false positives
    if ($BestCandidate -and $BestScore -ge 30) {
        $Key = "$($BestCandidate.ResourceType)|$($BestCandidate.Identity)"
        $ClaimedExportResources[$Key] = $true
        $MatchMap[$BpRes] = @{ Resource = $BestCandidate; Score = $BestScore; MatchType = 'Content' }
        Write-Ok "  Matched blueprint '$($BpRes.Identity)' → tenant '$($BestCandidate.Identity)' ($BestScore% content match)"
    }
    else {
        $MatchMap[$BpRes] = $null
        Write-Warn "  No match for blueprint '$($BpRes.Identity)' (best score: $BestScore%)"
    }
}

# ─── 3. Property-level comparison using matched pairs ────────────────────────

Write-Step 'Running property-level comparison'

$Findings = [System.Collections.Generic.List[PSCustomObject]]::new()

foreach ($BpRes in $BlueprintResources) {
    $MatchInfo = $MatchMap[$BpRes]
    $Match = if ($MatchInfo) { $MatchInfo.Resource } else { $null }

    # Build the display name showing both blueprint and tenant names
    $DisplayName = $BpRes.Identity
    if ($Match -and $Match.Identity -ne $BpRes.Identity) {
        $DisplayName = "$($BpRes.Identity) → matched: '$($Match.Identity)'"
    }

    if (-not $Match) {
        $Findings.Add([PSCustomObject]@{
                Status       = 'MISSING'
                Severity     = 'Critical'
                ResourceType = $BpRes.ResourceType
                ResourceName = $DisplayName
                Property     = '(entire resource)'
                Expected     = 'Present'
                Actual       = 'Not Found'
                Detail       = "No tenant resource of type '$($BpRes.ResourceType)' matches this blueprint resource."
            })
        continue
    }

    foreach ($Prop in $BpRes.Properties.GetEnumerator()) {
        if ($Prop.Key -in $PropsToSkip) { continue }

        # When matched by content (name differs), skip name/identity drift — it's expected
        if ($MatchInfo -and $MatchInfo.MatchType -eq 'Content' -and $Prop.Key -in $NameProps) { continue }

        $ExpectedVal = $Prop.Value
        $ActualVal = if ($Match.Properties.ContainsKey($Prop.Key)) {
            $Match.Properties[$Prop.Key]
        }
        else { '(not set)' }

        $NormExpected = Get-NormalisedValue $ExpectedVal
        $NormActual   = Get-NormalisedValue $ActualVal

        if ($NormExpected -ne $NormActual) {
            $Severity = switch -Regex ($Prop.Key) {
                'State|Action|BuiltInControls|Enabled|Block' { 'Critical' }
                'Threshold|Level|Frequency' { 'High' }
                default { 'Medium' }
            }

            $Findings.Add([PSCustomObject]@{
                    Status       = 'DRIFT'
                    Severity     = $Severity
                    ResourceType = $BpRes.ResourceType
                    ResourceName = $DisplayName
                    Property     = $Prop.Key
                    Expected     = $ExpectedVal
                    Actual       = $ActualVal
                    Detail       = "Property '$($Prop.Key)' differs from blueprint."
                })
        }
        else {
            $Findings.Add([PSCustomObject]@{
                    Status       = 'COMPLIANT'
                    Severity     = 'Info'
                    ResourceType = $BpRes.ResourceType
                    ResourceName = $DisplayName
                    Property     = $Prop.Key
                    Expected     = $ExpectedVal
                    Actual       = $ActualVal
                    Detail       = "Property '$($Prop.Key)' matches blueprint."
                })
        }
    }
}

# Summary counts
$Critical  = @($Findings | Where-Object Severity -eq 'Critical').Count
$High      = @($Findings | Where-Object Severity -eq 'High').Count
$Medium    = @($Findings | Where-Object Severity -eq 'Medium').Count
$Compliant = @($Findings | Where-Object Status   -eq 'COMPLIANT').Count
$Total     = $Findings.Count

Write-Ok "Comparison complete: $Critical critical, $High high, $Medium medium, $Compliant compliant"

# ─── 3. Generate HTML Report ────────────────────────────────────────────────

Write-Step 'Generating HTML gap-analysis report'

$ReportTitle = 'NCSC M365 Security Gap Analysis'
$ReportDate  = Get-Date -Format 'dd MMMM yyyy HH:mm'

$SeverityColor = @{
    Critical = '#e74c3c'
    High     = '#e67e22'
    Medium   = '#f39c12'
    Info     = '#2ecc71'
}

$StatusIcon = @{
    MISSING   = '&#10060;'         # ❌
    DRIFT     = '&#9888;&#65039;'  # ⚠️
    COMPLIANT = '&#9989;'          # ✅
}

# Build findings table rows
$TableRows = foreach ($F in ($Findings | Sort-Object @{Expression = 'Severity'; Ascending = $true }, ResourceType, ResourceName)) {
    $BgColor = switch ($F.Status) {
        'MISSING'   { '#fdecea' }
        'DRIFT'     { '#fef9e7' }
        'COMPLIANT' { '#eafaf1' }
    }
    $SevBadge = "<span style='background:$($SeverityColor[$F.Severity]);color:#fff;padding:2px 8px;border-radius:4px;font-size:0.85em;'>$($F.Severity)</span>"

    @"
        <tr style="background:$BgColor;">
            <td>$($StatusIcon[$F.Status]) $($F.Status)</td>
            <td>$SevBadge</td>
            <td><strong>$($F.ResourceType)</strong></td>
            <td>$([System.Net.WebUtility]::HtmlEncode($F.ResourceName))</td>
            <td><code>$([System.Net.WebUtility]::HtmlEncode($F.Property))</code></td>
            <td><code>$([System.Net.WebUtility]::HtmlEncode($F.Expected))</code></td>
            <td><code>$([System.Net.WebUtility]::HtmlEncode($F.Actual))</code></td>
            <td>$([System.Net.WebUtility]::HtmlEncode($F.Detail))</td>
        </tr>
"@
}

# Compliance score
$TotalEvaluated    = $Findings.Count
$CompliantProperties = @($Findings | Where-Object Status -eq 'COMPLIANT').Count

$CompliancePercent = if ($TotalEvaluated -gt 0) {
    [math]::Round(($CompliantProperties / $TotalEvaluated) * 100, 1)
}
else { 0 }

$ScoreColor = if ($CompliancePercent -ge 80) { '#2ecc71' }
              elseif ($CompliancePercent -ge 50) { '#f39c12' }
              else { '#e74c3c' }

# Warning banner for missing workloads
$WarningBannerHtml = ''
if ($MissingWorkloads.Count -gt 0) {
    $FailedList = ($MissingWorkloads | ForEach-Object { "<li><code>$_</code></li>" }) -join "`n"
    $WarningBannerHtml = @"
    <div style="background:#fef3cd;border:1px solid #ffc107;border-radius:10px;padding:16px 24px;margin-bottom:24px;">
        <strong style="color:#856404;">&#9888; Missing Resource Types</strong>
        <p style="color:#856404;margin:8px 0 4px;">The following $($MissingWorkloads.Count) resource type(s) are defined in the blueprint but not present in the export. They will appear as <strong>MISSING</strong> below:</p>
        <ul style="color:#856404;margin:4px 0 0 16px;">$FailedList</ul>
        <p style="color:#856404;font-size:0.85em;margin-top:8px;">Ensure the export includes all required workloads by reviewing the Components list in 2_DSC-Export.ps1.</p>
    </div>
"@
}

# Header subtitle components
$SubtitleParts = @()
if ($CompanyName) { $SubtitleParts += "Client: <strong>$([System.Net.WebUtility]::HtmlEncode($CompanyName))</strong>" }
$SubtitleParts += "Date: <strong>$ReportDate</strong>"
if ($Author) { $SubtitleParts += "Author: <strong>$([System.Net.WebUtility]::HtmlEncode($Author))</strong>" }
$SubtitleHtml = $SubtitleParts -join ' &nbsp;|&nbsp; '

$HtmlReport = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>$ReportTitle</title>
    <style>
        :root { --primary: #1a365d; --accent: #2b6cb0; --bg: #f7fafc; }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
               background: var(--bg); color: #2d3748; line-height: 1.6; }
        .container { max-width: 1400px; margin: 0 auto; padding: 24px; }

        /* Header */
        .header { background: linear-gradient(135deg, var(--primary), var(--accent));
                   color: #fff; padding: 32px 40px; border-radius: 12px;
                   margin-bottom: 24px; }
        .header h1 { font-size: 1.8em; margin-bottom: 4px; }
        .header .subtitle { opacity: 0.85; font-size: 0.95em; }

        /* Score Cards */
        .cards { display: grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
                 gap: 16px; margin-bottom: 24px; }
        .card { background: #fff; border-radius: 10px; padding: 20px;
                box-shadow: 0 1px 3px rgba(0,0,0,0.1); text-align: center; }
        .card .number { font-size: 2.2em; font-weight: 700; }
        .card .label  { font-size: 0.85em; color: #718096; margin-top: 4px; }

        /* Table */
        .table-wrap { background: #fff; border-radius: 10px; overflow: hidden;
                      box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
        table { width: 100%; border-collapse: collapse; font-size: 0.9em; }
        th { background: var(--primary); color: #fff; padding: 12px 16px;
             text-align: left; position: sticky; top: 0; }
        td { padding: 10px 16px; border-bottom: 1px solid #e2e8f0;
             vertical-align: top; }
        tr:hover { filter: brightness(0.97); }
        code { background: #edf2f7; padding: 2px 6px; border-radius: 4px;
               font-size: 0.9em; word-break: break-all; }

        /* Footer */
        .footer { text-align: center; padding: 24px; color: #a0aec0;
                   font-size: 0.85em; }

        /* Print */
        @media print {
            .header { -webkit-print-color-adjust: exact; print-color-adjust: exact; }
            .card   { break-inside: avoid; }
        }
    </style>
</head>
<body>
<div class="container">

    <!-- Header -->
    <div class="header">
        <h1>$ReportTitle</h1>
        <div class="subtitle">
            $SubtitleHtml
        </div>
    </div>

    <!-- Score Cards -->
    <div class="cards">
        <div class="card">
            <div class="number" style="color:$ScoreColor;">$CompliancePercent%</div>
            <div class="label">Compliance Score</div>
        </div>
        <div class="card">
            <div class="number" style="color:#e74c3c;">$Critical</div>
            <div class="label">Critical Findings</div>
        </div>
        <div class="card">
            <div class="number" style="color:#e67e22;">$High</div>
            <div class="label">High Findings</div>
        </div>
        <div class="card">
            <div class="number" style="color:#f39c12;">$Medium</div>
            <div class="label">Medium Findings</div>
        </div>
        <div class="card">
            <div class="number" style="color:#2ecc71;">$Compliant</div>
            <div class="label">Compliant</div>
        </div>
        <div class="card">
            <div class="number">$TotalEvaluated</div>
            <div class="label">Blueprint Properties</div>
        </div>
    </div>

    <!-- Warning Banner (if any resource types missing) -->
    $WarningBannerHtml

    <!-- Findings Table -->
    <div class="table-wrap">
        <table>
            <thead>
                <tr>
                    <th>Status</th>
                    <th>Severity</th>
                    <th>Resource Type</th>
                    <th>Resource Name</th>
                    <th>Property</th>
                    <th>Expected (Blueprint)</th>
                    <th>Actual (Tenant)</th>
                    <th>Detail</th>
                </tr>
            </thead>
            <tbody>
                $($TableRows -join "`n")
            </tbody>
        </table>
    </div>

    <!-- Footer -->
    <div class="footer">
        <p>Generated by <strong>M365DSC NCSC Gap Analysis v1.0</strong> &nbsp;|&nbsp;
           $ReportDate</p>
        <p>This report is confidential and intended solely for the named client.</p>
    </div>

</div>
</body>
</html>
"@

$HtmlReport | Set-Content -Path $ReportFile -Encoding UTF8
Write-Ok "HTML report saved: $ReportFile"

# Export findings as CSV
$Findings | Export-Csv -Path $CsvFile -NoTypeInformation -Encoding UTF8
Write-Ok "CSV findings:   $CsvFile"

# ─── 4. Summary ──────────────────────────────────────────────────────────────

Write-Host "`n" -NoNewline
Write-Host ('═' * 70) -ForegroundColor Cyan
Write-Host '  NCSC GAP ANALYSIS COMPLETE' -ForegroundColor Green
Write-Host ('═' * 70) -ForegroundColor Cyan
Write-Host @"

  Compliance Score    : $CompliancePercent% ($CompliantProperties / $TotalEvaluated properties)
  Critical Findings   : $Critical
  High Findings       : $High
  Medium Findings     : $Medium
  Compliant Props     : $CompliantProperties

  HTML Report : $ReportFile
  CSV Report  : $CsvFile
"@
