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
			
			"================================================",
			"",
            "      Información de hardware en $NombreEquipo",
            "",
            "================================================"
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
            "================================================"
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

    function Dibujar-InfoPlacaBase {
        $consoleWidth = $Host.UI.RawUI.WindowSize.Width
        
        $placaBaseItems = @(
            "===============================================",
            "",
            "Información sobre placa base --> $NombreEquipo",
            "",
            "===============================================",
            "",
            "Fabricante: $($motherboard.Manufacturer)",
            "Modelo: $($motherboard.Product)",
            "Versión: $($motherboard.Version)",
            "",
            "==============================================="
        )
        
        $maxWidth = ($placaBaseItems | Measure-Object -Property Length -Maximum).Maximum
        $leftPadding = [math]::Max(0, [math]::Floor(($consoleWidth - $maxWidth) / 2)) + 4
        
        Clear-Host
        Mostrar-BannerInf
        
        foreach ($item in $placaBaseItems) {
            if ($item -match "^={3,}") {
                Escribir-Centrado $item
            } elseif ($item -match "Información sobre placa base -->") {
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
    
    $motherboard = Get-CimInstance Win32_BaseBoard
    Dibujar-InfoPlacaBase
}

function Consultar-InfoCPU {
    param(
        [Parameter(Mandatory=$false)]
        [string]$NombreEquipo = $env:COMPUTERNAME
    )

    function Dibujar-InfoCPU {
        $consoleWidth = $Host.UI.RawUI.WindowSize.Width
        
        $cpuItems = @(
            "===============================================",
            "",
            "Información sobre CPU --> $NombreEquipo",
            "",
            "===============================================",
            "",
            "Nombre: $($cpuInfo.Name.ToString().Trim())",
            "Frecuencia Base (MHz): $($cpuInfo.MaxClockSpeed.ToString().Trim())",
            "Núcleos: $($cpuInfo.NumberOfCores.ToString().Trim())",
            "Procesadores lógicos: $($cpuInfo.NumberOfLogicalProcessors.ToString().Trim())",
            "Caché L2 (KB): $($cpuInfo.L2CacheSize.ToString().Trim())",
            "Caché L3 (KB): $($cpuInfo.L3CacheSize.ToString().Trim())",
            "",
            "==============================================="
        )
        
        $maxWidth = ($cpuItems | Measure-Object -Property Length -Maximum).Maximum
        $leftPadding = [math]::Max(0, [math]::Floor(($consoleWidth - $maxWidth) / 2)) + 2
        
        Clear-Host
        Mostrar-BannerInf
        
        foreach ($item in $cpuItems) {
            if ($item -match "^={3,}") {
                Escribir-Centrado $item
            } elseif ($item -match "Información sobre CPU -->") {
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
    
    $cpuInfo = Get-CimInstance Win32_Processor | Select-Object Name, MaxClockSpeed, NumberOfCores, NumberOfLogicalProcessors, L2CacheSize, L3CacheSize
    Dibujar-InfoCPU
}

function Consultar-InfoMemoria {
    param(
        [Parameter(Mandatory=$false)]
        [string]$NombreEquipo = $env:COMPUTERNAME
    )

    function Dibujar-InfoMemoria {
        $consoleWidth = $Host.UI.RawUI.WindowSize.Width
        
        $memoriaItems = @(
            "===============================================",
            "",
            "Información sobre memoria --> $NombreEquipo",
            "",
            "===============================================",
            "",
            "Memoria total: $($totalMemory) GB",
            "",
            "==============================================="
        )
        
        $maxWidth = ($memoriaItems | Measure-Object -Property Length -Maximum).Maximum
        $leftPadding = [math]::Max(0, [math]::Floor(($consoleWidth - $maxWidth) / 2)) + 4
        
        Clear-Host
        Mostrar-BannerInf
        
        foreach ($item in $memoriaItems) {
            if ($item -match "^={3,}") {
                Escribir-Centrado $item
            } elseif ($item -match "Información sobre memoria -->") {
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
        
        # Mostrar información de los módulos de RAM
        foreach ($mem in $physicalMemory) {
            if ($mem.Manufacturer -and $mem.Capacity -and $mem.Speed) {
                Write-Host "`n" -ForegroundColor Cyan
                Write-Host (" " * $leftPadding) + "Fabricante: $($mem.Manufacturer)" -ForegroundColor Cyan
                Write-Host (" " * $leftPadding) + "Capacidad: $( [math]::Round($mem.Capacity / 1GB, 2)) GB" -ForegroundColor Cyan
                Write-Host (" " * $leftPadding) + "Velocidad: $($mem.Speed) MHz" -ForegroundColor Cyan
                Write-Host (" " * $leftPadding) + "Número de Serie: $($mem.PartNumber)" -ForegroundColor Cyan
                Write-Host (" " * $leftPadding) + "--------------------------" -ForegroundColor Cyan
            }
        }
        
        $host.UI.RawUI.ForegroundColor = "White"
    }
    
    $totalMemory = (Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB
    $physicalMemory = Get-CimInstance Win32_PhysicalMemory | Select-Object Manufacturer, PartNumber, Capacity, Speed
    Dibujar-InfoMemoria
}

function Consultar-InfoDiscos {
    param(
        [Parameter(Mandatory=$false)]
        [string]$NombreEquipo = $env:COMPUTERNAME
    )

    function Dibujar-InfoDiscos {
        $consoleWidth = $Host.UI.RawUI.WindowSize.Width
        
        $discoItems = @(
            "===============================================",
            "",
            "Información sobre discos --> $NombreEquipo",
            "",
            "===============================================",
            ""
        )
        
        $maxWidth = ($discoItems | Measure-Object -Property Length -Maximum).Maximum
        $leftPadding = [math]::Max(0, [math]::Floor(($consoleWidth - $maxWidth) / 2)) + 4
        
        Clear-Host
        Mostrar-BannerInf
        
        foreach ($item in $discoItems) {
            if ($item -match "^={3,}") {
                Escribir-Centrado $item
            } elseif ($item -match "Información sobre discos -->") {
                Escribir-Centrado $item -ColorDeFondo Amarillo
            } else {
                $centeredLine = (" " * $leftPadding) + $item
                Write-Host $centeredLine -ForegroundColor Cyan
            }
        }
        
        # Mostrar información de los discos
        $discos = Get-CimInstance Win32_LogicalDisk | Select-Object DeviceID, VolumeName, @{Name="Size(GB)";Expression={[math]::Round($_.Size/1GB,2)}}, @{Name="FreeSpace(GB)";Expression={[math]::Round($_.FreeSpace/1GB,2)}}
        
        foreach ($disk in $discos) {
            Write-Host "`n" -ForegroundColor Cyan
            Write-Host (" " * $leftPadding) + "Unidad: $($disk.DeviceID)" -ForegroundColor Cyan
            Write-Host (" " * $leftPadding) + "Etiqueta: $($disk.VolumeName)" -ForegroundColor Cyan
            Write-Host (" " * $leftPadding) + "Tamaño (GB): $($disk.'Size(GB)')" -ForegroundColor Cyan
            Write-Host (" " * $leftPadding) + "Espacio libre (GB): $($disk.'FreeSpace(GB)')" -ForegroundColor Cyan
            Write-Host (" " * $leftPadding) + "--------------------------" -ForegroundColor Cyan
        }
        
        $host.UI.RawUI.ForegroundColor = "White"
    }
    
    Dibujar-InfoDiscos
}

function Consultar-InfoRed {
    param(
        [Parameter(Mandatory=$false)]
        [string]$NombreEquipo = $env:COMPUTERNAME
    )

    function Dibujar-InfoRed {
        $consoleWidth = $Host.UI.RawUI.WindowSize.Width
        
        $redItems = @(
            "===============================================================",
            "",
            "Información sobre adaptadores de red --> $NombreEquipo",
            "",
            "==============================================================="
        )
        
        $maxWidth = ($redItems | Measure-Object -Property Length -Maximum).Maximum
        $leftPadding = [math]::Max(0, [math]::Floor(($consoleWidth - $maxWidth) / 2)) + 4
        
        Clear-Host
        Mostrar-BannerInf
        
        foreach ($item in $redItems) {
            if ($item -match "^={3,}") {
                Escribir-Centrado $item
            } elseif ($item -match "Información sobre adaptadores de red -->") {
                Escribir-Centrado $item -ColorDeFondo Amarillo
            } else {
                $centeredLine = (" " * $leftPadding) + $item
                Write-Host $centeredLine -ForegroundColor Cyan
            }
        }
        
        # Mostrar información de los adaptadores de red
        $networkAdapters = Get-NetAdapter
        
        foreach ($adapter in $networkAdapters) {
            if ($null -ne $adapter.ifIndex) {
                $ipConfig = Get-NetIPConfiguration -InterfaceIndex $adapter.ifIndex
                $ipAddresses = ($ipConfig.IPv4Address.IPAddress) -join ', '
                $dnsServers = ($ipConfig.DNSServer.ServerAddresses) -join ', '
                
                Write-Host "`n" -ForegroundColor Cyan
                Write-Host (" " * $leftPadding) + "Nombre: $($adapter.Name)" -ForegroundColor Cyan
                Write-Host (" " * $leftPadding) + "Descripción: $($adapter.InterfaceDescription)" -ForegroundColor Cyan
                Write-Host (" " * $leftPadding) + "Estado: $($adapter.Status)" -ForegroundColor Cyan
                Write-Host (" " * $leftPadding) + "Velocidad del enlace: $($adapter.LinkSpeed)" -ForegroundColor Cyan
                Write-Host (" " * $leftPadding) + "Dirección MAC: $($adapter.MacAddress)" -ForegroundColor Cyan
                Write-Host (" " * $leftPadding) + "Direcciones IP: $ipAddresses" -ForegroundColor Cyan
                
                # Obtener la máscara de subred
                $subnetMask = $ipConfig.IPv4Address.PrefixLength
                if ($subnetMask) {
                    Write-Host (" " * $leftPadding) + "Máscara de subred: /$subnetMask" -ForegroundColor Cyan
                } else {
                    Write-Host (" " * $leftPadding) + "Máscara de subred: No configurada" -ForegroundColor Cyan
                }
                
                # Obtener la puerta de enlace
                $gateway = $ipConfig.IPv4DefaultGateway.NextHop
                if ($gateway) {
                    Write-Host (" " * $leftPadding) + "Puerta de enlace: $gateway" -ForegroundColor Cyan
                } else {
                    Write-Host (" " * $leftPadding) + "Puerta de enlace: No configurada" -ForegroundColor Cyan
                }
                
                Write-Host (" " * $leftPadding) + "Servidores DNS: $dnsServers" -ForegroundColor Cyan
            } else {
                Write-Host "`n" -ForegroundColor Cyan
                Write-Host (" " * $leftPadding) + "Nombre: $($adapter.Name)" -ForegroundColor Cyan
                Write-Host (" " * $leftPadding) + "Error: No se pudo obtener información completa para este adaptador" -ForegroundColor Cyan
            }
            
            Write-Host (" " * $leftPadding) + "--------------------------" -ForegroundColor Cyan
        }
        
        $host.UI.RawUI.ForegroundColor = "White"
    }
    
    Dibujar-InfoRed
}

function Consultar-InfoGPU {
    param(
        [Parameter(Mandatory=$false)]
        [string]$NombreEquipo = $env:COMPUTERNAME
    )

    function Dibujar-InfoGPU {
        $consoleWidth = $Host.UI.RawUI.WindowSize.Width
        
        $gpuItems = @(
            "===============================================",
            "",
            "Información sobre GPU --> $NombreEquipo",
            "",
            "===============================================",
            ""
        )
        
        $maxWidth = ($gpuItems | Measure-Object -Property Length -Maximum).Maximum
        $leftPadding = [math]::Max(0, [math]::Floor(($consoleWidth - $maxWidth) / 2)) + 4
        
        Clear-Host
        Mostrar-BannerInf
        
        foreach ($item in $gpuItems) {
            if ($item -match "^={3,}") {
                Escribir-Centrado $item
            } elseif ($item -match "Información sobre GPU -->") {
                Escribir-Centrado $item -ColorDeFondo Amarillo
            } else {
                $centeredLine = (" " * $leftPadding) + $item
                Write-Host $centeredLine -ForegroundColor Cyan
            }
        }
        
        $gpuInfo = Get-CimInstance Win32_VideoController | Select-Object Name, @{Name='MemoriaAdaptador'; Expression={[math]::round($_.AdapterRAM / 1MB, 2)}}, DriverVersion, CurrentRefreshRate
        
        if ($gpuInfo.Count -eq 0) {
            Write-Host "No se encontró información sobre la GPU." -ForegroundColor Cyan
        } else {
            foreach ($gpu in $gpuInfo) {
                Write-Host "`n" -ForegroundColor Cyan
                Write-Host (" " * $leftPadding) + "Nombre: $($gpu.Name)" -ForegroundColor Cyan
                Write-Host (" " * $leftPadding) + "Memoria del adaptador (MB): $($gpu.MemoriaAdaptador)" -ForegroundColor Cyan
                Write-Host (" " * $leftPadding) + "Versión del controlador: $($gpu.DriverVersion)" -ForegroundColor Cyan
                Write-Host (" " * $leftPadding) + "Tasa de refresco (Hz): $($gpu.CurrentRefreshRate)" -ForegroundColor Cyan
                Write-Host (" " * $leftPadding) + "--------------------------" -ForegroundColor Cyan
            }
        }
        
        $host.UI.RawUI.ForegroundColor = "White"
    }
    
    Dibujar-InfoGPU
}

function Consultar-InfoUSB {
    param(
        [Parameter(Mandatory=$false)]
        [string]$NombreEquipo = $env:COMPUTERNAME
    )

    function Dibujar-InfoUSB {
        $consoleWidth = $Host.UI.RawUI.WindowSize.Width
        
        $usbItems = @(
            "==================================================",
            "",
            "Información sobre USB's registrados --> $NombreEquipo",
            "",
            "==================================================",
            ""
        )
        
        $maxWidth = ($usbItems | Measure-Object -Property Length -Maximum).Maximum
        $leftPadding = [math]::Max(0, [math]::Floor(($consoleWidth - $maxWidth) / 2)) - 3
        
        Clear-Host
        Mostrar-BannerInf
        
        foreach ($item in $usbItems) {
            if ($item -match "^={3,}") {
                Escribir-Centrado $item
            } elseif ($item -match "Información sobre USB's registrados -->") {
                Escribir-Centrado $item -ColorDeFondo Amarillo
            } else {
                $centeredLine = (" " * $leftPadding) + $item
                Write-Host $centeredLine -ForegroundColor Cyan
            }
        }
        
        try {
            $usbDevices = Get-PnpDevice -Class USB -ErrorAction Stop | Where-Object { $_.InstanceId -match '^USB' }
            $results = foreach ($device in $usbDevices) {
                $deviceInfo = Get-PnpDeviceProperty -InstanceId $device.InstanceId
                $lastConnected = ($deviceInfo | Where-Object KeyName -eq 'DEVPKEY_Device_LastArrivalDate').Data
                
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
                    'ÚltimaConexiónOrdenable' = $lastConnectedDate
                }
            }
            
            $sortedResults = $results | 
                Sort-Object -Property ÚltimaConexiónOrdenable -Descending | 
                Select-Object * -ExcludeProperty ÚltimaConexiónOrdenable
            
            foreach ($usb in $sortedResults) {
                Write-Host "`n" -ForegroundColor Cyan
                Write-Host (" " * $leftPadding) + "Nombre: $($usb.Nombre)" -ForegroundColor Cyan
                Write-Host (" " * $leftPadding) + "Id de instancia: $($usb.'Id de instancia')" -ForegroundColor Cyan
                Write-Host (" " * $leftPadding) + "Puerto: $($usb.Puerto)" -ForegroundColor Cyan
                Write-Host (" " * $leftPadding) + "Última conexión: $($usb.'Última conexión')" -ForegroundColor Cyan
                Write-Host (" " * $leftPadding) + "--------------------------" -ForegroundColor Cyan
            }
        } catch {
            Write-Host "Error al obtener información de dispositivos USB: $_" -ForegroundColor Red
        }
        
        $host.UI.RawUI.ForegroundColor = "White"
    }
    
    Dibujar-InfoUSB
}

function Consultar-InfoBateria {
    param(
        [Parameter(Mandatory=$false)]
        [string]$NombreEquipo = $env:COMPUTERNAME
    )

    function Dibujar-InfoBateria {
        $consoleWidth = $Host.UI.RawUI.WindowSize.Width
        
        $bateriaItems = @(
            "===============================================",
            "",
            "Información sobre batería --> $NombreEquipo",
            "",
            "===============================================",
            ""
        )
        
        $maxWidth = ($bateriaItems | Measure-Object -Property Length -Maximum).Maximum
        $leftPadding = [math]::Max(0, [math]::Floor(($consoleWidth - $maxWidth) / 2)) + 4
        
        Clear-Host
        Mostrar-BannerInf
        
        foreach ($item in $bateriaItems) {
            if ($item -match "^={3,}") {
                Escribir-Centrado $item
            } elseif ($item -match "Información sobre batería -->") {
                Escribir-Centrado $item -ColorDeFondo Amarillo
            } else {
                $centeredLine = (" " * $leftPadding) + $item
                Write-Host $centeredLine -ForegroundColor Cyan
            }
        }
        
        $batteryInfo = Get-CimInstance Win32_Battery
        
        if ($batteryInfo) {
            foreach ($battery in $batteryInfo) {
                Write-Host "`n" -ForegroundColor Cyan
                Write-Host (" " * $leftPadding) + "Nombre: $($battery.Name)" -ForegroundColor Cyan
                Write-Host (" " * $leftPadding) + "Descripción: $($battery.Description)" -ForegroundColor Cyan
                Write-Host (" " * $leftPadding) + "ID del dispositivo: $($battery.DeviceID)" -ForegroundColor Cyan
                Write-Host (" " * $leftPadding) + "Carga estimada (%): $($battery.EstimatedChargeRemaining)" -ForegroundColor Cyan
                Write-Host (" " * $leftPadding) + "Tiempo estimado de ejecución (min): $($battery.EstimatedRunTime)" -ForegroundColor Cyan
                Write-Host (" " * $leftPadding) + "Capacidad de diseño (mWh): $([math]::round($battery.DesignCapacity / 1000, 2))" -ForegroundColor Cyan
                Write-Host (" " * $leftPadding) + "Capacidad completa (mWh): $([math]::round($battery.FullChargeCapacity / 1000, 2))" -ForegroundColor Cyan
                Write-Host (" " * $leftPadding) + "Voltaje de diseño (V): $([math]::round($battery.DesignVoltage / 1000, 2))" -ForegroundColor Cyan
                Write-Host (" " * $leftPadding) + "Gestión de energía soportada: $($battery.PowerManagementSupported)" -ForegroundColor Cyan
                Write-Host (" " * $leftPadding) + "--------------------------" -ForegroundColor Cyan
            }
        } else {
            Escribir-Centrado "No se encontró información sobre la batería." -ForegroundColor Cyan
        }
        
        $host.UI.RawUI.ForegroundColor = "White"
    }
    
    Dibujar-InfoBateria
}

function Consultar-Actualizaciones {
    param(
        [Parameter(Mandatory=$false)]
        [string]$NombreEquipo = $env:COMPUTERNAME
    )

    function Dibujar-Actualizaciones {
        $consoleWidth = $Host.UI.RawUI.WindowSize.Width
        
        $actualizacionItems = @(
            "================================================",
            "",
            "Información sobre actualizaciones --> $NombreEquipo",
            "",
            "================================================",
            ""
        )
        
        $maxWidth = ($actualizacionItems | Measure-Object -Property Length -Maximum).Maximum
        $leftPadding = [math]::Max(0, [math]::Floor(($consoleWidth - $maxWidth) / 2)) - 18
        
        Clear-Host
        Mostrar-BannerInf
        
        foreach ($item in $actualizacionItems) {
            if ($item -match "^={3,}") {
                Escribir-Centrado $item
            } elseif ($item -match "Información sobre actualizaciones -->") {
                Escribir-Centrado $item -ColorDeFondo Amarillo
            } else {
                $centeredLine = (" " * $leftPadding) + $item
                Write-Host $centeredLine -ForegroundColor Cyan
            }
        }
        
        $updates = Get-HotFix | Sort-Object InstalledOn -Descending
        $output = @()
        if ($updates.Count -gt 0) {
            foreach ($update in $updates) {
                $formattedDate = Get-Date -Date $update.InstalledOn -Format 'dd/MM/yyyy'
                $description = $update.Description.PadRight(25)
                $hotfixID = $update.HotFixID.PadRight(10)
                $output += "Descripción: $description HotFixID: $hotfixID Instalado el: $formattedDate"
            }
        } else {
            $output += "No se encontraron actualizaciones instaladas."
        }
        
        foreach ($line in $output) {
            Write-Host "`n" -ForegroundColor Cyan
            Write-Host (" " * $leftPadding) + $line -ForegroundColor Cyan
            Write-Host (" " * $leftPadding) + "--------------------------" -ForegroundColor Cyan
        }
        
        $host.UI.RawUI.ForegroundColor = "White"
    }
    
    Dibujar-Actualizaciones
}

function Consultar-InfoSO {
    param(
        [Parameter(Mandatory=$false)]
        [string]$NombreEquipo = $env:COMPUTERNAME
    )

    function Dibujar-InfoSO {
        $consoleWidth = $Host.UI.RawUI.WindowSize.Width
        
        $soItems = @(
            "==================================================",
            "",
            "Información sobre sistema operativo --> $NombreEquipo",
            "",
            "==================================================",
            ""
        )
        
        $maxWidth = ($soItems | Measure-Object -Property Length -Maximum).Maximum
        $leftPadding = [math]::Max(0, [math]::Floor(($consoleWidth - $maxWidth) / 2)) + 4
        
        Clear-Host
        Mostrar-BannerInf
        
        foreach ($item in $soItems) {
            if ($item -match "^={3,}") {
                Escribir-Centrado $item
            } elseif ($item -match "Información sobre sistema operativo -->") {
                Escribir-Centrado $item -ColorDeFondo Amarillo
            } else {
                $centeredLine = (" " * $leftPadding) + $item
                Write-Host $centeredLine -ForegroundColor Cyan
            }
        }
        
        $os = Get-CimInstance Win32_OperatingSystem
        $output = @(
            "Nombre: $($os.Caption)",
            "Versión: $($os.Version)",
            "Arquitectura: $($os.OSArchitecture)"
        )

        $activationStatus = Get-CimInstance -ClassName SoftwareLicensingProduct -Filter "Name like 'Windows%'" | Where-Object { $_.PartialProductKey } | Select-Object -First 1
        if ($activationStatus) {
            switch ($activationStatus.LicenseStatus) {
                0 { $status = "Sin licencia :(" }
                1 { $status = "Con licencia :)" }
                2 { $status = "Período de gracia Out-Of-Box" }
                3 { $status = "Período de gracia Out-Of-Tolerance" }
                4 { $status = "Período de gracia no genuino" }
                5 { $status = "Notificación" }
                6 { $status = "Período de gracia extendida" }
                default { $status = "Estado desconocido" }
            }
        } else {
            $status = "No disponible"
        }
        $output += "Activación: $status"
        
        foreach ($line in $output) {
            Write-Host "`n" -ForegroundColor Cyan
            Write-Host (" " * $leftPadding) + $line -ForegroundColor Cyan
            Write-Host (" " * $leftPadding) + "--------------------------" -ForegroundColor Cyan
        }
        
        $host.UI.RawUI.ForegroundColor = "White"
    }
    
    Dibujar-InfoSO
}

function Consultar-EstadoServicios {
    param(
        [Parameter(Mandatory=$false)]
        [string]$NombreEquipo = $env:COMPUTERNAME,
        [int]$DesplazarHorizontalmente = 0
    )

    function Dibujar-EstadoServicios {
        $consoleWidth = $Host.UI.RawUI.WindowSize.Width
        
        Clear-Host
        Mostrar-BannerInf
        
        $serviceNames = @(  # Lista de servicios a comprobar
            'CryptSvc', 'Dhcp', 'DcomLaunch', 'Dnscache', 'EventLog', 'LanmanServer',
            'LanmanWorkstation', 'mpssvc', 'OCS Inventory', 'PandaAetherAgent',
            'PlugPlay', 'Power', 'RpcSs', 'Schedule', 'Themes', 'W32Time',
            'WinDefend', 'WSearch', 'wuauserv', 'ClickToRunSvc'
        )
        $serviceNames = $serviceNames | Sort-Object
        
        $totalColumns = 30  # Reducimos el ancho total de las columnas
        $centeringPadding = [math]::Floor(($consoleWidth - $totalColumns) / 2)

        foreach ($serviceName in $serviceNames) {
            $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
            
            # Manejar el caso de servicios ausentes
            if (-not $service) {
                $statusColor = "Yellow"
                $statusIcon = "Ausente"
            } else {
                # Color del servicio
                $statusColor = switch ($service.Status) {
                    "Running" { "Green" }
                    "Stopped" { "Red" }
                    default { "Yellow" }
                }
                
                # Icono del estado
                $statusIcon = switch ($service.Status) {
                    "Running" { "En ejecución" }
                    "Stopped" { "Detenido" }
                    default { "$($service.Status)" }
                }
            }
            
# Extraer los datos para cada columna
$displayName = $service.DisplayName
$shortName = $serviceName
$status = $statusIcon

# Si no existe el nombre largo, usar el nombre corto para ambos
if ([string]::IsNullOrWhiteSpace($displayName)) {
    $displayName = $shortName
}

# Formato de las líneas con anchos fijos
$displayNameLine = "{0,-40}" -f $displayName  # 40 caracteres para el nombre completo
$shortNameLine = "{0,-25}" -f $shortName  # 25 caracteres para el nombre corto
$statusLine = "{0,-15}" -f $status  # 15 caracteres para el estado

# Aplicar el desplazamiento horizontal
$shiftAmount = [math]::Round($DesplazarHorizontalmente * 10 / 100)
$displayNameShifted = $displayNameLine.Substring($shiftAmount, $displayNameLine.Length - $shiftAmount)
$shortNameShifted = $shortNameLine.Substring($shiftAmount, $shortNameLine.Length - $shiftAmount)
$statusShifted = $statusLine.Substring($shiftAmount, $statusLine.Length - $shiftAmount)

# Construir la línea completa con colores y centrar cada elemento
$centeredDisplayName = " {0} " -f $displayNameShifted.PadRight((($consoleWidth - 120) / 3) - $shiftAmount)
$centeredShortName = " {0} " -f $shortNameShifted.PadLeft((($consoleWidth - 240) / 3) + 15 - $shiftAmount)
$centeredStatus = " {0} " -f $statusShifted.PadLeft((($consoleWidth - 240) / 3) + 20 - $shiftAmount)

# Imprimir la línea con el color correspondiente al estado del servicio
Write-Host "$centeredDisplayName$centeredShortName$centeredStatus" -ForegroundColor $statusColor
        }
    }
    
    Dibujar-EstadoServicios
}

function Consultar-InfoUsuarios {
    param(
        [Parameter(Mandatory=$false)]
        [string]$NombreEquipo = $env:COMPUTERNAME
    )

    function Dibujar-InfoUsuarios {
        $consoleWidth = $Host.UI.RawUI.WindowSize.Width

        $usuariosItems = @(
            "===============================================",
            "",
            "Información sobre usuarios --> $NombreEquipo",
            "",
            "==============================================="
        )

        $maxWidth = ($usuariosItems | Measure-Object -Property Length -Maximum).Maximum
        $leftPadding = [math]::Max(0, [math]::Floor(($consoleWidth - $maxWidth) / 2))

        Clear-Host
        Mostrar-BannerInf

        foreach ($item in $usuariosItems) {
            if ($item -match "^={3,}") {
                Escribir-Centrado $item
            } elseif ($item -match "Información sobre usuarios -->") {
                Escribir-Centrado $item -ColorDeFondo Amarillo
            } else {
                $centeredLine = (" " * $leftPadding) + $item
                Write-Host $centeredLine -ForegroundColor Cyan
            }
        }

        # Obtener información de los usuarios
        $users = Get-LocalUser | Select-Object Name, Enabled, LastLogon, Description

        # Mostrar información de los usuarios
        foreach ($user in $users) {
            Write-Host "`n" -ForegroundColor Cyan
            Write-Host (" " * $leftPadding) + "Nombre: $($user.Name)" -ForegroundColor Cyan
            Write-Host (" " * $leftPadding) + "Habilitado: $($user.Enabled)" -ForegroundColor Cyan
            if ($user.LastLogon) {
                Write-Host (" " * $leftPadding) + "Último inicio de sesión: $($user.LastLogon)" -ForegroundColor Cyan
            } else {
                Write-Host (" " * $leftPadding) + "Último inicio de sesión: No disponible" -ForegroundColor Cyan
            }
            Write-Host (" " * $leftPadding) + "Descripción: $($user.Description)" -ForegroundColor Cyan
        }

        $host.UI.RawUI.ForegroundColor = "White"
    }

    Dibujar-InfoUsuarios
}

function Consultar-Políticas {
    param(
        [Parameter(Mandatory=$false)]
        [string]$NombreEquipo = $env:COMPUTERNAME
    )

    function Dibujar-Politicas {
        $consoleWidth = $Host.UI.RawUI.WindowSize.Width

        $politicasItems = @(
            "===============================================",
            "",
            "Información sobre políticas --> $NombreEquipo",
            "",
            "==============================================="
        )

        $maxWidth = ($politicasItems | Measure-Object -Property Length -Maximum).Maximum
        $leftPadding = [math]::Max(0, [math]::Floor(($consoleWidth - $maxWidth) / 2))

        Clear-Host
        Mostrar-BannerInf

        foreach ($item in $politicasItems) {
            if ($item -match "^={3,}") {
                Escribir-Centrado $item
            } elseif ($item -match "Información sobre políticas -->") {
                Escribir-Centrado $item -ColorDeFondo Amarillo
            } else {
                $centeredLine = (" " * $leftPadding) + $item
                Write-Host $centeredLine -ForegroundColor Cyan
            }
        }

        # Ejecutar gpresult /r y filtrar las líneas no deseadas
        $gpresultOutput = gpresult /r | 
            Select-Object -Skip 9 |  # Omitir las primeras 9 líneas
            Where-Object { $_ -notmatch "Creado el" } |  # Omitir la línea que contiene "Creado el"
            ForEach-Object { $_.Trim() } |  # Eliminar espacios en blanco al inicio y final
            Where-Object { $_ -ne "" } |  # Omitir líneas vacías
            ForEach-Object { "$_" }

        # Mostrar la salida filtrada de gpresult
        foreach ($line in $gpresultOutput) {
            Write-Host "`n" -ForegroundColor Cyan
            Write-Host (" " * ($leftPadding - 12)) + $line -ForegroundColor Cyan
        }

        $host.UI.RawUI.ForegroundColor = "White"
    }

    Dibujar-Politicas
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

function Consultar-InfoSoftware {
    param(
        [switch]$PorFabricante,
        [Parameter(Mandatory=$false)]
        [string]$NombreEquipo = $env:COMPUTERNAME
    )

    function Dibujar-InfoSoftware {
        $consoleWidth = $Host.UI.RawUI.WindowSize.Width

        $softwareItems = @(
            "===================================================",
            "",
            "Información sobre software instalado --> $NombreEquipo",
            "",
            "==================================================="
        )

        $maxWidth = ($softwareItems | Measure-Object -Property Length -Maximum).Maximum
        $leftPadding = [math]::Max(0, [math]::Floor(($consoleWidth - $maxWidth) / 2)) + 4

        Clear-Host
        Mostrar-BannerInf

        foreach ($item in $softwareItems) {
            if ($item -match "^={3,}") {
                Escribir-Centrado $item
            } elseif ($item -match "Información sobre software instalado -->") {
                Escribir-Centrado $item -ColorDeFondo Amarillo
            } else {
                $centeredLine = (" " * $leftPadding) + $item
                Write-Host $centeredLine -ForegroundColor Cyan
            }
        }

        Write-Host ""

        $menuItems = @(
            "  1. Mostrar todo el software instalado",
            "  2. Buscar software específico",
            "  3. Mostrar software instalado en los últimos 30 días",
            "  4. Mostrar software por fabricante",
            "  0. Volver al menú principal info_equipo"
        )

        foreach ($item in $menuItems) {
            $centeredLine = (" " * $leftPadding) + $item
            Write-Host $centeredLine -ForegroundColor White
        }

        Write-Host ""

        $host.UI.RawUI.ForegroundColor = "White"
    }

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
        $softwareOrdenado = Get-WmiObject -Class Win32_Product -ComputerName $NombreEquipo | Select-Object Name, Version, Vendor, InstallDate | Sort-Object Name

        do {
            Dibujar-InfoSoftware

            $consoleWidth = $Host.UI.RawUI.WindowSize.Width
            $menuItems = @(
                "  1. Mostrar todo el software instalado",
                "  2. Buscar software específico",
                "  3. Mostrar software instalado en los últimos 30 días",
                "  4. Mostrar software por fabricante",
                "  0. Volver al menú principal info_equipo"
            )

            $cleanedMenuItems = $menuItems | ForEach-Object { $_.TrimStart() }
            $maxWidth = ($cleanedMenuItems | Measure-Object -Property Length -Maximum).Maximum
            $leftPadding = [math]::Max(0, [math]::Floor(($consoleWidth - $maxWidth) / 2))

            $prompt = (" " * $leftPadding) + "      Seleccione una opción (0-4)"
            $opcion = Read-Host $prompt

            $output = @()

            switch ($opcion) {
                "1" {
                    $output += "  Software instalado:"
                    foreach ($prog in $softwareOrdenado) {
                        $output += "  Nombre: $($prog.Name)"
                        $output += "  Versión: $($prog.Version)"
                        $output += "  Fabricante: $($prog.Vendor)"
                        if ($prog.InstallDate) {
                            $fecha = [DateTime]::ParseExact($prog.InstallDate, "yyyyMMdd", $null)
                            $output += "  Fecha de instalación: $(Get-Date -Format 'dd/MM/yyyy' -Date $fecha)"
                        } else {
                            $output += "  Fecha de instalación: No disponible"
                        }
                        $output += "  ---------------------------"
                    }
                }
                "2" {
                    $busqueda = Read-Host "  Introduzca el nombre del software a buscar"
                    $resultados = $softwareOrdenado | Where-Object { $_.Name -like "*$busqueda*" }
                    if ($resultados) {
                        $output += "  Resultados de la búsqueda para '$busqueda':"
                        foreach ($prog in $resultados) {
                            $output += "  Nombre: $($prog.Name)"
                            $output += "  Versión: $($prog.Version)"
                            $output += "  Fabricante: $($prog.Vendor)"
                            if ($prog.InstallDate) {
                                $fecha = [DateTime]::ParseExact($prog.InstallDate, "yyyyMMdd", $null)
                                $output += "  Fecha de instalación: $(Get-Date -Format 'dd/MM/yyyy' -Date $fecha)"
                            } else {
                                $output += "  Fecha de instalación: No disponible"
                            }
                            $output += "  ---------------------------"
                        }
                    } else {
                        $output += "  No se encontraron resultados para '$busqueda'."
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
                    $output += "  Software instalado en los últimos 30 días o sin fecha de instalación:"
                    foreach ($prog in $softwareReciente) {
                        $output += "  Nombre: $($prog.Name)"
                        $output += "  Versión: $($prog.Version)"
                        $output += "  Fabricante: $($prog.Vendor)"
                        if ($prog.InstallDate) {
                            $fecha = [DateTime]::ParseExact($prog.InstallDate, "yyyyMMdd", $null)
                            $output += "  Fecha de instalación: $(Get-Date -Format 'dd/MM/yyyy' -Date $fecha)"
                        } else {
                            $output += "  Fecha de instalación: No disponible"
                        }
                        $output += "  ---------------------------"
                    }
                }
                "4" {
                    $fabricantes = $softwareOrdenado | Group-Object -Property Vendor
                    $output += "  Software por fabricante:"
                    foreach ($fabricante in $fabricantes) {
                        $output += "  Fabricante: $($fabricante.Name)"
                        $output += "  Número de programas: $($fabricante.Count)"
                        $output += "  Programas:"
                        foreach ($prog in $fabricante.Group) {
                            $output += "    - $($prog.Name) (Versión: $($prog.Version))"
                            if ($prog.InstallDate) {
                                $fecha = [DateTime]::ParseExact($prog.InstallDate, "yyyyMMdd", $null)
                                $output += "    Fecha de instalación: $(Get-Date -Format 'dd/MM/yyyy' -Date $fecha)"
                            } else {
                                $output += "    Fecha de instalación: No disponible"
                            }
                        }
                        $output += "  ---------------------------"
                    }
                }
                "0" {
                    return # Volver al menú principal sin pausa
                }
                default {
                    $output += "  Opción incorrecta, por favor seleccione una opción válida."
                }
            }

            if ($output.Count -gt 0) {
                Write-Host ""
                $maxWidth = ($output | Measure-Object -Property Length -Maximum).Maximum
                $leftPadding = [math]::Max(0, [math]::Floor(($consoleWidth - $maxWidth) / 2))
                foreach ($line in $output) {
                    $centeredLine = (" " * $leftPadding) + $line
                    Write-Host $centeredLine -ForegroundColor Cyan
                }
            }

            if ($opcion -ne "0") { 
                Write-Host
                $centeredPrompt = (" " * $leftPadding) + "Presione cualquier tecla para continuar..."
                Write-Host $centeredPrompt -NoNewline
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

    function Obtener-ProgramasInicio {
        $programasInicio = @()

        # Carpeta de inicio del usuario actual
        $carpetaInicio = [System.Environment]::GetFolderPath('Startup')
        $programasInicio += Get-ChildItem -Path $carpetaInicio | ForEach-Object {
            [PSCustomObject]@{
                Nombre = $_.Name
                Ruta = $_.FullName
                Tipo = "Carpeta de inicio del usuario"
                Estado = if (Test-Path $_.FullName) { "Habilitado" } else { "Deshabilitado" }
                Descripcion = (Get-ItemProperty $_.FullName -ErrorAction SilentlyContinue).VersionInfo.FileDescription
                Version = (Get-ItemProperty $_.FullName -ErrorAction SilentlyContinue).VersionInfo.FileVersion
                Empresa = (Get-ItemProperty $_.FullName -ErrorAction SilentlyContinue).VersionInfo.CompanyName
                FechaModificacion = $_.LastWriteTime
            }
        }

        # Carpeta de inicio común para todos los usuarios
        $carpetaInicioComun = [System.Environment]::GetFolderPath('CommonStartup')
        $programasInicio += Get-ChildItem -Path $carpetaInicioComun | ForEach-Object {
            [PSCustomObject]@{
                Nombre = $_.Name
                Ruta = $_.FullName
                Tipo = "Carpeta de inicio común"
                Estado = if (Test-Path $_.FullName) { "Habilitado" } else { "Deshabilitado" }
                Descripcion = (Get-ItemProperty $_.FullName -ErrorAction SilentlyContinue).VersionInfo.FileDescription
                Version = (Get-ItemProperty $_.FullName -ErrorAction SilentlyContinue).VersionInfo.FileVersion
                Empresa = (Get-ItemProperty $_.FullName -ErrorAction SilentlyContinue).VersionInfo.CompanyName
                FechaModificacion = $_.LastWriteTime
            }
        }

        # Registro del usuario actual (HKCU)
        $registroInicio = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -ErrorAction SilentlyContinue
        if ($registroInicio) {
            $programasInicio += $registroInicio.PSObject.Properties | Where-Object { $_.Name -notlike "PS*" } | ForEach-Object {
                $ruta = $_.Value
                [PSCustomObject]@{
                    Nombre = $_.Name
                    Ruta = $ruta
                    Tipo = "Registro del usuario (HKCU)"
                    Estado = if ($ruta -and (Test-Path $ruta)) { "Habilitado" } else { "Deshabilitado" }
                    Descripcion = if ($ruta) { (Get-ItemProperty $ruta -ErrorAction SilentlyContinue).VersionInfo.FileDescription } else { "N/A" }
                    Version = if ($ruta) { (Get-ItemProperty $ruta -ErrorAction SilentlyContinue).VersionInfo.FileVersion } else { "N/A" }
                    Empresa = if ($ruta) { (Get-ItemProperty $ruta -ErrorAction SilentlyContinue).VersionInfo.CompanyName } else { "N/A" }
                    FechaModificacion = if ($ruta) { (Get-Item $ruta -ErrorAction SilentlyContinue).LastWriteTime } else { "N/A" }
                }
            }
        }

        # Registro de la máquina (HKLM)
        $registroInicioMaquina = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -ErrorAction SilentlyContinue
        if ($registroInicioMaquina) {
            $programasInicio += $registroInicioMaquina.PSObject.Properties | Where-Object { $_.Name -notlike "PS*" } | ForEach-Object {
                $ruta = $_.Value
                [PSCustomObject]@{
                    Nombre = $_.Name
                    Ruta = $ruta
                    Tipo = "Registro de la máquina (HKLM)"
                    Estado = if ($ruta -and (Test-Path $ruta)) { "Habilitado" } else { "Deshabilitado" }
                    Descripcion = if ($ruta) { (Get-ItemProperty $ruta -ErrorAction SilentlyContinue).VersionInfo.FileDescription } else { "N/A" }
                    Version = if ($ruta) { (Get-ItemProperty $ruta -ErrorAction SilentlyContinue).VersionInfo.FileVersion } else { "N/A" }
                    Empresa = if ($ruta) { (Get-ItemProperty $ruta -ErrorAction SilentlyContinue).VersionInfo.CompanyName } else { "N/A" }
                    FechaModificacion = if ($ruta) { (Get-Item $ruta -ErrorAction SilentlyContinue).LastWriteTime } else { "N/A" }
                }
            }
        }

        return $programasInicio
    }

    function Dibujar-InfoArranque {
        $consoleWidth = $Host.UI.RawUI.WindowSize.Width
        
        Clear-Host
        Mostrar-BannerInf
        
        Escribir-Centrado "========================================================"
        Escribir-Centrado ""
        Escribir-Centrado "Información sobre el arranque del sistema --> $NombreEquipo" -ColorDeFondo Amarillo
        Escribir-Centrado ""
        Escribir-Centrado "========================================================"
        Escribir-Centrado ""
        Escribir-Centrado "Programas con inicio automático:"
        Escribir-Centrado ""
        
        $programasInicio = Obtener-ProgramasInicio
        $leftPadding = [math]::Max(0, [math]::Floor(($consoleWidth - 80) / 2))

        foreach ($programa in $programasInicio) {
            Write-Host (" " * $leftPadding) $programa.Nombre -ForegroundColor Cyan
            Write-Host (" " * $leftPadding) "  Ruta: $($programa.Ruta)" -ForegroundColor White
            Write-Host (" " * $leftPadding) "  Estado: $($programa.Estado)" -ForegroundColor White
            Write-Host (" " * $leftPadding) "  Versión: $($programa.Version)" -ForegroundColor White
            Write-Host (" " * $leftPadding) "  Empresa: $($programa.Empresa)" -ForegroundColor White
            Write-Host (" " * $leftPadding) "  Fecha de modificación: $($programa.FechaModificacion)" -ForegroundColor White
            Write-Host ""
        }
        
#        Escribir-Centrado "========================================================"
 
    }

    Dibujar-InfoArranque
}

function Consultar-Energia {
    param(
        [Parameter(Mandatory=$false)]
        [string]$NombreEquipo = $env:COMPUTERNAME
    )

    function Dibujar-InfoEnergia {
        $consoleWidth = $Host.UI.RawUI.WindowSize.Width
        
        # Obtener información de energía
        $planesEnergia = powercfg /list
        $planActivo = powercfg /getactivescheme
        $suspensionActiva = (powercfg /query SCHEME_CURRENT SUB_SLEEP STANDBYIDLE | Select-String "0x00000000") -eq $null

        $energiaItems = @(
            "===============================================",
            "",
            "Información de energía --> $NombreEquipo",
            "",
            "===============================================",
            "",
            "Planes de energía disponibles:"
#            ""
<#             "Combinaciones de energía existentes (* activas)",
            "------------------------------------------------" #>
        )

        # Agregar cada plan de energía a la lista
        foreach ($plan in $planesEnergia) {
            $energiaItems += "  $($plan.Trim())"
        }

        $energiaItems += @(
            "",
            "Plan activo:",
			"",
            "  $($planActivo.Trim())",
            "",
            "Estado de suspensión: $($suspensionActiva ? 'Activada' : 'Desactivada')",
            ""
            "==============================================="
        )
        
        $maxWidth = ($energiaItems | Measure-Object -Property Length -Maximum).Maximum
        $leftPadding = [math]::Max(0, [math]::Floor(($consoleWidth - $maxWidth) / 2)) + 0
        
        Clear-Host
        Mostrar-BannerInf
        
        foreach ($item in $energiaItems) {
            if ($item -match "^={3,}") {
                Escribir-Centrado $item
            } elseif ($item -match "Información de energía -->") {
                Escribir-Centrado $item -ColorDeFondo Amarillo
            } elseif ($item -match "^Planes de energía disponibles:|^Plan activo:|^Estado de suspensión:") {
                $centeredLine = (" " * $leftPadding) + $item
                Write-Host $centeredLine -ForegroundColor White
            } elseif ($item -match "Combinaciones de energía existentes|^-{10,}") {
                $centeredLine = (" " * $leftPadding) + $item
                Write-Host $centeredLine -ForegroundColor Cyan
            } elseif ($item -match "GUID del plan de energía:") {
                $centeredLine = (" " * $leftPadding) + $item
                Write-Host $centeredLine -ForegroundColor Cyan
            } else {
                $centeredLine = (" " * $leftPadding) + $item
                Write-Host $centeredLine -ForegroundColor Cyan
            }
        }
    }
    
    Dibujar-InfoEnergia
}

function Consultar-Seguridad {
    param(
        [Parameter(Mandatory=$false)]
        [string]$NombreEquipo = $env:COMPUTERNAME
    )

    function Dibujar-InfoSeguridad {
        $consoleWidth = $Host.UI.RawUI.WindowSize.Width
        
        # Obtener información de seguridad
        $firewallStatus = Get-NetFirewallProfile | Select-Object Name, Enabled
        $antivirusStatus = Get-MpComputerStatus
        $updateSession = New-Object -ComObject Microsoft.Update.Session
        $updateSearcher = $updateSession.CreateUpdateSearcher()
        $pendingUpdates = $updateSearcher.Search("IsInstalled=0 and Type='Software'")

        $seguridadItems = @(
            "===============================================",
            "",
            "Información sobre seguridad --> $NombreEquipo",
            "",
            "===============================================",
            "",
            "Estado del Firewall de Windows:"
        )

        foreach ($profile in $firewallStatus) {
            $status = if($profile.Enabled){'Activado'}else{'Desactivado'}
            $seguridadItems += "  - $($profile.Name): |$status|"
        }

        $seguridadItems += @(
            "",
            "Estado del Antivirus (Windows Defender):",
            "  - Protección en tiempo real: |$(if($antivirusStatus.RealTimeProtectionEnabled){'Activada'}else{'Desactivada'})|",
            "  - Última actualización de definiciones: |$($antivirusStatus.AntivirusSignatureLastUpdated)|",
            "",
            "Actualizaciones pendientes: |$($pendingUpdates.Updates.Count)|",
            ""
        )

        $maxWidth = ($seguridadItems | Measure-Object -Property Length -Maximum).Maximum
        $leftPadding = [math]::Max(0, [math]::Floor(($consoleWidth - $maxWidth) / 2)) + 0
        
        Clear-Host
        Mostrar-BannerInf
        
        foreach ($item in $seguridadItems) {
            if ($item -match "^={3,}") {
                Escribir-Centrado $item
            } elseif ($item -match "Información sobre seguridad -->") {
                Escribir-Centrado $item -ColorDeFondo Amarillo
            } else {
                $centeredLine = (" " * $leftPadding) + $item
                if ($item -match "\|(.+?)\|") {
                    $parts = $item -split '\|'
                    Write-Host ($centeredLine -replace '\|.+?\|', '') -ForegroundColor White -NoNewline
                    Write-Host $matches[1] -ForegroundColor Cyan -NoNewline
                    Write-Host ($centeredLine -replace '^.*\|.+?\|', '') -ForegroundColor White
                } else {
                    Write-Host $centeredLine -ForegroundColor White
                }
            }
        }

        Escribir-Centrado "==============================================="
    }
    
    Dibujar-InfoSeguridad
}

function Exportar-InfoSistema {
    param(
        [Parameter(Mandatory=$false)]
        [string]$NombreEquipo = $env:COMPUTERNAME
    )

    function Dibujar-Exportacion {
        $consoleWidth = $Host.UI.RawUI.WindowSize.Width
        $fecha = Get-Date -Format "yyyyMMdd"

        Clear-Host
        Mostrar-BannerInf

        $exportacionItems = @(
            "===============================================================",
            "",
            "Exportar información de $NombreEquipo -->",
            "",
            "==============================================================="
        )

        $maxWidth = ($exportacionItems | Measure-Object -Property Length -Maximum).Maximum
        $leftPadding = [math]::Max(0, [math]::Floor(($consoleWidth - $maxWidth) / 2))

        foreach ($item in $exportacionItems) {
            if ($item -match "^={3,}") {
                Escribir-Centrado $item
            } elseif ($item -match "Exportar información de $NombreEquipo -->") {
                Escribir-Centrado $item -ColorDeFondo Amarillo
            } else {
                $centeredLine = (" " * $leftPadding) + $item
                Write-Host $centeredLine -ForegroundColor Cyan
            }
        }
        Write-Host "`n" -ForegroundColor Cyan
        Write-Host (" " * $leftPadding) + "Ruta para guardar el informe HTML:" -ForegroundColor Cyan
        Write-Host (" " * $leftPadding) + "  [Presione Enter para usar el escritorio]" -ForegroundColor Cyan

        $outputPath = Read-Host (" " * $leftPadding) + "Ruta: "
        if ([string]::IsNullOrWhiteSpace($outputPath)) {
            $outputPath = [Environment]::GetFolderPath("Desktop")
        }

        Write-Host "`n" -ForegroundColor Cyan
        Write-Host (" " * $leftPadding) + "Nombre del archivo (sin extensión):" -ForegroundColor Cyan
        Write-Host (" " * $leftPadding) + "  [Presione Enter para usar el nombre por defecto: inf0_$fecha`_$NombreEquipo]" -ForegroundColor Cyan

        $outputFile = Read-Host (" " * $leftPadding) + "Nombre: "
        if ([string]::IsNullOrWhiteSpace($outputFile)) {
            $outputFile = "inf0_$fecha`_$NombreEquipo"
        }
        if (-not ($outputFile.EndsWith('.html', [StringComparison]::OrdinalIgnoreCase))) {
            $outputFile += '.html'
        }

        $fullPath = Join-Path -Path $outputPath -ChildPath $outputFile

        Write-Host "`n" -ForegroundColor Cyan
        Write-Host (" " * $leftPadding) + "Ruta:" -ForegroundColor Cyan
        Write-Host (" " * $leftPadding) + $fullPath -ForegroundColor Cyan

        Write-Host "`n" -ForegroundColor Cyan
        Write-Host (" " * $leftPadding) + "¿Desea continuar con la exportación? (S/N)" -ForegroundColor Cyan
        $confirmacion = Read-Host (" " * $leftPadding) + "Respuesta: "

        if ($confirmacion -eq 'S' -or $confirmacion -eq 's' -or [string]::IsNullOrWhiteSpace($confirmacion)) {
            return $fullPath
        } else {
            return $null
        }
    }
    function Format-Content {
        param ([string]$content)
        
        $lines = $content -split "`r?`n" | ForEach-Object { $_.Trim() }
        $formattedContent = ($lines | Where-Object { $_ -match '\S' }) -join "<br>"
        
        return $formattedContent
    }

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
            color: #87CEFA;
            background-color: #000000;
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
            background-color: #1A1A1A;
            color: #FFFFFF;
            padding: 10px; 
            border-radius: 5px; 
            white-space: pre-wrap; 
            word-wrap: break-word; 
            position: relative;
            margin-bottom: 20px;
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
    
        text = text.trim().replace(/(\n\s*){2,}/g, '\n');

        navigator.clipboard.writeText(text).then(function() {
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
<p class='date-time'>$(Get-Date -Format "dd 'de' MMMM 'de' yyyy")</p>
<p class='date-time'>$(Get-Date -Format "HH:mm")</p>
"@

        $sectionId = 0
        foreach ($seccion in $infoSecciones) {
            $sectionId++
            $contenidoFormateado = Format-Content $seccion.Contenido
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
        # Recopilar información del sistema
    function Recopilar-InformacionSistema {
        $infoSecciones = @(
            @{Titulo="Resumen del sistema"; Contenido=(Consultar-ResumenSistema)}
            @{Titulo="Placa base"; Contenido=(Consultar-InfoPlacaBase)}
            @{Titulo="CPU"; Contenido=(Consultar-InfoCPU)}
            @{Titulo="Memoria RAM"; Contenido=(Consultar-InfoMemoria)}
            @{Titulo="Discos"; Contenido=(Consultar-InfoDiscos)}
            @{Titulo="Adaptadores de red"; Contenido=(Consultar-InfoRed)}
            @{Titulo="GPU"; Contenido=(Consultar-InfoGPU)}
            @{Titulo="Dispositivos USB registrados en el sistema"; Contenido=(Consultar-InfoUSB)}
            @{Titulo="Baterías"; Contenido=(Consultar-InfoBateria)}
            @{Titulo="Actualizaciones"; Contenido=(Consultar-Actualizaciones)}
            @{Titulo="Sistema operativo"; Contenido=(Consultar-InfoSO)}
            @{Titulo="Usuarios"; Contenido=(Consultar-InfoUsuarios)}
            @{Titulo="Políticas y grupos"; Contenido=(Consultar-Políticas)}
            @{Titulo="Arranque"; Contenido=(Consultar-Arranque)}
            @{Titulo="Energía"; Contenido=(Consultar-Energia)}
            @{Titulo="Seguridad"; Contenido=(Consultar-Seguridad)}
            @{Titulo="Software instalado ordenado por fabricante"; Contenido=(Consultar-InfoSoftware -PorFabricante)}
        )
        return $infoSecciones
    }
	# Inicia el proceso de exportación
    $fullPath = Dibujar-Exportacion

    if ($fullPath -eq $null) {
        Write-Host "`n"
        Escribir-Centrado "Exportación cancelada por el usuario." -ColorDeFondo "Amarillo"
        return
    }

    try {
        Write-Host "`n"
        Escribir-Centrado "Recopilando información del sistema..." -ColorDeFondo "Amarillo"
        $infoSecciones = Recopilar-InformacionSistema
        
        Escribir-Centrado "Generando informe HTML..." -ColorDeFondo "Amarillo"
        $htmlContent = Get-HTMLContent
        $htmlContent | Out-File -FilePath $fullPath -Encoding UTF8
        
        Write-Host "`n"
        Escribir-Centrado "Exportación completada con éxito." -ColorDeFondo "Verde"
        Escribir-Centrado "Archivo guardado en:" -ColorDeFondo "Verde"
        Escribir-Centrado $fullPath -ColorDeFondo "Verde"
    }
    catch {
        Write-Host "`n"
        Escribir-Centrado "Error al exportar la información: $_" -ColorDeFondo "Rojo"
    }

    Write-Host "`n"
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
            '16' { Consultar-InfoSoftware -NombreEquipo $NombreEquipo }
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
