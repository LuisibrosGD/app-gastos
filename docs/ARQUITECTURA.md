# App Gastos — Arquitectura

> **Cómo** está construida la app. El **qué** está en [SPEC.md](SPEC.md).
> Cualquier cambio de stack o de estructura se anota primero aquí (lo hace Claude Code).

**Última actualización:** 2026-11-11

## 1. Stack

| Capa | Tecnología |
|---|---|
| Lenguaje / framework | Dart + Flutter (canal stable) |
| IDE | Android Studio con los plugins de Flutter y Dart |
| Plataforma objetivo | Android (minSdk 23) |
| Base de datos | Drift (SQLite) + `drift_flutter` |
| Estado e inyección de dependencias | Riverpod (`flutter_riverpod`, `riverpod_annotation` + `riverpod_generator`) |
| Navegación | `go_router` |
| Idiomas | `flutter_localizations` + `intl` (archivos ARB) |
| Gráficos | `fl_chart` |
| Biometría | `local_auth` |
| Almacenamiento seguro | `flutter_secure_storage` (hash del PIN) |
| Preferencias | `shared_preferences` |
| Notificaciones | `flutter_local_notifications` |
| Generación de código | `build_runner` |
| Tests | `flutter_test`, `drift` con base en memoria (`NativeDatabase.memory()`) |
| Lint | `flutter_lints` |

Las versiones exactas se fijan en `pubspec.yaml` en la tarea de inicialización. No se añaden dependencias fuera de esta tabla sin actualizar antes este documento.

## 2. Estructura de carpetas

```
lib/
  main.dart                → arranque: ProviderScope + App
  app.dart                 → MaterialApp.router, tema, localización
  core/
    database/              → AppDatabase, conversores, migraciones
    router/                → rutas go_router y guarda de bloqueo
    theme/                 → colores, tipografía y espaciados (desde Figma)
    l10n/                  → app_es.arb, app_en.arb
    utils/                 → formato de moneda (céntimos ↔ S/) y de fechas
  features/
    onboarding/  inicio/  movimientos/  categorias/
    presupuesto/ recurrentes/ resumen/  seguridad/  ajustes/
      data/        → tablas Drift (*_table.dart) y repositorio (*_repository.dart)
      domain/      → lógica pura sin Flutter (solo si hace falta; p. ej. cálculo de recurrentes)
      providers/   → providers de Riverpod
      ui/          → pantallas (*_screen.dart) y widgets
test/                      → reflejo de lib/ (mismas rutas, sufijo _test.dart)
docs/                      → SPEC, ARQUITECTURA, tareas
```

## 3. Capas y reglas de dependencia

```
ui  →  providers  →  repository  →  Drift (AppDatabase)
                  ↘  domain (lógica pura)
```

1. **UI** solo lee y escribe a través de providers. Nunca importa Drift ni repositorios.
2. **Providers** exponen estado (`AsyncValue`) y acciones. Llaman a repositorios y a `domain`.
3. **Repositorios** son los únicos que tocan `AppDatabase`. Devuelven modelos de Drift o `Stream`s.
4. **Domain** es Dart puro, testeable sin Flutter.
5. Una feature puede usar el `data/` o los `providers/` de otra, nunca su `ui/`.
6. Ningún texto visible queda escrito en el código: todo va en los ARB.
7. Ningún color, tamaño de fuente o espaciado queda escrito suelto: todo sale de `core/theme`.
8. Un archivo de más de unas 300 líneas se divide.

## 4. Modelo de datos

Los montos son **enteros en céntimos** (S/ 12.50 → `1250`). Las fechas de los movimientos se guardan como `DateTime` a medianoche local. Los enums se guardan con `textEnum`.

**categorias**: `id` PK · `nombre` text(1–30) · `icono` text (clave del set fijo) · `color` int (ARGB) · `tipo` enum{gasto, ingreso} · `archivada` bool = false

**movimientos**: `id` PK · `tipo` enum · `montoCentimos` int > 0 · `fecha` date · `categoriaId` FK → categorias · `nota` text? (≤ 200) · `recurrenteId` FK → recurrentes? · `creadoEn` datetime

**presupuestos**: `id` PK · `categoriaId` FK? UNIQUE (null = total; como máximo uno) · `montoCentimos` int > 0

**recurrentes**: `id` PK · `tipo` enum · `montoCentimos` int > 0 · `categoriaId` FK · `nota` text? · `frecuencia` enum{mensual, semanal} · `dia` int (mensual 1–31, semanal 1 = lunes … 7 = domingo) · `fechaInicio` date · `ultimaGeneracion` date? · `activo` bool

**alertasEnviadas**: `presupuestoId` FK · `mes` text `YYYY-MM` · `umbral` int {80, 100} · PK (presupuestoId, mes, umbral)

**Índices:** `movimientos(fecha)`, `movimientos(categoriaId)`.

**Fuera de la base:**
- `shared_preferences`: `idioma`, `onboardingCompleto`, `bloqueoActivo`, `usarHuella`.
- `flutter_secure_storage`: `pinHash` y `pinSal` (SHA-256 con sal aleatoria de 16 bytes).

**Migraciones:** `schemaVersion` empieza en 1. Cada cambio de esquema sube la versión y añade un paso en `MigrationStrategy`, nunca se borra la base.

## 5. Componentes transversales

- **Arranque** (`main.dart`): abre la base → si el onboarding no está completo, va a P02 → genera los recurrentes pendientes → si el bloqueo está activo, va a P01 → Inicio.
- **Ciclo de vida:** un `AppLifecycleListener` registra cuándo la app pasa a segundo plano; al volver, genera los recurrentes y, si pasaron más de 60 s y el bloqueo está activo, muestra P01.
- **Router:** un `redirect` global aplica las reglas de onboarding y bloqueo.
- **Servicio de alertas** (`features/presupuesto`): lo llaman el repositorio de movimientos después de crear o editar un gasto, y el generador de recurrentes.
- **Formato:** `formatSoles(int centimos)` → `S/ 1,234.50`; `parseSoles(String)` → céntimos o error.

## 6. Diseño (Figma → código)

- El diseño vive en Figma y lo genera Command Code mediante el MCP de Figma.
- Los tokens (colores, tipografía, radios, espaciados) se trasladan a `core/theme` como constantes, en una tarea propia, antes de construir pantallas.
- Cada pantalla de código se basa en su frame de Figma, que debe tener el mismo ID que en SPEC (P01–P10).

## 7. Pruebas

| Tipo | Qué cubre | Dónde |
|---|---|---|
| Unitarias | Cálculo de recurrentes (meses cortos, atrasos, idempotencia), presupuesto y umbrales, alertas sin duplicados, totales del resumen, hash y verificación del PIN, formato de soles | `test/features/**`, `test/core/**` |
| Repositorio | CRUD y consultas contra Drift en memoria | `test/features/*/data/` |
| Widget | Validaciones del formulario P04, flujo de PIN en P01 | `test/features/*/ui/` |
| Manual | Checklist de pantallas en el teléfono real | Tarea final |

## 8. Comandos

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
flutter run            # o el botón Run de Android Studio con el teléfono conectado
flutter build apk --release
```

Los archivos generados (`*.g.dart`) **se commitean**, para que el proyecto compile sin regenerarlos.

## 9. Convenciones

- Archivos en `snake_case`, clases en `PascalCase`.
- Nombres del dominio en español (`Movimiento`, `montoCentimos`); términos técnicos de Flutter en inglés (`Screen`, `Repository`, `Provider`).
- Commits: `tipo(área): descripción` en español, por ejemplo `feat(movimientos): formulario P04`.
