# 009 — Movimientos: pantallas P04 y P05

**Estado:** APROBADA
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
- `lib/features/movimientos/ui/movimiento_form_screen.dart`.
- `lib/features/movimientos/ui/movimientos_screen.dart`.
- `lib/features/movimientos/ui/widgets/movimiento_tile.dart`, `selector_mes.dart`, `campo_monto.dart`.
- `lib/features/movimientos/ui/widgets/form_fields.dart` y `estado_vacio.dart` (extraídos para respetar la regla 8).
- `lib/features/movimientos/providers/movimientos_providers.dart`: añadido `movimientoProvider` (fuera del Alcance, ver desvíos).
- `lib/core/router/app_router.dart`: `/` y `/movimientos` a P05, `/movimiento/nuevo` y `/movimiento/:id` a P04.
- `lib/core/l10n/app_es.arb`, `app_en.arb` y clases generadas.
- `test/features/movimientos/ui/movimiento_form_screen_test.dart`, `movimientos_screen_test.dart`.
- `test/features/onboarding/ui/onboarding_screen_test.dart` (ajustado porque `/` ya no es P09).

**Comandos ejecutados y resultado:**
- `flutter gen-l10n` → textos de P04/P05 generados.
- `dart run build_runner build` → sin conflictos.
- `flutter analyze` → `No issues found!`
- `flutter test` → `All tests passed!` (73 tests; 7 nuevos de UI de movimientos)

**Decisiones tomadas / desvíos del brief:**
- P04 necesita cargar un movimiento por id y la UI no puede importar el repositorio, así que añadí `movimientoProvider` (`FutureProvider.family` a mano, regla 9) en el archivo de providers de la 008. Es el único cambio fuera del Alcance de esta tarea.
- El formulario se divide entre `form_fields.dart` (selector de tipo, chips de categoría, campo de fecha, mensaje de error de carga y mapeo de `ValidacionException`) y `estado_vacio.dart` para P05, de modo que ningún archivo supere las ~300 líneas.
- `SelectorMes` abre un diálogo propio con navegación de año y rejilla de 12 meses; así también se puede probar en widget tests.
- Las etiquetas de grupo usan `Hoy`/`Ayer` con `formatFecha` y, para el resto, solo la fecha.
- `MovimientoTile` muestra como título la nota (o la categoría si no hay nota) y como subtítulo la categoría (o el tipo si no hay nota), como en P05.
- Al cambiar de tipo se limpia la categoría seleccionada y su error; los errores de validación se pintan bajo el campo correspondiente. Los errores que no son `ValidacionException` muestran un SnackBar y conservan lo escrito (R7).
- En P05 el filtro de categoría ofrece «Todas» más las categorías de gasto e ingreso, y los cambios de tipo no borran el filtro de categoría.
- El test de onboarding se actualizó para comprobar la nueva ruta inicial (P05 «Movements») y que las 12 categorías en inglés se guardaron.

**Dudas o problemas pendientes:**
- No se ejecutó la prueba manual en teléfono (crear, editar y borrar) porque no hay dispositivo ni emulador Android conectado.

### Reporte — ronda 1

**Archivos modificados:**
- `lib/features/movimientos/providers/movimientos_providers.dart`: `movimientoProvider` pasa a `@riverpod Future<MovimientoConCategoria?> movimiento(Ref ref, int id)` (autoDispose), sin el comentario sobre la regla 9; `.g.dart` regenerado.
- `lib/features/movimientos/ui/movimiento_form_screen.dart`: el monto inicial se formatea con aritmética entera (`~/` y `%`), sin `double`.
- `test/features/movimientos/ui/movimiento_form_screen_test.dart`: el test de cambio de tipo ahora elige Comida, cambia a Ingreso, vuelve a Gasto, guarda y comprueba el error de categoría sin crear nada. Nuevo test `'editar, guardar y reabrir muestra el valor nuevo'`.

**Comandos ejecutados y resultado:**
- `dart run build_runner build` → generó el provider autoDispose; sin conflictos.
- `flutter analyze` → `No issues found!`
- `flutter test` → `All tests passed!` (74 tests)

**Decisiones tomadas / desvíos del brief:**
- El nuevo test reabre el mismo id tras guardar y comprueba que el campo muestra `30.00`; con el provider anterior habría mostrado `24.50`.
- No toqué los puntos no bloqueantes de la auditoría (chip de categoría archivada, errores de `eliminar`, prueba manual en teléfono).

**Dudas o problemas pendientes:**
- Ninguna nueva.

---

## Auditoría
*(La escribe Claude Code.)*

**Ronda 1 — 2026-11-13 — CAMBIOS_SOLICITADOS**

Lo verifiqué yo mismo: `flutter analyze` está limpio, los 73 tests pasan y `build_runner` no cambia el contenido de ningún `.g.dart`.
- P04 y P05 se parecen a sus PNG.
- Las claves de mes usan `inicioMes`.
- Los errores aparecen bajo cada campo, y R7 se cumple con un SnackBar sin perder lo escrito.
- La división en `form_fields.dart` y `estado_vacio.dart` está bien.

Desvíos que acepto:
- **Los dos widgets extra.** Son necesarios para cumplir la regla 8.
- **El ajuste del test de onboarding.** Ahora P05 es la ruta inicial.
- **Un `movimientoProvider` en el archivo de la 008.** Hace falta para cargar la edición. Su implementación hay que corregirla (punto 1).

Cambios:
1. **`movimientos_providers.dart`, `movimientoProvider`: muestra datos viejos tras editar.**
   - El provider es un `FutureProvider.family` sin `autoDispose`, así que se queda en memoria con el primer resultado.
   - Caso: abrir el movimiento 5, cambiar el monto a 30, guardar y volver a abrirlo. El formulario muestra el monto anterior.
   - La justificación de la regla 9 tampoco aplica: `MovimientoConCategoria` es una clase propia, y en la 008 `@riverpod` funcionó con ella.
   - Se espera `@riverpod Future<MovimientoConCategoria?> movimiento(Ref ref, int id)`, que es `autoDispose` por defecto, y quitar el comentario de la regla 9.
   - Test nuevo en `movimiento_form_screen_test.dart`: `'editar, guardar y reabrir muestra el valor nuevo'`. Abrir en edición, cambiar el monto, guardar, reabrir el mismo id y comprobar que el campo tiene el monto nuevo.
2. **`movimiento_form_screen.dart:74`: usa `double` con dinero** (`(centimos / 100).toStringAsFixed(2)`). ARQUITECTURA §4 pide manejar el dinero en enteros. Formatear con enteros: `'${centimos ~/ 100}.${(centimos % 100).toString().padLeft(2, '0')}'`.
3. **Al test `'cambiar a Ingreso…'` le falta la parte de «limpia la selección»** que pedía el brief.
   - Elegir Comida, cambiar a Ingreso, volver a Gasto, escribir un monto y pulsar Guardar.
   - Debe aparecer el error de categoría y no crearse ningún movimiento.

Observaciones que no bloquean:
- Al editar un movimiento cuya categoría está archivada, su chip no aparece, porque el provider excluye las archivadas. Se guarda bien, pero no se ve cuál está elegida. Lo retomo cuando planifique algo relacionado.
- `_borrar` no captura los errores de `eliminar`. Es poco probable que falle con una base local.
- Falta la prueba manual en el teléfono: crear, editar y borrar. La hará el usuario.

Volver a correr `build_runner`, `flutter analyze` y `flutter test`.

**Ronda 2 — 2026-11-13 — APROBADA**

Los tres cambios están hechos:
1. `movimiento` ahora es `@riverpod` (autoDispose) y ya no lleva el comentario de la regla 9. El test `'editar, guardar y reabrir muestra el valor nuevo'` comprueba que al reabrir se ve `30.00`.
2. `movimiento_form_screen.dart:76` arma el monto con `~/` y `%`, sin `double`.
3. El test de tipo elige Comida, pasa a Ingreso, vuelve a Gasto y guarda. Comprueba que aparece «Elige una categoría» y que no se crea nada.

`build_runner` no cambia nada, `flutter analyze` sale limpio y pasan los 74 tests. Las notas no bloqueantes de la Ronda 1 siguen abiertas: el chip de una categoría archivada y el try/catch de `_borrar`. La prueba manual en el teléfono queda a cargo del usuario.
