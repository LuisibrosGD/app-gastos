# 007 — Preferencias, idioma y onboarding P02

**Estado:** PENDIENTE
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
