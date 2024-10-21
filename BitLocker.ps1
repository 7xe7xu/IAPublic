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

function Mostrar-BannerBit {
    param (
        [switch]$Continuo
    )

    function Dibujar-Banner {
        $consoleWidth = $Host.UI.RawUI.WindowSize.Width

        # Banner ASCII
        $banner = @(
            "██████╗ ██╗████████╗██╗      ██████╗  ██████╗██╗  ██╗███████╗██████╗ "
            "██╔══██╗██║╚══██╔══╝██║     ██╔═══██╗██╔════╝██║ ██╔╝██╔════╝██╔══██╗"
            "██████╔╝██║   ██║   ██║     ██║   ██║██║     █████╔╝ █████╗  ██████╔╝"
            "██╔══██╗██║   ██║   ██║     ██║   ██║██║     ██╔═██╗ ██╔══╝  ██╔══██╗"
            "██████╔╝██║   ██║   ███████╗╚██████╔╝╚██████╗██║  ██╗███████╗██║  ██║"
            "╚═════╝ ╚═╝   ╚═╝   ╚══════╝ ╚═════╝  ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝"
        )

        $maxWidth = ($banner | Measure-Object -Property Length -Maximum).Maximum
        $leftPadding = [math]::Max(0, [math]::Floor(($consoleWidth - $maxWidth) / 2))

        Clear-Host
        Write-Host ""
		Write-Host ""
		Write-Host ""
        $colors = @('DarkRed', 'DarkRed', 'Red', 'Red', 'Red', 'White')

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

function Show-Menu {
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
            "Información de BitLocker en $NombreEquipo",
            "",
            "======================================",
			"",
            " 1. Ver estado de Bitlocker",
            " 2. Agregar protectores Bitlocker",
            " 3. Eliminar protectores Bitlocker",
            " 4. Activar Bitlocker",
            " 5. Desactivar Bitlocker",
            " 6. Reanudar cifrado/descifrado",
            " 7. Ver clave de Bitlocker",
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

function Bitlocker-Status {
    Escribir-Centrado ""
    Escribir-Centrado "Nombre del equipo [este]: " -NoNewline
    $equipo = Read-Host
		if ([string]::IsNullOrWhiteSpace($equipo)) {
		$equipo = $env:COMPUTERNAME
	}
    Escribir-Centrado "Ver métodos de protección de las unidades (C:,D:,E:...) [C:]: " -NoNewline
    $unidades = Read-Host
		if ([string]::IsNullOrWhiteSpace($unidades)) {
			$unidades = "C:"
		}
    Escribir-Centrado ""
    Mostrar-BannerBit
    Escribir-Centrado "===============================================" -ColorDeFondo "Red"
    Escribir-Centrado "Estado de BitLocker" -ColorDeFondo "Red"
    Escribir-Centrado "===============================================" -ColorDeFondo "Red"
    Escribir-Centrado ""

    # Si no se especifican unidades, usar C: por defecto
    if ([string]::IsNullOrWhiteSpace($unidades)) {
        $unidadesArray = @("C:")
    } else {
        # Dividir las unidades ingresadas en un array
        $unidadesArray = $unidades -split ',' | ForEach-Object { $_.Trim().ToUpper() }
    }

    foreach ($unidad in $unidadesArray) {
        # Verificar si la unidad tiene el formato correcto
        if ($unidad -notmatch '^[A-Z]:$') {
            Escribir-Centrado "Formato incorrecto para la unidad $unidad. Debe ser una letra seguida de dos puntos (ej. C:)" -ColorDeFondo "Red"
            continue
        }

        Escribir-Centrado "Estado de BitLocker para la unidad $unidad" -ColorDeFondo "Cyan"
        Escribir-Centrado ""
        
        # Capturar la salida del comando manage-bde para cada unidad
        $output = manage-bde -status $unidad -cn $equipo

        # Encontrar la longitud de la línea más larga, omitiendo las dos primeras líneas
        $maxLength = ($output | Select-Object -Skip 2 | Measure-Object -Property Length -Maximum).Maximum

        # Calcular el desplazamiento para centrar el bloque de texto
        $consoleWidth = $Host.UI.RawUI.WindowSize.Width
        $leftPadding = [Math]::Max(2, ($consoleWidth - $maxLength) / 2)

        # Procesar y mostrar cada línea con el espaciado deseado
        $output | ForEach-Object -Begin {$lineCount = 0} {
            if ($lineCount -lt 2) {
                # Las dos primeras líneas se centran normalmente
                Escribir-Centrado $_
            } else {
                # El resto de las líneas se alinean basándose en la línea más larga
                $paddedLine = $_.TrimStart().PadRight($maxLength)
                Write-Host (" " * $leftPadding) $paddedLine
            }
            $lineCount++
        }

        Escribir-Centrado ""
    }
	
	Escribir-Centrado ""
    Escribir-Centrado "Presiona Enter para volver al menú" -NoNewline
    Read-Host
}

function Add-Protectors {
    Escribir-Centrado ""
    Escribir-Centrado "Nombre del equipo [este]: " -NoNewline
    $equipo = Read-Host
		if ([string]::IsNullOrWhiteSpace($equipo)) {
		$equipo = $env:COMPUTERNAME
	}
    Escribir-Centrado "Ver métodos de protección de las unidades (C:,D:,E:...) [C:]: " -NoNewline
    $unidades = Read-Host
		if ([string]::IsNullOrWhiteSpace($unidades)) {
			$unidades = "C:"
		}
    Escribir-Centrado ""
    Mostrar-BannerBit
    Escribir-Centrado "===============================================" -ColorDeFondo "Rojo"
    Escribir-Centrado "Añadir protectores BitLocker" -ColorDeFondo "Rojo"
    Escribir-Centrado "===============================================" -ColorDeFondo "Rojo"
    Escribir-Centrado ""

    # Si no se especifican unidades, usar C: por defecto
    if ([string]::IsNullOrWhiteSpace($unidades)) {
        $unidadesArray = @("C:")
    } else {
        # Dividir las unidades ingresadas en un array
        $unidadesArray = $unidades -split ',' | ForEach-Object { $_.Trim().ToUpper() }
    }

    foreach ($unidad in $unidadesArray) {
        # Validar que la unidad tenga el formato correcto
        if ($unidad -notmatch '^[A-Z]:$') {
            Escribir-Centrado "Formato incorrecto para la unidad $unidad. Debe ser una letra seguida de dos puntos (ej. C:)" -ColorDeFondo "Rojo"
            continue
        }

        Escribir-Centrado "Añadiendo protectores a la unidad $unidad" -ColorDeFondo "Cyan"

        # Capturar la salida del comando manage-bde
        $output = manage-bde -protectors -add -tpm -rp $unidad -cn $equipo

        # Encontrar la longitud de la línea más larga
        $maxLength = ($output | Measure-Object -Property Length -Maximum).Maximum

        # Calcular el desplazamiento para alinear a la izquierda
        $consoleWidth = $Host.UI.RawUI.WindowSize.Width
        $leftPadding = [Math]::Max(0, ($consoleWidth - $maxLength) / 2)

        # Procesar y mostrar cada línea con el espaciado deseado
        $output | ForEach-Object {
            $paddedLine = $_.TrimStart().PadRight($maxLength)
            Write-Host (" " * $leftPadding) $paddedLine
        }

        Escribir-Centrado ""
    }

    Escribir-Centrado ""
    Escribir-Centrado "Presiona Enter para volver al menú" -NoNewline
    Read-Host
}

function Rmv-Protectors {
    Escribir-Centrado ""
    Escribir-Centrado "Nombre del equipo [este]: " -NoNewline
    $equipo = Read-Host
		if ([string]::IsNullOrWhiteSpace($equipo)) {
		$equipo = $env:COMPUTERNAME
	}
    Escribir-Centrado "Ver métodos de protección de las unidades (C:,D:,E:...) [C:]: " -NoNewline
    $unidades = Read-Host
		if ([string]::IsNullOrWhiteSpace($unidades)) {
			$unidades = "C:"
		}
    Escribir-Centrado ""
    Mostrar-BannerBit
    Escribir-Centrado "===============================================" -ColorDeFondo "Rojo"
    Escribir-Centrado "Eliminar protectores BitLocker" -ColorDeFondo "Rojo"
    Escribir-Centrado "===============================================" -ColorDeFondo "Rojo"
    Escribir-Centrado ""

    # Si no se especifican unidades, usar C: por defecto
    if ([string]::IsNullOrWhiteSpace($unidades)) {
        $unidadesArray = @("C:")
    } else {
        # Dividir las unidades ingresadas en un array
        $unidadesArray = $unidades -split ',' | ForEach-Object { $_.Trim().ToUpper() }
    }

    foreach ($unidad in $unidadesArray) {
        # Validar que la unidad tenga el formato correcto
        if ($unidad -notmatch '^[A-Z]:$') {
            Escribir-Centrado "Formato de unidad incorrecto para $unidad. Debe ser una letra seguida de dos puntos (ej. C:)" -ColorDeFondo "Rojo"
            continue
        }

        Escribir-Centrado "Eliminando protectores de la unidad $unidad" -ColorDeFondo "Cyan"
		Escribir-Centrado ""
		
        # Capturar la salida del comando manage-bde
        $output = manage-bde -protectors -delete $unidad -cn $equipo

        # Encontrar la longitud de la línea más larga
        $maxLength = ($output | Measure-Object -Property Length -Maximum).Maximum

        # Calcular el desplazamiento para alinear a la izquierda
        $consoleWidth = $Host.UI.RawUI.WindowSize.Width
        $leftPadding = [Math]::Max(0, ($consoleWidth - $maxLength) / 2)

        # Procesar y mostrar cada línea con el espaciado deseado
        $output | ForEach-Object {
            $paddedLine = $_.TrimStart().PadRight($maxLength)
            Write-Host (" " * $leftPadding) $paddedLine
        }

        Escribir-Centrado ""
    }

	Escribir-Centrado ""
    Escribir-Centrado "Presiona Enter para volver al menú" -NoNewline
    Read-Host
}

function Bitlocker-On {
    Escribir-Centrado ""
    Escribir-Centrado "Nombre del equipo [este]: " -NoNewline
    $equipo = Read-Host
		if ([string]::IsNullOrWhiteSpace($equipo)) {
		$equipo = $env:COMPUTERNAME
	}
    Escribir-Centrado "Ver métodos de protección de las unidades (C:,D:,E:...) [C:]: " -NoNewline
    $unidades = Read-Host
		if ([string]::IsNullOrWhiteSpace($unidades)) {
			$unidades = "C:"
		}
    Escribir-Centrado ""
    Mostrar-BannerBit
    Escribir-Centrado "===============================================" -ColorDeFondo "Rojo"
    Escribir-Centrado "Activar BitLocker" -ColorDeFondo "Rojo"
    Escribir-Centrado "===============================================" -ColorDeFondo "Rojo"
    Escribir-Centrado ""

    # Si no se especifican unidades, usar C: por defecto
    if ([string]::IsNullOrWhiteSpace($unidades)) {
        $unidadesArray = @("C:")
    } else {
        # Dividir las unidades ingresadas en un array
        $unidadesArray = $unidades -split ',' | ForEach-Object { $_.Trim().ToUpper() }
    }

    foreach ($unidad in $unidadesArray) {
        # Verificar si la unidad tiene el formato correcto
        if ($unidad -notmatch '^[A-Z]:$') {
            Escribir-Centrado "Formato incorrecto para la unidad $unidad. Debe ser una letra seguida de dos puntos (ej. C:)" -ColorDeFondo "Rojo"
            continue
        }

        Escribir-Centrado "Activando BitLocker en la unidad $unidad" -ColorDeFondo "Cyan"

        # Capturar la salida del comando manage-bde
        $output = manage-bde -on $unidad -cn $equipo

        # Encontrar la longitud de la línea más larga
        $maxLength = ($output | Measure-Object -Property Length -Maximum).Maximum

        # Calcular el desplazamiento para alinear a la izquierda
        $consoleWidth = $Host.UI.RawUI.WindowSize.Width
        $leftPadding = [Math]::Max(0, ($consoleWidth - $maxLength) / 2)

        # Procesar y mostrar cada línea con el espaciado deseado
        $output | ForEach-Object {
            $paddedLine = $_.TrimStart().PadRight($maxLength)
            Write-Host (" " * $leftPadding) $paddedLine
        }

        Escribir-Centrado ""
    }

    Escribir-Centrado ""
    Escribir-Centrado "Presiona Enter para volver al menú" -NoNewline
    Read-Host
}

function Bitlocker-Off {
    Escribir-Centrado ""
    Escribir-Centrado "Nombre del equipo [este]: " -NoNewline
    $equipo = Read-Host
		if ([string]::IsNullOrWhiteSpace($equipo)) {
		$equipo = $env:COMPUTERNAME
	}
    Escribir-Centrado "Ver métodos de protección de las unidades (C:,D:,E:...) [C:]: " -NoNewline
    $unidades = Read-Host
		if ([string]::IsNullOrWhiteSpace($unidades)) {
			$unidades = "C:"
		}
    Escribir-Centrado ""
    Mostrar-BannerBit
    Escribir-Centrado "===============================================" -ColorDeFondo "Rojo"
    Escribir-Centrado "Desactivar BitLocker" -ColorDeFondo "Rojo"
    Escribir-Centrado "===============================================" -ColorDeFondo "Rojo"
    Escribir-Centrado ""

    # Si no se especifican unidades, usar C: por defecto
    if ([string]::IsNullOrWhiteSpace($unidades)) {
        $unidadesArray = @("C:")
    } else {
        # Dividir las unidades ingresadas en un array
        $unidadesArray = $unidades -split ',' | ForEach-Object { $_.Trim().ToUpper() }
    }

    foreach ($unidad in $unidadesArray) {
        # Verificar si la unidad tiene el formato correcto
        if ($unidad -notmatch '^[A-Z]:$') {
            Escribir-Centrado "Formato incorrecto para la unidad $unidad. Debe ser una letra seguida de dos puntos (ej. C:)" -ColorDeFondo "Rojo"
            continue
        }

        Escribir-Centrado "Desactivando BitLocker en la unidad $unidad" -ColorDeFondo "Cyan"
		Escribir-Centrado ""

        # Capturar la salida del comando manage-bde
        $output = manage-bde -off $unidad -cn $equipo

        # Encontrar la longitud de la línea más larga
        $maxLength = ($output | Measure-Object -Property Length -Maximum).Maximum

        # Calcular el desplazamiento para alinear a la izquierda
        $consoleWidth = $Host.UI.RawUI.WindowSize.Width
        $leftPadding = [Math]::Max(0, ($consoleWidth - $maxLength) / 2)

        # Procesar y mostrar cada línea con el espaciado deseado
        $output | ForEach-Object {
            $paddedLine = $_.TrimStart().PadRight($maxLength)
            Write-Host (" " * $leftPadding) $paddedLine
        }

        Escribir-Centrado ""
    }

    Escribir-Centrado ""
    Escribir-Centrado "Presiona Enter para volver al menú" -NoNewline
    Read-Host
}

function Bitlocker-Resume {
    Escribir-Centrado ""
    Escribir-Centrado "Nombre del equipo [este]: " -NoNewline
    $equipo = Read-Host
		if ([string]::IsNullOrWhiteSpace($equipo)) {
		$equipo = $env:COMPUTERNAME
	}
    Escribir-Centrado "Ver métodos de protección de las unidades (C:,D:,E:...) [C:]: " -NoNewline
    $unidades = Read-Host
		if ([string]::IsNullOrWhiteSpace($unidades)) {
			$unidades = "C:"
		}
    Escribir-Centrado ""
    Mostrar-BannerBit
    Escribir-Centrado "===============================================" -ColorDeFondo "Rojo"
    Escribir-Centrado "Reanudar cifrado/descifrado BitLocker" -ColorDeFondo "Rojo"
    Escribir-Centrado "===============================================" -ColorDeFondo "Rojo"
    Escribir-Centrado ""

    # Si no se especifican unidades, usar C: por defecto
    if ([string]::IsNullOrWhiteSpace($unidades)) {
        $unidadesArray = @("C:")
    } else {
        # Dividir las unidades ingresadas en un array
        $unidadesArray = $unidades -split ',' | ForEach-Object { $_.Trim().ToUpper() }
    }

    foreach ($unidad in $unidadesArray) {
        # Verificar si la unidad tiene el formato correcto
        if ($unidad -notmatch '^[A-Z]:$') {
            Escribir-Centrado "Formato incorrecto para la unidad $unidad. Debe ser una letra seguida de dos puntos (ej. C:)" -ColorDeFondo "Rojo"
            continue
        }

        Escribir-Centrado "Reanudando cifrado/descifrado en la unidad $unidad" -ColorDeFondo "Cyan"
		Escribir-Centrado ""
		
        # Capturar la salida del comando manage-bde
        $output = manage-bde -resume $unidad -cn $equipo

        # Encontrar la longitud de la línea más larga
        $maxLength = ($output | Measure-Object -Property Length -Maximum).Maximum

        # Calcular el desplazamiento para alinear a la izquierda
        $consoleWidth = $Host.UI.RawUI.WindowSize.Width
        $leftPadding = [Math]::Max(0, ($consoleWidth - $maxLength) / 2)

        # Procesar y mostrar cada línea con el espaciado deseado
        $output | ForEach-Object {
            $paddedLine = $_.TrimStart().PadRight($maxLength)
            Write-Host (" " * $leftPadding) $paddedLine
        }

        Escribir-Centrado ""
    }

    Escribir-Centrado ""
    Escribir-Centrado "Presiona Enter para volver al menú" -NoNewline
    Read-Host
}

function View-BitlockerKey {
    Escribir-Centrado ""
    Escribir-Centrado "Nombre del equipo [este]: " -NoNewline
    $equipo = Read-Host
		if ([string]::IsNullOrWhiteSpace($equipo)) {
		$equipo = $env:COMPUTERNAME
	}
    Escribir-Centrado "Ver métodos de protección de las unidades (C:,D:,E:...) [C:]: " -NoNewline
    $unidades = Read-Host
		if ([string]::IsNullOrWhiteSpace($unidades)) {
			$unidades = "C:"
		}
    Escribir-Centrado ""
    Mostrar-BannerBit
    Escribir-Centrado "===============================================" -ColorDeFondo "Rojo"
    Escribir-Centrado "Métodos de protección BitLocker" -ColorDeFondo "Rojo"
    Escribir-Centrado "===============================================" -ColorDeFondo "Rojo"
    Escribir-Centrado ""

    # Si no se especifican unidades, usar C: por defecto
    if ([string]::IsNullOrWhiteSpace($unidades)) {
        $unidadesArray = @("C:")
    } else {
        # Dividir las unidades ingresadas en un array
        $unidadesArray = $unidades -split ',' | ForEach-Object { $_.Trim().ToUpper() }
    }

    foreach ($unidad in $unidadesArray) {
        # Verificar si la unidad tiene el formato correcto
        if ($unidad -notmatch '^[A-Z]:$') {
            Escribir-Centrado "Formato incorrecto para la unidad $unidad. Debe ser una letra seguida de dos puntos (ej. C:)" -ColorDeFondo "Rojo"
            continue
        }

        Escribir-Centrado "Métodos de protección para la unidad $unidad" -ColorDeFondo "Cyan"
		Escribir-Centrado ""
		
        # Capturar la salida del comando manage-bde
        $output = manage-bde $unidad -protectors -get -cn $equipo

        # Encontrar la longitud de la línea más larga
        $maxLength = ($output | Measure-Object -Property Length -Maximum).Maximum

        # Calcular el desplazamiento para alinear a la izquierda
        $consoleWidth = $Host.UI.RawUI.WindowSize.Width
        $leftPadding = [Math]::Max(0, ($consoleWidth - $maxLength) / 2)

        # Procesar y mostrar cada línea con el espaciado deseado
        $output | ForEach-Object {
            $paddedLine = $_.TrimStart().PadRight($maxLength)
            Write-Host (" " * $leftPadding) $paddedLine
        }

        Escribir-Centrado ""
    }

    Escribir-Centrado ""
    Escribir-Centrado "Presiona Enter para volver al menú" -NoNewline
    Read-Host
}

function Menu-Bitlocker {
    do {
        Show-Menu
        Escribir-Centrado ""
        Escribir-Centrado "Selecciona una opción: " -NoNewline
        $choice = Read-Host

        switch ($choice) {
            "1" { Bitlocker-Status }
            "2" { Add-Protectors }
            "3" { Rmv-Protectors }
            "4" { Bitlocker-On }
            "5" { Bitlocker-Off }
            "6" { Bitlocker-Resume }
            "7" { View-BitlockerKey }
            "0" { 
<#                 Escribir-Centrado ""
                Escribir-Centrado "Volviendo al menú principal..." -ColorDeFondo "Verde"
                Escribir-Centrado ""
                Escribir-Centrado "" #>
                return 
            }
            default { Escribir-Centrado "Opción incorrecta." -ColorDeFondo "Rojo" }
        }

    } while ($true)
}

#Menu-Bitlocker
