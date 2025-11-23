# Configuración de Variables de Entorno

Este proyecto utiliza variables de entorno para configurar APIs y servicios externos.

## Setup Rápido

1. **Copia el archivo de ejemplo**:
   ```bash
   cp .env.example .env
   ```

2. **Edita `.env` con tus valores reales**:
   ```env
   GEMINI_API_KEY=tu_api_key_real_de_gemini
   API_BASE_URL=https://tu-servidor-backend.com/api/v1
   MAIL_SERVICE_URL=https://tu-servicio-mail.com
   ```

## Variables Disponibles

### `GEMINI_API_KEY`
- **Descripción**: API Key de Google Gemini para funciones de IA
- **Requerido**: Sí (para funcionalidad de chat IA)
- **Obtener**: https://makersuite.google.com/app/apikey
- **Ejemplo**: `AIzaSyA...`

### `API_BASE_URL`
- **Descripción**: URL base del backend de BIAN
- **Requerido**: Sí
- **Valor por defecto**: `http://localhost:3000/api/v1`
- **Producción**: `https://api.bian.com/api/v1`

### `MAIL_SERVICE_URL`
- **Descripción**: URL del servicio de correo
- **Requerido**: Sí
- **Valor por defecto**: `http://localhost:3001`
- **Producción**: `https://mail.bian.com`

## Uso en Flutter

Para que Flutter reconozca las variables de entorno:

```bash
flutter run --dart-define=GEMINI_API_KEY=tu_key \
            --dart-define=API_BASE_URL=https://api.com \
            --dart-define=MAIL_SERVICE_URL=https://mail.com
```

## Build para Producción

```bash
flutter build apk --release \
    --dart-define=GEMINI_API_KEY=$GEMINI_API_KEY \
    --dart-define=API_BASE_URL=$API_BASE_URL \
    --dart-define=MAIL_SERVICE_URL=$MAIL_SERVICE_URL
```

## Seguridad

⚠️ **IMPORTANTE**:
- **NUNCA** commites el archivo `.env` al repositorio
- El archivo `.env.example` NO contiene valores reales
- Usa diferentes keys para desarrollo y producción
- Rota las API keys periódicamente

## Troubleshooting

**Problema**: "API key inválida"
- Solución: Verifica que `GEMINI_API_KEY` esté configurada correctamente

**Problema**: "Connection refused"
- Solución: Verifica que `API_BASE_URL` apunte al servidor correcto

**Problema**: Variables no se cargan
- Solución: Asegúrate de pasar `--dart-define` al ejecutar Flutter
