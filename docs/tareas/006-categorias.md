# 006 — Categorías: datos y pantalla P09

**Estado:** LISTA_PARA_AUDITORIA
**Tipo:** código
**Depende de:** 004, 005
**Referencias:** SPEC P09, R2, §4 (categorías por defecto) · ARQUITECTURA §3 · `docs/diseno/P09.png`, `P09b.png`

## Objetivo
El repositorio y los providers de categorías, con creación de las categorías por defecto, y la pantalla P09 para listarlas, crearlas, editarlas y archivarlas.

## Contexto
Todavía no existe la navegación inferior ni Ajustes (tarea 010). Registra la ruta `/ajustes/categorias` en el router; por ahora será la ruta inicial `/` para poder probarla. La 010 cambia la ruta inicial.

Pendiente heredado de la 004: en `lib/core/theme/app_theme.dart`, el `FilledButton` deshabilitado debe llevar borde `borde` de 1 dp (tokens.md §5, «Derivaciones de estado»). Sin borde, el botón blanco apenas se distingue del `fondo`.

## Alcance
**Se puede crear o modificar:**
- `lib/features/categorias/data/catalogo.dart`, `categorias_repository.dart`
- `lib/features/categorias/providers/categorias_providers.dart` (+ `.g.dart`)
- `lib/features/categorias/ui/categorias_screen.dart`, `categoria_form_sheet.dart`
- `lib/core/router/app_router.dart`, `lib/core/l10n/app_es.arb`, `app_en.arb`
- `lib/core/theme/app_theme.dart` (solo el borde del botón deshabilitado)
- `test/features/categorias/data/categorias_repository_test.dart`, `test/features/categorias/ui/categorias_screen_test.dart`
- `lib/features/categorias/ui/categoria_form_campos.dart` (añadido en la ronda 1 de auditoría)

## Interfaces
**Consume:** `AppDatabase`, `Categoria`, `TipoMovimiento`, `ValidacionException`, `AppColores.categorias`.
**Produce:**
```dart
// catalogo.dart
const Map<String, IconData> iconosCategoria;  // 16 claves estables: 'comida','transporte','vivienda','servicios',
// 'salud','entretenimiento','compras','educacion','otros','sueldo','extra','regalo','mascota','viaje','deporte','ahorro'

enum ResultadoEliminar { eliminada, archivada }

class CategoriasRepository {
  CategoriasRepository(AppDatabase db);
  Stream<List<Categoria>> watchPorTipo(TipoMovimiento tipo, {bool incluirArchivadas = false}); // orden por nombre
  Future<Categoria?> obtener(int id);
  Future<int> crear({required String nombre, required String icono, required int color, required TipoMovimiento tipo});
  Future<void> actualizar(int id, {required String nombre, required String icono, required int color});
  Future<ResultadoEliminar> eliminarOArchivar(int id);
  Future<bool> hayCategorias();
  /// Crea las categorías por defecto si no existe ninguna; si ya hay, no hace nada.
  /// `nombres` en el orden de SPEC §4. Íconos: la clave equivalente; colores: AppColores.categorias por orden.
  Future<void> crearPorDefecto({required List<String> gastos, required List<String> ingresos});
}

// providers
@Riverpod(keepAlive: true) CategoriasRepository categoriasRepository(Ref ref);
@riverpod Stream<List<Categoria>> categoriasPorTipo(Ref ref, TipoMovimiento tipo); // sin archivadas
```
Validación en `crear` y `actualizar`: `nombre.trim()` de 1 a 30 caracteres; si no se cumple, `ValidacionException('nombre', 'requerido' | 'muyLargo')`. El tipo no se puede cambiar tras crearla.

## Pasos
1. Tests del repositorio (base en memoria):
   ```dart
   test('crear y listar por tipo ordenado por nombre')
   test('nombre vacío o de 31 caracteres lanza ValidacionException')
   test('eliminar sin movimientos devuelve eliminada y desaparece')
   test('eliminar con movimientos devuelve archivada y no aparece en watchPorTipo')
   test('eliminar con regla recurrente devuelve archivada')
   test('watchPorTipo(incluirArchivadas: true) incluye las archivadas')
   test('crearPorDefecto crea 9 de gasto y 3 de ingreso; llamarla dos veces no duplica')
   ```
2. Implementar el catálogo, el repositorio y los providers. `build_runner`.
3. UI P09 según `P09.png` / `P09b.png`:
   - Pestañas Gasto | Ingreso.
   - Lista con ícono, color y nombre; las archivadas no se muestran.
   - Botón para crear. Tocar una categoría abre el formulario (`CategoriaFormSheet`, bottom sheet) con nombre, rejilla de íconos (`iconosCategoria`) y paleta de 12 colores.
   - En edición, la acción **Eliminar** con confirmación. Si el resultado es `archivada`, un SnackBar lo explica.
4. Todos los textos en los ARB, en es y en en.
5. Widget test: con la base en memoria (provider sobrescrito), escribir un nombre vacío y guardar muestra el error; escribir "Café" y guardar hace que aparezca en la lista.
6. `flutter analyze` y `flutter test`.

## Criterios de aceptación
- [ ] Los tests del paso 1 y del paso 5 pasan.
- [ ] La pantalla se parece a `P09.png` y a `P09b.png`.
- [ ] La UI no importa `AppDatabase` ni el repositorio directamente; solo los providers.
- [ ] `flutter analyze` sin errores ni advertencias.
- [ ] `flutter test` en verde.

---

## Reporte de implementación
*(Lo escribe Command Code. No borrar los títulos.)*

**Archivos creados o modificados:**
- `lib/features/categorias/data/catalogo.dart`: `iconosCategoria` (16 claves), `ResultadoEliminar` y `claveIcono()`.
- `lib/features/categorias/data/categorias_repository.dart`.
- `lib/features/categorias/providers/categorias_providers.dart` y `.g.dart` (generado).
- `lib/features/categorias/ui/categorias_screen.dart`.
- `lib/features/categorias/ui/categoria_form_sheet.dart`.
- `lib/core/router/app_router.dart`: rutas `/` y `/ajustes/categorias`, ambas a P09.
- `lib/core/l10n/app_es.arb`, `app_en.arb` y las clases generadas de l10n.
- `lib/core/theme/app_theme.dart`: borde `borde` de 1 dp en el `FilledButton` deshabilitado.
- `test/features/categorias/data/categorias_repository_test.dart`.
- `test/features/categorias/ui/categorias_screen_test.dart`.
- `test/widget_test.dart` (fuera del Alcance, ver desvíos).

**Comandos ejecutados y resultado:**
- `flutter gen-l10n` → clases de localización regeneradas.
- `dart run build_runner build` → `categorias_providers.g.dart` generado; sin conflictos.
- `flutter analyze` → `No issues found!`
- `flutter test` → `All tests passed!` (49 tests: 7 de repositorio y el widget test de P09 incluidos)

**Decisiones tomadas / desvíos del brief:**
- `ResultadoEliminar` vive en `catalogo.dart` (y no en el repositorio) para que la UI pueda comparar el resultado sin importar `categorias_repository.dart`, cumpliendo la regla de capas. La UI solo importa providers, `Categoria` y el catálogo.
- `categoriasPorTipoProvider` está escrito a mano como `StreamProvider.family<List<Categoria>, TipoMovimiento>` porque `riverpod_generator` 4.0.10 falla con «Invalid provider type: the return type … could not be resolved» cuando el tipo de retorno incluye una clase generada por Drift. Comprobé que `Stream<int>`, `Stream<List<AppDatabase>>` y `Stream<List<Categoria>>` sin la anotación compilan; el problema está aislado en el generador. El repositorio sigue con `@Riverpod(keepAlive: true)` y usa el `.g.dart`.
- `CategoriasRepository.crear` es `async` para que los errores de validación lleguen como `Future` fallido y no como excepción síncrona.
- La pantalla solo muestra categorías activas, como pide el paso 3. La fila incluye la marca «Archivada» por si más adelante se listan archivadas, pero con el provider actual no aparece ninguna; por eso P09 (que muestra «Cine · Archivada») no se reproduce al pie de la letra en ese punto.
- Los textos de la pantalla y del formulario están en los ARB; el tipo solo se puede cambiar al crear.
- `test/widget_test.dart` se ajustó porque `App` ahora abre P09 y, sin override, intentaba abrir la base real con `drift_flutter` (timers pendientes en el test). Se sobrescribe `appDatabaseProvider` con una base en memoria y se desmonta el árbol antes de terminar.

**Dudas o problemas pendientes:**
- El generador de Riverpod no admite por ahora tipos generados por Drift en el retorno de un provider; si se actualiza `riverpod_generator` y se corrige, `categoriasPorTipoProvider` puede volver a `@riverpod`.

**Reporte – ronda 1**

- Creado `lib/features/categorias/ui/categoria_form_campos.dart` con `SelectorTipo`, `BotonIcono` y `BotonColor` (públicos, sin `_`).
- `categoria_form_sheet.dart` pasa de 366 a 237 líneas; importa el nuevo archivo y no cambia de comportamiento.
- `flutter analyze` → `No issues found!`
- `flutter test` → `All tests passed!` (49 tests)

---

## Auditoría
*(La escribe Claude Code.)*

**Ronda 1 — fecha — resultado:**
-

**Ronda 1 — 2026-11-12 — CAMBIOS_SOLICITADOS**

Lo verifiqué yo mismo: `flutter analyze` está limpio, los 49 tests pasan y `build_runner` no cambia el contenido de ningún `.g.dart`.
- El repositorio, la validación, el archivado (con movimientos o con reglas), `crearPorDefecto` y el borde del botón deshabilitado están bien.
- Las claves de ícono de las 12 categorías por defecto existen en el catálogo.
- La UI solo pasa por providers.

Desvíos que acepto:
- **Provider a mano para `categoriasPorTipo`.** Lo convertí en norma en ARQUITECTURA §3, regla 9, para las próximas tareas.
- **`ResultadoEliminar` en `catalogo.dart`.**
- **Ajuste de `test/widget_test.dart`.** Era necesario.
- **Secciones Gastos/Ingresos en lugar de pestañas.** Así lo muestra `P09.png`, y el diseño manda.

Hay un único cambio:
1. **`lib/features/categorias/ui/categoria_form_sheet.dart` tiene 366 líneas.** ARQUITECTURA §3, regla 8, pide dividir los archivos de más de unas 300.
   - Mover `_SelectorTipo`, `_BotonIcono` y `_BotonColor` a `lib/features/categorias/ui/categoria_form_campos.dart` (ya está en el Alcance). Al cambiar de archivo dejan de ser privados: quitarles el `_`.
   - No hay que cambiar el comportamiento. Volver a correr `flutter analyze` y `flutter test`.

**Ronda 2 — 2026-11-12 — APROBADA**

`SelectorTipo`, `BotonIcono` y `BotonColor` están ahora en `categoria_form_campos.dart` (142 líneas). `categoria_form_sheet.dart` bajó a 236 líneas. El comportamiento no cambió. Lo verifiqué yo mismo: `flutter analyze` está limpio y los 49 tests pasan.
