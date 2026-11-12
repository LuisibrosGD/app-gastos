# 011 — Presupuesto: datos y alertas

**Estado:** PENDIENTE
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
