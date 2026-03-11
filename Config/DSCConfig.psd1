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
    ApplicationId         = 'edb4d3df-6eef-42f4-aa97-c7bb160832a2'
    TenantId              = '31df26f7-f5bb-4839-9cde-9e3c5589f7b4'
    TenantDomain          = 'q2bx.onmicrosoft.com'
    CertificateThumbprint = '4082F127F3705C7B20353A548FF1882AA6283631'
    CertificatePath       = 'C:\\\\Users\\\\Andre\\\\Git\\\\365DSC\\\\DSCExport\\\\..\\\\Config\\\\M365DSC-Assessment.pfx'
}
