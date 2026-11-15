# 019 — Ver y restaurar categorías archivadas en P09

**Estado:** PENDIENTE
**Tipo:** código
**Depende de:** 006
**Referencias:** SPEC P09, R2 · Tarea 017, checklist (fallo P09)

## Objetivo
En Categorías se ven las categorías archivadas, en una sección aparte, y se pueden restaurar.

## Contexto
Hoy una categoría con movimientos se archiva bien, pero desaparece de P09 y no hay forma de recuperarla. `categorias_screen.dart` usa `categoriasPorTipoProvider`, que excluye las archivadas, aunque la fila ya tiene la etiqueta `l10n.categoriaArchivada` preparada. Decisión del usuario: se pueden ver **y restaurar**. Al restaurar, la categoría vuelve a aparecer en los selectores (R2).

## Alcance
**Se puede crear o modificar:**
- `lib/features/categorias/data/categorias_repository.dart`: añadir `Future<void> restaurar(int id)` (pone `archivada = false`) y `Stream<List<Categoria>> watchArchivadas()` (todas las archivadas de los dos tipos, ordenadas por nombre).
- `lib/features/categorias/providers/categorias_providers.dart`: añadir `categoriasArchivadasProvider`.
- `lib/features/categorias/ui/categorias_screen.dart`: sección «Archivadas» al final, solo si hay alguna, con la etiqueta «Archivada» en cada fila.
- `lib/features/categorias/ui/categoria_form_sheet.dart`: si la categoría está archivada, en lugar de «Eliminar» se muestra «Restaurar». Restaurar cierra la hoja y muestra un SnackBar de confirmación.
- Los ARB (es y en) y sus clases generadas.
- `test/features/categorias/data/categorias_repository_test.dart`, `test/features/categorias/ui/categorias_screen_test.dart`.

**Fuera de alcance:** borrar definitivamente una categoría archivada. El resto de pantallas no cambia.

## Pasos
1. Tests del repositorio:
   ```dart
   test('watchArchivadas devuelve solo las archivadas de ambos tipos')
   test('restaurar la devuelve a watchPorTipo y la saca de watchArchivadas')
   ```
2. Implementar el repositorio y el provider.
3. UI: añadir la sección «Archivadas» (mismo estilo que las otras dos) y el botón «Restaurar» en la hoja. Si `categoria_form_sheet.dart` pasa de unas 300 líneas, separar la parte nueva en un widget propio dentro de `ui/`.
4. Widget tests:
   - Sin archivadas, la sección no aparece.
   - Con una archivada, aparece en «Archivadas» y no en la sección de su tipo.
   - Al tocar «Restaurar», vuelve a su sección.

## Criterios de aceptación
- [ ] Los tests de los pasos 1 y 4 pasan.
- [ ] Una categoría archivada se ve en P09 y se puede restaurar. Al restaurarla aparece otra vez en el selector de P04.
- [ ] Sin textos ni colores fijos en el código (ARQUITECTURA §3).
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
