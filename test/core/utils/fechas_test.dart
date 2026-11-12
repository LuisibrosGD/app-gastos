import 'package:app_gastos/core/utils/fechas.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('es');
    await initializeDateFormatting('en');
  });

  test('soloFecha deja la fecha a medianoche local', () {
    expect(soloFecha(DateTime(2026, 3, 5, 18, 30)), DateTime(2026, 3, 5));
  });

  test('claveMes usa el formato YYYY-MM', () {
    expect(claveMes(DateTime(2026, 3, 5)), '2026-03');
  });

  test('inicioMes devuelve el día 1 a medianoche', () {
    expect(inicioMes(DateTime(2026, 3, 5, 18, 30)), DateTime(2026, 3, 1));
  });

  test('inicioMesSiguiente cruza de año', () {
    expect(inicioMesSiguiente(DateTime(2026, 12, 15)), DateTime(2027, 1, 1));
  });

  test('ultimoDiaDelMes respeta el año bisiesto', () {
    expect(ultimoDiaDelMes(2028, 2), DateTime(2028, 2, 29));
  });

  test('ultimoDiaDelMes devuelve el 28 de febrero en año común', () {
    expect(ultimoDiaDelMes(2026, 2), DateTime(2026, 2, 28));
  });

  test('formatFecha en español usa el día y el mes abreviado', () {
    expect(formatFecha(DateTime(2026, 11, 11), 'es'), '11 nov 2026');
  });

  test('formatFecha en inglés usa el mes abreviado delante', () {
    expect(formatFecha(DateTime(2026, 11, 11), 'en'), 'Nov 11, 2026');
  });
}
