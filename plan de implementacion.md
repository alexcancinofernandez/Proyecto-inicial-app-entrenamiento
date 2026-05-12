# 📱 Plan de Implementación: App de Entrenamiento (Flutter + Firebase)

> **Nota preliminar:** Este documento es un **plan estratégico y procedural**. No contiene código, solo arquitectura, flujos, dependencias y pasos de desarrollo. Se asume que "Antigravity" fue un error tipográfico y se refiere a **Android Studio** (ambos IDEs son válidos, pero el plan está optimizado para VS Code por su ligereza y ecosistema Flutter).

---

## 1. 🛠️ Herramientas y Entorno de Desarrollo
| Categoría | Herramienta |
|-----------|-------------|
| **SDK/Framework** | Flutter (canal estable) + Dart SDK |
| **IDE Principal** | VS Code (recomendado) con extensiones: `Flutter`, `Dart`, `Pubspec Assist`, `Firebase Explorer`, `Error Lens` |
| **IDE Alternativo** | Android Studio (con plugins oficiales Flutter/Dart) |
| **Control de Versiones** | Git + GitHub/GitLab |
| **Diseño UI/UX** | Figma o Penpot (wireframes, prototipos interactivos, sistema de componentes) |
| **Backend/Cloud** | Firebase Console + Firebase CLI |
| **Emulación/Pruebas** | Android Emulator, iOS Simulator, dispositivos físicos (mínimo 1 Android + 1 iOS) |

---

## 2. 🎨 Diseño UI/UX (Fase Pre-Código)
1. **Definir identidad visual**: paleta energética pero legible, tipografía escalable, soporte nativo para modo claro/oscuro.
2. **Mapear flujos de usuario**:
   - Onboarding → Login/Registro → Home (Dashboard) → Navegación inferior: `Rutinas` | `Social` | `Estadísticas` | `Perfil`
3. **Diseñar componentes reutilizables**: tarjetas de rutina, inputs de series/reps/peso, botones de acción, estados de carga/vacío/error, gráficos interactivos.
4. **Validar accesibilidad**: contraste WCAG, tamaños de texto dinámicos, navegación por teclado/lector de pantalla.
5. **Prototipado interactivo**: probar flujos antes de implementar para reducir retrabajo.

---

## 3. 🏗️ Arquitectura y Gestión de Estado
- **Patrón**: Clean Architecture simplificada (Capas: `data` → `domain` → `presentation`)
- **State Management**: `provider` (según requerimiento)
- **Estructura de carpetas recomendada**:
  ```
  lib/
  ├── core/ (temas, constantes, utils, router, errores globales)
  ├── features/
  │   ├── auth/
  │   ├── routines/
  │   ├── workouts/
  │   ├── social/
  │   └── stats/
  ├── shared/ (widgets comunes, modelos base, providers globales)
  └── main.dart
  ```
- **Navegación**: `go_router` o navegación declarativa con Provider para control de rutas autenticadas/no autenticadas.
- **Gestión de sesiones**: Provider escucha `FirebaseAuth.instance.authStateChanges()` y redirige automáticamente.

---

## 4. 🔥 Configuración de Firebase
1. Crear proyecto en Firebase Console.
2. Habilitar **Authentication** → Método `Email/Password`.
3. Crear **Firestore Database** → Iniciar en modo prueba (luego migrar a reglas estrictas).
4. (Opcional) Habilitar **Storage** para fotos de perfil o imágenes de rutinas.
5. Generar archivos de configuración:
   - Android: `google-services.json`
   - iOS: `GoogleService-Info.plist`
6. Inicializar Firebase en `main.dart` antes de ejecutar la app.
7. Configurar reglas de seguridad iniciales y planificar migración a producción.

---

## 5. 🗃️ Estructura de Base de Datos (Firestore)
| Colección | Campos principales | Propósito |
|-----------|-------------------|-----------|
| `users/{uid}` | nombre, email, fecha_registro, preferencias_unidades, foto_url | Perfil y configuración global |
| `routines/{id}` | titulo, descripcion, creador_uid, ejercicios[], nivel, tags, fecha_creacion, visibilidad | Plantillas de entrenamiento |
| `workouts/{id}` | usuario_uid, rutina_id (o custom), fecha, duracion, ejercicios_log[], notas, volumen_total | Registro real de sesiones |
| `social_posts/{id}` | autor_uid, texto, imagen_url, rutina_vinculada, fecha, likes[], comentarios[] | Feed social y compartir progreso |
| `statistics/{uid}` | (documento agregado) total_workouts, racha_actual, peso_max_historico, frecuencia_semanal | Dashboard de métricas (calculado o cacheado) |

**Notas de diseño**:
- Usar subcolecciones solo si se espera alto volumen de datos anidados (ej. `social_posts/{id}/comments`).
- Crear índices compuestos para queries de filtrado + ordenamiento.
- Validar estructura en cliente antes de enviar a Firestore.

---

## 6. 📦 Dependencias (`pubspec.yaml`)
*(Lista conceptual con propósito de uso)*

| Categoría | Paquete | Función |
|-----------|---------|---------|
| **Core Firebase** | `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage` | Backend, autenticación, datos, archivos |
| **Estado** | `provider` | Gestión de estado reactivo |
| **Navegación** | `go_router` | Enrutamiento declarativo y protegido |
| **UI/UX** | `google_fonts`, `flutter_svg`, `cached_network_image`, `shimmer`, `intl` | Tipografía, iconos, imágenes, loaders, formateo |
| **Gráficos** | `fl_chart` | Estadísticas visuales (líneas, barras, radar) |
| **Utilidades** | `uuid`, `formz` o `form_field_validator`, `shared_preferences` | IDs únicos, validación de formularios, cache local |
| **Dev/Test** | `flutter_lints`, `mockito`, `flutter_test` | Calidad de código, pruebas unitarias/widget |

---

## 7. 📋 Plan de Implementación Paso a Paso

### 🔹 Fase 1: Cimiento y Configuración
1. Crear proyecto Flutter, configurar Git y estructura de carpetas.
2. Añadir dependencias iniciales en `pubspec.yaml` y ejecutar `flutter pub get`.
3. Configurar Firebase (Console + CLI + archivos de configuración).
4. Inicializar Firebase y Firebase Auth en `main.dart`.
5. Implementar tema global, tipografía, paleta de colores y sistema de rutas base.
6. Configurar Provider global para autenticación y estado de carga.

### 🔹 Fase 2: Autenticación y Perfil
1. Diseñar pantallas: Login, Registro, Recuperar contraseña, Validación de email (opcional).
2. Conectar formularios con `firebase_auth` mediante un `AuthProvider`.
3. Manejar estados: éxito, error, carga, validación en tiempo real.
4. Al crear usuario, generar documento en `users/{uid}` con datos básicos.
5. Implementar persistencia de sesión y cierre seguro.
6. Añadir pantalla de perfil (edición básica, unidades, foto).

### 🔹 Fase 3: Módulo de Rutinas
1. Definir modelo `Routine` y `Exercise`.
2. Crear UI: lista de rutinas, vista detalle, formulario de creación/edición.
3. Implementar CRUD en Firestore con validaciones.
4. Añadir lógica de "Usar rutina" → prepara estructura para registrar entrenamiento.
5. Optimizar queries: paginación, filtros por nivel/tags, búsqueda.
6. Manejar estados vacíos y errores de red.

### 🔹 Fase 4: Registro de Entrenamientos (Workouts)
1. Definir modelo `Workout` vinculado a `Routine` o creación libre.
2. Diseñar UI de sesión activa: temporizador, inputs por ejercicio, guardado automático/borrador.
3. Implementar lógica de cálculo de volumen, duración y progreso en tiempo real.
4. Guardar en Firestore con transacciones o escrituras batch para consistencia.
5. Añadir historial de entrenamientos con filtros por fecha/rutina.

### 🔹 Fase 5: Sección Social
1. Definir modelo `SocialPost` y estructura de interacciones.
2. Crear UI: feed infinito, formulario de publicación, vista de detalles.
3. Implementar paginación con `limit()` + `startAfter()` para rendimiento.
4. Añadir likes y comentarios (subcolección o array según volumen esperado).
5. Permitir compartir rutinas/entrenamientos como posts.
6. (Opcional) Integrar notificaciones push básicas con Firebase Cloud Messaging.

### 🔹 Fase 6: Estadísticas y Dashboard
1. Definir métricas clave: frecuencia semanal, racha, volumen progresivo, ejercicios más usados.
2. Implementar queries agregadas o cálculo en cliente con caching local.
3. Diseñar pantallas: resumen mensual/semanal, gráficos interactivos, comparativas.
4. Añadir exportación o visualización de tendencias.
5. Optimizar rendimiento: evitar lecturas masivas en tiempo real, usar `StreamBuilder` solo donde sea crítico.

### 🔹 Fase 7: Pulido, Optimización y Preparación para Producción
1. Añadir animaciones sutiles, transiciones entre pantallas, manejo global de errores.
2. Implementar modo oscuro/claro, accesibilidad completa.
3. Optimizar imágenes, lazy loading, cache local con `shared_preferences` o `hive`.
4. Revisar y endurecer reglas de seguridad de Firestore y Storage.
5. Preparar metadatos para stores: iconos, splash, permisos, política de privacidad.

---

## 8. 🧪 Pruebas y Despliegue
| Tipo | Herramienta/Método | Objetivo |
|------|-------------------|----------|
| **Unitarias** | `flutter test` + `mockito` | Validar modelos, lógica de negocio, cálculos de stats |
| **Widget** | `pumpWidget` + `find` | Verificar UI, estados, navegación, validaciones |
| **Integración** | `integration_test` + Firebase Emulator Suite | Flujos completos autenticación → rutina → stats |
| **QA Real** | Dispositivos físicos Android/iOS | Rendimiento, batería, modo offline parcial, gestos |
| **Despliegue** | Play Console + App Store Connect | Publicación, actualizaciones, rollbacks |
| **Monitoreo** | Crashlytics + Performance + Analytics | Detección de fallos, métricas de uso, optimización continua |

---

## 9. ✅ Recomendaciones Clave para el Desarrollo
1. **Reglas de Firestore**: Nunca publiques en modo "test". Define reglas por colección con `request.auth != null`.
2. **Índices**: Declara índices compuestos en la consola o vía CLI para evitar errores `failed-precondition`.
3. **Offline**: Firestore cachea automáticamente. Diseña UI que tolere latencia y muestre estados sincronizados.
4. **Escalabilidad**: Si el feed social crece, considera Cloud Functions para agregar métricas o moderar contenido.
5. **Legal**: Incluye Política de Privacidad y Términos de Uso antes de subir a stores (obligatorio para apps con cuentas).
6. **Iteración**: Desarrolla en branches por feature, usa PRs, y valida cada módulo antes de pasar al siguiente.

---

📌 **Siguiente paso recomendado**: Una vez validado este plan, puedo generar el esqueleto del proyecto, la estructura de `pubspec.yaml` lista para copiar, o el código modular de cualquier fase (Auth, Rutinas, Provider, etc.). Indica por dónde deseas comenzar.
