# 015 — Resumen P06 con gráficos

**Estado:** APROBADA
**Tipo:** código
**Depende de:** 010
**Referencias:** SPEC P06, R2 (las archivadas aparecen en el resumen) · `docs/diseno/P06.png`, `P06b.png`

## Objetivo
La pestaña Resumen: gráfico circular de gastos por categoría del mes elegido y barras de ingresos vs. gastos de los últimos 6 meses.

## Alcance
**Se puede crear o modificar:**
- `lib/features/resumen/data/resumen_repository.dart`
- `lib/features/resumen/providers/resumen_providers.dart` (+ `.g.dart`)
- `lib/features/resumen/ui/resumen_screen.dart` (sustituye la pantalla mínima de la 010), `lib/features/resumen/ui/widgets/grafico_categorias.dart`, `grafico_meses.dart`
- Los ARB
- `test/features/resumen/data/resumen_repository_test.dart`, `test/features/resumen/ui/resumen_screen_test.dart`

## Interfaces
**Consume:** `AppDatabase`, `Categoria`, `TotalesMes`, `SelectorMes`, `inicioMes`, `inicioMesSiguiente`, `formatSoles`.
**Produce:**
```dart
class GastoPorCategoria { const GastoPorCategoria({required this.categoria, required this.totalCentimos, required this.porcentaje});
  final Categoria categoria; final int totalCentimos; final double porcentaje; /* 0–100, solo para mostrar */ }

class ResumenRepository {
  ResumenRepository(AppDatabase db);
  /// Solo gastos del mes, incluidas las categorías archivadas, ordenados por total desc. Categorías con 0 no aparecen.
  Stream<List<GastoPorCategoria>> watchGastosPorCategoria(DateTime mes);
  /// Exactamente `cantidad` elementos, del más antiguo al más reciente, terminando en `mesFinal`.
  /// Los meses sin movimientos aparecen con 0.
  Stream<List<TotalesMes>> watchUltimosMeses(DateTime mesFinal, {int cantidad = 6});
}
@Riverpod(keepAlive: true) ResumenRepository resumenRepository(Ref ref);
@riverpod Stream<List<GastoPorCategoria>> gastosPorCategoria(Ref ref, DateTime mes);
@riverpod Stream<List<TotalesMes>> ultimosMeses(Ref ref, DateTime mesFinal);
```

## Pasos
1. Tests del repositorio:
   ```dart
   test('agrupa gastos por categoría y calcula porcentajes que suman 100')
   test('ignora ingresos y otros meses')
   test('incluye categorías archivadas con gastos')
   test('ultimosMeses(2026-03) devuelve oct 2025 … mar 2026 (6), con ceros en meses vacíos')
   ```
2. Implementar el repositorio (`SUM` con `GROUP BY`; completar los meses vacíos en Dart) y los providers.
3. UI según `P06*.png`:
   - `SelectorMes`.
   - `GraficoCategorias`: `PieChart` de fl_chart con el color de cada categoría y una leyenda con nombre, monto y %.
   - `GraficoMeses`: `BarChart` con dos barras por mes (`ingreso` y `gasto`) y la abreviatura del mes según el idioma.
   - Estado vacío si el mes no tiene gastos (`P06b`).
4. Widget test: con datos, se muestran la leyenda y los montos; sin datos, el estado vacío.
5. `flutter analyze` y `flutter test`.

## Criterios de aceptación
- [ ] Los tests de los pasos 1 y 4 pasan.
- [ ] La pantalla se parece a sus PNG.
- [ ] Los totales se calculan en céntimos `int`; solo el porcentaje es `double`.
- [ ] `flutter analyze` sin errores ni advertencias.
- [ ] `flutter test` en verde.

---

## Reporte de implementación
*(Lo escribe Command Code. No borrar los títulos.)*

**Archivos creados o modificados:**
- `lib/features/resumen/data/resumen_repository.dart`.
- `lib/features/resumen/providers/resumen_providers.dart` y su `.g.dart`.
- `lib/features/resumen/ui/resumen_screen.dart`, `ui/widgets/grafico_categorias.dart`, `grafico_meses.dart`.
- `lib/core/l10n/app_es.arb`, `app_en.arb` y clases generadas.
- `test/features/resumen/data/resumen_repository_test.dart`, `test/features/resumen/ui/resumen_screen_test.dart`.

**Comandos ejecutados y resultado:**
- `dart run build_runner build --delete-conflicting-outputs` → providers generados sin errores.
- `flutter gen-l10n` → textos nuevos generados.
- `flutter analyze` → `No issues found!`
- `flutter test` → `All tests passed!` (127 tests; 6 nuevos)

**Decisiones tomadas / desvíos del brief:**
- `watchGastosPorCategoria` usa `SUM` + `GROUP BY` sobre el join con categorías (sin filtrar archivadas) y calcula en Dart el porcentaje como `double`; los totales siguen en céntimos `int`.
- `watchUltimosMeses` emite el valor inicial y se suscribe a `tableUpdates` de movimientos, cancelando la suscripción. Completa los meses vacíos con ceros mediante una consulta por mes.
- La leyenda del gráfico circular muestra punto de color, nombre y porcentaje, como el PNG P06; el monto total aparece en el centro del donut y en las barras. El texto del brief pedía también el monto en la leyenda, pero se prioriza el diseño.
- El estado vacío (P06b) oculta también el gráfico de meses aunque existan movimientos en otros meses, tal como muestra el PNG.
- El selector de mes está en las acciones del AppBar y comparte `SelectorMes` con P05.

**Dudas o problemas pendientes:**
- Ninguna.

---

## Auditoría
*(La escribe Claude Code.)*

**Ronda 1 — 2026-11-15 — APROBADA**

Verificado: `flutter analyze` sin problemas, `flutter test` 127 en verde, `build_runner` sin cambios en `.g.dart`. Solo se tocaron archivos del Alcance. P06 y P06b se parecen a sus PNG. Los totales van en céntimos `int` y solo el porcentaje es `double`. Las categorías archivadas aparecen (R2). Los 6 meses salen completos y con ceros. Se acepta la leyenda sin monto por categoría: coincide con el PNG y con SPEC P06 ("leyenda y %"), y el total está en el centro del donut.

Notas no bloqueantes:
- Un mes que solo tiene ingresos muestra "Sin datos en {mes}" y oculta también las barras de 6 meses. Sigue el brief y el PNG, pero puede confundir; revisarlo si molesta en el uso real.
- Los tamaños del gráfico (148, 22, 48, 170, 7 y 240) son números fijos en lugar de constantes de `dimensiones.dart`.
- Si la consulta falla, la pantalla queda vacía sin mensaje (igual que en otras pantallas).
