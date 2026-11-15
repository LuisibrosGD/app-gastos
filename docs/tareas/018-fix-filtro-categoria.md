# 018 — Corrección: el filtro por categoría de P05 no abre

**Estado:** PENDIENTE
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
