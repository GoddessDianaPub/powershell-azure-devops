#You can remove the user's membership by using this PowerShell script.
#It will show you all the organizations, but you will see the user's details in the org the has a user at.
# $token (PAT) - the Personal Access Tokens need to be filled from this URL: "https://dev.azure.com/esi-grp/_usersSettings/tokens"
# $displayName - the user's Display Name need to be filled from this URL: "https://admin.microsoft.com/Adminportal/Home?source=applauncher#/users"

# $token (PAT) - the Personal Access Tokens need to be filled from this URL: "https://dev.azure.com/esi-grp/_usersSettings/tokens"
$token = "PAT” 
$B64Pat = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$token"))
$AzureDevOpsAuthenicationHeader = @{Authorization = 'Basic ' + $B64Pat }

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

 
# Go through all the users over all the organiztions and up to 1000 users
    $UriOrga = "https://dev.azure.com/" + $organization
    $uriOrgaUsers = "https://vsaex.dev.azure.com/" + $organization + "/_apis/userentitlements?top=1000&api-version=5.1-preview.2"
    
    $myResponse = Invoke-WebRequest -Uri $uriOrgaUsers -Method get -Headers $AzureDevOpsAuthenicationHeader
    
    if($myResponse.StatusCode -eq "200")
 
    {
    $uriget = (Invoke-RestMethod -Uri $uriOrgaUsers -Method get -Headers $AzureDevOpsAuthenicationHeader).members

    foreach($user in $uriget)
    {
        #Write-Host $user.user.displayName

        if ($user.user.displayName -eq "$displayName")
            {
                $UID= $user.user.descriptor
                Write-Host $user.user.displayName

                #list membership
                $uriOrgaUsersMembership =  "https://vssps.dev.azure.com/" + $organization + "/_apis/graph/Memberships/" +$UID+"?api-version=6.0-preview.1" 
                $uriMyMemberships = (Invoke-RestMethod -Uri $uriOrgaUsersMembership -Method get -Headers $AzureDevOpsAuthenicationHeader).value
                $status =  "0"

                foreach($groups in $uriMyMemberships)
                {
                    $groupID= $groups.containerDescriptor
                    #Write-Host $groupID

                    #group details
                    $urigroups =  "https://vssps.dev.azure.com/" +$organization + "/_apis/graph/groups/" + $groupID +"?api-version=6.0-preview.1"
                    $urigroupsResult = (Invoke-RestMethod -Uri $urigroups -Method get -Headers $AzureDevOpsAuthenicationHeader)

                    $PrincipalName = $urigroupsResult.principalName
                    #Write-Host $PrincipalName
            
                    # verify the required principles and delete the membership
                    #if($PrincipalName -eq "[DBA]\Contributors")
                    #{
                      $uriRemove =  "https://vssps.dev.azure.com/" +$organization+"/_apis/graph/memberships/"+$UID+"/"+$groupID+"?api-version=6.0-preview.1"
                      
                      $uriRemoveResult = Invoke-WebRequest -Uri $uriRemove -Method delete -Headers $AzureDevOpsAuthenicationHeader
                      if($uriRemoveResult.StatusCode -eq "200")
                      {
                      Write-Host $PrincipalName
                      $status = "1"
                      }
                      
                    #}


                }
                if($status -eq "1")
                {
                    Write-Host "Done"
                }

            }
    }
    }
    }