import 'package:flutter/material.dart';

import 'colores.dart';

abstract final class AppTexto {
  static const titulo = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w600,
    fontSize: 22,
    height: 28 / 22,
    color: AppColores.textoPrincipal,
  );

  static const subtitulo = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w500,
    fontSize: 18,
    height: 24 / 18,
    color: AppColores.textoPrincipal,
  );

  static const cuerpo = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 24 / 16,
    color: AppColores.textoPrincipal,
  );

  static const etiqueta = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w500,
    fontSize: 14,
    height: 20 / 14,
    color: AppColores.textoPrincipal,
  );

  static const pequeno = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 16 / 12,
    color: AppColores.textoPrincipal,
  );

  static const montoGrande = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w700,
    fontSize: 32,
    height: 40 / 32,
    color: AppColores.textoPrincipal,
  );
}
