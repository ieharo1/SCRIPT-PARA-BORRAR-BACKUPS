# ===============================================================
# borrar_bk.ps1
# Limpieza de Backups SITRADBK
# Conserva solo los 2 backups más recientes por fecha
# Notificación SOLO si hay errores
# ===============================================================

# ================= RUTAS =================
$BackupPath = ""
$LogPath    = ""

# ================= SMTP =================
$SmtpServer = ""
$MailFrom   = ""
$MailTo     = ""

# ================= TELEGRAM =================
$TelegramBotToken = ""
$TelegramChatId   = ""

# ================= CARPETAS =================
if (-not (Test-Path $LogPath)) {
    New-Item -ItemType Directory -Path $LogPath | Out-Null
}

$LogFile = Join-Path $LogPath ("borrar-backups-{0:yyyyMMdd}.log" -f (Get-Date))

# ================= FUNCIONES =================
function Log {
    param([string]$msg)
    $line = "[{0}] {1}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $msg
    Add-Content -Path $LogFile -Value $line
    Write-Host $msg
}

function Send-Mail {
    param ([string]$Subject, [string]$Body)
    Send-MailMessage `
        -From $MailFrom `
        -To $MailTo `
        -Subject $Subject `
        -Body $Body `
        -BodyAsHtml `
        -SmtpServer $SmtpServer `
        -Port 25 `
        -Encoding UTF8
}

function Send-Telegram {
    param ([string]$Message)
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $uri = "https://api.telegram.org/bot$TelegramBotToken/sendMessage"
        $body = @{
            chat_id = $TelegramChatId
            text    = $Message
        }
        Invoke-RestMethod -Uri $uri -Method Post -Body $body | Out-Null
        Log "Telegram enviado"
    } catch {
        Log "ERROR TELEGRAM: $($_.Exception.Message)"
    }
}

# ================= PROCESO =================
Log "=== INICIO LIMPIEZA BACKUPS SITRADBK ==="

$ErrorFiles = @()
$Deleted    = @()

if (-not (Test-Path $BackupPath)) {
    $ErrorFiles += "La ruta $BackupPath no existe"
    Log "ERROR: Ruta no existe"
} else {

    $Backups = Get-ChildItem -Path $BackupPath -Filter "*.zip" -File | ForEach-Object {

        if ($_.Name -match "Backup (\d{4}-\d{2}-\d{2})") {
            [PSCustomObject]@{
                File     = $_
                FileDate = [datetime]::ParseExact($matches[1], "yyyy-MM-dd", $null)
            }
        }
    }

    if ($Backups.Count -lt 3) {
        Log "INFO: Hay $($Backups.Count) backups no se elimina nada"
    } else {

        $BackupsOrdenados = $Backups | Sort-Object FileDate -Descending
        $BackupsABorrar  = $BackupsOrdenados | Select-Object -Skip 2

        foreach ($b in $BackupsABorrar) {
            try {
                Remove-Item $b.File.FullName -Force
                $Deleted += $b.File.Name
                Log "ELIMINADO: $($b.File.Name)"
            } catch {
                $ErrorFiles += "$($b.File.Name) - $($_.Exception.Message)"
                Log "ERROR eliminando $($b.File.Name)"
            }
        }
    }
}

Log "=== FIN LIMPIEZA BACKUPS ==="

# ================= NOTIFICACIONES SOLO SI HAY ERRORES =================
if ($ErrorFiles.Count -gt 0) {

    $Servidor = $env:COMPUTERNAME
    $Fecha    = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    # -------- CORREO HTML --------
    $BodyHtml  = "<h2>ERROR LIMPIEZA BACKUPS SITRADBK</h2>"
    $BodyHtml += "<p><b>Servidor:</b> $Servidor</p>"
    $BodyHtml += "<p><b>Fecha:</b> $Fecha</p>"
    $BodyHtml += "<p><b>Ruta:</b><br>$BackupPath</p>"

    $BodyHtml += "<h3>Errores detectados</h3><ul style='color:red'>"
    foreach ($e in $ErrorFiles) { $BodyHtml += "<li>$e</li>" }
    $BodyHtml += "</ul><p>Log: $LogFile</p>"

    Send-Mail -Subject "ERROR LIMPIEZA BACKUPS - $Servidor" -Body $BodyHtml

    # -------- TELEGRAM TEXTO PLANO --------
    $BodyTelegram  = "REPORTE LIMPIEZA BACKUPS`n"
    $BodyTelegram += "Servidor: $Servidor`n"
    $BodyTelegram += "Fecha: $Fecha`n`n"
    $BodyTelegram += "Notificación: @Ih200124`n`n"

    $BodyTelegram += "Errores:`n"
    foreach ($e in $ErrorFiles) { $BodyTelegram += "- $e`n" }

    $BodyTelegram += "`nLog: $LogFile"

    Send-Telegram -Message $BodyTelegram
}

Write-Host "Proceso finalizado"
