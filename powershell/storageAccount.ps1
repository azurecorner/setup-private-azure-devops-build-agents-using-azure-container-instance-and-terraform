
Param
(
    [Parameter(Mandatory=$true, HelpMessage = "Please provide a valid resource group")]
    [string]$resourceGroupName,
    [Parameter(Mandatory=$true, HelpMessage = "Please provide a valid location")]
    [string]$resourceGroupLocation,
    [Parameter(Mandatory=$true, HelpMessage = "Please provide a valid storageAccountName")]
    [string]$storageAccountName
 )

$application ='datasynchro';

$resourceGroupTags = @{"application"="$application"; 
                       "environment"="dev"}

$storageAccountSku="Standard_LRS"

$storageSpokeContainerName = 'backend-tfstate-spokes'

$StorageHT = @{
    ResourceGroupName = $ResourceGroupName
    Name              =  $storageAccountName 
    SkuName           =  $storageAccountSku
    Location          =  $resourceGroupLocation
    Tags              = $resourceGroupTags
  }


Write-Host -ForegroundColor Green "*************** Creating storage account.. ***************"  
## Get the storage account in which container has to be created  
$storageAcc=Get-AzStorageAccount -ResourceGroupName $ResourceGroupName -Name $storageAccountName -ErrorAction SilentlyContinue
if(!$storageAcc){ 
    Write-Host -ForegroundColor Yellow "storage account does not exist.."    
    $storageAcc = New-AzStorageAccount @StorageHT  
    Write-Host -ForegroundColor Green "$storageAccountName created succesfully at location $location"

    ## Get the storage account context  
    $ctx=$storageAcc.Context      
    Write-Host -ForegroundColor Green "*************** Creating storage container.. ***************"  


        ## Check if the storage container exists  
        if(Get-AzStorageContainer -Name $storageSpokeContainerName -Context $ctx -ErrorAction SilentlyContinue)  
        {  
            Write-Host -ForegroundColor Yellow $storageSpokeContainerName "- container already exists."  
            Write-Host  -ForegroundColor Magenta "using storage container $storageSpokeContainerName on location $location "
        }  
        else  
        {  
            Write-Host -ForegroundColor Magenta $storageSpokeContainerName "- container does not exist."   
            ## Create a new Azure Storage Account  
            New-AzStorageContainer -Name $storageSpokeContainerName -Context $ctx -Permission Container  
            Write-Host -ForegroundColor Green " $storageSpokeContainerName created succesfully at location $location"
        }
    }
    
    else {
        Write-Host -ForegroundColor Yellow "storage account already  exist"
        Write-Host  -ForegroundColor Magenta "using storage account $storageAccountName on location $resourceGroupLocation  "
    }

   