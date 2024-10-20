# Importar los scripts originales
. .\Bitlocker.ps1
. .\Info_Equipo.ps1
. .\ToolKit.ps1

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
		$consoleWidth = $Host.UI.RawUI.WindowSize.Width

		$menuItems = @(
				
			"======================================",
			"",
			"Menú principal - Script_Zer0",
			"",
			"======================================",
			"",
			" 1. BitLocker",
			" 2. Info_equip0",
			" 3. ToolKit",
			" 0. Salir",
			"",
			"======================================"
		)
	
        $maxWidth = ($menuItems | Measure-Object -Property Length -Maximum).Maximum
        $leftPadding = [math]::Max(0, [math]::Floor(($consoleWidth - $maxWidth) / 2))

        Clear-Host
        $host.UI.RawUI.BackgroundColor = "Black"
        Mostrar-BannerBit

        foreach ($item in $menuItems) {
            $centeredLine = (" " * $leftPadding) + $item
            if ($item -match "Información de BitLocker en") {
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



function MenuZer0 {
    do {
        Mostrar-MenuPrincipal
        $choice = Read-Host "						  Seleccione una opción"
        
        switch ($choice) {
            "1" { Menu-Bitlocker }
            "2" { Menu-InfoEquipo }
            "3" { Menu-ToolKit }
            "0" { 
                Write-Host "Saliendo de script_Zer0..."
                return 
            }
            default { Write-Host "						  Opción incorrecta." }
        }
    } while ($true)
}

# Ejecutar la función principal
MenuZer0