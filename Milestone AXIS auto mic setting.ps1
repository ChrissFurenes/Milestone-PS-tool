$server = "localhost" # endre til din server
$path_to_config = "C:\Users\Milestone\Desktop\Milestone AXIS\" # endre til sti som inneholder konfig filer eks.."10.230.0.21.txt"
$needs_credentials = $true # sett til $false om credentials ikke er nødvendig
$useBasicUser = $false # sett til $true om du skal logge på milestone med basicuser
$username = "username" #brukernavn til server pålogging
$password = "password" #passord til server pålogging

$content = "application/json"
$api = "axis-cgi/audiodevicecontrol.cgi" # API url

# Kobler til management server
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
ForEach ($camera in Get-Hardware){ # henter alle kamera i milestone
    if ($camera.Name.Contains("AXIS") -and $camera.Enabled){ # kjører kun når det er et AXIS enhet
        $pass = $camera | Get-HardwarePassword #henter passord på enhet fra milestone
        $user = $camera.UserName #henter brukernavn på enhet fra milestone
        $ip = ($camera.Address.Substring(7) -replace “.$”) # setter verdien fra "http://10.230.0.21/" til "10.230.0.21"
        $credentials = ([PSCredential]::new($user, (ConvertTo-SecureString -String $pass -AsPlainText -Force))) # lager credentila til å bruke til API kalling
        $url = ($camera.Address + $api)
        if ((Test-Connection -Count 1 -Quiet $ip) -and (Test-Path ($path_to_config + $ip + ".txt") -PathType Leaf)){ # sjekker om enhet nås på ping og at konfig fil er til stede
        
            try{
            echo "Endrer"
            echo ("URL: " + $camera.Address + "axis-cgi/audiodevicecontrol.cgi")
            echo ("Content type: " + $content)
            #echo ("Body: " + (Get-Content -Path ($ip +".txt")))
            $response = curl -Method Post $url -Credential $credentials -ContentType $content -Body (Get-Content -Path ($path_to_config + $ip +".txt")) # kjører API
            echo "OK. Config er gjort"
            echo ($response.StatusCode)

            }catch{
            echo "Failet på config"
            echo ($response.StatusCode)
            }
        }else{
            echo ("Feilet. Sjekk kamera eller config! Kamera: " + $camera.Name + " med ip: " + $camera.Address)
            break
        }
    }
}
Disconnect-ManagementServer # Kobler fra management server
