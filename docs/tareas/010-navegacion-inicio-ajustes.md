# 010 — Navegación, Inicio P03 y Ajustes P10

**Estado:** PENDIENTE
**Tipo:** código
**Depende de:** 007, 009
**Referencias:** SPEC P03, P10 · ARQUITECTURA §5 (Router) · `docs/diseno/P03.png`, `P03b.png`, `P10.png`

## Objetivo
La navegación inferior con 4 pestañas, la pantalla de Inicio (balance del mes, últimos movimientos, botón +) y Ajustes con el idioma y el acceso a Categorías.

## Contexto
- La barra de presupuesto y el banner de alerta de Inicio llegan en la 012.
- En Ajustes, las entradas de Presupuesto (012), Recurrentes (014) y Seguridad (016) se añaden en sus tareas. **No crear entradas vacías ni marcadores "próximamente".**
- Resumen (015) todavía no existe: su pestaña muestra una pantalla mínima con su título, que la 015 sustituirá.

## Alcance
**Se puede crear o modificar:**
- `lib/core/router/app_router.dart`, `lib/core/router/shell_scaffold.dart`
- `lib/features/inicio/ui/inicio_screen.dart`, `lib/features/inicio/ui/widgets/tarjeta_balance.dart`
- `lib/features/ajustes/ui/ajustes_screen.dart`
- `lib/features/resumen/ui/resumen_screen.dart` (solo la pantalla mínima)
- Los ARB
- `test/core/router/app_router_test.dart`, `test/features/inicio/ui/inicio_screen_test.dart`, `test/features/ajustes/ui/ajustes_screen_test.dart`

## Interfaces
**Consume:** `totalesMesProvider`, `movimientosRecientesProvider`, `MovimientoTile`, `idiomaActualProvider`, `onboardingCompletoProvider`, `formatSoles`.
**Produce:**
```dart
// Rutas (constantes en app_router.dart)
abstract final class Rutas {
  static const inicio = '/inicio', movimientos = '/movimientos', resumen = '/resumen', ajustes = '/ajustes';
  static const onboarding = '/onboarding', nuevoMovimiento = '/movimiento/nuevo';
  static String movimiento(int id) => '/movimiento/$id';
  static const categorias = '/ajustes/categorias';
  // 012: presupuesto = '/ajustes/presupuesto'; 014: recurrentes = '/ajustes/recurrentes'; 016: bloqueo = '/bloqueo'
}
class TarjetaBalance extends StatelessWidget { const TarjetaBalance({required this.totales}); final TotalesMes totales; }
```

## Pasos
1. Tests:
   ```dart
   testWidgets('con onboarding completo la ruta inicial es /inicio')
   testWidgets('la barra inferior navega entre las 4 pestañas y conserva el estado de cada una')
   testWidgets('Inicio muestra balance S/ 649.50 con ingresos 100000 y gastos 35050')
   testWidgets('Inicio sin movimientos muestra el estado vacío')
   testWidgets('el botón + abre /movimiento/nuevo')
   testWidgets('en Ajustes, cambiar a English traduce la pantalla')
   ```
2. Router con `StatefulShellRoute.indexedStack` (4 ramas). P04 y Categorías se abren por encima del shell, a pantalla completa. Mantener el redirect de onboarding de la 007.
3. `ShellScaffold` con `NavigationBar` (íconos y textos según `P03.png`).
4. `InicioScreen`: `TarjetaBalance` del mes actual (ingresos, gastos y balance, con colores), los últimos 5 movimientos con un enlace "Ver todos" a la pestaña Movimientos, un FAB **+** y el estado vacío (`P03b`).
5. `AjustesScreen`: selector de idioma (Español/English) y una entrada "Categorías" → `Rutas.categorias`.
6. `flutter analyze` y `flutter test`.

## Criterios de aceptación
- [ ] Los tests del paso 1 pasan.
- [ ] Inicio y Ajustes se parecen a sus PNG.
- [ ] No hay entradas vacías ni "próximamente" en Ajustes.
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
