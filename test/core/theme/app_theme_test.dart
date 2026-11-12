import 'package:app_gastos/core/theme/app_theme.dart';
import 'package:app_gastos/core/theme/colores.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('hay doce colores de categoría distintos', () {
    expect(AppColores.categorias.length, 12);
    expect(AppColores.categorias.toSet().length, 12);
  });

  test('el tema claro usa los colores del sistema', () {
    final tema = construirTemaClaro();

    expect(tema.brightness, Brightness.light);
    expect(tema.colorScheme.primary, AppColores.primario);
    expect(tema.scaffoldBackgroundColor, AppColores.fondo);
    expect(tema.colorScheme.error, AppColores.error);
  });
}
