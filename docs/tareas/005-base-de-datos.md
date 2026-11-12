# 005 — Base de datos: esquema v1

**Estado:** PENDIENTE
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
-

**Comandos ejecutados y resultado:**
- `flutter analyze` →
- `flutter test` →

**Decisiones tomadas / desvíos del brief:**
-

**Dudas o problemas pendientes:**
-

---

## Auditoría
*(La escribe Claude Code.)*

**Ronda 1 — fecha — resultado:**
-
