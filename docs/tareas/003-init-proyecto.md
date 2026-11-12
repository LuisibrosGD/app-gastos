# 003 — Inicializar proyecto Flutter y utilidades base

**Estado:** PENDIENTE
**Tipo:** configuración
**Depende de:** ninguna
**Referencias:** ARQUITECTURA §1, §2, §5 (Formato), §8, §9 · SPEC R1 · INDICE A1

## Objetivo
Un proyecto Flutter que compila y arranca en Android con la estructura de carpetas, las dependencias, la localización es/en y las utilidades de moneda y fecha testeadas.

## Contexto
- El proyecto se crea **en la raíz del repo** (`C:\CHAMBA\Proyectos\app-gastos`), sin subcarpeta. Ya existen `docs/`, `CLAUDE.md`, `AGENTS.md` y `.commandcode/`: no borrarlos.
- Nombre del paquete: `app_gastos`. Organización: `com.appgastos`. Nombre visible: "App Gastos".

## Alcance
**Se puede crear o modificar:**
- Todo lo que genera `flutter create` (`android/`, `lib/main.dart`, `pubspec.yaml`, `analysis_options.yaml`, `.gitignore`, `test/`).
- `l10n.yaml`, `lib/app.dart`, `lib/core/l10n/app_es.arb`, `lib/core/l10n/app_en.arb`.
- `lib/core/router/app_router.dart`, `lib/core/utils/moneda.dart`, `lib/core/utils/fechas.dart`, `lib/core/errors.dart`.
- `test/core/utils/moneda_test.dart`, `test/core/utils/fechas_test.dart`, `test/core/l10n_test.dart`, `test/widget_test.dart`.

**Fuera de alcance:** `docs/`, `CLAUDE.md`, `AGENTS.md`. Nada de iOS, web ni desktop: crea solo la plataforma Android.

## Interfaces que produce
```dart
// lib/core/utils/moneda.dart
const int kMaxCentimos = 9999999999;           // S/ 99,999,999.99
String formatSoles(int centimos);              // 123450 -> 'S/ 1,234.50'; -5000 -> '-S/ 50.00'; 0 -> 'S/ 0.00'
int? parseSoles(String texto);                 // null si es inválido

// lib/core/utils/fechas.dart
DateTime soloFecha(DateTime d);                // misma fecha a las 00:00 local
String claveMes(DateTime d);                   // 'YYYY-MM'
DateTime inicioMes(DateTime d);                // día 1, 00:00
DateTime inicioMesSiguiente(DateTime d);       // límite exclusivo del mes
DateTime ultimoDiaDelMes(int anio, int mes);
String formatFecha(DateTime d, String localeCode); // 'es' -> '11 nov 2026'; 'en' -> 'Nov 11, 2026'

// lib/core/errors.dart
class ValidacionException implements Exception {
  ValidacionException(this.campo, this.codigo);
  final String campo;   // p. ej. 'monto'
  final String codigo;  // p. ej. 'requerido', 'mayorACero', 'muyLargo', 'tipoNoCoincide'
}

// lib/core/router/app_router.dart
final appRouterProvider = Provider<GoRouter>(...); // de momento, una única ruta '/' con pantalla vacía
```
Reglas de `parseSoles`: quita los espacios y un prefijo `S/` opcional; acepta un solo separador decimal `.` o `,`; como máximo 2 decimales; no acepta separadores de miles, signo ni letras; el valor no puede superar `kMaxCentimos`. `''` → `null`.

## Pasos
1. `flutter create --org com.appgastos --project-name app_gastos --platforms android .`
2. En `android/app/build.gradle(.kts)`: `minSdk = 23`; en el `AndroidManifest`: `android:label="App Gastos"`.
3. Añadir **todas** las dependencias de ARQUITECTURA §1 (versiones estables actuales, fijadas con `^`) y `flutter_lints` en dev.
4. Configurar la localización: `l10n.yaml` con `arb-dir: lib/core/l10n`, `template-arb-file: app_es.arb`, `output-class: AppLocalizations`, `nullable-getter: false`; `generate: true` en `pubspec.yaml`. Claves iniciales: `appTitle`.
5. Crear la carpeta `lib/features/` vacía, con un `.gitkeep`.
6. Escribir los tests del paso 7 y comprobar que fallan.
7. Tests:
   ```dart
   // moneda_test.dart
   expect(formatSoles(123450), 'S/ 1,234.50');
   expect(formatSoles(5), 'S/ 0.05');
   expect(formatSoles(-5000), '-S/ 50.00');
   expect(parseSoles('12'), 1200);
   expect(parseSoles('12.5'), 1250);
   expect(parseSoles('12,50'), 1250);
   expect(parseSoles(' S/ 7.05 '), 705);
   expect(parseSoles('0'), 0);
   expect(parseSoles('0.999'), isNull);
   expect(parseSoles('1,234.50'), isNull);   // sin separadores de miles
   expect(parseSoles('-3'), isNull);
   expect(parseSoles('abc'), isNull);
   expect(parseSoles(''), isNull);
   expect(parseSoles('99999999.99'), kMaxCentimos);
   expect(parseSoles('100000000'), isNull);
   // fechas_test.dart
   expect(soloFecha(DateTime(2026, 3, 5, 18, 30)), DateTime(2026, 3, 5));
   expect(claveMes(DateTime(2026, 3, 5)), '2026-03');
   expect(inicioMesSiguiente(DateTime(2026, 12, 15)), DateTime(2027, 1, 1));
   expect(ultimoDiaDelMes(2028, 2), DateTime(2028, 2, 29));
   expect(ultimoDiaDelMes(2026, 2), DateTime(2026, 2, 28));
   // l10n_test.dart: lee los dos ARB como JSON e ignora las claves que empiezan con '@'
   expect(clavesEs, equals(clavesEn));
   ```
8. Implementar las utilidades (`intl` para `formatSoles` y `formatFecha`), `errors.dart`, el router mínimo y `app.dart` (`MaterialApp.router` con `localizationsDelegates`, `supportedLocales: [Locale('es'), Locale('en')]` y `locale: Locale('es')` fijo por ahora). `main.dart`: `runApp(ProviderScope(child: App()))`.
9. Sustituir `test/widget_test.dart` por un smoke test: la `App` se construye sin excepciones.
10. Ejecutar `flutter analyze` y `flutter test`. Arrancar en un emulador o teléfono desde Android Studio y comprobar que abre.

## Criterios de aceptación
- [ ] La app arranca en Android y muestra una pantalla vacía sin errores.
- [ ] Todos los tests del paso 7 pasan, más el smoke test.
- [ ] `pubspec.yaml` contiene exactamente las dependencias de ARQUITECTURA §1.
- [ ] No se generaron plataformas distintas de Android.
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
