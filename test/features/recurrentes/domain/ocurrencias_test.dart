import 'package:app_gastos/core/database/enums.dart';
import 'package:app_gastos/features/recurrentes/domain/ocurrencias.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('mensual día 15 genera una fecha por mes', () {
    final resultado = ocurrenciasPendientes(
      frecuencia: Frecuencia.mensual,
      dia: 15,
      fechaInicio: DateTime(2026, 1, 10),
      hoy: DateTime(2026, 3, 20),
    );

    expect(resultado, [
      DateTime(2026, 1, 15),
      DateTime(2026, 2, 15),
      DateTime(2026, 3, 15),
    ]);
  });

  test('mensual día 31 usa el último día en meses cortos (2028 bisiesto)', () {
    final resultado = ocurrenciasPendientes(
      frecuencia: Frecuencia.mensual,
      dia: 31,
      fechaInicio: DateTime(2028, 1, 1),
      hoy: DateTime(2028, 3, 31),
    );

    expect(resultado, [
      DateTime(2028, 1, 31),
      DateTime(2028, 2, 29),
      DateTime(2028, 3, 31),
    ]);
  });

  test('mensual día 31 en 2026 usa el 28 de febrero', () {
    final resultado = ocurrenciasPendientes(
      frecuencia: Frecuencia.mensual,
      dia: 31,
      fechaInicio: DateTime(2026, 1, 1),
      hoy: DateTime(2026, 2, 28),
    );

    expect(resultado, [DateTime(2026, 1, 31), DateTime(2026, 2, 28)]);
  });

  test('con ultimaGeneracion hoy no hay pendientes', () {
    final resultado = ocurrenciasPendientes(
      frecuencia: Frecuencia.mensual,
      dia: 15,
      fechaInicio: DateTime(2026, 1, 1),
      ultimaGeneracion: DateTime(2026, 3, 20),
      hoy: DateTime(2026, 3, 20),
    );

    expect(resultado, isEmpty);
  });

  test('fechaInicio futura no genera nada', () {
    final resultado = ocurrenciasPendientes(
      frecuencia: Frecuencia.mensual,
      dia: 1,
      fechaInicio: DateTime(2026, 12, 1),
      hoy: DateTime(2026, 11, 11),
    );

    expect(resultado, isEmpty);
  });

  test('la fechaInicio que cae en el día de ocurrencia se incluye', () {
    final resultado = ocurrenciasPendientes(
      frecuencia: Frecuencia.mensual,
      dia: 15,
      fechaInicio: DateTime(2026, 1, 15),
      hoy: DateTime(2026, 1, 15),
    );

    expect(resultado, [DateTime(2026, 1, 15)]);
  });

  test('semanal día 1 genera los lunes del intervalo', () {
    final resultado = ocurrenciasPendientes(
      frecuencia: Frecuencia.semanal,
      dia: 1,
      fechaInicio: DateTime(2026, 11, 1),
      hoy: DateTime(2026, 11, 16),
    );

    expect(resultado, [
      DateTime(2026, 11, 2),
      DateTime(2026, 11, 9),
      DateTime(2026, 11, 16),
    ]);
  });
}
