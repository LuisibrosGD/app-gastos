# 011 — Presupuesto: datos y alertas

**Estado:** LISTA_PARA_AUDITORIA
**Tipo:** código
**Depende de:** 008
**Referencias:** SPEC R3, R4 · ARQUITECTURA §4 (alertasEnviadas), §5 (Servicio de alertas) · INDICE A2

## Objetivo
El repositorio de presupuestos, el cálculo del progreso mensual y el servicio que envía cada alerta del 80 % y del 100 % una sola vez, conectado al guardado de movimientos.

## Alcance
**Se puede crear o modificar:**
- `lib/features/presupuesto/domain/progreso.dart`
- `lib/features/presupuesto/data/presupuestos_repository.dart`
- `lib/features/presupuesto/data/alertas_service.dart`, `notificador.dart`
- `lib/features/presupuesto/providers/presupuesto_providers.dart` (+ `.g.dart`)
- `lib/features/movimientos/providers/movimientos_providers.dart` (solo para llamar a las alertas desde `guardar`)
- `android/app/src/main/AndroidManifest.xml` (permiso `POST_NOTIFICATIONS`), los ARB
- `test/features/presupuesto/domain/progreso_test.dart`, `test/features/presupuesto/data/presupuestos_repository_test.dart`, `alertas_service_test.dart`, `test/features/movimientos/providers/movimientos_controller_test.dart`

## Interfaces
**Consume:** `AppDatabase`, `Presupuesto`, `AlertaEnviada`, `MovimientosController`, `claveMes`, `inicioMes`, `inicioMesSiguiente`, `formatSoles`, `idiomaActualProvider`.
**Produce:**
```dart
// domain/progreso.dart (Dart puro)
int porcentaje(int gastado, int limite);                 // floor(gastado*100/limite); 0 si limite <= 0
List<int> umbralesAlcanzados(int gastado, int limite);   // subconjunto ordenado de [80, 100]

class ProgresoPresupuesto {
  const ProgresoPresupuesto({required this.presupuesto, required this.categoria, required this.gastado});
  final Presupuesto presupuesto; final Categoria? categoria; /* null = total */ final int gastado;
  int get porcentaje; bool get enAlerta /* >= 80 */; bool get excedido /* >= 100 */;
}

// data/presupuestos_repository.dart
class PresupuestosRepository {
  PresupuestosRepository(AppDatabase db);
  Future<void> guardarTotal(int? montoCentimos);                       // null = eliminar
  Future<void> guardarCategoria(int categoriaId, int? montoCentimos);  // null = eliminar
  Stream<List<ProgresoPresupuesto>> watchProgreso(DateTime mes);       // el total primero, después por nombre
  Future<List<ProgresoPresupuesto>> progresoPara(DateTime mes, int categoriaId); // total + el de esa categoría (si existen)
}

// data/notificador.dart
abstract interface class Notificador { Future<void> mostrar({required String titulo, required String cuerpo}); }
class NotificadorLocal implements Notificador { /* flutter_local_notifications; canal 'presupuesto' */ }

// data/alertas_service.dart
class AlertasService {
  AlertasService({required AppDatabase db, required PresupuestosRepository presupuestos,
      required Notificador notificador, required AppLocalizations Function() textos});
  /// Revisa el presupuesto total y el de `categoriaId` para el mes de `fecha`.
  /// Por cada umbral alcanzado que no esté en alertasEnviadas: notifica e inserta la fila.
  Future<void> revisar({required DateTime fecha, required int categoriaId});
}

// providers
@Riverpod(keepAlive: true) PresupuestosRepository presupuestosRepository(Ref ref);
@Riverpod(keepAlive: true) Notificador notificador(Ref ref);   // NotificadorLocal
@Riverpod(keepAlive: true) AlertasService alertasService(Ref ref);
@riverpod Stream<List<ProgresoPresupuesto>> progresoPresupuesto(Ref ref, DateTime mes);
```
**Conexión:** `MovimientosController.guardar`, después de guardar con éxito y **solo si `input.tipo == gasto`**, llama a `alertasService.revisar(fecha: input.fecha, categoriaId: input.categoriaId)`. Usa los datos **nuevos** del input, no los anteriores (A2). Si `revisar` falla, el guardado no se revierte: el error se ignora.

Texto de la notificación (ARB): título "Presupuesto al {porcentaje}%" / "Budget at {porcentaje}%"; cuerpo con el nombre (o "Total") y `gastado de limite` formateados con `formatSoles`.

## Pasos
1. Tests de dominio:
   ```dart
   expect(porcentaje(79999, 100000), 79);
   expect(umbralesAlcanzados(79999, 100000), isEmpty);
   expect(umbralesAlcanzados(80000, 100000), [80]);
   expect(umbralesAlcanzados(150000, 100000), [80, 100]);
   expect(porcentaje(10, 0), 0);
   ```
2. Tests del repositorio y del servicio (base en memoria + `NotificadorFalso` que guarda las llamadas):
   ```dart
   test('guardarTotal dos veces actualiza en lugar de duplicar; null lo elimina')
   test('watchProgreso suma solo gastos del mes (ignora ingresos y otros meses)')
   test('revisar al 85% notifica 1 vez (80); repetir revisar no vuelve a notificar')
   test('revisar al 120% sin alertas previas notifica 80 y 100')
   test('alerta del mes siguiente es independiente del mes actual')
   test('revisar notifica por presupuesto de categoría y por total por separado')
   test('sin presupuestos no notifica nada')
   ```
3. Test del controlador:
   ```dart
   test('guardar un ingreso no llama a revisar')
   test('editar un gasto moviéndolo a otro mes revisa el mes nuevo')   // A2
   ```
4. Implementar. Inicializar `flutter_local_notifications` de forma perezosa en `NotificadorLocal`. En Android 13+ el permiso se pide la primera vez que se guarda un presupuesto (lo hace la 012; aquí se expone `Future<bool> pedirPermiso()` en `NotificadorLocal`).
5. `build_runner`, `flutter analyze` y `flutter test`.

## Criterios de aceptación
- [ ] Los tests de los pasos 1 a 3 pasan.
- [ ] Ningún test depende de las notificaciones reales.
- [ ] `flutter analyze` sin errores ni advertencias.
- [ ] `flutter test` en verde.

---

## Reporte de implementación
*(Lo escribe Command Code. No borrar los títulos.)*

**Archivos creados o modificados:**
- `lib/features/presupuesto/domain/progreso.dart`.
- `lib/features/presupuesto/data/presupuestos_repository.dart`, `alertas_service.dart`, `notificador.dart`.
- `lib/features/presupuesto/providers/presupuesto_providers.dart` y `.g.dart`.
- `lib/features/movimientos/providers/movimientos_providers.dart`: `guardar` llama a `AlertasService.revisar` solo para gastos y con los datos del input.
- `android/app/src/main/AndroidManifest.xml`: permiso `POST_NOTIFICATIONS`.
- `lib/core/l10n/app_es.arb`, `app_en.arb` y clases generadas (título, cuerpo, «Total» y nombre del canal).
- `test/features/presupuesto/domain/progreso_test.dart`, `test/features/presupuesto/data/presupuestos_repository_test.dart`, `alertas_service_test.dart`, `test/features/movimientos/providers/movimientos_controller_test.dart`.

**Comandos ejecutados y resultado:**
- `flutter gen-l10n` → textos de alertas generados.
- `dart run build_runner build` → providers del presupuesto generados.
- `flutter analyze` → `No issues found!`
- `flutter test` → `All tests passed!` (94 tests; 14 nuevos)

**Decisiones tomadas / desvíos del brief:**
- El título de la notificación usa el umbral alcanzado (80 o 100) y el cuerpo el gastado real frente al límite, ambos con `formatSoles` y el nombre de la categoría o «Total».
- `NotificadorLocal` inicializa el plugin de forma perezosa la primera vez que se muestra o se pide permiso; el nombre del canal sale del ARB y el id es `presupuesto`.
- `guardar` captura cualquier error de `revisar` y no revierte el movimiento. Después de crear o editar usa siempre el `MovimientoInput` nuevo, también al cambiar de mes.
- `progresoPara` devuelve el total primero y luego el de la categoría; `watchProgreso` ordena igual y después por nombre.
- Los tests del controlador sustituyen `notificadorProvider` por un falso y usan preferencias simuladas para resolver los textos; ninguna prueba toca notificaciones reales.

**Dudas o problemas pendientes:**
- Ninguna.

### Reporte — ronda 1

**Archivos modificados:**
- `lib/features/presupuesto/data/presupuestos_repository.dart`: `watchProgreso` emite el valor inicial y vuelve a emitir con `tableUpdates(TableUpdateQuery.onAllTables(presupuestos, categorias, movimientos))`. El cálculo se extrajo a `_progresoActual`.
- `test/features/presupuesto/data/presupuestos_repository_test.dart`: nuevo test `'watchProgreso emite de nuevo al añadir un gasto'`, que escucha el stream, comprueba el gastado inicial y espera una segunda emisión con el gasto insertado.

**Comandos ejecutados y resultado:**
- `dart run build_runner build` → sin cambios pendientes en los `.g.dart`.
- `flutter analyze` → `No issues found!`
- `flutter test` → `All tests passed!` (95 tests)

**Decisiones tomadas / desvíos del brief:**
- El stream se implementa con un `StreamController`: emisión inicial, suscripción a `tableUpdates` de las tres tablas y cancelación explícita de esa suscripción. La primera versión con `async*` dejaba la cancelación pendiente y el test expiraba.
- `_progresoActual` reutiliza la consulta con `leftOuterJoin` a `categorias` y los cálculos de gastado existentes; solo cambia el disparador.

**Dudas o problemas pendientes:**
- Ninguna.

---

## Auditoría
*(La escribe Claude Code.)*

**Ronda 1 — 2026-11-13 — CAMBIOS_SOLICITADOS**

Lo demás está bien. `flutter analyze` sale limpio y pasan los 94 tests. El dominio, la deduplicación por `(presupuesto, mes, umbral)`, la conexión en `guardar` (solo con gastos y con el input nuevo, sin revertir) y el permiso cumplen R3, R4 y A2. Ningún test toca las notificaciones reales.

**Hay que cambiar:**
1. **`presupuestos_repository.dart`, `watchProgreso`: el stream no se actualiza cuando cambian los movimientos.** `consulta.watch()` solo escucha `presupuestos` y `categorias`. El gasto se suma dentro de `asyncMap` con lecturas sueltas de `movimientos`, y Drift no las vigila. Por eso, después de guardar un gasto, `progresoPresupuestoProvider` seguiría mostrando el gastado anterior. Le afectarían a la 012 la barra de Inicio y el aviso de R4 («mientras el gasto del mes sea ≥ 80 %»).
   - Se espera que el stream vuelva a emitir cuando cambie cualquiera de las tres tablas. Por ejemplo, partir de `_db.tableUpdates(TableUpdateQuery.onAllTables([presupuestos, categorias, movimientos]))` con una emisión inicial, o de un `customSelect(..., readsFrom: {...}).watch()`. Elige la forma que prefieras.
   - Añadir el test `'watchProgreso emite de nuevo al añadir un gasto'`: escucha el stream, comprueba el primer valor, inserta un gasto del mes y comprueba que llega un valor nuevo con el gastado actualizado (con `emitsInOrder` o equivalente).

Notas, no bloquean:
- `NotificadorLocal._siguienteId` vuelve a 0 en cada arranque, así que una alerta nueva puede reemplazar una anterior que siga en la bandeja. Es aceptable en la v1.

Volver a correr `build_runner`, `flutter analyze` y `flutter test`.

**Ronda 2 — 2026-11-15 — APROBADA**

- `watchProgreso` emite un valor al empezar a escucharlo y vuelve a emitir cuando cambian `presupuestos`, `categorias` o `movimientos`. Al cancelar, se da de baja de `tableUpdates`.
- El test `'watchProgreso emite de nuevo al añadir un gasto'` comprueba que el gastado pasa de 0 a 2450.
- `flutter analyze` sale limpio, pasan los 95 tests y `build_runner` no cambia nada.

Notas, no bloquean:
- Si llegan dos cambios seguidos, dos `emitir()` corren a la vez y, en teoría, el más lento podría emitir un valor viejo después del nuevo. Con una base local y un solo usuario es muy poco probable.
- Un error dentro de `emitir()` no llega al stream (no hay `addError`). Con una base local es poco probable que ocurra.
