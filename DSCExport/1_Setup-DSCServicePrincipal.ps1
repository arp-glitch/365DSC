#Requires -Version 5.1
#Requires -Modules Microsoft.Graph.Authentication, Microsoft.Graph.Applications
<#
.SYNOPSIS
    Creates an Entra ID App Registration with the Graph API permissions
    required by Microsoft365DSC to read/write Conditional Access, SharePoint,
    Security & Compliance, and Exchange Online settings.

.DESCRIPTION
    This script:
      1. Creates (or updates) an App Registration in Entra ID.
      2. Assigns the minimum Microsoft Graph *Application* permissions needed
         for the NCSC audit workloads (loaded from AssessmentToolPermissions.json).
      3. Generates a self-signed certificate (2-year validity), uploads the
         public key to the App Registration, and exports the .pfx to disk.
      4. Grants admin consent for all assigned permissions.
      5. Updates the config file with the new AppId / TenantId /
         Thumbprint for use by the export and gap analysis steps.

    This is Step 1 of the 3-step NCSC assessment process:
      Step 1: Setup Service Principal (this script)
      Step 2: Export tenant configuration (2_DSC-Export.ps1)
      Step 3: Gap analysis against NCSC blueprint (3_GapAnalysis.ps1)

.PARAMETER ConfigPath
    Path to DSCConfig.psd1.  Defaults to ..\Config\DSCConfig.psd1

.PARAMETER CertificateValidityYears
    How many years the self-signed cert should be valid.  Default: 2

.EXAMPLE
    .\1_Setup-DSCServicePrincipal.ps1
    .\1_Setup-DSCServicePrincipal.ps1 -ConfigPath 'C:\M365DSC\Config\DSCConfig.psd1'

.NOTES
    Author  : M365 NCSC Audit Pipeline
    Version : 1.0.0
    Date    : 2026-02-27
#>

[CmdletBinding()]
param(
    [string]$ConfigPath = (Join-Path $PSScriptRoot '..\Config\DSCConfig.psd1'),

    [string]$PermissionsPath = (Join-Path $PSScriptRoot 'AssessmentToolPermissions.json'),

    [ValidateRange(1, 10)]
    [int]$CertificateValidityYears = 2
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# ─── Helpers ────────────────────────────────────────────────────────────────

function Write-Step {
    param([string]$Message)
    Write-Host "`n► $Message" -ForegroundColor Cyan
}

function Write-Success {
    param([string]$Message)
    Write-Host "  ✔ $Message" -ForegroundColor Green
}

function Write-Warn {
    param([string]$Message)
    Write-Host "  ⚠ $Message" -ForegroundColor Yellow
}

# ─── 0. Load Config ────────────────────────────────────────────────────────

Write-Step 'Loading pipeline configuration'
if (-not (Test-Path $ConfigPath)) {
    throw "Config file not found at '$ConfigPath'. Copy the template and fill in your values."
}
$Config = Import-PowerShellDataFile -Path $ConfigPath
$AppDisplayName = $Config.AppDisplayName
if ([string]::IsNullOrWhiteSpace($AppDisplayName)) {
    throw "AppDisplayName is not set in '$ConfigPath'."
}
Write-Success "Config loaded – App name: $AppDisplayName"

Write-Step 'Loading required app permissions'
if (-not (Test-Path $PermissionsPath)) {
    throw "Permissions file not found at '$PermissionsPath'."
}

$PermissionsJson = Get-Content -Path $PermissionsPath -Raw | ConvertFrom-Json
if (-not $PermissionsJson -or $PermissionsJson.Count -eq 0) {
    throw "Permissions file '$PermissionsPath' is empty or invalid."
}

$RequiredResourceAccess = foreach ($Api in $PermissionsJson) {
    @{
        ResourceAppId  = [string]$Api.ResourceAppId
        ResourceAccess = @(
            foreach ($Access in $Api.ResourceAccess) {
                @{
                    Id   = [Guid]$Access.Id
                    Type = [string]$Access.Type
                }
            }
        )
    }
}

$TotalPermissionCount = ($RequiredResourceAccess | ForEach-Object { $_.ResourceAccess.Count } | Measure-Object -Sum).Sum
Write-Success "Loaded $TotalPermissionCount permissions across $($RequiredResourceAccess.Count) APIs"

# ─── 1. Connect to Microsoft Graph ─────────────────────────────────────────

Write-Step 'Connecting to Microsoft Graph (delegated – you will be prompted)'

# We need these scopes to create the app registration and grant consent
$RequiredScopes = @(
    'Application.ReadWrite.All'
    'AppRoleAssignment.ReadWrite.All'
    'Directory.ReadWrite.All'
    'RoleManagement.ReadWrite.Directory'
)

try {
    Connect-MgGraph -Scopes $RequiredScopes -ErrorAction Stop | Out-Null
    $ctx = Get-MgContext
    Write-Success "Connected as $($ctx.Account) to tenant $($ctx.TenantId)"
}
catch {
    throw "Failed to connect to Microsoft Graph: $_"
}

$TenantId = $ctx.TenantId

# ─── 2. Define Required API Permissions ─────────────────────────────────────

$GraphAppId = '00000003-0000-0000-c000-000000000000'  # Microsoft Graph
$ExoAppId = '00000002-0000-0ff1-ce00-000000000000'  # Office 365 Exchange Online
$SpoApiAppId = '00000003-0000-0ff1-ce00-000000000000'  # Office 365 SharePoint Online

$PermissionNameMap = @{
    '01c0a623-fc9b-48e9-b794-0756f8e8f067' = 'Policy.ReadWrite.ConditionalAccess'
    '1bfefb4e-e0b5-418b-a88f-73c46d2cc8e9' = 'Application.ReadWrite.All'
    '230c1aed-a721-4c5d-9cb4-a90514e508ef' = 'Mail.ReadWrite'
    '246dd0d5-5bd0-4def-940b-0421030a5b68' = 'Policy.Read.All'
    '45cc0394-e837-488b-a098-1918f48d186c' = 'SecurityPolicy.ReadWrite.All'
    '62a82d76-70ea-41e2-9197-370581804d09' = 'Group.ReadWrite.All'
    '83d4163d-a2d8-4d3b-9695-4ae3ca98f888' = 'DeviceManagementApps.ReadWrite.All'
    '9241abd9-d0e6-425a-bd4f-47ba86e767a4' = 'DeviceManagementConfiguration.ReadWrite.All'
    '9e3f62cf-ca93-4989-b6ce-bf83c28f9fe8' = 'RoleManagement.ReadWrite.Directory'
    'a82116e5-55eb-4c41-a434-62fe8a61c773' = 'Sites.ReadWrite.All'
    'bdd80a03-d9bc-451d-b7c4-ce7c63fe3c8f' = 'TeamSettings.ReadWrite.All'
    'dc50a0fb-09a3-484d-be87-e023b12c6440' = 'Exchange.ManageAsApp'
    'df021288-bdef-4463-88db-98f22de89214' = 'User.Read.All'
    'e321f0bb-e7f7-481e-bb28-e3b0b32d4bd0' = 'IdentityProvider.Read.All'
    '19b94e34-907c-4f43-bde9-38b1909ed408' = 'ThreatAssessment.ReadWrite.All'
    '678536fe-1083-478a-9c59-b99265e6b0d3' = 'Sites.FullControl.All'
    'b86848a7-d5b1-41eb-a9b4-54a4e6306e97' = 'APIConnectors.Read.All'
    '1b0c317f-dd31-4305-9932-259a8b6e8099' = 'IdentityUserFlow.Read.All'
    'eedb7fdd-7539-4345-a38b-4839e4a84cbd' = 'ProgramControl.Read.All'
    'c9090d00-6101-42f0-a729-c41074260d47' = 'Agreement.ReadWrite.All'
}

$RequiredGraphPermissions = @(
    foreach ($Api in $RequiredResourceAccess) {
        if ($Api.ResourceAppId -eq $GraphAppId) {
            foreach ($Perm in $Api.ResourceAccess) {
                @{
                    Id   = [string]$Perm.Id
                    Desc = if ($PermissionNameMap.ContainsKey([string]$Perm.Id)) { $PermissionNameMap[[string]$Perm.Id] } else { [string]$Perm.Id }
                }
            }
        }
    }
)

# ─── 3. Create or Retrieve App Registration ────────────────────────────────

Write-Step "Creating / retrieving App Registration '$AppDisplayName'"

$ExistingApp = Get-MgApplication -Filter "displayName eq '$AppDisplayName'" -ErrorAction SilentlyContinue |
Select-Object -First 1

if ($ExistingApp) {
    Write-Warn "App '$AppDisplayName' already exists (AppId: $($ExistingApp.AppId)). Updating."
    $App = $ExistingApp
}
else {
    $AppBody = @{
        DisplayName    = $AppDisplayName
        SignInAudience = 'AzureADMyOrg'
    }
    $App = New-MgApplication @AppBody
    Write-Success "App created – AppId: $($App.AppId)"
}

$AppObjectId = $App.Id
$AppId = $App.AppId

# ─── 4. Assign API Permissions ──────────────────────────────────────────────

Write-Step 'Assigning Microsoft Graph application permissions'

Update-MgApplication -ApplicationId $AppObjectId -RequiredResourceAccess $RequiredResourceAccess
Write-Success "$TotalPermissionCount permissions assigned across $($RequiredResourceAccess.Count) APIs"

# ─── 5. Create Self-Signed Certificate ──────────────────────────────────────

Write-Step 'Generating self-signed certificate for app authentication'

$CertSubject = "CN=$AppDisplayName"
$CertStore = 'Cert:\CurrentUser\My'
$PfxFolder = Join-Path $PSScriptRoot '..\Config'
$PfxPath = Join-Path $PfxFolder "$AppDisplayName.pfx"
$CerPath = Join-Path $PfxFolder "$AppDisplayName.cer"

# Check if cert already exists
$ExistingCert = Get-ChildItem $CertStore | Where-Object { $_.Subject -eq $CertSubject -and $_.NotAfter -gt (Get-Date) } |
Sort-Object NotAfter -Descending | Select-Object -First 1

if ($ExistingCert) {
    Write-Warn "Valid certificate already exists (Thumbprint: $($ExistingCert.Thumbprint)). Re-using."
    $Cert = $ExistingCert
}
else {
    $CertParams = @{
        Subject           = $CertSubject
        CertStoreLocation = $CertStore
        KeyExportPolicy   = 'Exportable'
        KeySpec           = 'Signature'
        KeyLength         = 2048
        KeyAlgorithm      = 'RSA'
        HashAlgorithm     = 'SHA256'
        NotAfter          = (Get-Date).AddYears($CertificateValidityYears)
        Provider          = 'Microsoft Enhanced RSA and AES Cryptographic Provider'
    }
    $Cert = New-SelfSignedCertificate @CertParams
    Write-Success "Certificate created – Thumbprint: $($Cert.Thumbprint)"
}

# Export .pfx (private key) – prompt for password
$PfxPassword = Read-Host -Prompt '  Enter a password to protect the .pfx file' -AsSecureString
Export-PfxCertificate -Cert "$CertStore\$($Cert.Thumbprint)" -FilePath $PfxPath -Password $PfxPassword | Out-Null
Write-Success "PFX exported to: $PfxPath"

# Export .cer (public key only) for upload
Export-Certificate -Cert "$CertStore\$($Cert.Thumbprint)" -FilePath $CerPath -Type CERT | Out-Null
Write-Success "CER exported to: $CerPath"

# ─── 6. Upload Certificate to App Registration ──────────────────────────────

Write-Step 'Uploading public key to App Registration'

$CertBase64 = [System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes($CerPath))

$KeyCredential = @{
    DisplayName = "$AppDisplayName Auth Cert"
    Type        = 'AsymmetricX509Cert'
    Usage       = 'Verify'
    Key         = [System.Convert]::FromBase64String($CertBase64)
}

Update-MgApplication -ApplicationId $AppObjectId -KeyCredentials @($KeyCredential)
Write-Success 'Certificate uploaded to App Registration'

# ─── 7. Create Service Principal & Grant Admin Consent ───────────────────────

Write-Step 'Creating Service Principal and granting admin consent'

$SP = Get-MgServicePrincipal -Filter "appId eq '$AppId'" -ErrorAction SilentlyContinue | Select-Object -First 1
if (-not $SP) {
    $SP = New-MgServicePrincipal -AppId $AppId
    Write-Success "Service Principal created – ObjectId: $($SP.Id)"
}
else {
    Write-Warn "Service Principal already exists – ObjectId: $($SP.Id)"
}

# Get the Microsoft Graph service principal to look up AppRole IDs
$GraphSP = Get-MgServicePrincipal -Filter "appId eq '$GraphAppId'" | Select-Object -First 1

foreach ($Perm in $RequiredGraphPermissions) {
    try {
        $Body = @{
            PrincipalId = $SP.Id
            ResourceId  = $GraphSP.Id
            AppRoleId   = $Perm.Id
        }
        New-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $SP.Id -BodyParameter $Body -ErrorAction SilentlyContinue | Out-Null
        Write-Host "    ✔ $($Perm.Desc)" -ForegroundColor DarkGreen
    }
    catch {
        if ($_.Exception.Message -like '*already exists*') {
            Write-Host "    ≡ $($Perm.Desc) (already granted)" -ForegroundColor DarkGray
        }
        else {
            Write-Host "    ✘ $($Perm.Desc) – $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}

$NonGraphApis = $RequiredResourceAccess | Where-Object { $_.ResourceAppId -ne $GraphAppId }
foreach ($Api in $NonGraphApis) {
    $ResourceAppId = [string]$Api.ResourceAppId
    $ApiName = switch ($ResourceAppId) {
        $ExoAppId { 'Exchange Online' }
        $SpoApiAppId { 'SharePoint Online' }
        default { $ResourceAppId }
    }

    $ApiSp = Get-MgServicePrincipal -Filter "appId eq '$ResourceAppId'" -ErrorAction SilentlyContinue | Select-Object -First 1
    if (-not $ApiSp) {
        Write-Warn "Could not find service principal for API $ApiName ($ResourceAppId)"
        continue
    }

    foreach ($Perm in $Api.ResourceAccess) {
        $PermId = [string]$Perm.Id
        $PermDesc = if ($PermissionNameMap.ContainsKey($PermId)) { $PermissionNameMap[$PermId] } else { $PermId }

        try {
            New-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $SP.Id -BodyParameter @{
                PrincipalId = $SP.Id
                ResourceId  = $ApiSp.Id
                AppRoleId   = $PermId
            } -ErrorAction SilentlyContinue | Out-Null
            Write-Host "    ✔ $ApiName - $PermDesc" -ForegroundColor DarkGreen
        }
        catch {
            Write-Host "    ≡ $ApiName - $PermDesc (already granted)" -ForegroundColor DarkGray
        }
    }
}

# Assign directory roles to the SP
# Use direct API calls with proper JSON formatting
Write-Step 'Assigning directory roles to Service Principal'

$DirectoryRoles = @(
    @{ Name = 'Exchange Administrator'; RoleDefinitionId = '29232cdf-9323-42fd-ade2-1d097af3e4de' }
    @{ Name = 'Compliance Administrator'; RoleDefinitionId = '17315797-102d-40b4-93e0-432062caca18' }
    @{ Name = 'SharePoint Administrator'; RoleDefinitionId = 'f28a1f50-f6e7-4571-818b-6a12f2af6b6c' }
    @{ Name = 'Global Reader'; RoleDefinitionId = 'f2ef992c-3afb-46b9-b7cf-a126ee74c451' }
    @{ Name = 'Teams Administrator'; RoleDefinitionId = '69091246-20e8-4a56-aa4d-066075b2a7a8' }
)

foreach ($Role in $DirectoryRoles) {
    try {
        # Check if role is already assigned
        $Existing = Invoke-MgGraphRequest -Method GET `
            -Uri "https://graph.microsoft.com/v1.0/roleManagement/directory/roleAssignments?`$filter=principalId eq '$($SP.Id)' and roleDefinitionId eq '$($Role.RoleDefinitionId)'" `
            -ErrorAction SilentlyContinue
        
        if ($Existing.value -and $Existing.value.Count -gt 0) {
            Write-Warn "$($Role.Name) role already assigned"
        }
        else {
            # Assign the role
            $Body = @{
                principalId      = $SP.Id
                roleDefinitionId = $Role.RoleDefinitionId
                directoryScopeId = '/'
            } | ConvertTo-Json
            
            Invoke-MgGraphRequest -Method POST `
                -Uri 'https://graph.microsoft.com/v1.0/roleManagement/directory/roleAssignments' `
                -Body $Body -ContentType 'application/json' -ErrorAction Stop | Out-Null
            Write-Success "$($Role.Name) role assigned"
        }
    }
    catch {
        Write-Warn "Could not assign $($Role.Name) role: $($_.Exception.Message)"
        Write-Host "        → Try manually assigning roles from https://entra.microsoft.com > App registrations > $AppDisplayName > Directory roles" -ForegroundColor Gray
    }
}

# ─── 8. Update Config File ──────────────────────────────────────────────────

Write-Step 'Updating pipeline config with new credentials'

# Retrieve the organization's verified domains to get the default tenant domain
try {
    $Domains = @(Get-MgDomain -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Id)
    if ($Domains -and $Domains.Count -gt 0) {
        # Prefer the .onmicrosoft.com domain, fall back to first domain
        $TenantDomain = $Domains | Where-Object { $_ -like '*.onmicrosoft.com' } | Select-Object -First 1
        if (-not $TenantDomain) { $TenantDomain = $Domains[0] }
    }
    else {
        throw "No domains found in organization"
    }
    Write-Debug "Resolved Tenant Domain: $TenantDomain"
}
catch {
    Write-Warn "Could not resolve tenant domain automatically. Using placeholder. Please update manually."
    $TenantDomain = "unresolved.onmicrosoft.com"
}

# Read config line-by-line to preserve comments and alignment
$ConfigLines = @(Get-Content $ConfigPath -Encoding UTF8)
$UpdatesNeeded = @(
    @{ Pattern = "ApplicationId\s*="; NewValue = "ApplicationId         = '$AppId'"; Field = 'ApplicationId' }
    @{ Pattern = "TenantId\s*="; NewValue = "TenantId              = '$TenantId'"; Field = 'TenantId' }
    @{ Pattern = "TenantDomain\s*="; NewValue = "TenantDomain          = '$TenantDomain'"; Field = 'TenantDomain' }
    @{ Pattern = "CertificateThumbprint\s*="; NewValue = "CertificateThumbprint = '$($Cert.Thumbprint)'"; Field = 'CertificateThumbprint' }
    @{ Pattern = "CertificatePath\s*="; NewValue = "CertificatePath       = '$($PfxPath -replace '\\','\\\\')'"; Field = 'CertificatePath' }
)

$UpdatedCount = 0
$UpdatedLines = @(
    foreach ($Line in $ConfigLines) {
        $Updated = $false
        foreach ($Update in $UpdatesNeeded) {
            if ($Line -match "^\s*$($Update.Pattern)") {
                $NewLine = "    $($Update.NewValue)"
                Write-Host "    ✔ $($Update.Field)" -ForegroundColor DarkGreen
                $Updated = $true
                $UpdatedCount++
                $NewLine
                break
            }
        }
        if (-not $Updated) { $Line }
    }
)

# Write updated config back to file
Set-Content -Path $ConfigPath -Value $UpdatedLines -Encoding UTF8 -ErrorAction Stop

if ($UpdatedCount -eq $UpdatesNeeded.Count) {
    Write-Success "Config file updated with $UpdatedCount values"
}
else {
    Write-Warn "Config file updated but only $UpdatedCount of $($UpdatesNeeded.Count) expected values were found"
}

# ─── 9. Summary ──────────────────────────────────────────────────────────────

Write-Host "`n" -NoNewline
Write-Host ('═' * 70) -ForegroundColor Cyan
Write-Host '  SERVICE PRINCIPAL SETUP COMPLETE' -ForegroundColor Green
Write-Host ('═' * 70) -ForegroundColor Cyan
Write-Host @"

  Display Name           : $AppDisplayName
  Application (Client) Id: $AppId
  Tenant Id              : $TenantId
  Tenant Domain          : $TenantDomain
  SP Object Id           : $($SP.Id)
  Certificate Thumbprint : $($Cert.Thumbprint)
  PFX Path               : $PfxPath
  Permissions Granted    : $TotalPermissionCount across $($RequiredResourceAccess.Count) APIs
  Directory Roles        : Exchange Administrator, Compliance Administrator, SharePoint Administrator, Global Reader, Teams Administrator
  Config Updated         : $ConfigPath

  ► NEXT STEP: Run 2_DSC-Export.ps1 to export the tenant configuration:
    .\2_DSC-Export.ps1 -TenantName $TenantDomain -ApplicationId $AppId -CertificateThumbprint $($Cert.Thumbprint)
"@

Disconnect-MgGraph | Out-Null
Write-Success 'Disconnected from Microsoft Graph'
