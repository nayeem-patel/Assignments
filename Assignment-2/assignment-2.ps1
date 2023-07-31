$tenantId = Read-Host "Please Enter Your Tenant Id"
$subscriptionId = Read-Host "Please Enter your Azure Subscription Id"
$Credential = Get-Credential
Login-AzAccount -Credential $Credential -ServicePrincipal -TenantId $tenantId -Subscription $subscriptionId
$token=(Get-AzAccessToken).Token 
$url="https://management.azure.com/subscriptions/$subscriptionId/resourcegroups?api-version-2021-04-01"
$Headers = @{ Authorization = @{ Authorization = "Bearer $token"}
$responce=Invoke-RestMethod -Method Get -Uri $url -Headers $Headers | ConvertTo-Json
Write-Host $responce

