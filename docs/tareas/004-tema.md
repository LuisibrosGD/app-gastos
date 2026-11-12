# 004 — Tema desde los tokens de Figma

**Estado:** APROBADA
**Tipo:** código
**Depende de:** 001, 003
**Referencias:** ARQUITECTURA §3 (regla 7), §6 · `docs/diseno/tokens.md` · `docs/diseno/componentes.png`

## Objetivo
`lib/core/theme` contiene todos los tokens de Figma como constantes y un `ThemeData` claro, aplicado en `App`.

## Alcance
**Se puede crear o modificar:**
- `lib/core/theme/colores.dart`, `tipografia.dart`, `dimensiones.dart`, `app_theme.dart`.
- `lib/app.dart` (solo para aplicar el tema).
- `test/core/theme/app_theme_test.dart`.

**Fuera de alcance:** widgets de componentes (se crean en cada feature cuando hacen falta).

## Interfaces que produce
```dart
abstract final class AppColores {           // un `static const Color` por cada color de tokens.md
  static const primario = Color(0xFF...);   // ... primarioSuave, fondo, superficie, borde, textoPrincipal,
                                            // textoSecundario, ingreso, gasto, alerta, error
  static const categorias = <Color>[...];   // exactamente 12, en el orden categoria01..12
}
abstract final class AppTexto { static const titulo = TextStyle(...); /* subtitulo, cuerpo, etiqueta, pequeno, montoGrande */ }
abstract final class AppEspacio { static const xs = 4.0, s = 8.0, m = 12.0, l = 16.0, xl = 24.0, xxl = 32.0; }
abstract final class AppRadio { static const s = 8.0, m = 12.0, l = 20.0; }
ThemeData construirTemaClaro();
```

## Pasos
1. Escribir los tests:
   ```dart
   expect(AppColores.categorias.length, 12);
   expect(AppColores.categorias.toSet().length, 12);            // sin repetidos
   final t = construirTemaClaro();
   expect(t.brightness, Brightness.light);
   expect(t.colorScheme.primary, AppColores.primario);
   expect(t.scaffoldBackgroundColor, AppColores.fondo);
   expect(t.colorScheme.error, AppColores.error);
   ```
2. Copiar **literalmente** los valores de `docs/diseno/tokens.md` en las constantes.
3. `construirTemaClaro()`: Material 3, `fontFamily: 'Roboto'`, `ColorScheme` desde los tokens, `textTheme` mapeado a `AppTexto`, y temas de `InputDecoration`, `FilledButton`, `Card`, `NavigationBar` y `FloatingActionButton` coherentes con `componentes.png`.
4. Aplicarlo en `App` (`theme: construirTemaClaro()`).
5. `flutter analyze` y `flutter test`.

## Criterios de aceptación
- [ ] Cada valor de `tokens.md` existe en `lib/core/theme` con el mismo valor.
- [ ] Ningún archivo fuera de `lib/core/theme` define colores con `Color(0x...)`.
- [ ] Tests del paso 1 en verde.
- [ ] `flutter analyze` sin errores ni advertencias.
- [ ] `flutter test` en verde.

---

## Reporte de implementación
*(Lo escribe Command Code. No borrar los títulos.)*

**Archivos creados o modificados:**
- `lib/core/theme/colores.dart`: los 11 colores de `tokens.md` y `AppColores.categorias` con los 12 colores en orden `categoria01`…`categoria12`.
- `lib/core/theme/tipografia.dart`: `AppTexto` con `titulo`, `subtitulo`, `cuerpo`, `etiqueta`, `pequeno` y `montoGrande` (Roboto, pesos, tamaños e interlineados del token).
- `lib/core/theme/dimensiones.dart`: `AppEspacio` (`xs`…`xxl`) y `AppRadio` (`s`, `m`, `l`).
- `lib/core/theme/app_theme.dart`: `construirTemaClaro()`.
- `lib/app.dart`: `theme: construirTemaClaro()`.
- `test/core/theme/app_theme_test.dart`.

**Comandos ejecutados y resultado:**
- `flutter analyze` → `No issues found!`
- `flutter test` → `All tests passed!` (32 tests)

**Decisiones tomadas / desvíos del brief:**
- `ColorScheme.light` construido solo con tokens: `primary`, `primaryContainer`, `secondary`, `tertiary`, `surface`, `outline`, `outlineVariant`, `surfaceTint`, `error` y sus `on*`; `onSurfaceVariant` usa `textoSecundario`.
- `textTheme` mapea los seis estilos de `AppTexto` a `displaySmall` (montoGrande), `headlineSmall` (titulo), `titleMedium` (subtitulo), `bodyLarge` (cuerpo), `labelLarge` (etiqueta) y `bodySmall` (pequeno).
- `InputDecorationTheme`: relleno `superficie`, borde `borde` redondeado `radioM`, foco y error con borde `primario`/`error` de 2 dp, hint y label en `textoSecundario`, error en `error`.
- `FilledButtonTheme`: 52 dp de alto, `radioM`, fondo `primario`, texto `superficie`, y deshabilitado `superficie` + `textoSecundario`.
- `CardTheme`: `superficie`, sin elevación, `radioL` y borde `borde`.
- `NavigationBarTheme`: 80 dp, fondo `superficie`, indicador `primarioSuave`, activa en `primario` e inactiva en `textoSecundario`, etiqueta `pequeno`.
- `FloatingActionButtonTheme`: 56 × 56, `radioL`, fondo `primario` y texto `superficie`.
- `AppTexto` fija `color: textoPrincipal` en los seis estilos; los usos que necesitan otro color lo cambian con `copyWith`.

**Dudas o problemas pendientes:**
- Ninguna.

---

## Auditoría
*(La escribe Claude Code.)*

**Ronda 1 — 2026-11-12 — APROBADA**

Lo verifiqué yo mismo: `flutter analyze` está limpio, los 32 tests pasan y no hay ningún `Color(0x…)` ni `Colors.` fuera de `lib/core/theme`.
- Los 11 colores, los 12 de categoría, los 6 estilos de texto, los radios y los espaciados coinciden uno por uno con `tokens.md`.
- Los temas de campo, botón, tarjeta, barra de navegación y FAB siguen las medidas de §5.
- Solo se tocaron los archivos del alcance.

Observación no bloqueante: el `FilledButton` deshabilitado no lleva el borde `borde` que pide tokens.md §5. Lo añadí como pendiente heredado a la tarea 006, que es la primera con un formulario.
