Connect-ManagementServer -ShowDialog

$items = Select-VideoOSItem -Category Server -AllowServers -AllowFolders -HideServerTab
foreach ($camera in Get-RecordingServer -Name $items.Name | Get-Hardware ){
    if ($camera.Model.Contains("AXIS") -and $camera.Enabled){
        $pass = $camera | Get-HardwarePassword
        $user = $camera.UserName
        $response = curl ($camera.Address + "axis-cgi/disks/list.cgi?diskid=SD_DISK") -Credential ([PSCredential]::new($user, (ConvertTo-SecureString -String $pass -AsPlainText -Force)))  
        $xml = [XML]$response.Content
        if ($xml.root.disks.disk.name -eq ""){
            echo ($camera.Name + " Mangler sd kort")
        }
    }
}
Disconnect-ManagementServer