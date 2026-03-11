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
    ApplicationId         = '39dc85a5-1759-4254-8cfa-135ac30b5452'
    TenantId              = '31df26f7-f5bb-4839-9cde-9e3c5589f7b4'
    TenantDomain          = 'q2bx.onmicrosoft.com'
    CertificateThumbprint = 'F4F5A4AA988A3926EAF07EA204A19CF606701458'
    CertificatePath       = 'C:\\\\Users\\\\Andre\\\\Git\\\\365DSC\\\\DSCExport\\\\..\\\\Config\\\\M365DSC-Assessment.pfx'
}
