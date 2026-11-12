# 014 — Recurrentes: pantalla P08 y ciclo de vida

**Estado:** PENDIENTE
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
