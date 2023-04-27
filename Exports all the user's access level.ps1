#Fill in these values: $token + $env:Path + $Orgname

#Provide the Personal Access Token from the right organization
$token = "PAT"

#Provide the path and the file name
$env:Path = "Your_path"

#Provide the organization name
$Orgname = "OrgName"

$UserGroupsObject = @()

#Reads up to 1000 users 
$url="https://vsaex.dev.azure.com/$Orgname/_apis/userentitlements?top=1000&api-version=5.1-preview.1"

$token = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$($token)"))
 
$response = Invoke-RestMethod -Uri $url -Headers @{Authorization = "Basic $token"} -Method Get  -ContentType application/json
 
ForEach ($oneuser in $response.value)
{

   $UserGroupsObject += New-Object -TypeName PSObject -Property @{ 
 
   UserDisplayName = $oneuser.user.displayName
 
   AccessLevelName = $oneuser.accessLevel.licenseDisplayName
    
    }
    
    }  

 
#Exoprts the info to the path you have specified
 $UserGroupsObject | Export-csv -Path $env:Path  -NoTypeInformation