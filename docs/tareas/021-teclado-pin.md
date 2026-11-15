# 021 — Teclado de PIN: 4 dígitos, sin confirmar, desordenado y con huella

**Estado:** PENDIENTE
**Tipo:** código
**Depende de:** 016
**Referencias:** SPEC P01, R6 (actualizada: el PIN tiene exactamente 4 dígitos) · Mejoras pedidas por el usuario tras la prueba de la 017

## Objetivo
El PIN tiene siempre 4 dígitos y se comprueba solo al escribir el cuarto. Los números del teclado salen desordenados. La tecla de confirmar desaparece y en su lugar va el botón de huella, solo con el ícono.

## Contexto
Decisiones del usuario:
- **Exactamente 4 dígitos.** SPEC R6 ya está actualizada. No se pueden escribir más de 4.
- **Sin botón de confirmar.** Al escribir el 4.º dígito se comprueba solo: si es correcto entra, y si no, se borran los puntos y se vuelve a pedir. El contador de 5 fallos y la espera de 30 s siguen igual.
- **Números desordenados en los tres sitios:** bloqueo P01, crear PIN, y el PIN actual que pide Ajustes. Hoy Ajustes usa un `TextField` con el teclado del teléfono (`ajustes_screen.dart:52-90`); pasa a usar este mismo teclado.
- **Cuándo se mezclan:** cada vez que aparece la pantalla y tras cada PIN incorrecto. No se mezclan mientras se escribe un mismo intento.
- **Huella:** la tecla de abajo a la izquierda (donde estaba ✓) muestra solo el ícono de huella, y solo en P01 cuando la huella está disponible y activada. En los demás casos, ese hueco queda vacío. Se quita el botón de texto «Usar huella» que había debajo del teclado. Borrar sigue abajo a la derecha.

Distribución: los 10 dígitos (0–9) se reparten al azar en las 10 posiciones de número, es decir, las 9 de arriba y la del centro de la última fila. Las esquinas inferiores son fijas: huella o hueco a la izquierda, borrar a la derecha.

## Alcance
**Se puede crear o modificar:**
- `lib/features/seguridad/data/pin_service.dart`: la validación pasa a `RegExp(r'^\d{4}$')`.
- `lib/features/seguridad/ui/widgets/teclado_pin.dart`:
  - Recibe `List<int> orden` (una permutación de 0–9) y `VoidCallback? alHuella`, en lugar de `alConfirmar`.
  - Añadir la función pública `List<int> mezclarDigitos(Random random)`.
- `lib/features/seguridad/ui/widgets/verificar_pin_dialogo.dart` (nuevo): diálogo con `PuntosPin` y `TecladoPin` que llama a `BloqueoController.verificarPinActual` al cuarto dígito. Devuelve `true` si el PIN es correcto y `false` si se cancela. Durante la espera de 30 s muestra la cuenta atrás.
- `lib/features/seguridad/ui/bloqueo_screen.dart`, `crear_pin_screen.dart`, `widgets/puntos_pin.dart` (4 puntos fijos).
- `lib/features/seguridad/providers/bloqueo_providers.dart`: añadir un provider `Random` (por defecto `Random.secure()`) para poder fijarlo en los tests.
- `lib/features/ajustes/ui/ajustes_screen.dart`: usar `verificar_pin_dialogo.dart` en lugar del `TextField`.
- Los ARB (es y en) y sus clases generadas: quitar los textos que queden sin uso y añadir una etiqueta accesible para la tecla de huella.
- Tests de `test/features/seguridad/**` y `test/features/ajustes/**`.

**Fuera de alcance:**
- El hash con sal, el contador de fallos, la regla de los 60 s y la lógica de `BloqueoController`, salvo lo imprescindible para el diálogo.
- El teclado del sistema en otras pantallas.

## Pasos
1. **Tests unitarios:**
   ```dart
   test('guardar con 3, 5 o 6 dígitos lanza ValidacionException')
   test('mezclarDigitos devuelve una permutación de 0–9')
   test('mezclarDigitos con semillas distintas da órdenes distintos')
   ```
2. **Widget tests de P01** (usar un `Random` con semilla fija mediante el provider):
   - Al pulsar 4 dígitos correctos se desbloquea sin pulsar nada más.
   - Un 5.º dígito no hace nada.
   - Con un PIN incorrecto, los puntos se vacían y el orden de las teclas cambia.
   - No existe la tecla ✓.
   - Con huella disponible, la tecla de huella está abajo a la izquierda, y al pulsarla se llama a `intentarHuella`.
   - Sin huella, ese hueco está vacío.
   - Se mantiene el test de 5 PIN incorrectos → espera de 30 s, adaptado a 4 dígitos.
3. **Widget tests de crear PIN y de Ajustes:**
   - Crear PIN: el 4.º dígito pasa a «confirma tu PIN» y, si coincide, se guarda.
   - Ajustes: el diálogo verifica al 4.º dígito y, tras 5 fallos, muestra la espera.
4. Implementar. Comprobar también que el teclado de estas pantallas no queda tapado por la barra del sistema (margen inferior).
5. Actualizar los tests existentes que usen PIN de 5 o 6 dígitos.

## Criterios de aceptación
- [ ] Los tests de los pasos 1 a 3 pasan.
- [ ] No queda la tecla ✓ ni el botón de texto «Usar huella».
- [ ] El PIN nunca se guarda ni se imprime en texto plano (R6).
- [ ] Sin textos, colores ni tamaños fijos en el código (ARQUITECTURA §3). Los archivos tienen unas 300 líneas como máximo.
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
