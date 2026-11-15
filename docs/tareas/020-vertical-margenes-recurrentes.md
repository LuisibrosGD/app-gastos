# 020 — Solo vertical, margen inferior y fila de recurrentes

**Estado:** PENDIENTE
**Tipo:** código
**Depende de:** 017 (parcial)
**Referencias:** SPEC P07, P08, P09 · Mejoras pedidas por el usuario tras la prueba de la 017

## Objetivo
Tres arreglos visuales detectados en el teléfono:
1. La app solo funciona en vertical.
2. La barra de navegación del teléfono no tapa el final de las listas.
3. En la fila de una regla recurrente, el monto no se monta sobre el interruptor.

## Contexto
- **Margen inferior:** en Ajustes → Categorías, la barra de navegación del sistema tapa las últimas categorías, aunque se baje del todo. Android dibuja la app hasta el borde inferior de la pantalla («edge-to-edge»). Un `ListView` con `padding` explícito no suma el espacio de esa barra (en `categorias_screen.dart:44` se usa `EdgeInsets.all(AppEspacio.l)`). Afecta a las pantallas que se abren encima de las pestañas, porque no tienen barra inferior propia que reserve ese espacio.
- **Recurrentes:** en `recurrentes_screen.dart:141-162`, el monto y el `Switch` van en una columna, y el `Switch` está metido en un `SizedBox(height: AppEspacio.xl)`, más bajo que el propio interruptor. Por eso este se desborda y queda encima del monto.

## Alcance
**Se puede crear o modificar:**
- `lib/main.dart`: fijar la orientación vertical (`SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])`) antes de `runApp`.
- `android/app/src/main/AndroidManifest.xml`: `android:screenOrientation="portrait"` en la `activity`.
- Margen inferior en las pantallas que se abren encima de las pestañas:
  - `lib/features/categorias/ui/categorias_screen.dart`
  - `lib/features/presupuesto/ui/presupuesto_screen.dart`
  - `lib/features/recurrentes/ui/recurrentes_screen.dart`
  - `lib/features/recurrentes/ui/widgets/formulario_recurrente.dart`
  - `lib/features/movimientos/ui/movimiento_form_screen.dart`
  - `lib/features/onboarding/ui/onboarding_screen.dart`
  - Solo las que lo necesiten: revisar cada una y anotar en el reporte cuáles cambiaron.
- `lib/features/recurrentes/ui/recurrentes_screen.dart`: nueva disposición de la fila.
- `test/features/recurrentes/ui/recurrentes_screen_test.dart`, `test/features/categorias/ui/categorias_screen_test.dart`.

**Fuera de alcance:**
- Las pantallas de seguridad: las toca la 021.
- Las pantallas con barra de pestañas (Inicio, Movimientos, Resumen, Ajustes): ya reservan el espacio.

## Pasos
1. **Orientación:** cambiar `main.dart` y el manifest.
2. **Margen inferior:** en cada lista con `padding` explícito, sumar abajo `MediaQuery.paddingOf(context).bottom`, o envolver el cuerpo en `SafeArea(top: false)`. Usar el mismo método en todas.
3. **Fila de recurrentes:** el monto pasa a la columna central, a la derecha del título o en su línea, y el `Switch` queda solo a la derecha, centrado en vertical y sin `SizedBox` que lo recorte. El nombre largo sigue cortándose con `…`.
4. **Widget tests:**
   - En recurrentes, con una regla, el monto y el `Switch` no se solapan: comparar sus `tester.getRect(...)` con `overlaps` en `false`. No hay errores de desbordamiento.
   - En categorías, con un `MediaQuery` con `padding.bottom` de 48, la última fila queda por encima de esos 48 px al hacer scroll hasta el final.

## Criterios de aceptación
- [ ] Al girar el teléfono, la app sigue en vertical.
- [ ] En Categorías, la última fila se ve completa por encima de la barra del sistema.
- [ ] En Recurrentes, el monto y el interruptor no se tocan.
- [ ] Los tests del paso 4 pasan.
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
