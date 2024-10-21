# Limpiar la pantalla al inicio
Clear-Host

# Mostrar un mensaje de bienvenida
Write-Host "Generador de comandos de búsqueda de logs" -ForegroundColor Cyan
Write-Host "Este script te ayudará a crear comandos para buscar en los logs de correo." -ForegroundColor Cyan
Write-Host "Para el Rastreator SMTPLX Postfix" -ForegroundColor Cyan
Write-Host ""

function Format-Date {
    param (
        [string]$inputDate
    )

    if ($inputDate -eq "hoy") {
        $fechaHoy = Get-Date
        return "hoy", $fechaHoy.ToString("yyyyMMdd"), $fechaHoy.ToString("dd/MM/yyyy")
    }
    elseif ($inputDate -match '\*') {
        return "en la fecha $inputDate", $inputDate, $inputDate
    }
    else {
        try {
            $fechaObj = [DateTime]::ParseExact($inputDate, "dd/MM/yyyy", $null)
            $fechaArchivo = $fechaObj.AddDays(1)
            $fechaLegible = $fechaObj.ToString("dd 'de' MMMM 'del' yyyy", [System.Globalization.CultureInfo]::new("es-ES"))
            return "del $fechaLegible", $fechaArchivo.ToString("yyyyMMdd"), $inputDate
        }
        catch {
            return $null, $null, $null
        }
    }
}

function Obtener-EntradaUsuario {
    param (
        [string]$mensaje,
        [switch]$permitirVacio,
        [string]$porDefecto = ""
    )

    do {
        if ($porDefecto -ne "") {
            $entrada = Read-Host -Prompt "$mensaje (Por defecto: $porDefecto)"
            if ($entrada -eq "") { $entrada = $porDefecto }
        } else {
            $entrada = Read-Host -Prompt $mensaje
        }
        if ($permitirVacio -or $entrada -ne "") {
            return $entrada
        }
        Write-Host "Este campo no puede estar vacío." -ForegroundColor Yellow
    } while ($true)
}

function Construir-ComandoBusqueda {
    param (
        [string]$fechaArchivo,
        [string]$remitente,
        [string]$destinatario,
        [string]$asunto,
        [string]$estado
    )

    if ([string]::IsNullOrEmpty($fechaArchivo)) {
        return "Error: Fecha de archivo no válida", $false
    }

    $comando = "bzcat /var/log/correo/mail-$fechaArchivo.bz2"
    $filtros = @()

    # Agregar filtros en el orden especificado
    if ($asunto) {
        if ($asunto.Contains(" ")) {
            $filtros += "busca -s `"$asunto`""
        } else {
            $filtros += "busca -s '$asunto'"
        }
    }
    if ($estado -ne "") { $filtros += "busca -d '$estado'" }
    if ($remitente -ne "") { $filtros += "busca -f '$remitente'" }

    # Manejar destinatarios
    $destinatarios = $destinatario.Split(',').Trim() | Where-Object { $_ -ne "" }
    $dominiosDestinatarios = $destinatarios | ForEach-Object { $_.Split('@')[1] } | Select-Object -Unique

    if ($destinatarios.Count -gt 0) {
        $dominio = $destinatarios[0].Split('@')[1]
        $filtros += "busca -t @$dominio"
    }

    # Agregar los filtros al comando
    if ($filtros.Count -gt 0) {
        $comando += " | " + ($filtros -join " | ")
    }

    # Agregar el grep para múltiples destinatarios si es necesario
    if ($destinatarios.Count -gt 1) {
        $grepPatterns = $destinatarios | ForEach-Object { "-e $_" }
        $comando += " | grep $($grepPatterns -join ' ')"
    }

    return @{
        Comando = $comando
        MultiplesDominios = ($dominiosDestinatarios.Count -gt 1)
    }
}

# Solicitar fecha (obligatoria)
do {
    $fecha = Obtener-EntradaUsuario -mensaje "Fecha ('hoy' para la fecha actual, o DD/MM/YYYY)"
    if ($fecha -eq "hoy" -or $fecha -match '^\d{2}/\d{2}/\d{4}$') {
        break
    }
    Write-Host "Formato de fecha incorrecto. Usa 'hoy' o DD/MM/YYYY." -ForegroundColor Red
} while ($true)

$fechaDescripcion, $fechaArchivo, $fechaBusqueda = Format-Date $fecha
Write-Host "" # Línea en blanco

# Solicitar información sobre el remitente
Write-Host "Opciones de remitente:"
Write-Host "1. alertas@seresco.es"
Write-Host "2. cgs@seresco.es"
Write-Host "3. otro remitente"
Write-Host "4. cualquier remitente"

do {
    $opcionRemitente = Read-Host "Seleccione una opción (1-4) [4]"
    switch ($opcionRemitente) {
        "1" { $remitente = "alertas@seresco.es"; break }
        "2" { $remitente = "cgs@seresco.es"; break }
        "3" { $remitente = Read-Host "otro remitente"; break }
        "4" { $remitente = ""; break }
        "" { $remitente = ""; break }
        default { Write-Host "Opción incorrecta, selecciona un número del 1 al 4 o presiona Enter [4]" -ForegroundColor Yellow }
    }
} while ($opcionRemitente -notin @("", "1", "2", "3", "4"))

Write-Host "" # Línea en blanco

# Solicitar información al usuario
$destinatario = Obtener-EntradaUsuario -mensaje "Destinatario (separados por comas si son varios)" -permitirVacio

$resultado = Construir-ComandoBusqueda -fechaArchivo $fechaArchivo -remitente $remitente -destinatario $destinatario -asunto $asunto -estado $estado
$comando = $resultado.Comando
$multiplesDominios = $resultado.MultiplesDominios

if ($multiplesDominios) {
    Write-Host "ADVERTENCIA: Se han detectado múltiples dominios en los destinatarios. La búsqueda podría no ser precisa." -ForegroundColor Yellow
    Write-Host "NOTA: Para búsquedas múltiples de destinatarios, se recomienda que sean del mismo dominio para obtener resultados precisos." -ForegroundColor Yellow
}

Write-Host "" # Línea en blanco
$asunto = Obtener-EntradaUsuario -mensaje "Asunto" -permitirVacio
Write-Host "" # Línea en blanco

# Solicitar estado de entrega
Write-Host "Opciones de estado de entrega:"
Write-Host "1. sent (enviado)"
Write-Host "2. deferred (diferido)"
Write-Host "3. bounced (rebotado)"
Write-Host "4. expired (expirado)"
Write-Host "5. delivered (entregado)"
Write-Host "6. queued (en cola)"
Write-Host "7. held (retenido)"
Write-Host "8. rejected (rechazado)"
Write-Host "9. cualquier estado de entrega"

do {
    $opcionEstado = Read-Host "Seleccione una opción (1-9) o Enter para cualquier estado [9]"
    switch ($opcionEstado) {
        "1" { $estado = "sent"; break }
        "2" { $estado = "deferred"; break }
        "3" { $estado = "bounced"; break }
        "4" { $estado = "expired"; break }
        "5" { $estado = "delivered"; break }
        "6" { $estado = "queued"; break }
        "7" { $estado = "held"; break }
        "8" { $estado = "rejected"; break }
        "9" { $estado = ""; break }
        "" { $estado = ""; break }
        default { Write-Host "Opción incorrecta, selecciona un número del 1 al 9 o presione Enter [9]" -ForegroundColor Yellow }
    }
} while ($opcionEstado -notin @("", "1", "2", "3", "4", "5", "6", "7", "8", "9"))

Write-Host "" # Línea en blanco

# Construir el comando
#$comando = Construir-ComandoBusqueda -fechaArchivo $fechaArchivo -remitente $remitente -destinatario $destinatario -asunto $asunto -estado $estado

# Verificar si se ha seleccionado algún parámetro
$comandoVacio = [string]::IsNullOrEmpty($comando)

# Preguntar si se desea exportar a un archivo
$exportar = Obtener-EntradaUsuario -mensaje "¿Quieres exportar los resultados a un archivo? (s/n)" -permitirVacio
if ($exportar.ToLower() -eq "s") {
    $archivo = Obtener-EntradaUsuario -mensaje "Nombre y extensión del archivo de salida"
    $comando += " > $archivo"
}

# Obtener el ancho de la consola
$anchoConsola = $Host.UI.RawUI.WindowSize.Width

# Generar mensaje descriptivo
$mensajeDescriptivo = "Este comando buscará correos"
$componentes = @()

if ($fechaDescripcion -eq "hoy") {
    $fechaHoy = Get-Date
    $fechaManana = $fechaHoy.AddDays(1)
    $componentes += "de hoy"
    $componentes += "en el archivo del $($fechaManana.ToString('dd \de MMMM \del yyyy'))"
} else {
    if ($fechaArchivo -match '^\d{8}$') {
        $fechaBusqueda = [DateTime]::ParseExact($fechaArchivo, "yyyyMMdd", $null).AddDays(-1)
        $fechaArchivoObj = [DateTime]::ParseExact($fechaArchivo, "yyyyMMdd", $null)
        $componentes += "del $($fechaBusqueda.ToString('dd \de MMMM \del yyyy'))"
        $componentes += "en el archivo del $($fechaArchivoObj.ToString('dd \de MMMM \del yyyy'))"
    } else {
        $componentes += "$fechaDescripcion"
    }
}

if ($remitente) { $componentes += "enviados desde $remitente" }
if ($destinatario) { $componentes += "para $destinatario" }
if ($asunto) { $componentes += "con asunto '$asunto'" }
if ($estado) { $componentes += "con estado $estado" }

# Unir los componentes con comas y añadir 'y' antes del último componente
if ($componentes.Count -gt 1) {
    $mensajeDescriptivo += " " + ($componentes[0..($componentes.Count - 2)] -join ", ") + " y " + $componentes[-1] + "."
} elseif ($componentes.Count -eq 1) {
    $mensajeDescriptivo += " " + $componentes[0] + "."
} else {
    $mensajeDescriptivo += "."
}

# Imprimir el comando generado con mejoras visuales
Write-Host "`nComando generado:" -ForegroundColor Yellow

# Crear una línea en blanco con fondo azul oscuro
Write-Host "".PadRight($anchoConsola) -BackgroundColor DarkBlue

# Imprimir el comando o el mensaje de no selección
if ($comandoVacio) {
    $mensaje = "No has seleccionado ningún parámetro de búsqueda."
    Write-Host $mensaje -ForegroundColor Red -BackgroundColor Black
} else {
    Write-Host $comando -ForegroundColor Green -BackgroundColor Black
}

# Crear otra línea en blanco con fondo azul oscuro
Write-Host "".PadRight($anchoConsola) -BackgroundColor DarkBlue

# Mostrar el mensaje descriptivo (solo si hay un comando)
if (-not $comandoVacio) {
    Write-Host "`n$mensajeDescriptivo" -ForegroundColor Cyan
}

# Esperar a que el usuario presione una tecla antes de cerrar
Write-Host "`nPresiona cualquier tecla para salir..." -ForegroundColor Cyan
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")