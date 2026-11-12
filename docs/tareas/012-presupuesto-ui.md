# 012 — Presupuesto: pantalla P07 y avisos en Inicio

**Estado:** PENDIENTE
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
