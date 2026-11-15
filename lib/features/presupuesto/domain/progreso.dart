import '../../../core/database/app_database.dart';

/// Porcentaje gastado, redondeado hacia abajo. 0 si no hay límite.
int porcentaje(int gastado, int limite) {
  if (limite <= 0) return 0;
  return (gastado * 100) ~/ limite;
}

/// Umbrales de alerta alcanzados: subconjunto ordenado de [80, 100].
List<int> umbralesAlcanzados(int gastado, int limite) {
  if (limite <= 0) return const [];
  return [
    if (gastado * 100 >= limite * 80) 80,
    if (gastado * 100 >= limite * 100) 100,
  ];
}

class ProgresoPresupuesto {
  const ProgresoPresupuesto({
    required this.presupuesto,
    required this.categoria,
    required this.gastado,
  });

  final Presupuesto presupuesto;

  /// `null` cuando el presupuesto es el total.
  final Categoria? categoria;

  final int gastado;

  int get porcentaje {
    final limite = presupuesto.montoCentimos;
    if (limite <= 0) return 0;
    return (gastado * 100) ~/ limite;
  }

  bool get enAlerta => porcentaje >= 80;

  bool get excedido => porcentaje >= 100;
}
