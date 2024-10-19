function Escribir-Centrado {
    param(
        [string]$Texto,
        [string]$ColorDeFondo = $host.UI.RawUI.ForegroundColor,
        [string]$ColorDeFondoFondo = $host.UI.RawUI.BackgroundColor,
        [int]$Desplazamiento = 0  # Número de espacios para desplazar el texto
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

    $ColorDeFondo = $colores[$ColorDeFondo] ?? $ColorDeFondo
    $ColorDeFondoFondo = $colores[$ColorDeFondoFondo] ?? $ColorDeFondoFondo

    $anchoConsola = $Host.UI.RawUI.WindowSize.Width
    $longitudTexto = $Texto.Length
    $rellenoIzquierdo = [math]::Max(0, [math]::Floor(($anchoConsola - $longitudTexto) / 2)) + $Desplazamiento
    $lineaCentrada = (" " * $rellenoIzquierdo) + $Texto

    Write-Host $lineaCentrada -ForegroundColor $ColorDeFondo -BackgroundColor $ColorDeFondoFondo
}

function Mostrar-BannerInf {
    param (
        [switch]$Continuo
    )

    function Dibujar-Banner {
        $consoleWidth = $Host.UI.RawUI.WindowSize.Width

        # Banner ASCII
        $banner = @(
            "██╗███╗   ██╗███████╗ ██████╗         ███████╗ ██████╗ ██╗   ██╗██╗██████╗  ██████╗",
            "██║████╗  ██║██╔════╝██╔═████╗        ██╔════╝██╔═══██╗██║   ██║██║██╔══██╗██╔═████╗",
            "██║██╔██╗ ██║█████╗  ██║██╔██║        █████╗  ██║   ██║██║   ██║██║██████╔╝██║██╔██║",
            "██║██║╚██╗██║██╔══╝  ████╔╝██║        ██╔══╝  ██║▄▄ ██║██║   ██║██║██╔═══╝ ████╔╝██║",
            "██║██║ ╚████║██║     ╚██████╔╝███████╗███████╗╚██████╔╝╚██████╔╝██║██║     ╚██████╔╝",
            "╚═╝╚═╝  ╚═══╝╚═╝      ╚═════╝ ╚══════╝╚══════╝ ╚══▀▀═╝  ╚═════╝ ╚═╝╚═╝      ╚═════╝"
        )

        $maxWidth = ($banner | Measure-Object -Property Length -Maximum).Maximum
        $leftPadding = [math]::Max(0, [math]::Floor(($consoleWidth - $maxWidth) / 2))

        Clear-Host
        Write-Host ""
		Write-Host ""
		Write-Host ""
        $colors = @('DarkBlue', 'Blue', 'Blue', 'Cyan', 'Cyan', 'White')

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

function Mostrar-MenuHardware {
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
            " 1. Resumen del sistema",
            " 2. Información sobre placa base",
            " 3. Información sobre CPU",
            " 4. Información sobre memoria",
            " 5. Información sobre discos",
            " 6. Información sobre red",
            " 7. Información sobre GPU",
            " 8. Información sobre USB registrados",
            " 9. Información sobre batería",
            "10. Información sobre actualizaciones",
            "11. Información sobre sistema operativo",
            "12. Información sobre servicios relevantes",
            "13. Informacion sobre usuarios",
            "14. Informacion sobre políticas y grupos",
            "15. Información sobre controladores",
            "16. Información sobre software instalado",
            "17. Información sobre el arranque del sistema",
            "18. Información sobre energía",
            "19. Información sobre seguridad",
            "20. Exportar información",
            " 0. Salir",
            "",
            "==============================================="
        )

        $maxWidth = ($menuItems | Measure-Object -Property Length -Maximum).Maximum
        $leftPadding = [math]::Max(0, [math]::Floor(($consoleWidth - $maxWidth) / 2))

        Clear-Host
        $host.UI.RawUI.BackgroundColor = "Black"
        Mostrar-BannerInf

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
            Write-Host "`nPresiona Ctrl+C para salir" -ForegroundColor Yellow
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

function Consultar-ResumenSistema {
    param(
        [Parameter(Mandatory=$false)]
        [string[]]$NombreEquipo = @($env:COMPUTERNAME)
    )
    
    function Dibujar-Resumen {
    $consoleWidth = $Host.UI.RawUI.WindowSize.Width
    
    $resumenItems = @(
        "===============================================",
        "",
        "Resumen del sistema --> $NombreEquipo",
        "",
        "===============================================",
        "",
        "Fabricante: $($computerSystem.Manufacturer)",
        "Modelo: $($computerSystem.Model)",
        "Nombre del equipo: $($computerSystem.Name)",
        "S.O.: $($operatingSystem.Caption) $($operatingSystem.Version)",
        "Arquitectura: $($operatingSystem.OSArchitecture)",
        "Número de serie: $($bios.SerialNumber)",
        "Procesador: $($computerSystem.NumberOfProcessors) x $($computerSystem.NumberOfLogicalProcessors) núcleos lógicos",
        "Memoria RAM: $([math]::Round($computerSystem.TotalPhysicalMemory / 1GB, 2)) GB",
        "",
        "==============================================="
    )
    
    $maxWidth = ($resumenItems | Measure-Object -Property Length -Maximum).Maximum
    $leftPadding = [math]::Max(0, [math]::Floor(($consoleWidth - $maxWidth) / 2)) + 4
    
    Clear-Host
    Mostrar-BannerInf
    
    foreach ($item in $resumenItems) {
        if ($item -match "^={3,}") {
            Escribir-Centrado $item
        } elseif ($item -match "Resumen del sistema -->") {
            Escribir-Centrado $item -ColorDeFondo Amarillo
        } else {
            $parts = $item -split ':', 2
            if ($parts.Count -eq 2) {
                $key = $parts[0].Trim()
                $value = $parts[1].Trim()
                $centeredLine = (" " * $leftPadding) + "${key}: "
                Write-Host $centeredLine -ForegroundColor White -NoNewline
                Write-Host $value -ForegroundColor Cyan
            } else {
                $centeredLine = (" " * $leftPadding) + $item
                Write-Host $centeredLine -ForegroundColor Cyan
            }
        }
    }
    
    $host.UI.RawUI.ForegroundColor = "White"
}
    
    $computerSystem = Get-CimInstance Win32_ComputerSystem
    $operatingSystem = Get-CimInstance Win32_OperatingSystem
    $bios = Get-CimInstance Win32_BIOS
    
    Dibujar-Resumen
}

function Consultar-InfoPlacaBase {
    param(
        [Parameter(Mandatory=$false)]
        [string]$NombreEquipo = $env:COMPUTERNAME
    )

	Mostrar-BannerInf
    Write-Host "			 			  ===============================================" 
    Write-Host "			 			     Información sobre placa base --> " -ForegroundColor Yellow -NoNewline; Write-Host "$NombreEquipo" -ForegroundColor Cyan
    Write-Host "			 			  ==============================================="
	Write-Host
	$motherboard = Get-CimInstance Win32_BaseBoard
    $output = @()
    $output += "			 			  Fabricante: $($motherboard.Manufacturer)"
    $output += "			 			  Modelo: $($motherboard.Product)"
    $output += "			 			  Versión: $($motherboard.Version)" 
    return $output -join "`n"
}

function Consultar-InfoCPU {
        param(
        [Parameter(Mandatory=$false)]
        [string]$NombreEquipo = $env:COMPUTERNAME
    )

    Mostrar-BannerInf
    Write-Host "			 			  ==============================================="
    Write-Host "			 			        Información sobre CPU --> " -ForegroundColor Yellow -NoNewline; Write-Host "$NombreEquipo" -ForegroundColor Cyan
    Write-Host "			 			  ==============================================="
    Write-Host

    $cpuInfo = Get-CimInstance Win32_Processor | Select-Object Name, MaxClockSpeed, NumberOfCores, NumberOfLogicalProcessors, L2CacheSize, L3CacheSize
    $output = @()

    # Añadir cada dato en una línea separada, convirtiendo a string
    $output += "			 			  Nombre: $($cpuInfo.Name.ToString().Trim())"
    $output += "			 			  Frecuencia Base (MHz): $($cpuInfo.MaxClockSpeed.ToString().Trim())"
    $output += "			 			  Núcleos: $($cpuInfo.NumberOfCores.ToString().Trim())"
    $output += "			 			  Procesadores lógicos: $($cpuInfo.NumberOfLogicalProcessors.ToString().Trim())"
    $output += "			 			  Caché L2 (KB): $($cpuInfo.L2CacheSize.ToString().Trim())"
    $output += "			 			  Caché L3 (KB): $($cpuInfo.L3CacheSize.ToString().Trim())"
	$output += "			 			  --------------------------"  # Línea de división entre CPUs
    return $output -join "`n"  # Unir los elementos del array con saltos de línea
}

function Consultar-InfoMemoria {
        param(
        [Parameter(Mandatory=$false)]
        [string]$NombreEquipo = $env:COMPUTERNAME
    )

	Mostrar-BannerInf
    Write-Host "			 			  ===============================================" 
    Write-Host "			 			       Información sobre memoria --> " -ForegroundColor Yellow -NoNewline; Write-Host "$NombreEquipo" -ForegroundColor Cyan
    Write-Host "			 			  ===============================================" 
    Write-Host
	$totalMemory = (Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB  # Obtener información sobre la memoria física total
    $physicalMemory = Get-CimInstance Win32_PhysicalMemory | Select-Object Manufacturer, PartNumber, Capacity, Speed  # Obtener información sobre los módulos de RAM
    $output = @()  # Crear salida
    $output += "			 			  Memoria total: $( [math]::Round($totalMemory, 2)) GB"  # Añadir la memoria total al inicio de la salida
    foreach ($mem in $physicalMemory) {
        if ($mem.Manufacturer -and $mem.Capacity -and $mem.Speed) {  # Asegurarse que Manufacturer, Capacity y Speed no estén vacíos
            $output += "			 			  Fabricante: $($mem.Manufacturer)"  # Agregar fabricante
            $output += "			 			  Capacidad: $( [math]::Round($mem.Capacity / 1GB, 2)) GB"  # Agregar capacidad
            $output += "			 			  Velocidad: $($mem.Speed) MHz"  # Agregar velocidad
            $output += "			 			  Número de Serie: $($mem.PartNumber)"  # Agregar número de serie
			$output += "			 			  --------------------------"  # Línea de división entre memorias
        }
    }
    return $output -join "`n"  # Unir toda la salida con saltos de línea
}

function Consultar-InfoDiscos {
        param(
        [Parameter(Mandatory=$false)]
        [string]$NombreEquipo = $env:COMPUTERNAME
    )

    Mostrar-BannerInf
    Write-Host "			 			  ==============================================="
    Write-Host "			 			       Información sobre discos --> " -ForegroundColor Yellow -NoNewline; Write-Host "$NombreEquipo" -ForegroundColor Cyan
    Write-Host "			 			  ==============================================="
    Write-Host

    $disks = Get-CimInstance Win32_LogicalDisk | Select-Object DeviceID, VolumeName, @{Name="Size(GB)";Expression={[math]::Round($_.Size/1GB,2)}}, @{Name="FreeSpace(GB)";Expression={[math]::Round($_.FreeSpace/1GB,2)}}
    $output = @()

    foreach ($disk in $disks) {
        # Añadir cada dato en una línea separada
        $output += "			 			  Unidad: $($disk.DeviceID)"
        $output += "			 			  Etiqueta: $($disk.VolumeName)"
        $output += "			 			  Tamaño (GB): $($disk.'Size(GB)')"
        $output += "			 			  Espacio libre (GB): $($disk.'FreeSpace(GB)')"
        $output += "			 			  --------------------------"  # Línea de división entre discos
    }

    return $output -join "`n"  # Unir los elementos del array con saltos de línea
}

function Consultar-InfoRed {
        param(
        [Parameter(Mandatory=$false)]
        [string]$NombreEquipo = $env:COMPUTERNAME
    )

    Mostrar-BannerInf
    Write-Host "			 			  =================================================" 
    Write-Host "			 			  Información sobre adaptadores de red --> " -ForegroundColor Yellow -NoNewline; Write-Host "$NombreEquipo" -ForegroundColor Cyan
    Write-Host "			 			  =================================================" 

    $networkAdapters = Get-NetAdapter
    $output = @()

    foreach ($adapter in $networkAdapters) {
        $adapterInfo = @()
        if ($null -ne $adapter.ifIndex) {
            $ipConfig = Get-NetIPConfiguration -InterfaceIndex $adapter.ifIndex
            $ipAddresses = ($ipConfig.IPv4Address.IPAddress) -join ', '
            $dnsServers = ($ipConfig.DNSServer.ServerAddresses) -join ', '
			$adapterInfo += ""
            $adapterInfo += "			 			  Nombre: $($adapter.Name)"
            $adapterInfo += "			 			  Descripción: $($adapter.InterfaceDescription)"
            $adapterInfo += "			 			  Estado: $($adapter.Status)"
            $adapterInfo += "			 			  Velocidad del enlace: $($adapter.LinkSpeed)"
            $adapterInfo += "			 			  Dirección MAC: $($adapter.MacAddress)"
            $adapterInfo += "			 			  Direcciones IP: $ipAddresses"

            # Obtener la máscara de subred
            $subnetMask = $ipConfig.IPv4Address.PrefixLength
            if ($subnetMask) {
                $adapterInfo += "			 			  Máscara de subred: /$subnetMask"
            } else {
                $adapterInfo += "			 			  Máscara de subred: No configurada"
            }

            # Obtener la puerta de enlace
            $gateway = $ipConfig.IPv4DefaultGateway.NextHop
            if ($gateway) {
                $adapterInfo += "			 			  Puerta de enlace: $gateway"
            } else {
                $adapterInfo += "			 			  Puerta de enlace: No configurada"
            }

            $adapterInfo += "			 			  Servidores DNS: $dnsServers"
        } else {
            $adapterInfo += "			 			  Nombre: $($adapter.Name)"
            $adapterInfo += "			 			  Error: No se pudo obtener información completa para este adaptador"
        }
        $output += $adapterInfo -join "`n"
        $output += "`n			 			  --------------------------"  # Línea de división entre adaptadores de red
    }

    return $output -join "`n"
}

function Consultar-InfoGPU {
        param(
        [Parameter(Mandatory=$false)]
        [string]$NombreEquipo = $env:COMPUTERNAME
    )

    Mostrar-BannerInf
    Write-Host "			 			  ==============================================="
    Write-Host "			 			         Información sobre GPU --> " -ForegroundColor Yellow -NoNewline; Write-Host "$NombreEquipo" -ForegroundColor Cyan
    Write-Host "			 			  ==============================================="
    Write-Host

    $gpuInfo = Get-CimInstance Win32_VideoController | Select-Object Name, @{Name='MemoriaAdaptador'; Expression={[math]::round($_.AdapterRAM / 1MB, 2)}}, DriverVersion, CurrentRefreshRate
    
    $output = @()
    foreach ($gpu in $gpuInfo) {
        $gpuDetails = @(
            "			 			  Nombre: $($gpu.Name)",
            "			 			  Memoria del adaptador (MB): $($gpu.MemoriaAdaptador)",
            "			 			  Versión del controlador: $($gpu.DriverVersion)",
            "			 			  Tasa de refresco (Hz): $($gpu.CurrentRefreshRate)"
        )
        $output += $gpuDetails -join "`n"
        $output += "			 			  --------------------------"  # Línea de división entre GPUs
    }
    
    if ($output.Count -eq 0) {
        $output += "			 			  No se encontró información sobre la GPU."
    }

    return $output -join "`n"
}

function Consultar-InfoUSB {
        param(
        [Parameter(Mandatory=$false)]
        [string]$NombreEquipo = $env:COMPUTERNAME
    )

	Mostrar-BannerInf
    Write-Host "			 			  ================================================"
    Write-Host "			 			  Información sobre USB´s registrados --> " -ForegroundColor Yellow -NoNewline; Write-Host "$NombreEquipo" -ForegroundColor Cyan
    Write-Host "			 			  ================================================"
    Write-Host
	try {
        $usbDevices = Get-PnpDevice -Class USB -ErrorAction Stop | Where-Object { $_.InstanceId -match '^USB' }
        $results = foreach ($device in $usbDevices) {
            $deviceInfo = Get-PnpDeviceProperty -InstanceId $device.InstanceId
            $lastConnected = ($deviceInfo | Where-Object KeyName -eq 'DEVPKEY_Device_LastArrivalDate').Data
            # Convertir la fecha a un objeto DateTime si no es nulo
            if ($lastConnected) {
                try {
                    $lastConnectedDate = [DateTime]::ParseExact($lastConnected, "MM/dd/yyyy HH:mm:ss", [System.Globalization.CultureInfo]::InvariantCulture)
                } catch {
                    $lastConnectedDate = [DateTime]::MinValue
                    Write-Warning "No se pudo parsear la fecha: $lastConnected"
                }
            } else {
                $lastConnectedDate = [DateTime]::MinValue
            }
            
            [PSCustomObject]@{
                'Nombre' = $device.FriendlyName -replace '\s*\([^)]*\)', ''
                'Id de instancia' = $device.InstanceId
                'Puerto' = ($deviceInfo | Where-Object KeyName -eq 'DEVPKEY_Device_LocationInfo').Data
                'Última conexión' = $lastConnectedDate
                'ÚltimaConexiónOrdenable' = $lastConnectedDate  # Campo adicional para ordenar por fecha de conexión mas reciente
            }
        }
        # Ordenar los resultados por la fecha de última conexión y eliminar el campo de ordenación
        $sortedResults = $results | 
            Sort-Object -Property ÚltimaConexiónOrdenable -Descending | 
            Select-Object * -ExcludeProperty ÚltimaConexiónOrdenable
        return $sortedResults | Format-Table -AutoSize | Out-String
    } catch {
        return "Error al obtener información de dispositivos USB: $_"
    }
}

function Consultar-InfoBateria {
        param(
        [Parameter(Mandatory=$false)]
        [string]$NombreEquipo = $env:COMPUTERNAME
    )

    Mostrar-BannerInf
    Write-Host "			 			  ==============================================="
    Write-Host "			 			       Información sobre batería --> " -ForegroundColor Yellow -NoNewline; Write-Host "$NombreEquipo" -ForegroundColor Cyan
    Write-Host "			 			  ==============================================="
    Write-Host

    $batteryInfo = Get-CimInstance Win32_Battery
    $output = @()
    
    if ($batteryInfo) {
        foreach ($battery in $batteryInfo) {
            $batteryDetails = @(
                "			 			  Nombre: $($battery.Name)",
                "			 			  Descripción: $($battery.Description)",
                "			 			  ID del dispositivo: $($battery.DeviceID)",
                "			 			  Carga estimada (%): $($battery.EstimatedChargeRemaining)",
                "			 			  Tiempo estimado de ejecución (min): $($battery.EstimatedRunTime)",
                "			 			  Capacidad de diseño (mWh): $([math]::round($battery.DesignCapacity / 1000, 2))",
                "			 			  Capacidad completa (mWh): $([math]::round($battery.FullChargeCapacity / 1000, 2))",
                "			 			  Voltaje de diseño (V): $([math]::round($battery.DesignVoltage / 1000, 2))",
                "			 			  Gestión de energía soportada: $($battery.PowerManagementSupported)"
            )
            $output += $batteryDetails -join "`n"
            $output += "`n			 			  --------------------------"  # Línea de separación entre baterías
        }
    } else {
        $output += "No se encontró información sobre la batería."
    }

    return $output -join "`n"
}

function Consultar-Actualizaciones {
        param(
        [Parameter(Mandatory=$false)]
        [string]$NombreEquipo = $env:COMPUTERNAME
    )

	Mostrar-BannerInf
    Write-Host "			 			  =============================================="
    Write-Host "			 			  Información sobre actualizaciones --> " -ForegroundColor Yellow -NoNewline; Write-Host "$NombreEquipo" -ForegroundColor Cyan
    Write-Host "			 			  =============================================="
	Write-Host
    $updates = Get-HotFix | Sort-Object InstalledOn -Descending
    $output = @()
    if ($updates.Count -gt 0) {
        foreach ($update in $updates) {
            $formattedDate = Get-Date -Date $update.InstalledOn -Format 'dd/MM/yyyy'  # Formatear solo la fecha sin la hora
            $description = $update.Description.PadRight(25)  # Ajusta el ancho según sea necesario
            $hotfixID = $update.HotFixID.PadRight(10)  # Ajusta el ancho según sea necesario
            $output += "			 	Descripción: $description HotFixID: $hotfixID Instalado el: $formattedDate"
        }
    } else {
        $output += "			 			  No se encontraron actualizaciones instaladas."
    }
    return $output -join "`n"
}

function Consultar-InfoSO {
        param(
        [Parameter(Mandatory=$false)]
        [string]$NombreEquipo = $env:COMPUTERNAME
    )

	Mostrar-BannerInf
    Write-Host "			 			  ================================================"
    Write-Host "			 			  Información sobre sistema operativo --> " -ForegroundColor Yellow -NoNewline; Write-Host "$NombreEquipo" -ForegroundColor Cyan
    Write-Host "			 			  ================================================"
    Write-Host
	$os = Get-CimInstance Win32_OperatingSystem
	$output = @()
    $output += "			 			  Nombre: $($os.Caption)"
    $output += "			 			  Versión: $($os.Version)"
    $output += "			 			  Arquitectura: $($os.OSArchitecture)"
    $activationStatus = Get-CimInstance -ClassName SoftwareLicensingProduct -Filter "Name like 'Windows%'" | Where-Object { $_.PartialProductKey } | Select-Object -First 1  # Obtener el estado de activación
    if ($activationStatus) {
        switch ($activationStatus.LicenseStatus) {
            0 { $status = "Sin licencia :(" }
            1 { $status = "Con licencia :)" }
            2 { $status = "Período de gracia Out-Of-Box" }
            3 { $status = "Período de gracia Out-Of-Tolerance" }
            4 { $status = "Período de gracia no genuino" }
            5 { $status = "Notificación" }
            6 { $status = "Período de gracia extendida" }
            default { $status = "			 			  Estado desconocido" }
        }
    } else {
        $status = "			 			  No disponible"
    }
    $output += "			 			  Activación: $status"
    return $output -join "`n"
}

function Consultar-EstadoServicios {
    param(
        [Parameter(Mandatory=$false)]
        [string]$NombreEquipo = $env:COMPUTERNAME
    )

    $leftPadding = 34  # Ajustar para desplazar el margen izquierdo
    function PaddedWrite-Host {
        param([string]$text, $ForegroundColor = $host.UI.RawUI.ForegroundColor)
        Write-Host (" " * $leftPadding + $text) -ForegroundColor $ForegroundColor
    }

	Mostrar-BannerInf
    Write-Host "			 			  ==============================================="
    Write-Host "			 			     Información sobre servicios --> " -ForegroundColor Yellow -NoNewline; Write-Host "$NombreEquipo" -ForegroundColor Cyan
    Write-Host "			 			  ==============================================="
    Write-Host
	PaddedWrite-Host
    $serviceNames = @(  # Lista de servicios a comprobar
        'CryptSvc', 'Dhcp', 'DcomLaunch', 'Dnscache', 'EventLog', 'LanmanServer',
        'LanmanWorkstation', 'mpssvc', 'OCS Inventory Service', 'PandaAetherAgent',
        'PlugPlay', 'Power', 'RpcSs', 'Schedule', 'Themes', 'W32Time',
        'WinDefend', 'WSearch', 'wuauserv', 'ClickToRunSvc'
    )
    $serviceNames = $serviceNames | Sort-Object
    $maxDisplayNameLength = ($serviceNames | ForEach-Object { (Get-Service -Name $_ -ErrorAction SilentlyContinue).DisplayName.Length } | Measure-Object -Maximum).Maximum
    $maxNameLength = ($serviceNames | ForEach-Object { $_.Length } | Measure-Object -Maximum).Maximum
    $maxStatusLength = 10
    $headerFormat = "{0,-$($maxDisplayNameLength+2)} {1,-$($maxNameLength+2)} {2}"
    PaddedWrite-Host ($headerFormat -f "Nombre del Servicio", "Nombre Corto", "Estado")
    PaddedWrite-Host ("-" * ($maxDisplayNameLength + $maxNameLength + $maxStatusLength + 4))
    foreach ($serviceName in $serviceNames) {
        $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
        if ($service) {
            $statusColor = switch ($service.Status) {
                "Running" { "Green" }
                "Stopped" { "Red" }
                default { "Yellow" }
            }
            $statusIcon = switch ($service.Status) {
                "Running" { "En ejecución" }
                "Stopped" { "Detenido" }
                default { "$($service.Status)" }
            }
            $lineFormat = "{0,-$($maxDisplayNameLength+2)} {1,-$($maxNameLength+2)} {2}"
            $line = $lineFormat -f $service.DisplayName, $service.Name, $statusIcon
            PaddedWrite-Host $line -ForegroundColor $statusColor
        } else {
            $lineFormat = "{0,-$($maxDisplayNameLength+2)} {1,-$($maxNameLength+2)} {2}"
            $line = $lineFormat -f $serviceName, $serviceName, "Ausente"
            PaddedWrite-Host $line -ForegroundColor Yellow
        }
    }
}

function Consultar-InfoUsuarios {
        param(
        [Parameter(Mandatory=$false)]
        [string]$NombreEquipo = $env:COMPUTERNAME
    )

	Mostrar-BannerInf
    Write-Host "			 			  =================================================="
    Write-Host "			 			  Información sobre usuarios y perfiles --> " -ForegroundColor Yellow -NoNewline; Write-Host "$NombreEquipo" -ForegroundColor Cyan
    Write-Host "			 			  =================================================="
    $output = @()
    # Información de perfiles de usuario (incluyendo usuarios de dominio)
    $output += "`n			                                 Perfiles de Usuario"
	$output += ""
    $userProfiles = Get-CimInstance Win32_UserProfile | Where-Object { -not $_.Special }
    foreach ($profile in $userProfiles) {
        $sid = $profile.SID
        $userName = (New-Object System.Security.Principal.SecurityIdentifier($sid)).Translate([System.Security.Principal.NTAccount]).Value
        $output += "			 			  Nombre de usuario: $userName"
        $output += "			 			  Ruta del perfil: $($profile.LocalPath)"
        $output += "			 			  Último uso: $(if ($profile.LastUseTime) {$profile.LastUseTime.ToString('dd/MM/yyyy HH:mm')})"
        
        # Intentar obtener la fecha de último cambio de contraseña
        try {
            $user = Get-LocalUser -SID $sid -ErrorAction SilentlyContinue
            if ($user) {
                $output += "			 			  Última vez que se cambió la contraseña: $(if ($user.PasswordLastSet) {$user.PasswordLastSet.ToString('dd/MM/yyyy HH:mm')})"
            } else {
                $adUser = Get-ADUser -Identity $sid -Properties PasswordLastSet -ErrorAction SilentlyContinue
                if ($adUser) {
                    $output += "			 			  Última vez que se cambió la contraseña: $(if ($adUser.PasswordLastSet) {$adUser.PasswordLastSet.ToString('dd/MM/yyyy HH:mm')})"
                } else {
                    $output += "			 			  Última vez que se cambió la contraseña: No disponible"
                }
            }
        } catch {
            $output += "			 			  Última vez que se cambió la contraseña: No disponible"
        }
        $output += ""
    }

    # Información de usuarios locales
    $output += ""
	$output += "			                                  Usuarios Locales"
    $output += ""
    $localUsers = Get-LocalUser | Select-Object Name, Enabled, LastLogon, PasswordLastSet, PasswordExpires
    foreach ($user in $localUsers) {
        $output += "			 			  Nombre: $($user.Name)"
        $output += "			 			  Habilitado: $($user.Enabled)"
        $output += "			 			  Último inicio de sesión: $(if ($user.LastLogon) {$user.LastLogon.ToString('dd/MM/yyyy HH:mm')})"
        $output += "			 			  Última vez que se cambió la contraseña: $(if ($user.PasswordLastSet) {$user.PasswordLastSet.ToString('dd/MM/yyyy HH:mm')})"
        $output += "			 			  Expiración de la contraseña: $(if ($user.PasswordExpires) {$user.PasswordExpires.ToString('dd/MM/yyyy HH:mm')})"
        $output += ""
    }

    return $output -join "`n"
}

function Consultar-Políticas {
        param(
        [Parameter(Mandatory=$false)]
        [string]$NombreEquipo = $env:COMPUTERNAME
    )

    Mostrar-BannerInf
    Write-Host "			 			  ===============================================" 
    Write-Host "			 			     Información sobre políticas --> " -ForegroundColor Yellow -NoNewline; Write-Host "$NombreEquipo" -ForegroundColor Cyan
    Write-Host "			 			  ===============================================" 
    Write-Host

    $output = @()

    # Ejecutar gpresult /r y filtrar las líneas no deseadas
    $gpresultOutput = gpresult /r | 
        Select-Object -Skip 9 |  # Omitir las primeras 9 líneas
        Where-Object { $_ -notmatch "Creado el" } |  # Omitir la línea que contiene "Creado el"
        ForEach-Object { "                                   $_" }

    # Agregar la salida filtrada de gpresult al array de salida
    $output += $gpresultOutput

    return $output -join "`n"
}

function Consultar-Controladores {
        param(
        [Parameter(Mandatory=$false)]
        [string]$NombreEquipo = $env:COMPUTERNAME
    )

    Mostrar-BannerInf
    Write-Host "			 			  ==============================================" 
    Write-Host "			 			   Información sobre controladores --> " -ForegroundColor Yellow -NoNewline; Write-Host "$NombreEquipo" -ForegroundColor Cyan
    Write-Host "			 			  ==============================================" 
    Write-Host

    $output = @()

    # Obtener todos los controladores instalados
    $drivers = Get-WmiObject Win32_PnPSignedDriver | Select-Object DeviceName, Manufacturer, DriverVersion, DriverDate

    if ($drivers.Count -eq 0) {
        $output += "No se encontraron controladores instalados."
    } else {
        $output += "Controladores instalados:"
        foreach ($driver in $drivers) {
            $output += "Dispositivo: $($driver.DeviceName)"
            $output += "  Fabricante: $($driver.Manufacturer)"
            $output += "  Versión: $($driver.DriverVersion)"
            
            # Convertir y formatear la fecha
            if ($driver.DriverDate) {
                $fecha = [Management.ManagementDateTimeConverter]::ToDateTime($driver.DriverDate)
                $fechaFormateada = $fecha.ToString("dd/MM/yyyy HH:mm:ss")
                $output += "  Fecha: $fechaFormateada"
            } else {
                $output += "  Fecha: No disponible"
            }
            
            $output += ""
        }
    }

    # Obtener controladores con problemas
    $problemDrivers = Get-WmiObject Win32_PnPEntity | Where-Object { $_.ConfigManagerErrorCode -ne 0 }

    if ($problemDrivers) {
        $output += "Controladores con problemas:"
        foreach ($driver in $problemDrivers) {
            $output += "  Dispositivo: $($driver.Name)"
            $output += "  Descripción del error: $($driver.ConfigManagerErrorCode)"
            $output += ""
        }
    }

    # Mostrar la salida acumulada
    $output | ForEach-Object { Write-Host "			 			  $_" }

    # Mostrar el mensaje en verde si no hay controladores con problemas
    if (-not $problemDrivers) {
        Write-Host "			 			  No se encontraron controladores con problemas." -ForegroundColor Green
    }

    Write-Host "`n			 			  Opciones:"
    Write-Host "			 			    1. Actualizar todos los controladores (sin probar aún)"
    Write-Host "			 			    2. Mostrar controladores instalados en los últimos 7 días"
    Write-Host "			 			    3. Volver al menú principal"
    Write-Host ""

    $choice = Read-Host "			 			  Selecciona una opción (1-3)"
    Write-Host ""

    switch ($choice) {
        "1" {
            if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
                Write-Host "			 			  Se requieren privilegios de administrador para actualizar controladores." -ForegroundColor Red
            } else {
                Write-Host "			 			  Iniciando actualización de controladores... (Esta operación puede tardar varios minutos)"
                $pnputilOutput = pnputil /scan-devices | ForEach-Object { "			 			    $_" }
                $pnputilOutput | ForEach-Object { Write-Host $_ }
                Write-Host "			 			  Actualización de controladores completada." -ForegroundColor Green
            }
        }
        "2" {
            # Mostrar controladores instalados en los últimos 7 días
            $sevenDaysAgo = (Get-Date).AddDays(-7)
            $recentDrivers = $drivers | Where-Object { 
                $_.DriverDate -and [Management.ManagementDateTimeConverter]::ToDateTime($_.DriverDate) -gt $sevenDaysAgo 
            } | Sort-Object { [Management.ManagementDateTimeConverter]::ToDateTime($_.DriverDate) } -Descending

            Write-Host "			 			  Controladores instalados en los últimos 7 días:"
            if ($recentDrivers) {
                foreach ($driver in $recentDrivers) {
                    Write-Host "			 			    Dispositivo: $($driver.DeviceName)"
                    Write-Host "			 			    Fabricante: $($driver.Manufacturer)"
                    Write-Host "			 			    Versión: $($driver.DriverVersion)"
                    $fecha = [Management.ManagementDateTimeConverter]::ToDateTime($driver.DriverDate)
                    Write-Host "			 			    Fecha de instalación: $($fecha.ToString('dd/MM/yyyy HH:mm:ss'))"
                    Write-Host ""
                }
            } else {
                Write-Host "			 			    No se encontraron controladores instalados en los últimos 7 días."
            }
        }
        "3" {
            Write-Host "			 			  Volviendo al menú principal..."
            return
        }
        default {
            Write-Host "			 			  Opción incorrecta. Volviendo al menú principal..."
        }
    }
}

function Consultar-SoftwareInstalado {
    param(
        [switch]$PorFabricante,
        [Parameter(Mandatory=$false)]
        [string]$NombreEquipo = $env:COMPUTERNAME
    )

 if ($PorFabricante) {
        $fabricantes = Get-WmiObject -Class Win32_Product -ComputerName $NombreEquipo | Group-Object -Property Vendor
        $output = "Software instalado por fabricante:`n"
        foreach ($fabricante in $fabricantes) {
            $output += "Fabricante: $($fabricante.Name)`n"
            $output += "Número de programas: $($fabricante.Count)`n"
            $output += "Programas:`n"
            foreach ($prog in $fabricante.Group) {
                $output += "- $($prog.Name) (Versión: $($prog.Version))`n"
                if ($prog.InstallDate) {
                    $fecha = [DateTime]::ParseExact($prog.InstallDate, "yyyyMMdd", $null)
                    $output += "Fecha de instalación: $(Get-Date -Format 'dd/MM/yyyy' -Date $fecha)`n"
                } else {
                    $output += "Fecha de instalación: No disponible`n"
                }
            }
            $output += "---------------------------`n"
        }
        return $output
    } else {
        do {
            Mostrar-BannerInf
            Write-Host "			 			  ================================================="
            Write-Host "			 			  Información sobre software instalado --> " -ForegroundColor Yellow -NoNewline; Write-Host "$NombreEquipo" -ForegroundColor Cyan
            Write-Host "			 			  ================================================="
            Write-Host

            # Obtener la lista de software instalado (solo si no se ha obtenido antes)
            if (-not $softwareOrdenado) {
                try {
                    $software = Get-WmiObject -Class Win32_Product -ComputerName $NombreEquipo | Select-Object Name, Version, Vendor, InstallDate
                    $softwareOrdenado = $software | Sort-Object Name
                }
                catch {
                    Write-Warning "Error al obtener información del software en $NombreEquipo $_"
                    return
                }
            }

            Write-Host "			 			  1. Mostrar todo el software instalado"
            Write-Host "			 			  2. Buscar software específico"
            Write-Host "			 			  3. Mostrar software instalado en los últimos 30 días"
            Write-Host "			 			  4. Mostrar software por fabricante"
            Write-Host "			 			  0. Volver al menú principal info_equipo"
            Write-Host

            $opcion = Read-Host "			 			  Seleccione una opción (0-4)"

            $output = @()

            switch ($opcion) {
                "1" {
                    $output += "			 			  Software instalado:"
                    foreach ($prog in $softwareOrdenado) {
                        $output += "			 			  Nombre: $($prog.Name)"
                        $output += "			 			  Versión: $($prog.Version)"
                        $output += "			 			  Fabricante: $($prog.Vendor)"
                        if ($prog.InstallDate) {
                            $fecha = [DateTime]::ParseExact($prog.InstallDate, "yyyyMMdd", $null)
                            $output += "			 			  Fecha de instalación: $(Get-Date -Format 'dd/MM/yyyy' -Date $fecha)"
                        } else {
                            $output += "			 			  Fecha de instalación: No disponible"
                        }
                        $output += "			 			  ---------------------------"
                    }
                }
                "2" {
                    $busqueda = Read-Host "			 			  Introduzca el nombre del software a buscar"
                    $resultados = $softwareOrdenado | Where-Object { $_.Name -like "*$busqueda*" }
                    if ($resultados) {
                        $output += "			 			  Resultados de la búsqueda para '$busqueda':"
                        foreach ($prog in $resultados) {
                            $output += "			 			  Nombre: $($prog.Name)"
                            $output += "			 			  Versión: $($prog.Version)"
                            $output += "			 			  Fabricante: $($prog.Vendor)"
                            if ($prog.InstallDate) {
                                $fecha = [DateTime]::ParseExact($prog.InstallDate, "yyyyMMdd", $null)
                                $output += "			 			  Fecha de instalación: $(Get-Date -Format 'dd/MM/yyyy' -Date $fecha)"
                            } else {
                                $output += "			 			  Fecha de instalación: No disponible"
                            }
                            $output += "			 			  ---------------------------"
                        }
                    } else {
                        $output += "			 			  No se encontraron resultados para '$busqueda'."
                    }
                }
                "3" {
                    $fechaLimite = (Get-Date).AddDays(-30)
                    $softwareReciente = $softwareOrdenado | Where-Object { 
                        if ($_.InstallDate) {
                            $fechaInstalacion = [DateTime]::ParseExact($_.InstallDate, "yyyyMMdd", $null)
                            $fechaInstalacion -gt $fechaLimite
                        } else {
                            $true  # Incluir si no hay fecha de instalación
                        }
                    }
                    $output += "			 			  Software instalado en los últimos 30 días o sin fecha de instalación:"
                    foreach ($prog in $softwareReciente) {
                        $output += "			 			  Nombre: $($prog.Name)"
                        $output += "			 			  Versión: $($prog.Version)"
                        $output += "			 			  Fabricante: $($prog.Vendor)"
                        if ($prog.InstallDate) {
                            $fecha = [DateTime]::ParseExact($prog.InstallDate, "yyyyMMdd", $null)
                            $output += "			 			  Fecha de instalación: $(Get-Date -Format 'dd/MM/yyyy' -Date $fecha)"
                        } else {
                            $output += "			 			  Fecha de instalación: No disponible"
                        }
                        $output += "			 			  ---------------------------"
                    }
                }
                "4" {
                    $fabricantes = $softwareOrdenado | Group-Object -Property Vendor
                    $output += "			 			  Software por fabricante:"
                    foreach ($fabricante in $fabricantes) {
                        $output += "			 			  Fabricante: $($fabricante.Name)"
                        $output += "			 			  Número de programas: $($fabricante.Count)"
                        $output += "			 			  Programas:"
                        foreach ($prog in $fabricante.Group) {
                            $output += "			 			    - $($prog.Name) (Versión: $($prog.Version))"
                            if ($prog.InstallDate) {
                                $fecha = [DateTime]::ParseExact($prog.InstallDate, "yyyyMMdd", $null)
                                $output += "			 			      Fecha de instalación: $(Get-Date -Format 'dd/MM/yyyy' -Date $fecha)"
                            } else {
                                $output += "			 			      Fecha de instalación: No disponible"
                            }
                        }
                        $output += "			 			  ---------------------------"
                    }
                }
                "0" {
                    return # Volver al menú principal sin pausa
                }
                default {
                    $output += "			 			  Opción incorrecta, por favor seleccione una opción válida."
                }
            }

            # Mostrar la salida
            if ($output.Count -gt 0) {
                Write-Host ""
                foreach ($line in $output) {
                    Write-Host $line
                }
            }

            # Pausa personalizada solo si no se seleccionó la opción 0
            if ($opcion -ne "0") { 
                Write-Host
                Write-Host "			 			  Presione cualquier tecla para continuar..." -NoNewline
                $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
                Write-Host
            }

        } while ($opcion -ne "0")  # Continuar mostrando el menú hasta que se seleccione la opción 0
    }
}

function Consultar-Arranque {
        param(
        [Parameter(Mandatory=$false)]
        [string]$NombreEquipo = $env:COMPUTERNAME
    )

	Mostrar-BannerInf
    Write-Host "			 			  ===============================================" 
    Write-Host "			   			      Información sobre arranque --> " -ForegroundColor Yellow -NoNewline; Write-Host "$NombreEquipo" -ForegroundColor Cyan
    Write-Host "			 			  ===============================================" 
    Write-Host
    
    $output = @()
    
    # Obtener información sobre el tiempo de arranque
    $os = Get-CimInstance Win32_OperatingSystem
    $lastBootUpTime = $os.LastBootUpTime
    $uptime = (Get-Date) - $lastBootUpTime
    
    $output += "			 			  Último arranque: $lastBootUpTime"
    $output += "			 			  Tiempo de actividad: $($uptime.Days) días, $($uptime.Hours) horas, $($uptime.Minutes) minutos"
    
    # Obtener programas que se inician automáticamente
    $output += "`n			 			  Programas de inicio automático habilitados:"

    # Verificar programas en la carpeta de inicio
    $startupFolder = [Environment]::GetFolderPath('Startup')
    $startupItems = Get-ChildItem -Path $startupFolder -ErrorAction SilentlyContinue
    foreach ($item in $startupItems) {
        $output += "			 			      - Nombre: $($item.Name)"
        $output += "			 			      Ubicación: $($item.FullName)"
        $output += ""
    }

    # Verificar programas en el registro (HKCU)
    $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
    $regItems = Get-ItemProperty -Path $regPath -ErrorAction SilentlyContinue
    foreach ($item in $regItems.PSObject.Properties | Where-Object { $_.Name -notin @('PSPath', 'PSParentPath', 'PSChildName', 'PSDrive', 'PSProvider') }) {
        $output += "			 			      - Nombre: $($item.Name)"
        $output += "			 			      Comando: $($item.Value)"
        $output += "			 			      Ubicación: Registro (HKCU)"
        $output += ""
    }

    # Verificar programas en el registro (HKLM)
    $regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
    $regItems = Get-ItemProperty -Path $regPath -ErrorAction SilentlyContinue
    foreach ($item in $regItems.PSObject.Properties | Where-Object { $_.Name -notin @('PSPath', 'PSParentPath', 'PSChildName', 'PSDrive', 'PSProvider') }) {
        $output += "			 			      - Nombre: $($item.Name)"
        $output += "			 			      Comando: $($item.Value)"
        $output += "			 			      Ubicación: Registro (HKLM)"
        $output += ""
    }

    # Si no se encontraron programas de inicio
    if ($output.Count -eq 3) {
        $output += "			 			  No se encontraron programas de inicio automático habilitados."
    }
    
    return $output -join "`n"
}

function Consultar-Energia {
        param(
        [Parameter(Mandatory=$false)]
        [string]$NombreEquipo = $env:COMPUTERNAME
    )

	Mostrar-BannerInf
    Write-Host "			 			  ===============================================" 
    Write-Host "			   			        Información de energía --> " -ForegroundColor Yellow -NoNewline; Write-Host "$NombreEquipo" -ForegroundColor Cyan
    Write-Host "			 			  ===============================================" 
    Write-Host
    
    $output = @()
    
    # Asegurarse de que el servicio de energía esté en ejecución
    try {
        $powerService = Get-Service -Name "Power" -ErrorAction Stop
        if ($powerService.Status -ne "Running") {
            Start-Service -Name "Power" -ErrorAction Stop
            $output += "			 			  Servicio de energía iniciado."
        } else {
            $output += "			 			  El servicio de energía está en ejecución."
        }
    } catch {
        $output += "			 			  Error al manipular el servicio de energía: $_"
    }
	
    # Listar todos los planes de energía disponibles
    try {
        $allPlans = powercfg /list
#        $output += "`n			 			  Planes de energía disponibles:"
        $output += $allPlans | ForEach-Object { "			 			  $_" }
    } catch {
        $output += "			 			  Error al obtener la lista de planes de energía: $_"
    }
    
    # Obtener configuración de suspensión
    try {
        $sleepSettings = powercfg /query SCHEME_CURRENT SUB_SLEEP
        $output += "`n			 			  Configuración de suspensión:"
        $sleepAfter = $sleepSettings | Select-String "Suspender después de"
        if ($sleepAfter) {
            $output += $sleepAfter | ForEach-Object { "			 			  $_" }
        } else {
            $output += "			 			  No se encontró información sobre la suspensión."
        }
    } catch {
        $output += "			 			  Error al obtener la configuración de suspensión: $_"
    }

    return $output -join "`n"
}

function Consultar-Seguridad {
        param(
        [Parameter(Mandatory=$false)]
        [string]$NombreEquipo = $env:COMPUTERNAME
    )

	Mostrar-BannerInf
    Write-Host "			 			  ==============================================" 
    Write-Host "			   			     Información sobre seguridad --> " -ForegroundColor Yellow -NoNewline; Write-Host "$NombreEquipo" -ForegroundColor Cyan
    Write-Host "			 			  ==============================================" 
    Write-Host
    
    $output = @()
    
    # Verificar el estado del Firewall de Windows
    $firewallStatus = Get-NetFirewallProfile | Select-Object Name, Enabled
    $output += "			 			   Estado del Firewall de Windows:"
    foreach ($profile in $firewallStatus) {
        $output += "			 			    - $($profile.Name): $(if($profile.Enabled){'Activado'}else{'Desactivado'})"
    }
    
    # Verificar el estado del antivirus (Windows Defender)
    $antivirusStatus = Get-MpComputerStatus
    $output += "`n			 			   Estado del Antivirus (Windows Defender):"
    $output += "			 			    - Protección en tiempo real: $(if($antivirusStatus.RealTimeProtectionEnabled){'Activada'}else{'Desactivada'})"
    $output += "			 			    - Última actualización de definiciones: $($antivirusStatus.AntivirusSignatureLastUpdated)"
    
    # Verificar actualizaciones pendientes
    $updateSession = New-Object -ComObject Microsoft.Update.Session
    $updateSearcher = $updateSession.CreateUpdateSearcher()
    $pendingUpdates = $updateSearcher.Search("IsInstalled=0 and Type='Software'").Updates.Count
    $output += "`n			 			   Actualizaciones pendientes: $pendingUpdates"
    
    return $output -join "`n"
}

function Exportar-InfoSistema {
        param(
        [Parameter(Mandatory=$false)]
        [string]$NombreEquipo = $env:COMPUTERNAME
    )

    Mostrar-BannerInf
    Write-Host "			 			  ==============================================="
    Write-Host "			                           Exportar información de $NombreEquipo --> " -ForegroundColor Yellow -NoNewline; Write-Host "$NombreEquipo" -ForegroundColor Cyan
    Write-Host "			 			  ==============================================="
    Write-Host

    # Solicitar la ruta de destino
    do {
        $outputPath = Read-Host '			 			  Ruta para guardar el informe HTML, p. ej. C:\Temp [Escritorio]'
        if ([string]::IsNullOrWhiteSpace($outputPath)) {
            $outputPath = [Environment]::GetFolderPath("Desktop")
        }
    } while (-not (Test-Path $outputPath -IsValid))

    # Definir el nombre del archivo por defecto
    $defaultFileName = "info_$NombreEquipo.html"

    # Solicitar nombre del archivo para exportar, usando el nombre por defecto si se deja en blanco
    $outputFile = Read-Host "			 			  Introduce el nombre del archivo sin extensión [$defaultFileName]"
    if ([string]::IsNullOrWhiteSpace($outputFile)) {
        $outputFile = $defaultFileName
    }
    elseif (-not ($outputFile.EndsWith('.html', [StringComparison]::OrdinalIgnoreCase))) {
        $outputFile += '.html'
    }

    # Combinar la ruta y el nombre del archivo
    $fullPath = Join-Path -Path $outputPath -ChildPath $outputFile

    # Comprobar si el archivo ya existe
    if (Test-Path $fullPath) {
        $confirmacion = Read-Host "			 			  El archivo $fullPath ya existe. ¿Deseas sobrescribirlo? (S/N) [S]"
        if ([string]::IsNullOrWhiteSpace($confirmacion)) {
            $confirmacion = "S"
        }
        if ($confirmacion.ToUpper() -ne 'S') {
            Write-Host "			 			  Operación cancelada por el usuario." -ForegroundColor Yellow
            return
        }
    }

    # Obtener la fecha y hora actual
    $currentCulture = [System.Threading.Thread]::CurrentThread.CurrentCulture
    [System.Threading.Thread]::CurrentThread.CurrentCulture = 'es-ES'
    $currentTime = Get-Date -Format "HH:mm"
    $currentDate = Get-Date -Format "dd 'de' MMMM 'de' yyyy"
    [System.Threading.Thread]::CurrentThread.CurrentCulture = $currentCulture

    # Función para formatear el contenido
    function Format-Content {
        param ([string]$content)
        
        # Divide el contenido en líneas y elimina espacios en blanco al inicio y final de cada línea
        $lines = $content -split "`r?`n" | ForEach-Object { $_.Trim() }
        
        # Filtra las líneas vacías y une las líneas con <br> para HTML
        $formattedContent = ($lines | Where-Object { $_ -match '\S' }) -join "<br>"
        
        return $formattedContent
    }

    # Crear una estructura de datos para almacenar la información
    $infoSecciones = @(
        @{Titulo="Resumen del sistema"; Contenido=(Format-Content (Consultar-ResumenSistema))},
        @{Titulo="Placa base"; Contenido=(Format-Content (Consultar-InfoPlacaBase))},
        @{Titulo="CPU"; Contenido=(Format-Content (Consultar-InfoCPU))},
        @{Titulo="Memoria RAM"; Contenido=(Format-Content (Consultar-InfoMemoria))},
        @{Titulo="Discos"; Contenido=(Format-Content (Consultar-InfoDiscos))},
        @{Titulo="Adaptadores de red"; Contenido=(Format-Content (Consultar-InfoRed))},
        @{Titulo="GPU"; Contenido=(Format-Content (Consultar-InfoGPU))},
        @{Titulo="Dispositivos USB registrados en el sistema"; Contenido=(Format-Content (Consultar-InfoUSB))},
        @{Titulo="Baterías"; Contenido=(Format-Content (Consultar-InfoBateria))},
        @{Titulo="Actualizaciones"; Contenido=(Format-Content (Consultar-Actualizaciones))},
        @{Titulo="Sistema operativo"; Contenido=(Format-Content (Consultar-InfoSO))},
        @{Titulo="Usuarios"; Contenido=(Format-Content (Consultar-InfoUsuarios))},
        @{Titulo="Políticas y grupos"; Contenido=(Format-Content (Consultar-Políticas))},
        @{Titulo="Arranque"; Contenido=(Format-Content (Consultar-Arranque))},
        @{Titulo="Energía"; Contenido=(Format-Content (Consultar-Energia))},
        @{Titulo="Seguridad"; Contenido=(Format-Content (Consultar-Seguridad))}
		@{Titulo="Software instalado ordenado por fabricante"; Contenido=(Format-Content (Consultar-SoftwareInstalado -PorFabricante))}
    )

    # Función para generar el contenido HTML
     function Get-HTMLContent {
        $htmlContent = @"
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>$NombreEquipo - Informe de Sistema</title>
    <style>
        body { 
            font-family: Arial, sans-serif; 
            line-height: 1.6; 
            color: #87CEFA; /* Light Sky Blue */
            background-color: #000000; /* Black */
            max-width: 1200px;
            margin: 0 auto; 
            padding: 20px; 
            width: 85%;
        }
        .ascii-banner {
            font-family: monospace;
            white-space: pre;
            font-size: 10px;
            line-height: 1.2;
            text-align: center;
            color: #87CEFA;
        }
        .computer-name {
            text-align: center;
            font-size: 24px;
            font-weight: bold;
            margin-top: 10px;
            color: #87CEFA;
        }
        h2 { 
            color: #ff9500;
            border-bottom: 2px solid #87CEFA; 
            padding-bottom: 10px; 
        }
        .content { 
            font-family: 'Consolas', monospace; 
            font-size: 14px; 
            background-color: #1A1A1A; /* Very Dark Gray (Almost Black) */
            color: #FFFFFF; /* White */
            padding: 10px; 
            border-radius: 5px; 
            white-space: pre-wrap; 
            word-wrap: break-word; 
            position: relative;
            margin-bottom: 20px; /* Añadir espacio entre secciones */
        }
        .copy-btn {
            position: absolute;
            top: 5px;
            right: 5px;
            background-color: #4CAF50;
            border: none;
            color: white;
            padding: 5px 10px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 12px;
            margin: 4px 2px;
            cursor: pointer;
            border-radius: 3px;
        }
        footer { 
            margin-top: 10px; 
            padding-top: 5px; 
            border-top: 1px solid #87CEFA; 
            font-size: 0.7em; 
            text-align: center; 
            color: #ff9500;
        }
        .date-time { 
			font-family: 'Consolas', monospace; 
            text-align: right; 
            color: #ffffff;
        }
    </style>
    <script>
    function copyToClipboard(id) {
        var element = document.getElementById(id);
        var text = element.innerText;
        
        // Eliminar espacios y saltos de línea innecesarios
        text = text.trim().replace(/(\n\s*){2,}/g, '\n');

        navigator.clipboard.writeText(text).then(function() {
            // Cambiar el texto del botón temporalmente
            var button = element.nextElementSibling;
            var originalText = button.textContent;
            button.textContent = 'Copiado';
            setTimeout(function() {
                button.textContent = originalText;
            }, 2000);
        }).catch(function(err) {
            console.error('Error al copiar: ', err);
            alert('Error al copiar al portapapeles. Por favor, inténtalo de nuevo.');
        });
    }
    </script>
</head>
<body>
    <div class="ascii-banner">
██╗███╗   ██╗███████╗ ██████╗         ███████╗ ██████╗ ██╗   ██╗██╗██████╗  ██████╗ 
██║████╗  ██║██╔════╝██╔═══██╗        ██╔════╝██╔═══██╗██║   ██║██║██╔══██╗██╔═████╗
██║██╔██╗ ██║█████╗  ██║   ██║        █████╗  ██║   ██║██║   ██║██║██████╔╝██║██╔██║
██║██║╚██╗██║██╔══╝  ██║   ██║        ██╔══╝  ██║▄▄ ██║██║   ██║██║██╔═══╝ ████╔╝██║
██║██║ ╚████║██║     ╚██████╔╝███████╗███████╗╚██████╔╝╚██████╔╝██║██║     ╚██████╔╝
╚═╝╚═╝  ╚═══╝╚═╝      ╚═════╝ ╚══════╝╚══════╝ ╚══▀▀═╝  ╚═════╝ ╚═╝╚═╝      ╚═════╝ 
    </div>
    <div class="computer-name">$NombreEquipo</div>
    <p class='date-time'> $currentDate</p>
	<p class='date-time'> $currentTime</p>
"@

        $sectionId = 0
        foreach ($seccion in $infoSecciones) {
            $sectionId++
            $contenidoFormateado = $seccion.Contenido -replace "`r`n", "<br>" -replace "`n", "<br>"
            $htmlContent += @"
    <h2>$($seccion.Titulo)</h2>
    <div class="content">
        <div id="section$sectionId">$contenidoFormateado</div>
        <button class="copy-btn" onclick="copyToClipboard('section$sectionId')">Copiar</button>
    </div>
"@
        }

        $htmlContent += @"
    <footer>
        <p>Informe generado con script_zer0 | sergiomv_2024</p>
    </footer>
</body>
</html>
"@

        return $htmlContent
    }

    # Exportar la información en formato HTML
    try {
        Get-HTMLContent | Out-File -FilePath $fullPath -Encoding UTF8
        Write-Host "			 			  Información exportada a $fullPath" -ForegroundColor Green
    }
    catch {
        Write-Host "			 			  Error al exportar la información: $_" -ForegroundColor Red
    }
}

function Menu-InfoEquipo {
    param(
        [Parameter(Mandatory=$false)]
        [string]$NombreEquipo = $env:COMPUTERNAME
    )
    
    do {
        Mostrar-MenuHardware -NombreEquipo $NombreEquipo
        Escribir-Centrado ""
        
        function Obtener-OpcionCentrada {
            $consoleWidth = $Host.UI.RawUI.WindowSize.Width
            $prompt = "Selecciona una opción: "
            $leftPadding = [math]::Max(0, [math]::Floor(($consoleWidth - $prompt.Length) / 2)) - 10 # Resta para desplazar a la izquierda
            $centeredPrompt = (" " * $leftPadding) + $prompt
            Write-Host $centeredPrompt -ForegroundColor Cyan -NoNewline
            return Read-Host
        }

        $opcion = Obtener-OpcionCentrada
        
        switch ($opcion) {
            '1' { Consultar-ResumenSistema -NombreEquipo $NombreEquipo }
            '2' { Consultar-InfoPlacaBase -NombreEquipo $NombreEquipo }
            '3' { Consultar-InfoCPU -NombreEquipo $NombreEquipo }
            '4' { Consultar-InfoMemoria -NombreEquipo $NombreEquipo }
            '5' { Consultar-InfoDiscos -NombreEquipo $NombreEquipo }
            '6' { Consultar-InfoRed -NombreEquipo $NombreEquipo }
            '7' { Consultar-InfoGPU -NombreEquipo $NombreEquipo }
            '8' { Consultar-InfoUSB -NombreEquipo $NombreEquipo }
            '9' { Consultar-InfoBateria -NombreEquipo $NombreEquipo }
            '10' { Consultar-Actualizaciones -NombreEquipo $NombreEquipo }
            '11' { Consultar-InfoSO -NombreEquipo $NombreEquipo }
            '12' { Consultar-EstadoServicios -NombreEquipo $NombreEquipo }
            '13' { Consultar-InfoUsuarios -NombreEquipo $NombreEquipo }
            '14' { Consultar-Políticas -NombreEquipo $NombreEquipo }
            '15' { Consultar-Controladores -NombreEquipo $NombreEquipo }
            '16' { Consultar-SoftwareInstalado -NombreEquipo $NombreEquipo }
            '17' { Consultar-Arranque -NombreEquipo $NombreEquipo }
            '18' { Consultar-Energia -NombreEquipo $NombreEquipo }
            '19' { Consultar-Seguridad -NombreEquipo $NombreEquipo }
            '20' { Exportar-InfoSistema -NombreEquipo $NombreEquipo }
            '0' {
                Escribir-Centrado ""  # Línea en blanco
                Escribir-Centrado "Saliendo del script..." -ColorDeFondo Rojo
                return
            }
            default {
                Escribir-Centrado ""  # Línea en blanco
                Escribir-Centrado "Opción incorrecta." -ColorDeFondo Rojo
            }
        }
        if ($opcion -ne '0') {
			Escribir-Centrado ""  # Línea en blanco
            Escribir-Centrado "Presiona cualquier tecla para continuar..." -Desplazamiento 0
            [void][System.Console]::ReadKey()
        }
    } while ($true)
}

function Obtener-NombreEquipo {
	param(
        [Parameter(Mandatory=$false)]
        [string]$NombreEquipo = $env:COMPUTERNAME
    )
	
    Clear-Host  # Borra la pantalla
    Mostrar-BannerInf
	$consoleWidth = $Host.UI.RawUI.WindowSize.Width
    $prompt = "Introduce el nombre del equipo [este]: "
    $leftPadding = [math]::Max(0, [math]::Floor(($consoleWidth - $prompt.Length) / 2)) - 12  # Resta para desplazar a la izquierda
    $centeredPrompt = (" " * $leftPadding) + $prompt
    Write-Host $centeredPrompt -ForegroundColor Cyan -NoNewline
    return Read-Host
}

$NombreEquipo = Obtener-NombreEquipo
if ([string]::IsNullOrWhiteSpace($NombreEquipo)) {
    $NombreEquipo = $env:COMPUTERNAME
}

Menu-InfoEquipo -NombreEquipo $NombreEquipo