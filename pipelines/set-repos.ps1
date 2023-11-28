param(
    [Parameter(Mandatory = $true)]
    [string] $FactoryName,

    [Parameter(Mandatory = $true)]
    [string] $RepositoryAccount,

    [Parameter(Mandatory = $true)]
    [string] $RepositoryName,

    [Parameter(Mandatory = $true)]

    [string] $BranchName
)

$factories = az datafactory list | ConvertFrom-Json
$account = az account show | ConvertFrom-Json



foreach($factory in $factories)
{
    $dfName = $factory.name
    $dfId = $factory.id
    $tenantId = $account.tenantId
    $location = $factory.location
    $rgName = $factory.resourceGroup

    if($factory.name.EndsWith($FactoryName))
    {
        az datafactory configure-factory-repo `
            --factory-resource-id "$dfId" `
            --location "$location" `
            --factory-git-hub-configuration account-name="$RepositoryAccount" repository-name="$RepositoryName" root-folder="/pipelines" collaboration-branch="$BranchName"
    }
}