# Powershell ADO

Powershell scripts to manage access levels within all organizations in Azure Devops.

## Requirements
- Create a personal access tokens for all accessible organizations, with thses scopes:
  - Entitlements: Read
  - Graph: Read & manage
  - Identity: Read & manage
  - Member Entitlement Management: Read & write
  - User Profile: Read & write

![image](https://user-images.githubusercontent.com/88986177/234857318-c82a6e44-4f30-4850-9d7c-f0e01fe740f9.png)

- Change thses variables in the scripts: 
  - $token = "PAT” 
  - $displayName = "Display Name"
