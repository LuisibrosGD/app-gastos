# 013 — Recurrentes: lógica y generador

**Estado:** APROBADA
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
- `lib/features/recurrentes/domain/ocurrencias.dart`.
- `lib/features/recurrentes/data/recurrentes_repository.dart`, `generador_recurrentes.dart`.
- `lib/features/recurrentes/providers/recurrentes_providers.dart` y su `.g.dart`.
- `test/features/recurrentes/domain/ocurrencias_test.dart`, `test/features/recurrentes/data/recurrentes_repository_test.dart`, `generador_recurrentes_test.dart`.

**Comandos ejecutados y resultado:**
- `dart run build_runner build --delete-conflicting-outputs` → 16 salidas generadas, sin errores.
- `flutter analyze` → `No issues found!`
- `flutter test` → `All tests passed!` (115 tests; 15 nuevos)

**Decisiones tomadas / desvíos del brief:**
- `ocurrenciasPendientes` normaliza `fechaInicio`, `ultimaGeneracion` y `hoy` con `soloFecha`; mensual recorre desde el mes de `desde` hasta el de `hoy` y recorta el día al último del mes; semanal avanza día a día desde `desde + 1`.
- `RecurrentesRepository` ordena `watchTodas` por activas primero, nombre de categoría y `id`. `actualizar` no escribe `ultimaGeneracion`, como pide el brief.
- El generador crea las reglas activas en una transacción por regla usando `MovimientosRepository.crear` (con `recurrenteId`) y guarda `ultimaGeneracion = soloFecha(hoy)` dentro de la misma transacción. Las alertas se revisan después, solo para gastos.
- Los tests usan `NotificadorFalso implements Notificador`, como el test de `AlertasService`.

**Dudas o problemas pendientes:**
- Ninguna. La UI y el ciclo de vida quedan para la tarea 014, fuera de alcance.

### Reporte – ronda 2

**Cambios realizados:**
- `generarPendientes` ahora relee cada regla por `id` dentro de su transacción y descarta las que ya no existen o están inactivas. `ocurrenciasPendientes` se calcula con esa lectura fresca, así una segunda llamada concurrente ve la `ultimaGeneracion` ya escrita y no duplica. Los contadores locales solo se vuelcan al resultado tras completar la transacción.
- Cada `alertas.revisar` va en `try/catch`: un fallo de alertas ya no aborta la generación ni propaga la excepción al arranque.
- Nuevo test `'dos generaciones simultáneas no duplican'`: `Future.wait` sobre dos llamadas, suma de resultados 3 y exactamente 3 movimientos.

**Comandos ejecutados y resultado:**
- `flutter analyze` → `No issues found!`
- `flutter test` → `All tests passed!` (116 tests)

---

## Auditoría
*(La escribe Claude Code.)*

**Ronda 1 — 2026-11-15 — CAMBIOS_SOLICITADOS**

Verificado: `flutter analyze` sin problemas, `flutter test` 115 en verde, `build_runner` sin cambios en `.g.dart`. `ocurrencias.dart` es Dart puro y los casos de A3 (bisiesto, día 31, inicio futuro) están cubiertos. Repositorio, validaciones y orden de `watchTodas` coinciden con el brief.

Cambios pedidos:
1. **Dos llamadas seguidas al generador pueden duplicar movimientos (incumple R5).** `generador_recurrentes.dart`: las reglas se leen *antes* de las transacciones. En la 014 el generador se lanzará al abrir la app y al volver a primer plano; si las dos llamadas se solapan, ambas leen la misma `ultimaGeneracion` y crean las mismas ocurrencias dos veces. Esperado: dentro de la transacción de cada regla, volver a leer la regla por `id` (si ya no existe o está inactiva, saltarla) y calcular `ocurrenciasPendientes` con esa lectura, de modo que la segunda llamada vea la `ultimaGeneracion` ya actualizada.
   Test: `test('dos generaciones simultáneas no duplican')` → `await Future.wait([g.generarPendientes(hoy), g.generarPendientes(hoy)])` sobre una regla con 3 ocurrencias pendientes; deben existir exactamente 3 movimientos y la suma de los dos resultados debe ser 3.
2. **Un fallo al revisar alertas hace fallar todo el generador.** Los movimientos ya están guardados, pero la excepción de `alertas.revisar` sube a quien llama (en la 014, el arranque de la app). Esperado: envolver cada `alertas.revisar` en `try/catch` y seguir con el resto, igual que hace `MovimientosController.guardar`.

Nota no bloqueante: cambiar la `fechaInicio` de una regla a una fecha anterior no rellena ocurrencias antiguas porque `ultimaGeneracion` ya avanzó; es coherente con el brief.

**Ronda 2 — 2026-11-15 — APROBADA**

Verificado: `flutter analyze` sin problemas, `flutter test` 116 en verde, `build_runner` sin cambios en `.g.dart`. El generador relee cada regla dentro de su transacción (y salta las borradas o desactivadas), y el test `'dos generaciones simultáneas no duplican'` lo comprueba. Cada `alertas.revisar` está aislado con `try/catch`.

Nota no bloqueante: el Estado volvió a quedarse en `CAMBIOS_SOLICITADOS` al entregar la ronda; hay que ponerlo en `LISTA_PARA_AUDITORIA`.
