Param
(
    [Parameter(Mandatory=$true, HelpMessage = "Please provide a valid resource group")]
    [string]$resourceGroupName,
    [Parameter(Mandatory=$true, HelpMessage = "Please provide a valid location")]
    [string]$resourceGroupLocation
 )

Get-AzResourceGroup -Name $ResourceGroupName -ErrorVariable notPresent -ErrorAction SilentlyContinue
Write-Host -ForegroundColor Green " *************** Creating resource group.. ****************"

if ($notPresent)
{
    Write-Host -ForegroundColor Yellow "resource group does not exist"
    New-AzResourceGroup -Name $ResourceGroupName -Location $resourceGroupLocation -Tag $tags
    Write-Host -ForegroundColor Green "$ResourceGroupName created succesfully at location $resourceGroupLocation"
}
else {
    Write-Host -ForegroundColor Yellow "resource group already  exist"
    Write-Host  -ForegroundColor Magenta "using resource group  $ResourceGroupName on location $resourceGroupLocation "
}
