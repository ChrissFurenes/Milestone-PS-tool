Connect-ManagementServer -ShowDialog

$Folder = Select-VideoOSItem -AllowFolders -HideServerTab

foreach ($device in $Folder.Devices) {
   foreach ($cam in $device.Cameras) {
       $cam | Get-Snapshot -Live -Path "C:\Users\Public" -FileName "Snapshot_$(Get-Date -Format 'yyyyMMdd_HHmmss').jpg"  -Save
   }
}

Disconnect-ManagementServer


