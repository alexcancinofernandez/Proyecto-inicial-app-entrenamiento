ACTÚA COMO: Desarrollador Senior experto en Flutter, Dart, Firebase y Arquitectura MVVM.
OBJETIVO: Generar el plan de implementación COMPLETO, EJECUTABLE y DETALLADO para una app de entrenamiento/fitness multiplataforma, ejecutándose EXCLUSIVAMENTE en modo debug/local contra Firebase Emulator Suite.

━━━━━━━━━━━━━━━━━━━━━━━━━━
🔒 RESTRICCIONES NO NEGOCIABLES
━━━━━━━━━━━━━━━━━━━━━━━━━━
- ✅ Framework: Flutter + Dart SDK (canal estable)
- ✅ Backend: Firebase Console (Firestore + Auth)
- ✅ Autenticación: Email + Contraseña (Firebase Auth)
- 🚫 PROHIBIDO: Firebase Analytics, Crashlytics, Performance Monitoring, builds release, publicación en stores, o cualquier servicio de producción.
- ✅ Plataformas obligatorias: Android, iOS, Web, Windows
- ✅ Herramientas: VS Code, Firebase Emulator Suite (Auth + Firestore), emuladores nativos
- ✅ Formato de respuesta: Markdown, secciones numeradas, tablas obligatorias donde aplique, sin relleno ni preámbulos.

━━━━━━━━━━━━━━━━━━━━━━━━━━
🎨 UI/UX & COLORES (PRIMER PLANO)
━━━━━━━━━━━━━━━━━━━━━━━━━━
Diseño oscuro estricto. Fondo base: #0A0A0A. Mapea EXACTAMENTE estos colores en primer plano:
- Acento primario: #00E5FF (Cyan) → ElevatedButton, progress indicators, active chips, íconos principales
- Acento secundario: #3B82F6 (Azul) → BottomNavigationBar, cards, headers, dividers
- Éxito: #10B981 (Verde) → metas cumplidas, checkmarks, feedback positivo
- Alerta: #F97316 (Naranja) → errores, validaciones fallidas, CTAs secundarios
- Texto principal: #FFFFFF → títulos, body, labels activos
- Texto secundario: #CBD5E1 → descripciones, placeholders, metadatos
- Texto desactivado: #64748B → estados disabled, bordes inactivos
Principios: WCAG AA ≥4.5:1, touch targets ≥48x48px, espaciado en múltiplos de 8px, modo oscuro único, BottomNavigationBar fijo con 4 pestañas: Inicio, Rutinas, Social, Estadísticas.

━━━━━━━━━━━━━━━━━━━━━━━━━━
📂 ESTRUCTURA bin/ (CONTENIDO EXACTO)
━━━━━━━━━━━━━━━━━━━━━━━━━━
Crea la carpeta `bin/` con estos archivos y especifica su lógica:
1. setup_firebase_emulator.sh/.bat → Instala Firebase CLI, ejecuta `firebase init emulators`, descarga binarios Auth+Firestore, inicia en localhost
2. run_all_platforms.sh/.bat → Comandos `flutter run -d` para chrome, windows, android, ios-simulator con flags `--dart-define=USE_EMULATOR=true`
3. seed_firestore_emulator.dart → Script Dart que inserta datos iniciales (ejercicios públicos, logros, usuarios test) usando `firebase_admin` o REST al emulador
4. reset_emulator_data.dart → Limpia colecciones `users/`, `workouts/`, `measurements/`, `goals/`, `posts/` vía DELETE al emulador
5. generate_test_users.dart → Crea 5 usuarios de prueba con `firebase auth:emulators` o llamadas REST a Auth emulator
6. check_dependencies.dart → Valida versiones de Flutter, Dart, paquetes y conexión a localhost:8080/9099
7. README_scripts.md → Instrucciones de uso, permisos, troubleshooting

━━━━━━━━━━━━━━━━━━━━━━━━━━
📦 pubspec.yaml (INCLUIR EXACTAMENTE)
━━━━━━━━━━━━━━━━━━━━━━━━━━
name: fitness_app
description: 'App fitness multiplataforma. Solo debug/local. Sin analytics/producción.'
publish_to: 'none'
version: 1.0.0+1
environment:
  sdk: '>=3.3.0 <4.0.0'
  flutter: '>=3.19.0'
dependencies:
  flutter: {sdk: flutter}
  firebase_core: ^3.8.0
  firebase_auth: ^5.3.4
  cloud_firestore: ^5.5.1
  provider: ^6.1.2
  go_router: ^14.6.2
  google_fonts: ^6.2.1
  flutter_svg: ^2.0.10+1
  cached_network_image: ^3.4.1
  shimmer: ^3.0.0
  intl: ^0.19.0
  gap: ^3.0.1
  fl_chart: ^0.70.2
  uuid: ^4.5.1
  formz: ^0.8.0
  shared_preferences: ^2.3.3
  collection: ^1.19.0
  window_manager: ^0.4.2
  url_launcher: ^6.3.1
dev_dependencies:
  flutter_test: {sdk: flutter}
  flutter_lints: ^5.0.0
  mockito: ^5.4.4
  integration_test: {sdk: flutter}
flutter:
  uses-material-design: true

━━━━━━━━━━━━━━━━━━━━━━━━━━
🗃️ ENTIDADES & ATRIBUTOS (Firestore ↔ Dart)
━━━━━━━━━━━━━━━━━━━━━━━━━━
Mapea exactamente estas 12 entidades. Incluye tipos Dart, rutas Firestore, y campos anidados/array:
1. users/{uid} → usuario_id, nombre, apellido, email, fecha_nacimiento, genero, peso_kg, altura_cm, nivel_fitness (enum), foto_perfil_url, fecha_registro, activo
2. exercises/{id} → ejercicio_id, nombre, descripcion, grupo_muscular, tipo_ejercicio, equipo_necesario, imagen_url, video_url, es_publico, creado_por
3. routines/{id} → rutina_id, usuario_id, nombre, descripcion, objetivo, dias_por_semana, duracion_estimada_min, es_publica, fecha_creacion + ejercicios_asociados[]
4. ejercicios_asociados[] → rutina_ejercicio_id, ejercicio_id, orden, series, repeticiones, peso_sugerido_kg, descanso_seg, notas
5. users/{uid}/workouts/{id} → sesion_id, usuario_id, rutina_id, fecha_inicio, fecha_fin, duracion_real_min, calorias_quemadas, notas, estado (enum)
6. workouts/{id}.ejercicios[] → sesion_ejercicio_id, ejercicio_id, orden, series_registradas[]
7. series_registradas[] → serie_id, numero_serie, repeticiones_realizadas, peso_kg, duracion_seg, distancia_km, completada, notas
8. users/{uid}/measurements/{id} → medida_id, usuario_id, fecha, peso_kg, porcentaje_grasa, masa_muscular_kg, imc, pecho_cm, cintura_cm, cadera_cm, brazo_cm, pierna_cm
9. users/{uid}/goals/{id} → meta_id, usuario_id, tipo, descripcion, valor_objetivo, valor_actual, unidad, fecha_limite, estado (enum)
10. achievements/{id} → logro_id, nombre, descripcion, icono_url, condicion_tipo, condicion_valor
11. users/{uid}/unlocked/{logro_id} → usuario_logro_id, logro_id, fecha_obtenido
12. posts/{id} → post_id, autor_id, contenido, rutina_vinculada, fecha, likes[], comentarios[]

━━━━━━━━━━━━━━━━━━━━━━━━━━
⚙️ ARQUITECTURA PROVIDER
━━━━━━━━━━━━━━━━━━━━━━━━━━
- `main.dart` con `MultiProvider`: `AuthProvider`, `LocalStorageProvider` (shared_preferences), `ThemeNotifier` (dark fijo)
- Módulo scoped: `RoutineProvider`, `WorkoutProvider`, `StatsProvider`, `SocialProvider`, `ProfileProvider` (extienden `ChangeNotifier`)
- Flujo obligatorio: UI → Provider.method() → Repository → Firestore Emulator → Stream/Document → `notifyListeners()` → UI
- Uso estricto de `Selector` para rebuilds parciales y `Consumer` para secciones amplias
- Validación pre-Firestore con `formz`. Solo `isValid == true` persiste.
- Persistencia local: uid, última sesión activa, preferencias de unidades.
- Conexión emulador: `FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080)` y Auth en 9099 si `kDebugMode`.

━━━━━━━━━━━━━━━━━━━━━━━━━━
📅 FASES DE DESARROLLO (7 FASES)
━━━━━━━━━━━━━━━━━━━━━━━━━━
Detalla paso a paso, en orden:
FASE 1: Configuración multiplataforma, init Flutter, estructura bin/lib, firebase.json emulator-only, tema global, go_router base, MultiProvider vacío.
FASE 2: Auth screens, AuthProvider, formz validation, users/{uid} creation, perfil editable, persistencia sesión, password reset.
FASE 3: Modelos Exercise/Routine, UI exploración con filtros, CRUD rutinas, array embebido, paginación, cache, visibilidad pública/privada.
FASE 4: Workout anidado, pantalla activa (temporizador, inputs por serie), guardado incremental, borrador offline, cálculo volumen/duración, historial.
FASE 5: Medidas corporales, sistema metas, StatsProvider agregaciones, fl_chart (líneas, radar, barras), logros desbloqueables, optimización consultas.
FASE 6: Modelo Post, feed infinito paginado, likes/comments (arrayUnion/Remove), vinculación rutinas, filtros categoría, permisos emulador.
FASE 7: flutter test + integration_test contra emulador, validación offline/sync, accesibilidad WCAG/touch targets, builds debug por plataforma, documentación.

━━━━━━━━━━━━━━━━━━━━━━━━━━
📤 FORMATO DE ENTREGA OBLIGATORIO
━━━━━━━━━━━━━━━━━━━━━━━━━━
- Responde en Markdown con secciones numeradas (1, 2, 3...)
- Usa tablas para stack, dependencias, entidades, fases y UI/UX
- Incluye fragmentos de código clave cuando sea necesario (firebase.json, reglas Firestore test, main.dart setup, Provider base)
- NO omitas NINGUNA entidad, dependencia, fase, color, script de bin/, ni principio de diseño
- Mantén coherencia estricta entre modelos Dart y estructura Firestore
- Reglas de Firestore SOLO para entorno de prueba (request.auth.uid == uid)

## PLAN DE IMPLEMENTACION V2:
# 1. Stack y Entorno de Ejecución
| Componente | Versión/Configuración | Notas |
|---|---|---|
| Flutter SDK | `stable >=3.19.0` | Canal estable obligatorio |
| Dart SDK | `>=3.3.0 <4.0.0` | Pattern matching & records habilitados |
| Firebase Core | `^3.8.0` | Inicialización local |
| Emulator Suite | `auth` + `firestore` | Puertos `9099` y `8080` |
| Plataformas | Android, iOS, Web, Windows | Flags `--dart-define=USE_EMULATOR=true` |
| IDE | VS Code | Extensiones: Dart, Flutter, Firebase |

# 2. Estructura `bin/` y Lógica de Scripts
| Archivo | Lógica / Comandos Clave |
|---|---|
| `bin/setup_firebase_emulator.sh` / `.bat` | `firebase init emulators` → `firebase emulators:download` → `firebase emulators:start --only auth,firestore --export-on-exit=./firebase-data` |
| `bin/run_all_platforms.sh` / `.bat` | Ejecuta secuentemente: `flutter run -d chrome --dart-define=USE_EMULATOR=true`, `flutter run -d windows --dart-define=USE_EMULATOR=true`, `flutter run -d <android_device> --dart-define=USE_EMULATOR=true`, `flutter run -d <ios_simulator> --dart-define=USE_EMULATOR=true` |
| `bin/seed_firestore_emulator.dart` | Conecta a `http://localhost:8080/emulator/v1/projects/<project_id>/database/(default)/documents`. Ejecuta POST masivos para `exercises/{id}`, `achievements/{id}`, `posts/{id}`. |
| `bin/reset_emulator_data.dart` | DELETE a `http://localhost:8080/emulator/v1/projects/<project_id>/databases/(default)/documents/<colección>/*` vía REST. Limpia `users/`, `workouts/`, `measurements/`, `goals/`, `posts/`. |
| `bin/generate_test_users.dart` | Llama a `http://localhost:9099/identitytoolkit.googleapis.com/v1/accounts:signUp`. Crea 5 credenciales email/pass. Asigna `uid` estático y vincula a `users/{uid}`. |
| `bin/check_dependencies.dart` | Ejecuta `flutter doctor -v`, `dart pub get`. Verifica `ping localhost:8080` y `localhost:9099`. Sale con código `0` si todo pasa, `1` si falla. |
| `bin/README_scripts.md` | Permisos (`chmod +x`), variables `.env.local`, resolución de puertos ocupados, flags de depuración VS Code. |

# 3. Configuración de Dependencias (`pubspec.yaml`)
```yaml
name: fitness_app
description: 'App fitness multiplataforma. Solo debug/local. Sin analytics/producción.'
publish_to: 'none'
version: 1.0.0+1
environment:
  sdk: '>=3.3.0 <4.0.0'
  flutter: '>=3.19.0'
dependencies:
  flutter: {sdk: flutter}
  firebase_core: ^3.8.0
  firebase_auth: ^5.3.4
  cloud_firestore: ^5.5.1
  provider: ^6.1.2
  go_router: ^14.6.2
  google_fonts: ^6.2.1
  flutter_svg: ^2.0.10+1
  cached_network_image: ^3.4.1
  shimmer: ^3.0.0
  intl: ^0.19.0
  gap: ^3.0.1
  fl_chart: ^0.70.2
  uuid: ^4.5.1
  formz: ^0.8.0
  shared_preferences: ^2.3.3
  collection: ^1.19.0
  window_manager: ^0.4.2
  url_launcher: ^6.3.1
dev_dependencies:
  flutter_test: {sdk: flutter}
  flutter_lints: ^5.0.0
  mockito: ^5.4.4
  integration_test: {sdk: flutter}
flutter:
  uses-material-design: true
```

# 4. Mapeo de Entidades (Firestore ↔ Dart)
| # | Ruta Firestore | Modelo Dart (Campos) | Estructura Anidada/Array |
|---|---|---|---|
| 1 | `users/{uid}` | `Usuario(uid, nombre, apellido, email, fechaNacimiento, genero, pesoKg, alturaCm, nivelFitness, fotoPerfilUrl, fechaRegistro, activo)` | - |
| 2 | `exercises/{id}` | `Ejercicio(ejercicioId, nombre, descripcion, grupoMuscular, tipoEjercicio, equipoNecesario, imageUrl, videoUrl, esPublico, creadoPor)` | - |
| 3 | `routines/{id}` | `Rutina(rutinaId, usuarioId, nombre, descripcion, objetivo, diasPorSemana, duracionEstimadaMin, esPublica, fechaCreacion)` | `List<RutinaEjercicio> ejerciciosAsociados` |
| 4 | `routines/{id}.ejerciciosAsociados` | `RutinaEjercicio(rutinaEjercicioId, ejercicioId, orden, series, repeticiones, pesoSugeridoKg, descansoSeg, notas)` | Embedido en doc `routines/{id}` |
| 5 | `users/{uid}/workouts/{id}` | `Sesion(sesionId, usuarioId, rutinaId, fechaInicio, fechaFin, duracionRealMin, caloriasQuemadas, notas, estado)` | `List<SesionEjercicio> ejercicios` |
| 6 | `users/{uid}/workouts/{id}.ejercicios` | `SesionEjercicio(sesionEjercicioId, ejercicioId, orden, seriesRegistradas)` | Embedido en subcolección |
| 7 | `users/{uid}/workouts/{id}.ejercicios[].seriesRegistradas` | `Serie(sesionSerieId, numeroSerie, repeticionesRealizadas, pesoKg, duracionSeg, distanciaKm, completada, notas)` | Embedido |
| 8 | `users/{uid}/measurements/{id}` | `Medida(medidaId, usuarioId, fecha, pesoKg, porcentajeGrasa, masaMuscularKg, imc, pechoCm, cinturaCm, caderaCm, brazoCm, piernaCm)` | - |
| 9 | `users/{uid}/goals/{id}` | `Meta(metaId, usuarioId, tipo, descripcion, valorObjetivo, valorActual, unidad, fechaLimite, estado)` | - |
| 10 | `achievements/{id}` | `Logro(logroId, nombre, descripcion, iconoUrl, condicionTipo, condicionValor)` | - |
| 11 | `users/{uid}/unlocked/{logroId}` | `UsuarioLogro(usuarioLogroId, logroId, fechaObtenido)` | Subcolección bajo `users` |
| 12 | `posts/{id}` | `Post(postId, autorId, contenido, rutinaVinculada, fecha)` | `List<String> likes`, `List<Comentario> comentarios` |

# 5. Especificaciones UI/UX y Paleta de Colores
| Elemento | Hex | Aplicación UI |
|---|---|---|
| Fondo Base | `#0A0A0A` | `Scaffold.backgroundColor`, pantallas completas |
| Acento Primario | `#00E5FF` (Cyan) | `ElevatedButton`, `LinearProgressIndicator`, `Chip` activos, íconos principales |
| Acento Secundario | `#3B82F6` (Azul) | `BottomNavigationBar` (active/inactive), `Card` background, `AppBar`/Headers, `Divider` |
| Éxito | `#10B981` (Verde) | Checkmarks, metas cumplidas, feedback positivo, bordes `TextField` válido |
| Alerta | `#F97316` (Naranja) | Mensajes error, validación fallida `Formz`, CTAs secundarios, estados de advertencia |
| Texto Principal | `#FFFFFF` | `TextTheme.display/body/label`, títulos, labels activos |
| Texto Secundario | `#CBD5E1` | Descripciones, `InputDecoration.hintText`, metadatos, timestamps |
| Texto Desactivado | `#64748B` | Estados `disabled`, bordes inactivos, placeholders apagados |

**Reglas de Diseño:**
- Contraste WCAG AA ≥4.5:1 verificado en todos los pares texto/fondo.
- `minHeight: 48.0` y `minWidth: 48.0` en todos los `GestureDetector`, `IconButton`, `ElevatedButton`.
- `EdgeInsets` en múltiplos de `8.0` (`8, 16, 24, 32`).
- Modo oscuro único. `ThemeMode.dark` forzado.
- `BottomNavigationBar` fijo, 4 items: `Inicio`, `Rutinas`, `Social`, `Estadísticas`.

# 6. Arquitectura MVVM + Provider & Configuración `main.dart`
**Flujo Obligatorio:** `UI Widget` → `Provider.method(formzState)` → `if (formzState.isValid == true)` → `Repository` → `Firestore Emulator (Stream/Set)` → `notifyListeners()` → `Selector/Consumer` rebuild.

```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:provider/provider.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/local_storage_provider.dart';
import 'providers/theme_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "test", projectId: "test", messagingSenderId: "test", appId: "1:test"
    ),
  );

  if (kDebugMode && const bool.fromEnvironment('USE_EMULATOR', defaultValue: false)) {
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  }

  runApp(const FitnessApp());
}

class FitnessApp extends StatelessWidget {
  const FitnessApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocalStorageProvider()),
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // Módulos scoped se inyectan vía router o lazy en pantallas específicas
      ],
      child: const _AppWithThemeAndRouter(),
    );
  }
}

class _AppWithThemeAndRouter extends StatelessWidget {
  const _AppWithThemeAndRouter();
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      routerConfig: AppRouter.router,
      title: 'Fitness App (Debug)',
    );
  }
}
```

# 7. Fases de Implementación
| Fase | Tarea | Entregable Técnico |
|---|---|---|
| **FASE 1** | Configuración multiplataforma, init Flutter, estructura `lib/` (models, views, viewmodels/providers, repositories), `firebase.json` (emuladores-only), `ThemeData` estricto, `go_router` base, `MultiProvider` vacío. | `firebase.json` configurado, `AppTheme` con paleta, router con 4 tabs, build correcto en 4 plataformas. |
| **FASE 2** | Auth screens, `AuthProvider`, `formz` validation (email/pass), creación `users/{uid}`, perfil editable, persistencia `uid`/unidades, password reset emulado. | `AuthRepository` (signIn/signUp/reset), `Formz` mixin en inputs, `LocalStorageProvider` guardado, `Selector<AuthProvider>` controla acceso. |
| **FASE 3** | Modelos `Exercise`/`Routine`, UI exploración con filtros, CRUD rutinas, array `ejercicios_asociados[]`, paginación (`startAfterDocument`), cache local, visibilidad pública/privada. | `RoutineProvider` con `StreamProvider`, UI lista filtrable, `Formz` validación arrays, `FirestoreRepository.routines()`. |
| **FASE 4** | Workout anidado, pantalla activa (temporizador `Ticker`, inputs por serie), guardado incremental (`setDoc` batch), borrador offline (`shared_preferences`), cálculo volumen/duración, historial. | `WorkoutProvider`, `Sesion` model con subcolección, lógica de `completada`, `Consumer` para actualizaciones en tiempo real durante sesión. |
| **FASE 5** | Medidas corporales, sistema metas (`goals/`), `StatsProvider` agregaciones (`FieldValue.increment`, queries con `where`), `fl_chart` (líneas progreso, radar grupos, barras volumen), logros desbloqueables, optimización consultas. | `StatsProvider` con `FutureBuilder` optimizado, `fl_chart` widgets encapsulados, trigger lógico de `unlocked/` al cumplir condición. |
| **FASE 6** | Modelo `Post`, feed infinito paginado, likes/comments (`arrayUnion`/`Remove`), vinculación rutinas (`rutina_vinculada`), filtros categoría, permisos emulador. | `SocialProvider`, `PaginatedDataTable`/`ListView.builder` con `DocumentSnapshot` cursor, reglas `allow write: if request.auth.uid == resource.data.autor_id`. |
| **FASE 7** | `flutter test` + `integration_test` contra emulador, validación offline/sync (`Connectivity` simulada + retry), accesibilidad `Semantics`/WCAG/touch targets, builds debug por plataforma, documentación `bin/README_scripts.md`. | Suite tests ejecutados, `flutter build apk --debug`, `flutter build web`, `flutter build windows --debug`, informe cobertura, accesibilidad validada. |

# 8. Reglas de Seguridad Firestore (Solo Entorno Prueba)
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Colecciones globales públicas
    match /exercises/{id} {
      allow read: if true;
    }
    match /achievements/{id} {
      allow read: if true;
    }
    
    // Usuarios y subcolecciones
    match /users/{userId} {
      allow create, read: if request.auth != null;
      allow update, delete: if request.auth.uid == userId;
      
      match /workouts/{workoutId} {
        allow read, write: if request.auth.uid == userId;
      }
      match /measurements/{measurementId} {
        allow read, write: if request.auth.uid == userId;
      }
      match /goals/{goalId} {
        allow read, write: if request.auth.uid == userId;
      }
      match /unlocked/{logroId} {
        allow read, write: if request.auth.uid == userId;
      }
    }

    // Posts
    match /posts/{postId} {
      allow read: if true;
      allow create: if request.auth != null;
      allow update: if request.auth.uid == resource.data.autor_id;
      allow delete: if request.auth.uid == resource.data.autor_id;
    }

    // Rutinas
    match /routines/{routineId} {
      allow read: if true;
      allow write: if request.auth.uid == resource.data.usuario_id || request.auth != null && request.resource.data.usuario_id == request.auth.uid;
    }
  }
}
```

# 9. Validación, Testing y Ejecución
- **Flujo de ejecución local:**
  1. `bin/setup_firebase_emulator.sh` (inicia Auth `9099` + Firestore `8080`)
  2. `bin/seed_firestore_emulator.dart` → pobla `exercises`, `achievements`
  3. `bin/generate_test_users.dart` → genera 5 cuentas
  4. `flutter run -d windows --dart-define=USE_EMULATOR=true` (o plataforma equivalente)
- **Testing Automatizado:**
  - `flutter test test/unit/` → Validaciones `formz`, lógica `Provider`, cálculos `StatsProvider`
  - `flutter test integration_test/app_test.dart` → Navegación router, Auth flow, CRUD rutinas contra `localhost:8080`
  - Mock de `FirebaseFirestore.instance` deshabilitado en tests `integration` reales; se conecta directamente al emulador.
- **Accesibilidad & UX:**
  - `Semantics` explícitos en `IconButton` y `ListTile`.
  - `focusNode` en formularios.
  - `kMinInteractiveDimension = 48.0`.
  - Espaciado estricto `8.0`px grid.
  - Cero transiciones innecesarias, dark mode fijo, contraste verificado.
- Cero menciones a producción, analytics, o servicios externos.

Genera el plan completo ahora.
