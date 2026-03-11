@{
    # ─────────────────────────────────────────────────────────────────────────
    # DSCExport Pipeline – Configuration
    # ─────────────────────────────────────────────────────────────────────────
    # Used by the 3-step NCSC assessment process:
    #   Step 1: 1_Setup-DSCServicePrincipal.ps1  (creates app, writes creds)
    #   Step 2: 2_DSC-Export.ps1                 (uses creds via CLI params)
    #   Step 3: 3_GapAnalysis.ps1                (uses export file via CLI)

    # ── App Registration ───────────────────────────────────────────────────
    AppDisplayName = 'M365DSC-Assessment'

    # ── Credentials (populated automatically by Step 1) ────────────────────
    ApplicationId         = '68f8b6ff-a6bb-4f9b-a1d9-5a998d70f939'
    TenantId              = 'e96b6518-a046-4d95-aee0-64c8c94cf0d8'
    TenantDomain          = 'samplesandbox.onmicrosoft.com'
    CertificateThumbprint = '4082F127F3705C7B20353A548FF1882AA6283631'
    CertificatePath       = 'C:\\\\Users\\\\Andre\\\\Git\\\\365DSC\\\\DSCExport\\\\..\\\\Config\\\\M365DSC-Assessment.pfx'
}
