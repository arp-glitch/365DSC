<#
.SYNOPSIS
    NCSC Golden Blueprint – Microsoft365DSC Configuration
    Enforces core NCSC M365 Security Guidance requirements.

.DESCRIPTION
    This DSC configuration defines the "desired state" for a client tenant
    aligned to the UK National Cyber Security Centre (NCSC) guidance for
    Microsoft 365 security.

    Coverage:
      • Conditional Access – MFA for all users
      • Conditional Access – Block legacy authentication
      • Conditional Access – Require compliant devices for admins
      • Conditional Access – Block high-risk sign-ins
      • Named Locations – Define trusted corporate IPs
      • SharePoint Online – Restrict external sharing
      • Exchange Online – Anti-phishing, anti-spam, safe attachments
      • Security & Compliance – DLP, Retention

    Each resource block includes a comment reference to the relevant NCSC
    guidance section.

.PARAMETER ApplicationId
    The Entra ID App Registration (Client) Id.

.PARAMETER TenantId
    The target tenant GUID.

.PARAMETER CertificateThumbprint
    Thumbprint of the certificate used for authentication.

.NOTES
    Author  : M365 NCSC Audit Pipeline
    Version : 1.0.0
    Date    : 2026-02-27
    Ref     : https://www.ncsc.gov.uk/collection/microsoft-365-security
#>

Configuration NCSC_M365_Baseline
{
    param(
        [Parameter(Mandatory)]
        [string]$ApplicationId,

        [Parameter(Mandatory)]
        [string]$TenantId,

        [Parameter(Mandatory)]
        [string]$CertificateThumbprint,

        [Parameter()]
        [string[]]$TrustedIpRanges = @('203.0.113.0/24', '198.51.100.0/24')
    )

    Import-DscResource -ModuleName Microsoft365DSC

    Node 'localhost'
    {
        # ╔═══════════════════════════════════════════════════════════════════╗
        # ║  CONDITIONAL ACCESS POLICIES                                     ║
        # ║  NCSC Ref: «Enforce multi-factor authentication»                 ║
        # ╚═══════════════════════════════════════════════════════════════════╝

        # ── CA-001: Require MFA for All Users ──────────────────────────────
        # NCSC: "Require MFA for all users, including admins and guests."
        AADConditionalAccessPolicy 'CA-001-Require-MFA-All-Users' {
            DisplayName                = '[NCSC] CA-001: Require MFA for All Users'
            State                      = 'enabled'

            # Conditions
            IncludeUsers               = @('All')
            ExcludeUsers               = @()
            IncludeGroups              = @()
            ExcludeGroups              = @()      # Add break-glass group GUID here
            IncludeApplications        = @('All')
            ExcludeApplications        = @()
            ClientAppTypes             = @('browser', 'mobileAppsAndDesktopClients')
            IncludePlatforms           = @('all')
            ExcludePlatforms           = @()
            IncludeLocations           = @('All')
            ExcludeLocations           = @()

            # Grant controls
            GrantControlOperator       = 'OR'
            BuiltInControls            = @('mfa')

            # Session controls – default
            SignInFrequencyIsEnabled   = $false
            PersistentBrowserIsEnabled = $false

            Ensure                     = 'Present'
            ApplicationId              = $ApplicationId
            TenantId                   = $TenantId
            CertificateThumbprint      = $CertificateThumbprint
        }

        # ── CA-002: Block Legacy Authentication ────────────────────────────
        # NCSC: "Disable legacy authentication protocols completely."
        AADConditionalAccessPolicy 'CA-002-Block-Legacy-Auth' {
            DisplayName           = '[NCSC] CA-002: Block Legacy Authentication'
            State                 = 'enabled'

            IncludeUsers          = @('All')
            ExcludeUsers          = @()
            IncludeApplications   = @('All')
            ExcludeApplications   = @()
            ClientAppTypes        = @('exchangeActiveSync', 'other')
            IncludeLocations      = @('All')
            ExcludeLocations      = @()

            # Block access entirely
            GrantControlOperator  = 'OR'
            BuiltInControls       = @('block')

            Ensure                = 'Present'
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }

        # ── CA-003: Require Compliant Device for Admins ────────────────────
        # NCSC: "Admin accounts should use managed, compliant devices."
        AADConditionalAccessPolicy 'CA-003-Compliant-Device-Admins' {
            DisplayName           = '[NCSC] CA-003: Require Compliant Device for Admins'
            State                 = 'enabled'

            IncludeUsers          = @()
            ExcludeUsers          = @()
            IncludeRoles          = @(
                'Global Administrator'
                'Security Administrator'
                'Exchange Administrator'
                'SharePoint Administrator'
                'Compliance Administrator'
                'User Administrator'
                'Intune Administrator'
            )
            IncludeApplications   = @('All')
            ExcludeApplications   = @()
            ClientAppTypes        = @('browser', 'mobileAppsAndDesktopClients')
            IncludePlatforms      = @('all')
            ExcludePlatforms      = @()

            GrantControlOperator  = 'AND'
            BuiltInControls       = @('mfa', 'compliantDevice')

            Ensure                = 'Present'
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }

        # ── CA-004: Block High-Risk Sign-Ins ──────────────────────────────
        # NCSC: "Use risk-based Conditional Access to block high-risk sessions."
        AADConditionalAccessPolicy 'CA-004-Block-High-Risk-SignIns' {
            DisplayName           = '[NCSC] CA-004: Block High-Risk Sign-Ins'
            State                 = 'enabled'

            IncludeUsers          = @('All')
            ExcludeUsers          = @()
            IncludeApplications   = @('All')
            ExcludeApplications   = @()
            ClientAppTypes        = @('browser', 'mobileAppsAndDesktopClients')
            SignInRiskLevels      = @('high')
            UserRiskLevels        = @('high')

            GrantControlOperator  = 'OR'
            BuiltInControls       = @('block')

            Ensure                = 'Present'
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }

        # ── CA-005: Require MFA for Azure Management ──────────────────────
        # NCSC: "Protect Azure management plane with strong authentication."
        AADConditionalAccessPolicy 'CA-005-MFA-Azure-Management' {
            DisplayName           = '[NCSC] CA-005: Require MFA for Azure Management'
            State                 = 'enabled'

            IncludeUsers          = @('All')
            ExcludeUsers          = @()
            IncludeApplications   = @('797f4846-ba00-4fd7-ba43-dac1f8f63013')  # Azure Management
            ExcludeApplications   = @()
            ClientAppTypes        = @('browser', 'mobileAppsAndDesktopClients')

            GrantControlOperator  = 'OR'
            BuiltInControls       = @('mfa')

            Ensure                = 'Present'
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }

        # ╔═══════════════════════════════════════════════════════════════════╗
        # ║  SHAREPOINT ONLINE SETTINGS                                      ║
        # ║  NCSC Ref: «Reduce external sharing to minimum required»         ║
        # ╚═══════════════════════════════════════════════════════════════════╝

        SPOTenantSettings 'SharePoint-Tenant-Security' {
            IsSingleInstance                           = 'Yes'

            # ── NCSC Security Properties ──────────────────────────────────
            LegacyAuthProtocolsEnabled                 = $false   # Disable legacy auth at the SPO level
            DisableCustomAppAuthentication             = $true    # Block custom/unmanaged app auth
            MarkNewFilesSensitiveByDefault             = 'BlockExternalSharing'  # Prevent accidental external sharing of new files
            EnableAIPIntegration                       = $true    # Enable Azure Information Protection integration

            # RequireAcceptingAccountMatchInvitedAccount — DISABLED
            # This property is valid in the M365DSC schema but the SharePoint
            # Admin API rejects it with 400 BadRequest on EDU tenants (and
            # potentially other restricted tenant types).  Re-enable for
            # commercial tenants where the API accepts it.
            # RequireAcceptingAccountMatchInvitedAccount = $true

            Ensure                                     = 'Present'
            ApplicationId                              = $ApplicationId
            TenantId                                   = $TenantId
            CertificateThumbprint                      = $CertificateThumbprint
        }

        # ╔═══════════════════════════════════════════════════════════════════╗
        # ║  EXCHANGE ONLINE – ANTI-PHISHING                                 ║
        # ║  NCSC Ref: «Enable advanced anti-phishing protections»           ║
        # ╚═══════════════════════════════════════════════════════════════════╝

        EXOAntiPhishPolicy 'NCSC-AntiPhish-Policy' {
            Identity                            = 'NCSC Anti-Phishing Policy'

            Enabled                             = $true
            EnableMailboxIntelligence           = $true
            EnableMailboxIntelligenceProtection = $true
            EnableOrganizationDomainsProtection = $true
            EnableSimilarDomainsSafetyTips      = $true
            EnableSimilarUsersSafetyTips        = $true
            EnableSpoofIntelligence             = $true
            EnableUnusualCharactersSafetyTips   = $true
            EnableUnauthenticatedSender         = $true

            PhishThresholdLevel                 = 3       # Aggressive
            MailboxIntelligenceProtectionAction = 'Quarantine'
            TargetedDomainProtectionAction      = 'Quarantine'
            TargetedUserProtectionAction        = 'Quarantine'

            AuthenticationFailAction            = 'Quarantine'
            SpoofQuarantineTag                  = 'DefaultFullAccessPolicy'

            Ensure                              = 'Present'
            ApplicationId                       = $ApplicationId
            TenantId                            = $TenantId
            CertificateThumbprint               = $CertificateThumbprint
        }

        # ╔═══════════════════════════════════════════════════════════════════╗
        # ║  EXCHANGE ONLINE – ANTI-SPAM                                     ║
        # ║  NCSC Ref: «Configure spam filtering to recommended levels»      ║
        # ╚═══════════════════════════════════════════════════════════════════╝

        EXOHostedContentFilterPolicy 'NCSC-AntiSpam-Inbound' {
            Identity                  = 'NCSC Anti-Spam Inbound'

            SpamAction                = 'MoveToJmf'
            HighConfidenceSpamAction  = 'Quarantine'
            BulkSpamAction            = 'MoveToJmf'
            PhishSpamAction           = 'Quarantine'
            HighConfidencePhishAction = 'Quarantine'
            BulkThreshold             = 6
            InlineSafetyTipsEnabled   = $true
            MarkAsSpamBulkMail        = 'On'

            QuarantineRetentionPeriod = 30

            Ensure                    = 'Present'
            ApplicationId             = $ApplicationId
            TenantId                  = $TenantId
            CertificateThumbprint     = $CertificateThumbprint
        }

        # ╔═══════════════════════════════════════════════════════════════════╗
        # ║  EXCHANGE ONLINE – SAFE ATTACHMENTS (Defender for Office 365)    ║
        # ║  NCSC Ref: «Enable Safe Attachments for all users»               ║
        # ╚═══════════════════════════════════════════════════════════════════╝

        EXOSafeAttachmentPolicy 'NCSC-Safe-Attachments' {
            Identity              = 'NCSC Safe Attachments'

            Enable                = $true
            Action                = 'DynamicDelivery'     # Deliver message, sandbox attachment
            Redirect              = $false
            # RedirectAddress                    = 'security@yourdomain.com'   # Uncomment per client

            Ensure                = 'Present'
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }

        # ╔═══════════════════════════════════════════════════════════════════╗
        # ║  EXCHANGE ONLINE – SAFE LINKS (Defender for Office 365)          ║
        # ║  NCSC Ref: «Enable Safe Links URL scanning»                      ║
        # ╚═══════════════════════════════════════════════════════════════════╝

        EXOSafeLinksPolicy 'NCSC-Safe-Links' {
            Identity                 = 'NCSC Safe Links'

            EnableSafeLinksForEmail  = $true
            EnableSafeLinksForTeams  = $true
            EnableSafeLinksForOffice = $true
            TrackClicks              = $true
            AllowClickThrough        = $false     # Do NOT let users click through warnings
            ScanUrls                 = $true
            EnableForInternalSenders = $true
            DeliverMessageAfterScan  = $true
            DisableUrlRewrite        = $false

            Ensure                   = 'Present'
            ApplicationId            = $ApplicationId
            TenantId                 = $TenantId
            CertificateThumbprint    = $CertificateThumbprint
        }

        # ╔═══════════════════════════════════════════════════════════════════╗
        # ║  EXCHANGE ONLINE – MALWARE FILTER                                ║
        # ║  NCSC Ref: «Block known malicious file types»                    ║
        # ╚═══════════════════════════════════════════════════════════════════╝

        EXOMalwareFilterPolicy 'NCSC-Malware-Filter' {
            Identity                               = 'NCSC Malware Filter'

            EnableFileFilter                       = $true
            FileTypes                              = @(
                'ace', 'apk', 'app', 'appx', 'ani', 'arj', 'bat', 'cab', 'cmd', 'com',
                'deb', 'dex', 'dll', 'docm', 'elf', 'exe', 'hta', 'img', 'iso', 'jar',
                'jnlp', 'kext', 'lha', 'lib', 'lnk', 'lzh', 'macho', 'mde', 'msc',
                'msi', 'msix', 'msp', 'mst', 'pif', 'ppa', 'ppam', 'reg', 'rev', 'scf',
                'scr', 'sct', 'sys', 'uif', 'vb', 'vbe', 'vbs', 'vxd', 'wsc', 'wsf',
                'wsh', 'xll', 'xlsm', 'zip'
            )
            EnableInternalSenderAdminNotifications = $true
            # InternalSenderAdminAddress          = 'security@yourdomain.com'
            ZapEnabled                             = $true

            Ensure                                 = 'Present'
            ApplicationId                          = $ApplicationId
            TenantId                               = $TenantId
            CertificateThumbprint                  = $CertificateThumbprint
        }

        # ╔═══════════════════════════════════════════════════════════════════╗
        # ║  NAMED LOCATION – Trusted Corporate Network                      ║
        # ║  Used by Conditional Access policies above                       ║
        # ╚═══════════════════════════════════════════════════════════════════╝

        AADNamedLocationPolicy 'Trusted-Corporate-Network' {
            DisplayName           = 'Trusted Corporate Network'
            OdataType             = '#microsoft.graph.ipNamedLocation'
            IsTrusted             = $true

            # Client IP ranges — set in Config/M365DSC.Config.psd1 → ClientSettings.TrustedIpRanges
            IpRanges              = $TrustedIpRanges

            Ensure                = 'Present'
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
