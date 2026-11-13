# 009 — Movimientos: pantallas P04 y P05

**Estado:** PENDIENTE
**Tipo:** código
**Depende de:** 007, 008
**Referencias:** SPEC P04, P05, R1, R7 · `docs/diseno/P04.png`, `P04b.png`, `P04c.png`, `P05.png`, `P05b.png`

## Objetivo
El formulario para crear, editar y borrar un movimiento (P04) y la lista mensual con filtros (P05).

## Contexto
La navegación inferior llega en la 010. Por ahora registra `/movimientos` como ruta inicial `/` para poder probarla. Rutas de P04: `/movimiento/nuevo` y `/movimiento/:id`.

Ojo con los providers de la 008: `movimientosMesProvider(filtro)` y `totalesMesProvider(mes)` usan la fecha como clave. Pasa siempre `inicioMes(...)`, nunca `DateTime.now()`. Si no, cada reconstrucción crea un provider nuevo y la consulta se reabre una y otra vez.

## Alcance
**Se puede crear o modificar:**
- `lib/features/movimientos/ui/movimiento_form_screen.dart`, `movimientos_screen.dart`
- `lib/features/movimientos/ui/widgets/movimiento_tile.dart`, `selector_mes.dart`, `campo_monto.dart`
- `lib/core/router/app_router.dart`, los ARB
- `test/features/movimientos/ui/movimiento_form_screen_test.dart`, `movimientos_screen_test.dart`

## Interfaces
**Consume:** `movimientosControllerProvider`, `movimientosMesProvider(FiltroMovimientos)`, `categoriasPorTipoProvider`, `MovimientoInput`, `ValidacionException`, `parseSoles`, `formatSoles`, `formatFecha`, `idiomaActualProvider`.
**Produce (lo reutilizan 010 y 014):**
```dart
class MovimientoTile extends StatelessWidget { const MovimientoTile({required this.item, this.onTap}); final MovimientoConCategoria item; final VoidCallback? onTap; }
class SelectorMes extends StatelessWidget { const SelectorMes({required this.mes, required this.onCambio}); final DateTime mes; final ValueChanged<DateTime> onCambio; }
class CampoMonto extends StatelessWidget { /* TextFormField con prefijo 'S/', teclado decimal; validator con parseSoles */ }
class MovimientoFormScreen extends ConsumerStatefulWidget { const MovimientoFormScreen({this.id}); final int? id; }
```

## Pasos
1. Widget tests (base en memoria sobrescrita y categorías creadas):
   ```dart
   testWidgets('guardar con monto vacío muestra error y no crea nada')
   testWidgets('guardar con "12,50" y categoría crea un gasto de 1250 y vuelve atrás')
   testWidgets('cambiar a Ingreso muestra solo categorías de ingreso y limpia la selección')
   testWidgets('en edición, Borrar pide confirmación y elimina')
   testWidgets('P05 muestra los movimientos del mes agrupados por día y "sin movimientos" si no hay')
   testWidgets('P05 cambiar de mes con SelectorMes actualiza la lista')
   ```
2. P04 según `P04*.png`:
   - Selector gasto/ingreso, `CampoMonto`, categorías como chips (solo las del tipo elegido), fecha (por defecto hoy, con `showDatePicker`), nota (máximo 200 caracteres).
   - Los errores de validación aparecen bajo cada campo.
   - Si se captura una `ValidacionException`, el error se muestra en su campo. Si se captura cualquier otro error, un SnackBar, sin perder lo escrito (R7).
   - En edición: carga los datos y muestra Borrar con un diálogo de confirmación.
3. P05 según `P05*.png`: `SelectorMes`, filtros (Todos/Gastos/Ingresos y categoría), lista agrupada por día con cabecera de fecha (`formatFecha`), `MovimientoTile` (monto con color `ingreso` o `gasto`), estado vacío. Tocar un movimiento abre `/movimiento/:id`.
4. Todos los textos en los ARB (es/en), incluidos los mensajes de cada código de `ValidacionException`.
5. `flutter analyze` y `flutter test`. Probar en el teléfono: crear, editar y borrar.

## Criterios de aceptación
- [ ] Los widget tests del paso 1 pasan.
- [ ] Las pantallas se parecen a sus PNG.
- [ ] El formulario conserva lo escrito si falla el guardado.
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
