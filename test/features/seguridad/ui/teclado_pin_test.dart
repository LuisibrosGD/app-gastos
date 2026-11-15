import 'dart:math';

import 'package:app_gastos/features/seguridad/ui/widgets/teclado_pin.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('mezclarDigitos devuelve una permutación de 0–9', () {
    final orden = mezclarDigitos(Random(1));

    expect(orden, hasLength(10));
    expect(orden.toSet(), {0, 1, 2, 3, 4, 5, 6, 7, 8, 9});
  });

  test('mezclarDigitos con semillas distintas da órdenes distintos', () {
    final primero = mezclarDigitos(Random(1));
    final segundo = mezclarDigitos(Random(2));

    expect(primero, isNot(equals(segundo)));
  });
}
