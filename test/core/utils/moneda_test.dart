import 'package:app_gastos/core/utils/moneda.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('formatSoles', () {
    test('formatea céntimos con separador de miles y dos decimales', () {
      expect(formatSoles(123450), 'S/ 1,234.50');
    });

    test('rellena los céntimos con ceros', () {
      expect(formatSoles(5), 'S/ 0.05');
    });

    test('coloca el signo delante del símbolo', () {
      expect(formatSoles(-5000), '-S/ 50.00');
    });

    test('formatea el cero', () {
      expect(formatSoles(0), 'S/ 0.00');
    });
  });

  group('parseSoles', () {
    test('acepta un entero', () {
      expect(parseSoles('12'), 1200);
    });

    test('acepta un decimal con punto', () {
      expect(parseSoles('12.5'), 1250);
    });

    test('acepta un decimal con coma', () {
      expect(parseSoles('12,50'), 1250);
    });

    test('ignora espacios y el prefijo S/', () {
      expect(parseSoles(' S/ 7.05 '), 705);
    });

    test('acepta cero', () {
      expect(parseSoles('0'), 0);
    });

    test('rechaza más de dos decimales', () {
      expect(parseSoles('0.999'), isNull);
    });

    test('rechaza separadores de miles', () {
      expect(parseSoles('1,234.50'), isNull);
    });

    test('rechaza signos', () {
      expect(parseSoles('-3'), isNull);
    });

    test('rechaza letras', () {
      expect(parseSoles('abc'), isNull);
    });

    test('rechaza la cadena vacía', () {
      expect(parseSoles(''), isNull);
    });

    test('acepta el máximo permitido', () {
      expect(parseSoles('99999999.99'), kMaxCentimos);
    });

    test('rechaza valores por encima del máximo', () {
      expect(parseSoles('100000000'), isNull);
    });

    test('rechaza un separador sin decimales', () {
      expect(parseSoles('12.'), isNull);
    });

    test('rechaza dos separadores iguales', () {
      expect(parseSoles('12.5.0'), isNull);
    });

    test('rechaza números que desbordarían el entero de 64 bits', () {
      expect(parseSoles('92233720368547759'), isNull);
    });

    test('rechaza números de 25 dígitos', () {
      expect(parseSoles('1234567890123456789012345'), isNull);
    });
  });
}
