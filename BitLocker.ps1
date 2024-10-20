function Mostrar-BannerBit {
    Clear-Host
    Write-Host
    Write-Host
	Write-Host
    Write-Host
	Write-Host "				       ██████╗ ██╗████████╗██╗      ██████╗  ██████╗██╗  ██╗███████╗██████╗ " -ForegroundColor DarkRed
	Write-Host "				       ██╔══██╗██║╚══██╔══╝██║     ██╔═══██╗██╔════╝██║ ██╔╝██╔════╝██╔══██╗" -ForegroundColor DarkRed
	Write-Host "				       ██████╔╝██║   ██║   ██║     ██║   ██║██║     █████╔╝ █████╗  ██████╔╝" -ForegroundColor Red
	Write-Host "				       ██╔══██╗██║   ██║   ██║     ██║   ██║██║     ██╔═██╗ ██╔══╝  ██╔══██╗" -ForegroundColor Red
	Write-Host "				       ██████╔╝██║   ██║   ███████╗╚██████╔╝╚██████╗██║  ██╗███████╗██║  ██║" -ForegroundColor Red
	Write-Host "				       ╚═════╝ ╚═╝   ╚═╝   ╚══════╝ ╚═════╝  ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝" -ForegroundColor White
    Write-Host
}

function Show-Menu {
    $computerName = $env:COMPUTERNAME
    $host.UI.RawUI.BackgroundColor = "Black"
	Mostrar-BannerBit
	Write-Host "			 			  =============================================="
    Write-Host "			   			       Información y opciones de BitLocker" -ForegroundColor Yellow
    Write-Host "			 			  =============================================="
	Write-Host ""
    Write-Host "						    1. Ver estado de Bitlocker"
    Write-Host "						    2. Agregar protectores de Bitlocker"
	Write-Host "						    3. Eliminar protectores de Bitlocker"
    Write-Host "						    4. Activar Bitlocker"
    Write-Host "						    5. Desactivar Bitlocker"
    Write-Host "						    6. Reanudar cifrado/descifrado de Bitlocker"
    Write-Host "						    7. Ver clave de Bitlocker"
    Write-Host "						    0. Salir"
	Write-Host ""
    Write-Host "			 			  ===============================================" 
	Write-Host
    $host.UI.RawUI.ForegroundColor = "White"    # Restablecer el color del texto para que sea más fácil leer otros mensajes después del menú
}

function Bitlocker-Status {
    Write-Host ""
    $equipo = Read-Host "			 			  Nombre del equipo [este]"
    $unidades = Read-Host "			 			  Unidades a verificar el estado de BitLocker (C:,D:,E:...) [C:]"
    Write-Host ""
    Mostrar-BannerBit
    Write-Host "			 			  ==============================================="
    Write-Host "			 			                 Estado de BitLocker" -ForegroundColor Yellow 
    Write-Host "			 			  ==============================================="
    Write-Host

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
            Write-Host "			 			  Formato incorrecto para la unidad $unidad. Debe ser una letra seguida de dos puntos (ej. C:)" -ForegroundColor Red
            continue
        }

        Write-Host "			 			  Estado de BitLocker para la unidad $unidad" -ForegroundColor Cyan

        # Capturar la salida del comando manage-bde para cada unidad
        $output = manage-bde -status $unidad -cn $equipo

        # Procesar y mostrar cada línea con el espaciado deseado
        $output | ForEach-Object {
            Write-Host "			 			  $_"
        }

        Write-Host
    }

    Write-Host
    Read-Host "			 			  Presiona Enter para volver al menú"
}

function Add-Protectors {
    Write-Host ""
    $equipo = Read-Host "			 			  Nombre del equipo [este]"
    $unidades = Read-Host "			 			  Añadir protectores a las unidades (C:,D:,E:...) [C:]"
    Write-Host ""
    Mostrar-BannerBit
    Write-Host "			 			  ==============================================="
    Write-Host "			 			         Añadir protectores BitLocker" -ForegroundColor Yellow 
    Write-Host "			 			  ==============================================="
    Write-Host

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
            Write-Host "			 			  Formato incorrecto para la unidad $unidad. Debe ser una letra seguida de dos puntos (ej. C:)" -ForegroundColor Red
            continue
        }

        Write-Host "			 			  Añadiendo protectores a la unidad $unidad" -ForegroundColor Cyan

        # Capturar la salida del comando manage-bde
        $output = manage-bde -protectors -add -tpm -rp $unidad -cn $equipo

        # Procesar y mostrar cada línea con el espaciado deseado
        $output | ForEach-Object {
            Write-Host "			 			  $_"
        }

        Write-Host
    }

    Write-Host
    Read-Host "			 			  Presiona Enter para volver al menú"
}

function Rmv-Protectors {
    Write-Host ""
    $equipo = Read-Host "			 			  Nombre del equipo [este]"
    $unidades = Read-Host "			 			  Eliminar protectores a las unidades (C:,D:,E:...) [C:]"
    Write-Host ""
    Mostrar-BannerBit
    Write-Host "                         ==============================================="
    Write-Host "                                 Eliminar protectores BitLocker" -ForegroundColor Yellow 
    Write-Host "                         ==============================================="
    Write-Host

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
            Write-Host "                         Formato de unidad incorrecto para $unidad. Debe ser una letra seguida de dos puntos (ej. C:)" -ForegroundColor Red
            continue
        }

        Write-Host "                         Eliminando protectores de la unidad $unidad" -ForegroundColor Cyan

        # Capturar la salida del comando manage-bde
        $output = manage-bde -protectors -delete $unidad -cn $equipo

        # Procesar y mostrar cada línea con el espaciado deseado
        $output | ForEach-Object {
            Write-Host "                         $_"
        }

        Write-Host
    }

    Write-Host
    Read-Host "                         Presione Enter para volver al menú"
}

function Bitlocker-On {
    Write-Host ""
    $equipo = Read-Host "			 			  Nombre del equipo [este]"
    $unidades = Read-Host "			 			  Activar BitLocker en las unidades (C:,D:,E:...) [C:]"
    Write-Host ""
    Mostrar-BannerBit
    Write-Host "			 			  ==============================================="
    Write-Host "			 			          Activar BitLocker" -ForegroundColor Yellow 
    Write-Host "			 			  ==============================================="
    Write-Host

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
            Write-Host "			 			  Formato incorrecto para la unidad $unidad. Debe ser una letra seguida de dos puntos (ej. C:)" -ForegroundColor Red
            continue
        }

        Write-Host "			 			  Activando BitLocker en la unidad $unidad" -ForegroundColor Cyan

        # Capturar la salida del comando manage-bde
        $output = manage-bde -on $unidad -cn $equipo

        # Procesar y mostrar cada línea con el espaciado deseado
        $output | ForEach-Object {
            Write-Host "			 			  $_"
        }

        Write-Host
    }

    Write-Host
    Read-Host "			 			  Presiona Enter para volver al menú"
}

function Bitlocker-Off {
    Write-Host ""
    $equipo = Read-Host "			 			  Nombre del equipo [este]"
    $unidades = Read-Host "			 			  Desactivar BitLocker en las unidades (C:,D:,E:...) [C:]"
    Write-Host ""
    Mostrar-BannerBit
    Write-Host "			 			  ==============================================="
    Write-Host "			 			          Desactivar BitLocker" -ForegroundColor Yellow 
    Write-Host "			 			  ==============================================="
    Write-Host

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
            Write-Host "			 			  Formato incorrecto para la unidad $unidad. Debe ser una letra seguida de dos puntos (ej. C:)" -ForegroundColor Red
            continue
        }

        Write-Host "			 			  Desactivando BitLocker en la unidad $unidad" -ForegroundColor Cyan

        # Capturar la salida del comando manage-bde
        $output = manage-bde -off $unidad -cn $equipo

        # Procesar y mostrar cada línea con el espaciado deseado
        $output | ForEach-Object {
            Write-Host "			 			  $_"
        }

        Write-Host
    }

    Write-Host
    Read-Host "			 			  Presiona Enter para volver al menú"
}

function Bitlocker-Resume {
    Write-Host ""
    $equipo = Read-Host "			 			  Nombre del equipo [este]"
    $unidades = Read-Host "			 			  Reanudar cifrado/descifrado en las unidades (C:,D:,E:...) [C:]"
    
    # Si no se especifica unidad, usar C: por defecto
    if ([string]::IsNullOrWhiteSpace($unidad)) {
        $unidad = "C:"
    } else {
        $unidad = $unidad.Trim().ToUpper()
        # Verificar si la unidad tiene el formato correcto
        if ($unidad -notmatch '^[A-Z]:$') {
            Write-Host "			 			  Formato incorrecto para la unidad. Debe ser una letra seguida de dos puntos (ej. C:)" -ForegroundColor Red
            Read-Host "			 			  Presione Enter para volver al menú"
            return
        }
    }

    Write-Host ""
    Mostrar-BannerBit
    Write-Host "			 			  ==============================================="
    Write-Host "			 			      Reanudar cifrado/descifrado UNIDAD $unidad" -ForegroundColor Yellow 
    Write-Host "			 			  ==============================================="
    Write-Host

    # Capturar la salida del comando manage-bde
    $output = manage-bde -resume $unidad -cn $equipo

    # Procesar y mostrar cada línea con el espaciado deseado
    $output | ForEach-Object {
        Write-Host "			 			  $_"
    }

    Write-Host
    Read-Host "			 			  Presiona Enter para volver al menú"
}

function View-BitlockerKey {
    Write-Host ""
    $equipo = Read-Host "			 			  Nombre del equipo [este]"
    $unidades = Read-Host "			 			  Ver métodos de protección de las unidades (C:,D:,E:...) [C:]"
    Write-Host ""
    Mostrar-BannerBit
    Write-Host "			 			  ==============================================="
    Write-Host "			 			      Métodos de protección BitLocker" -ForegroundColor Yellow 
    Write-Host "			 			  ==============================================="
    Write-Host

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
            Write-Host "			 			  Formato incorrecto para la unidad $unidad. Debe ser una letra seguida de dos puntos (ej. C:)" -ForegroundColor Red
            continue
        }

        Write-Host "			 			  Métodos de protección para la unidad $unidad" -ForegroundColor Cyan

        # Capturar la salida del comando manage-bde
        $output = manage-bde $unidad -protectors -get -cn $equipo

        # Procesar y mostrar cada línea con el espaciado deseado
        $output | ForEach-Object {
            Write-Host "			 			  $_"
        }

        Write-Host
    }

    Write-Host
    Read-Host "			 			  Presiona Enter para volver al menú"
}

function Menu-Bitlocker {
    do {
        Show-Menu
        Write-Host
        $choice = Read-Host "						  Selecciona una opción"
        switch ($choice) {
            "1" { Bitlocker-Status }
            "2" { Add-Protectors }
            "3" { Rmv-Protectors }
            "4" { Bitlocker-On }
            "5" { Bitlocker-Off }
            "6" { Bitlocker-Resume }
            "7" { View-BitlockerKey }
            "0" { 
                Write-Host "`n						  Volviendo al menú principal..." -ForegroundColor Green 
                Write-Host ""
                Write-Host ""
                return 
            }
            default { Write-Host "`n						  Opción incorrecta." -ForegroundColor Red }
        }
        if ($choice -ne '0') {
            Write-Host "`n						  Presione cualquier tecla para continuar..."
            [void][System.Console]::ReadKey()
        }
    } while ($true)
}
Menu-Bitlocker
