# Configuración de Google Gemini AI (GRATIS)

## ⚡ Funcionalidad de Análisis con IA

La app ahora incluye análisis extendido de reportes de bienestar animal utilizando **Google Gemini AI completamente GRATIS**.

## 🔑 Obtener tu API Key GRATUITA

### Paso 1: Crear cuenta en Google AI Studio
1. Ve a [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Inicia sesión con tu cuenta de Google
3. Acepta los términos de servicio

### Paso 2: Generar API Key
1. Haz clic en "Get API Key" o "Crear clave de API"
2. Selecciona "Create API key in new project" o usa un proyecto existente
3. Copia la API key generada (empezará con `AIzaSy...`)

### Paso 3: Configurar en la app
Abre el archivo `lib/core/services/gemini_service.dart` y reemplaza la línea 8:

```dart
// ANTES (línea 8):
static const String _apiKey = 'AIzaSyBJKxKxKxKxKxKxKxKxKxKxKxKxKxK'; // ⚠️ PLACEHOLDER

// DESPUÉS (reemplaza con tu key real):
static const String _apiKey = 'TU_API_KEY_AQUI'; // ✅ Tu API key real
```

## 📊 Límites GRATUITOS de Google Gemini

El tier gratuito incluye:
- ✅ **15 requests por minuto**
- ✅ **1500 requests por día**
- ✅ **Totalmente GRATIS** - No se requiere tarjeta de crédito
- ✅ Modelo `gemini-1.5-flash` (rápido y eficiente)

## 🚀 Funcionalidades Implementadas

### 1. Banner de Reportes Pendientes en Login
- Muestra cuántos reportes están sin sincronizar
- Al tocar, redirige al modo offline para sincronizar

### 2. Análisis Extendido con IA en Reportes
- Botón destacado con badge "GRATIS" en la pantalla de resultados
- **Valida conexión a internet** antes de usar
- Genera análisis detallado con:
  - Evaluación general del bienestar
  - Análisis por categoría
  - Recomendaciones específicas y accionables
  - Impacto en el bienestar animal
  - Recursos y mejores prácticas

## ⚠️ Consideraciones de Seguridad

**IMPORTANTE:** En producción, NO incluyas la API key directamente en el código. Usa:
- Variables de entorno
- Configuración del servidor
- Servicios de gestión de secretos (Firebase Remote Config, AWS Secrets Manager, etc.)

Para desarrollo local, la configuración actual es suficiente.

## 🧪 Cómo Probar

1. Obtén tu API key siguiendo los pasos anteriores
2. Configúrala en `gemini_service.dart`
3. Completa una evaluación de bienestar animal
4. En la pantalla de resultados, toca el botón **"Análisis Extendido con IA"**
5. Espera unos segundos mientras genera el análisis personalizado

## 🛠️ Solución de Problemas

### Error: "El servicio de IA no está disponible"
- Verifica que hayas configurado correctamente la API key
- Asegúrate de que la key no tenga espacios adicionales

### Error: "Necesitas conexión a internet"
- La función de IA requiere conexión activa
- Verifica tu conexión WiFi o datos móviles

### Error de cuota excedida
- Espera 1 minuto (límite de 15 requests/minuto)
- O espera al día siguiente (límite de 1500 requests/día)

## 📚 Documentación Adicional

- [Google Gemini API Docs](https://ai.google.dev/docs)
- [Pricing & Limits](https://ai.google.dev/pricing)
- [Quick Start Guide](https://ai.google.dev/tutorials/get_started_dart)

---

**Nota:** Esta funcionalidad es 100% GRATUITA y no requiere configuración de billing ni tarjeta de crédito. ¡Disfruta del análisis inteligente! 🎉
