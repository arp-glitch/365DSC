<#
.SYNOPSIS
    Exports the current M365 tenant configuration using Microsoft365DSC.

.DESCRIPTION
    Runs Export-M365DSCConfiguration to extract the current state of the
    target tenant for the workloads required by the NCSC blueprint assessment.

    This is Step 2 of the 3-step NCSC assessment process:
      Step 1: Setup Service Principal (1_Setup-DSCServicePrincipal.ps1)
      Step 2: Export tenant configuration (this script)
      Step 3: Gap analysis against NCSC blueprint (3_GapAnalysis.ps1)

.PARAMETER TenantName
    The tenant domain name (e.g. contoso.onmicrosoft.com).

.PARAMETER ApplicationId
    The Entra ID App Registration (Client) Id created in Step 1.

.PARAMETER CertificateThumbprint
    Thumbprint of the certificate created in Step 1.

.PARAMETER Path
    Output directory for the export. Defaults to current directory.

.PARAMETER FileName
    Output filename for the exported configuration.

.EXAMPLE
    .\2_DSC-Export.ps1 -TenantName contoso.onmicrosoft.com -ApplicationId <guid> -CertificateThumbprint <thumbprint>

.NOTES
    Author  : M365 NCSC Audit Pipeline
    Version : 1.1.0
    Date    : 2026-03-10
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]$TenantName,

    [Parameter(Mandatory = $true)]
    [string]$ApplicationId,

    [Parameter(Mandatory = $true)]
    [string]$CertificateThumbprint,

    [Parameter(Mandatory = $false)]
    [string]$Path = ".",

    [Parameter(Mandatory = $false)]
    [string]$FileName = "export.ps1"
)

# Components aligned with NCSC_M365_Baseline.ps1 blueprint resource types
Export-M365DSCConfiguration `
    -Components @("AADConditionalAccessPolicy", "AADNamedLocationPolicy", "AADPasswordRuleSettings", "AADTokenLifetimePolicy", "EXOTransportRule", "EXOAntiPhishPolicy", "EXOHostedContentFilterPolicy", "EXOMalwareFilterPolicy", "EXOSafeAttachmentPolicy", "EXOSafeLinksPolicy", "IntuneDeviceCompliancePolicyWindows10", "SPOSharingSettings", "SPOTenantSettings", "SCDLPCompliancePolicy", "SCRetentionCompliancePolicy", "SCLabelPolicy", "TeamsMessagingPolicy") `
    -ApplicationId $ApplicationId `
    -TenantId $TenantName `
    -CertificateThumbprint $CertificateThumbprint `
    -Path $Path `
    -FileName $FileName

Write-Host "`n► NEXT STEP: Run 3_GapAnalysis.ps1 to compare the export against the NCSC blueprint." -ForegroundColor Cyan
