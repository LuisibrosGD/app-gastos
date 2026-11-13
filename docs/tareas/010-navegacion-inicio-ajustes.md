# 010 — Navegación, Inicio P03 y Ajustes P10

**Estado:** APROBADA
**Tipo:** código
**Depende de:** 007, 009
**Referencias:** SPEC P03, P10 · ARQUITECTURA §5 (Router) · `docs/diseno/P03.png`, `P03b.png`, `P10.png`

## Objetivo
La navegación inferior con 4 pestañas, la pantalla de Inicio (balance del mes, últimos movimientos, botón +) y Ajustes con el idioma y el acceso a Categorías.

## Contexto
- La barra de presupuesto y el banner de alerta de Inicio llegan en la 012.
- En Ajustes, las entradas de Presupuesto (012), Recurrentes (014) y Seguridad (016) se añaden en sus tareas. **No crear entradas vacías ni marcadores "próximamente".**
- Resumen (015) todavía no existe: su pestaña muestra una pantalla mínima con su título, que la 015 sustituirá.

Ojo con los providers de la 008: `movimientosMesProvider(filtro)` y `totalesMesProvider(mes)` usan la fecha como clave. Pasa siempre `inicioMes(...)`, nunca `DateTime.now()`. Si no, cada reconstrucción crea un provider nuevo y la consulta se reabre una y otra vez.

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
- `lib/core/router/app_router.dart`: `Rutas`, `StatefulShellRoute.indexedStack` con las 4 ramas y redirect de onboarding a `/inicio`.
- `lib/core/router/shell_scaffold.dart`: `NavigationBar` de 4 pestañas con `goBranch`.
- `lib/features/inicio/ui/inicio_screen.dart` y `widgets/tarjeta_balance.dart`.
- `lib/features/ajustes/ui/ajustes_screen.dart`.
- `lib/features/resumen/ui/resumen_screen.dart` (pantalla mínima con su título).
- `lib/features/movimientos/ui/widgets/movimiento_tile.dart`: parámetro opcional `mostrarFecha` (ver desvíos).
- `lib/core/l10n/app_es.arb`, `app_en.arb` y clases generadas.
- `test/core/router/app_router_test.dart`, `test/features/inicio/ui/inicio_screen_test.dart`, `test/features/ajustes/ui/ajustes_screen_test.dart`.

**Comandos ejecutados y resultado:**
- `flutter gen-l10n` → textos nuevos generados.
- `flutter analyze` → `No issues found!`
- `flutter test` → `All tests passed!` (80 tests; 6 nuevos)

**Decisiones tomadas / desvíos del brief:**
- `MovimientoTile` recibe `mostrarFecha` (por defecto `false`): P03 muestra «Comida · Hoy» en cada fila y P05 no muestra fecha. Sin ese parámetro no se podía reproducir el diseño; el valor por defecto conserva P05 y la 014.
- El botón «Ver todos» usa `context.go(Rutas.movimientos)` para cambiar de rama sin apilar; el FAB usa `push` para abrir P04 a pantalla completa.
- Inicio usa `movimientosRecientesProvider` (5 últimos) y `totalesMesProvider(inicioMes(now))`; la barra de presupuesto y el banner quedan para la 012.
- Ajustes solo contiene Idioma y Categorías; no hay filas vacías ni «próximamente». El selector de idioma es un diálogo con Español/English.
- Resumen es una pantalla mínima con su AppBar, sin contenido, para que la 015 la sustituya.
- P04 y Categorías son rutas de nivel superior, fuera del shell.

**Dudas o problemas pendientes:**
- Ninguna.

---

## Auditoría
*(La escribe Claude Code.)*

**Ronda 1 — 2026-11-13 — APROBADA**

- Pasan los 6 tests del paso 1. Corrí `flutter analyze` y salió limpio, pasan los 80 tests y `build_runner` no cambia nada.
- Inicio (P03 y P03b) y Ajustes (P10) se ven como en sus PNG, sin las filas que llegan en la 012, la 014 y la 016. Ajustes no tiene entradas vacías ni «próximamente».
- `totalesMesProvider` recibe `inicioMes(...)`, como pide el Contexto.
- Acepto el desvío en `movimiento_tile.dart` (fuera del alcance): `mostrarFecha` es opcional, vale `false` por defecto y P05 no cambia.

Notas, no bloquean:
- `movimientos_screen.dart:185` y `:243` todavía tienen las rutas escritas a mano. Hay que cambiarlas por `Rutas.nuevoMovimiento` y `Rutas.movimiento(id)` la próxima vez que se toque ese archivo.
- Si falla la carga, Inicio no muestra nada (`SizedBox.shrink`). Con una base local es poco probable.
- `_EstadoVacioInicio` y `_FilaAjuste` usan `AppEspacio` como tamaño de ícono. Ya está anotado en la 016.
