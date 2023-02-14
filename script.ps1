$rg = $env:rg

$tenantId = "e5baac75-773b-4d69-a86e-c698458fbaba"
$ApplicationId = "56fa1eca-fdb4-42f5-b6d4-6f7c28e6684d"
# $ApplicationId = "10038af5-4c8a-44d6-a0ee-b85dbb737b4c"
# $clientsecret = "Nd.8Q~802y6Ra_HX1zhH_Czruv6Iycs-oeJzsbZ."
# $clientsecretid = "a959774c-3664-450f-a57e-bc065cd38489"

$securePassword = "password" | ConvertTo-SecureString -AsPlainText -Force

Connect-AzAccount -Subscription "740b9c7c-c9e4-4ca7-a8b1-7f86c65b259e" -TenantId $tenantId -ApplicationId $ApplicationId -CertificatePath './docker1.pfx' -CertificatePassword $securePassword

Write-Output "Logged in to Azure successfully using the service principle."
Select-AzSubscription -TenantId $tenantId
$vms = (get-azvm -ResourceGroupName $rg).name
$vms
Foreach ($vm in $vms) {
    
    get-azvm -Name $vm -ResourceGroupName $rg
    $vmstatus = (get-azvm -Name $vm -ResourceGroupName $rg -Status).Statuses.displayStatus[1]
    
    if ($vmstatus -eq "VM deallocated") {
        Write-Host "Virtual Machine $vm is stopped. No further action will be taken" -foregroundColor Red
    }

    if ($vmstatus -eq "VM running") {
    
        Write-Host "Stopping vm $vm............" -ForegroundColor DarkYellow
    
        Stop-AzVM -Name $vm -ResourceGroupName $rg -force -ErrorAction Continue -ErrorVariable failedStop
          
        Write-Host VM $vm has stopped, moving to starting the VM -ForegroundColor Green
        
        Write-Host "Starting vm $vm............" -ForegroundColor DarkYellow
    
        Start-AzVM -Name $vm -ResourceGroupName $rg -Confirm:$false -ErrorAction Continue -ErrorVariable failedStart

        Get-AzVM -name $vm -ResourceGroupName $rg -Status
        }
    }
    