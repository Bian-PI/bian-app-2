# 📚 Documentación Completa de API - BIAN App

## 🔧 Configuración

### Variables de Entorno (.env)
```env
API_BASE_URL=http://10.0.2.2:8081          # Backend principal
MAIL_SERVICE_URL=http://10.0.2.2:8080     # Servicio de correos
EVALUATIONS_BASE_URL=http://10.0.2.2:8089  # Backend Java (evaluaciones)
GEMINI_API_KEY=tu_api_key_aqui
```

### URLs por Entorno
- **Emulador Android**: `http://10.0.2.2:PUERTO`
- **Dispositivo físico/iOS**: `http://TU_IP_LOCAL:PUERTO`
- **Producción**: Configura las URLs reales en el `.env`

---

## 🔐 AUTENTICACIÓN

### 1. Login
Inicia sesión con credenciales de usuario.

**Uso en Flutter:**
```dart
final apiService = ApiService();

final result = await apiService.login(
  'usuario@ejemplo.com',
  'contraseña123'
);

if (result['success']) {
  final token = result['token'];
  final user = result['user'];
  // Guardar token y usuario
} else {
  final message = result['message']; // 'invalid_credentials', 'user_not_verified', etc.
}
```

**Request:**
- **Método**: `POST /auth/login`
- **Headers**: `Content-Type: application/json`
- **Body**:
```json
{
  "email": "usuario@ejemplo.com",
  "password": "contraseña123"
}
```

**Response Success (200)**:
```json
{
  "success": true,
  "token": "eyJhbGciOiJIUzI1NiIs...",
  "user": {
    "id": 1,
    "name": "Juan Pérez",
    "email": "usuario@ejemplo.com",
    "role": "evaluador",
    "document": "1234567890",
    "isActiveSession": true
  }
}
```

**Response Error (401)**:
```json
{
  "success": false,
  "message": "invalid_credentials"
}
```

**Response Error (403 - Usuario no verificado)**:
```json
{
  "success": false,
  "message": "user_not_verified",
  "email": "usuario@ejemplo.com",
  "userId": 123
}
```

---

### 2. Register
Registra un nuevo usuario en el sistema.

**Uso en Flutter:**
```dart
final result = await apiService.register({
  'name': 'Juan Pérez',
  'email': 'usuario@ejemplo.com',
  'password': 'contraseña123',
  'role': 'evaluador',
  'document': '1234567890'
});

if (result['success']) {
  if (result['user_not_verified'] == true) {
    // Usuario creado pero debe verificar email
    final email = result['email'];
    final userId = result['userId'];
  } else {
    // Usuario creado y verificado
    final user = result['user'];
    final token = result['token'];
  }
}
```

**Request:**
- **Método**: `POST /auth/register`
- **Headers**: `Content-Type: application/json`
- **Body**:
```json
{
  "name": "Juan Pérez",
  "email": "usuario@ejemplo.com",
  "password": "contraseña123",
  "role": "evaluador",
  "document": "1234567890"
}
```

**Response Success (201)**:
```json
{
  "success": true,
  "user": {
    "id": 1,
    "name": "Juan Pérez",
    "email": "usuario@ejemplo.com",
    "role": "evaluador"
  },
  "token": "eyJhbGciOiJIUzI1NiIs..."
}
```

**Response Error (409 - Usuario ya existe)**:
```json
{
  "success": false,
  "message": "user_exists"
}
```

---

### 3. Refresh Token
Renueva el token de autenticación.

**Uso en Flutter:**
```dart
final currentToken = await _storage.getToken();
final result = await apiService.refreshToken(currentToken);

if (result['success']) {
  final newToken = result['token'];
  await _storage.saveToken(newToken);
}
```

**Request:**
- **Método**: `POST /auth/refresh`
- **Headers**: `Content-Type: application/json`, `Authorization: Bearer {token}`
- **Body**:
```json
{
  "token": "eyJhbGciOiJIUzI1NiIs..."
}
```

**Response Success (200)**:
```json
{
  "success": true,
  "token": "eyJhbGciOiJIUzI1NiIs_NEW_TOKEN..."
}
```

---

### 4. Reenviar Email de Verificación
Reenvía el email de verificación a un usuario.

**Uso en Flutter:**
```dart
final result = await apiService.resendVerificationEmail(
  userId: 123,
  email: 'usuario@ejemplo.com'
);

if (result['success']) {
  // Email enviado exitosamente
  print(result['message']); // 'verification_sent'
}
```

**Request:**
- **Método**: `POST /api/email/send/{userId}?email={email}`
- **Base URL**: `MAIL_SERVICE_URL`

**Response Success (200)**:
```json
{
  "success": true,
  "message": "verification_sent"
}
```

---

## 👥 GESTIÓN DE USUARIOS

### 5. Obtener Todos los Usuarios
Obtiene la lista completa de usuarios (requiere autenticación).

**Uso en Flutter:**
```dart
final result = await apiService.getAllUsers();

if (result['success']) {
  final List users = result['users'];
  for (var user in users) {
    print('${user['name']} - ${user['email']}');
  }
}
```

**Request:**
- **Método**: `GET /users`
- **Headers**: `Authorization: Bearer {token}`

**Response Success (200)**:
```json
{
  "success": true,
  "users": [
    {
      "id": 1,
      "name": "Juan Pérez",
      "email": "juan@ejemplo.com",
      "role": "evaluador",
      "document": "1234567890"
    },
    {
      "id": 2,
      "name": "María García",
      "email": "maria@ejemplo.com",
      "role": "administrador"
    }
  ]
}
```

---

### 6. Obtener Usuario por ID
Obtiene la información de un usuario específico.

**Uso en Flutter:**
```dart
final result = await apiService.getUserById(1);

if (result['success']) {
  final user = result['user'];
  print('Usuario: ${user['name']}');
}
```

**Request:**
- **Método**: `GET /users/{id}`
- **Headers**: `Authorization: Bearer {token}`

**Response Success (200)**:
```json
{
  "success": true,
  "user": {
    "id": 1,
    "name": "Juan Pérez",
    "email": "juan@ejemplo.com",
    "role": "evaluador",
    "document": "1234567890"
  }
}
```

**Response Error (404)**:
```json
{
  "success": false,
  "message": "user_not_found"
}
```

---

### 7. Obtener Usuario por Documento
Busca un usuario por su número de documento.

**Uso en Flutter:**
```dart
final result = await apiService.getUserByDocument('1234567890');

if (result['success']) {
  final user = result['user'];
  print('Usuario encontrado: ${user['name']}');
}
```

**Request:**
- **Método**: `GET /users/document/{document}`
- **Headers**: `Content-Type: application/json`

**Response Success (200)**:
```json
{
  "success": true,
  "user": {
    "id": 1,
    "name": "Juan Pérez",
    "email": "juan@ejemplo.com",
    "document": "1234567890"
  }
}
```

---

### 8. Crear Usuario
Crea un nuevo usuario en el sistema (requiere autenticación de admin).

**Uso en Flutter:**
```dart
final result = await apiService.createUser({
  'name': 'Nuevo Usuario',
  'email': 'nuevo@ejemplo.com',
  'password': 'password123',
  'role': 'evaluador',
  'document': '9876543210'
});

if (result['success']) {
  print(result['message']); // 'user_created'
}
```

**Request:**
- **Método**: `POST /users`
- **Headers**: `Authorization: Bearer {token}`, `Content-Type: application/json`
- **Body**:
```json
{
  "name": "Nuevo Usuario",
  "email": "nuevo@ejemplo.com",
  "password": "password123",
  "role": "evaluador",
  "document": "9876543210"
}
```

**Response Success (201)**:
```json
{
  "success": true,
  "message": "user_created"
}
```

---

### 9. Actualizar Usuario
Actualiza la información de un usuario existente.

**Uso en Flutter:**
```dart
final result = await apiService.updateUser(1, {
  'name': 'Juan Pérez Actualizado',
  'email': 'juan.nuevo@ejemplo.com',
  'role': 'administrador'
});

if (result['success']) {
  print(result['message']); // 'user_updated'
}
```

**Request:**
- **Método**: `PUT /users/{id}`
- **Headers**: `Authorization: Bearer {token}`, `Content-Type: application/json`
- **Body**:
```json
{
  "name": "Juan Pérez Actualizado",
  "email": "juan.nuevo@ejemplo.com",
  "role": "administrador"
}
```

**Response Success (200)**:
```json
{
  "success": true,
  "message": "user_updated"
}
```

---

### 10. Eliminar Usuario
Elimina un usuario del sistema.

**Uso en Flutter:**
```dart
final result = await apiService.deleteUser(1);

if (result['success']) {
  print(result['message']); // 'user_deleted'
}
```

**Request:**
- **Método**: `DELETE /users/{id}`
- **Headers**: `Authorization: Bearer {token}`

**Response Success (204)**:
```json
{
  "success": true,
  "message": "user_deleted"
}
```

---

## 📊 EVALUACIONES (Backend Java - Puerto 8089)

### 11. Crear Reporte de Evaluación
Crea un nuevo reporte de evaluación de bienestar animal.

**Uso en Flutter:**
```dart
final result = await apiService.createEvaluationReport({
  'connection_status': 'online',
  'user_id': '12345',
  'evaluation_date': '2025-11-24',
  'language': 'es',
  'species': 'bovino',
  'farm_name': 'Granja El Ejemplo',
  'farm_location': 'Bogotá, Colombia',
  'evaluator_name': 'Juan Pérez',
  'status': 'completado',
  'overall_score': '85',
  'compliance_level': 'alto',
  'categories': {
    'feeding': {
      'score': '90',
      'responses': {
        'pregunta1': 'respuesta1',
        'pregunta2': 'respuesta2'
      }
    },
    'health': {
      'score': '85',
      'responses': {}
    },
    'behavior': {
      'score': '88',
      'responses': {}
    },
    'infrastructure': {
      'score': '80',
      'responses': {}
    },
    'management': {
      'score': '92',
      'responses': {}
    }
  },
  'critical_points': [
    {
      'punto': 'Descripción del punto crítico',
      'categoria': 'Salud'
    }
  ],
  'strong_points': [
    {
      'punto': 'Descripción del punto fuerte',
      'categoria': 'Alimentación'
    }
  ],
  'recommendations': [
    'Recomendación 1',
    'Recomendación 2'
  ]
});

if (result['success']) {
  print(result['message']); // 'Registro creado correctamente.'
}
```

**Request:**
- **Método**: `POST /animals/evaluation`
- **Base URL**: `EVALUATIONS_BASE_URL` (puerto 8089)
- **Headers**: `Content-Type: application/json`
- **Body**:
```json
{
  "connection_status": "online",
  "user_id": "12345",
  "evaluation_date": "2025-11-24",
  "language": "es",
  "species": "bovino",
  "farm_name": "Granja El Ejemplo",
  "farm_location": "Bogotá, Colombia",
  "evaluator_name": "Juan Pérez",
  "status": "completado",
  "overall_score": "85",
  "compliance_level": "alto",
  "categories": {
    "feeding": {
      "score": "90",
      "responses": {}
    },
    "health": {
      "score": "85",
      "responses": {}
    },
    "behavior": {
      "score": "88",
      "responses": {}
    },
    "infrastructure": {
      "score": "80",
      "responses": {}
    },
    "management": {
      "score": "92",
      "responses": {}
    }
  },
  "critical_points": [
    {
      "punto": "Descripción",
      "categoria": "Salud"
    }
  ],
  "strong_points": [
    {
      "punto": "Descripción",
      "categoria": "Alimentación"
    }
  ],
  "recommendations": [
    "Recomendación 1"
  ]
}
```

**Response Success (201)**:
```json
{
  "success": true,
  "message": "Registro creado correctamente."
}
```

**Response Error (400)**:
```json
{
  "success": false,
  "message": "validation_error"
}
```

---

### 12. Obtener Reporte por ID
Obtiene un reporte específico por su ID de evaluación.

**Uso en Flutter:**
```dart
final result = await apiService.getEvaluationById('abc123');

if (result['success']) {
  final evaluation = result['evaluation'];
  print('Granja: ${evaluation['farmName']}');
  print('Score: ${evaluation['overallScore']}%');
}
```

**Request:**
- **Método**: `GET /animals/evaluation/{evaluationId}`
- **Base URL**: `EVALUATIONS_BASE_URL` (puerto 8089)
- **Path Parameter**: `evaluationId` (String) - ID único del reporte

**Ejemplo**: `GET http://10.0.2.2:8089/animals/evaluation/abc123`

**Response Success (200)**:
```json
{
  "success": true,
  "evaluation": {
    "id": "mongoDBDocumentId",
    "userId": "12345",
    "evaluationId": "abc123",
    "evaluationDate": "2025-11-24",
    "language": "es",
    "species": "bovino",
    "farmName": "Granja El Ejemplo",
    "farmLocation": "Bogotá, Colombia",
    "evaluatorName": "Juan Pérez",
    "status": "completado",
    "overallScore": "85",
    "complianceLevel": "alto",
    "categories": {
      "feeding": {
        "score": "90",
        "responses": {}
      },
      "health": {
        "score": "85",
        "responses": {}
      },
      "behavior": {
        "score": "88",
        "responses": {}
      },
      "infrastructure": {
        "score": "80",
        "responses": {}
      },
      "management": {
        "score": "92",
        "responses": {}
      }
    },
    "criticalPoints": [
      {
        "punto": "Descripción",
        "categoria": "Salud"
      }
    ],
    "strongPoints": [
      {
        "punto": "Descripción",
        "categoria": "Alimentación"
      }
    ],
    "recommendations": [
      "Recomendación 1"
    ]
  }
}
```

**Response Error (404)**:
```json
{
  "success": false,
  "message": "evaluation_not_found"
}
```

---

### 13. Obtener Todos los Reportes de un Usuario
Obtiene todos los reportes de evaluación asociados a un usuario específico.

**Uso en Flutter:**
```dart
final result = await apiService.getAllUserEvaluationReports('12345');

if (result['success']) {
  final evaluations = result['evaluations'];
  final total = result['total'];

  print('Total de reportes: $total');
  for (var evaluation in evaluations) {
    print('Granja: ${evaluation['farmName']} - Score: ${evaluation['overallScore']}%');
  }
}
```

**Request:**
- **Método**: `GET /animals/evaluation/all/{userId}`
- **Base URL**: `EVALUATIONS_BASE_URL` (puerto 8089)
- **Path Parameter**: `userId` (String) - ID del usuario

**Ejemplo**: `GET http://10.0.2.2:8089/animals/evaluation/all/12345`

**Response Success (200)**:
```json
{
  "success": true,
  "evaluations": [
    {
      "id": "mongoDBDocumentId1",
      "userId": "12345",
      "evaluationId": "eval001",
      "evaluationDate": "2025-11-24",
      "farmName": "Granja 1",
      "overallScore": "85",
      ...
    },
    {
      "id": "mongoDBDocumentId2",
      "userId": "12345",
      "evaluationId": "eval002",
      "evaluationDate": "2025-11-23",
      "farmName": "Granja 2",
      "overallScore": "92",
      ...
    }
  ],
  "total": 2
}
```

**Response Error (404)**:
```json
{
  "success": false,
  "message": "user_not_found"
}
```

---

### 14. Obtener Reportes para Administradores
Obtiene reportes de evaluación para usuarios con permisos de administrador.

**Uso en Flutter:**
```dart
final result = await apiService.getAdminEvaluationReports(1);

if (result['success']) {
  final evaluations = result['evaluations'];
  final total = result['total'];

  print('Reportes disponibles para admin: $total');
}
```

**Request:**
- **Método**: `GET /animals/evaluation/users/{adminId}`
- **Base URL**: `EVALUATIONS_BASE_URL` (puerto 8089)
- **Path Parameter**: `adminId` (int) - ID del usuario administrador

**Ejemplo**: `GET http://10.0.2.2:8089/animals/evaluation/users/1`

**Response Success (200)**:
```json
{
  "success": true,
  "evaluations": [
    {
      "id": "mongoDBDocumentId",
      "userId": "12345",
      "evaluationId": "eval001",
      "evaluationDate": "2025-11-24",
      ...
    }
  ],
  "total": 1
}
```

---

## 🔄 SINCRONIZACIÓN (Reportes Offline)

### 15. Sincronizar Reporte Offline
Sincroniza un reporte creado en modo offline con el servidor.

**Uso en Flutter:**
```dart
final result = await apiService.syncOfflineReport({
  'user_id': '12345',
  'evaluation_date': '2025-11-24',
  'farm_name': 'Granja Local',
  'farm_location': 'Bogotá',
  'evaluator_name': 'Juan Pérez',
  'overall_score': 88.5,
  'categories': {...},
  // ... resto de datos
});

if (result['success']) {
  print('Reporte sincronizado exitosamente');
  final syncedData = result['data'];
}
```

**Request:**
- **Método**: `POST /evaluations/sync`
- **Headers**: `Content-Type: application/json`

**Response Success (201)**:
```json
{
  "success": true,
  "message": "report_synced",
  "data": {
    "id": "nuevoIdEnServidor",
    ...
  }
}
```

---

### 16. Obtener Evaluaciones del Usuario (con Paginación)
Obtiene los reportes del usuario actual con soporte de paginación.

**Uso en Flutter:**
```dart
final result = await apiService.getUserEvaluations(
  limit: 20,
  offset: 0
);

if (result['success']) {
  final evaluations = result['evaluations'];
  final total = result['total'];
  final hasMore = result['hasMore'];

  print('Mostrando ${evaluations.length} de $total reportes');
  if (hasMore) {
    // Cargar más reportes
    print('Hay más reportes disponibles');
  }
}
```

**Request:**
- **Método**: `GET /evaluations/user?limit={limit}&offset={offset}`
- **Headers**: `Authorization: Bearer {token}`
- **Query Parameters**:
  - `limit` (int): Número máximo de reportes a obtener
  - `offset` (int): Número de reportes a saltar

**Ejemplo**: `GET http://10.0.2.2:8081/evaluations/user?limit=20&offset=0`

**Response Success (200)**:
```json
{
  "success": true,
  "evaluations": [...],
  "total": 50,
  "hasMore": true
}
```

---

## 📝 Estructura de Datos

### Categorías de Evaluación
Todas las categorías tienen la misma estructura:

```json
{
  "score": "85",
  "responses": {
    "clave1": "valor1",
    "clave2": "valor2"
  }
}
```

**Categorías disponibles**:
- `feeding` (Alimentación)
- `health` (Salud)
- `behavior` (Comportamiento)
- `infrastructure` (Infraestructura)
- `management` (Gestión)

---

## 🚨 Códigos de Estado HTTP

| Código | Significado |
|--------|-------------|
| 200 | OK - Solicitud exitosa |
| 201 | Created - Recurso creado exitosamente |
| 204 | No Content - Eliminación exitosa |
| 400 | Bad Request - Datos inválidos |
| 401 | Unauthorized - Credenciales inválidas |
| 403 | Forbidden - Usuario no verificado |
| 404 | Not Found - Recurso no encontrado |
| 409 | Conflict - Recurso ya existe |
| 500 | Internal Server Error - Error del servidor |

---

## 🛠️ Ejemplos de Uso Completos

### Flujo de Login Completo
```dart
import 'package:bian_app/core/api/api_service.dart';
import 'package:bian_app/core/storage/secure_storage.dart';

class LoginExample {
  final apiService = ApiService();
  final storage = SecureStorage();

  Future<void> performLogin(String email, String password) async {
    // 1. Intentar login
    final result = await apiService.login(email, password);

    if (result['success']) {
      // 2. Guardar token y usuario
      final token = result['token'];
      final user = User.fromJson(result['user']);

      await storage.saveToken(token);
      await storage.saveUser(user);

      print('✅ Login exitoso: ${user.name}');

      // 3. Navegar a home
      // Navigator.pushReplacement(...);
    } else {
      final message = result['message'];

      switch (message) {
        case 'invalid_credentials':
          print('❌ Credenciales incorrectas');
          break;
        case 'user_not_verified':
          print('⚠️ Usuario no verificado');
          final email = result['email'];
          final userId = result['userId'];
          // Mostrar opción de reenviar email
          break;
        case 'connection_error':
          print('❌ Error de conexión');
          break;
        default:
          print('❌ Error: $message');
      }
    }
  }
}
```

### Flujo de Creación de Reporte
```dart
Future<void> createEvaluationReport(Evaluation evaluation) async {
  final apiService = ApiService();

  // 1. Preparar datos del reporte
  final reportData = {
    'connection_status': 'online',
    'user_id': evaluation.userId,
    'evaluation_date': evaluation.evaluationDate.toIso8601String().split('T')[0],
    'language': evaluation.language,
    'species': evaluation.speciesId,
    'farm_name': evaluation.farmName,
    'farm_location': evaluation.farmLocation,
    'evaluator_name': evaluation.evaluatorName,
    'status': evaluation.status,
    'overall_score': evaluation.overallScore.toString(),
    'compliance_level': evaluation.complianceLevel,
    'categories': _buildCategoriesMap(evaluation),
    'critical_points': evaluation.criticalPoints,
    'strong_points': evaluation.strongPoints,
    'recommendations': evaluation.recommendations,
  };

  // 2. Enviar al backend Java
  final result = await apiService.createEvaluationReport(reportData);

  if (result['success']) {
    print('✅ Reporte creado exitosamente');
    print(result['message']);
  } else {
    print('❌ Error creando reporte: ${result['message']}');
  }
}

Map<String, dynamic> _buildCategoriesMap(Evaluation evaluation) {
  return {
    'feeding': {
      'score': evaluation.categoryScores['feeding']?.toString() ?? '0',
      'responses': evaluation.getCategoryResponses('feeding'),
    },
    'health': {
      'score': evaluation.categoryScores['health']?.toString() ?? '0',
      'responses': evaluation.getCategoryResponses('health'),
    },
    'behavior': {
      'score': evaluation.categoryScores['behavior']?.toString() ?? '0',
      'responses': evaluation.getCategoryResponses('behavior'),
    },
    'infrastructure': {
      'score': evaluation.categoryScores['infrastructure']?.toString() ?? '0',
      'responses': evaluation.getCategoryResponses('infrastructure'),
    },
    'management': {
      'score': evaluation.categoryScores['management']?.toString() ?? '0',
      'responses': evaluation.getCategoryResponses('management'),
    },
  };
}
```

---

## 🔍 Tips y Mejores Prácticas

### 1. Manejo de Errores
Siempre verifica el campo `success` en la respuesta:
```dart
final result = await apiService.someMethod();
if (result['success']) {
  // Procesar datos exitosos
} else {
  // Manejar error según result['message']
}
```

### 2. Timeouts
Los timeouts están configurados en 15 segundos. Si necesitas más tiempo:
```dart
// En api_config.dart
static const Duration receiveTimeout = Duration(seconds: 30);
```

### 3. Logging
Todos los métodos tienen logging incorporado. Revisa la consola para debugging:
```
📤 POST /auth/login
📦 Body: {email: test@test.com, password: ***}
📥 Response status: 200
📥 Response body: {...}
```

### 4. Autenticación
Los métodos que requieren autenticación automáticamente agregan el header `Authorization`:
```dart
// No necesitas hacer esto manualmente
headers['Authorization'] = 'Bearer $token'; // ❌ Incorrecto

// El ApiService lo hace automáticamente
await apiService.getAllUsers(); // ✅ Correcto
```

---

## 📞 Soporte

Si encuentras problemas:
1. Verifica las variables de entorno en `.env`
2. Confirma que los puertos estén correctos
3. Revisa los logs en consola
4. Verifica que los backends estén corriendo

---

**Última actualización**: 2025-11-24
**Versión de la API**: 1.0.0
