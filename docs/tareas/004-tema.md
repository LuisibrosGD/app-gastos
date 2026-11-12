# 004 — Tema desde los tokens de Figma

**Estado:** PENDIENTE
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
