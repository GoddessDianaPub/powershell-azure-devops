#You can change the user's access level to "Basic + Test plans" by using this PowerShell script.
#In the output It will show you all the organizations name, but you will see the user's details in the org the has a username at.

# $token (PAT) - the Personal Access Tokens need to be filled from this URL: "https://dev.azure.com/%YOUR_ORG%/_usersSettings/tokens"
$token = "PAT” 
 
$url="https://app.vssps.visualstudio.com/_apis/profile/profiles/me?api-version=6.0"

$token = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$($token)"))

$response = Invoke-RestMethod -Uri $url -Headers @{Authorization = "Basic $token"} -Method Get -ContentType application/json

$publicAlias = $response.publicAlias

# $displayName - the user's Display Name need to be filled from this URL: "https://admin.microsoft.com/Adminportal/Home?source=applauncher#/users"
$displayName = "Display Name"

 
$url1=“https://app.vssps.visualstudio.com/_apis/accounts?memberId=$($publicAlias)&api-version=6.0”

$response1 = Invoke-RestMethod -Uri $url1 -Headers @{Authorization = "Basic $token"} -Method Get -ContentType application/json

Foreach($organization in $response1.value.accountName)
{

#Adding a space between each organization
  echo ""
  echo $organization

  
  $url2="https://vsaex.dev.azure.com/$($organization)/_apis/userentitlements?"+"`$filter"+"=name eq '$displayName'&api-version=6.0-preview.3"

  $response2 = Invoke-RestMethod -Uri $url2 -Headers @{Authorization = "Basic $token"} -Method Get -ContentType application/json

# You need to add the "accountLicenseType" value according to the access level needed (follow Account License Type.xlsx).
# "licensingSource" need to be configured as "account", unless you need to change it to "Visual Studio Subscriber" access level (follow Account License Type.xlsx).

  Foreach($users in $response2.members)
  {
    if($users.user.displayName -eq "$displayName")
    { 
       echo $users.user.displayname 
       $userID = $users.id 
       $url3="https://vsaex.dev.azure.com/$($organization)/_apis/userentitlements/$($userID)?api-version=6.0-preview.3"
       $body = @'
       [{
            "from": "",
            "op": "replace",
            "path": "/accessLevel",
            "value": {
               "accountLicenseType": "advanced",
               "licensingSource": "account"
             }
    
         }]
'@
        $response3 = Invoke-RestMethod -Uri $url3 -Headers @{Authorization = "Basic $token"} -Method PATCH -Body $body -ContentType application/json-patch+json
        echo  $response3.operationResults.result.accessLevel.licenseDisplayName
    }
   
  }

}
