# 012 — Presupuesto: pantalla P07 y avisos en Inicio

**Estado:** APROBADA
**Tipo:** código
**Depende de:** 010, 011
**Referencias:** SPEC P03, P07, R3, R4 · `docs/diseno/P07.png`, `P03.png`, `P03c.png`

## Objetivo
Configurar el presupuesto total y los presupuestos por categoría (P07), y mostrar en Inicio la barra del presupuesto total y el banner de alerta.

## Alcance
**Se puede crear o modificar:**
- `lib/features/presupuesto/ui/presupuesto_screen.dart`, `lib/features/presupuesto/ui/widgets/barra_progreso.dart`, `banner_alerta.dart`
- `lib/features/inicio/ui/inicio_screen.dart`
- `lib/features/ajustes/ui/ajustes_screen.dart` (entrada "Presupuesto")
- `lib/core/router/app_router.dart` (`Rutas.presupuesto = '/ajustes/presupuesto'`), los ARB
- `test/features/presupuesto/ui/presupuesto_screen_test.dart`, `test/features/inicio/ui/inicio_screen_test.dart`

## Interfaces
**Consume:** `presupuestosRepositoryProvider`, `progresoPresupuestoProvider(DateTime mes)`, `ProgresoPresupuesto`, `categoriasPorTipoProvider(TipoMovimiento.gasto)`, `notificadorProvider` (como `NotificadorLocal` para `pedirPermiso`), `CampoMonto`, `formatSoles`.
**Produce:**
```dart
class BarraProgreso extends StatelessWidget { const BarraProgreso({required this.progreso}); final ProgresoPresupuesto progreso; }
// colores: < 80 primario, >= 80 alerta, >= 100 gasto
class BannerAlerta extends StatelessWidget { const BannerAlerta({required this.progresos}); final List<ProgresoPresupuesto> progresos; }
// solo se muestra si algún progreso tiene enAlerta == true
```

## Pasos
1. Widget tests:
   ```dart
   testWidgets('P07: guardar total S/ 1000 crea el presupuesto y muestra su progreso')
   testWidgets('P07: borrar el monto de una categoría elimina su presupuesto')
   testWidgets('Inicio con total 100000 y gastos 85000 muestra barra al 85% y banner')
   testWidgets('Inicio sin presupuesto no muestra ni barra ni banner')
   ```
2. P07 según `P07.png`:
   - Campo del presupuesto total con su `BarraProgreso` del mes actual.
   - Lista de las categorías de gasto (sin archivadas), cada una con un monto opcional y su barra si tiene presupuesto.
   - Al guardar el primer presupuesto, llamar a `pedirPermiso()`. Si se rechaza, continuar sin errores (R4).
3. Inicio: bajo `TarjetaBalance`, la `BarraProgreso` del presupuesto total (si existe) y el `BannerAlerta` (`P03c`). Tocar el banner abre P07.
4. Ajustes: entrada "Presupuesto" → `Rutas.presupuesto`.
5. `flutter analyze` y `flutter test`. En el teléfono: crear un presupuesto pequeño, registrar gastos hasta superar el 80 % y comprobar que llega una sola notificación.

## Criterios de aceptación
- [ ] Los widget tests del paso 1 pasan.
- [ ] Las pantallas se parecen a sus PNG.
- [ ] Rechazar el permiso de notificaciones no rompe nada.
- [ ] `flutter analyze` sin errores ni advertencias.
- [ ] `flutter test` en verde.

---

## Reporte de implementación
*(Lo escribe Command Code. No borrar los títulos.)*

**Archivos creados o modificados:**
- `lib/features/presupuesto/ui/presupuesto_screen.dart`.
- `lib/features/presupuesto/ui/widgets/barra_progreso.dart`, `banner_alerta.dart` y `dialogo_monto.dart` (extraído para respetar la regla 8).
- `lib/features/inicio/ui/inicio_screen.dart`: bloque de presupuesto total y banner.
- `lib/features/ajustes/ui/ajustes_screen.dart`: entrada «Presupuesto».
- `lib/core/router/app_router.dart`: `Rutas.presupuesto` y su ruta de nivel superior.
- `lib/core/l10n/app_es.arb`, `app_en.arb` y clases generadas.
- `test/features/presupuesto/ui/presupuesto_screen_test.dart`, `test/features/inicio/ui/inicio_screen_test.dart`.

**Comandos ejecutados y resultado:**
- `flutter gen-l10n` → textos nuevos generados.
- `flutter analyze` → `No issues found!`
- `flutter test` → `All tests passed!` (99 tests; 4 nuevos)

**Decisiones tomadas / desvíos del brief:**
- `BarraProgreso` dibuja la barra (color según <80, >=80 y >=100) y el texto «gastado de límite»; las pantallas ponen la etiqueta y el porcentaje para reproducir P07 y P03c.
- P07 muestra solo las categorías con presupuesto, como el PNG. Tocar una fila abre el diálogo para editarla o, si se vacía el monto, eliminarla; «Añadir límite por categoría» abre la lista de categorías de gasto y después el mismo diálogo.
- El permiso de notificaciones se pide solo cuando se guarda el primer presupuesto (lista de progresos vacía). Un rechazo o un fallo del plugin se ignoran.
- `BannerAlerta` usa el primer progreso en alerta (el total va primero) y no pinta nada si ninguno llega al 80 %; Inicio lo envuelve para abrir P07 al tocarlo.
- Inicio no muestra ni barra ni banner si no existe presupuesto total.
- `dialogo_monto.dart` se añade al Alcance para que la pantalla no pase de ~300 líneas; contiene el diálogo reutilizado para total y categorías.

**Dudas o problemas pendientes:**
- No se ejecutó la comprobación manual en el teléfono (presupuesto pequeño, gastos hasta el 80 % y notificación única) porque no hay dispositivo ni emulador conectado.

### Reporte – ronda 2

**Cambios realizados:**
- `_BloquePresupuesto` de Inicio ya no sale antes de mirar las alertas: la barra solo se pinta si hay presupuesto total, pero el `BannerAlerta` aparece siempre que algún progreso tenga `enAlerta`. Sin total, el bloque conserva su margen superior y no añade el separador interno de la barra.
- `BannerAlerta` distingue categoría y total: si `progreso.categoria != null` usa la nueva clave `categoriaAlertaTitulo` («{categoria} al {porcentaje} %»); el total mantiene `presupuestoAlertaTitulo`.
- `EncabezadoProgreso` se movió de `dialogo_monto.dart` a `barra_progreso.dart`. Inicio lo reutiliza en lugar de repetir la `Row` de etiqueta y porcentaje.
- Nuevo test `'solo con presupuesto de Comida al 85 % muestra el banner con el nombre y sin barra'` en `inicio_screen_test.dart`.
- Nuevas claves `categoriaAlertaTitulo` en `app_es.arb` y `app_en.arb`; clases de localización regeneradas.

**Comandos ejecutados y resultado:**
- `flutter gen-l10n` → textos generados.
- `flutter analyze` → `No issues found!`
- `flutter test` → `All tests passed!` (100 tests)

---

## Auditoría
*(La escribe Claude Code.)*

**Ronda 1 — 2026-11-15 — CAMBIOS_SOLICITADOS**

Verificado: `flutter analyze` sin problemas, `flutter test` 99 en verde, `build_runner` sin cambios en `.g.dart`. P07 y P03c se parecen a sus PNG; el permiso se pide solo con el primer presupuesto y un rechazo no rompe nada. Se acepta mostrar en P07 solo las categorías con límite (como el PNG) y el archivo extra `dialogo_monto.dart`.

Cambios pedidos:
1. **El aviso no sale sin presupuesto total (incumple R4).** `inicio_screen.dart`, `_BloquePresupuesto`: si no hay total devuelve `SizedBox.shrink()` antes de mirar el banner. R4 dice "mientras el gasto del mes actual sea ≥ 80 % de **algún** presupuesto". Esperado: la barra solo si existe el total; el `BannerAlerta` siempre que algún progreso tenga `enAlerta`, aunque no haya total (en ese caso sin el margen superior de la barra, con el mismo espaciado que tendría el bloque).
2. **El texto del banner no dice qué presupuesto es.** `banner_alerta.dart`: con un presupuesto de categoría muestra "Presupuesto al 84 %", que se lee como el total. Esperado: si `progreso.categoria != null`, título "{categoria} al {porcentaje} %" (nueva clave ARB `categoriaAlertaTitulo`, es y en); el total sigue con "Presupuesto al {porcentaje} %". El cuerpo puede quedar igual.
3. **`EncabezadoProgreso` está en el archivo equivocado.** `dialogo_monto.dart` contiene `EncabezadoProgreso`, que no tiene que ver con el diálogo. Muévelo a `barra_progreso.dart` y úsalo también en `_BloquePresupuesto` de Inicio en lugar de repetir la misma `Row`.
4. **Test que lo cubra** en `inicio_screen_test.dart`: `'solo con presupuesto de Comida al 85 % muestra el banner con el nombre y sin barra'` → existe `BannerAlerta`, aparece `'Comida al 85 %'` y no aparece `'Presupuesto total'`.

Nota no bloqueante: la prueba en el teléfono queda pendiente para el usuario.

**Ronda 2 — 2026-11-15 — APROBADA**

Verificado: `flutter analyze` sin problemas, `flutter test` 100 en verde, `build_runner` sin cambios en `.g.dart`. Los cuatro puntos de la Ronda 1 están resueltos: el banner sale aunque no haya presupuesto total (R4), nombra la categoría («Comida al 85 %»), `EncabezadoProgreso` vive en `barra_progreso.dart` y se reutiliza en Inicio, y el nuevo test cubre el caso.

Notas no bloqueantes:
- El Estado no se devolvió a `LISTA_PARA_AUDITORIA` al entregar la ronda; recordar hacerlo la próxima vez.
- Queda pendiente la prueba en el teléfono (presupuesto pequeño, gastos hasta el 80 % y una sola notificación).
