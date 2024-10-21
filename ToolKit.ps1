function Escribir-Centrado {
    param(
        [string]$Texto,
        [string]$ColorDeFondo = $host.UI.RawUI.ForegroundColor,
        [string]$ColorDeFondoFondo = $host.UI.RawUI.BackgroundColor,
        [int]$Desplazamiento = 0,  # Número de espacios para desplazar el texto
        [switch]$NoNewline
    )

    $colores = @{
        "Amarillo" = "Yellow"
        "Azul" = "Blue"
        "Rojo" = "Red"
        "Verde" = "Green"
        "Cyan" = "Cyan"
        "Magenta" = "Magenta"
        "Blanco" = "White"
        "Negro" = "Black"
        "Gris" = "Gray"
        "GrisOscuro" = "DarkGray"
        "AzulOscuro" = "DarkBlue"
        "VerdeOscuro" = "DarkGreen"
        "CyanOscuro" = "DarkCyan"
        "RojoOscuro" = "DarkRed"
        "MagentaOscuro" = "DarkMagenta"
        "AmarilloOscuro" = "DarkYellow"
    }

    # Reemplazar el operador de fusión nula (??) con una estructura if-else
    if ($colores.ContainsKey($ColorDeFondo)) {
        $ColorDeFondo = $colores[$ColorDeFondo]
    }
    if ($colores.ContainsKey($ColorDeFondoFondo)) {
        $ColorDeFondoFondo = $colores[$ColorDeFondoFondo]
    }

    $anchoConsola = $Host.UI.RawUI.WindowSize.Width
    $longitudTexto = $Texto.Length
    $rellenoIzquierdo = [math]::Max(0, [math]::Floor(($anchoConsola - $longitudTexto) / 2)) + $Desplazamiento
    $lineaCentrada = (" " * $rellenoIzquierdo) + $Texto

    $parametros = @{
        Object = $lineaCentrada
        ForegroundColor = $ColorDeFondo
        BackgroundColor = $ColorDeFondoFondo
    }

    if ($NoNewline) {
        $parametros.Add("NoNewline", $true)
    }

    Write-Host @parametros
}

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
        $consoleWidth = $Host.UI.RawUI.WindowSize.Width

        $menuItems = @(
			
			"===============================================",
			"",
            "      Información de hardware en $NombreEquipo",
            "",
            "==============================================="
			"",
            " 1. Apagar equipo remoto",
            " 2. Reiniciar equipo remoto",
            " 3. Sesiones y usuarios activos remoto",
            " 4. Firma ES equipo remoto (no funciona)",
            " 5. Firma PT equipo remoto (no funciona)",
            " 6. PSTools / CMD equipo remoto",
            " 7. PSTools / PowerShell equipo remoto",
            " 8. Número de serie equipo remoto",
            " 9. OCS equipo remoto",
            " 0. Salir",
            "",
            "==============================================="
        )

        $maxWidth = ($menuItems | Measure-Object -Property Length -Maximum).Maximum
        $leftPadding = [math]::Max(0, [math]::Floor(($consoleWidth - $maxWidth) / 2))

        Clear-Host
        $host.UI.RawUI.BackgroundColor = "Black"
        Mostrar-BannerTol

        foreach ($item in $menuItems) {
            $centeredLine = (" " * $leftPadding) + $item
            if ($item -match "Información de hardware en") {
                Write-Host $centeredLine -ForegroundColor Yellow
            } elseif ($item -match "^[0-9]+\.") {
                Write-Host $centeredLine
            } elseif ($item -match "={3,}") {
                Write-Host $centeredLine
            } else {
                Write-Host $centeredLine
            }
        }

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
    Escribir-Centrado ""
    Escribir-Centrado "Nombre del equipo a apagar: " -NoNewline
    $equipo = Read-Host
    Escribir-Centrado ""
    
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
            Escribir-Centrado "El equipo remoto $equipo se apagará inmediatamente." -ColorDeFondo "Verde"
        } else {
            $errorMessage = $result -join " "
            if ($errorMessage) {
                Escribir-Centrado "Error al apagar el equipo $equipo': $errorMessage" -ColorDeFondo "Rojo"
            } else {
                Escribir-Centrado "Error al apagar el equipo $equipo." -ColorDeFondo "Rojo"
            }
        }
    } catch {
        Escribir-Centrado "Error al ejecutar el comando: $_" -ColorDeFondo "Rojo"
    }
    
    Escribir-Centrado ""
    Escribir-Centrado "Presione Enter para continuar..." -NoNewline
    Read-Host

    Mostrar-ToolKit
}

function Reiniciar-EquipoRemoto {
    $computerName = $env:COMPUTERNAME
    Escribir-Centrado "Nombre del equipo que quieres reiniciar: " -NoNewline
    $equipo = Read-Host
    
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
            Escribir-Centrado "Reiniciando equipo $equipo..." -ColorDeFondo "Verde"
        } else {
            Escribir-Centrado "Error al reiniciar el equipo $equipo." -ColorDeFondo "Rojo"
            if ($result) {
                $filteredResult = $result | Where-Object { $_ -match '\S' }  # Filtrar líneas vacías
                if ($filteredResult) {
                    Escribir-Centrado "Mensaje de error:" -ColorDeFondo "Rojo"
                    $filteredResult | ForEach-Object { Escribir-Centrado $_ -ColorDeFondo "Rojo" }
                }
            }
        }
    } catch {
        Escribir-Centrado "Error al ejecutar el comando: $_" -ColorDeFondo "Rojo"
    }
    
    Escribir-Centrado ""
    Escribir-Centrado "Presione Enter para continuar..." -NoNewline
    Read-Host

    Mostrar-ToolKit
}

function SesionesUsuarios-EquipoRemoto {
    Escribir-Centrado ""
    Escribir-Centrado "Nombre del equipo [este]: " -NoNewline
    $equipo = Read-Host
    if ([string]::IsNullOrWhiteSpace($equipo)) {
        $equipo = $env:COMPUTERNAME
    }
    Escribir-Centrado ""
    
    $sesiones = query session /server:$equipo 2>&1
    if ($sesiones -is [string]) {
        Escribir-Centrado $sesiones
    } else {
        $sesiones | ForEach-Object { Escribir-Centrado $_ }
    }
    
    Escribir-Centrado ""
    $usuarios = query user /server:$equipo 2>&1
    if ($usuarios -is [string]) {
        Escribir-Centrado $usuarios
    } else {
        $usuarios | ForEach-Object { Escribir-Centrado $_ }
    }
    
    if ($sesiones -notmatch "No existe un usuario para" -and $usuarios -notmatch "No existe un usuario para") {
        Escribir-Centrado "Número ID de la sesión a cerrar: " -NoNewline
        $sesionID = Read-Host
        
        try {
            $result = logoff $sesionID /server:$equipo 2>&1
            if ($LASTEXITCODE -eq 0) {
                Escribir-Centrado "Sesión cerrada" -ColorDeFondo "Verde"
            } else {
                Escribir-Centrado "Error al cerrar la sesión: $result" -ColorDeFondo "Rojo"
            }
        } catch {
            Escribir-Centrado "Error al ejecutar el comando: $_" -ColorDeFondo "Rojo"
        }
    }
    
    Escribir-Centrado ""
    Escribir-Centrado "Presione Enter para continuar..." -NoNewline
    Read-Host

    Mostrar-ToolKit
}

function FirmaES-EquipoRemoto {
    Escribir-Centrado ""
    Escribir-Centrado "Nombre equipo: " -NoNewline
    $equipo = Read-Host
    Escribir-Centrado ""
    
    $scriptPath = "\\seresco.red\recursos\rep\correo\Firmas2022\firma_seresco_2022"
    $psExecPath = "C:\PSTOOLS\PsExec.exe" # Asegúrate de que esta ruta sea correcta

    try {
        Escribir-Centrado "Obteniendo lista de usuarios..." -ColorDeFondo "Cyan"
        $sesiones = quser /server:$equipo 2>&1
        
        if ($LASTEXITCODE -eq 0 -and $sesiones -notmatch "No existe un usuario para") {
            Escribir-Centrado "Usuarios conectados en $equipo':" -ColorDeFondo "Cyan"
            $usuarios = $sesiones | Select-Object -Skip 1 | ForEach-Object {
                $linea = $_ -split '\s+'
                if ($linea.Count -ge 3) {
                    [PSCustomObject]@{
                        Usuario = $linea[1]
                        Estado = $linea[3]
                    }
                }
            }
            $usuariosFormateados = $usuarios | Format-Table -AutoSize | Out-String
            $usuariosFormateados -split "`n" | ForEach-Object { Escribir-Centrado $_ }
            
            Escribir-Centrado "Introduzca el nombre del usuario para ejecutar el script: " -NoNewline
            $usuarioElegido = Read-Host
            
            $usuarioEncontrado = $usuarios | Where-Object { $_.Usuario -eq $usuarioElegido }
            
            if (-not $usuarioEncontrado) {
                Escribir-Centrado "El usuario elegido no está en la lista de usuarios conectados." -ColorDeFondo "Rojo"
                Escribir-Centrado "Usuarios disponibles: $($usuarios.Usuario -join ', ')" -ColorDeFondo "Amarillo"
                Escribir-Centrado "Presione Enter para continuar..." -NoNewline
                Read-Host
                return
            }
            
            Escribir-Centrado "Ejecutando script como $usuarioElegido..." -ColorDeFondo "Cyan"
            
            $comando = "$psExecPath \\$equipo -u $usuarioElegido -i powershell.exe -ExecutionPolicy Bypass -File `"$scriptPath`""
            
            Escribir-Centrado "Comando a ejecutar: $comando" -ColorDeFondo "Cyan"
            
            $result = Invoke-Expression $comando

            if ($result) {
                Escribir-Centrado "Resultado de la ejecución:" -ColorDeFondo "Verde"
                $result | ForEach-Object { Escribir-Centrado $_ }
            } else {
                Escribir-Centrado "No se recibió ningún resultado de la ejecución." -ColorDeFondo "Amarillo"
            }
        } else {
            Escribir-Centrado "No se encontraron usuarios conectados en el equipo $equipo." -ColorDeFondo "Amarillo"
            Escribir-Centrado "Volviendo al menú principal..." -ColorDeFondo "Cyan"
        }
        
    } catch {
        Escribir-Centrado "Error: $_" -ColorDeFondo "Rojo"
    }
    
    Escribir-Centrado ""
    Escribir-Centrado "Presione Enter para continuar..." -NoNewline
    Read-Host

    Mostrar-ToolKit
}

function FirmaPT-EquipoRemoto {
    Escribir-Centrado ""
    Escribir-Centrado "Nombre equipo: " -NoNewline
    $equipo = Read-Host
    Escribir-Centrado ""
    
    $scriptPath = "\\seresco.red\recursos\rep\correo\Firmas2022\firma_seresco_PT_2022"
    $psExecPath = "C:\PSTOOLS\PsExec.exe" # Asegúrate de que esta ruta sea correcta

    try {
        Escribir-Centrado "Obteniendo lista de usuarios..." -ColorDeFondo "Cyan"
        $sesiones = quser /server:$equipo 2>&1
        
        if ($LASTEXITCODE -eq 0 -and $sesiones -notmatch "No existe un usuario para") {
            Escribir-Centrado "Usuarios conectados en $equipo':" -ColorDeFondo "Cyan"
            $usuarios = $sesiones | Select-Object -Skip 1 | ForEach-Object {
                $linea = $_ -split '\s+'
                if ($linea.Count -ge 3) {
                    [PSCustomObject]@{
                        Usuario = $linea[1]
                        Estado = $linea[3]
                    }
                }
            }
            $usuariosFormateados = $usuarios | Format-Table -AutoSize | Out-String
            $usuariosFormateados -split "`n" | ForEach-Object { Escribir-Centrado $_ }
            
            Escribir-Centrado "Introduzca el nombre del usuario para ejecutar el script: " -NoNewline
            $usuarioElegido = Read-Host
            
            $usuarioEncontrado = $usuarios | Where-Object { $_.Usuario -eq $usuarioElegido }
            
            if (-not $usuarioEncontrado) {
                Escribir-Centrado "El usuario elegido no está en la lista de usuarios conectados." -ColorDeFondo "Rojo"
                Escribir-Centrado "Usuarios disponibles: $($usuarios.Usuario -join ', ')" -ColorDeFondo "Amarillo"
                Escribir-Centrado "Presione Enter para continuar..." -NoNewline
                Read-Host
                return
            }
            
            Escribir-Centrado "Ejecutando script como $usuarioElegido..." -ColorDeFondo "Cyan"
            
            $comando = "$psExecPath \\$equipo -u $usuarioElegido -i powershell.exe -ExecutionPolicy Bypass -File `"$scriptPath`""
            
            Escribir-Centrado "Comando a ejecutar: $comando" -ColorDeFondo "Cyan"
            
            $result = Invoke-Expression $comando

            if ($result) {
                Escribir-Centrado "Resultado de la ejecución:" -ColorDeFondo "Verde"
                $result | ForEach-Object { Escribir-Centrado $_ }
            } else {
                Escribir-Centrado "No se recibió ningún resultado de la ejecución." -ColorDeFondo "Amarillo"
            }
        } else {
            Escribir-Centrado "No se encontraron usuarios conectados en el equipo $equipo." -ColorDeFondo "Amarillo"
            Escribir-Centrado "Volviendo al menú principal..." -ColorDeFondo "Cyan"
        }
        
    } catch {
        Escribir-Centrado "Error: $_" -ColorDeFondo "Rojo"
    }
    
    Escribir-Centrado ""
    Escribir-Centrado "Presione Enter para continuar..." -NoNewline
    Read-Host

    Mostrar-ToolKit
}

function PSToolsCMD-EquipoRemoto {
    Escribir-Centrado ""
    Escribir-Centrado "Nombre de equipo: " -NoNewline
    $equipo = Read-Host
    $psExecPath = "C:\PSTools\PsExec.exe" # Asegúrate de que esta ruta sea correcta

    Escribir-Centrado "Iniciando sesión CMD remota en $equipo..." -ColorDeFondo "Cyan"
    
    # Ejecutamos PsExec directamente
    & $psExecPath "\\$equipo" -accepteula cmd

    Escribir-Centrado "Sesión CMD remota finalizada." -ColorDeFondo "Verde"

    Escribir-Centrado ""
    Escribir-Centrado "Presione Enter para continuar..." -NoNewline
    Read-Host

    Mostrar-ToolKit
}

function PSToolsPS-EquipoRemoto {
    Escribir-Centrado ""
    Escribir-Centrado "Nombre de equipo: " -NoNewline
    $equipo = Read-Host
    $psExecPath = "C:\PSTools\PsExec.exe" # Asegúrate de que esta ruta sea correcta

    Escribir-Centrado "Iniciando sesión PowerShell remota en $equipo..." -ColorDeFondo "Cyan"
    
    & $psExecPath "\\$equipo" -accepteula PowerShell.exe

    Escribir-Centrado "Sesión PowerShell remota finalizada." -ColorDeFondo "Verde"

    Escribir-Centrado ""
    Escribir-Centrado "Presione Enter para continuar..." -NoNewline
    Read-Host

    Mostrar-ToolKit
}

function NumeroSerie-EquipoRemoto {
    Escribir-Centrado ""
    Escribir-Centrado "Nombre de equipo [este]: " -NoNewline
    $equipo = Read-Host
    $psExecPath = "C:\PSTools\PsExec.exe" # Asegúrate de que esta ruta sea correcta

    if ([string]::IsNullOrWhiteSpace($equipo)) {
        $equipo = $env:COMPUTERNAME
        Escribir-Centrado "Usando el equipo local: $equipo" -ColorDeFondo "Cyan"
    }

    try {
        Escribir-Centrado "Obteniendo número de serie de $equipo..." -ColorDeFondo "Cyan"
        
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
            Escribir-Centrado "Número de serie: $serialNumber" -ColorDeFondo "Verde"
        } else {
            Escribir-Centrado "No se pudo obtener el número de serie." -ColorDeFondo "Amarillo"
            if ($error_output) {
                Escribir-Centrado "Error: $error_output" -ColorDeFondo "Rojo"
            }
        }
    } catch {
        Escribir-Centrado "Error: $_" -ColorDeFondo "Rojo"
    }

    Escribir-Centrado ""
    Escribir-Centrado "Presione Enter para continuar..." -NoNewline
    Read-Host

    Mostrar-ToolKit
}

function OCS-EquipoRemoto {
    Escribir-Centrado ""
    Escribir-Centrado "Nombre de equipo: " -NoNewline
    $equipo = Read-Host
    $psExecPath = "C:\PSTools\PsExec.exe" # Asegúrate de que esta ruta sea correcta
    $ocsPath = "C:\Program Files (x86)\OCS Inventory Agent\OCSInventory.exe"

    Escribir-Centrado "Intentando conectar con $equipo..." -ColorDeFondo "Cyan"
    
    if (-not (Test-Path $psExecPath)) {
        Escribir-Centrado "Error: PsExec no encontrado en $psExecPath" -ColorDeFondo "Rojo"
        Escribir-Centrado "Presione Enter para continuar..." -NoNewline
        Read-Host
        return
    }

    try {
        # Ejecutamos PsExec y capturamos la salida y el código de salida
        $output = & $psExecPath "\\$equipo" -accepteula -s $ocsPath /FORCE 2>&1
        $exitCode = $LASTEXITCODE

        if ($exitCode -eq 0) {
            # Solo mostramos el mensaje en verde si la ejecución fue exitosa
            Escribir-Centrado "Petición OCS enviada con éxito para $equipo" -ColorDeFondo "Verde"
        } else {
            Escribir-Centrado "Error al enviar petición OCS para $equipo (Código de salida: $exitCode)" -ColorDeFondo "Rojo"
            Escribir-Centrado "Detalles del error:" -ColorDeFondo "Rojo"
            $output | ForEach-Object { Escribir-Centrado $_ -ColorDeFondo "Rojo" }
            # No continuamos con el script si hay un error
            return
        }
    } catch {
        Escribir-Centrado "Error inesperado al ejecutar PsExec: $_" -ColorDeFondo "Rojo"
        Escribir-Centrado "Stack Trace: $($_.ScriptStackTrace)" -ColorDeFondo "Rojo"
        # No continuamos con el script si hay una excepción
        return
    }

    Escribir-Centrado ""
    Escribir-Centrado "Presione Enter para continuar..." -NoNewline
    Read-Host

    Mostrar-ToolKit
}

function Menu-ToolKit {
    do {
        Mostrar-ToolKit
        Escribir-Centrado "Seleccione una opción: " -NoNewline
        $option = Read-Host
        
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
                Escribir-Centrado "Opción incorrecta, selecciona una opción válida." -ColorDeFondo "Rojo"
                Start-Sleep -Seconds 2
            }
        }
        
        if ($option -ne '0') {
            Escribir-Centrado ""
            Escribir-Centrado "Presione Enter para continuar..." -ColorDeFondo "Verde" -NoNewline
            Read-Host
        }
    } while ($true)
}

function Pause-Script {
    Write-Host ""
	Write-Host "Presione una tecla para continuar..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

#Menu-ToolKit