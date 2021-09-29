<#
    .DESCRIPTION
        Powershell script to stop a azure webapp

    .PARAMETER WebAppName
        Name of web application which needs to be stopped

    .PARAMETER ResourceGroupName
        Name of resource group which needs to be stopped
        
    .NOTES
        AUTHOR: Chaitra D Dangat
        LASTEDIT: Sep 30, 2021
#>

Param
(
  [Parameter (Mandatory= $true)]
  [String] $WebAppName,
  
  [Parameter (Mandatory= $true)]
  [String] $ResourceGroupName
)

$connectionName = "AzureRunAsConnection"
try
{
    # Get the connection "AzureRunAsConnection "
    $servicePrincipalConnection=Get-AutomationConnection -Name $connectionName         

    "Logging in to Azure..."
    Add-AzureRmAccount `
        -ServicePrincipal `
        -TenantId $servicePrincipalConnection.TenantId `
        -ApplicationId $servicePrincipalConnection.ApplicationId `
        -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint 

    "Stopping website"
    Stop-AzureRmWebApp -ResourceGroupName $ResourceGroupName -Name $WebAppName
}
catch {
    if (!$servicePrincipalConnection)
    {
        $ErrorMessage = "Connection $connectionName not found."
        throw $ErrorMessage
    } else{
        Write-Error -Message $_.Exception
        throw $_.Exception
    }
}