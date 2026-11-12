# 007 — Preferencias, idioma y onboarding P02

**Estado:** APROBADA
**Tipo:** código
**Depende de:** 006
**Referencias:** SPEC P02, §4 (categorías por defecto) · ARQUITECTURA §4 (fuera de la base), §5 (Arranque, Router) · `docs/diseno/P02a.png`, `P02b.png`

## Objetivo
Las preferencias persistentes (`shared_preferences`), el cambio de idioma en vivo y el onboarding del primer arranque: elegir idioma y crear las categorías por defecto en ese idioma.

## Contexto
El paso de PIN del onboarding (`P02c`) se añade en la tarea 016. Aquí el onboarding termina tras crear las categorías.

## Alcance
**Se puede crear o modificar:**
- `lib/features/ajustes/data/preferencias_repository.dart`
- `lib/features/ajustes/providers/preferencias_providers.dart` (+ `.g.dart`)
- `lib/features/onboarding/ui/onboarding_screen.dart`
- `lib/main.dart`, `lib/app.dart`, `lib/core/router/app_router.dart`, los ARB
- `test/features/ajustes/data/preferencias_repository_test.dart`, `test/features/onboarding/ui/onboarding_screen_test.dart`

## Interfaces
**Consume:** `CategoriasRepository.crearPorDefecto`, `categoriasRepositoryProvider`.
**Produce:**
```dart
class PreferenciasRepository {
  PreferenciasRepository(SharedPreferences prefs);
  String get idioma;                     // 'es' por defecto
  Future<void> setIdioma(String codigo); // solo 'es' | 'en'; si no, ArgumentError
  bool get onboardingCompleto;           // false por defecto
  Future<void> marcarOnboardingCompleto();
  bool get bloqueoActivo;  Future<void> setBloqueoActivo(bool v);   // false por defecto (la usa 016)
  bool get usarHuella;     Future<void> setUsarHuella(bool v);      // false por defecto (la usa 016)
}

@Riverpod(keepAlive: true) SharedPreferences sharedPreferences(Ref ref); // lanza UnimplementedError; se sobrescribe en main
@Riverpod(keepAlive: true) PreferenciasRepository preferenciasRepository(Ref ref);
@Riverpod(keepAlive: true) class IdiomaActual extends _$IdiomaActual {
  Locale build();                       // Locale(prefs.idioma)
  Future<void> cambiar(String codigo);  // persiste y actualiza el estado
}
@Riverpod(keepAlive: true) class OnboardingCompleto extends _$OnboardingCompleto {
  bool build();
  Future<void> completar();
}
```

## Pasos
1. Tests del repositorio con `SharedPreferences.setMockInitialValues({})`:
   ```dart
   test('valores por defecto: es, onboarding false, bloqueo false, huella false')
   test('setIdioma persiste en y lanza ArgumentError con fr')
   test('marcarOnboardingCompleto persiste true')
   ```
2. Implementar el repositorio y los providers. En `main.dart`: `WidgetsFlutterBinding.ensureInitialized()`, `SharedPreferences.getInstance()` y `ProviderScope(overrides: [sharedPreferencesProvider.overrideWithValue(prefs)])`.
3. `App`: `locale: ref.watch(idiomaActualProvider)`.
4. Router: ruta `/onboarding`, más un `redirect` que manda a `/onboarding` si `!onboardingCompleto` y fuera de ella si ya está completo. El router debe refrescarse cuando cambie `onboardingCompletoProvider`.
5. `OnboardingScreen` con 2 pasos (`P02a`, `P02b`):
   - **Paso 1:** elegir Español o English. La interfaz cambia de idioma al instante.
   - **Paso 2:** "Creamos tus categorías" con la vista previa de las 12. Al pulsar Continuar: `crearPorDefecto` con los nombres **traducidos** (claves ARB `catComida` … `catOtrosIngreso`), y después `completar()`.
6. Widget test: elegir English, continuar y comprobar que se crearon las categorías con el nombre "Food" y que el onboarding quedó completo.
7. `flutter analyze` y `flutter test`. Probar en el teléfono que tras completar el onboarding y reiniciar la app ya no aparece.

## Criterios de aceptación
- [ ] Los tests de los pasos 1 y 6 pasan.
- [ ] Cambiar el idioma actualiza los textos sin reiniciar la app.
- [ ] El onboarding solo aparece en el primer arranque.
- [ ] `flutter analyze` sin errores ni advertencias.
- [ ] `flutter test` en verde.

---

## Reporte de implementación
*(Lo escribe Command Code. No borrar los títulos.)*

**Archivos creados o modificados:**
- `lib/features/ajustes/data/preferencias_repository.dart`.
- `lib/features/ajustes/providers/preferencias_providers.dart` y `.g.dart` (generado).
- `lib/features/onboarding/ui/onboarding_screen.dart`.
- `lib/main.dart`: `SharedPreferences.getInstance()` y override de `sharedPreferencesProvider`.
- `lib/app.dart`: `locale: ref.watch(idiomaActualProvider)`.
- `lib/core/router/app_router.dart`: ruta `/onboarding` y `redirect` según `onboardingCompletoProvider`.
- `lib/core/l10n/app_es.arb`, `app_en.arb` (textos de P02 y `cat*`) y clases generadas.
- `test/features/ajustes/data/preferencias_repository_test.dart`.
- `test/features/onboarding/ui/onboarding_screen_test.dart`.
- `test/widget_test.dart` (fuera del Alcance: ahora necesita el override de preferencias).

**Comandos ejecutados y resultado:**
- `flutter gen-l10n` → clases de localización regeneradas con las claves nuevas.
- `dart run build_runner build` → `preferencias_providers.g.dart` generado; sin conflictos.
- `flutter analyze` → `No issues found!`
- `flutter test` → `All tests passed!` (53 tests)
- `flutter build apk --debug` → `app-debug.apk` construida.
- `flutter devices` → no hay dispositivo ni emulador Android conectado.

**Decisiones tomadas / desvíos del brief:**
- Las claves de «Otros» son `catOtrosGasto` y `catOtrosIngreso` para no colisionar entre los dos tipos.
- P02a y P02b son dos pasos dentro de un único `OnboardingScreen` con estado local; P02c se añadirá en la 016 sin rehacer la pantalla.
- Elegir idioma llama a `IdiomaActual.cambiar` en el acto: persiste la preferencia y `App` reconstruye con el nuevo `locale`.
- El `redirect` se apoya en `ref.watch(onboardingCompletoProvider)`, así que al completar el onboarding el router se recrea y sale de `/onboarding` automáticamente.
- El botón Continuar del paso 2 se deshabilita mientras se crean las categorías, para no duplicarlas con dobles pulsaciones.
- La vista previa de P02b usa `AppColores.categorias` en el mismo orden que `crearPorDefecto`.
- El paso 7 (probar el reinicio en el teléfono) no se ejecutó porque no hay emulador ni dispositivo Android conectado. La persistencia queda cubierta por el test del repositorio y el test de onboarding.

**Dudas o problemas pendientes:**
- Falta la comprobación manual en dispositivo del reinicio tras completar el onboarding.

---

## Auditoría
*(La escribe Claude Code.)*

**Ronda 1 — 2026-11-12 — APROBADA**

Lo verifiqué yo mismo: `flutter analyze` está limpio, los 53 tests pasan y `build_runner` no cambia el contenido de ningún `.g.dart`.
- El repositorio cumple la interfaz y sus valores por defecto.
- `main.dart` sobrescribe `sharedPreferencesProvider`.
- El `redirect` sigue ARQUITECTURA §5.
- P02a y P02b coinciden con las capturas.
- Los nombres de las categorías están traducidos y van en el orden de SPEC §4.

Desvíos que acepto:
- **Claves `catOtrosGasto` y `catOtrosIngreso`.** Correcto: así no chocan las dos «Otros».
- **Ajuste de `test/widget_test.dart`.** Era necesario.
- **Prueba manual de reinicio sin hacer.** La hará el usuario en su teléfono.

Observaciones que no bloquean (para tenerlas en cuenta en la 016, que vuelve a tocar esta pantalla):
- `onboarding_screen.dart`, `_finalizar`: si `crearPorDefecto` falla, `_creando` se queda en `true` y el botón queda deshabilitado sin ningún mensaje.
- `_OpcionIdioma` usa `AppEspacio.xl` como tamaño del ícono. Funciona, pero un tamaño de ícono no es un espaciado.
