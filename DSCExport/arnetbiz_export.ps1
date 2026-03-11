# Generated with Microsoft365DSC version 1.26.218.1
# For additional information on how to use Microsoft365DSC, please visit https://aka.ms/M365DSC
param (
)

Configuration arnetbiz_export
{
    param (
    )

    $OrganizationName = $ConfigurationData.NonNodeData.OrganizationName

    Import-DscResource -ModuleName 'Microsoft365DSC' -ModuleVersion '1.26.218.1'

    Node localhost
    {
        AADConditionalAccessPolicy "AADConditionalAccessPolicy-Block Legacy Auth"
        {
            ApplicationEnforcedRestrictionsIsEnabled = $False;
            ApplicationId                            = $ConfigurationData.NonNodeData.ApplicationId;
            AuthenticationContexts                   = @();
            BuiltInControls                          = @("block");
            CertificateThumbprint                    = $ConfigurationData.NonNodeData.CertificateThumbprint;
            ClientAppTypes                           = @("exchangeActiveSync","other");
            CloudAppSecurityIsEnabled                = $False;
            CloudAppSecurityType                     = "";
            CustomAuthenticationFactors              = @();
            DeviceFilterRule                         = "";
            DisplayName                              = "Block Legacy Auth";
            Ensure                                   = "Present";
            ExcludeApplications                      = @();
            ExcludeExternalTenantsMembers            = @();
            ExcludeExternalTenantsMembershipKind     = "";
            ExcludeGroups                            = @();
            ExcludeLocations                         = @();
            ExcludePlatforms                         = @();
            ExcludeRoles                             = @();
            ExcludeUsers                             = @("andre@ar-net.biz");
            GrantControlOperator                     = "OR";
            Id                                       = "0e558d63-3520-46a0-b10a-edced9aca2b3";
            IncludeApplications                      = @("All");
            IncludeExternalTenantsMembers            = @();
            IncludeExternalTenantsMembershipKind     = "";
            IncludeGroups                            = @();
            IncludeLocations                         = @();
            IncludePlatforms                         = @();
            IncludeRoles                             = @();
            IncludeUserActions                       = @();
            IncludeUsers                             = @("All");
            PersistentBrowserIsEnabled               = $False;
            PersistentBrowserMode                    = "";
            ProtocolFlows                            = @();
            SecureSignInSessionIsEnabled             = $False;
            ServicePrincipalRiskLevels               = @();
            SignInFrequencyIsEnabled                 = $False;
            SignInFrequencyType                      = "";
            SignInRiskLevels                         = @();
            State                                    = "enabled";
            TenantId                                 = $OrganizationName;
            TransferMethods                          = "";
            UserRiskLevels                           = @();
        }
        AADConditionalAccessPolicy "AADConditionalAccessPolicy-Require MFA for Admins"
        {
            ApplicationEnforcedRestrictionsIsEnabled = $False;
            ApplicationId                            = $ConfigurationData.NonNodeData.ApplicationId;
            AuthenticationContexts                   = @();
            BuiltInControls                          = @("mfa");
            CertificateThumbprint                    = $ConfigurationData.NonNodeData.CertificateThumbprint;
            ClientAppTypes                           = @("all");
            CloudAppSecurityIsEnabled                = $False;
            CloudAppSecurityType                     = "";
            CustomAuthenticationFactors              = @();
            DeviceFilterRule                         = "";
            DisplayName                              = "Require MFA for Admins";
            Ensure                                   = "Present";
            ExcludeApplications                      = @();
            ExcludeExternalTenantsMembers            = @();
            ExcludeExternalTenantsMembershipKind     = "";
            ExcludeGroups                            = @();
            ExcludeLocations                         = @();
            ExcludePlatforms                         = @();
            ExcludeRoles                             = @();
            ExcludeUsers                             = @();
            GrantControlOperator                     = "OR";
            Id                                       = "4fa315eb-ab86-4f52-87a6-1795568c2a19";
            IncludeApplications                      = @("All");
            IncludeExternalTenantsMembers            = @();
            IncludeExternalTenantsMembershipKind     = "";
            IncludeGroups                            = @();
            IncludeLocations                         = @();
            IncludePlatforms                         = @();
            IncludeRoles                             = @("Authentication Administrator","Billing Administrator","Conditional Access Administrator","Exchange Administrator","Global Administrator","Helpdesk Administrator","Intune Administrator","Password Administrator","Security Administrator","SharePoint Administrator","Teams Administrator","Skype for Business Administrator","User Administrator","Application Administrator");
            IncludeUserActions                       = @();
            IncludeUsers                             = @();
            PersistentBrowserIsEnabled               = $False;
            PersistentBrowserMode                    = "";
            ProtocolFlows                            = @();
            SecureSignInSessionIsEnabled             = $False;
            ServicePrincipalRiskLevels               = @();
            SignInFrequencyIsEnabled                 = $False;
            SignInFrequencyType                      = "";
            SignInRiskLevels                         = @();
            State                                    = "enabled";
            TenantId                                 = $OrganizationName;
            TransferMethods                          = "";
            UserRiskLevels                           = @();
        }
        AADConditionalAccessPolicy "AADConditionalAccessPolicy-Require MFA for Azure mgmt"
        {
            ApplicationEnforcedRestrictionsIsEnabled = $False;
            ApplicationId                            = $ConfigurationData.NonNodeData.ApplicationId;
            AuthenticationContexts                   = @();
            BuiltInControls                          = @("mfa");
            CertificateThumbprint                    = $ConfigurationData.NonNodeData.CertificateThumbprint;
            ClientAppTypes                           = @("all");
            CloudAppSecurityIsEnabled                = $False;
            CloudAppSecurityType                     = "";
            CustomAuthenticationFactors              = @();
            DeviceFilterRule                         = "";
            DisplayName                              = "Require MFA for Azure mgmt";
            Ensure                                   = "Present";
            ExcludeApplications                      = @();
            ExcludeExternalTenantsMembers            = @();
            ExcludeExternalTenantsMembershipKind     = "";
            ExcludeGroups                            = @();
            ExcludeLocations                         = @();
            ExcludePlatforms                         = @();
            ExcludeRoles                             = @();
            ExcludeUsers                             = @();
            GrantControlOperator                     = "OR";
            Id                                       = "af1feed1-3f63-4f98-832c-863b825eceee";
            IncludeApplications                      = @("797f4846-ba00-4fd7-ba43-dac1f8f63013");
            IncludeExternalTenantsMembers            = @();
            IncludeExternalTenantsMembershipKind     = "";
            IncludeGroups                            = @();
            IncludeLocations                         = @();
            IncludePlatforms                         = @();
            IncludeRoles                             = @();
            IncludeUserActions                       = @();
            IncludeUsers                             = @("All");
            PersistentBrowserIsEnabled               = $False;
            PersistentBrowserMode                    = "";
            ProtocolFlows                            = @();
            SecureSignInSessionIsEnabled             = $False;
            ServicePrincipalRiskLevels               = @();
            SignInFrequencyIsEnabled                 = $False;
            SignInFrequencyType                      = "";
            SignInRiskLevels                         = @();
            State                                    = "enabled";
            TenantId                                 = $OrganizationName;
            TransferMethods                          = "";
            UserRiskLevels                           = @();
        }
        AADConditionalAccessPolicy "AADConditionalAccessPolicy-Require MFA for All Users"
        {
            ApplicationEnforcedRestrictionsIsEnabled = $False;
            ApplicationId                            = $ConfigurationData.NonNodeData.ApplicationId;
            AuthenticationContexts                   = @();
            BuiltInControls                          = @("mfa");
            CertificateThumbprint                    = $ConfigurationData.NonNodeData.CertificateThumbprint;
            ClientAppTypes                           = @("browser","mobileAppsAndDesktopClients");
            CloudAppSecurityIsEnabled                = $False;
            CloudAppSecurityType                     = "";
            CustomAuthenticationFactors              = @();
            DeviceFilterRule                         = "";
            DisplayName                              = "Require MFA for All Users";
            Ensure                                   = "Present";
            ExcludeApplications                      = @();
            ExcludeExternalTenantsMembers            = @();
            ExcludeExternalTenantsMembershipKind     = "";
            ExcludeGroups                            = @();
            ExcludeLocations                         = @();
            ExcludePlatforms                         = @();
            ExcludeRoles                             = @();
            ExcludeUsers                             = @();
            GrantControlOperator                     = "OR";
            Id                                       = "fce8ffa1-a0ed-4716-977e-537b0510ace6";
            IncludeApplications                      = @("All");
            IncludeExternalTenantsMembers            = @();
            IncludeExternalTenantsMembershipKind     = "";
            IncludeGroups                            = @();
            IncludeLocations                         = @();
            IncludePlatforms                         = @();
            IncludeRoles                             = @();
            IncludeUserActions                       = @();
            IncludeUsers                             = @("All");
            PersistentBrowserIsEnabled               = $False;
            PersistentBrowserMode                    = "";
            ProtocolFlows                            = @();
            SecureSignInSessionIsEnabled             = $False;
            ServicePrincipalRiskLevels               = @();
            SignInFrequencyIsEnabled                 = $False;
            SignInFrequencyType                      = "";
            SignInRiskLevels                         = @();
            State                                    = "enabled";
            TenantId                                 = $OrganizationName;
            TransferMethods                          = "";
            UserRiskLevels                           = @();
        }
        AADConditionalAccessPolicy "AADConditionalAccessPolicy-Combined Security Info Registration with TAP"
        {
            ApplicationEnforcedRestrictionsIsEnabled = $False;
            ApplicationId                            = $ConfigurationData.NonNodeData.ApplicationId;
            AuthenticationContexts                   = @();
            BuiltInControls                          = @("mfa");
            CertificateThumbprint                    = $ConfigurationData.NonNodeData.CertificateThumbprint;
            ClientAppTypes                           = @("all");
            CloudAppSecurityIsEnabled                = $False;
            CloudAppSecurityType                     = "";
            CustomAuthenticationFactors              = @();
            DeviceFilterRule                         = "";
            DisplayName                              = "Combined Security Info Registration with TAP";
            Ensure                                   = "Present";
            ExcludeApplications                      = @();
            ExcludeExternalTenantsMembers            = @();
            ExcludeExternalTenantsMembershipKind     = "";
            ExcludeGroups                            = @();
            ExcludeLocations                         = @();
            ExcludePlatforms                         = @();
            ExcludeRoles                             = @();
            ExcludeUsers                             = @("GuestsOrExternalUsers");
            GrantControlOperator                     = "OR";
            Id                                       = "a9e5fc76-057f-4c5f-be6c-a71187a7d682";
            IncludeApplications                      = @();
            IncludeExternalTenantsMembers            = @();
            IncludeExternalTenantsMembershipKind     = "";
            IncludeGroups                            = @();
            IncludeLocations                         = @();
            IncludePlatforms                         = @();
            IncludeRoles                             = @();
            IncludeUserActions                       = @("urn:user:registersecurityinfo");
            IncludeUsers                             = @("All");
            PersistentBrowserIsEnabled               = $False;
            PersistentBrowserMode                    = "";
            ProtocolFlows                            = @();
            SecureSignInSessionIsEnabled             = $False;
            ServicePrincipalRiskLevels               = @();
            SignInFrequencyIsEnabled                 = $False;
            SignInFrequencyType                      = "";
            SignInRiskLevels                         = @();
            State                                    = "enabledForReportingButNotEnforced";
            TenantId                                 = $OrganizationName;
            TransferMethods                          = "";
            UserRiskLevels                           = @();
        }
        AADConditionalAccessPolicy "AADConditionalAccessPolicy-Block access except from UK"
        {
            ApplicationEnforcedRestrictionsIsEnabled = $False;
            ApplicationId                            = $ConfigurationData.NonNodeData.ApplicationId;
            AuthenticationContexts                   = @();
            BuiltInControls                          = @("block");
            CertificateThumbprint                    = $ConfigurationData.NonNodeData.CertificateThumbprint;
            ClientAppTypes                           = @("all");
            CloudAppSecurityIsEnabled                = $False;
            CloudAppSecurityType                     = "";
            CustomAuthenticationFactors              = @();
            DeviceFilterRule                         = "";
            DisplayName                              = "Block access except from UK";
            Ensure                                   = "Present";
            ExcludeApplications                      = @();
            ExcludeExternalTenantsMembers            = @();
            ExcludeExternalTenantsMembershipKind     = "";
            ExcludeGroups                            = @();
            ExcludeLocations                         = @("UK Only");
            ExcludePlatforms                         = @();
            ExcludeRoles                             = @();
            ExcludeUsers                             = @("andre@ar-net.biz");
            GrantControlOperator                     = "OR";
            Id                                       = "9b4590a2-4a8d-49be-a1bc-92a082dd874f";
            IncludeApplications                      = @("All");
            IncludeExternalTenantsMembers            = @();
            IncludeExternalTenantsMembershipKind     = "";
            IncludeGroups                            = @();
            IncludeLocations                         = @("All");
            IncludePlatforms                         = @();
            IncludeRoles                             = @();
            IncludeUserActions                       = @();
            IncludeUsers                             = @("All");
            PersistentBrowserIsEnabled               = $False;
            PersistentBrowserMode                    = "";
            ProtocolFlows                            = @();
            SecureSignInSessionIsEnabled             = $False;
            ServicePrincipalRiskLevels               = @();
            SignInFrequencyIsEnabled                 = $False;
            SignInFrequencyType                      = "";
            SignInRiskLevels                         = @();
            State                                    = "enabledForReportingButNotEnforced";
            TenantId                                 = $OrganizationName;
            TransferMethods                          = "";
            UserRiskLevels                           = @();
        }
        AADConditionalAccessPolicy "AADConditionalAccessPolicy-MCAS CA"
        {
            ApplicationEnforcedRestrictionsIsEnabled = $False;
            ApplicationId                            = $ConfigurationData.NonNodeData.ApplicationId;
            AuthenticationContexts                   = @();
            BuiltInControls                          = @();
            CertificateThumbprint                    = $ConfigurationData.NonNodeData.CertificateThumbprint;
            ClientAppTypes                           = @("all");
            CloudAppSecurityIsEnabled                = $True;
            CloudAppSecurityType                     = "mcasConfigured";
            CustomAuthenticationFactors              = @();
            DeviceFilterRule                         = "";
            DisplayName                              = "MCAS CA";
            Ensure                                   = "Present";
            ExcludeApplications                      = @();
            ExcludeExternalTenantsMembers            = @();
            ExcludeExternalTenantsMembershipKind     = "";
            ExcludeGroups                            = @();
            ExcludeLocations                         = @();
            ExcludePlatforms                         = @();
            ExcludeRoles                             = @();
            ExcludeUsers                             = @();
            Id                                       = "509de6bd-a9dd-47c2-a21a-36717493bf3c";
            IncludeApplications                      = @("All");
            IncludeExternalTenantsMembers            = @();
            IncludeExternalTenantsMembershipKind     = "";
            IncludeGroups                            = @();
            IncludeLocations                         = @();
            IncludePlatforms                         = @();
            IncludeRoles                             = @();
            IncludeUserActions                       = @();
            IncludeUsers                             = @("All");
            PersistentBrowserIsEnabled               = $False;
            PersistentBrowserMode                    = "";
            ProtocolFlows                            = @();
            SecureSignInSessionIsEnabled             = $False;
            ServicePrincipalRiskLevels               = @();
            SignInFrequencyIsEnabled                 = $False;
            SignInFrequencyType                      = "";
            SignInRiskLevels                         = @();
            State                                    = "enabled";
            TenantId                                 = $OrganizationName;
            TransferMethods                          = "";
            UserRiskLevels                           = @();
        }
        AADConditionalAccessPolicy "AADConditionalAccessPolicy-Block all legacy sign-ins that don't support MFA"
        {
            ApplicationEnforcedRestrictionsIsEnabled = $False;
            ApplicationId                            = $ConfigurationData.NonNodeData.ApplicationId;
            AuthenticationContexts                   = @();
            BuiltInControls                          = @("block");
            CertificateThumbprint                    = $ConfigurationData.NonNodeData.CertificateThumbprint;
            ClientAppTypes                           = @("exchangeActiveSync","other");
            CloudAppSecurityIsEnabled                = $False;
            CloudAppSecurityType                     = "";
            CustomAuthenticationFactors              = @();
            DeviceFilterRule                         = "";
            DisplayName                              = "Block all legacy sign-ins that don't support MFA";
            Ensure                                   = "Present";
            ExcludeApplications                      = @();
            ExcludeExternalTenantsMembers            = @();
            ExcludeExternalTenantsMembershipKind     = "";
            ExcludeGroups                            = @();
            ExcludeLocations                         = @();
            ExcludePlatforms                         = @();
            ExcludeRoles                             = @();
            ExcludeUsers                             = @("andre@ar-net.biz");
            GrantControlOperator                     = "OR";
            Id                                       = "f435f819-e9ce-4c50-81b5-20131d3ee019";
            IncludeApplications                      = @("All");
            IncludeExternalTenantsMembers            = @();
            IncludeExternalTenantsMembershipKind     = "";
            IncludeGroups                            = @();
            IncludeLocations                         = @();
            IncludePlatforms                         = @();
            IncludeRoles                             = @();
            IncludeUserActions                       = @();
            IncludeUsers                             = @("All");
            PersistentBrowserIsEnabled               = $False;
            PersistentBrowserMode                    = "";
            ProtocolFlows                            = @();
            SecureSignInSessionIsEnabled             = $False;
            ServicePrincipalRiskLevels               = @();
            SignInFrequencyIsEnabled                 = $False;
            SignInFrequencyType                      = "";
            SignInRiskLevels                         = @();
            State                                    = "enabled";
            TenantId                                 = $OrganizationName;
            TransferMethods                          = "";
            UserRiskLevels                           = @();
        }
        AADNamedLocationPolicy "AADNamedLocationPolicy-UK Only"
        {
            ApplicationId                     = $ConfigurationData.NonNodeData.ApplicationId;
            CertificateThumbprint             = $ConfigurationData.NonNodeData.CertificateThumbprint;
            CountriesAndRegions               = @("GB");
            CountryLookupMethod               = "clientIpAddress";
            DisplayName                       = "UK Only";
            Ensure                            = "Present";
            Id                                = "19f28f61-479f-4e2b-8e53-977c29046ebc";
            IncludeUnknownCountriesAndRegions = $False;
            OdataType                         = "#microsoft.graph.countryNamedLocation";
            TenantId                          = $OrganizationName;
        }
        AADNamedLocationPolicy "AADNamedLocationPolicy-Brazil Only"
        {
            ApplicationId                     = $ConfigurationData.NonNodeData.ApplicationId;
            CertificateThumbprint             = $ConfigurationData.NonNodeData.CertificateThumbprint;
            CountriesAndRegions               = @("BR");
            CountryLookupMethod               = "clientIpAddress";
            DisplayName                       = "Brazil Only";
            Ensure                            = "Present";
            Id                                = "168c3d31-14df-4f4d-a460-495395dda883";
            IncludeUnknownCountriesAndRegions = $False;
            OdataType                         = "#microsoft.graph.countryNamedLocation";
            TenantId                          = $OrganizationName;
        }
        AADPasswordRuleSettings "AADPasswordRuleSettings"
        {
            ApplicationId                       = $ConfigurationData.NonNodeData.ApplicationId;
            BannedPasswordCheckOnPremisesMode   = "Audit";
            BannedPasswordList                  = @("Password");
            CertificateThumbprint               = $ConfigurationData.NonNodeData.CertificateThumbprint;
            EnableBannedPasswordCheck           = $True;
            EnableBannedPasswordCheckOnPremises = $True;
            Ensure                              = "Present";
            IsSingleInstance                    = "Yes";
            LockoutDurationInSeconds            = "60";
            LockoutThreshold                    = "10";
            TenantId                            = $OrganizationName;
        }
        EXOAntiPhishPolicy "EXOAntiPhishPolicy-Office365 AntiPhish Default"
        {
            AdminDisplayName                              = "";
            ApplicationId                                 = $ConfigurationData.NonNodeData.ApplicationId;
            AuthenticationFailAction                      = "MoveToJmf";
            CertificateThumbprint                         = $ConfigurationData.NonNodeData.CertificateThumbprint;
            DmarcQuarantineAction                         = "Quarantine";
            DmarcRejectAction                             = "Reject";
            Enabled                                       = $True;
            EnableFirstContactSafetyTips                  = $False;
            EnableMailboxIntelligence                     = $True;
            EnableMailboxIntelligenceProtection           = $False;
            EnableOrganizationDomainsProtection           = $False;
            EnableSimilarDomainsSafetyTips                = $False;
            EnableSimilarUsersSafetyTips                  = $False;
            EnableSpoofIntelligence                       = $True;
            EnableTargetedDomainsProtection               = $False;
            EnableTargetedUserProtection                  = $False;
            EnableUnauthenticatedSender                   = $True;
            EnableUnusualCharactersSafetyTips             = $False;
            EnableViaTag                                  = $True;
            Ensure                                        = "Present";
            ExcludedDomains                               = @();
            ExcludedSenders                               = @();
            HonorDmarcPolicy                              = $True;
            Identity                                      = "Office365 AntiPhish Default";
            ImpersonationProtectionState                  = "Automatic";
            MailboxIntelligenceProtectionAction           = "NoAction";
            MailboxIntelligenceProtectionActionRecipients = @();
            MailboxIntelligenceQuarantineTag              = "DefaultFullAccessPolicy";
            MakeDefault                                   = $True;
            PhishThresholdLevel                           = 1;
            SpoofQuarantineTag                            = "DefaultFullAccessPolicy";
            TargetedDomainActionRecipients                = @();
            TargetedDomainProtectionAction                = "NoAction";
            TargetedDomainQuarantineTag                   = "DefaultFullAccessPolicy";
            TargetedDomainsToProtect                      = @();
            TargetedUserActionRecipients                  = @();
            TargetedUserProtectionAction                  = "NoAction";
            TargetedUserQuarantineTag                     = "DefaultFullAccessPolicy";
            TargetedUsersToProtect                        = @();
            TenantId                                      = $OrganizationName;
        }
        EXOAntiPhishPolicy "EXOAntiPhishPolicy-Anti-phishing policy"
        {
            AdminDisplayName                              = "";
            ApplicationId                                 = $ConfigurationData.NonNodeData.ApplicationId;
            AuthenticationFailAction                      = "MoveToJmf";
            CertificateThumbprint                         = $ConfigurationData.NonNodeData.CertificateThumbprint;
            DmarcQuarantineAction                         = "Quarantine";
            DmarcRejectAction                             = "Reject";
            Enabled                                       = $True;
            EnableFirstContactSafetyTips                  = $True;
            EnableMailboxIntelligence                     = $True;
            EnableMailboxIntelligenceProtection           = $True;
            EnableOrganizationDomainsProtection           = $True;
            EnableSimilarDomainsSafetyTips                = $True;
            EnableSimilarUsersSafetyTips                  = $False;
            EnableSpoofIntelligence                       = $True;
            EnableTargetedDomainsProtection               = $False;
            EnableTargetedUserProtection                  = $False;
            EnableUnauthenticatedSender                   = $True;
            EnableUnusualCharactersSafetyTips             = $True;
            EnableViaTag                                  = $True;
            Ensure                                        = "Present";
            ExcludedDomains                               = @();
            ExcludedSenders                               = @();
            HonorDmarcPolicy                              = $True;
            Identity                                      = "Anti-phishing policy";
            ImpersonationProtectionState                  = "Manual";
            MailboxIntelligenceProtectionAction           = "MoveToJmf";
            MailboxIntelligenceProtectionActionRecipients = @();
            MailboxIntelligenceQuarantineTag              = "DefaultFullAccessPolicy";
            MakeDefault                                   = $False;
            PhishThresholdLevel                           = 3;
            SpoofQuarantineTag                            = "DefaultFullAccessPolicy";
            TargetedDomainActionRecipients                = @();
            TargetedDomainProtectionAction                = "MoveToJmf";
            TargetedDomainQuarantineTag                   = "DefaultFullAccessPolicy";
            TargetedDomainsToProtect                      = @();
            TargetedUserActionRecipients                  = @();
            TargetedUserProtectionAction                  = "NoAction";
            TargetedUserQuarantineTag                     = "DefaultFullAccessPolicy";
            TargetedUsersToProtect                        = @();
            TenantId                                      = $OrganizationName;
        }
        EXOAntiPhishPolicy "EXOAntiPhishPolicy-Standard Preset Security Policy1646828621474"
        {
            AdminDisplayName                              = "";
            ApplicationId                                 = $ConfigurationData.NonNodeData.ApplicationId;
            AuthenticationFailAction                      = "MoveToJmf";
            CertificateThumbprint                         = $ConfigurationData.NonNodeData.CertificateThumbprint;
            DmarcQuarantineAction                         = "Quarantine";
            DmarcRejectAction                             = "Reject";
            Enabled                                       = $True;
            EnableFirstContactSafetyTips                  = $True;
            EnableMailboxIntelligence                     = $True;
            EnableMailboxIntelligenceProtection           = $True;
            EnableOrganizationDomainsProtection           = $True;
            EnableSimilarDomainsSafetyTips                = $True;
            EnableSimilarUsersSafetyTips                  = $True;
            EnableSpoofIntelligence                       = $True;
            EnableTargetedDomainsProtection               = $True;
            EnableTargetedUserProtection                  = $True;
            EnableUnauthenticatedSender                   = $True;
            EnableUnusualCharactersSafetyTips             = $True;
            EnableViaTag                                  = $True;
            Ensure                                        = "Present";
            ExcludedDomains                               = @();
            ExcludedSenders                               = @();
            HonorDmarcPolicy                              = $True;
            Identity                                      = "Standard Preset Security Policy1646828621474";
            ImpersonationProtectionState                  = "Automatic";
            MailboxIntelligenceProtectionAction           = "MoveToJmf";
            MailboxIntelligenceProtectionActionRecipients = @();
            MailboxIntelligenceQuarantineTag              = "DefaultFullAccessPolicy";
            MakeDefault                                   = $False;
            PhishThresholdLevel                           = 3;
            SpoofQuarantineTag                            = "DefaultFullAccessPolicy";
            TargetedDomainActionRecipients                = @();
            TargetedDomainProtectionAction                = "Quarantine";
            TargetedDomainQuarantineTag                   = "DefaultFullAccessWithNotificationPolicy";
            TargetedDomainsToProtect                      = @();
            TargetedUserActionRecipients                  = @();
            TargetedUserProtectionAction                  = "Quarantine";
            TargetedUserQuarantineTag                     = "DefaultFullAccessWithNotificationPolicy";
            TargetedUsersToProtect                        = @();
            TenantId                                      = $OrganizationName;
        }
        EXOAntiPhishPolicy "EXOAntiPhishPolicy-Strict Preset Security Policy1646828668302"
        {
            AdminDisplayName                              = "";
            ApplicationId                                 = $ConfigurationData.NonNodeData.ApplicationId;
            AuthenticationFailAction                      = "Quarantine";
            CertificateThumbprint                         = $ConfigurationData.NonNodeData.CertificateThumbprint;
            DmarcQuarantineAction                         = "Quarantine";
            DmarcRejectAction                             = "Reject";
            Enabled                                       = $True;
            EnableFirstContactSafetyTips                  = $False;
            EnableMailboxIntelligence                     = $True;
            EnableMailboxIntelligenceProtection           = $True;
            EnableOrganizationDomainsProtection           = $True;
            EnableSimilarDomainsSafetyTips                = $True;
            EnableSimilarUsersSafetyTips                  = $True;
            EnableSpoofIntelligence                       = $True;
            EnableTargetedDomainsProtection               = $True;
            EnableTargetedUserProtection                  = $True;
            EnableUnauthenticatedSender                   = $True;
            EnableUnusualCharactersSafetyTips             = $True;
            EnableViaTag                                  = $True;
            Ensure                                        = "Present";
            ExcludedDomains                               = @();
            ExcludedSenders                               = @();
            HonorDmarcPolicy                              = $True;
            Identity                                      = "Strict Preset Security Policy1646828668302";
            ImpersonationProtectionState                  = "Automatic";
            MailboxIntelligenceProtectionAction           = "Quarantine";
            MailboxIntelligenceProtectionActionRecipients = @();
            MailboxIntelligenceQuarantineTag              = "DefaultFullAccessWithNotificationPolicy";
            MakeDefault                                   = $False;
            PhishThresholdLevel                           = 4;
            SpoofQuarantineTag                            = "DefaultFullAccessWithNotificationPolicy";
            TargetedDomainActionRecipients                = @();
            TargetedDomainProtectionAction                = "Quarantine";
            TargetedDomainQuarantineTag                   = "DefaultFullAccessWithNotificationPolicy";
            TargetedDomainsToProtect                      = @();
            TargetedUserActionRecipients                  = @();
            TargetedUserProtectionAction                  = "Quarantine";
            TargetedUserQuarantineTag                     = "DefaultFullAccessWithNotificationPolicy";
            TargetedUsersToProtect                        = @();
            TenantId                                      = $OrganizationName;
        }
        EXOHostedContentFilterPolicy "EXOHostedContentFilterPolicy-Default"
        {
            AddXHeaderValue                      = "";
            AdminDisplayName                     = "";
            AllowedSenderDomains                 = @();
            AllowedSenders                       = @();
            ApplicationId                        = $ConfigurationData.NonNodeData.ApplicationId;
            BlockedSenderDomains                 = @();
            BlockedSenders                       = @();
            BulkQuarantineTag                    = "DefaultFullAccessPolicy";
            BulkSpamAction                       = "MoveToJmf";
            BulkThreshold                        = 9;
            CertificateThumbprint                = $ConfigurationData.NonNodeData.CertificateThumbprint;
            EnableLanguageBlockList              = $False;
            EnableRegionBlockList                = $False;
            Ensure                               = "Present";
            HighConfidencePhishAction            = "Quarantine";
            HighConfidencePhishQuarantineTag     = "AdminOnlyAccessPolicy";
            HighConfidenceSpamAction             = "MoveToJmf";
            HighConfidenceSpamQuarantineTag      = "DefaultFullAccessPolicy";
            Identity                             = "Default";
            IncreaseScoreWithBizOrInfoUrls       = "Off";
            IncreaseScoreWithImageLinks          = "Off";
            IncreaseScoreWithNumericIps          = "Off";
            IncreaseScoreWithRedirectToOtherPort = "Off";
            InlineSafetyTipsEnabled              = $True;
            IntraOrgFilterState                  = "Default";
            LanguageBlockList                    = @();
            MakeDefault                          = $True;
            MarkAsSpamBulkMail                   = "On";
            MarkAsSpamEmbedTagsInHtml            = "Off";
            MarkAsSpamEmptyMessages              = "Off";
            MarkAsSpamFormTagsInHtml             = "Off";
            MarkAsSpamFramesInHtml               = "Off";
            MarkAsSpamFromAddressAuthFail        = "Off";
            MarkAsSpamJavaScriptInHtml           = "Off";
            MarkAsSpamNdrBackscatter             = "Off";
            MarkAsSpamObjectTagsInHtml           = "Off";
            MarkAsSpamSensitiveWordList          = "Off";
            MarkAsSpamSpfRecordHardFail          = "Off";
            MarkAsSpamWebBugsInHtml              = "Off";
            ModifySubjectValue                   = "";
            PhishQuarantineTag                   = "DefaultFullAccessPolicy";
            PhishSpamAction                      = "MoveToJmf";
            PhishZapEnabled                      = $True;
            QuarantineRetentionPeriod            = 15;
            RedirectToRecipients                 = @();
            RegionBlockList                      = @();
            SpamAction                           = "MoveToJmf";
            SpamQuarantineTag                    = "DefaultFullAccessPolicy";
            SpamZapEnabled                       = $True;
            TenantId                             = $OrganizationName;
            TestModeAction                       = "None";
            TestModeBccToRecipients              = @();
        }
        EXOHostedContentFilterPolicy "EXOHostedContentFilterPolicy-Strict Preset Security Policy1646828668580"
        {
            AddXHeaderValue                      = "";
            AdminDisplayName                     = "";
            AllowedSenderDomains                 = @();
            AllowedSenders                       = @();
            ApplicationId                        = $ConfigurationData.NonNodeData.ApplicationId;
            BlockedSenderDomains                 = @();
            BlockedSenders                       = @();
            BulkQuarantineTag                    = "DefaultFullAccessWithNotificationPolicy";
            BulkSpamAction                       = "Quarantine";
            BulkThreshold                        = 5;
            CertificateThumbprint                = $ConfigurationData.NonNodeData.CertificateThumbprint;
            EnableLanguageBlockList              = $False;
            EnableRegionBlockList                = $False;
            Ensure                               = "Present";
            HighConfidencePhishAction            = "Quarantine";
            HighConfidencePhishQuarantineTag     = "AdminOnlyAccessPolicy";
            HighConfidenceSpamAction             = "Quarantine";
            HighConfidenceSpamQuarantineTag      = "DefaultFullAccessWithNotificationPolicy";
            Identity                             = "Strict Preset Security Policy1646828668580";
            IncreaseScoreWithBizOrInfoUrls       = "Off";
            IncreaseScoreWithImageLinks          = "Off";
            IncreaseScoreWithNumericIps          = "Off";
            IncreaseScoreWithRedirectToOtherPort = "Off";
            InlineSafetyTipsEnabled              = $True;
            IntraOrgFilterState                  = "Default";
            LanguageBlockList                    = @();
            MakeDefault                          = $False;
            MarkAsSpamBulkMail                   = "On";
            MarkAsSpamEmbedTagsInHtml            = "Off";
            MarkAsSpamEmptyMessages              = "Off";
            MarkAsSpamFormTagsInHtml             = "Off";
            MarkAsSpamFramesInHtml               = "Off";
            MarkAsSpamFromAddressAuthFail        = "Off";
            MarkAsSpamJavaScriptInHtml           = "Off";
            MarkAsSpamNdrBackscatter             = "Off";
            MarkAsSpamObjectTagsInHtml           = "Off";
            MarkAsSpamSensitiveWordList          = "Off";
            MarkAsSpamSpfRecordHardFail          = "Off";
            MarkAsSpamWebBugsInHtml              = "Off";
            ModifySubjectValue                   = "";
            PhishQuarantineTag                   = "DefaultFullAccessWithNotificationPolicy";
            PhishSpamAction                      = "Quarantine";
            PhishZapEnabled                      = $True;
            QuarantineRetentionPeriod            = 30;
            RedirectToRecipients                 = @();
            RegionBlockList                      = @();
            SpamAction                           = "Quarantine";
            SpamQuarantineTag                    = "DefaultFullAccessWithNotificationPolicy";
            SpamZapEnabled                       = $True;
            TenantId                             = $OrganizationName;
            TestModeAction                       = "None";
            TestModeBccToRecipients              = @();
        }
        EXOHostedContentFilterPolicy "EXOHostedContentFilterPolicy-Standard Preset Security Policy1646828621843"
        {
            AddXHeaderValue                      = "";
            AdminDisplayName                     = "";
            AllowedSenderDomains                 = @();
            AllowedSenders                       = @();
            ApplicationId                        = $ConfigurationData.NonNodeData.ApplicationId;
            BlockedSenderDomains                 = @();
            BlockedSenders                       = @();
            BulkQuarantineTag                    = "DefaultFullAccessPolicy";
            BulkSpamAction                       = "MoveToJmf";
            BulkThreshold                        = 6;
            CertificateThumbprint                = $ConfigurationData.NonNodeData.CertificateThumbprint;
            EnableLanguageBlockList              = $False;
            EnableRegionBlockList                = $False;
            Ensure                               = "Present";
            HighConfidencePhishAction            = "Quarantine";
            HighConfidencePhishQuarantineTag     = "AdminOnlyAccessPolicy";
            HighConfidenceSpamAction             = "Quarantine";
            HighConfidenceSpamQuarantineTag      = "DefaultFullAccessWithNotificationPolicy";
            Identity                             = "Standard Preset Security Policy1646828621843";
            IncreaseScoreWithBizOrInfoUrls       = "Off";
            IncreaseScoreWithImageLinks          = "Off";
            IncreaseScoreWithNumericIps          = "Off";
            IncreaseScoreWithRedirectToOtherPort = "Off";
            InlineSafetyTipsEnabled              = $True;
            IntraOrgFilterState                  = "Default";
            LanguageBlockList                    = @();
            MakeDefault                          = $False;
            MarkAsSpamBulkMail                   = "On";
            MarkAsSpamEmbedTagsInHtml            = "Off";
            MarkAsSpamEmptyMessages              = "Off";
            MarkAsSpamFormTagsInHtml             = "Off";
            MarkAsSpamFramesInHtml               = "Off";
            MarkAsSpamFromAddressAuthFail        = "Off";
            MarkAsSpamJavaScriptInHtml           = "Off";
            MarkAsSpamNdrBackscatter             = "Off";
            MarkAsSpamObjectTagsInHtml           = "Off";
            MarkAsSpamSensitiveWordList          = "Off";
            MarkAsSpamSpfRecordHardFail          = "Off";
            MarkAsSpamWebBugsInHtml              = "Off";
            ModifySubjectValue                   = "";
            PhishQuarantineTag                   = "DefaultFullAccessWithNotificationPolicy";
            PhishSpamAction                      = "Quarantine";
            PhishZapEnabled                      = $True;
            QuarantineRetentionPeriod            = 30;
            RedirectToRecipients                 = @();
            RegionBlockList                      = @();
            SpamAction                           = "MoveToJmf";
            SpamQuarantineTag                    = "DefaultFullAccessPolicy";
            SpamZapEnabled                       = $True;
            TenantId                             = $OrganizationName;
            TestModeAction                       = "None";
            TestModeBccToRecipients              = @();
        }
        EXOMalwareFilterPolicy "EXOMalwareFilterPolicy-Default"
        {
            ApplicationId                          = $ConfigurationData.NonNodeData.ApplicationId;
            CertificateThumbprint                  = $ConfigurationData.NonNodeData.CertificateThumbprint;
            CustomNotifications                    = $False;
            EnableExternalSenderAdminNotifications = $False;
            EnableFileFilter                       = $False;
            EnableInternalSenderAdminNotifications = $False;
            Ensure                                 = "Present";
            FileTypeAction                         = "Reject";
            FileTypes                              = @("ace","ani","apk","app","appx","arj","bat","cab","cmd","com","deb","dex","dll","docm","elf","exe","hta","img","iso","jar","jnlp","kext","lha","lib","library","lnk","lzh","macho","msc","msi","msix","msp","mst","pif","ppa","ppam","reg","rev","scf","scr","sct","sys","uif","vb","vbe","vbs","vxd","wsc","wsf","wsh","xll","xz","z");
            Identity                               = "Default";
            MakeDefault                            = $True;
            QuarantineTag                          = "AdminOnlyAccessPolicy";
            TenantId                               = $OrganizationName;
            ZapEnabled                             = $True;
        }
        EXOMalwareFilterPolicy "EXOMalwareFilterPolicy-Strict Preset Security Policy1646828669862"
        {
            ApplicationId                          = $ConfigurationData.NonNodeData.ApplicationId;
            CertificateThumbprint                  = $ConfigurationData.NonNodeData.CertificateThumbprint;
            CustomNotifications                    = $False;
            EnableExternalSenderAdminNotifications = $False;
            EnableFileFilter                       = $True;
            EnableInternalSenderAdminNotifications = $False;
            Ensure                                 = "Present";
            FileTypeAction                         = "Reject";
            FileTypes                              = @("ace","apk","app","appx","ani","arj","bat","cab","cmd","com","deb","dex","dll","docm","elf","exe","hta","img","iso","jar","jnlp","kext","lha","lib","library","lnk","lzh","macho","msc","msi","msix","msp","mst","pif","ppa","ppam","reg","rev","scf","scr","sct","sys","uif","vb","vbe","vbs","vxd","wsc","wsf","wsh","xll","xz","z");
            Identity                               = "Strict Preset Security Policy1646828669862";
            MakeDefault                            = $False;
            QuarantineTag                          = "AdminOnlyAccessPolicy";
            TenantId                               = $OrganizationName;
            ZapEnabled                             = $True;
        }
        EXOMalwareFilterPolicy "EXOMalwareFilterPolicy-Standard Preset Security Policy1646828624860"
        {
            ApplicationId                          = $ConfigurationData.NonNodeData.ApplicationId;
            CertificateThumbprint                  = $ConfigurationData.NonNodeData.CertificateThumbprint;
            CustomNotifications                    = $False;
            EnableExternalSenderAdminNotifications = $False;
            EnableFileFilter                       = $True;
            EnableInternalSenderAdminNotifications = $False;
            Ensure                                 = "Present";
            FileTypeAction                         = "Reject";
            FileTypes                              = @("ace","apk","app","appx","ani","arj","bat","cab","cmd","com","deb","dex","dll","docm","elf","exe","hta","img","iso","jar","jnlp","kext","lha","lib","library","lnk","lzh","macho","msc","msi","msix","msp","mst","pif","ppa","ppam","reg","rev","scf","scr","sct","sys","uif","vb","vbe","vbs","vxd","wsc","wsf","wsh","xll","xz","z");
            Identity                               = "Standard Preset Security Policy1646828624860";
            MakeDefault                            = $False;
            QuarantineTag                          = "AdminOnlyAccessPolicy";
            TenantId                               = $OrganizationName;
            ZapEnabled                             = $True;
        }
        EXOMalwareFilterPolicy "EXOMalwareFilterPolicy-Anti-malware policy"
        {
            ApplicationId                          = $ConfigurationData.NonNodeData.ApplicationId;
            CertificateThumbprint                  = $ConfigurationData.NonNodeData.CertificateThumbprint;
            CustomNotifications                    = $False;
            EnableExternalSenderAdminNotifications = $True;
            EnableFileFilter                       = $True;
            EnableInternalSenderAdminNotifications = $True;
            Ensure                                 = "Present";
            ExternalSenderAdminAddress             = "andre@ar-net.biz";
            FileTypeAction                         = "Quarantine";
            FileTypes                              = @("ace","ani","app","docm","exe","jar","reg","scr","vbe","vbs");
            Identity                               = "Anti-malware policy";
            InternalSenderAdminAddress             = "andre@ar-net.biz";
            MakeDefault                            = $False;
            QuarantineTag                          = "AdminOnlyAccessPolicy";
            TenantId                               = $OrganizationName;
            ZapEnabled                             = $True;
        }
        EXOSafeAttachmentPolicy "EXOSafeAttachmentPolicy-Safe Attachments policy"
        {
            Action                = "DynamicDelivery";
            AdminDisplayName      = "";
            ApplicationId         = $ConfigurationData.NonNodeData.ApplicationId;
            CertificateThumbprint = $ConfigurationData.NonNodeData.CertificateThumbprint;
            Enable                = $True;
            Ensure                = "Present";
            Identity              = "Safe Attachments policy";
            QuarantineTag         = "AdminOnlyAccessPolicy";
            Redirect              = $True;
            RedirectAddress       = "andre@ar-net.biz";
            TenantId              = $OrganizationName;
        }
        EXOSafeAttachmentPolicy "EXOSafeAttachmentPolicy-Strict Preset Security Policy1646828670204"
        {
            Action                = "Block";
            AdminDisplayName      = "";
            ApplicationId         = $ConfigurationData.NonNodeData.ApplicationId;
            CertificateThumbprint = $ConfigurationData.NonNodeData.CertificateThumbprint;
            Enable                = $True;
            Ensure                = "Present";
            Identity              = "Strict Preset Security Policy1646828670204";
            QuarantineTag         = "AdminOnlyAccessPolicy";
            Redirect              = $False;
            RedirectAddress       = "";
            TenantId              = $OrganizationName;
        }
        EXOSafeAttachmentPolicy "EXOSafeAttachmentPolicy-Standard Preset Security Policy1646828625177"
        {
            Action                = "Block";
            AdminDisplayName      = "";
            ApplicationId         = $ConfigurationData.NonNodeData.ApplicationId;
            CertificateThumbprint = $ConfigurationData.NonNodeData.CertificateThumbprint;
            Enable                = $True;
            Ensure                = "Present";
            Identity              = "Standard Preset Security Policy1646828625177";
            QuarantineTag         = "AdminOnlyAccessPolicy";
            Redirect              = $False;
            RedirectAddress       = "";
            TenantId              = $OrganizationName;
        }
        EXOSafeAttachmentPolicy "EXOSafeAttachmentPolicy-Built-In Protection Policy"
        {
            Action                = "Block";
            AdminDisplayName      = "";
            ApplicationId         = $ConfigurationData.NonNodeData.ApplicationId;
            CertificateThumbprint = $ConfigurationData.NonNodeData.CertificateThumbprint;
            Enable                = $True;
            Ensure                = "Present";
            Identity              = "Built-In Protection Policy";
            QuarantineTag         = "AdminOnlyAccessPolicy";
            Redirect              = $False;
            RedirectAddress       = "";
            TenantId              = $OrganizationName;
        }
        EXOSafeLinksPolicy "EXOSafeLinksPolicy-Standard Preset Security Policy1646828625511"
        {
            AdminDisplayName           = "";
            AllowClickThrough          = $False;
            ApplicationId              = $ConfigurationData.NonNodeData.ApplicationId;
            CertificateThumbprint      = $ConfigurationData.NonNodeData.CertificateThumbprint;
            CustomNotificationText     = "";
            DeliverMessageAfterScan    = $True;
            DisableUrlRewrite          = $False;
            DoNotRewriteUrls           = @();
            EnableForInternalSenders   = $True;
            EnableOrganizationBranding = $False;
            EnableSafeLinksForEmail    = $True;
            EnableSafeLinksForOffice   = $True;
            EnableSafeLinksForTeams    = $True;
            Ensure                     = "Present";
            Identity                   = "Standard Preset Security Policy1646828625511";
            ScanUrls                   = $True;
            TenantId                   = $OrganizationName;
            TrackClicks                = $True;
        }
        EXOSafeLinksPolicy "EXOSafeLinksPolicy-Strict Preset Security Policy1646828670460"
        {
            AdminDisplayName           = "";
            AllowClickThrough          = $False;
            ApplicationId              = $ConfigurationData.NonNodeData.ApplicationId;
            CertificateThumbprint      = $ConfigurationData.NonNodeData.CertificateThumbprint;
            CustomNotificationText     = "";
            DeliverMessageAfterScan    = $True;
            DisableUrlRewrite          = $False;
            DoNotRewriteUrls           = @();
            EnableForInternalSenders   = $True;
            EnableOrganizationBranding = $False;
            EnableSafeLinksForEmail    = $True;
            EnableSafeLinksForOffice   = $True;
            EnableSafeLinksForTeams    = $True;
            Ensure                     = "Present";
            Identity                   = "Strict Preset Security Policy1646828670460";
            ScanUrls                   = $True;
            TenantId                   = $OrganizationName;
            TrackClicks                = $True;
        }
        EXOSafeLinksPolicy "EXOSafeLinksPolicy-Safe Links Policy"
        {
            AdminDisplayName           = "";
            AllowClickThrough          = $True;
            ApplicationId              = $ConfigurationData.NonNodeData.ApplicationId;
            CertificateThumbprint      = $ConfigurationData.NonNodeData.CertificateThumbprint;
            CustomNotificationText     = "";
            DeliverMessageAfterScan    = $False;
            DisableUrlRewrite          = $True;
            DoNotRewriteUrls           = @();
            EnableForInternalSenders   = $True;
            EnableOrganizationBranding = $False;
            EnableSafeLinksForEmail    = $True;
            EnableSafeLinksForOffice   = $True;
            EnableSafeLinksForTeams    = $True;
            Ensure                     = "Present";
            Identity                   = "Safe Links Policy";
            ScanUrls                   = $True;
            TenantId                   = $OrganizationName;
            TrackClicks                = $False;
        }
        EXOSafeLinksPolicy "EXOSafeLinksPolicy-Built-In Protection Policy"
        {
            AdminDisplayName           = "";
            AllowClickThrough          = $True;
            ApplicationId              = $ConfigurationData.NonNodeData.ApplicationId;
            CertificateThumbprint      = $ConfigurationData.NonNodeData.CertificateThumbprint;
            CustomNotificationText     = "";
            DeliverMessageAfterScan    = $True;
            DisableUrlRewrite          = $True;
            DoNotRewriteUrls           = @();
            EnableForInternalSenders   = $False;
            EnableOrganizationBranding = $False;
            EnableSafeLinksForEmail    = $True;
            EnableSafeLinksForOffice   = $True;
            EnableSafeLinksForTeams    = $True;
            Ensure                     = "Present";
            Identity                   = "Built-In Protection Policy";
            ScanUrls                   = $True;
            TenantId                   = $OrganizationName;
            TrackClicks                = $True;
        }
        EXOTransportRule "EXOTransportRule-Spam Filter"
        {
            AccessTokens                                 = $ConfigurationData.NonNodeData.AccessTokens;
            AddToRecipients                              = @();
            AnyOfCcHeader                                = @();
            AnyOfCcHeaderMemberOf                        = @();
            AnyOfRecipientAddressContainsWords           = @();
            AnyOfRecipientAddressMatchesPatterns         = @();
            AnyOfToCcHeader                              = @();
            AnyOfToCcHeaderMemberOf                      = @();
            AnyOfToHeader                                = @();
            AnyOfToHeaderMemberOf                        = @();
            ApplicationId                                = $ConfigurationData.NonNodeData.ApplicationId;
            AttachmentContainsWords                      = @();
            AttachmentExtensionMatchesWords              = @();
            AttachmentHasExecutableContent               = $False;
            AttachmentIsPasswordProtected                = $False;
            AttachmentIsUnsupported                      = $False;
            AttachmentMatchesPatterns                    = @();
            AttachmentNameMatchesPatterns                = @();
            AttachmentProcessingLimitExceeded            = $False;
            AttachmentPropertyContainsWords              = @();
            BetweenMemberOf1                             = @();
            BetweenMemberOf2                             = @();
            BlindCopyTo                                  = @();
            CertificateThumbprint                        = $ConfigurationData.NonNodeData.CertificateThumbprint;
            ContentCharacterSetContainsWords             = @();
            CopyTo                                       = @();
            DeleteMessage                                = $False;
            Enabled                                      = $True;
            Ensure                                       = "Present";
            ExceptIfAnyOfCcHeader                        = @();
            ExceptIfAnyOfCcHeaderMemberOf                = @();
            ExceptIfAnyOfRecipientAddressContainsWords   = @();
            ExceptIfAnyOfRecipientAddressMatchesPatterns = @();
            ExceptIfAnyOfToCcHeader                      = @();
            ExceptIfAnyOfToCcHeaderMemberOf              = @();
            ExceptIfAnyOfToHeader                        = @();
            ExceptIfAnyOfToHeaderMemberOf                = @();
            ExceptIfAttachmentContainsWords              = @();
            ExceptIfAttachmentExtensionMatchesWords      = @();
            ExceptIfAttachmentHasExecutableContent       = $False;
            ExceptIfAttachmentIsPasswordProtected        = $False;
            ExceptIfAttachmentIsUnsupported              = $False;
            ExceptIfAttachmentMatchesPatterns            = @();
            ExceptIfAttachmentNameMatchesPatterns        = @();
            ExceptIfAttachmentProcessingLimitExceeded    = $False;
            ExceptIfAttachmentPropertyContainsWords      = @();
            ExceptIfBetweenMemberOf1                     = @();
            ExceptIfBetweenMemberOf2                     = @();
            ExceptIfContentCharacterSetContainsWords     = @();
            ExceptIfFrom                                 = @();
            ExceptIfFromAddressContainsWords             = @();
            ExceptIfFromAddressMatchesPatterns           = @();
            ExceptIfFromMemberOf                         = @();
            ExceptIfHasNoClassification                  = $False;
            ExceptIfHeaderContainsWords                  = @();
            ExceptIfHeaderMatchesPatterns                = @();
            ExceptIfManagerAddresses                     = @();
            ExceptIfRecipientADAttributeContainsWords    = @();
            ExceptIfRecipientADAttributeMatchesPatterns  = @();
            ExceptIfRecipientAddressContainsWords        = @();
            ExceptIfRecipientAddressMatchesPatterns      = @();
            ExceptIfRecipientDomainIs                    = @();
            ExceptIfRecipientInSenderList                = @();
            ExceptIfSenderADAttributeContainsWords       = @();
            ExceptIfSenderADAttributeMatchesPatterns     = @();
            ExceptIfSenderDomainIs                       = @();
            ExceptIfSenderInRecipientList                = @();
            ExceptIfSenderIpRanges                       = @();
            ExceptIfSentTo                               = @();
            ExceptIfSentToMemberOf                       = @();
            ExceptIfSubjectContainsWords                 = @();
            ExceptIfSubjectMatchesPatterns               = @();
            ExceptIfSubjectOrBodyContainsWords           = @();
            ExceptIfSubjectOrBodyMatchesPatterns         = @();
            From                                         = @();
            FromAddressContainsWords                     = @();
            FromAddressMatchesPatterns                   = @();
            FromMemberOf                                 = @();
            HasNoClassification                          = $False;
            HeaderContainsWords                          = @();
            HeaderMatchesMessageHeader                   = "X-Spam-Flag";
            HeaderMatchesPatterns                        = @("YES");
            IncidentReportContent                        = @();
            ManagerAddresses                             = @();
            Mode                                         = "Enforce";
            ModerateMessageByManager                     = $False;
            ModerateMessageByUser                        = @();
            Name                                         = "Spam Filter";
            Priority                                     = 0;
            Quarantine                                   = $False;
            RecipientADAttributeContainsWords            = @();
            RecipientADAttributeMatchesPatterns          = @();
            RecipientAddressContainsWords                = @();
            RecipientAddressMatchesPatterns              = @();
            RecipientAddressType                         = "Resolved";
            RecipientDomainIs                            = @();
            RecipientInSenderList                        = @();
            RedirectMessageTo                            = @();
            RemoveOMEv2                                  = $False;
            RemoveRMSAttachmentEncryption                = $False;
            RouteMessageOutboundRequireTls               = $False;
            RuleErrorAction                              = "Ignore";
            RuleSubType                                  = "None";
            SenderADAttributeContainsWords               = @();
            SenderADAttributeMatchesPatterns             = @();
            SenderAddressLocation                        = "Header";
            SenderDomainIs                               = @();
            SenderInRecipientList                        = @();
            SenderIpRanges                               = @();
            SentTo                                       = @();
            SentToMemberOf                               = @();
            SetSCL                                       = "9";
            StopRuleProcessing                           = $True;
            SubjectContainsWords                         = @();
            SubjectMatchesPatterns                       = @();
            SubjectOrBodyContainsWords                   = @();
            SubjectOrBodyMatchesPatterns                 = @();
            TenantId                                     = $OrganizationName;
        }
        IntuneDeviceCompliancePolicyWindows10 "IntuneDeviceCompliancePolicyWindows10-Windows Device Compliance"
        {
            ActiveFirewallRequired                      = $False;
            AntiSpywareRequired                         = $False;
            AntivirusRequired                           = $False;
            ApplicationId                               = $ConfigurationData.NonNodeData.ApplicationId;
            Assignments                                 = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments{
                    dataType = "#microsoft.graph.allLicensedUsersAssignmentTarget"
                    deviceAndAppManagementAssignmentFilterType = "none"
                    groupDisplayName = "All users"
                }
            );
            BitLockerEnabled                            = $False;
            CertificateThumbprint                       = $ConfigurationData.NonNodeData.CertificateThumbprint;
            CodeIntegrityEnabled                        = $False;
            ConfigurationManagerComplianceRequired      = $False;
            DefenderEnabled                             = $False;
            DeviceThreatProtectionEnabled               = $False;
            DeviceThreatProtectionRequiredSecurityLevel = "unavailable";
            DisplayName                                 = "Windows Device Compliance";
            EarlyLaunchAntiMalwareDriverEnabled         = $False;
            Ensure                                      = "Present";
            Id                                          = "238c4093-6348-452b-bc02-66c16aa6fe99";
            OsMinimumVersion                            = "10.0.1904";
            PasswordBlockSimple                         = $False;
            PasswordRequired                            = $False;
            PasswordRequiredToUnlockFromIdle            = $False;
            PasswordRequiredType                        = "deviceDefault";
            RequireHealthyDeviceReport                  = $False;
            RoleScopeTagIds                             = @("0");
            RTPEnabled                                  = $False;
            ScheduledActionsForRule                     = @(
                MSFT_MicrosoftGraphDeviceComplianceScheduledActionsForRuleConfiguration{
                    ActionType = "block"
                    GracePeriodHours = 0
                }
            );
            SecureBootEnabled                           = $False;
            SignatureOutOfDate                          = $False;
            StorageRequireEncryption                    = $False;
            TenantId                                    = $OrganizationName;
            TpmRequired                                 = $False;
        }
        SCDLPCompliancePolicy "SCDLPCompliancePolicy-Highly Sensitive Content"
        {
            ApplicationId                         = $ConfigurationData.NonNodeData.ApplicationId;
            CertificateThumbprint                 = $ConfigurationData.NonNodeData.CertificateThumbprint;
            Comment                               = "Highly Sensitive Content";
            EndpointDlpLocationException          = @();
            Ensure                                = "Present";
            ExchangeLocation                      = "All";
            ExchangeSenderMemberOf                = @();
            ExchangeSenderMemberOfException       = @();
            Mode                                  = "Enable";
            Name                                  = "Highly Sensitive Content";
            OneDriveLocationException             = @();
            OnPremisesScannerDlpLocationException = @();
            PowerBIDlpLocationException           = @();
            Priority                              = 0;
            SharePointLocationException           = @();
            TeamsLocationException                = @();
            TenantId                              = $OrganizationName;
            ThirdPartyAppDlpLocationException     = @();
        }
        SCDLPCompliancePolicy "SCDLPCompliancePolicy-File extension custom policy"
        {
            ApplicationId                         = $ConfigurationData.NonNodeData.ApplicationId;
            CertificateThumbprint                 = $ConfigurationData.NonNodeData.CertificateThumbprint;
            Comment                               = "Create a custom policy from scratch. You will choose the type of content to protect and how you want to protect it.";
            EndpointDlpLocationException          = @();
            Ensure                                = "Present";
            ExchangeLocation                      = "All";
            ExchangeSenderMemberOf                = @();
            ExchangeSenderMemberOfException       = @();
            Mode                                  = "Enable";
            Name                                  = "File extension custom policy";
            OneDriveLocationException             = @();
            OnPremisesScannerDlpLocationException = @();
            PowerBIDlpLocationException           = @();
            Priority                              = 1;
            SharePointLocationException           = @();
            TeamsLocationException                = @();
            TenantId                              = $OrganizationName;
            ThirdPartyAppDlpLocationException     = @();
        }
        SCDLPCompliancePolicy "SCDLPCompliancePolicy-Blue-Exchange: Egress .switch Attachments"
        {
            ApplicationId                         = $ConfigurationData.NonNodeData.ApplicationId;
            CertificateThumbprint                 = $ConfigurationData.NonNodeData.CertificateThumbprint;
            Comment                               = "Create a custom policy from scratch. You will choose the type of content to protect and how you want to protect it.";
            EndpointDlpLocationException          = @();
            Ensure                                = "Present";
            ExchangeLocation                      = "All";
            ExchangeSenderMemberOf                = @();
            ExchangeSenderMemberOfException       = @();
            Mode                                  = "Disable";
            Name                                  = "Blue-Exchange: Egress .switch Attachments";
            OneDriveLocationException             = @();
            OnPremisesScannerDlpLocationException = @();
            PowerBIDlpLocationException           = @();
            Priority                              = 2;
            SharePointLocationException           = @();
            TeamsLocationException                = @();
            TenantId                              = $OrganizationName;
            ThirdPartyAppDlpLocationException     = @();
        }
        SCDLPCompliancePolicy "SCDLPCompliancePolicy-(ALT) Blue-Exchange: Egress .switch Attachments"
        {
            ApplicationId                         = $ConfigurationData.NonNodeData.ApplicationId;
            CertificateThumbprint                 = $ConfigurationData.NonNodeData.CertificateThumbprint;
            Comment                               = "Create a custom policy from scratch. You will choose the type of content to protect and how you want to protect it.";
            EndpointDlpLocationException          = @();
            Ensure                                = "Present";
            ExchangeLocation                      = "All";
            ExchangeSenderMemberOf                = @();
            ExchangeSenderMemberOfException       = @();
            Mode                                  = "Disable";
            Name                                  = "(ALT) Blue-Exchange: Egress .switch Attachments";
            OneDriveLocationException             = @();
            OnPremisesScannerDlpLocationException = @();
            PowerBIDlpLocationException           = @();
            Priority                              = 3;
            SharePointLocationException           = @();
            TeamsLocationException                = @();
            TenantId                              = $OrganizationName;
            ThirdPartyAppDlpLocationException     = @();
        }
        SCDLPCompliancePolicy "SCDLPCompliancePolicy-Default policy for Teams"
        {
            ApplicationId                         = $ConfigurationData.NonNodeData.ApplicationId;
            CertificateThumbprint                 = $ConfigurationData.NonNodeData.CertificateThumbprint;
            Comment                               = "This policy detects the presence of credit card numbers in Teams chats and channel messages. When this sensitive information is detected, admins will get an Alert notification. Users would not see any policy tip. However, you can edit these actions anytime.";
            EndpointDlpLocationException          = @();
            Ensure                                = "Present";
            ExchangeSenderMemberOf                = @();
            ExchangeSenderMemberOfException       = @();
            Mode                                  = "Disable";
            Name                                  = "Default policy for Teams";
            OneDriveLocationException             = @();
            OnPremisesScannerDlpLocationException = @();
            PowerBIDlpLocationException           = @();
            Priority                              = 4;
            SharePointLocationException           = @();
            TeamsLocation                         = "All";
            TeamsLocationException                = @();
            TenantId                              = $OrganizationName;
            ThirdPartyAppDlpLocationException     = @();
        }
        SCDLPCompliancePolicy "SCDLPCompliancePolicy-U.K. Data Protection Act"
        {
            ApplicationId                         = $ConfigurationData.NonNodeData.ApplicationId;
            CertificateThumbprint                 = $ConfigurationData.NonNodeData.CertificateThumbprint;
            Comment                               = "Helps detect the presence of information subject to United Kingdom Data Protection Act, including data like national insurance numbers.";
            EndpointDlpLocationException          = @();
            Ensure                                = "Present";
            ExchangeLocation                      = "All";
            ExchangeSenderMemberOf                = @();
            ExchangeSenderMemberOfException       = @();
            Mode                                  = "Disable";
            Name                                  = "U.K. Data Protection Act";
            OneDriveLocation                      = "All";
            OneDriveLocationException             = @();
            OnPremisesScannerDlpLocation          = "All";
            OnPremisesScannerDlpLocationException = @();
            PowerBIDlpLocationException           = @();
            Priority                              = 5;
            SharePointLocation                    = "All";
            SharePointLocationException           = @();
            TeamsLocation                         = "All";
            TeamsLocationException                = @();
            TenantId                              = $OrganizationName;
            ThirdPartyAppDlpLocation              = "All";
            ThirdPartyAppDlpLocationException     = @();
        }
        SCLabelPolicy "SCLabelPolicy-None"
        {
            AdvancedSettings      = @(
                MSFT_SCLabelSetting{
                    Key = "powerbimandatory"
                    Value = "false"
                }
                MSFT_SCLabelSetting{
                    Key = "requiredowngradejustification"
                    Value = "false"
                }
                MSFT_SCLabelSetting{
                    Key = "mandatory"
                    Value = "false"
                }
                MSFT_SCLabelSetting{
                    Key = "disablemandatoryinoutlook"
                    Value = "true"
                }
                MSFT_SCLabelSetting{
                    Key = "teamworkmandatory"
                    Value = "false"
                }
            );
            ApplicationId         = $ConfigurationData.NonNodeData.ApplicationId;
            CertificateThumbprint = $ConfigurationData.NonNodeData.CertificateThumbprint;
            Comment               = "";
            Ensure                = "Present";
            ExchangeLocation      = "All";
            Labels                = @("None");
            Name                  = "None";
            TenantId              = $OrganizationName;
        }
        SCLabelPolicy "SCLabelPolicy-Default Labeling Policy"
        {
            AdvancedSettings      = @(
                MSFT_SCLabelSetting{
                    Key = "powerbimandatory"
                    Value = "false"
                }
                MSFT_SCLabelSetting{
                    Key = "requiredowngradejustification"
                    Value = "false"
                }
                MSFT_SCLabelSetting{
                    Key = "mandatory"
                    Value = "false"
                }
                MSFT_SCLabelSetting{
                    Key = "disablemandatoryinoutlook"
                    Value = "true"
                }
                MSFT_SCLabelSetting{
                    Key = "teamworkmandatory"
                    Value = "false"
                }
            );
            ApplicationId         = $ConfigurationData.NonNodeData.ApplicationId;
            CertificateThumbprint = $ConfigurationData.NonNodeData.CertificateThumbprint;
            Comment               = "Default Labeling Policy";
            Ensure                = "Present";
            Labels                = @("Public","Highly Sensitive","None","Confidential","Restricted");
            ModernGroupLocation   = @("allcompany@ar-net.biz","ar-netusers@ar-net.biz","arnetbiz@ar-net.biz");
            Name                  = "Default Labeling Policy";
            TenantId              = $OrganizationName;
        }
        SCLabelPolicy "SCLabelPolicy-Latest Policy"
        {
            AdvancedSettings      = @(
                MSFT_SCLabelSetting{
                    Key = "powerbimandatory"
                    Value = "false"
                }
                MSFT_SCLabelSetting{
                    Key = "requiredowngradejustification"
                    Value = "false"
                }
                MSFT_SCLabelSetting{
                    Key = "mandatory"
                    Value = "false"
                }
                MSFT_SCLabelSetting{
                    Key = "disablemandatoryinoutlook"
                    Value = "true"
                }
                MSFT_SCLabelSetting{
                    Key = "teamworkmandatory"
                    Value = "false"
                }
            );
            ApplicationId         = $ConfigurationData.NonNodeData.ApplicationId;
            CertificateThumbprint = $ConfigurationData.NonNodeData.CertificateThumbprint;
            Comment               = "";
            Ensure                = "Present";
            ExchangeLocation      = "All";
            Labels                = @();
            Name                  = "Latest Policy";
            TenantId              = $OrganizationName;
        }
        SCRetentionCompliancePolicy "SCRetentionCompliancePolicy-Teams chats retention policy"
        {
            ApplicationId                 = $ConfigurationData.NonNodeData.ApplicationId;
            CertificateThumbprint         = $ConfigurationData.NonNodeData.CertificateThumbprint;
            Comment                       = "Teams chats retention policy";
            Enabled                       = $True;
            Ensure                        = "Present";
            Name                          = "Teams chats retention policy";
            RestrictiveRetention          = $False;
            TeamsChannelLocation          = @();
            TeamsChannelLocationException = @();
            TeamsChatLocation             = @("All");
            TeamsChatLocationException    = @();
            TenantId                      = $OrganizationName;
        }
        SPOSharingSettings "SPOSharingSettings"
        {
            ApplicationId                            = $ConfigurationData.NonNodeData.ApplicationId;
            BccExternalSharingInvitations            = $False;
            CertificateThumbprint                    = $ConfigurationData.NonNodeData.CertificateThumbprint;
            DefaultLinkPermission                    = "Edit";
            DefaultSharingLinkType                   = "AnonymousAccess";
            EnableGuestSignInAcceleration            = $False;
            Ensure                                   = "Present";
            ExternalUserExpirationRequired           = $True;
            ExternalUserExpireInDays                 = 60;
            FileAnonymousLinkType                    = "Edit";
            FolderAnonymousLinkType                  = "Edit";
            IsSingleInstance                         = "Yes";
            MySiteSharingCapability                  = "ExternalUserAndGuestSharing";
            NotifyOwnersWhenItemsReshared            = $True;
            PreventExternalUsersFromResharing        = $True;
            ProvisionSharedWithEveryoneFolder        = $False;
            SharingAllowedDomainList                 = @("avanade.com","protonmail.com","renatacastrophotography.com");
            SharingCapability                        = "ExternalUserAndGuestSharing";
            SharingDomainRestrictionMode             = "AllowList";
            ShowAllUsersClaim                        = $False;
            ShowEveryoneClaim                        = $False;
            ShowEveryoneExceptExternalUsersClaim     = $True;
            ShowPeoplePickerSuggestionsForGuestUsers = $False;
            TenantId                                 = $OrganizationName;
        }
        SPOTenantSettings "SPOTenantSettings"
        {
            AllowDownloadingNonWebViewableFiles                    = $True;
            AllowEditing                                           = $True;
            AllowSelectSecurityGroupsInSPSitesList                 = @();
            AllowSelectSGsInODBListInTenant                        = @();
            ApplicationId                                          = $ConfigurationData.NonNodeData.ApplicationId;
            ApplyAppEnforcedRestrictionsToAdHocRecipients          = $True;
            CertificateThumbprint                                  = $ConfigurationData.NonNodeData.CertificateThumbprint;
            CommentsOnSitePagesDisabled                            = $False;
            DenySelectSecurityGroupsInSPSitesList                  = @();
            DenySelectSGsInODBListInTenant                         = @();
            DisableCustomAppAuthentication                         = $True;
            DisabledModernListTemplateIds                          = @();
            DisablePersonalListCreation                            = $False;
            DisplayNamesOfFileViewersInSpo                         = $True;
            EnableAzureADB2BIntegration                            = $False;
            Ensure                                                 = "Present";
            ExemptNativeUsersFromTenantLevelRestricedAccessControl = $False;
            FilePickerExternalImageSearchEnabled                   = $True;
            HideDefaultThemes                                      = $False;
            HideSyncButtonOnODB                                    = $False;
            IsFluidEnabled                                         = $True;
            IsLoopEnabled                                          = $True;
            IsSharePointNewsfeedEnabled                            = $False;
            IsSingleInstance                                       = "Yes";
            IsSiteCreationEnabled                                  = $True;
            IsSiteCreationUiEnabled                                = $True;
            IsSitePagesCreationEnabled                             = $True;
            LegacyAuthProtocolsEnabled                             = $True;
            MarkNewFilesSensitiveByDefault                         = "AllowExternalSharing";
            MaxCompatibilityLevel                                  = "15";
            MinCompatibilityLevel                                  = "15";
            MobileFriendlyUrlEnabledInTenant                       = $True;
            NotificationsInSharePointEnabled                       = $True;
            OfficeClientADALDisabled                               = $False;
            OwnerAnonymousNotification                             = $True;
            PublicCdnAllowedFileTypes                              = "CSS,EOT,GIF,ICO,JPEG,JPG,JS,MAP,PNG,SVG,TTF,WOFF";
            PublicCdnEnabled                                       = $False;
            RequireAcceptingAccountMatchInvitedAccount             = $False;
            SearchResolveExactEmailOrUPN                           = $False;
            SignInAccelerationDomain                               = "";
            SocialBarOnSitePagesDisabled                           = $False;
            SpecialCharactersStateInFileFolderNames                = "Allowed";
            TenantDefaultTimezone                                  = "(UTC-08:00) Pacific Time (US and Canada)";
            TenantId                                               = $OrganizationName;
            UseFindPeopleInPeoplePicker                            = $False;
            UsePersistentCookiesForExplorerView                    = $False;
        }
        TeamsMessagingPolicy "TeamsMessagingPolicy-Global"
        {
            AllowChatWithGroup                            = $True;
            AllowCommunicationComplianceEndUserReporting  = $True;
            AllowCustomGroupChatAvatars                   = $True;
            AllowFluidCollaborate                         = $False;
            AllowFullChatPermissionUserToDeleteAnyMessage = $False;
            AllowGiphy                                    = $True;
            AllowGiphyDisplay                             = $True;
            AllowGroupChatJoinLinks                       = $True;
            AllowImmersiveReader                          = $True;
            AllowMemes                                    = $True;
            AllowOwnerDeleteMessage                       = $True;
            AllowPasteInternetImage                       = $True;
            AllowPriorityMessages                         = $True;
            AllowRemoveUser                               = $True;
            AllowSecurityEndUserReporting                 = $True;
            AllowSmartCompose                             = $True;
            AllowSmartReply                               = $True;
            AllowStickers                                 = $True;
            AllowUrlPreviews                              = $True;
            AllowUserChat                                 = $True;
            AllowUserDeleteChat                           = $True;
            AllowUserDeleteMessage                        = $True;
            AllowUserEditMessage                          = $True;
            AllowUserTranslation                          = $True;
            AllowVideoMessages                            = $True;
            ApplicationId                                 = $ConfigurationData.NonNodeData.ApplicationId;
            AudioMessageEnabledType                       = "ChatsAndChannels";
            AutoShareFilesInExternalChats                 = "Enabled";
            CertificateThumbprint                         = $ConfigurationData.NonNodeData.CertificateThumbprint;
            ChannelsInChatListEnabledType                 = "EnabledUserOverride";
            ChatPermissionRole                            = "Restricted";
            CreateCustomEmojis                            = $True;
            DeleteCustomEmojis                            = $False;
            DesignerForBackgroundsAndImages               = "Enabled";
            Ensure                                        = "Present";
            GiphyRatingType                               = "NoRestriction";
            Identity                                      = "Global";
            InOrganizationChatControl                     = "BlockingDisallowed";
            ReadReceiptsEnabledType                       = "UserPreference";
            TenantId                                      = $OrganizationName;
            UseB2BInvitesToAddExternalUsers               = "Enabled";
            UsersCanDeleteBotMessages                     = $False;
        }
        TeamsMessagingPolicy "TeamsMessagingPolicy-Default"
        {
            AllowChatWithGroup                            = $True;
            AllowCommunicationComplianceEndUserReporting  = $True;
            AllowCustomGroupChatAvatars                   = $True;
            AllowFluidCollaborate                         = $False;
            AllowFullChatPermissionUserToDeleteAnyMessage = $False;
            AllowGiphy                                    = $True;
            AllowGiphyDisplay                             = $True;
            AllowGroupChatJoinLinks                       = $True;
            AllowImmersiveReader                          = $True;
            AllowMemes                                    = $True;
            AllowOwnerDeleteMessage                       = $False;
            AllowPasteInternetImage                       = $True;
            AllowPriorityMessages                         = $True;
            AllowRemoveUser                               = $True;
            AllowSecurityEndUserReporting                 = $True;
            AllowSmartCompose                             = $True;
            AllowSmartReply                               = $True;
            AllowStickers                                 = $True;
            AllowUrlPreviews                              = $True;
            AllowUserChat                                 = $True;
            AllowUserDeleteChat                           = $True;
            AllowUserDeleteMessage                        = $True;
            AllowUserEditMessage                          = $True;
            AllowUserTranslation                          = $True;
            AllowVideoMessages                            = $True;
            ApplicationId                                 = $ConfigurationData.NonNodeData.ApplicationId;
            AudioMessageEnabledType                       = "ChatsAndChannels";
            AutoShareFilesInExternalChats                 = "Enabled";
            CertificateThumbprint                         = $ConfigurationData.NonNodeData.CertificateThumbprint;
            ChannelsInChatListEnabledType                 = "DisabledUserOverride";
            ChatPermissionRole                            = "Restricted";
            CreateCustomEmojis                            = $True;
            DeleteCustomEmojis                            = $False;
            DesignerForBackgroundsAndImages               = "Enabled";
            Ensure                                        = "Present";
            GiphyRatingType                               = "Moderate";
            Identity                                      = "Default";
            InOrganizationChatControl                     = "BlockingDisallowed";
            ReadReceiptsEnabledType                       = "UserPreference";
            TenantId                                      = $OrganizationName;
            UseB2BInvitesToAddExternalUsers               = "Enabled";
            UsersCanDeleteBotMessages                     = $False;
        }
        TeamsMessagingPolicy "TeamsMessagingPolicy-EduFaculty"
        {
            AllowChatWithGroup                            = $True;
            AllowCommunicationComplianceEndUserReporting  = $True;
            AllowCustomGroupChatAvatars                   = $True;
            AllowFluidCollaborate                         = $False;
            AllowFullChatPermissionUserToDeleteAnyMessage = $False;
            AllowGiphy                                    = $False;
            AllowGiphyDisplay                             = $False;
            AllowGroupChatJoinLinks                       = $True;
            AllowImmersiveReader                          = $True;
            AllowMemes                                    = $True;
            AllowOwnerDeleteMessage                       = $True;
            AllowPasteInternetImage                       = $False;
            AllowPriorityMessages                         = $True;
            AllowRemoveUser                               = $True;
            AllowSecurityEndUserReporting                 = $True;
            AllowSmartCompose                             = $True;
            AllowSmartReply                               = $True;
            AllowStickers                                 = $True;
            AllowUrlPreviews                              = $True;
            AllowUserChat                                 = $True;
            AllowUserDeleteChat                           = $True;
            AllowUserDeleteMessage                        = $True;
            AllowUserEditMessage                          = $True;
            AllowUserTranslation                          = $True;
            AllowVideoMessages                            = $True;
            ApplicationId                                 = $ConfigurationData.NonNodeData.ApplicationId;
            AudioMessageEnabledType                       = "ChatsAndChannels";
            AutoShareFilesInExternalChats                 = "Enabled";
            CertificateThumbprint                         = $ConfigurationData.NonNodeData.CertificateThumbprint;
            ChannelsInChatListEnabledType                 = "DisabledUserOverride";
            ChatPermissionRole                            = "Full";
            CreateCustomEmojis                            = $True;
            DeleteCustomEmojis                            = $False;
            DesignerForBackgroundsAndImages               = "Enabled";
            Ensure                                        = "Present";
            GiphyRatingType                               = "Strict";
            Identity                                      = "EduFaculty";
            InOrganizationChatControl                     = "BlockingDisallowed";
            ReadReceiptsEnabledType                       = "UserPreference";
            TenantId                                      = $OrganizationName;
            UseB2BInvitesToAddExternalUsers               = "Enabled";
            UsersCanDeleteBotMessages                     = $False;
        }
        TeamsMessagingPolicy "TeamsMessagingPolicy-EduStudent"
        {
            AllowChatWithGroup                            = $True;
            AllowCommunicationComplianceEndUserReporting  = $True;
            AllowCustomGroupChatAvatars                   = $True;
            AllowFluidCollaborate                         = $False;
            AllowFullChatPermissionUserToDeleteAnyMessage = $False;
            AllowGiphy                                    = $False;
            AllowGiphyDisplay                             = $False;
            AllowGroupChatJoinLinks                       = $True;
            AllowImmersiveReader                          = $True;
            AllowMemes                                    = $True;
            AllowOwnerDeleteMessage                       = $False;
            AllowPasteInternetImage                       = $False;
            AllowPriorityMessages                         = $True;
            AllowRemoveUser                               = $True;
            AllowSecurityEndUserReporting                 = $True;
            AllowSmartCompose                             = $True;
            AllowSmartReply                               = $True;
            AllowStickers                                 = $True;
            AllowUrlPreviews                              = $True;
            AllowUserChat                                 = $True;
            AllowUserDeleteChat                           = $True;
            AllowUserDeleteMessage                        = $True;
            AllowUserEditMessage                          = $True;
            AllowUserTranslation                          = $True;
            AllowVideoMessages                            = $True;
            ApplicationId                                 = $ConfigurationData.NonNodeData.ApplicationId;
            AudioMessageEnabledType                       = "ChatsAndChannels";
            AutoShareFilesInExternalChats                 = "Enabled";
            CertificateThumbprint                         = $ConfigurationData.NonNodeData.CertificateThumbprint;
            ChannelsInChatListEnabledType                 = "DisabledUserOverride";
            ChatPermissionRole                            = "Full";
            CreateCustomEmojis                            = $True;
            DeleteCustomEmojis                            = $False;
            DesignerForBackgroundsAndImages               = "Enabled";
            Ensure                                        = "Present";
            GiphyRatingType                               = "Strict";
            Identity                                      = "EduStudent";
            InOrganizationChatControl                     = "BlockingDisallowed";
            ReadReceiptsEnabledType                       = "UserPreference";
            TenantId                                      = $OrganizationName;
            UseB2BInvitesToAddExternalUsers               = "Enabled";
            UsersCanDeleteBotMessages                     = $False;
        }
    }
}

arnetbiz_export -ConfigurationData .\ConfigurationData.psd1
