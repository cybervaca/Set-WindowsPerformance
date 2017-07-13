$ErrorActionPreference = "SilentlyContinue"
function informa{param($texto)
Write-Host "`n[+]" -ForegroundColor Green -NoNewline ; Write-Host  " $texto" -ForegroundColor white -NoNewline ; Write-Host " $MAC" -ForegroundColor Green -NoNewline
sleep -Seconds 2}

function check-admin {If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {informa "Tienes que ejecutar el software como Administrador";break} }
$banner = @"

  ____            __                                            
 |  _ \ ___ _ __ / _| ___  _ __ _ __ ___   __ _ _ __   ___ ___  
 | |_) / _ \ '__| |_ / _ \| '__| '_ ' _ \ / _' | '_ \ / __/ _ \ 
 |  __/  __/ |  |  _| (_) | |  | | | | | | (_| | | | | (_|  __/ 
 |_|   \___|_|  |_|  \___/|_|  |_| |_| |_|\__,_|_| |_|\___\___| 
 __        ___           _                     _  ___           
 \ \      / (_)_ __   __| | _____      _____  / |/ _ \          
  \ \ /\ / /| | '_ \ / _' |/ _ \ \ /\ / / __| | | | | |         
   \ V  V / | | | | | (_| | (_) \ V  V /\__ \ | | |_| |         
    \_/\_/  |_|_| |_|\__,_|\___/ \_/\_/ |___/ |_|\___/  Fix FPS

"@


########################################### Variables #######################################################################

[int]$n = 0
[int]$x = 0

$posible_directorio_1 = (ls ${env:ProgramFiles(x86)} -Recurse  | Where-Object {$_.Directory -like "*Offensive\csgo\resource\flash"}).DirectoryName[0]
$posible_directorio_2 = (ls ${env:ProgramFiles} -Recurse  | Where-Object {$_.Directory -like "*Offensive\csgo\resource\flash"}).DirectoryName[0]
$posible_directorio_1 = $posible_directorio_1 + "\BACKGROUND*"
$posible_directorio_2 = $posible_directorio_2 + "\BACKGROUND*"

##############################################################################################################################


Write-Host $banner -ForegroundColor Green
Write-Host "                                                   by CyberVaca" -ForegroundColor red ; sleep -Seconds 2
informa "Buscando Servicio Steam Client Service ..." ; 
if ((Get-Service -Name "Steam Client Service").status -ne "Stopped") {informa "No hemos encontrado el servicio :_("} else {informa "Servicio encontrado, se procede a parar el servicio";$n++;Get-Service -Name "Steam Client Service" | Stop-Service ;set-Service -Name "Steam Client Service" -StartupType Manual}

if ((Get-ItemProperty registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection).allowtelemetry -eq 1) {informa "Telemetria Activada, se procede a la desactivacion";$n++; Set-ItemProperty registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection -Name AllowTelemetry -Value 0 } else {informa "La Telemetria esta desactivada"}

if ((get-ItemProperty registry::HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo).Enabled -eq 1) {informa "AdvertisingInfo esta activado, se procede a la desactivacion";$n++; Set-ItemProperty registry::HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo -Name Enabled -Value 0} else {informa "AdvertisingInfo esta desactivado"}

if ((Get-ItemProperty registry::HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost).EnableWebContentEvaluation -eq 1 ) {informa "SmartScreen Filter esta activado, se procede a la desactivacion";$n++; Set-ItemProperty registry::HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost -Name EnableWebContentEvaluation -Value 0} else {informa "SmartScreen Filter esta desactivado"}

if ((Get-ItemProperty registry::HKEY_CURRENT_USER\SOFTWARE\Microsoft\Input\TIPC).enabled -eq 1) {informa "TIPC esta activado, se procede a la desactivacion";$n++; Set-ItemProperty registry::HKEY_CURRENT_USER\SOFTWARE\Microsoft\Input\TIPC -name Enabled -Value 0} else {informa "TIPC esta desactivado"}

if ((Get-Service diagtrack).Status -ne "Stopped") {informa "Servicio de Telemetria activado, se procede a parar el servicio y deshabilitar su inicio";$n++; stop-Service DiagTrack ; Set-Service "DiagTrack" -StartupType Disabled } else {informa "Servicio de Telemetria esta desactivado"}

if ((Get-ItemProperty "registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search").allowcortana -ne 0 ) {informa "Cortana esta activado, se procede a la desactivacion";$n++; New-Item "registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search" ;New-ItemProperty "registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search"  -Name AllowCortana -Value 0} else {informa "Cortana esta desactivado"}

if ((Get-ItemProperty "registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management").ClearPageFileAtShutdown -ne 0) {informa "Limpieza de archivo de paginacion en el apagado no esta activo, se procede a su activacion"; $n++;set-ItemProperty "registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name ClearPageFileAtShutdown -Value 1}

if ((Get-ItemProperty registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize).StartupDelayInMSec -ne 0) {informa "El arranque de Windows no esta optimizado, se procede a su optimizacion";$n++; new-Item registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer -Name Serialize; New-ItemProperty registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize -Name StartupDelayInMSec -Value 0} else {informa "El arranque de Windows esta optimizado"}

if ((Get-ItemProperty "registry::HKEY_CLASSES_ROOT\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}")."System.IsPinnedToNameSpaceTree" -ne 0)  {informa "Detectado OneDrive en Explorer, se procede a su desactivacion";$n++; Set-ItemProperty "registry::HKEY_CLASSES_ROOT\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" -Name "System.IsPinnedToNameSpaceTree" -Value 0} else {informa "OneDrive en Explorer esta desactivado"}

if ((Get-ItemProperty "registry::HKEY_CURRENT_USER\Control Panel\International\User Profile").HttpAcceptLanguageOptOut -ne 0) {Set-ItemProperty "registry::HKEY_CURRENT_USER\Control Panel\International\User Profile" -Name HttpAcceptLanguageOptOut -Value 0}

informa "Creando Regkeys para desactivar GameDVR" ; New-ItemProperty registry::HKEY_CURRENT_USER\System\GameConfigStore\ -Name GameDVR_Enabled -Value 0 -Force | Out-Null

if (((Get-AppxPackage -Name "*3dbuilder*").name).count -ne 0) {informa "Desinstalando 3DBuilder`n";$x++; Get-AppxPackage -Name "*3dbuilder*"  | Remove-AppxPackage | Out-Null}
if (((Get-AppxPackage -Name "*windowsmaps*" ).name).count -ne 0) {informa "Desinstalando WindowsMaps`n";$x++;Get-AppxPackage -Name "*windowsmaps*" | Remove-AppxPackage | Out-Null}
if (((Get-AppxPackage -Name "*bingfinance*").name).count -ne 0) {informa "Desinstalando BingFinance`n";$x++;Get-AppxPackage -Name "*bingfinance*" | Remove-AppxPackage | Out-Null}
if (((Get-AppxPackage -Name "*bingnews*").name).count -ne 0) {informa "Desinstalando BingNews`n";$x++;Get-AppxPackage -Name "*bingnews*" | Remove-AppxPackage | Out-Null}
if (((Get-AppxPackage -Name "*windowsphone*").name).count -ne 0) {informa "Desinstalando Windows Phone app`n";$x++;Get-AppxPackage -Name "*windowsphone*" | Remove-AppxPackage | Out-Null}
if (((Get-AppxPackage -Name "*windowsstore*").name).count -ne 0) {informa "Desinstalando Windows Store`n";$x++;Get-AppxPackage -Name "*windowsstore*" | Remove-AppxPackage | Out-Null}
if (((Get-AppxPackage -Name "*bingsports*").name).count -ne 0) {informa "Desisntalando BingSports`n";$x++;Get-AppxPackage -Name "*bingsports*" | Remove-AppxPackage | Out-Null}
if (((Get-AppxPackage -Name "*xboxapp* ").name).count -ne 0) {informa "Desisntalando Xbox App`n" ;$x++;Get-AppxPackage -Name "*xboxapp*"  | Remove-AppxPackage | Out-Null}



informa "Corregidas $n/10 claves de registro"
informa "Apps de Windows desinstaladas $x/8"
informa "Buscando posible archivo corrupto 'BACKGROUND' dentro del CSGO "
if (Test-Path $posible_directorio_1 -eq $true) {informa "Detectado archivo corrupto, se procede a eliminar" ; Remove-Item $posible_directorio_1}
if (Test-Path $posible_directorio_2 -eq $true) {informa "Detectado archivo corrupto, se procede a eliminar" ;Remove-Item $posible_directorio_2}
informa "Su Windows ha quedado optimizado, es necesario reiniciar"

sleep -Seconds 5