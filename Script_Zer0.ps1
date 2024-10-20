<# # Importar los scripts originales
. .\Bitlocker.ps1
. .\Inf0_Equipo.ps1
. .\ToolKit.ps1 #>

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

    $ColorDeFondo = $colores[$ColorDeFondo] ?? $ColorDeFondo
    $ColorDeFondoFondo = $colores[$ColorDeFondoFondo] ?? $ColorDeFondoFondo

    $anchoConsola = $Host.UI.RawUI.WindowSize.Width
    $longitudTexto = $Texto.Length
    $rellenoIzquierdo = [math]::Max(0, [math]::Floor(($anchoConsola - $longitudTexto) / 2)) + $Desplazamiento
    $lineaCentrada = (" " * $rellenoIzquierdo) + $Texto

    if ($NoNewline) {
        Write-Host $lineaCentrada -ForegroundColor $ColorDeFondo -BackgroundColor $ColorDeFondoFondo -NoNewline
    } else {
        Write-Host $lineaCentrada -ForegroundColor $ColorDeFondo -BackgroundColor $ColorDeFondoFondo
    }
}

function Mostrar-BannerScr {
    param (
        [switch]$Continuo
    )

    function Dibujar-Banner {
        $consoleWidth = $Host.UI.RawUI.WindowSize.Width

        # Banner ASCII
        $banner = @(
"███████╗ ██████╗██████╗ ██╗██████╗ ████████╗    ███████╗███████╗██████╗  ██████╗"
"██╔════╝██╔════╝██╔══██╗██║██╔══██╗╚══██╔══╝    ╚══███╔╝██╔════╝██╔══██╗██╔═████╗"
"███████╗██║     ██████╔╝██║██████╔╝   ██║         ███╔╝ █████╗  ██████╔╝██║██╔██║"
"╚════██║██║     ██╔══██╗██║██╔═══╝    ██║        ███╔╝  ██╔══╝  ██╔══██╗████╔╝██║"
"███████║╚██████╗██║  ██║██║██║        ██║       ███████╗███████╗██║  ██║╚██████╔╝"
"╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝        ╚═╝       ╚══════╝╚══════╝╚═╝  ╚═╝ ╚═════╝"
        )

        $maxWidth = ($banner | Measure-Object -Property Length -Maximum).Maximum
        $leftPadding = [math]::Max(0, [math]::Floor(($consoleWidth - $maxWidth) / 2))

        Clear-Host
        Write-Host ""
		Write-Host ""
		Write-Host ""
        $colors = @('DarkYellow', 'DarkYellow', 'Yellow', 'Yellow', 'White', 'White')

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

function Mostrar-MenuPrincipal {
    param(
        [Parameter(Mandatory=$false)]
        [string]$NombreEquipo = $env:COMPUTERNAME,
        [switch]$Continuo
    )

    function Dibujar-Menu {
        Clear-Host
        $host.UI.RawUI.BackgroundColor = "Black"
        Mostrar-BannerScr

        Escribir-Centrado "=============================="
        Escribir-Centrado ""
        Escribir-Centrado "Menú principal - Script_Zer0"
        Escribir-Centrado ""
        Escribir-Centrado "=============================="
        Escribir-Centrado ""
        Escribir-Centrado "1. BitLocker"
        Escribir-Centrado "2. Inf0_Equipo"
        Escribir-Centrado "3. ToolKit"
        Escribir-Centrado "0. Salir"
        Escribir-Centrado ""
        Escribir-Centrado "=============================="

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

function MenuZer0 {
    do {
        Mostrar-MenuPrincipal
        Escribir-Centrado "Seleccione una opción: " -NoNewline
        $choice = Read-Host
        
        switch ($choice) {
            "1" { $scriptName = "Bitlocker" }
            "2" { $scriptName = "InfoEquipo" }
            "3" { $scriptName = "ToolKit" }
            "0" { 
                Escribir-Centrado ""
				Escribir-Centrado "Saliendo de script_Zer0..." -ColorDeFondo "Verde"
                return 
            }
            default { 
                Escribir-Centrado "Opción incorrecta." -ColorDeFondo "Red"
                continue
            }
        }

        if ($choice -ne "0") {
            $rutaScript = Join-Path $PSScriptRoot "$scriptName.ps1"
            if (Test-Path $rutaScript) {
                . $rutaScript
                $nombreFuncion = "Menu-$scriptName"
                if (Get-Command $nombreFuncion -ErrorAction SilentlyContinue) {
                    & $nombreFuncion
                } else {
                    Escribir-Centrado "No se encontró la función $nombreFuncion en el script $scriptName.ps1" -ColorDeFondo "Red"
                }
            } else {
                Escribir-Centrado "No se encontró el script $rutaScript" -ColorDeFondo "Red"
            }
            Escribir-Centrado ""
			Escribir-Centrado "Presione Enter para volver al menú principal" -ColorDeFondo "Verde" -NoNewline
            Read-Host
        }
    } while ($true)
}

# Ejecutar la función principal
MenuZer0