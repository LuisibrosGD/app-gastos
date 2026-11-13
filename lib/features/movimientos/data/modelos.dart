import '../../../core/database/app_database.dart';
import '../../../core/database/enums.dart';

class MovimientoInput {
  const MovimientoInput({
    required this.tipo,
    required this.montoCentimos,
    required this.fecha,
    required this.categoriaId,
    this.nota,
    this.recurrenteId,
  });

  final TipoMovimiento tipo;
  final int montoCentimos;
  final DateTime fecha;
  final int categoriaId;
  final String? nota;
  final int? recurrenteId;
}

class MovimientoConCategoria {
  const MovimientoConCategoria(this.movimiento, this.categoria);

  final Movimiento movimiento;
  final Categoria categoria;
}

class TotalesMes {
  const TotalesMes({
    required this.mes,
    required this.ingresos,
    required this.gastos,
  });

  final DateTime mes;
  final int ingresos;
  final int gastos;

  int get balance => ingresos - gastos;
}

class FiltroMovimientos {
  const FiltroMovimientos({required this.mes, this.tipo, this.categoriaId});

  final DateTime mes;
  final TipoMovimiento? tipo;
  final int? categoriaId;

  @override
  bool operator ==(Object other) {
    return other is FiltroMovimientos &&
        other.mes == mes &&
        other.tipo == tipo &&
        other.categoriaId == categoriaId;
  }

  @override
  int get hashCode => Object.hash(mes, tipo, categoriaId);
}
