# 🗑️ SCRIPT-PARA-BORRAR-BACKUPS

Script en PowerShell para automatizar el reemplazo de etiquetas XML y limpieza de archivos de backup desarrollado por **Isaac Esteban Haro Torres**.

---

## 📝 Descripción

Script para automatizar el reemplazo de la etiqueta `<HSTACC2>` por `<HSTACC>` en archivos XML. Incluye backup automático, logging detallado y notificaciones únicamente en caso de error vía correo SMTP y Telegram.

---

## 🎯 Para qué sirve

- Reemplazo automático de etiquetas XML legacy
- Limpieza de archivos backup antiguos
- Automatización de procesos batch críticos
- Integraciones con sistemas ERP
- Mantenimiento de archivos XML

---

## 🏗 Arquitectura

```
Carpeta XML → Script → Backup → Procesamiento → Notificaciones (si error)
```

---

## 🚀 Funcionalidades

- Reemplazo automático de `<HSTACC2>` por `<HSTACC>`
- Procesa únicamente archivos nuevos
- Backup obligatorio antes de modificar archivos
- Logs diarios con timestamp
- Manejo de errores por archivo
- Notificación por correo solo si hay errores
- Notificación por Telegram solo si hay errores
- Listo para ejecución programada

---

## 📂 Estructura de Carpetas

```
C:\ASPEN\OUTBOUND\RECIBO        # Archivos a procesar
C:\ASPEN\OUTBOUND\BACKUP       # Respaldos
C:\Scripts\Logs                # Logs
```

---

## 💻 Requisitos

- Windows Server o Windows 10+
- PowerShell 5.1 o superior
- Acceso a servidor SMTP
- Token válido de Telegram Bot

---

## ⚙️ Configuración Principal

```powershell
# Rutas
$XmlPath = "C:\ASPEN\OUTBOUND\RECIBO"
$BackupPath = "C:\ASPEN\OUTBOUND\BACKUP"
$LogPath = "C:\Scripts\Logs"

# SMTP
$SmtpServer = "smtp.servidor.com"
$MailFrom = "sistema@servidor.com"
$MailTo = "admin@servidor.com"

# Telegram
$TelegramBotToken = "token"
$TelegramChatId = "chat_id"
```

---

## 🔄 Flujo del Proceso

1. Escanea la carpeta de XML de entrada
2. Omite archivos ya respaldados
3. Genera backup del archivo original
4. Reemplaza etiquetas XML
5. Registra acciones en log
6. Notifica solo si existen errores

---

## 📬 Notificaciones

Las alertas se envían únicamente cuando se detectan errores:

- **Correo electrónico:** Formato HTML con detalles
- **Telegram:** Mensaje en texto plano

---

## ⚙️ Ejecución Recomendada

- Windows Task Scheduler
- Ejecución periódica
- Usuario con permisos sobre las rutas configuradas

---

## 🎯 Casos de Uso

- Integraciones ERP (Aspen / SAP)
- Procesos de facturación o recibos
- Corrección de XML legacy
- Automatización de flujos batch

---

## 👨‍💻 Desarrollado por Isaac Esteban Haro Torres

**Ingeniero en Sistemas · Full Stack · Automatización · Data**

- 📧 Email: zackharo1@gmail.com
- 📱 WhatsApp: 098805517
- 💻 GitHub: https://github.com/ieharo1
- 🌐 Portafolio: https://ieharo1.github.io/portafolio-isaac.haro/

---

© 2026 Isaac Esteban Haro Torres - Todos los derechos reservados.
