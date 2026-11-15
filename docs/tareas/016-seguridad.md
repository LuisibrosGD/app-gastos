# 016 — Seguridad: PIN, huella y bloqueo P01

**Estado:** APROBADA
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
- `lib/features/seguridad/data/pin_service.dart`, `biometria_service.dart`.
- `lib/features/seguridad/providers/bloqueo_providers.dart` y su `.g.dart`.
- `lib/features/seguridad/ui/bloqueo_screen.dart`, `crear_pin_screen.dart`, `widgets/teclado_pin.dart`, `widgets/puntos_pin.dart`.
- `lib/features/onboarding/ui/onboarding_screen.dart` (paso 3 y correcciones de la 007).
- `lib/features/ajustes/ui/ajustes_screen.dart`, `ui/widgets/filas_ajustes.dart` (extraído por la regla 8).
- `lib/core/lifecycle/ciclo_vida.dart`, `lib/core/router/app_router.dart`.
- `android/app/src/main/kotlin/com/appgastos/app_gastos/MainActivity.kt`, `AndroidManifest.xml`.
- `lib/core/l10n/app_es.arb`, `app_en.arb` y clases generadas.
- Tests: `test/features/seguridad/data/pin_service_test.dart`, `providers/bloqueo_controller_test.dart`, `ui/bloqueo_screen_test.dart`; ajuste del test de onboarding para el paso 3.

**Comandos ejecutados y resultado:**
- `flutter gen-l10n` → textos nuevos generados.
- `dart run build_runner build --delete-conflicting-outputs` → providers generados sin errores.
- `flutter analyze` → `No issues found!`
- `flutter test` → `All tests passed!` (139 tests; 12 nuevos)

**Decisiones tomadas / desvíos del brief:**
- `PinService` guarda `pinHash` y `pinSal` (16 bytes de `Random.secure`) en `flutter_secure_storage`, con SHA-256 de sal + PIN. No se guarda la longitud ni el PIN en claro.
- `BiometriaLocalAuth` usa `isDeviceSupported` + `getAvailableBiometrics` (v3 de `local_auth`) y captura cualquier excepción en `disponible` y `autenticar`.
- El controlador usa el reloj inyectable, bloquea al 5.º fallo durante 30 s y solo bloquea al volver si pasaron más de 60 s con el bloqueo activo.
- `TecladoPin` usa la celda vacía inferior izquierda del diseño como tecla de confirmación: es la única forma de admitir PIN de 4, 5 y 6 dígitos sin conocer su longitud. Es el único desvío visual respecto a P01/P01b.
- El router lee el estado de bloqueo en el `redirect` y se refresca con `ref.listen`, pasando la ruta de origen en `?desde=` para volver a ella al desbloquear.
- En Ajustes la sección de seguridad va dentro de la tarjeta «Preferencias» como en P10 (Idioma, Bloqueo, Cambiar PIN, Usar huella). Desactivar el bloqueo o cambiar el PIN pide antes el PIN actual; activar sin PIN abre `CrearPinScreen`.
- `_finalizar` del onboarding restaura `_creando` y muestra SnackBar si fallan las categorías; el ícono de `_OpcionIdioma` usa el tamaño del tema.
- Al crear el PIN desde onboarding o al activar el bloqueo se ofrece la huella si está disponible; si se rechaza o no existe, todo sigue funcionando solo con PIN.
- Se añadieron `puntos_pin.dart` y `filas_ajustes.dart` para respetar la regla 8.

**Dudas o problemas pendientes:**
- No se ejecutó la prueba manual en el teléfono (activar bloqueo, salir más de 1 minuto y volver) porque no hay dispositivo ni emulador conectado.

### Reporte – ronda 2

**Cambios realizados:**
- `CrearPinScreen` acepta `activarBloqueo` (por defecto `true`); solo escribe `bloqueoActivo` cuando es `true`. `_cambiarPin` de Ajustes lo usa con `false`, así cambiar el PIN no activa el bloqueo.
- Tras volver de cualquier `CrearPinScreen`, Ajustes relee `bloqueoActivo` y `usarHuella` con `_refrescarSeguridad`, por lo que los switches quedan sincronizados.
- `BloqueoController.verificarPinActual` usa el mismo contador de fallos y la misma espera de 30 s que `intentarPin`, pero conserva `bloqueado`. Ajustes lo usa y, si hay espera activa, muestra el SnackBar con `pinEspera`.
- Nuevo test `'verificarPinActual: 5 fallos impiden verificar durante 30 s y no cambian bloqueado'`.
- Eliminadas `Rutas.pin`, su `GoRoute` y el import de `crear_pin_screen.dart` en `app_router.dart`.

**Comandos ejecutados y resultado:**
- `flutter analyze` → `No issues found!`
- `flutter test` → `All tests passed!` (140 tests)

---

## Auditoría
*(La escribe Claude Code.)*

**Ronda 1 — 2026-11-15 — CAMBIOS_SOLICITADOS**

Verificado: `flutter analyze` sin problemas, `flutter test` 139 en verde, `build_runner` sin cambios en `.g.dart`. Solo se tocaron archivos del Alcance más `puntos_pin.dart` y `filas_ajustes.dart` (aceptados por la regla 8). El PIN se guarda como SHA-256 con sal de 16 bytes en almacenamiento seguro y nunca en claro. La biometría no lanza nunca y, sin huella, todo funciona con el PIN (A5). Las esperas de 30 s y de 60 s funcionan. El router vuelve a la ruta de origen y `CicloDeVida` avisa antes de generar los recurrentes. Las dos correcciones pendientes de la 007 están hechas. Se acepta la tecla de confirmación en la celda vacía del teclado.

Cambios pedidos:
1. **"Cambiar PIN" activa el bloqueo sin avisar.** `crear_pin_screen.dart`, `_guardar` llama siempre a `setBloqueoActivo(true)`. Con el bloqueo apagado, al cambiar el PIN (o crearlo desde "Cambiar PIN" si no había ninguno) el bloqueo queda activo, pero el switch de Ajustes sigue apagado porque `_bloqueoActivo` no se vuelve a leer. Esperado: añade a `CrearPinScreen` un parámetro `activarBloqueo` (por defecto `true`); `_cambiarPin` de Ajustes lo pasa en `false`, así cambiar el PIN no toca `bloqueoActivo`. Además, al volver de `CrearPinScreen`, Ajustes vuelve a leer `bloqueoActivo` y `usarHuella` de las preferencias.
2. **El PIN que se pide en Ajustes no tiene límite de intentos (incumple R6).** `ajustes_screen.dart`, `_verificarPinActual` llama directamente a `pinService.verificar`, así que se pueden probar PIN sin límite para desactivar el bloqueo o cambiar el PIN. R6: "Tras 5 PIN incorrectos seguidos, la entrada se bloquea durante 30 s". Esperado: añade a `BloqueoController` un método `Future<bool> verificarPinActual(String pin)`. Debe usar el mismo contador y la misma espera que `intentarPin`, pero sin cambiar `bloqueado`. Ajustes lo usa y, si toca esperar, muestra un SnackBar con `pinEspera`. Añade el test `'verificarPinActual: 5 fallos impiden verificar durante 30 s y no cambian bloqueado'` en `bloqueo_controller_test.dart`.
3. **Ruta sin usar.** `app_router.dart` declara `Rutas.pin` y su `GoRoute`, pero Ajustes y el onboarding abren `CrearPinScreen` con `Navigator.push`. Quita la constante y la ruta para no dejar código muerto.

Notas no bloqueantes:
- El tamaño 40 del ícono del candado está escrito a mano en tres sitios; mejor usar una constante de `dimensiones.dart`.
- Al ir a `/bloqueo` solo se guarda la ruta, sin sus parámetros; hoy no afecta a nada.
- Queda pendiente la prueba en el teléfono.

**Ronda 2 — 2026-11-15 — APROBADA**

Verificado: `flutter analyze` sin problemas, `flutter test` 140 en verde, `build_runner` sin cambios en `.g.dart`. Los tres puntos de la Ronda 1 están resueltos. Cambiar el PIN ya no activa el bloqueo (`activarBloqueo: false`) y Ajustes vuelve a leer las preferencias al volver. `verificarPinActual` comparte el límite de 5 intentos y la espera de 30 s sin tocar `bloqueado`, con su test. La ruta `/ajustes/pin` ya no existe.

Notas no bloqueantes:
- `intentarPin` y `verificarPinActual` repiten casi la misma lógica; se podría extraer a un método privado común.
- El Estado no se devolvió a `LISTA_PARA_AUDITORIA` al entregar la ronda.
- Queda pendiente la prueba en el teléfono (activar el bloqueo, salir más de 1 minuto, volver y comprobar que pide la huella o el PIN).

