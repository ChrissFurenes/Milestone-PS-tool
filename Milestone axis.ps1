

Connect-ManagementServer -ShowDialog


$hassSD = $null
$run = 1
$list = @()
#$list | Add-Member -MemberType NoteProperty -Name "Navn" -Value $null
#$list | Add-Member -MemberType NoteProperty -Name "SD" -Value $null
#$list | Add-Member -MemberType NoteProperty -Name "IP" -Value $null
##$list | Add-Member -MemberType NoteProperty -Name "Recodrin Server" -Value $null
#$list | Add-Member -MemberType NoteProperty -Name "Model" -Value $null
#$list | Add-Member -MemberType NoteProperty -Name "API" -Value $null

$items = Select-VideoOSItem -Category Server -AllowServers -AllowFolders -HideGroupsTab -Title "Select RecodingServer"

if ($items -ne $null){
        
    $tingtang = (Get-RecordingServer -Name $items.Name | Get-Hardware) 
    #$tingtang.Count
    foreach ($camera in Get-RecordingServer -Name $items.Name | Get-Hardware ){
        
        
        Write-Progress -Activity ("Henter data  "+((100/$tingtang.Count)*$run) +"%") -Status $camera.Name -PercentComplete (100/($tingtang.Count)*$run++)
        Start-Sleep -Milliseconds 1000
        $response = $null
        if ($camera.Name.Contains(" ") -and $camera.Enabled){
            $pass = $camera | Get-HardwarePassword
            $user = $camera.UserName
            try {
            $response = curl ($camera.Address + "axis-cgi/disks/list.cgi?diskid=SD_DISK") -Credential ([PSCredential]::new($user, (ConvertTo-SecureString -String $pass -AsPlainText -Force)))  
            }catch{
            #echo ($camera.Name + " Støtter ikke denne APIen")
            $hassSD = $false
            $api = $false
            }
            if ($response.StatusCode -eq 200){
                $api = $true
                $xml = [XML]$response.Content
                if ($xml.root.disks.disk.status -eq "disconnected"){
                    #echo ($camera.Name + " Mangler sd kort")
                    $hassSD = $false
                }else{
                    $hassSD = $true
                }
                
            }
            #$list | Add-Member -MemberType NoteProperty -Name "Navn" -Value $camera.Name
            #$list | Add-Member -MemberType NoteProperty -Name "SD" -Value $hassSD
            #$list | Add-Member -MemberType NoteProperty -Name "IP" -Value $camera.Address
            #$list | Add-Member -MemberType NoteProperty -Name "Recodrin Server" -Value $items.Name
            #$list | Add-Member -MemberType NoteProperty -Name "Model" -Value $camera.Model
            #$list | Add-Member -MemberType NoteProperty -Name "API" -Value $api
            $list += New-Object -TypeName psobject -Property @{Navn=$camera.Name;SD=$hassSD;IP=$camera.Address;"Recordin Server"=$items.Name;Mode=$camera.Model;API=$api}
        }
    }
}
$list
Start-Sleep -Milliseconds 5000
Disconnect-ManagementServer
