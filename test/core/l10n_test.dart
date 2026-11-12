import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

Set<String> clavesDe(String ruta) {
  final contenido = File(ruta).readAsStringSync();
  final mapa = jsonDecode(contenido) as Map<String, dynamic>;
  return mapa.keys.where((clave) => !clave.startsWith('@')).toSet();
}

void main() {
  test('español e inglés tienen las mismas claves', () {
    final clavesEs = clavesDe('lib/core/l10n/app_es.arb');
    final clavesEn = clavesDe('lib/core/l10n/app_en.arb');
    expect(clavesEs, equals(clavesEn));
  });
}
