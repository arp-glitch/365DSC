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
    ApplicationId         = ''
    TenantId              = ''
    TenantDomain          = ''
    CertificateThumbprint = ''
    CertificatePath       = ''
}
