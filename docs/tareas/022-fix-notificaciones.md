# 022 — Corrección: notificaciones del presupuesto

**Estado:** PENDIENTE
**Tipo:** código
**Depende de:** 011, 017 (parcial)
**Referencias:** SPEC P07 / R4 · ARQUITECTURA §3 · tarea 017 (Auditoría, ronda 2)

## Objetivo
Al guardar a mano un gasto que cruza el 80 % o el 100 % de un presupuesto, llega una notificación por umbral y mes. Si mostrarla falla, el error queda registrado y no se pierde en silencio.

## Contexto
En el teléfono sale el banner de Inicio, pero no llega ninguna notificación (017, ronda 2). Hay dos causas posibles y esta tarea corrige las dos:

1. **Controlador destruido a mitad de `guardar` (la más probable).** `movimiento_form_screen.dart` llama a `guardar` con `ref.read(movimientosControllerProvider.notifier)` y nadie escucha ese provider. `MovimientosController` es `@riverpod`, así que se destruye en cuanto nadie lo usa. Después del `await` que guarda en la base de datos, su `ref` puede estar ya destruido. Entonces `ref.read(alertasServiceProvider)` lanza una excepción y el `catch (_) {}` la oculta. Es el mismo tipo de problema de Riverpod 3 que se vio en la tarea 018. El generador de recurrentes sí notificó en la ronda 1 porque usa providers `keepAlive`.
2. **Ícono de notificación.** `NotificadorLocal` usa `@mipmap/ic_launcher`. Desde la 017 ese recurso es un ícono adaptativo, y Android pide como ícono pequeño un drawable monocromo (blanco sobre transparente).

## Alcance
**Archivos que se pueden crear o modificar:**
- `lib/features/movimientos/providers/movimientos_providers.dart` (y su `.g.dart` regenerado)
- `lib/features/presupuesto/data/notificador.dart`
- `android/app/src/main/res/drawable/ic_notificacion.xml` (nuevo)
- `android/app/src/main/res/raw/keep.xml` (nuevo, solo si hace falta para que el build release no elimine el drawable)
- `test/features/movimientos/providers/movimientos_controller_test.dart`
- `test/features/movimientos/ui/movimiento_form_screen_test.dart`

**Fuera de alcance (no tocar):**
- `alertas_service.dart`: la lógica de umbrales (R4) es correcta y está probada.
- El banner de Inicio, P07 y las recurrentes.
- Dependencias nuevas.

## Pasos
1. **Test que falla primero.** En `movimiento_form_screen_test.dart`, añade un widget test con `notificadorProvider` sustituido por un `NotificadorFalso` (como en `movimientos_controller_test.dart`):
   - Crea un presupuesto total de S/ 100.
   - Desde el formulario, guarda un gasto de S/ 85 y deja que la pantalla se cierre (`pumpAndSettle`).
   - Comprueba que el notificador recibió exactamente 1 llamada.
   - Ejecútalo antes de corregir y anota en el reporte si falla. Si pasa, dilo también: entonces la causa 1 no se reproduce en test y pesa más la causa 2.
2. **Controlador.** Cambia `MovimientosController` a `@Riverpod(keepAlive: true)`. Es un controlador sin estado propio, así que mantenerlo vivo no cuesta nada y evita que se destruya a mitad de `guardar`. Regenera con `build_runner`.
3. **No silenciar el error.** En `guardar`, sustituye `catch (_) {}` por un `catch (error, pila)` que llame a `FlutterError.reportError(FlutterErrorDetails(exception: error, stack: pila, library: 'alertas'))`. El gasto ya está guardado, así que `guardar` sigue devolviendo el id sin relanzar. El error queda visible en el logcat. No uses `print`.
4. **Ícono.** Crea `res/drawable/ic_notificacion.xml`, un vector monocromo blanco de 24 dp (una billetera o una moneda, en línea con el ícono de la app). Úsalo en `AndroidInitializationSettings('ic_notificacion')` y en `AndroidNotificationDetails(icon: 'ic_notificacion')`. Si el build release elimina el recurso al reducir tamaño, añade `res/raw/keep.xml` con `tools:keep="@drawable/ic_notificacion"`.
5. **Test del error.** En `movimientos_controller_test.dart`, añade un test con un notificador que lanza una excepción en `mostrar`:
   - `guardar` devuelve el id y el gasto queda en la base de datos.
   - El error se reporta (captúralo sustituyendo `FlutterError.onError` dentro del test y restáuralo al final).
6. `flutter analyze`, `flutter test` y `flutter build apk --release --split-per-abi`.

## Criterios de aceptación
- [ ] El widget test del paso 1 pasa: guardar desde el formulario un gasto que cruza el 80 % produce exactamente 1 notificación.
- [ ] `MovimientosController` es `keepAlive`.
- [ ] Ya no hay `catch (_) {}` en `guardar`; un fallo del notificador se reporta con `FlutterError.reportError` y el gasto se guarda igual (test del paso 5).
- [ ] La notificación usa `ic_notificacion` (drawable vectorial monocromo), no `@mipmap/ic_launcher`.
- [ ] Los tests existentes de alertas (80 % y 100 %, una vez por mes) siguen en verde sin cambios.
- [ ] `flutter build apk --release --split-per-abi` sin errores.
- [ ] `flutter analyze` sin errores ni advertencias.
- [ ] `flutter test` en verde (incluidos los tests nuevos de esta tarea).

## Prueba en el teléfono (después de aprobar, dentro de la 017)
Con un presupuesto de categoría **nuevo** (que no haya avisado este mes):
- Un gasto a mano que pase del 80 % → llega 1 notificación al momento, con el ícono blanco.
- Otro gasto que pase del 100 % → llega 1 notificación más.
- Otro gasto más → ninguna notificación nueva.

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
