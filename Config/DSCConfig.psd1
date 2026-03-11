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
    ApplicationId         = 'a474ef76-a8b5-48bc-8c14-f94aa694782e'
    TenantId              = 'b3f0a9b8-5da5-4eac-acff-83059c4bbf17'
    TenantDomain          = 'arnetbiz.onmicrosoft.com'
    CertificateThumbprint = '4082F127F3705C7B20353A548FF1882AA6283631'
    CertificatePath       = 'C:\\\\Users\\\\Andre\\\\Git\\\\365DSC\\\\DSCExport\\\\..\\\\Config\\\\M365DSC-Assessment.pfx'
}
