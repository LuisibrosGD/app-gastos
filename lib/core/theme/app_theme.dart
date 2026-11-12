import 'package:flutter/material.dart';

import 'colores.dart';
import 'dimensiones.dart';
import 'tipografia.dart';

ThemeData construirTemaClaro() {
  const esquema = ColorScheme.light(
    primary: AppColores.primario,
    onPrimary: AppColores.superficie,
    primaryContainer: AppColores.primarioSuave,
    onPrimaryContainer: AppColores.primario,
    secondary: AppColores.primario,
    onSecondary: AppColores.superficie,
    secondaryContainer: AppColores.primarioSuave,
    onSecondaryContainer: AppColores.primario,
    tertiary: AppColores.textoSecundario,
    onTertiary: AppColores.superficie,
    error: AppColores.error,
    onError: AppColores.superficie,
    surface: AppColores.superficie,
    onSurface: AppColores.textoPrincipal,
    onSurfaceVariant: AppColores.textoSecundario,
    outline: AppColores.borde,
    outlineVariant: AppColores.borde,
    surfaceTint: AppColores.primario,
  );

  const bordeCampo = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(AppRadio.m)),
    borderSide: BorderSide(color: AppColores.borde),
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: 'Roboto',
    colorScheme: esquema,
    scaffoldBackgroundColor: AppColores.fondo,
    textTheme: const TextTheme(
      displaySmall: AppTexto.montoGrande,
      headlineSmall: AppTexto.titulo,
      titleMedium: AppTexto.subtitulo,
      bodyLarge: AppTexto.cuerpo,
      labelLarge: AppTexto.etiqueta,
      bodySmall: AppTexto.pequeno,
    ),
    dividerTheme: const DividerThemeData(
      color: AppColores.borde,
      thickness: 1,
      space: 1,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColores.superficie,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppEspacio.l,
        vertical: AppEspacio.l,
      ),
      hintStyle: AppTexto.cuerpo.copyWith(color: AppColores.textoSecundario),
      labelStyle: AppTexto.etiqueta.copyWith(
        color: AppColores.textoSecundario,
      ),
      errorStyle: AppTexto.pequeno.copyWith(color: AppColores.error),
      border: bordeCampo,
      enabledBorder: bordeCampo,
      disabledBorder: bordeCampo,
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppRadio.m)),
        borderSide: BorderSide(color: AppColores.primario, width: 2),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppRadio.m)),
        borderSide: BorderSide(color: AppColores.error, width: 2),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppRadio.m)),
        borderSide: BorderSide(color: AppColores.error, width: 2),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColores.primario,
        foregroundColor: AppColores.superficie,
        disabledBackgroundColor: AppColores.superficie,
        disabledForegroundColor: AppColores.textoSecundario,
        minimumSize: const Size(double.infinity, 52),
        padding: const EdgeInsets.symmetric(horizontal: AppEspacio.l),
        elevation: 0,
        textStyle: AppTexto.cuerpo,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadio.m)),
        ),
      ).copyWith(
        side: WidgetStateProperty.resolveWith((estados) {
          return estados.contains(WidgetState.disabled)
              ? const BorderSide(color: AppColores.borde)
              : BorderSide.none;
        }),
      ),
    ),
    cardTheme: const CardThemeData(
      color: AppColores.superficie,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppRadio.l)),
        side: BorderSide(color: AppColores.borde),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      height: 80,
      backgroundColor: AppColores.superficie,
      indicatorColor: AppColores.primarioSuave,
      elevation: 0,
      labelTextStyle: WidgetStateProperty.resolveWith((estados) {
        final seleccionada = estados.contains(WidgetState.selected);
        return AppTexto.pequeno.copyWith(
          color: seleccionada ? AppColores.primario : AppColores.textoSecundario,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((estados) {
        final seleccionada = estados.contains(WidgetState.selected);
        return IconThemeData(
          color: seleccionada ? AppColores.primario : AppColores.textoSecundario,
        );
      }),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColores.primario,
      foregroundColor: AppColores.superficie,
      elevation: 0,
      sizeConstraints: BoxConstraints.tightFor(width: 56, height: 56),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppRadio.l)),
      ),
    ),
  );
}
