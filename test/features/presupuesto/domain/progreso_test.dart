import 'package:app_gastos/core/database/app_database.dart';
import 'package:app_gastos/core/database/enums.dart';
import 'package:app_gastos/features/presupuesto/domain/progreso.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('porcentaje redondea hacia abajo y devuelve 0 sin límite', () {
    expect(porcentaje(79999, 100000), 79);
    expect(porcentaje(80000, 100000), 80);
    expect(porcentaje(150000, 100000), 150);
    expect(porcentaje(10, 0), 0);
    expect(porcentaje(10, -5), 0);
  });

  test('umbralesAlcanzados devuelve el subconjunto ordenado de [80, 100]', () {
    expect(umbralesAlcanzados(79999, 100000), isEmpty);
    expect(umbralesAlcanzados(80000, 100000), [80]);
    expect(umbralesAlcanzados(99999, 100000), [80]);
    expect(umbralesAlcanzados(100000, 100000), [80, 100]);
    expect(umbralesAlcanzados(150000, 100000), [80, 100]);
    expect(umbralesAlcanzados(500, 0), isEmpty);
  });

  test('ProgresoPresupuesto expone porcentaje, enAlerta y excedido', () {
    const presupuesto = Presupuesto(
      id: 1,
      montoCentimos: 100000,
    );
    final progreso = ProgresoPresupuesto(
      presupuesto: presupuesto,
      categoria: const Categoria(
        id: 1,
        nombre: 'Comida',
        icono: 'comida',
        color: 0xFFC2410C,
        tipo: TipoMovimiento.gasto,
        archivada: false,
      ),
      gastado: 85000,
    );

    expect(progreso.porcentaje, 85);
    expect(progreso.enAlerta, isTrue);
    expect(progreso.excedido, isFalse);
  });
}
