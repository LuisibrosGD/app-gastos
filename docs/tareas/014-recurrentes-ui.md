# 014 — Recurrentes: pantalla P08 y ciclo de vida

**Estado:** APROBADA
**Tipo:** código
**Depende de:** 010, 013
**Referencias:** SPEC P08, R5 · ARQUITECTURA §5 (Arranque, Ciclo de vida) · `docs/diseno/P08.png`, `P08b.png`

## Objetivo
Gestionar las reglas recurrentes (P08) y generar los movimientos pendientes al abrir la app y al volver a primer plano.

## Alcance
**Se puede crear o modificar:**
- `lib/features/recurrentes/ui/recurrentes_screen.dart`, `recurrente_form_screen.dart`
- `lib/core/lifecycle/ciclo_vida.dart`
- `lib/app.dart` (envolver con `CicloDeVida`)
- `lib/features/ajustes/ui/ajustes_screen.dart` (entrada "Recurrentes")
- `lib/core/router/app_router.dart` (`Rutas.recurrentes = '/ajustes/recurrentes'`, `'/ajustes/recurrentes/nueva'`, `'/ajustes/recurrentes/:id'`), los ARB
- `test/features/recurrentes/ui/recurrentes_screen_test.dart`, `test/core/lifecycle/ciclo_vida_test.dart`

## Interfaces
**Consume:** `recurrentesProvider`, `recurrentesRepositoryProvider`, `generadorRecurrentesProvider`, `RecurrenteInput`, `categoriasPorTipoProvider`, `CampoMonto`, `onboardingCompletoProvider`.
**Produce (016 lo amplía):**
```dart
/// Widget sin UI propia que escucha el ciclo de vida de la app.
/// - Al montarse, si el onboarding está completo: generarPendientes(DateTime.now()).
/// - En cada AppLifecycleState.resumed: generarPendientes(DateTime.now()).
/// Los errores del generador se registran con debugPrint y no se muestran.
class CicloDeVida extends ConsumerStatefulWidget { const CicloDeVida({required this.child}); final Widget child; }
```

## Pasos
1. Tests:
   ```dart
   testWidgets('P08 lista reglas con monto, frecuencia ("Cada mes, día 5" / "Cada lunes") y estado')
   testWidgets('crear una regla mensual día 5 la muestra en la lista')
   testWidgets('el formulario cambia el selector de día según la frecuencia (1–31 vs. lunes–domingo)')
   testWidgets('desactivar una regla con el switch la marca inactiva')
   testWidgets('CicloDeVida llama a generarPendientes al montarse y al recibir resumed')  // generador falso
   ```
2. P08 según `P08.png`: lista con un switch de activo, botón para crear, tocar una regla abre la edición, y Eliminar con confirmación que explica que los movimientos ya creados se conservan (R5).
3. Formulario según `P08b.png`: tipo, monto, categoría, nota, frecuencia, día y fecha de inicio (por defecto hoy). Mismo manejo de errores que P04.
4. `CicloDeVida` con `AppLifecycleListener`; envolver la app en `app.dart`.
5. Ajustes: entrada "Recurrentes".
6. `flutter analyze` y `flutter test`. En el teléfono: crear una regla con día de hoy, cerrar y abrir la app, y comprobar que aparece el movimiento una sola vez.

## Criterios de aceptación
- [ ] Los tests del paso 1 pasan.
- [ ] Las pantallas se parecen a sus PNG.
- [ ] Abrir la app varias veces el mismo día no duplica movimientos.
- [ ] `flutter analyze` sin errores ni advertencias.
- [ ] `flutter test` en verde.

---

## Reporte de implementación
*(Lo escribe Command Code. No borrar los títulos.)*

**Archivos creados o modificados:**
- `lib/features/recurrentes/ui/recurrentes_screen.dart`, `recurrente_form_screen.dart`.
- `lib/features/recurrentes/ui/widgets/formulario_recurrente.dart`, `selector_frecuencia.dart`, `campo_dia.dart`, `campos_formulario.dart` (extraídos para respetar la regla 8).
- `lib/core/lifecycle/ciclo_vida.dart` y `lib/app.dart` (envuelto con `CicloDeVida`).
- `lib/core/router/app_router.dart` y `lib/features/ajustes/ui/ajustes_screen.dart` (entrada «Recurrentes»).
- `lib/core/l10n/app_es.arb`, `app_en.arb` y clases generadas.
- `test/features/recurrentes/ui/recurrentes_screen_test.dart`, `test/core/lifecycle/ciclo_vida_test.dart`.

**Comandos ejecutados y resultado:**
- `flutter gen-l10n` → textos nuevos generados.
- `flutter analyze` → `No issues found!`
- `flutter test` → `All tests passed!` (121 tests; 5 nuevos)

**Decisiones tomadas / desvíos del brief:**
- P08 lista cada regla en una tarjeta con icono de categoría, título (nota o nombre de categoría), importe con signo y color, subtítulo «Mensual · día N» / «Semanal · día» y switch que actualiza `activo` mediante `actualizar`.
- El formulario reutiliza `SelectorTipoMovimiento`, `ChipCategoria`, `CampoFecha` y `CampoMonto` de P04, y valida igual: errores por campo y SnackBar para fallos inesperados. El día se elige con un desplegable que cambia entre 1–31 y lunes–domingo según la frecuencia.
- La edición carga la regla desde `recurrentesProvider` y ofrece «Borrar» con confirmación que avisa de que los movimientos se conservan.
- `CicloDeVida` se monta en el `builder` de `MaterialApp.router`: genera una vez tras el primer frame (si el onboarding está completo) y otra en cada `onResume`; cualquier error se registra con `debugPrint`.
- Las rutas `nueva` y `:id` se declararon en ese orden para que «nueva» no se interprete como un id.
- Los cuatro archivos de widgets se añaden al Alcance para que el formulario no pase de ~300 líneas.

**Dudas o problemas pendientes:**
- No se ejecutó la prueba manual en el teléfono (crear una regla con día de hoy, cerrar y abrir la app) porque no hay dispositivo ni emulador conectado.

---

## Auditoría
*(La escribe Claude Code.)*

**Ronda 1 — 2026-11-15 — APROBADA**

Verificado: `flutter analyze` sin problemas, `flutter test` 121 en verde, `build_runner` sin cambios en `.g.dart`. P08 y P08b se parecen a sus PNG. `CicloDeVida` genera tras el primer frame (con onboarding completo) y en cada `onResume`, con errores solo en `debugPrint`; junto al generador de la 013, que relee la regla dentro de la transacción, abrir y volver a la app no duplica. La confirmación de borrado avisa de que los movimientos se conservan (R5). Se aceptan los cuatro widgets extraídos.

Notas no bloqueantes (para cuando se toquen estos archivos):
- `app_router.dart`: un `:id` no numérico (`int.tryParse` → null) abre el formulario de alta en lugar de un error. Usar `Rutas.recurrente` evita el caso en la práctica.
- `recurrente_form_screen.dart`: al borrar, el stream puede reconstruir antes del `pop` y mostrar un instante «no se pudo cargar».
- `recurrentes_screen.dart`: si la carga falla no se muestra nada (`SizedBox.shrink`), igual que en Inicio.
- El día por defecto es 1; podría ser el día de hoy, para que coincida con la fecha de inicio.
- Pendiente la prueba en el teléfono (regla con día de hoy, cerrar y abrir, un solo movimiento).
