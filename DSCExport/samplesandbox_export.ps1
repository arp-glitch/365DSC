# Generated with Microsoft365DSC version 1.26.218.1
# For additional information on how to use Microsoft365DSC, please visit https://aka.ms/M365DSC
param (
)

Configuration samplesandbox_export
{
    param (
    )

    $OrganizationName = $ConfigurationData.NonNodeData.OrganizationName

    Import-DscResource -ModuleName 'Microsoft365DSC' -ModuleVersion '1.26.218.1'

    Node localhost
    {
        AADPasswordRuleSettings "AADPasswordRuleSettings"
        {
            ApplicationId         = $ConfigurationData.NonNodeData.ApplicationId;
            CertificateThumbprint = $ConfigurationData.NonNodeData.CertificateThumbprint;
            Ensure                = "Absent";
            IsSingleInstance      = "Yes";
            TenantId              = $OrganizationName;
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
            BulkThreshold                        = 7;
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
        EXOMalwareFilterPolicy "EXOMalwareFilterPolicy-Default"
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
            Identity                               = "Default";
            MakeDefault                            = $True;
            QuarantineTag                          = "AdminOnlyAccessPolicy";
            TenantId                               = $OrganizationName;
            ZapEnabled                             = $True;
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
        SCDLPCompliancePolicy "SCDLPCompliancePolicy-Default policy for Teams"
        {
            ApplicationId                         = $ConfigurationData.NonNodeData.ApplicationId;
            CertificateThumbprint                 = $ConfigurationData.NonNodeData.CertificateThumbprint;
            Comment                               = "This policy detects the presence of credit card numbers in Teams chats and channel messages. When this sensitive info is detected, admins will receive an alert but policy tips won't be displayed to users. You can edit these actions at any time.";
            EndpointDlpLocationException          = @();
            Ensure                                = "Present";
            ExchangeSenderMemberOf                = @();
            ExchangeSenderMemberOfException       = @();
            Mode                                  = "Enable";
            Name                                  = "Default policy for Teams";
            OneDriveLocationException             = @();
            OnPremisesScannerDlpLocationException = @();
            PowerBIDlpLocationException           = @();
            Priority                              = 0;
            SharePointLocationException           = @();
            TeamsLocation                         = "All";
            TeamsLocationException                = @();
            TenantId                              = $OrganizationName;
            ThirdPartyAppDlpLocationException     = @();
        }
        SCLabelPolicy "SCLabelPolicy-Global sensitivity label policy"
        {
            AdvancedSettings      = @(
                MSFT_SCLabelSetting{
                    Key = "mandatory"
                    Value = "false"
                }
                MSFT_SCLabelSetting{
                    Key = "powerbimandatory"
                    Value = "false"
                }
                MSFT_SCLabelSetting{
                    Key = "outlookdefaultlabel"
                    Value = "All Employees (unrestricted)"
                }
                MSFT_SCLabelSetting{
                    Key = "requiredowngradejustification"
                    Value = "true"
                }
                MSFT_SCLabelSetting{
                    Key = "defaultlabelid"
                    Value = "All Employees (unrestricted)"
                }
                MSFT_SCLabelSetting{
                    Key = "disablemandatoryinoutlook"
                    Value = "true"
                }
            );
            ApplicationId         = $ConfigurationData.NonNodeData.ApplicationId;
            CertificateThumbprint = $ConfigurationData.NonNodeData.CertificateThumbprint;
            Comment               = "Default sensitivity label policy for all users and groups.";
            Ensure                = "Present";
            ExchangeLocation      = "All";
            Labels                = @("defa4170-0d19-0005-000b-bc88714345d2","defa4170-0d19-0005-0001-bc88714345d2","defa4170-0d19-0005-0007-bc88714345d2","defa4170-0d19-0005-0005-bc88714345d2","defa4170-0d19-0005-0008-bc88714345d2","defa4170-0d19-0005-000a-bc88714345d2","defa4170-0d19-0005-0000-bc88714345d2","defa4170-0d19-0005-0003-bc88714345d2","defa4170-0d19-0005-0002-bc88714345d2","defa4170-0d19-0005-0009-bc88714345d2","defa4170-0d19-0005-0004-bc88714345d2","defa4170-0d19-0005-0006-bc88714345d2");
            Name                  = "Global sensitivity label policy";
            TenantId              = $OrganizationName;
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

samplesandbox_export -ConfigurationData .\ConfigurationData.psd1
