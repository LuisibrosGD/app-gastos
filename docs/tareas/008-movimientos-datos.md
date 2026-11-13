# 008 — Movimientos: datos y controlador

**Estado:** APROBADA
**Tipo:** código
**Depende de:** 006
**Referencias:** SPEC R1 · ARQUITECTURA §3, §4 · INDICE A2

## Objetivo
El repositorio de movimientos (CRUD, consultas por mes, recientes y totales) y un controlador para guardar y borrar desde la UI, todo testeado.

## Alcance
**Se puede crear o modificar:**
- `lib/features/movimientos/data/modelos.dart`, `movimientos_repository.dart`
- `lib/features/movimientos/providers/movimientos_providers.dart` (+ `.g.dart`)
- `test/features/movimientos/data/movimientos_repository_test.dart`, `test/features/movimientos/providers/movimientos_controller_test.dart`

**Fuera de alcance:** UI (tarea 009) y alertas (tarea 011).

## Interfaces
**Consume:** `AppDatabase`, `Movimiento`, `Categoria`, `TipoMovimiento`, `ValidacionException`, `soloFecha`, `inicioMes`, `inicioMesSiguiente`.
**Produce:**
```dart
// modelos.dart
class MovimientoInput {
  const MovimientoInput({required this.tipo, required this.montoCentimos, required this.fecha,
      required this.categoriaId, this.nota, this.recurrenteId});
  final TipoMovimiento tipo; final int montoCentimos; final DateTime fecha;
  final int categoriaId; final String? nota; final int? recurrenteId;
}
class MovimientoConCategoria { const MovimientoConCategoria(this.movimiento, this.categoria);
  final Movimiento movimiento; final Categoria categoria; }
class TotalesMes { const TotalesMes({required this.mes, required this.ingresos, required this.gastos});
  final DateTime mes; final int ingresos; final int gastos; int get balance => ingresos - gastos; }
class FiltroMovimientos { const FiltroMovimientos({required this.mes, this.tipo, this.categoriaId});
  final DateTime mes; final TipoMovimiento? tipo; final int? categoriaId;
  /* == y hashCode por valor (para usarlo como parámetro de provider) */ }

// movimientos_repository.dart
class MovimientosRepository {
  MovimientosRepository(AppDatabase db);
  Future<int> crear(MovimientoInput input);
  Future<void> actualizar(int id, MovimientoInput input);
  Future<void> eliminar(int id);
  Future<MovimientoConCategoria?> obtener(int id);
  Stream<List<MovimientoConCategoria>> watchMes(FiltroMovimientos filtro); // fecha desc, id desc
  Stream<List<MovimientoConCategoria>> watchRecientes({int limite = 5});
  Stream<TotalesMes> watchTotalesMes(DateTime mes);
}

// movimientos_providers.dart
@Riverpod(keepAlive: true) MovimientosRepository movimientosRepository(Ref ref);
@riverpod Stream<List<MovimientoConCategoria>> movimientosMes(Ref ref, FiltroMovimientos filtro);
@riverpod Stream<List<MovimientoConCategoria>> movimientosRecientes(Ref ref);
@riverpod Stream<TotalesMes> totalesMes(Ref ref, DateTime mes);
@riverpod class MovimientosController extends _$MovimientosController {
  FutureOr<void> build() {}
  /// Crea (id == null) o actualiza. Devuelve el id. Relanza ValidacionException.
  Future<int> guardar({int? id, required MovimientoInput input});
  Future<void> eliminar(int id);
}
```
**Validación en `crear` y `actualizar`** (R1), siempre con `ValidacionException(campo, codigo)`:
| Condición | campo | codigo |
|---|---|---|
| `montoCentimos <= 0` | `monto` | `mayorACero` |
| `montoCentimos > kMaxCentimos` | `monto` | `muyGrande` |
| `nota` de más de 200 caracteres (tras `trim`) | `nota` | `muyLargo` |
| la categoría no existe | `categoria` | `requerido` |
| `categoria.tipo != input.tipo` | `categoria` | `tipoNoCoincide` |

`fecha` se guarda con `soloFecha`. Una `nota` vacía tras `trim` se guarda como `null`. `creadoEn = DateTime.now()`.

## Pasos
1. Tests del repositorio (base en memoria, con categorías creadas en `setUp`):
   ```dart
   test('crear guarda fecha sin hora y nota vacía como null')
   test('monto 0 lanza ValidacionException(monto, mayorACero)')
   test('nota de 201 caracteres lanza ValidacionException(nota, muyLargo)')
   test('gasto con categoría de ingreso lanza tipoNoCoincide')
   test('actualizar de gasto a ingreso sin cambiar a una categoría de ingreso lanza tipoNoCoincide')  // A2
   test('watchMes devuelve solo el mes pedido, ordenado por fecha desc')
   test('watchMes filtra por tipo y por categoriaId')
   test('watchMes incluye el 1 y el último día del mes y excluye el 1 del mes siguiente')
   test('watchRecientes devuelve como máximo 5, los más recientes')
   test('watchTotalesMes: ingresos 100000, gastos 35050 -> balance 64950')
   test('eliminar lo quita de watchMes')
   ```
2. Implementar los modelos, el repositorio (consultas con `join` a categorías; totales con `SUM` agrupado por tipo) y los providers.
3. Test del controlador (`ProviderContainer` con la base en memoria sobrescrita): `guardar` sin id crea, con id actualiza, y relanza `ValidacionException`.
4. `build_runner`, `flutter analyze` y `flutter test`.

## Criterios de aceptación
- [ ] Los tests de los pasos 1 y 3 pasan.
- [ ] Ningún cálculo de montos usa `double`.
- [ ] `flutter analyze` sin errores ni advertencias.
- [ ] `flutter test` en verde.

---

## Reporte de implementación
*(Lo escribe Command Code. No borrar los títulos.)*

**Archivos creados o modificados:**
- `lib/features/movimientos/data/modelos.dart`: `MovimientoInput`, `MovimientoConCategoria`, `TotalesMes` y `FiltroMovimientos` (con `==` y `hashCode`).
- `lib/features/movimientos/data/movimientos_repository.dart`.
- `lib/features/movimientos/providers/movimientos_providers.dart` y `.g.dart` (generado).
- `test/features/movimientos/data/movimientos_repository_test.dart`.
- `test/features/movimientos/providers/movimientos_controller_test.dart`.

**Comandos ejecutados y resultado:**
- `dart run build_runner build` → `movimientos_providers.g.dart` generado; sin conflictos.
- `flutter analyze` → `No issues found!`
- `flutter test` → `All tests passed!` (66 tests; 11 de repositorio y 2 del controlador)

**Decisiones tomadas / desvíos del brief:**
- Las consultas con categoría usan `innerJoin` y devuelven `MovimientoConCategoria`; `watchMes` ordena por `fecha` desc e `id` desc y filtra por rango `[inicioMes, inicioMesSiguiente)`.
- `watchTotalesMes` usa `SUM(montoCentimos)` agrupado por `tipo` con `selectOnly`. Para leer el enum desde la fila agregada hace falta `readWithConverter`; `read` devuelve el `String` crudo del `textEnum`.
- `actualizar` no toca `creadoEn`; `crear` lo fija con `DateTime.now()`. La `nota` se guarda con `trim` y vacía como `null`, y la fecha con `soloFecha`.
- La validación de categoría consulta la tabla antes de insertar/actualizar, de modo que un tipo distinto devuelve `tipoNoCoincide` y una categoría inexistente `requerido`.
- Los montos se manejan solo con `int`; el límite es `kMaxCentimos` de `core/utils/moneda.dart`.
- `MovimientosController.guardar` devuelve el id existente al actualizar y relanza `ValidacionException` sin envolverla.

**Dudas o problemas pendientes:**
- Ninguna.

---

## Auditoría
*(La escribe Claude Code.)*

**Ronda 1 — 2026-11-12 — APROBADA**

Lo verifiqué yo mismo: `flutter analyze` está limpio, los 66 tests pasan y `build_runner` no cambia el contenido de ningún `.g.dart`.
- La validación cubre las 5 filas de la tabla R1, en el orden pedido.
- La fecha se guarda con `soloFecha` y la nota vacía como `null`.
- `actualizar` no toca `creadoEn`.
- `watchMes` filtra por el rango `[inicioMes, inicioMesSiguiente)` y ordena por fecha desc e id desc.
- Los totales se calculan con `SUM` agrupado por tipo; usar `readWithConverter` es correcto.
- No hay ningún `double` en la feature.
- Los tests prueban casos reales: los bordes del mes, el límite de 5, el cambio de tipo (A2) y los totales exactos.
- Los providers usan `@riverpod` sin problemas, porque `MovimientoConCategoria` es una clase propia.

Observaciones que no bloquean:
- `actualizar` con un id que no existe no hace nada y no avisa. Ninguna pantalla debería pedirlo; no hace falta cambiarlo.
- Las claves `DateTime` de `movimientosMes` y `totalesMes` tienen que ser `inicioMes(...)`. Lo anoté en el Contexto de la 009 y de la 010.
