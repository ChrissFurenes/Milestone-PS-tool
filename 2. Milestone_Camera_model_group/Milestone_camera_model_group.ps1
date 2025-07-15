
Connect-ManagementServer -ShowDialog

$hardvare = Get-VmsRecordingServer | Get-Hardware 



foreach ($device in $hardvare){

    if ((Get-DeviceGroup).DisplayName -contains $device.Model){
        foreach ($cam in (Get-VmsCamera -Hardware $device)){
            if((Get-VmsDeviceGroup -Name $device.Model | Get-VmsDeviceGroupMember).Id -ne $cam.Id -and $cam.Enabled){
                Add-VmsDeviceGroupMember -Group (Get-DeviceGroup -Name $device.Model) -Device $cam
            }
        }
    }else{
    New-VmsDeviceGroup -Name $device.Model
        foreach ($cam in (Get-VmsCamera -Hardware $device)){
            if((Get-VmsDeviceGroup -Name $device.Model | Get-VmsDeviceGroupMember).Id -ne $cam.Id -and $cam.Enabled){
                Add-VmsDeviceGroupMember -Group (Get-DeviceGroup -Name $device.Model) -Device $cam
            }
        }
    }
}
Disconnect-ManagementServer