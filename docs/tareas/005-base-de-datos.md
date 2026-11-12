# 005 — Base de datos: esquema v1

**Estado:** APROBADA
**Tipo:** código
**Depende de:** 003
**Referencias:** ARQUITECTURA §4 · SPEC R2, R3, R5

## Objetivo
`AppDatabase` (Drift) con las 5 tablas del esquema v1, sus restricciones y un provider de Riverpod, todo testeado con una base en memoria.

## Alcance
**Se puede crear o modificar:**
- `lib/core/database/enums.dart`, `app_database.dart`, `app_database.g.dart` (generado), `database_provider.dart`.
- `lib/features/categorias/data/categorias_table.dart`
- `lib/features/movimientos/data/movimientos_table.dart`
- `lib/features/presupuesto/data/presupuestos_table.dart`, `alertas_enviadas_table.dart`
- `lib/features/recurrentes/data/recurrentes_table.dart`
- `test/core/database/app_database_test.dart`

**Fuera de alcance:** repositorios y UI.

## Interfaces que produce
```dart
enum TipoMovimiento { gasto, ingreso }
enum Frecuencia { mensual, semanal }

// Tablas → clases de datos (@DataClassName):
// Categorias → Categoria, Movimientos → Movimiento, Presupuestos → Presupuesto,
// Recurrentes → Recurrente, AlertasEnviadas → AlertaEnviada
// Columnas: las de ARQUITECTURA §4, en camelCase (montoCentimos, categoriaId, recurrenteId,
// creadoEn, fechaInicio, ultimaGeneracion, presupuestoId, …). Enums con textEnum<T>().

@DriftDatabase(tables: [Categorias, Movimientos, Presupuestos, Recurrentes, AlertasEnviadas])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);
  @override int get schemaVersion => 1;
}

// database_provider.dart
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref);   // driftDatabase(name: 'app_gastos'); ref.onDispose(db.close)
```

## Pasos
1. Escribir los tests con `AppDatabase(NativeDatabase.memory())`:
   ```dart
   test('crea las 5 tablas')                      // insertar una fila en cada una funciona
   test('rechaza movimiento con categoria inexistente')   // expect(..., throwsA(isA<SqliteException>()))
   test('rechaza monto <= 0')                     // CHECK montoCentimos > 0 en movimientos, presupuestos y recurrentes
   test('solo un presupuesto total')              // el 2.º insert con categoriaId null lanza excepción
   test('solo un presupuesto por categoria')
   test('borrar recurrente deja movimiento con recurrenteId null')
   test('alertasEnviadas no admite duplicado (presupuestoId, mes, umbral)')
   ```
2. Escribir las tablas con las restricciones: `CHECK` de monto > 0, longitud de `nombre` 1–30 y de `nota` ≤ 200, FKs con `references(...)`, `recurrenteId` con `onDelete: KeyAction.setNull`, `categoriaId` de presupuestos `unique()`, PK compuesta en `AlertasEnviadas`.
3. `MigrationStrategy`: en `onCreate`, `createAll()` y luego los índices de ARQUITECTURA §4 (incluido `presupuesto_total_unico`, con `customStatement`). En `beforeOpen`, `PRAGMA foreign_keys = ON`.
4. `dart run build_runner build --delete-conflicting-outputs`.
5. `flutter analyze` y `flutter test`.

## Criterios de aceptación
- [ ] Los 7 tests del paso 1 pasan.
- [ ] `schemaVersion == 1`.
- [ ] Los archivos `*.g.dart` están incluidos.
- [ ] `flutter analyze` sin errores ni advertencias.
- [ ] `flutter test` en verde.

---

## Reporte de implementación
*(Lo escribe Command Code. No borrar los títulos.)*

**Archivos creados o modificados:**
- `lib/core/database/enums.dart`: `TipoMovimiento` y `Frecuencia`.
- `lib/features/categorias/data/categorias_table.dart` (`Categorias` → `Categoria`).
- `lib/features/movimientos/data/movimientos_table.dart` (`Movimientos` → `Movimiento`).
- `lib/features/recurrentes/data/recurrentes_table.dart` (`Recurrentes` → `Recurrente`).
- `lib/features/presupuesto/data/presupuestos_table.dart` (`Presupuestos` → `Presupuesto`).
- `lib/features/presupuesto/data/alertas_enviadas_table.dart` (`AlertasEnviadas` → `AlertaEnviada`).
- `lib/core/database/app_database.dart` y `app_database.g.dart` (generado).
- `lib/core/database/database_provider.dart` y `database_provider.g.dart` (generado).
- `test/core/database/app_database_test.dart`.

**Comandos ejecutados y resultado:**
- `dart run build_runner build --delete-conflicting-outputs` → genera `app_database.g.dart` y `database_provider.g.dart`. Aviso del tool: la opción `--delete-conflicting-outputs` «has been removed and ignored» en la versión instalada de build_runner.
- `dart run build_runner build` → segunda pasada tras ajustar los `CHECK`; 20 salidas escritas, sin conflictos.
- `flutter analyze` → `No issues found!`
- `flutter test` → `All tests passed!` (39 tests; incluye los 7 de base de datos)

**Decisiones tomadas / desvíos del brief:**
- Los `CHECK` de monto usan `check(CustomExpression('monto_centimos > 0'))` en vez de `check(montoCentimos.isBiggerThanValue(0))`: la forma convencional dispara el lint `recursive_getters` (getter que se referencia a sí mismo) y `flutter analyze` lo reporta como issue.
- Los índices se crean en `onCreate` con `customStatement` e `IF NOT EXISTS`: `movimientos_fecha`, `movimientos_categoria_id` y el único parcial `presupuesto_total_unico ON presupuestos ((categoria_id IS NULL)) WHERE categoria_id IS NULL`.
- `PRAGMA foreign_keys = ON` en `beforeOpen`, así los tests en memoria validan las FKs.
- Se generó también `database_provider.g.dart`, que no figuraba en el Alcance pero es obligatorio para la anotación `@Riverpod` que pide el brief.

**Dudas o problemas pendientes:**
- Ninguna.

**Reporte – ronda 1**

- `presupuestos_table.dart`: `categoriaId` con `references(Categorias, #id, onDelete: KeyAction.cascade)`.
- `alertas_enviadas_table.dart`: `presupuestoId` con `references(Presupuestos, #id, onDelete: KeyAction.cascade)`.
- `app_database_test.dart`: añadidos `borrar presupuesto borra sus alertas enviadas` y `borrar categoría borra su presupuesto`.
- Regenerado con `dart run build_runner build` → 14 salidas, sin conflictos.
- `flutter analyze` → `No issues found!`
- `flutter test` → `All tests passed!` (41 tests)

---

## Auditoría
*(La escribe Claude Code.)*

**Ronda 1 — fecha — resultado:**
-

**Ronda 1 — 2026-11-12 — CAMBIOS_SOLICITADOS**

Lo verifiqué yo mismo: `flutter analyze` está limpio, los 39 tests pasan y `build_runner` no regenera nada (los `.g.dart` están al día).
- Las tablas, los `CHECK`, el índice parcial, el `PRAGMA` y el provider coinciden con §4.
- Acepto los dos desvíos: usar `CustomExpression` por el lint, y generar `database_provider.g.dart`, que hace falta para `@Riverpod`.

Hay un único cambio, y la culpa es de mi plan, no de la implementación. Con el esquema actual:
- Borrar un presupuesto que ya tenga filas en `alertasEnviadas` falla por la FK. La tarea 011 permite eliminar presupuestos (`guardarTotal(null)`).
- Lo mismo pasa al borrar una categoría que tenga presupuesto (tarea 006, `eliminarOArchivar`).

Ya actualicé ARQUITECTURA §4. Qué hay que cambiar:
1. `presupuestos_table.dart`: `categoriaId` con `references(Categorias, #id, onDelete: KeyAction.cascade)`.
2. `alertas_enviadas_table.dart`: `presupuestoId` con `references(Presupuestos, #id, onDelete: KeyAction.cascade)`.
3. Volver a correr `build_runner`.
4. Añadir dos tests a `app_database_test.dart`:
   - `test('borrar presupuesto borra sus alertas enviadas')`
   - `test('borrar categoría borra su presupuesto')`

**Ronda 2 — 2026-11-12 — APROBADA**

Las dos cascadas están en las tablas y en el código generado (`ON DELETE CASCADE`), y los dos tests nuevos prueban el borrado real. Lo verifiqué yo mismo: `flutter analyze` está limpio, los 41 tests pasan y `build_runner` no escribe nada nuevo.

