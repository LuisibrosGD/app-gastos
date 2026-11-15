# 018 — Corrección: el filtro por categoría de P05 no abre

**Estado:** APROBADA
**Tipo:** código
**Depende de:** 009
**Referencias:** SPEC P05 · Tarea 017, checklist (fallo P05)

## Objetivo
En Movimientos, tocar el filtro de categoría abre el selector siempre, también la primera vez tras abrir la app.

## Contexto
En el teléfono, el botón no hacía nada hasta reiniciar la app. Causa probable: en `movimientos_screen.dart:33-38`, `_elegirCategoria` espera `ref.read(categoriasPorTipoProvider(...).future)`. En Riverpod 3, un provider que ningún widget escucha queda en pausa, y ese `future` puede no completarse nunca, así que el diálogo no llega a mostrarse.

## Alcance
**Se puede crear o modificar:**
- `lib/features/movimientos/ui/movimientos_screen.dart`
- `test/features/movimientos/ui/movimientos_screen_test.dart`

**Fuera de alcance:** cambiar `categoriasPorTipoProvider` o el repositorio de categorías.

## Pasos
1. Escribir primero un widget test que reproduzca el fallo. Usar la base en memoria con categorías de gasto e ingreso y un `ProviderScope` nuevo, sin haber abierto antes ninguna otra pantalla. Pulsar el filtro y comprobar que aparece el diálogo con «Todas» y las categorías de los dos tipos. Comprobar que el test falla (o se queda colgado) con el código actual.
2. Corregir: escuchar con `ref.watch` las dos listas (gasto e ingreso) en `build`, y que el diálogo use los datos ya cargados, sin esperar ningún `future`. Mientras no haya datos, el botón está deshabilitado.
3. Segundo test: elegir una categoría filtra la lista, y elegir «Todas» quita el filtro.

## Criterios de aceptación
- [ ] El test del paso 1 falla antes del cambio y pasa después (dejarlo anotado en el reporte).
- [ ] No queda ningún `ref.read(...future)` en `movimientos_screen.dart`.
- [ ] `flutter analyze` sin errores ni advertencias.
- [ ] `flutter test` en verde.

---

## Reporte de implementación
*(Lo escribe Command Code. No borrar los títulos.)*

**Archivos creados o modificados:**
- `lib/features/movimientos/ui/movimientos_screen.dart`: las listas de gasto e ingreso se escuchan con `ref.watch` en `build`; `_elegirCategoria` recibe las categorías ya cargadas y ya no espera ningún `future`; el botón queda deshabilitado mientras faltan datos.
- `test/features/movimientos/ui/movimientos_screen_test.dart`: dos tests nuevos (apertura del selector en el primer arranque y filtrado/limpieza con «Todas»).

**Comandos ejecutados y resultado:**
- `flutter test test/features/movimientos/ui/movimientos_screen_test.dart --plain-name "el filtro de categoría abre el selector en el primer arranque"` (antes del cambio) → **falla** como se esperaba: `Found 0 widgets with text "Categoría"`. El proceso quedó colgado hasta el timeout por el `future` que nunca se completa.
- `flutter test test/features/movimientos/ui/movimientos_screen_test.dart` → 5 tests en verde.
- `flutter analyze` → `No issues found!`
- `flutter test` → `All tests passed!` (142 tests).
- Búsqueda de `ref.read|.future` en `movimientos_screen.dart` → sin coincidencias.

**Decisiones tomadas / desvíos del brief:**
- El diálogo muestra primero las categorías de gasto y después las de ingreso, como antes; no se ordenan globalmente para no cambiar el comportamiento visual existente.
- Mientras alguna de las dos listas no tenga datos, el botón no responde (igual que el estado deshabilitado pedido) y mantiene su aspecto actual; no se añadió estilo nuevo.

**Dudas o problemas pendientes:**
- La comprobación en el teléfono queda pendiente, aunque el fallo reproducido en el test coincide con el reportado en la tarea 017.

---

## Auditoría
*(La escribe Claude Code.)*

**Ronda 1 — 2026-11-15 — APROBADA**

Verificado: `flutter analyze` sin problemas y `flutter test` 142 en verde. Solo se tocaron los dos archivos del Alcance. Las dos listas se escuchan con `ref.watch` en `build`, el botón queda deshabilitado (`onTap: null`) hasta tener las dos, y no queda ningún `ref.read(...future)`. El test del primer arranque reproduce el fallo antes del cambio, según el reporte, y comprueba categorías de los dos tipos. El test de filtrado prueba también quitar el filtro con «Todas».

Pendiente: confirmarlo en el teléfono con el próximo APK.
