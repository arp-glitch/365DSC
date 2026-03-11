@{
    AllNodes = @(
        @{
            NodeName                    = "localhost"
            PSDscAllowPlainTextPassword = $true;
            PSDscAllowDomainUser        = $true;
            #region Parameters
            # Default Value Used to Ensure a Configuration Data File is Generated
            ServerNumber = "0"

        }
    )
    NonNodeData = @(
        @{
            # Azure AD Application Id for Authentication
            ApplicationId = "a474ef76-a8b5-48bc-8c14-f94aa694782e"

            # Thumbprint of the certificate to use for authentication
            CertificateThumbprint = "4082F127F3705C7B20353A548FF1882AA6283631"

            # Tenant's default verified domain name
            OrganizationName = "arnetbiz.onmicrosoft.com"

            # Placeholder for sensitive data - TenantGuid
            TenantGuid = "b3f0a9b8-5da5-4eac-acff-83059c4bbf17"

            # The Id or Name of the tenant to authenticate against
            TenantId = "arnetbiz.onmicrosoft.com"

        }
    )
}
