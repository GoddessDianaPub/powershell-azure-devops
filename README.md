# Powershell ADO

Powershell scripts to manage access levels within all organizations in Azure Devops.

## Requirements
- Create a personal access token for all accessible organizations, with thses scopes:

  ![image](https://user-images.githubusercontent.com/88986177/234857318-c82a6e44-4f30-4850-9d7c-f0e01fe740f9.png)

  - Entitlements: Read
  - Graph: Read & manage
  - Identity: Read & manage
  - Member Entitlement Management: Read & write
  - User Profile: Read & write

- Change thses variables in the scripts:
  - $token = "Your PAT” 
  - $displayName = "User's ADO Display Name"

## Notes

The access levels variables are as follows:

"accountLicenseType" or "licensingSource"

![image](https://user-images.githubusercontent.com/88986177/234867143-92a56517-6105-46a6-b865-c03fed0512df.png)
