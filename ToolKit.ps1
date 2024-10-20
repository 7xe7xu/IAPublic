function Mostrar-BannerTol {
    param (
        [switch]$Continuo
    )

    function Dibujar-Banner {
        $consoleWidth = $Host.UI.RawUI.WindowSize.Width

        # Banner ASCII
        $banner = @(
"████████╗ ██████╗  ██████╗ ██╗     ██╗  ██╗██╗████████╗"
"╚══██╔══╝██╔═══██╗██╔═══██╗██║     ██║ ██╔╝██║╚══██╔══╝"
"   ██║   ██║   ██║██║   ██║██║     █████╔╝ ██║   ██║   "
"   ██║   ██║   ██║██║   ██║██║     ██╔═██╗ ██║   ██║   "
"   ██║   ╚██████╔╝╚██████╔╝███████╗██║  ██╗██║   ██║   "
"   ╚═╝    ╚═════╝  ╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝   ╚═╝   "
        )

        $maxWidth = ($banner | Measure-Object -Property Length -Maximum).Maximum
        $leftPadding = [math]::Max(0, [math]::Floor(($consoleWidth - $maxWidth) / 2))

        Clear-Host
        Write-Host ""
		Write-Host ""
		Write-Host ""
        $colors = @('DarkGreen', 'DarkGreen', 'Green', 'Green', 'Green', 'White')

        for ($i = 0; $i -lt $banner.Length; $i++) {
            $centeredLine = (" " * $leftPadding) + $banner[$i]
            Write-Host $centeredLine -ForegroundColor $colors[$i]
        }

        Write-Host "`n"  # 1 línea en blanco después del banner
        if ($Continuo) {
            Write-Host "Presiona Ctrl+C para salir" -ForegroundColor Yellow
        }
    }

    if ($Continuo) {
        try {
            $lastWidth = 0
            while ($true) {
                $currentWidth = $Host.UI.RawUI.WindowSize.Width
                if ($currentWidth -ne $lastWidth) {
                    Dibujar-Banner
                    $lastWidth = $currentWidth
                }
                Start-Sleep -Milliseconds 100
            }
        }
        finally {
            Clear-Host
        }
    } else {
        Dibujar-Banner
    }
}

function Mostrar-ToolKit {
    param(
        [Parameter(Mandatory=$false)]
        [string]$NombreEquipo = $env:COMPUTERNAME,
        [switch]$Continuo
    )

    function Dibujar-Menu {
        Clear-Host
        $host.UI.RawUI.BackgroundColor = "Black"
        Mostrar-BannerTol

        Escribir-Centrado "======================================"
        Escribir-Centrado ""
        Escribir-Centrado "Tool Kit ejecutándose desde $NombreEquipo"
        Escribir-Centrado ""
        Escribir-Centrado "======================================"
        Escribir-Centrado ""
        Escribir-Centrado "1. Apagar equipo remoto"
        Escribir-Centrado "2. Reiniciar equipo remoto"
        Escribir-Centrado "3. Sesiones y usuarios activos remoto"
        Escribir-Centrado "4. Firma ES equipo remoto (no funciona)"
        Escribir-Centrado "5. Firma PT equipo remoto (no funciona)"
        Escribir-Centrado "6. PSTools / CMD equipo remoto"
        Escribir-Centrado "7. PSTools / PowerShell equipo remoto"
        Escribir-Centrado "8. Número de serie equipo remoto"
        Escribir-Centrado "9. OCS equipo remoto"
        Escribir-Centrado "0. Volver al menú principal"
        Escribir-Centrado ""
        Escribir-Centrado "======================================"

        if ($Continuo) {
            Escribir-Centrado "`nPresiona Ctrl+C para salir"
        }

        $host.UI.RawUI.ForegroundColor = "White"
    }

    if ($Continuo) {
        try {
            $lastWidth = 0
            while ($true) {
                $currentWidth = $Host.UI.RawUI.WindowSize.Width
                if ($currentWidth -ne $lastWidth) {
                    Dibujar-Menu
                    $lastWidth = $currentWidth
                }
                Start-Sleep -Milliseconds 100
            }
        }
        finally {
            Clear-Host
        }
    } else {
        Dibujar-Menu
    }
}


function Apagar-EquipoRemoto {
    Write-Host ""
    $equipo = Read-Host "			 			  Nombre del equipo a apagar"
    Write-Host ""
    
    try {
        $result = & "C:\PSTools\PsExec.exe" \\$equipo -s shutdown /s /f /t 0 2>&1 | 
            Where-Object { 
                $_ -notmatch "PsExec v2\.11 - Execute processes remotely" -and 
                $_ -notmatch "Copyright \(C\) 2001-2014 Mark Russinovich" -and 
                $_ -notmatch "Sysinternals - www\.sysinternals\.com" -and 
                $_ -notmatch "Couldn't access" -and 
                $_ -notmatch "Controlador no vßlido\." -and 
                $_ -notmatch "Connecting to" -and
                $_ -notmatch "System\.Management\.Automation\.RemoteException"
            }
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "			 			  El equipo remoto $equipo se apagará inmediatamente." -ForegroundColor Green
        } else {
            $errorMessage = $result -join " "
            if ($errorMessage) {
                Write-Host "			 			  Error al apagar el equipo $equipo`: $errorMessage" -ForegroundColor Red
            } else {
                Write-Host "			 			  Error al apagar el equipo $equipo." -ForegroundColor Red
            }
        }
    } catch {
        Write-Host "			 			  Error al ejecutar el comando: $_" -ForegroundColor Red
    }
    
    Pause-Script
    Mostrar-ToolKit
}

function Reiniciar-EquipoRemoto {
    $computerName = $env:COMPUTERNAME
    $equipo = Read-Host "			 			  Nombre del equipo que quieres reiniciar"
    
    try {
        $result = & "C:\PSTools\PsExec.exe" \\$equipo -s shutdown /r /t 0 2>&1 | 
            Where-Object { 
                $_ -notmatch "PsExec v2.11 - Execute processes remotely" -and 
                $_ -notmatch "Copyright \(C\) 2001-2014 Mark Russinovich" -and 
                $_ -notmatch "Sysinternals - www.sysinternals.com" -and 
                $_ -notmatch "Couldn't access :" -and 
                $_ -notmatch "Controlador no vßlido." -and 
                $_ -notmatch "Connecting to" -and
                $_ -notmatch "System\.Management\.Automation\.RemoteException" -and
                $_ -notmatch "Couldn't access \d+:"
            }

        if ($LASTEXITCODE -eq 0) {
            Write-Host "			 			  Reiniciando equipo $equipo..." -ForegroundColor Green
        } else {
            Write-Host "			 			  Error al reiniciar el equipo $equipo." -ForegroundColor Red
            if ($result) {
                $filteredResult = $result | Where-Object { $_ -match '\S' }  # Filtrar líneas vacías
                if ($filteredResult) {
                    Write-Host "			 			  Mensaje de error:" -ForegroundColor Red
                    $filteredResult | ForEach-Object { Write-Host "			 			  $_" -ForegroundColor Red }
                }
            }
        }
    } catch {
        Write-Host "			 			  Error al ejecutar el comando: $_" -ForegroundColor Red
    }
    
    Pause-Script
    Mostrar-ToolKit
}

function SesionesUsuarios-EquipoRemoto {
    Write-Host ""
    $equipo = Read-Host "			 			  Nombre del equipo [este]"
    Write-Host ""
    
    $sesiones = query session /server:$equipo 2>&1
    if ($sesiones -is [string]) {
        Write-Host "			 			  $sesiones"
    } else {
        $sesiones | ForEach-Object { Write-Host "			 			  $_" }
    }
    
    Write-Host ""
    $usuarios = query user /server:$equipo 2>&1
    if ($usuarios -is [string]) {
        Write-Host "			 			  $usuarios"
    } else {
        $usuarios | ForEach-Object { Write-Host "			 			  $_" }
    }
    
    if ($sesiones -notmatch "No existe un usuario para" -and $usuarios -notmatch "No existe un usuario para") {
        $sesionID = Read-Host "			 			  Número ID de la sesión a cerrar"
        
        try {
            $result = logoff $sesionID /server:$equipo 2>&1
            if ($LASTEXITCODE -eq 0) {
                Write-Host "			 			  Sesión cerrada" -ForegroundColor Green
            } else {
                Write-Host "			 			  Error al cerrar la sesión: $result" -ForegroundColor Red
            }
        } catch {
            Write-Host "			 			  Error al ejecutar el comando: $_" -ForegroundColor Red
        }
    }
    
    Pause-Script
    Mostrar-ToolKit
}

function FirmaES-EquipoRemoto {
    Write-Host ""
    $equipo = Read-Host "                       Nombre equipo"
    Write-Host ""
    
    $scriptPath = "\\seresco.red\recursos\rep\correo\Firmas2022\firma_seresco_2022.ps1"
    $psExecPath = "C:\PSTOOLS\PsExec.exe" # Asegúrate de que esta ruta sea correcta

    try {
        # Obtener la lista de usuarios conectados en el equipo remoto
        Write-Host "                       Obteniendo lista de usuarios..."
        $sesiones = quser /server:$equipo 2>&1
        
        if ($LASTEXITCODE -eq 0 -and $sesiones -notmatch "No existe un usuario para") {
            Write-Host "                       Usuarios conectados en $equipo`:"
            $usuarios = $sesiones | Select-Object -Skip 1 | ForEach-Object {
                $linea = $_ -split '\s+'
                if ($linea.Count -ge 3) {
                    [PSCustomObject]@{
                        Usuario = $linea[1]
                        Estado = $linea[3]
                    }
                }
            }
            $usuarios | Format-Table -AutoSize | Out-String | ForEach-Object { Write-Host "                       $_" }
            
            # Pedir al usuario que elija un nombre de usuario
            $usuarioElegido = Read-Host "                       Introduzca el nombre del usuario para ejecutar el script"
            
            # Verificar si el usuario elegido está en la lista
            $usuarioEncontrado = $usuarios | Where-Object { $_.Usuario -eq $usuarioElegido }
            
            if (-not $usuarioEncontrado) {
                Write-Host "                       El usuario elegido no está en la lista de usuarios conectados." -ForegroundColor Red
                Write-Host "                       Usuarios disponibles: $($usuarios.Usuario -join ', ')" -ForegroundColor Yellow
                Pause-Script
                return
            }
            
            # Ejecutar el script como el usuario seleccionado usando PsExec
            Write-Host "                       Ejecutando script como $usuarioElegido..."
            
            $comando = "$psExecPath \\$equipo -u $usuarioElegido -i powershell.exe -ExecutionPolicy Bypass -File `"$scriptPath`""
            
            Write-Host "                       Comando a ejecutar: $comando" -ForegroundColor Cyan
            
            $result = Invoke-Expression $comando

            if ($result) {
                Write-Host "                       Resultado de la ejecución:" -ForegroundColor Green
                $result | ForEach-Object { Write-Host "                       $_" }
            } else {
                Write-Host "                       No se recibió ningún resultado de la ejecución." -ForegroundColor Yellow
            }
        } else {
            Write-Host "                       No se encontraron usuarios conectados en el equipo $equipo." -ForegroundColor Yellow
            Write-Host "                       Volviendo al menú principal..." -ForegroundColor Cyan
        }
        
    } catch {
        Write-Host "                       Error: $_" -ForegroundColor Red
    }
    
    Pause-Script
    Mostrar-ToolKit
}

function FirmaPT-EquipoRemoto {
    Write-Host ""
    $equipo = Read-Host "                       Nombre equipo"
    Write-Host ""
    
    $scriptPath = "\\seresco.red\recursos\rep\correo\Firmas2022\firma_seresco_PT_2022"
    $psExecPath = "C:\PSTOOLS\PsExec.exe" # Asegúrate de que esta ruta sea correcta

    try {
        # Obtener la lista de usuarios conectados en el equipo remoto
        Write-Host "                       Obteniendo lista de usuarios..."
        $sesiones = quser /server:$equipo 2>&1
        
        if ($LASTEXITCODE -eq 0 -and $sesiones -notmatch "No existe un usuario para") {
            Write-Host "                       Usuarios conectados en $equipo`:"
            $usuarios = $sesiones | Select-Object -Skip 1 | ForEach-Object {
                $linea = $_ -split '\s+'
                if ($linea.Count -ge 3) {
                    [PSCustomObject]@{
                        Usuario = $linea[1]
                        Estado = $linea[3]
                    }
                }
            }
            $usuarios | Format-Table -AutoSize | Out-String | ForEach-Object { Write-Host "                       $_" }
            
            # Pedir al usuario que elija un nombre de usuario
            $usuarioElegido = Read-Host "                       Introduzca el nombre del usuario para ejecutar el script"
            
            # Verificar si el usuario elegido está en la lista
            $usuarioEncontrado = $usuarios | Where-Object { $_.Usuario -eq $usuarioElegido }
            
            if (-not $usuarioEncontrado) {
                Write-Host "                       El usuario elegido no está en la lista de usuarios conectados." -ForegroundColor Red
                Write-Host "                       Usuarios disponibles: $($usuarios.Usuario -join ', ')" -ForegroundColor Yellow
                Pause-Script
                return
            }
            
            # Ejecutar el script como el usuario seleccionado usando PsExec
            Write-Host "                       Ejecutando script como $usuarioElegido..."
            
            $comando = "$psExecPath \\$equipo -u $usuarioElegido -i powershell.exe -ExecutionPolicy Bypass -File `"$scriptPath`""
            
            Write-Host "                       Comando a ejecutar: $comando" -ForegroundColor Cyan
            
            $result = Invoke-Expression $comando

            if ($result) {
                Write-Host "                       Resultado de la ejecución:" -ForegroundColor Green
                $result | ForEach-Object { Write-Host "                       $_" }
            } else {
                Write-Host "                       No se recibió ningún resultado de la ejecución." -ForegroundColor Yellow
            }
        } else {
            Write-Host "                       No se encontraron usuarios conectados en el equipo $equipo." -ForegroundColor Yellow
            Write-Host "                       Volviendo al menú principal..." -ForegroundColor Cyan
        }
        
    } catch {
        Write-Host "                       Error: $_" -ForegroundColor Red
    }
    
    Pause-Script
    Mostrar-ToolKit
}

function PSToolsCMD-EquipoRemoto {
    Write-Host ""
    $equipo = Read-Host "			 			  Nombre de equipo"
    $psExecPath = "C:\PSTools\PsExec.exe" # Asegúrate de que esta ruta sea correcta
    $indentation = "			 			  " # Espacios para el desplazamiento a la derecha

    Write-Host "$indentationIniciando sesión CMD remota en $equipo..." -ForegroundColor Cyan
    
    # Ejecutamos PsExec directamente
    & $psExecPath "\\$equipo" -accepteula cmd

    Write-Host "$indentationSesión CMD remota finalizada." -ForegroundColor Green

    Pause-Script
    Mostrar-ToolKit
}

function PSToolsPS-EquipoRemoto {
    Write-Host ""
    $equipo = Read-Host "			 			  Nombre de equipo"
    $psExecPath = "C:\PSTools\PsExec.exe" # Asegúrate de que esta ruta sea correcta
    $indentation = "			 			  " # Espacios para el desplazamiento a la derecha

    Write-Host "$indentationIniciando sesión PowerShell remota en $equipo..." -ForegroundColor Cyan
    
    & $psExecPath "\\$equipo" -accepteula PowerShell.exe

    Write-Host "$indentationSesión PowerShell remota finalizada." -ForegroundColor Green

    Pause-Script
}

function NumeroSerie-EquipoRemoto {
    Write-Host ""
    $equipo = Read-Host "			 			  Nombre de equipo [este]"
    $psExecPath = "C:\PSTools\PsExec.exe" # Asegúrate de que esta ruta sea correcta
    $indentation = "			 			  " # Espacios para el desplazamiento a la derecha

    if ([string]::IsNullOrWhiteSpace($equipo)) {
        $equipo = $env:COMPUTERNAME
        Write-Host "$indentation Usando el equipo local: $equipo" -ForegroundColor Cyan
    }

    try {
        Write-Host "$indentation Obteniendo número de serie de $equipo..." -ForegroundColor Cyan
        
        if ($equipo -eq $env:COMPUTERNAME) {
            # Si es el equipo local, usamos directamente wmic
            $output = wmic bios get serialnumber
        } else {
            # Para equipos remotos, usamos PsExec
            $process = Start-Process -FilePath $psExecPath -ArgumentList "\\$equipo -accepteula -s cmd /c `"wmic bios get serialnumber`"" -NoNewWindow -Wait -RedirectStandardOutput "temp_output.txt" -RedirectStandardError "temp_error.txt"
            $output = Get-Content "temp_output.txt"
            $error_output = Get-Content "temp_error.txt"
            Remove-Item "temp_output.txt", "temp_error.txt" -ErrorAction SilentlyContinue
        }

        # Filtramos y procesamos la salida
        $serialNumber = $output | Where-Object { 
            $_ -match '\S' -and 
            $_ -notmatch 'SerialNumber' -and
            $_ -notmatch 'PsExec|Copyright|Sysinternals|Starting|exited|cmd'
        } | Select-Object -First 1 | ForEach-Object { $_.Trim() }

        if ($serialNumber) {
            Write-Host "$indentation Número de serie: $serialNumber" -ForegroundColor Green
        } else {
            Write-Host "$indentation No se pudo obtener el número de serie." -ForegroundColor Yellow
            if ($error_output) {
                Write-Host "$indentation Error: $error_output" -ForegroundColor Red
            }
        }
    } catch {
        Write-Host "$indentation Error: $_" -ForegroundColor Red
    }

    Pause-Script
    Mostrar-ToolKit
}

function OCS-EquipoRemoto {
    Write-Host ""
    $equipo = Read-Host "						  Nombre de equipo"
    $psExecPath = "C:\PSTools\PsExec.exe" # Asegúrate de que esta ruta sea correcta
    $ocsPath = "C:\Program Files (x86)\OCS Inventory Agent\OCSInventory.exe"
    $indentation = "						  " # Espacios para el desplazamiento a la derecha

    Write-Host "$indentation Intentando conectar con $equipo..." -ForegroundColor Cyan
    
    if (-not (Test-Path $psExecPath)) {
        Write-Host "$indentation Error: PsExec no encontrado en $psExecPath" -ForegroundColor Red
        Pause-Script
        return
    }

    try {
        # Ejecutamos PsExec y capturamos la salida y el código de salida
        $output = & $psExecPath "\\$equipo" -accepteula -s $ocsPath /FORCE 2>&1
        $exitCode = $LASTEXITCODE

        if ($exitCode -eq 0) {
            # Solo mostramos el mensaje en verde si la ejecución fue exitosa
            Write-Host "$indentation Petición OCS enviada con éxito para $equipo" -ForegroundColor Green
        } else {
            Write-Host "$indentation Error al enviar petición OCS para $equipo (Código de salida: $exitCode)" -ForegroundColor Red
            Write-Host "$indentation Detalles del error:" -ForegroundColor Red
            $output | ForEach-Object { Write-Host "$indentation $_" -ForegroundColor Red }
            # No continuamos con el script si hay un error
            return
        }
    } catch {
        Write-Host "$indentation Error inesperado al ejecutar PsExec: $_" -ForegroundColor Red
        Write-Host "$indentation Stack Trace: $($_.ScriptStackTrace)" -ForegroundColor Red
        # No continuamos con el script si hay una excepción
        return
    }

    Pause-Script
    Mostrar-ToolKit
}

function Menu-ToolKit {
    do {
        Mostrar-ToolKit
        $option = Read-Host "						  Seleccione una opción"
        
        switch ($option) {
            "1" { Apagar-EquipoRemoto }
            "2" { Reiniciar-EquipoRemoto }
            "3" { SesionesUsuarios-EquipoRemoto }
            "4" { FirmaES-EquipoRemoto }
            "5" { FirmaPT-EquipoRemoto }
            "6" { PSToolsCMD-EquipoRemoto }
            "7" { PSToolsPS-EquipoRemoto }
            "8" { NumeroSerie-EquipoRemoto }
            "9" { OCS-EquipoRemoto }
            "0" { 

                return 
            }
            default { 
                Write-Host "						  Opción incorrecta, selecciona una opción válida." -ForegroundColor Red
                Start-Sleep -Seconds 2
            }
        }
        
        if ($option -ne '0') {
            Write-Host "`n						  Presione cualquier tecla para continuar..."
            [void][System.Console]::ReadKey($true)
        }
    } while ($true)
}

Menu-ToolKit