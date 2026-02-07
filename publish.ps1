$ProjectsPath = "storage/docker" # Must NOT end with slash
$ProjectName = (Split-Path (Get-Location).Path -Leaf)
$DockerTag = ("summeryway:5000/$ProjectName" + ":latest")
$DiscordWebhookUri = "https://discord.com/api/webhooks/1427485288535425047/mkOb33uf21BK09NE9EFS6rQvNZj7S1ceIyWm1bh7cKURggV3eaoCSfdbtbsR7IYpjfis"
function Update-Channel {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Message
    )

    Write-Host $Message

    $payload = @{
        content = "$Message
-# From: $ProjectName"
    } | ConvertTo-Json

    Start-Job { Invoke-RestMethod -Uri ($using:DiscordWebhookUri) -Method Post -Body ($using:payload) -ContentType 'application/json' | Out-Null }
}
function Exit-Error {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Message
    )

    $UncaughtError = $Error[0].Exception.Message
    
    Write-Error $Message

    $payload = @{
        content = "# ERROR: $Message
$UncaughtError
-# From: $ProjectName"
    } | ConvertTo-Json

    Start-Job { Invoke-RestMethod -Uri ($using:DiscordWebhookUri) -Method Post -Body ($using:payload) -ContentType 'application/json' | Out-Null }

    Exit 1
}


Update-Channel "# Creating new Update for $ProjectName"
docker build -t $DockerTag .
if ($LASTEXITCODE -ne 0) {
    Exit-Error "Couldn't build!"
}

Update-Channel "Uploading the update to the server"
docker push $DockerTag
if ($LASTEXITCODE -ne 0) {
    Exit-Error "Couldn't upload to server!"
}

Update-Channel "Restarting $ProjectName on server..."
ssh summerwya@summeryway "cd $ProjectsPath/$ProjectName && sudo sh run.sh"
if ($LASTEXITCODE -ne 0) {
    Exit-Error "Couldn't update server image!"
}
Update-Channel "Update Uploaded and Finished Rolling out!"