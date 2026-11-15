# 019 — Ver y restaurar categorías archivadas en P09

**Estado:** APROBADA
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
- `lib/features/categorias/data/categorias_repository.dart`: `watchArchivadas()` y `restaurar(int id)`.
- `lib/features/categorias/providers/categorias_providers.dart`: `categoriasArchivadasProvider`.
- `lib/features/categorias/ui/categorias_screen.dart`: sección «Archivadas» al final, solo si hay categorías archivadas.
- `lib/features/categorias/ui/categoria_form_sheet.dart`: botón «Restaurar» en lugar de «Eliminar» cuando la categoría está archivada, con SnackBar de confirmación.
- `lib/core/l10n/app_es.arb`, `lib/core/l10n/app_en.arb` y clases generadas: `categoriasArchivadas`, `accionRestaurar` y `categoriaRestauradaAviso`.
- `test/features/categorias/data/categorias_repository_test.dart`: tests de `watchArchivadas` y `restaurar`.
- `test/features/categorias/ui/categorias_screen_test.dart`: tests de sección ausente, sección con archivadas y restauración.

**Comandos ejecutados y resultado:**
- `flutter gen-l10n` → clases de localización regeneradas.
- `flutter analyze` → `No issues found!`
- `flutter test` → `All tests passed!` (147 tests).

**Decisiones tomadas / desvíos del brief:**
- La sección «Archivadas» usa el mismo encabezado y la misma tarjeta que las secciones de gasto e ingreso; la fila reutiliza la etiqueta «Archivada» que ya existía.
- La lista de archivadas mezcla ambos tipos y se ordena por nombre, tal como pide el repositorio.
- El botón «Restaurar» usa el color primario del tema, no un color suelto.
- La hoja de edición sigue permitiendo cambiar nombre, ícono y color de una categoría archivada; solo se sustituye la acción de eliminar por la de restaurar.

**Dudas o problemas pendientes:**
- La comprobación en el teléfono queda pendiente. La reactividad de P04 está cubierta indirectamente: `restaurar` devuelve la categoría a `watchPorTipo`, que es el provider que usan los selectores.

---

## Auditoría
*(La escribe Claude Code.)*

**Ronda 1 — 2026-11-15 — APROBADA**

Verificado: `flutter analyze` sin problemas y `flutter test` 147 en verde. Solo se tocaron archivos del Alcance. `watchArchivadas` filtra `archivada = true` de los dos tipos y ordena por nombre; `restaurar` solo pone `archivada = false`. La sección «Archivadas» reutiliza el encabezado y la tarjeta existentes y no aparece si está vacía. En la hoja, una categoría archivada muestra «Restaurar» (color primario del tema) en lugar de «Eliminar»; al restaurar se cierra y sale el SnackBar. Textos en los dos ARB. Los tests del repositorio y de la pantalla cubren los tres casos pedidos, y el de restaurar comprueba que vuelve a `watchPorTipo`, que es lo que usan los selectores de P04.

Pendiente: confirmarlo en el teléfono con el próximo APK.
