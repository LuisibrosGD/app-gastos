# 013 — Recurrentes: lógica y generador

**Estado:** PENDIENTE
**Tipo:** código
**Depende de:** 011
**Referencias:** SPEC R5 · ARQUITECTURA §4 (recurrentes), §5 · INDICE A3, A4

## Objetivo
Calcular las fechas pendientes de cada regla (lógica pura), el CRUD de reglas y un generador idempotente que crea los movimientos y revisa las alertas.

## Alcance
**Se puede crear o modificar:**
- `lib/features/recurrentes/domain/ocurrencias.dart`
- `lib/features/recurrentes/data/recurrentes_repository.dart`, `generador_recurrentes.dart`
- `lib/features/recurrentes/providers/recurrentes_providers.dart` (+ `.g.dart`)
- `test/features/recurrentes/domain/ocurrencias_test.dart`, `test/features/recurrentes/data/recurrentes_repository_test.dart`, `generador_recurrentes_test.dart`

**Fuera de alcance:** UI y ciclo de vida (tarea 014).

## Interfaces
**Consume:** `AppDatabase`, `Recurrente`, `Frecuencia`, `TipoMovimiento`, `MovimientoInput`, `MovimientosRepository`, `AlertasService.revisar`, `soloFecha`, `ultimoDiaDelMes`, `ValidacionException`.
**Produce:**
```dart
// domain/ocurrencias.dart (Dart puro)
/// Fechas de ocurrencia en el intervalo (desde, hoy], donde
/// desde = ultimaGeneracion ?? (fechaInicio - 1 día). Orden ascendente.
/// Mensual: el día `dia` de cada mes; si el mes no lo tiene, su último día.
/// Semanal: el día de la semana `dia` (1 = lunes … 7 = domingo, como DateTime.weekday).
List<DateTime> ocurrenciasPendientes({required Frecuencia frecuencia, required int dia,
    required DateTime fechaInicio, DateTime? ultimaGeneracion, required DateTime hoy});

// data/recurrentes_repository.dart
class RecurrenteInput { const RecurrenteInput({required this.tipo, required this.montoCentimos,
    required this.categoriaId, this.nota, required this.frecuencia, required this.dia,
    required this.fechaInicio, this.activo = true}); /* campos final con esos nombres */ }
class RecurrentesRepository {
  RecurrentesRepository(AppDatabase db);
  Stream<List<RecurrenteConCategoria>> watchTodas();       // activas primero, después por nombre de categoría
  Future<int> crear(RecurrenteInput input);
  Future<void> actualizar(int id, RecurrenteInput input);  // no toca ultimaGeneracion
  Future<void> eliminar(int id);                           // los movimientos quedan con recurrenteId null
}
class RecurrenteConCategoria { const RecurrenteConCategoria(this.regla, this.categoria); final Recurrente regla; final Categoria categoria; }

// data/generador_recurrentes.dart
class GeneradorRecurrentes {
  GeneradorRecurrentes({required AppDatabase db, required MovimientosRepository movimientos, required AlertasService alertas});
  /// Para cada regla activa: crea un movimiento por cada ocurrencia pendiente (con recurrenteId)
  /// y pone ultimaGeneracion = soloFecha(hoy), todo en UNA transacción por regla.
  /// Después, para cada gasto creado, llama a alertas.revisar. Devuelve cuántos movimientos creó.
  Future<int> generarPendientes(DateTime hoy);
}

// providers
@Riverpod(keepAlive: true) RecurrentesRepository recurrentesRepository(Ref ref);
@Riverpod(keepAlive: true) GeneradorRecurrentes generadorRecurrentes(Ref ref);
@riverpod Stream<List<RecurrenteConCategoria>> recurrentes(Ref ref);
```
Validación de `RecurrenteInput` (`ValidacionException`): monto > 0 (`monto`, `mayorACero`); `dia` de 1 a 31 si es mensual y de 1 a 7 si es semanal (`dia`, `fueraDeRango`); categoría del mismo tipo (`categoria`, `tipoNoCoincide`); nota ≤ 200 (`nota`, `muyLargo`).

El generador crea los movimientos aunque la categoría esté **archivada**: la regla sigue vigente hasta que el usuario la desactive.

## Pasos
1. Tests de dominio:
   ```dart
   // mensual día 15, inicio 2026-01-10, sin ultimaGeneracion, hoy 2026-03-20
   expect(r, [DateTime(2026,1,15), DateTime(2026,2,15), DateTime(2026,3,15)]);
   // mensual día 31, inicio 2028-01-01, hoy 2028-03-31  (A3: bisiesto)
   expect(r, [DateTime(2028,1,31), DateTime(2028,2,29), DateTime(2028,3,31)]);
   // mensual día 31 en 2026: febrero -> 2026-02-28
   // ultimaGeneracion 2026-03-20, hoy 2026-03-20 -> vacío
   // fechaInicio 2026-12-01 (futuro), hoy 2026-11-11 -> vacío     (A3)
   // la fechaInicio es día de ocurrencia -> se incluye
   // semanal día 1 (lunes), inicio 2026-11-01 (domingo), hoy 2026-11-16 -> [2026-11-02, 2026-11-09, 2026-11-16]
   ```
2. Tests del repositorio y del generador (base en memoria + `NotificadorFalso`):
   ```dart
   test('crear valida dia fuera de rango y tipo de categoría')
   test('eliminar regla conserva sus movimientos con recurrenteId null')
   test('generar 3 meses atrasados crea 3 movimientos con recurrenteId y actualiza ultimaGeneracion')
   test('generar dos veces el mismo día no duplica')                         // idempotencia (R5)
   test('borrar un movimiento generado y volver a generar no lo recrea')     // A4
   test('regla inactiva no genera')
   test('regla con categoría archivada sigue generando')
   test('un gasto generado que cruza el 80% dispara una notificación')
   ```
3. Implementar. Para crear los movimientos, el generador usa `MovimientosRepository.crear` (que ya valida) dentro de la transacción.
4. `build_runner`, `flutter analyze` y `flutter test`.

## Criterios de aceptación
- [ ] Los tests de los pasos 1 y 2 pasan.
- [ ] `ocurrenciasPendientes` no importa Flutter ni Drift.
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
