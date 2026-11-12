# 016 — Seguridad: PIN, huella y bloqueo P01

**Estado:** PENDIENTE
**Tipo:** código
**Depende de:** 014
**Referencias:** SPEC P01, P02, P10, R6 · ARQUITECTURA §4 (secure storage), §5 (Ciclo de vida, Router) · `docs/diseno/P01.png`, `P01b.png`, `P02c.png`, `P10.png` · INDICE A5

## Objetivo
Bloqueo opcional con PIN y huella: configurarlo en el onboarding y en Ajustes, y aplicarlo al abrir la app y al volver tras más de 60 s.

## Contexto
Pendientes de la auditoría de la 007 en `onboarding_screen.dart`, para corregir al añadir el paso 3:
- Si `crearPorDefecto` falla en `_finalizar`, el botón se queda deshabilitado sin ningún mensaje. Hay que restaurar `_creando` y mostrar un SnackBar.
- `_OpcionIdioma` usa `AppEspacio.xl` como tamaño del ícono. Usar un tamaño de ícono del tema, o `IconTheme`.

## Alcance
**Se puede crear o modificar:**
- `lib/features/seguridad/data/pin_service.dart`, `biometria_service.dart`
- `lib/features/seguridad/providers/bloqueo_providers.dart` (+ `.g.dart`)
- `lib/features/seguridad/ui/bloqueo_screen.dart`, `crear_pin_screen.dart`, `widgets/teclado_pin.dart`
- `lib/features/onboarding/ui/onboarding_screen.dart` (paso 3)
- `lib/features/ajustes/ui/ajustes_screen.dart` (sección Seguridad)
- `lib/core/lifecycle/ciclo_vida.dart`, `lib/core/router/app_router.dart` (`Rutas.bloqueo = '/bloqueo'`, `'/ajustes/pin'`)
- `android/app/src/main/kotlin/.../MainActivity.kt` (`FlutterFragmentActivity`), `AndroidManifest.xml` (`USE_BIOMETRIC`), los ARB
- `test/features/seguridad/data/pin_service_test.dart`, `test/features/seguridad/providers/bloqueo_controller_test.dart`, `test/features/seguridad/ui/bloqueo_screen_test.dart`

## Interfaces
**Consume:** `PreferenciasRepository` (`bloqueoActivo`, `usarHuella`), `CicloDeVida`, `onboardingCompletoProvider`.
**Produce:**
```dart
class PinService {
  PinService(FlutterSecureStorage storage, {Random? random});
  Future<void> guardarPin(String pin);  // 4–6 dígitos; si no, ValidacionException('pin','formato'). Sal nueva de 16 bytes
  Future<bool> verificar(String pin);   // sha256(sal + pin) == hash guardado
  Future<bool> tienePin();
  Future<void> borrarPin();
}
abstract interface class BiometriaService {
  Future<bool> disponible();            // el dispositivo la soporta Y tiene alguna huella registrada
  Future<bool> autenticar(String motivo); // false ante cualquier excepción (nunca lanza)
}
class BiometriaLocalAuth implements BiometriaService { /* local_auth */ }

class EstadoBloqueo {
  const EstadoBloqueo({required this.bloqueado, this.intentosFallidos = 0, this.esperarHasta});
  final bool bloqueado; final int intentosFallidos; final DateTime? esperarHasta;
}
@Riverpod(keepAlive: true) class BloqueoController extends _$BloqueoController {
  EstadoBloqueo build();                       // bloqueado = prefs.bloqueoActivo (bloqueada al arrancar)
  Future<bool> intentarPin(String pin);        // si es correcto, desbloquea y pone intentos a 0; al 5.º fallo, esperarHasta = ahora + 30 s
  Future<bool> intentarHuella();               // solo si usarHuella && disponible()
  void alPasarASegundoPlano();                 // recuerda la hora
  void alVolver();                             // si bloqueoActivo y pasaron > 60 s: bloqueado = true
}
@Riverpod(keepAlive: true) DateTime Function() reloj(Ref ref);   // () => DateTime.now(); se sobrescribe en los tests
@Riverpod(keepAlive: true) PinService pinService(Ref ref);
@Riverpod(keepAlive: true) BiometriaService biometriaService(Ref ref);
```

## Pasos
1. Tests de `PinService` (con un `FlutterSecureStorage` falso en memoria):
   ```dart
   test('guardar "1234" y verificar "1234" es true, "1235" es false')
   test('"123" y "1234567" y "12a4" lanzan ValidacionException')
   test('el almacenamiento no contiene "1234" en texto plano')
   test('dos guardados del mismo PIN generan hashes distintos (sal distinta)')
   ```
2. Tests de `BloqueoController` (`reloj` falso + biometría falsa):
   ```dart
   test('con bloqueo inactivo arranca desbloqueado')
   test('5 PIN incorrectos -> esperarHasta = ahora + 30 s; intentarPin antes de eso devuelve false sin verificar')
   test('alVolver a los 61 s bloquea; a los 59 s no')
   test('intentarHuella con biometría no disponible devuelve false y no lanza')   // A5
   test('usarHuella true pero huella eliminada del teléfono -> se ofrece el PIN') // A5
   ```
3. Implementar los servicios y el controlador.
4. UI:
   - `BloqueoScreen` (P01/P01b): `TecladoPin`, botón de huella solo si está disponible y activada, lanza la huella automáticamente al entrar y muestra la cuenta atrás de 30 s cuando toca esperar.
   - Router: un `redirect` que manda a `/bloqueo` si `bloqueado == true` (después del de onboarding). Al desbloquear, vuelve a la ruta anterior.
5. `CicloDeVida`: llamar a `alPasarASegundoPlano` en `paused` y a `alVolver` en `resumed`, antes de generar los recurrentes.
6. Onboarding, paso 3 (`P02c`): "Proteger con PIN" → `CrearPinScreen` (introducir y confirmar) → activa el bloqueo, y ofrece la huella si está disponible; o bien "Omitir".
7. Ajustes, sección Seguridad:
   - Activar el bloqueo: pide crear un PIN si no hay.
   - Desactivar el bloqueo o cambiar el PIN: pide antes el PIN actual (R6).
   - Switch "Usar huella": solo visible si `disponible()`.
8. Widget test de P01: un PIN correcto desbloquea; 5 incorrectos muestran la espera.
9. `flutter analyze` y `flutter test`. En el teléfono: activar el bloqueo, salir más de 1 minuto, volver y comprobar que pide la huella o el PIN.

## Criterios de aceptación
- [ ] Los tests de los pasos 1, 2 y 8 pasan.
- [ ] El PIN nunca se guarda ni se registra en texto plano.
- [ ] Sin huella disponible, la app funciona solo con el PIN, sin errores (A5).
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
