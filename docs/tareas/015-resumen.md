# 015 — Resumen P06 con gráficos

**Estado:** PENDIENTE
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
