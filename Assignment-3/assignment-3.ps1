$jsonObject = @"
    {
        "a" : {
            "b" : {
                "c" : "d"
            }
        }
    }
"@

$jsonString = $jsonObject | ConvertFrom-Json
$keys = 'a/b/c'
$jsonKeys = $keys.Split('/')
$propertyValue = $jsonString
foreach ($key in $jsonKeys){
    $propertyValue = $propertyValue.$key
}

Write-Host $propertyValue | ConvertTo-Json
