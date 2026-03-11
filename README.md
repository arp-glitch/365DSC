# DSCExport — NCSC M365 Security Assessment Toolkit

> **Purpose:** Automate the assessment of a Microsoft 365 tenant's security posture against the [UK National Cyber Security Centre (NCSC) Microsoft 365 Security Guidance](https://www.ncsc.gov.uk/collection/microsoft-365-security).

This folder contains a **3-step pipeline** that provisions authentication, exports the live tenant configuration using [Microsoft365DSC](https://microsoft365dsc.com/), and produces a colour-coded HTML/CSV gap-analysis report comparing the tenant state to a golden NCSC blueprint.

---

## Table of Contents

- [Overview](#overview)
- [Pipeline Steps at a Glance](#pipeline-steps-at-a-glance)
- [NCSC Blueprint — Workloads Assessed](#ncsc-blueprint--workloads-assessed)
- [Directory Layout](#directory-layout)
- [Prerequisites](#prerequisites)
- [File Reference](#file-reference)
  - [1\_Setup-DSCServicePrincipal.ps1](#1_setup-dscserviceprincipalps1)
  - [2\_DSC-Export.ps1](#2_dsc-exportps1)
  - [3\_GapAnalysis.ps1](#3_gapanalysisps1)
  - [ConfigurationData.psd1](#configurationdatapsd1)
  - [AssessmentToolPermissions.json](#assessmenttoolpermissionsjson)
- [Outputs](#outputs)
- [Troubleshooting](#troubleshooting)

---

## Overview

The toolkit follows a read-only assessment model:

1. **Authenticate** — Create (or reuse) an Entra ID App Registration with the minimum Graph API, Exchange Online, and SharePoint Online permissions.
2. **Export** — Pull the live M365 tenant configuration for the in-scope workloads using `Export-M365DSCConfiguration`.
3. **Analyse** — Parse both the export and the NCSC golden blueprint, compare every property, and generate a branded gap report.

No changes are made to the tenant during steps 1–3. This is a **read-only audit**.

---

## Pipeline Steps at a Glance

```
┌───────────────────────────┐     ┌──────────────────────────┐     ┌──────────────────────────────┐
│  Step 1                   │     │  Step 2                  │     │  Step 3                      │
│  Setup Service Principal  │────▶│  Export Tenant Config     │────▶│  Gap Analysis vs Blueprint   │
│  (1_Setup-DSC...ps1)      │     │  (2_DSC-Export.ps1)      │     │  (3_GapAnalysis.ps1)         │
│                           │     │                          │     │                              │
│  • App Registration       │     │  • Calls M365DSC Export  │     │  • AST-based DSC parsing     │
│  • Certificate generation │     │  • Scoped to NCSC        │     │  • Property-level comparison │
│  • Permission assignment  │     │    workloads              │     │  • HTML + CSV report output  │
│  • Admin consent          │     │  • Outputs .ps1 file     │     │  • Compliance scoring        │
└───────────────────────────┘     └──────────────────────────┘     └──────────────────────────────┘
```

---

## NCSC Blueprint — Workloads Assessed

The golden blueprint (`Blueprints/NCSC_M365_Baseline.ps1`) codifies the [NCSC Microsoft 365 Security Guidance](https://www.ncsc.gov.uk/collection/microsoft-365-security) into enforceable DSC resource blocks. The following workloads are assessed:

| Area | DSC Resource Types | NCSC Guidance Section |
|---|---|---|
| **Conditional Access** | `AADConditionalAccessPolicy` | [Enforce multi-factor authentication](https://www.ncsc.gov.uk/collection/microsoft-365-security) |
| **Named Locations** | `AADNamedLocationPolicy` | Trusted corporate networks for CA policies |
| **SharePoint Online** | `SPOTenantSettings` | [Reduce external sharing to minimum required](https://www.ncsc.gov.uk/collection/microsoft-365-security) |
| **Anti-Phishing** | `EXOAntiPhishPolicy` | [Enable advanced anti-phishing protections](https://www.ncsc.gov.uk/collection/microsoft-365-security) |
| **Anti-Spam** | `EXOHostedContentFilterPolicy` | [Configure spam filtering to recommended levels](https://www.ncsc.gov.uk/collection/microsoft-365-security) |
| **Safe Attachments** | `EXOSafeAttachmentPolicy` | [Enable Safe Attachments for all users](https://www.ncsc.gov.uk/collection/microsoft-365-security) |
| **Safe Links** | `EXOSafeLinksPolicy` | [Enable Safe Links URL scanning](https://www.ncsc.gov.uk/collection/microsoft-365-security) |
| **Malware Filter** | `EXOMalwareFilterPolicy` | [Block known malicious file types](https://www.ncsc.gov.uk/collection/microsoft-365-security) |
| **Transport Rules** | `EXOTransportRule` | Email flow and protection rules |
| **DLP** | `SCDLPCompliancePolicy` | Data Loss Prevention policies |
| **Retention** | `SCRetentionCompliancePolicy` | Data retention compliance |
| **Sensitivity Labels** | `SCLabelPolicy` | Information protection labels |
| **Device Compliance** | `IntuneDeviceCompliancePolicyWindows10` | Endpoint compliance baselines |
| **Token Lifetime** | `AADTokenLifetimePolicy` | Session management policies |
| **Teams Messaging** | `TeamsMessagingPolicy` | Teams messaging controls |

### Conditional Access Policies in the Blueprint

The blueprint defines five Conditional Access policies aligned to NCSC recommendations:

| Policy | Purpose |
|---|---|
| **CA-001** — Require MFA for All Users | Enforce MFA for all users, admins, and guests |
| **CA-002** — Block Legacy Authentication | Disable legacy auth protocols (ActiveSync, other) |
| **CA-003** — Require Compliant Device for Admins | Admin accounts must use managed, compliant devices |
| **CA-004** — Block High-Risk Sign-Ins | Risk-based CA to block high-risk sessions |
| **CA-005** — Require MFA for Azure Management | Protect Azure management plane with strong auth |

---

## Directory Layout

```
365DSC/
├── DSCExport/                            ← You are here
│   ├── 1_Setup-DSCServicePrincipal.ps1   # Step 1: App registration & auth setup
│   ├── 2_DSC-Export.ps1                  # Step 2: Export tenant configuration
│   ├── 3_GapAnalysis.ps1                # Step 3: Gap analysis & report generation
│   ├── ConfigurationData.psd1           # DSC configuration data (node/credential info)
│   └── AssessmentToolPermissions.json   # Required API permissions definition
├── Blueprints/
│   └── NCSC_M365_Baseline.ps1           # Golden blueprint (desired state)
├── Config/
│   └── DSCConfig.psd1                   # Pipeline config (app name, creds, paths)
├── Exports/                             # Timestamped tenant export snapshots
├── Reports/                             # Generated HTML & CSV gap reports
└── Logs/                                # Assessment & remediation transcript logs
```

---

## Prerequisites

### Machine Requirements

| Requirement | Minimum Version | Notes |
|---|---|---|
| **Operating System** | Windows 10/11 or Windows Server 2019+ | Required for DSC/CIM support |
| **PowerShell** | 7.x (7.5+ recommended) | PS 5.1 is **not** supported by M365DSC v1.26+ |
| **Microsoft365DSC** | Latest from PSGallery | Tested with v1.26.218.1 |
| **PSDesiredStateConfiguration** | 2.0.7 (prerelease) | **Required on PowerShell 7** — not installed by default |
| **ExchangeOnlineManagement** | 3.0+ | Required for EXO policy analysis |
| **Microsoft.Graph.Authentication** | 2.x | For Service Principal setup (Step 1) |
| **Microsoft.Graph.Applications** | 2.x | For Service Principal setup (Step 1) |
| **M365DSC Dependencies** | ~37 modules | Graph Beta, MSCloudLoginAssistant, PnP.PowerShell 1.12.0, Az.*, etc. |

### Entra ID / Tenant Requirements

- **Global Administrator** — Required for initial app registration and admin consent (Step 1 only).
- **Licensing** — The target tenant needs at minimum **Microsoft Entra ID P1** (included in M365 Business Premium / E3 / E5) for Conditional Access workloads. Advanced DLP and Sensitivity Labels require **M365 E3 or E5**.

### Module Installation

```powershell
# Install core modules (run elevated — AllUsers scope)
Install-Module Microsoft365DSC -Force -Scope AllUsers
Install-Module Microsoft.Graph.Authentication -Force -Scope AllUsers
Install-Module Microsoft.Graph.Applications -Force -Scope AllUsers

# CRITICAL: Required on PowerShell 7 for M365DSC to function
Install-Module PSDesiredStateConfiguration -RequiredVersion 2.0.7 -Force -AllowPrerelease -Scope AllUsers

# Install all M365DSC dependencies from its manifest (run in PowerShell 7)
$m365Path = (Get-Module Microsoft365DSC -ListAvailable | Select-Object -First 1).ModuleBase
$manifest = Import-PowerShellDataFile "$m365Path\Dependencies\Manifest.psd1"
foreach ($dep in $manifest.Dependencies) {
    Install-Module -Name $dep.ModuleName -RequiredVersion $dep.RequiredVersion `
                   -Force -AllowClobber -Scope AllUsers -ErrorAction SilentlyContinue
}

# Az.* modules (required at runtime but NOT listed in M365DSC manifest)
@('Az.Accounts','Az.ResourceGraph','Az.Resources','Az.Security','Az.SecurityInsights') |
    ForEach-Object { Install-Module $_ -Force -AllowClobber -Scope AllUsers }
```

> **Important:** Always install with `-Scope AllUsers` to avoid dual-install issues between PS 5.1 and PS 7 module paths. Restart your terminal after installing.

---

## File Reference

### 1_Setup-DSCServicePrincipal.ps1

**Purpose:** Creates (or updates) an Entra ID App Registration with the minimum permissions needed by Microsoft365DSC to read tenant configuration for the NCSC audit workloads.

**What it does:**
1. Loads required permissions from `AssessmentToolPermissions.json`
2. Connects to Microsoft Graph with delegated permissions (interactive sign-in)
3. Creates or retrieves the App Registration
4. Assigns Microsoft Graph, Exchange Online, and SharePoint Online API permissions
5. Generates a self-signed certificate (2-year validity) and uploads it to the app
6. Grants admin consent for all permissions
7. Writes the `ApplicationId`, `TenantId`, and `CertificateThumbprint` back to `Config/DSCConfig.psd1`

**Parameters:**

| Parameter | Required | Default | Description |
|---|---|---|---|
| `-ConfigPath` | No | `..\Config\DSCConfig.psd1` | Path to the pipeline configuration file |
| `-PermissionsPath` | No | `.\AssessmentToolPermissions.json` | Path to the permissions definition file |
| `-CertificateValidityYears` | No | `2` | Certificate validity period (1–10 years) |

**Examples:**

```powershell
# Default — uses config and permissions files from standard locations
cd 365DSC\DSCExport
.\1_Setup-DSCServicePrincipal.ps1

# Custom config path
.\1_Setup-DSCServicePrincipal.ps1 -ConfigPath 'C:\M365DSC\Config\DSCConfig.psd1'

# Custom certificate validity
.\1_Setup-DSCServicePrincipal.ps1 -CertificateValidityYears 1
```

---

### 2_DSC-Export.ps1

**Purpose:** Exports the current M365 tenant configuration for the NCSC-scoped workloads using `Export-M365DSCConfiguration`.

**What it does:**
1. Calls `Export-M365DSCConfiguration` with the specified authentication parameters
2. Scopes the export to only the DSC resource types relevant to the NCSC blueprint (e.g. `AADConditionalAccessPolicy`, `EXOAntiPhishPolicy`, `SPOTenantSettings`, etc.)
3. Writes the exported configuration as a `.ps1` file to the specified output path

**Parameters:**

| Parameter | Required | Default | Description |
|---|---|---|---|
| `-TenantName` | **Yes** | — | Tenant domain (e.g. `contoso.onmicrosoft.com`) |
| `-ApplicationId` | **Yes** | — | App Registration (Client) Id from Step 1 |
| `-CertificateThumbprint` | **Yes** | — | Certificate thumbprint from Step 1 |
| `-Path` | No | `.` (current directory) | Output directory for the export |
| `-FileName` | No | `export.ps1` | Output filename |

**Examples:**

```powershell
# Basic export with required parameters
.\2_DSC-Export.ps1 `
    -TenantName "contoso.onmicrosoft.com" `
    -ApplicationId "cd704314-acc8-46f9-ae73-1edc1dc49145" `
    -CertificateThumbprint "EB15021BEF4103CAF518D27634DDE36EE871C7DA"

# Export to a specific folder with a custom filename
.\2_DSC-Export.ps1 `
    -TenantName "contoso.onmicrosoft.com" `
    -ApplicationId "cd704314-acc8-46f9-ae73-1edc1dc49145" `
    -CertificateThumbprint "EB15021BEF4103CAF518D27634DDE36EE871C7DA" `
    -Path "..\Exports" `
    -FileName "contoso_export.ps1"
```

---

### 3_GapAnalysis.ps1

**Purpose:** Compares the exported tenant configuration against the NCSC golden blueprint and generates a branded HTML gap-analysis report with a CSV export.

**What it does:**
1. Parses both the export and the blueprint using PowerShell AST (`DynamicKeywordStatementAst`) to extract DSC resource blocks
2. Matches tenant resources to blueprint resources using a two-pass strategy:
   - **Exact match** on `ResourceType` + `DisplayName`/`Identity`
   - **Content-based scoring** — if names differ, scores property overlap (minimum 30% threshold)
3. Performs a **property-level comparison** with normalisation (quotes stripped, booleans unified, whitespace collapsed)
4. Classifies each finding by severity:
   - **Critical** — State, action, or block control properties that differ
   - **High** — Threshold, level, or frequency properties
   - **Medium** — All other property drifts
   - **Missing** — Entire blueprint resource not found in tenant (Critical)
5. Generates a branded HTML report with compliance score, colour-coded findings, and summary cards
6. Exports all findings as CSV for programmatic consumption

**Parameters:**

| Parameter | Required | Default | Description |
|---|---|---|---|
| `-ExportPath` | **Yes** | — | Path to the exported DSC `.ps1` file from Step 2 |
| `-BlueprintPath` | No | `..\Blueprints\NCSC_M365_Baseline.ps1` | Path to the NCSC golden blueprint |
| `-ReportDir` | No | `..\Reports` | Output directory for HTML and CSV reports |
| `-CompanyName` | No | Inferred from export filename | Company name for the report header |
| `-Author` | No | Empty | Author name for the report header |

**Examples:**

```powershell
# Basic gap analysis — blueprint path and report dir use defaults
.\3_GapAnalysis.ps1 -ExportPath .\contoso_export.ps1

# With company name and author in the report header
.\3_GapAnalysis.ps1 `
    -ExportPath "..\Exports\contoso_export.ps1" `
    -CompanyName "Contoso Ltd" `
    -Author "Andre Passos"

# Custom blueprint and output directory
.\3_GapAnalysis.ps1 `
    -ExportPath "..\Exports\contoso_export.ps1" `
    -BlueprintPath "C:\Blueprints\Custom_Baseline.ps1" `
    -ReportDir "C:\AuditReports"
```

---

### ConfigurationData.psd1

**Purpose:** Standard DSC configuration data file used by `Export-M365DSCConfiguration`. Contains node metadata and authentication parameters (Application Id, Certificate Thumbprint, Tenant Id).

This file is typically auto-generated or populated after running Step 1.

---

### AssessmentToolPermissions.json

**Purpose:** Defines the exact set of Microsoft Graph, Exchange Online, and SharePoint Online API permissions (Application-level `Role` type) that the service principal needs. Used by Step 1 to assign permissions to the app registration.

The file includes permissions across five API resource providers:

| API | Resource App Id | Key Permissions |
|---|---|---|
| **Microsoft Graph** | `00000003-0000-0000-c000-000000000000` | Policy.Read.All, User.Read.All, Sites.ReadWrite.All, SecurityPolicy.ReadWrite.All, Agreement.ReadWrite.All, etc. |
| **Exchange Online** | `00000002-0000-0ff1-ce00-000000000000` | Exchange.ManageAsApp |
| **SharePoint Online** | `00000003-0000-0ff1-ce00-000000000000` | Sites.FullControl.All |
| **Office 365 Management** | `c5393580-f805-4401-95e8-94b7a6ef2fc2` | ServiceHealth.Read, ActivityFeed.Read |
| **PowerApps Service** | `fc780465-2017-40d4-a0c5-307022471b92` | User access management |

---

## Outputs

### Exports (`../Exports/`)

Each run of Step 2 produces a timestamped export folder:

```
Exports/
├── Export_20260303-134930/
│   └── export.ps1          # Full DSC configuration of the tenant
├── Export_20260310-205148/
│   └── export.ps1
└── ...
```

### Reports (`../Reports/`)

Each run of Step 3 produces both an HTML and CSV report:

```
Reports/
├── NCSC_GapReport_20260310-205148.html   # Branded HTML report
├── NCSC_GapReport_20260310-205148.csv    # Machine-readable findings
└── ...
```

**HTML Report contents:**
- **Compliance score** — percentage of blueprint properties that match the tenant state
- **Summary cards** — counts by severity (Critical / High / Medium / Compliant)
- **Warning banner** — lists any blueprint resource types missing from the export
- **Findings table** — colour-coded rows per finding with Status, Severity, Resource Type, Property, Expected vs Actual values, and Detail

**CSV Report columns:**
`Status`, `Severity`, `ResourceType`, `ResourceName`, `Property`, `Expected`, `Actual`, `Detail`

### Logs (`../Logs/`)

Transcript logs are stored with timestamped filenames:

```
Logs/
├── Assessment_20260303-134930.log    # Export step logs
├── Remediation_20260303-222915.log   # Remediation step logs (if applicable)
└── ...
```

---

## Troubleshooting

| Issue | Resolution |
|---|---|
| `The term 'Get-PwshDscResource' is not recognized` | Install `PSDesiredStateConfiguration` v2.0.7: `Install-Module PSDesiredStateConfiguration -RequiredVersion 2.0.7 -Force -AllowPrerelease` |
| `A second CIM class definition` errors | You have duplicate M365DSC installs. Remove the `CurrentUser` copy and keep only the `AllUsers` install. |
| `The following dependencies need updating: Az.Accounts...` | Install Az.* modules manually — they are not in the M365DSC manifest. |
| `PnP.PowerShell Assembly with same name already loaded` | Remove PnP.PowerShell v3.x and keep only v1.12.0. |
| Export produces empty/partial results | Verify the service principal has all required API permissions and the three directory roles (Exchange Admin, Compliance Admin, SharePoint Admin). |
| Step 1 fails on role assignment | Assign roles manually via [Entra portal](https://entra.microsoft.com) → Enterprise applications → your app → Roles and administrators. |
