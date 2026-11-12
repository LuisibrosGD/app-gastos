# 006 — Categorías: datos y pantalla P09

**Estado:** PENDIENTE
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
