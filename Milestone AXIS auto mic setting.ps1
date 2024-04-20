$server = "localhost"
$path_to_config = "C:\Users\Milestone\Desktop\Milestone auto update axis mic konfig\"
$needs_credentials = $true
$useBasicUser = $false
$username = "DESKTOP-VR3VNGT\Milestone"
$password = "Tusse1009"

$content = "application/json"
$api = "axis-cgi/audiodevicecontrol.cgi"

if($needs_credentials){
    $server_credentials = ([PSCredential]::new($username, (ConvertTo-SecureString -String $password -AsPlainText -Force)))
    if($useBasicUser){
        Connect-ManagementServer -Server $server -Credential $server_credentials -BasicUser
    }else{
        Connect-ManagementServer -Server $server -Credential $server_credentials
    }
}else{
    Connect-ManagementServer -Server $server
}

$response = $null
ForEach ($camera in Get-Hardware){
    if ($camera.Name.Contains("AXIS") -and $camera.Enabled){
        $pass = $camera | Get-HardwarePassword
        $user = $camera.UserName
        $ip = ($camera.Address.Substring(7) -replace “.$”)
        $credentials = ([PSCredential]::new($user, (ConvertTo-SecureString -String $pass -AsPlainText -Force)))
        $url = ($camera.Address + $api)
        if ((Test-Connection -Count 1 -Quiet $ip) -and (Test-Path ($path_to_config + $ip + ".txt") -PathType Leaf)){
        
            try{
            echo "Endrer"
            echo ("URL: " + $camera.Address + "axis-cgi/audiodevicecontrol.cgi")
            echo ("Content type: " + $content)
            #echo ("Body: " + (Get-Content -Path ($ip +".txt")))
            $response = curl -Method Post $url -Credential $credentials -ContentType $content -Body (Get-Content -Path ($path_to_config + $ip +".txt"))
            echo "OK. Config er gjort"
            echo ($response.StatusCode)

            }catch{
            echo "Failet på config"
            echo ($response.StatusCode)
            }
        }else{
            echo ("Feilet. Sjekk kamera eller config! Kamera: " + $camera.Name + " med ip: " + $camera.Address)
        }
    }
}
Disconnect-ManagementServer
