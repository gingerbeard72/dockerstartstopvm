$rg = $env:rg

$tenantId = "Your Tenanat ID"
$ApplicationId = "Your SPN ID"
$securePassword = " Your Password" | ConvertTo-SecureString -AsPlainText -Force

Connect-AzAccount -Subscription "Your Subscription ID" -TenantId $tenantId -ApplicationId $ApplicationId -CertificatePath './docker1.pfx' -CertificatePassword $securePassword

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
    
