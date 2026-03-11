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
            ApplicationId = "68f8b6ff-a6bb-4f9b-a1d9-5a998d70f939"

            # Thumbprint of the certificate to use for authentication
            CertificateThumbprint = "4082F127F3705C7B20353A548FF1882AA6283631"

            # Tenant's default verified domain name
            OrganizationName = "samplesandbox.onmicrosoft.com"

            # Placeholder for sensitive data - TenantGuid
            TenantGuid = "e96b6518-a046-4d95-aee0-64c8c94cf0d8"

            # The Id or Name of the tenant to authenticate against
            TenantId = "samplesandbox.onmicrosoft.com"

        }
    )
}
