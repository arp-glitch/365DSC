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
            ApplicationId = "cd704314-acc8-46f9-ae73-1edc1dc49145"

            # Thumbprint of the certificate to use for authentication
            CertificateThumbprint = "EB15021BEF4103CAF518D27634DDE36EE871C7DA"

            # Tenant's default verified domain name
            OrganizationName = "samplesandbox.onmicrosoft.com"

            # Placeholder for sensitive data - TenantGuid
            TenantGuid = "31df26f7-f5bb-4839-9cde-9e3c5589f7b4"

            # The Id or Name of the tenant to authenticate against
            TenantId = "samplesandbox.onmicrosoft.com"

        }
    )
}
