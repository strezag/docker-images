[CmdletBinding()]
[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingPlainTextForPassword", "SitecorePassword")]
param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()] 
    [string]$Path
    ,
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()] 
    [string]$Destination
    ,
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$SitecoreUsername
    ,
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$SitecorePassword
)

# setup
$sitecoreDownloadUrl = "https://dev.sitecore.net"
$sitecoreDownloadSession = $null

# ensure destination exists
if (!(Test-Path $Destination -PathType "Container"))
{
    New-Item $Destination -ItemType Directory -WhatIf:$false | Out-Null
}

Write-Host ("Downloading files into '{0}'..." -f $Destination)
 
Get-Content -Raw $Path | ConvertFrom-Json -PipelineVariable jo | Get-Member -Type  NoteProperty | ForEach-Object { 
    $fileName = $_.Name
    $filePath = Join-Path $Destination $fileName
    $fileUrl = ($jo.$($_.Name)).url

    # if needed, login to dev.sitecore.net and save session for re-use
    if ($fileUrl.StartsWith($sitecoreDownloadUrl) -and $null -eq $sitecoreDownloadSession)
    {
        Write-Host ("Logging in to '{0}' using username '{1}'..." -f $sitecoreDownloadUrl, $SitecoreUsername)

        $loginResponse = Invoke-WebRequest ("{0}/api/authorization" -f $sitecoreDownloadUrl) -Method Post -Body @{
            username   = $SitecoreUsername
            password   = $SitecorePassword
            rememberMe = $true
        } -SessionVariable "sitecoreDownloadSession" -UseBasicParsing

        if ($null -eq $loginResponse -or $loginResponse.StatusCode -ne 200 -or $loginResponse.Content -eq "false")
        {
            throw ("Unable to login to '{0}' with the supplied credentials." -f $sitecoreDownloadUrl)
        }

        Write-Host ("Logged in to '{0}'." -f $sitecoreDownloadUrl)
    }
    
    Write-Host ("Downloading '{0}' from '{1}'..." -f $fileName, $fileUrl)

    Invoke-WebRequest -Uri $fileUrl -OutFile $filePath -WebSession $sitecoreDownloadSession -UseBasicParsing
}

Write-Host "Downloads completed."