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
            "██╗███╗   ██╗███████╗ ██████╗         ███████╗ ██████╗ ██╗   ██╗██╗██████╗  ██████╗"
            "██║████╗  ██║██╔════╝██╔═████╗        ██╔════╝██╔═══██╗██║   ██║██║██╔══██╗██╔═████╗"
            "██║██╔██╗ ██║█████╗  ██║██╔██║        █████╗  ██║   ██║██║   ██║██║██████╔╝██║██╔██║"
            "██║██║╚██╗██║██╔══╝  ████╔╝██║        ██╔══╝  ██║▄▄ ██║██║   ██║██║██╔═══╝ ████╔╝██║"
            "██║██║ ╚████║██║     ╚██████╔╝███████╗███████╗╚██████╔╝╚██████╔╝██║██║     ╚██████╔╝"
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

function Consultar-ResumenSistema {
    param(
        [string]$NombreEquipo = $env:COMPUTERNAME
    )
	
    Clear-Host
    Mostrar-BannerInf
    $Global:ResumenSistemaHTML = @()
    Escribir-Centrado "=================================" -ColorDeFondo "Cyan"
    Escribir-Centrado "Resumen del sistema en $NombreEquipo" -ColorDeFondo "Cyan"
    Escribir-Centrado "=================================" -ColorDeFondo "Cyan"
    Escribir-Centrado ""

    $os = Get-WmiObject -Class Win32_OperatingSystem
    $cs = Get-WmiObject -Class Win32_ComputerSystem
    $proc = Get-WmiObject -Class Win32_Processor
    $disk = Get-WmiObject -Class Win32_LogicalDisk | Where-Object { $_.DeviceID -eq 'C:' }
    $bios = Get-WmiObject -Class Win32_BIOS
    $network = Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true }
    $lastBootUpTime = [Management.ManagementDateTimeConverter]::ToDateTime($os.LastBootUpTime)
    $uptime = (Get-Date) - $lastBootUpTime
    $info = @(
        "Nombre del equipo: $env:COMPUTERNAME",
        "Sistema Operativo: $($os.Caption)",
        "Versión del SO: $($os.Version)",
        "Arquitectura: $($os.OSArchitecture)",
        "Fabricante: $($cs.Manufacturer)",
        "Modelo: $($cs.Model)",
        "Número de serie: $($bios.SerialNumber)",
        "Procesador: $($proc.Name)",
        "Núcleos: $($proc.NumberOfCores)",
        "Hilos: $($proc.NumberOfLogicalProcessors)",
        "Memoria RAM: $([math]::Round($cs.TotalPhysicalMemory / 1GB, 2)) GB",
        "Espacio en disco: $([math]::Round($disk.Size / 1GB, 2)) GB",
        "Espacio libre en disco: $([math]::Round($disk.FreeSpace / 1GB, 2)) GB",
        "Dirección IP: $($network.IPAddress[0])",
        "Máscara de subred: $($network.IPSubnet[0])",
        "Puerta de enlace: $($network.DefaultIPGateway[0])",
        "Servidores DNS: $($network.DNSServerSearchOrder -join ', ')",
        "Dirección MAC: $($network.MACAddress)",
        "Usuario actual: $env:USERNAME",
		"Último reinicio: $lastBootUpTime",
        "Tiempo de actividad: $($uptime.Days) días, $($uptime.Hours) horas, $($uptime.Minutes) minutos"
        
    )

    foreach ($item in $info) {
        Escribir-Centrado $item
        $Global:ResumenSistemaHTML += "$item<br>"
    }

    $Global:ResumenSistemaHTML = $Global:ResumenSistemaHTML -join ""
}

function Consultar-InfoPlacaBase {
    param(
        [string]$NombreEquipo = $env:COMPUTERNAME
    )

    Clear-Host
    Mostrar-BannerInf
    $Global:InfoPlacaBaseHTML = @()
    
    Escribir-Centrado "==========================================" -ColorDeFondo "Cyan"
    Escribir-Centrado "Información sobre placa base en $NombreEquipo" -ColorDeFondo "Cyan"
    Escribir-Centrado "==========================================" -ColorDeFondo "Cyan"
    Escribir-Centrado ""

    $motherboard = Get-WmiObject Win32_BaseBoard -ComputerName $NombreEquipo

    $info = @(
        "Fabricante: $($motherboard.Manufacturer)",
        "Modelo: $($motherboard.Product)",
        "Versión: $($motherboard.Version)",
        "Número de serie: $($motherboard.SerialNumber)",
        "Tag de activo: $($motherboard.Tag)"
    )

    foreach ($item in $info) {
        Escribir-Centrado $item
        $Global:InfoPlacaBaseHTML += "$item<br>"
    }

    $Global:InfoPlacaBaseHTML = $Global:InfoPlacaBaseHTML -join ""
}

function Consultar-InfoCPU {
    param(
        [string]$NombreEquipo = $env:COMPUTERNAME
    )

    Clear-Host
    Mostrar-BannerInf
    $Global:InfoCPUHTML = @()
    
    Escribir-Centrado "======================================" -ColorDeFondo "Cyan"
    Escribir-Centrado "Información sobre la CPU en $NombreEquipo" -ColorDeFondo "Cyan"
    Escribir-Centrado "======================================" -ColorDeFondo "Cyan"
    Escribir-Centrado ""

    $cpuInfo = Get-WmiObject Win32_Processor -ComputerName $NombreEquipo | 
               Select-Object Name, MaxClockSpeed, NumberOfCores, NumberOfLogicalProcessors, L2CacheSize, L3CacheSize

    foreach ($cpu in $cpuInfo) {
        $info = @(
            "Nombre: $($cpu.Name.Trim())",
            "Frecuencia Base (MHz): $($cpu.MaxClockSpeed)",
            "Núcleos: $($cpu.NumberOfCores)",
            "Procesadores lógicos: $($cpu.NumberOfLogicalProcessors)",
            "Caché L2 (KB): $($cpu.L2CacheSize)",
            "Caché L3 (KB): $($cpu.L3CacheSize)",
            ""
        )

        foreach ($item in $info) {
            Escribir-Centrado $item
            $Global:InfoCPUHTML += "$item<br>"
        }
    }

    $Global:InfoCPUHTML = $Global:InfoCPUHTML -join ""
}

function Consultar-InfoMemoria {
    param(
        [string]$NombreEquipo = $env:COMPUTERNAME
    )

    Clear-Host
    Mostrar-BannerInf
    $Global:InfoMemoriaHTML = @()
    
    Escribir-Centrado "=======================================" -ColorDeFondo "Cyan"
    Escribir-Centrado "Información sobre memoria en $NombreEquipo" -ColorDeFondo "Cyan"
    Escribir-Centrado "=======================================" -ColorDeFondo "Cyan"
    Escribir-Centrado ""

    $totalMemory = (Get-WmiObject Win32_ComputerSystem -ComputerName $NombreEquipo).TotalPhysicalMemory / 1GB
    $physicalMemory = Get-WmiObject Win32_PhysicalMemory -ComputerName $NombreEquipo | 
                      Select-Object Manufacturer, PartNumber, Capacity, Speed

    $info = @("Memoria total: $([math]::Round($totalMemory, 2)) GB")

    foreach ($mem in $physicalMemory) {
        if ($mem.Manufacturer -and $mem.Capacity -and $mem.Speed) {
            $info += @(
                ""
				"Fabricante: $($mem.Manufacturer)",
                "Capacidad: $([math]::Round($mem.Capacity / 1GB, 2)) GB",
                "Velocidad: $($mem.Speed) MHz",
                "Número de Serie: $($mem.PartNumber)",
                "--------------------------"
            )
        }
    }

    foreach ($item in $info) {
        Escribir-Centrado $item
        $Global:InfoMemoriaHTML += "$item<br>"
    }

    $Global:InfoMemoriaHTML = $Global:InfoMemoriaHTML -join ""
}

function Consultar-InfoDiscos {
    param(
        [string]$NombreEquipo = $env:COMPUTERNAME
    )

    Clear-Host
    Mostrar-BannerInf
    $Global:InfoDiscosHTML = @()
    
    Escribir-Centrado "======================================" -ColorDeFondo "Cyan"
    Escribir-Centrado "Información sobre discos en $NombreEquipo" -ColorDeFondo "Cyan"
    Escribir-Centrado "======================================" -ColorDeFondo "Cyan"
    Escribir-Centrado ""

    $disks = Get-WmiObject Win32_LogicalDisk -ComputerName $NombreEquipo | 
             Select-Object DeviceID, VolumeName, 
                           @{Name="Size(GB)";Expression={[math]::Round($_.Size/1GB,2)}}, 
                           @{Name="FreeSpace(GB)";Expression={[math]::Round($_.FreeSpace/1GB,2)}}

    foreach ($disk in $disks) {
        $info = @(
            "Unidad: $($disk.DeviceID)",
            "Etiqueta: $($disk.VolumeName)",
            "Tamaño (GB): $($disk.'Size(GB)')",
            "Espacio libre (GB): $($disk.'FreeSpace(GB)')",
            "--------------------------"
        )

        foreach ($item in $info) {
            Escribir-Centrado $item
            $Global:InfoDiscosHTML += "$item<br>"
        }
    }

    $Global:InfoDiscosHTML = $Global:InfoDiscosHTML -join ""
}

function Consultar-InfoRed {
    param(
        [string]$NombreEquipo = $env:COMPUTERNAME
    )

    Clear-Host
    Mostrar-BannerInf
    $Global:InfoRedHTML = @()
    
    Escribir-Centrado "==================================================" -ColorDeFondo "Cyan"
    Escribir-Centrado "Información sobre adaptadores de red en $NombreEquipo" -ColorDeFondo "Cyan"
    Escribir-Centrado "==================================================" -ColorDeFondo "Cyan"
    Escribir-Centrado ""

    $networkAdapters = Get-WmiObject Win32_NetworkAdapterConfiguration -ComputerName $NombreEquipo | Where-Object { $_.IPEnabled -eq $true } # filtra por interfaces activas

    foreach ($adapter in $networkAdapters) {
        $info = @(
            "",
            "Nombre: $($adapter.Description)",
            "Activado: $($adapter.IPEnabled)",
            "Dirección MAC: $($adapter.MACAddress)",
            "Direcciones IP: $($adapter.IPAddress -join ', ')",
            "Máscara de subred: $($adapter.IPSubnet -join ', ')",
            "Puerta de enlace: $($adapter.DefaultIPGateway -join ', ')",
            "Servidores DNS: $($adapter.DNSServerSearchOrder -join ', ')",
            "--------------------------"
        )

        foreach ($item in $info) {
            Escribir-Centrado $item
            $Global:InfoRedHTML += "$item<br>"
        }
    }

    $Global:InfoRedHTML = $Global:InfoRedHTML -join ""
}

function Consultar-InfoGPU {
    param(
        [string]$NombreEquipo = $env:COMPUTERNAME
    )

    Clear-Host
    Mostrar-BannerInf
    $Global:InfoGPUHTML = @()
    
    Escribir-Centrado "===================================" -ColorDeFondo "Cyan"
    Escribir-Centrado "Información sobre GPU en $NombreEquipo" -ColorDeFondo "Cyan"
    Escribir-Centrado "===================================" -ColorDeFondo "Cyan"
    Escribir-Centrado ""

    $gpuInfo = Get-WmiObject Win32_VideoController -ComputerName $NombreEquipo | 
               Select-Object Name, @{Name='MemoriaAdaptador'; Expression={[math]::round($_.AdapterRAM / 1MB, 2)}}, 
                              DriverVersion, CurrentRefreshRate

    if ($gpuInfo) {
        foreach ($gpu in $gpuInfo) {
            $info = @(
                "Nombre: $($gpu.Name)",
                "Memoria del adaptador (MB): $($gpu.MemoriaAdaptador)",
                "Versión del controlador: $($gpu.DriverVersion)",
                "Tasa de refresco (Hz): $($gpu.CurrentRefreshRate)",
                ""
            )

            foreach ($item in $info) {
                Escribir-Centrado $item
                $Global:InfoGPUHTML += "$item<br>"
            }
        }
    } else {
        $mensaje = "No se encontró información sobre la GPU."
        Escribir-Centrado $mensaje
        $Global:InfoGPUHTML += "$mensaje<br>"
    }

    $Global:InfoGPUHTML = $Global:InfoGPUHTML -join ""
}

function Consultar-InfoUSB {
    param(
        [string]$NombreEquipo = $env:COMPUTERNAME
    )

    Clear-Host
    Mostrar-BannerInf
    $Global:InfoUSBHTML = @()
    
    Escribir-Centrado "=================================================" -ColorDeFondo "Cyan"
    Escribir-Centrado "Información sobre USB's registrados en $NombreEquipo" -ColorDeFondo "Cyan"
    Escribir-Centrado "=================================================" -ColorDeFondo "Cyan"
    Escribir-Centrado ""

    try {
        $usbDevices = Get-WmiObject Win32_PnPEntity -ComputerName $NombreEquipo | 
                      Where-Object { $_.PNPClass -eq "USB" -or $_.Name -like "*USB*" }
        
        if ($usbDevices) {
            foreach ($device in $usbDevices) {
                $nombreLimpio = $device.Name -replace '\(.*?\)', ''
                $info = @(
                    "Nombre: $nombreLimpio",
                    "Id de instancia: $($device.DeviceID)",
                    "Fabricante: $($device.Manufacturer)",
                    "Descripción: $($device.Description)",
                    "--------------------------"
                )

                foreach ($item in $info) {
                    Escribir-Centrado $item
                    $Global:InfoUSBHTML += "$item<br>"
                }
            }
        } else {
            $mensaje = "No se encontraron dispositivos USB."
            Escribir-Centrado $mensaje
            $Global:InfoUSBHTML += "$mensaje<br>"
        }
    } catch {
        $errorMensaje = "Error al obtener información de dispositivos USB: $_"
        Escribir-Centrado $errorMensaje
        $Global:InfoUSBHTML += "$errorMensaje<br>"
    }

    $Global:InfoUSBHTML = $Global:InfoUSBHTML -join ""
}

function Consultar-InfoBateria {
    param(
        [string]$NombreEquipo = $env:COMPUTERNAME
    )

    Clear-Host
    Mostrar-BannerInf
    $Global:InfoBateriaHTML = @()
    
    Escribir-Centrado "=======================================" -ColorDeFondo "Cyan"
    Escribir-Centrado "Información sobre batería en $NombreEquipo" -ColorDeFondo "Cyan"
    Escribir-Centrado "=======================================" -ColorDeFondo "Cyan"
    Escribir-Centrado ""

    try {
        $batteryInfo = Get-WmiObject Win32_Battery -ComputerName $NombreEquipo
        
        if ($batteryInfo) {
            foreach ($battery in $batteryInfo) {
                $info = @(
                    "Nombre: $($battery.Name)",
                    "Descripción: $($battery.Description)",
                    "ID del dispositivo: $($battery.DeviceID)",
                    "Carga estimada (%): $($battery.EstimatedChargeRemaining)",
                    "Tiempo estimado de ejecución (min): $($battery.EstimatedRunTime)",
                    "Capacidad de diseño (mWh): $([math]::round($battery.DesignCapacity / 1000, 2))",
                    "Capacidad completa (mWh): $([math]::round($battery.FullChargeCapacity / 1000, 2))",
                    "Voltaje de diseño (V): $([math]::round($battery.DesignVoltage / 1000, 2))",
                    "Gestión de energía soportada: $($battery.PowerManagementSupported)",
                    "--------------------------"
                )

                foreach ($item in $info) {
                    Escribir-Centrado $item
                    $Global:InfoBateriaHTML += "$item<br>"
                }
            }
        } else {
            $mensaje = "No se encontró información sobre la batería."
            Escribir-Centrado $mensaje
            $Global:InfoBateriaHTML += "$mensaje<br>"
        }
    } catch {
        $errorMensaje = "Error al obtener información de la batería: $_"
        Escribir-Centrado $errorMensaje
        $Global:InfoBateriaHTML += "$errorMensaje<br>"
    }

    $Global:InfoBateriaHTML = $Global:InfoBateriaHTML -join ""
}

function Consultar-Actualizaciones {
    param(
        [string]$NombreEquipo = $env:COMPUTERNAME
    )

    Clear-Host
    Mostrar-BannerInf
    $Global:InfoActualizacionesHTML = @()
    
    Escribir-Centrado "===============================================" -ColorDeFondo "Cyan"
    Escribir-Centrado "Información sobre actualizaciones en $NombreEquipo" -ColorDeFondo "Cyan"
    Escribir-Centrado "===============================================" -ColorDeFondo "Cyan"
    Escribir-Centrado ""

    try {
        $updates = Get-WmiObject -Class Win32_QuickFixEngineering -ComputerName $NombreEquipo | 
                   Sort-Object InstalledOn -Descending
        
        if ($updates) {
            foreach ($update in $updates) {
                $formattedDate = Get-Date -Date $update.InstalledOn -Format 'dd/MM/yyyy'
                $info = "Descripción: $($update.Description.PadRight(25)) HotFixID: $($update.HotFixID.PadRight(10)) Instalado el: $formattedDate"
                
                Escribir-Centrado $info
                $Global:InfoActualizacionesHTML += "$info<br>"
            }
        } else {
            $mensaje = "No se encontraron actualizaciones instaladas."
            Escribir-Centrado $mensaje
            $Global:InfoActualizacionesHTML += "$mensaje<br>"
        }
    } catch {
        $errorMensaje = "Error al obtener información de actualizaciones: $_"
        Escribir-Centrado $errorMensaje -ColorDeTexto "Red"
        $Global:InfoActualizacionesHTML += "<p style='color: red;'>$errorMensaje</p>"
    }

    # Unir el contenido HTML sin saltos de línea adicionales
    $Global:InfoActualizacionesHTML = $Global:InfoActualizacionesHTML -join ""
}

function Consultar-InfoSO {
    param(
        [string]$NombreEquipo = $env:COMPUTERNAME
    )

    Clear-Host
    Mostrar-BannerInf
    $Global:InfoSOHTML = @()
    
    Escribir-Centrado "=================================================" -ColorDeFondo "Cyan"
    Escribir-Centrado "Información sobre sistema operativo en $NombreEquipo" -ColorDeFondo "Cyan"
    Escribir-Centrado "=================================================" -ColorDeFondo "Cyan"
    Escribir-Centrado ""

    try {
        $os = Get-WmiObject Win32_OperatingSystem -ComputerName $NombreEquipo
        $activationStatus = Get-WmiObject -Class SoftwareLicensingProduct -ComputerName $NombreEquipo |
                            Where-Object { $_.PartialProductKey -and $_.Name -like 'Windows*' } |
                            Select-Object -First 1

        $info = @(
            "Nombre: $($os.Caption)",
            "Versión: $($os.Version)",
            "Arquitectura: $($os.OSArchitecture)"
        )

        if ($activationStatus) {
            $status = switch ($activationStatus.LicenseStatus) {
                0 { "Sin licencia :(" }
                1 { "Con licencia :)" }
                2 { "Período de gracia Out-Of-Box" }
                3 { "Período de gracia Out-Of-Tolerance" }
                4 { "Período de gracia no genuino" }
                5 { "Notificación" }
                6 { "Período de gracia extendida" }
                default { "Estado desconocido" }
            }
        } else {
            $status = "No disponible"
        }
        $info += "Activación: $status"

        foreach ($item in $info) {
            Escribir-Centrado $item
            $Global:InfoSOHTML += "$item<br>"
        }
    } catch {
        $errorMensaje = "Error al obtener información del sistema operativo: $_"
        Escribir-Centrado $errorMensaje
        $Global:InfoSOHTML += "$errorMensaje<br>"
    }

    $Global:InfoSOHTML = $Global:InfoSOHTML -join ""
}

function Consultar-EstadoServicios {
    param(
        [string]$NombreEquipo = $env:COMPUTERNAME
    )

    Clear-Host
    Mostrar-BannerInf
    $Global:InfoServiciosHTML = @()

    Escribir-Centrado "=========================================" -ColorDeFondo "Cyan"
    Escribir-Centrado "Información sobre servicios en $NombreEquipo" -ColorDeFondo "Cyan"
    Escribir-Centrado "=========================================" -ColorDeFondo "Cyan"
    Escribir-Centrado ""

    $serviceNames = @(
        'CryptSvc', 'Dhcp', 'DcomLaunch', 'Dnscache', 'EventLog', 'LanmanServer',
        'LanmanWorkstation', 'mpssvc', 'OCS Inventory Service', 'PandaAetherAgent',
        'PlugPlay', 'Power', 'RpcSs', 'Schedule', 'Themes', 'W32Time',
        'WinDefend', 'WSearch', 'wuauserv', 'ClickToRunSvc'
    ) | Sort-Object

    try {
        $services = Get-WmiObject Win32_Service -ComputerName $NombreEquipo

        # Definir longitudes fijas para las columnas
        $maxDisplayNameLength = 43  # Ancho fijo para el nombre del servicio
        $maxNameLength = 23         # Ancho fijo para el nombre corto
        $maxStatusLength = 15       # Ancho fijo para el estado

        $headerFormat = "{0,-$maxDisplayNameLength} {1,-$maxNameLength} {2,-$maxStatusLength}"
        $header = $headerFormat -f "Nombre del Servicio", "Nombre Corto", "Estado"
        Escribir-Centrado $header
        Escribir-Centrado ("-" * ($maxDisplayNameLength + $maxNameLength + $maxStatusLength + 2))
        $Global:InfoServiciosHTML += "$header<br>" + ("-" * ($maxDisplayNameLength + $maxNameLength + $maxStatusLength + 2)) + "<br>"

        foreach ($serviceName in $serviceNames) {
            $service = $services | Where-Object { $_.Name -eq $serviceName }
            if ($service) {
                $displayName = $service.DisplayName
                $name = $service.Name
                $statusIcon = switch ($service.State) {
                    "Running" { "En ejecución" }
                    "Stopped" { "Detenido" }
                    default { $service.State }
                }
                $color = switch ($service.State) {
                    "Running" { "Verde" }
                    "Stopped" { "Rojo" }
                    default { "Amarillo" }
                }
            } else {
                $displayName = $serviceName
                $name = $serviceName
                $statusIcon = "Ausente"
                $color = "Amarillo"
            }

            # Truncar o rellenar los campos para que se ajusten a las longitudes fijas
            $displayName = $displayName.PadRight($maxDisplayNameLength).Substring(0, $maxDisplayNameLength)
            $name = $name.PadRight($maxNameLength).Substring(0, $maxNameLength)
            $statusIcon = $statusIcon.PadRight($maxStatusLength).Substring(0, $maxStatusLength)

            $lineFormat = "{0} {1} {2}"
            $line = $lineFormat -f $displayName, $name, $statusIcon
            
            Escribir-Centrado $line -ColorDeFondo $color
            $Global:InfoServiciosHTML += "<span style='color: $color;'>$line</span><br>"
        }
    } catch {
        $errorMensaje = "Error al obtener información de servicios: $_"
        Escribir-Centrado $errorMensaje -ColorDeFondo "Rojo"
        $Global:InfoServiciosHTML += "<span style='color: red;'>$errorMensaje</span><br>"
    }

    $Global:InfoServiciosHTML = $Global:InfoServiciosHTML -join ""
}

function Consultar-InfoUsuarios {
    param(
        [string]$NombreEquipo = $env:COMPUTERNAME,
        [switch]$ParaHTML = $false
    )

    if (-not $ParaHTML) {
        Clear-Host
        Mostrar-BannerInf
        
        Escribir-Centrado "===================================================" -ColorDeFondo "Cyan"
        Escribir-Centrado "Información sobre usuarios y perfiles en $NombreEquipo" -ColorDeFondo "Cyan"
        Escribir-Centrado "===================================================" -ColorDeFondo "Cyan"
        Escribir-Centrado ""
    }

    $Global:InfoUsuariosHTML = @()
    
    try {
        # Información de perfiles de usuario
        Escribir-Centrado "Perfiles de Usuario" -ColorDeFondo "Yellow"
        $Global:InfoUsuariosHTML += "<h3>Perfiles de Usuario</h3>"

        $userProfiles = Get-WmiObject Win32_UserProfile -ComputerName $NombreEquipo | Where-Object { -not $_.Special }
        foreach ($profile in $userProfiles) {
            $sid = $profile.SID
            $userName = (New-Object System.Security.Principal.SecurityIdentifier($sid)).Translate([System.Security.Principal.NTAccount]).Value
            $lastUseTime = if ($profile.LastUseTime) {
                [DateTime]::ParseExact($profile.LastUseTime.Substring(0,14), "yyyyMMddHHmmss", $null).ToString("dd/MM/yyyy HH:mm")
            } else {
                "No disponible"
            }
            
            Escribir-Centrado "Nombre de usuario: $userName"
            Escribir-Centrado "Ruta del perfil: $($profile.LocalPath)"
            Escribir-Centrado "Último uso: $lastUseTime"
            Escribir-Centrado ""

            $Global:InfoUsuariosHTML += "Nombre de usuario: $userName<br>"
            $Global:InfoUsuariosHTML += "Ruta del perfil: $($profile.LocalPath)<br>"
            $Global:InfoUsuariosHTML += "Último uso: $lastUseTime<br><br>"
        }

        # Información de usuarios locales
        Escribir-Centrado "Usuarios Locales" -ColorDeFondo "Yellow"
        $Global:InfoUsuariosHTML += "<h3>Usuarios Locales</h3>"

        $localUsers = Get-WmiObject Win32_UserAccount -ComputerName $NombreEquipo -Filter "LocalAccount=True"
        foreach ($user in $localUsers) {
            Escribir-Centrado "Nombre: $($user.Name)"
            Escribir-Centrado "Habilitado: $(-not $user.Disabled)"
            Escribir-Centrado "Último inicio de sesión: No disponible"
            Escribir-Centrado "Última vez que se cambió la contraseña: No disponible"
            Escribir-Centrado "Expiración de la contraseña: No disponible"
            Escribir-Centrado ""

            $Global:InfoUsuariosHTML += "Nombre: $($user.Name)<br>"
            $Global:InfoUsuariosHTML += "Habilitado: $(-not $user.Disabled)<br>"
            $Global:InfoUsuariosHTML += "Último inicio de sesión: No disponible<br>"
            $Global:InfoUsuariosHTML += "Última vez que se cambió la contraseña: No disponible<br>"
            $Global:InfoUsuariosHTML += "Expiración de la contraseña: No disponible<br><br>"
        }
    } catch {
        $errorMensaje = "Error al obtener información de usuarios: $_"
        Escribir-Centrado $errorMensaje -ColorDeTexto "Rojo"
        $Global:InfoUsuariosHTML += "<p style='color: red;'>$errorMensaje</p>"
    }

    $Global:InfoUsuariosHTML = $Global:InfoUsuariosHTML -join ""

<#     if (-not $ParaHTML) {
        Escribir-Centrado ""
        Escribir-Centrado "Presiona cualquier tecla para continuar..."
        [void][System.Console]::ReadKey($true)
    } #>
}

function Consultar-Políticas {
    param(
        [string]$NombreEquipo = $env:COMPUTERNAME
    )

    Clear-Host
    Mostrar-BannerInf
    $Global:InfoPoliticasHTML = @()
    
    Escribir-Centrado "=========================================" -ColorDeFondo "Cyan"
    Escribir-Centrado "Información sobre políticas en $NombreEquipo" -ColorDeFondo "Cyan"
    Escribir-Centrado "=========================================" -ColorDeFondo "Cyan"
    Escribir-Centrado ""

    try {
        # Ejecutar gpresult /r y filtrar las líneas no deseadas
		
        $gpresultOutput = gpresult /r /s $NombreEquipo | 
            Select-Object -Skip 9 |  # Omitir las primeras 9 líneas
            Where-Object { $_ -notmatch "Creado el" } |  # Omitir la línea que contiene "Creado el"
            ForEach-Object { $_.Trim() } |  # Eliminar espacios en blanco al inicio y final de cada línea
            Where-Object { $_ -ne "" }  # Eliminar líneas en blanco

        foreach ($line in $gpresultOutput) {
            Escribir-Centrado $line
            $Global:InfoPoliticasHTML += "$line<br>"
        }
    }
    catch {
        $errorMensaje = "Error al obtener información de políticas: $_"
        Escribir-Centrado $errorMensaje -ColorDeTexto "Rojo"
        $Global:InfoPoliticasHTML += "<p style='color: red;'>$errorMensaje</p>"
    }

    $Global:InfoPoliticasHTML = $Global:InfoPoliticasHTML -join ""
}

function Consultar-Controladores {
    param(
        [string]$NombreEquipo = $env:COMPUTERNAME
    )

    Clear-Host
    Mostrar-BannerInf
    
    Escribir-Centrado "==============================================" -ColorDeFondo "Cyan"
    Escribir-Centrado "Información sobre controladores en $NombreEquipo" -ColorDeFondo "Cyan"
    Escribir-Centrado "==============================================" -ColorDeFondo "Cyan"
    Escribir-Centrado ""

    $Global:InfoControladoresHTML = @()
    $Global:InfoControladoresHTML += "<h3>Controladores instalados:</h3>"

    $drivers = Get-WmiObject Win32_PnPSignedDriver -ComputerName $NombreEquipo | 
               Select-Object DeviceName, Manufacturer, DriverVersion |
               Sort-Object DeviceName

    if ($drivers.Count -eq 0) {
        Escribir-Centrado "No se encontraron controladores instalados."
        $Global:InfoControladoresHTML += "No se encontraron controladores instalados.<br>"
    } else {
        Escribir-Centrado ""
		Escribir-Centrado "Controladores instalados:" -ColorDeFondo "Yellow"
        Escribir-Centrado ""
		Escribir-Centrado "Total de controladores: $($drivers.Count)" -ColorDeFondo "Verde"
        Escribir-Centrado ""
        $Global:InfoControladoresHTML += "Total de controladores: $($drivers.Count)<br><br>"

        foreach ($driver in $drivers) {
            $info = "Dispositivo: $($driver.DeviceName) - Fabricante: $($driver.Manufacturer) - Versión: $($driver.DriverVersion)"
            
            Escribir-Centrado $info
            $Global:InfoControladoresHTML += "$info<br>"
        }
    }

    $Global:InfoControladoresHTML = $Global:InfoControladoresHTML -join ""

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
        # Aquí va el código para el menú interactivo
        do {
            Mostrar-BannerInf
            Escribir-Centrado "======================================" -ColorDeFondo "Cyan"
            Escribir-Centrado "Información sobre software instalado" -ColorDeFondo "Cyan"
            Escribir-Centrado "======================================" -ColorDeFondo "Cyan"
            Escribir-Centrado ""

            # Obtener la lista de software instalado (solo si no se ha obtenido antes)
            if (-not $softwareOrdenado) {
                try {
                    $software = Get-WmiObject -Class Win32_Product -ComputerName $NombreEquipo | Select-Object Name, Version, Vendor, InstallDate
                    $softwareOrdenado = $software | Sort-Object Name
                }
                catch {
                    Escribir-Centrado "Error al obtener información del software en $NombreEquipo $_" -ColorDeTexto "Rojo"
                    return
                }
            }

            Escribir-Centrado "1. Mostrar todo el software instalado"
			Escribir-Centrado "2. Buscar software específico"
			Escribir-Centrado "3. Mostrar software instalado en los últimos 30 días"
			Escribir-Centrado "4. Mostrar software por fabricante"
			Escribir-Centrado "0. Volver al menú principal info_equipo"
			Escribir-Centrado ""

			Escribir-Centrado "Seleccione una opción (0-4): " -NoNewline
			$opcion = Read-Host

			$output = @()

			switch ($opcion) {
				"1" { Mostrar-TodoSoftware }
				"2" { Buscar-Software }
				"3" { Mostrar-SoftwareReciente }
				"4" { Mostrar-SoftwarePorFabricante }
				"0" { return }
				default { 
					Escribir-Centrado "Opción incorrecta, por favor seleccione una opción válida." -ColorDeTexto "Rojo"
					Start-Sleep -Seconds 2
				}
			}

			# Mostrar la salida
			if ($output.Count -gt 0) {
				Write-Host ""
				foreach ($line in $output) {
					Escribir-Centrado $line
				}
			}

# Pausa personalizada solo si no se seleccionó la opción 0
if ($opcion -ne "0") { 
    Escribir-Centrado ""
    Escribir-Centrado "Presione cualquier tecla para continuar..." -NoNewline
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    Escribir-Centrado ""
}

        } while ($opcion -ne "0")  # Continuar mostrando el menú hasta que se seleccione la opción 0
    }
}

function Mostrar-TodoSoftware {
    Escribir-Centrado "Software instalado:" -ColorDeFondo "Yellow"
    foreach ($prog in $softwareOrdenado) {
        Escribir-Centrado "Nombre: $($prog.Name)"
        Escribir-Centrado "Versión: $($prog.Version)"
        Escribir-Centrado "Fabricante: $($prog.Vendor)"
        if ($prog.InstallDate) {
            $fecha = [DateTime]::ParseExact($prog.InstallDate, "yyyyMMdd", $null)
            Escribir-Centrado "Fecha de instalación: $(Get-Date -Format 'dd/MM/yyyy' -Date $fecha)"
        } else {
            Escribir-Centrado "Fecha de instalación: No disponible"
        }
        Escribir-Centrado "---------------------------"
    }
}

function Buscar-Software {
    $busqueda = Read-Host (Escribir-Centrado "Introduzca el nombre del software a buscar" -NoNewline)
    $resultados = $softwareOrdenado | Where-Object { $_.Name -like "*$busqueda*" }
    if ($resultados) {
        Escribir-Centrado "Resultados de la búsqueda para '$busqueda':" -ColorDeFondo "Yellow"
        foreach ($prog in $resultados) {
            Escribir-Centrado "Nombre: $($prog.Name)"
            Escribir-Centrado "Versión: $($prog.Version)"
            Escribir-Centrado "Fabricante: $($prog.Vendor)"
            if ($prog.InstallDate) {
                $fecha = [DateTime]::ParseExact($prog.InstallDate, "yyyyMMdd", $null)
                Escribir-Centrado "Fecha de instalación: $(Get-Date -Format 'dd/MM/yyyy' -Date $fecha)"
            } else {
                Escribir-Centrado "Fecha de instalación: No disponible"
            }
            Escribir-Centrado "---------------------------"
        }
    } else {
        Escribir-Centrado "No se encontraron resultados para '$busqueda'." -ColorDeTexto "Amarillo"
    }
}

function Mostrar-SoftwareReciente {
    $fechaLimite = (Get-Date).AddDays(-30)
    $softwareReciente = $softwareOrdenado | Where-Object { 
        if ($_.InstallDate) {
            $fechaInstalacion = [DateTime]::ParseExact($_.InstallDate, "yyyyMMdd", $null)
            $fechaInstalacion -gt $fechaLimite
        } else {
            $false
        }
    }
    Escribir-Centrado "Software instalado en los últimos 30 días:" -ColorDeFondo "Yellow"
    foreach ($prog in $softwareReciente) {
        Escribir-Centrado "Nombre: $($prog.Name)"
        Escribir-Centrado "Versión: $($prog.Version)"
        Escribir-Centrado "Fabricante: $($prog.Vendor)"
        if ($prog.InstallDate) {
            $fecha = [DateTime]::ParseExact($prog.InstallDate, "yyyyMMdd", $null)
            Escribir-Centrado "Fecha de instalación: $(Get-Date -Format 'dd/MM/yyyy' -Date $fecha)"
        }
        Escribir-Centrado "---------------------------"
    }
}

function Mostrar-SoftwarePorFabricante {
    $fabricantes = $softwareOrdenado | Group-Object -Property Vendor
    Escribir-Centrado "Software por fabricante:" -ColorDeFondo "Yellow"
    foreach ($fabricante in $fabricantes) {
        Escribir-Centrado "Fabricante: $($fabricante.Name)" -ColorDeFondo "Verde"
        Escribir-Centrado "Número de programas: $($fabricante.Count)"
        Escribir-Centrado "Programas:"
        foreach ($prog in $fabricante.Group) {
            Escribir-Centrado "  - $($prog.Name) (Versión: $($prog.Version))"
            if ($prog.InstallDate) {
                $fecha = [DateTime]::ParseExact($prog.InstallDate, "yyyyMMdd", $null)
                Escribir-Centrado "    Fecha de instalación: $(Get-Date -Format 'dd/MM/yyyy' -Date $fecha)"
            } else {
                Escribir-Centrado "    Fecha de instalación: No disponible"
            }
        }
        Escribir-Centrado "---------------------------"
    }
}

function Consultar-Arranque {
    param(
        [string]$NombreEquipo = $env:COMPUTERNAME
    )

    Mostrar-BannerInf
    $Global:InfoArranqueHTML = @()
    
    Escribir-Centrado "===============================================" -ColorDeFondo "Cyan"
    Escribir-Centrado "Información sobre arranque en $NombreEquipo" -ColorDeFondo "Cyan"
    Escribir-Centrado "===============================================" -ColorDeFondo "Cyan"
    Escribir-Centrado ""
    
    # Obtener información sobre el tiempo de arranque
    $os = Get-CimInstance Win32_OperatingSystem -ComputerName $NombreEquipo
    $lastBootUpTime = $os.LastBootUpTime
    $uptime = (Get-Date) - $lastBootUpTime
    
    Escribir-Centrado "Último arranque: $lastBootUpTime"
    Escribir-Centrado "Tiempo de actividad: $($uptime.Days) días, $($uptime.Hours) horas, $($uptime.Minutes) minutos"
    
    $Global:InfoArranqueHTML += "Último arranque: $lastBootUpTime<br>"
    $Global:InfoArranqueHTML += "Tiempo de actividad: $($uptime.Days) días, $($uptime.Hours) horas, $($uptime.Minutes) minutos<br><br>"
    
    # Obtener programas que se inician automáticamente
    Escribir-Centrado ""
	Escribir-Centrado "Programas de inicio automático habilitados:" -ColorDeFondo "Yellow"
	Escribir-Centrado ""
    $Global:InfoArranqueHTML += "<h3>Programas de inicio automático habilitados:</h3>"

    # Verificar programas en la carpeta de inicio
    $startupFolder = [Environment]::GetFolderPath('Startup')
    $startupItems = Get-ChildItem -Path $startupFolder -ErrorAction SilentlyContinue
    foreach ($item in $startupItems) {
        Escribir-Centrado "- Nombre: $($item.Name)"
        Escribir-Centrado "  Ubicación: $($item.FullName)"
        Escribir-Centrado ""
        $Global:InfoArranqueHTML += "- Nombre: $($item.Name)<br>"
        $Global:InfoArranqueHTML += "  Ubicación: $($item.FullName)<br><br>"
    }

    # Verificar programas en el registro (HKCU)
    $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
    $regItems = Get-ItemProperty -Path $regPath -ErrorAction SilentlyContinue
    foreach ($item in $regItems.PSObject.Properties | Where-Object { $_.Name -notin @('PSPath', 'PSParentPath', 'PSChildName', 'PSDrive', 'PSProvider') }) {
        Escribir-Centrado "- Nombre: $($item.Name)"
        Escribir-Centrado "  Comando: $($item.Value)"
        Escribir-Centrado "  Ubicación: Registro (HKCU)"
        Escribir-Centrado ""
        $Global:InfoArranqueHTML += "- Nombre: $($item.Name)<br>"
        $Global:InfoArranqueHTML += "  Comando: $($item.Value)<br>"
        $Global:InfoArranqueHTML += "  Ubicación: Registro (HKCU)<br><br>"
    }

    # Verificar programas en el registro (HKLM)
    $regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
    $regItems = Get-ItemProperty -Path $regPath -ErrorAction SilentlyContinue
    foreach ($item in $regItems.PSObject.Properties | Where-Object { $_.Name -notin @('PSPath', 'PSParentPath', 'PSChildName', 'PSDrive', 'PSProvider') }) {
        Escribir-Centrado "- Nombre: $($item.Name)"
        Escribir-Centrado "  Comando: $($item.Value)"
        Escribir-Centrado "  Ubicación: Registro (HKLM)"
        Escribir-Centrado ""
        $Global:InfoArranqueHTML += "- Nombre: $($item.Name)<br>"
        $Global:InfoArranqueHTML += "  Comando: $($item.Value)<br>"
        $Global:InfoArranqueHTML += "  Ubicación: Registro (HKLM)<br><br>"
    }

    # Si no se encontraron programas de inicio
    if ($Global:InfoArranqueHTML.Count -eq 2) {
        Escribir-Centrado "No se encontraron programas de inicio automático habilitados."
        $Global:InfoArranqueHTML += "No se encontraron programas de inicio automático habilitados.<br>"
    }
    
    $Global:InfoArranqueHTML = $Global:InfoArranqueHTML -join ""
}

function Consultar-Energia {
    param(
        [string]$NombreEquipo = $env:COMPUTERNAME
    )

    Mostrar-BannerInf
    $Global:InfoEnergiaHTML = @()
    
    Escribir-Centrado "===============================================" -ColorDeFondo "Cyan"
    Escribir-Centrado "Información de energía en $NombreEquipo" -ColorDeFondo "Cyan"
    Escribir-Centrado "===============================================" -ColorDeFondo "Cyan"
    Escribir-Centrado ""
    
    # Asegurarse de que el servicio de energía esté en ejecución
    try {
        $powerService = Get-Service -Name "Power" -ErrorAction Stop
        if ($powerService.Status -ne "Running") {
            Start-Service -Name "Power" -ErrorAction Stop
            Escribir-Centrado "Servicio de energía iniciado."
            $Global:InfoEnergiaHTML += "Servicio de energía iniciado.<br>"
        } else {
            Escribir-Centrado "El servicio de energía está en ejecución."
            $Global:InfoEnergiaHTML += "El servicio de energía está en ejecución.<br>"
        }
    } catch {
        Escribir-Centrado "Error al manipular el servicio de energía: $_" -ColorDeTexto "Rojo"
        $Global:InfoEnergiaHTML += "Error al manipular el servicio de energía: $_<br>"
    }
    
    # Listar todos los planes de energía disponibles
    try {
        $allPlans = powercfg /list
        Escribir-Centrado ""
		Escribir-Centrado ""
		Escribir-Centrado "Planes de energía disponibles:" -ColorDeFondo "Yellow"
        $Global:InfoEnergiaHTML += "<h3>Planes de energía disponibles:</h3>"
        foreach ($plan in $allPlans) {
            Escribir-Centrado $plan
            $Global:InfoEnergiaHTML += "$plan<br>"
        }
    } catch {
        Escribir-Centrado "Error al obtener la lista de planes de energía: $_" -ColorDeTexto "Rojo"
        $Global:InfoEnergiaHTML += "Error al obtener la lista de planes de energía: $_<br>"
    }
    
    # Obtener configuración de suspensión
    try {
        $sleepSettings = powercfg /query SCHEME_CURRENT SUB_SLEEP
        Escribir-Centrado ""
		Escribir-Centrado "Configuración de suspensión:" -ColorDeFondo "Yellow"
        $Global:InfoEnergiaHTML += "<h3>Configuración de suspensión:</h3>"
		Escribir-Centrado ""
        $sleepAfter = $sleepSettings | Select-String "Suspender después de"
        if ($sleepAfter) {
            foreach ($setting in $sleepAfter) {
                Escribir-Centrado $setting
                $Global:InfoEnergiaHTML += "$setting<br>"
            }
        } else {
            Escribir-Centrado "No se encontró información sobre la suspensión."
            $Global:InfoEnergiaHTML += "No se encontró información sobre la suspensión.<br>"
        }
    } catch {
        Escribir-Centrado "Error al obtener la configuración de suspensión: $_" -ColorDeTexto "Rojo"
        $Global:InfoEnergiaHTML += "Error al obtener la configuración de suspensión: $_<br>"
    }

    $Global:InfoEnergiaHTML = $Global:InfoEnergiaHTML -join ""
}

function Consultar-Seguridad {
    param(
        [string]$NombreEquipo = $env:COMPUTERNAME
    )

    Mostrar-BannerInf
    $Global:InfoSeguridadHTML = @()
    
    Escribir-Centrado "=========================================" -ColorDeFondo "Cyan"
    Escribir-Centrado "Información sobre seguridad en $NombreEquipo" -ColorDeFondo "Cyan"
    Escribir-Centrado "=========================================" -ColorDeFondo "Cyan"
    Escribir-Centrado ""
    
    # Verificar el estado del Firewall de Windows
    $firewallStatus = Get-NetFirewallProfile | Select-Object Name, Enabled
    Escribir-Centrado "Estado del Firewall de Windows:" -ColorDeFondo "Yellow"
    $Global:InfoSeguridadHTML += "<h3>Estado del Firewall de Windows:</h3>"
    foreach ($profile in $firewallStatus) {
        $status = if($profile.Enabled) {'Activado'} else {'Desactivado'}
        Escribir-Centrado "- $($profile.Name): $status"
        $Global:InfoSeguridadHTML += "- $($profile.Name): $status<br>"
    }
    
    # Verificar el estado del antivirus (Windows Defender)
    $antivirusStatus = Get-MpComputerStatus
    Escribir-Centrado ""
    Escribir-Centrado "Estado del Antivirus (Windows Defender):" -ColorDeFondo "Yellow"
    $Global:InfoSeguridadHTML += "<h3>Estado del Antivirus (Windows Defender):</h3>"
    $rtpStatus = if($antivirusStatus.RealTimeProtectionEnabled) {'Activada'} else {'Desactivada'}
    Escribir-Centrado "- Protección en tiempo real: $rtpStatus"
    Escribir-Centrado "- Última actualización de definiciones: $($antivirusStatus.AntivirusSignatureLastUpdated)"
    $Global:InfoSeguridadHTML += "- Protección en tiempo real: $rtpStatus<br>"
    $Global:InfoSeguridadHTML += "- Última actualización de definiciones: $($antivirusStatus.AntivirusSignatureLastUpdated)<br>"
    
    # Verificar actualizaciones pendientes
    $updateSession = New-Object -ComObject Microsoft.Update.Session
    $updateSearcher = $updateSession.CreateUpdateSearcher()
    $pendingUpdates = $updateSearcher.Search("IsInstalled=0 and Type='Software'").Updates.Count
    Escribir-Centrado ""
    Escribir-Centrado "Actualizaciones pendientes: $pendingUpdates" -ColorDeFondo "Yellow"
    $Global:InfoSeguridadHTML += "<h3>Actualizaciones pendientes: $pendingUpdates</h3>"
    
    $Global:InfoSeguridadHTML = $Global:InfoSeguridadHTML -join ""
}

function Exportar-InfoSistema {
    param(
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string]$NombreEquipo = $env:COMPUTERNAME
    )

    # Validar que el equipo sea accesible
    if (-not (Test-Connection -ComputerName $NombreEquipo -Count 1 -Quiet)) {
        Write-Error "No se puede conectar al equipo $NombreEquipo"
        return
    }

    # Validación de la ruta de salida
    do {
        $outputPath = Read-Host 'Ruta para guardar el informe HTML, p. ej. C:\Temp [Escritorio]'
        if ([string]::IsNullOrWhiteSpace($outputPath)) {
            $outputPath = [Environment]::GetFolderPath("Desktop")
        }
        if (-not (Test-Path $outputPath -IsValid)) {
            Write-Warning "La ruta especificada no es válida. Por favor, intente de nuevo."
        }
    } while (-not (Test-Path $outputPath -IsValid))

    # Validación del nombre del archivo
    do {
        $outputFile = Read-Host "Introduce el nombre del archivo sin extensión [info_$NombreEquipo]"
        if ([string]::IsNullOrWhiteSpace($outputFile)) {
            $outputFile = "info_$NombreEquipo"
        }
        if (-not ($outputFile -match '^[\w\-. ]+$')) {
            Write-Warning "El nombre del archivo contiene caracteres no válidos. Por favor, intente de nuevo."
        }
    } while (-not ($outputFile -match '^[\w\-. ]+$'))

    # Asegurar que el archivo tenga extensión .html
    if (-not ($outputFile.EndsWith('.html', [StringComparison]::OrdinalIgnoreCase))) {
        $outputFile += '.html'
    }

    Mostrar-BannerInf
    Escribir-Centrado "==============================" -ColorDeFondo "Cyan"
    Escribir-Centrado "Exportar informe de $NombreEquipo" -ColorDeFondo "Cyan"
    Escribir-Centrado "==============================" -ColorDeFondo "Cyan"
    Escribir-Centrado ""

    # Solicitar la ruta de destino
    do {
        $outputPath = Read-Host 'Ruta para guardar el informe HTML, p. ej. C:\Temp [Escritorio]'
        if ([string]::IsNullOrWhiteSpace($outputPath)) {
            $outputPath = [Environment]::GetFolderPath("Desktop")
        }
    } while (-not (Test-Path $outputPath -IsValid))

    # Definir el nombre del archivo por defecto
    $defaultFileName = "info_$NombreEquipo.html"

    # Solicitar nombre del archivo para exportar, usando el nombre por defecto si se deja en blanco
    $outputFile = Read-Host "Introduce el nombre del archivo sin extensión [$defaultFileName]"
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
        $confirmacion = Read-Host "El archivo $fullPath ya existe. ¿Deseas sobrescribirlo? (S/N) [S]"
        if ([string]::IsNullOrWhiteSpace($confirmacion)) {
            $confirmacion = "S"
        }
        if ($confirmacion.ToUpper() -ne 'S') {
            Escribir-Centrado "Operación cancelada por el usuario." -ColorDeTexto "Amarillo"
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
        $lines = $content -split "`r?`n" | ForEach-Object { $_.Trim() }
        $formattedContent = ($lines | Where-Object { $_ -match '\S' }) -join "<br>"
        return $formattedContent
    }

    # Ejecutar todas las funciones de consulta
	Consultar-ResumenSistema -NombreEquipo $NombreEquipo
	Consultar-InfoPlacaBase -NombreEquipo $NombreEquipo
	Consultar-InfoCPU -NombreEquipo $NombreEquipo
	Consultar-InfoMemoria -NombreEquipo $NombreEquipo
	Consultar-InfoDiscos -NombreEquipo $NombreEquipo
	Consultar-InfoRed -NombreEquipo $NombreEquipo
	Consultar-InfoGPU -NombreEquipo $NombreEquipo
	Consultar-InfoUSB -NombreEquipo $NombreEquipo
	Consultar-InfoBateria -NombreEquipo $NombreEquipo
	Consultar-Actualizaciones -NombreEquipo $NombreEquipo
	Consultar-InfoSO -NombreEquipo $NombreEquipo
	Consultar-EstadoServicios -NombreEquipo $NombreEquipo
	Consultar-InfoUsuarios -NombreEquipo $NombreEquipo
	Consultar-Políticas -NombreEquipo $NombreEquipo
	Consultar-Controladores -NombreEquipo $NombreEquipo
	Consultar-SoftwareInstalado -NombreEquipo $NombreEquipo
	Consultar-Arranque -NombreEquipo $NombreEquipo
	Consultar-Energia -NombreEquipo $NombreEquipo
	Consultar-Seguridad -NombreEquipo $NombreEquipo

	# Crear una estructura de datos para almacenar la información
	$infoSecciones = @(
		@{Titulo="Resumen del sistema"; Contenido=(Format-Content $Global:ResumenSistemaHTML)},
		@{Titulo="Placa base"; Contenido=(Format-Content $Global:InfoPlacaBaseHTML)},
		@{Titulo="CPU"; Contenido=(Format-Content $Global:InfoCPUHTML)},
		@{Titulo="Memoria RAM"; Contenido=(Format-Content $Global:InfoMemoriaHTML)},
		@{Titulo="Discos"; Contenido=(Format-Content $Global:InfoDiscosHTML)},
		@{Titulo="Adaptadores de red"; Contenido=(Format-Content $Global:InfoRedHTML)},
		@{Titulo="GPU"; Contenido=(Format-Content $Global:InfoGPUHTML)},
		@{Titulo="Dispositivos USB registrados en el sistema"; Contenido=(Format-Content $Global:InfoUSBHTML)},
		@{Titulo="Baterías"; Contenido=(Format-Content $Global:InfoBateriaHTML)},
		@{Titulo="Actualizaciones"; Contenido=(Format-Content $Global:InfoActualizacionesHTML)},
		@{Titulo="Sistema operativo"; Contenido=(Format-Content $Global:InfoSOHTML)},
        @{Titulo="Servicios relevantes"; Contenido=(Format-Content (Consultar-EstadoServicios -NombreEquipo))},
        @{Titulo="Usuarios"; Contenido=(Format-Content (Consultar-Usuarios -NombreEquipo))},
        @{Titulo="Políticas y grupos"; Contenido=(Format-Content (Consultar-PoliticasGrupos -NombreEquipo))},
        @{Titulo="Controladores"; Contenido=(Format-Content (Consultar-Controladores -NombreEquipo))},
        @{Titulo="Software instalado ordenado por fabricante"; Contenido=(Consultar-SoftwareInstalado -PorFabricante -NombreEquipo $NombreEquipo)}
        @{Titulo="Arranque"; Contenido=(Format-Content (Consultar-Arranque -NombreEquipo))},
        @{Titulo="Energía"; Contenido=(Format-Content (Consultar-Energia -NombreEquipo))},
        @{Titulo="Seguridad"; Contenido=(Format-Content (Consultar-Seguridad -NombreEquipo))}
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

       # Limpiar la pantalla y mostrar el banner
       Clear-Host
       Mostrar-BannerInf

       # Mostrar el mensaje de éxito
       Escribir-Centrado "==============================" -ColorDeFondo "Cyan"
       Escribir-Centrado "Informe exportado con éxito" -ColorDeFondo "Cyan"
       Escribir-Centrado "==============================" -ColorDeFondo "Cyan"
       Escribir-Centrado ""
       Escribir-Centrado "Información exportada a:  $fullPath" -ColorDeTexto "Verde"
   }
   catch {
       # En caso de error, también limpiar la pantalla y mostrar el banner
       Clear-Host
       Mostrar-BannerInf

       Escribir-Centrado "==============================" -ColorDeFondo "Rojo"
       Escribir-Centrado "Error al exportar el informe" -ColorDeFondo "Rojo"
       Escribir-Centrado "==============================" -ColorDeFondo "Rojo"
       Escribir-Centrado ""
       Escribir-Centrado "Error al exportar la información: $_" -ColorDeTexto "Rojo"
   }

   # Esperar a que el usuario presione una tecla antes de continuar
   Escribir-Centrado ""
   Escribir-Centrado "Presiona cualquier tecla para continuar..."
   [void][System.Console]::ReadKey($true)
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
            '15' { Consultar-Controladores -NombreEquipo $NombreEquipo  -ParaHTML}
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
