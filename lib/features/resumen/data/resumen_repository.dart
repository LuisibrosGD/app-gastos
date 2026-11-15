import 'dart:async';

import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/enums.dart';
import '../../../core/utils/fechas.dart';
import '../../movimientos/data/modelos.dart';

class GastoPorCategoria {
  const GastoPorCategoria({
    required this.categoria,
    required this.totalCentimos,
    required this.porcentaje,
  });

  final Categoria categoria;
  final int totalCentimos;
  final double porcentaje;
}

class ResumenRepository {
  ResumenRepository(this._db);

  final AppDatabase _db;

  Stream<List<GastoPorCategoria>> watchGastosPorCategoria(DateTime mes) {
    final desde = inicioMes(mes);
    final hasta = inicioMesSiguiente(mes);
    final suma = _db.movimientos.montoCentimos.sum();

    final consulta = _db.select(_db.movimientos).join([
      innerJoin(
        _db.categorias,
        _db.categorias.id.equalsExp(_db.movimientos.categoriaId),
      ),
    ])
      ..addColumns([suma])
      ..where(
        _db.movimientos.tipo.equalsValue(TipoMovimiento.gasto) &
            _db.movimientos.fecha.isBiggerOrEqualValue(desde) &
            _db.movimientos.fecha.isSmallerThanValue(hasta),
      )
      ..groupBy([_db.categorias.id])
      ..orderBy([OrderingTerm.desc(suma)]);

    return consulta.watch().map((filas) {
      final parciales = [
        for (final fila in filas)
          (
            categoria: fila.readTable(_db.categorias),
            total: fila.read(suma) ?? 0,
          ),
      ];
      final total = parciales.fold<int>(0, (acc, item) => acc + item.total);
      if (total == 0) return <GastoPorCategoria>[];

      return [
        for (final item in parciales)
          GastoPorCategoria(
            categoria: item.categoria,
            totalCentimos: item.total,
            porcentaje: item.total * 100 / total,
          ),
      ];
    });
  }

  Stream<List<TotalesMes>> watchUltimosMeses(
    DateTime mesFinal, {
    int cantidad = 6,
  }) {
    late final StreamController<List<TotalesMes>> controlador;
    StreamSubscription<Set<TableUpdate>>? suscripcion;

    Future<void> emitir() async {
      final lista = await _totales(mesFinal, cantidad);
      if (!controlador.isClosed) controlador.add(lista);
    }

    controlador = StreamController<List<TotalesMes>>(
      onListen: () {
        emitir();
        suscripcion = _db.tableUpdates(
          TableUpdateQuery.onTable(_db.movimientos),
        ).listen((_) => emitir());
      },
      onCancel: () async {
        await suscripcion?.cancel();
      },
    );

    return controlador.stream;
  }

  Future<List<TotalesMes>> _totales(DateTime mesFinal, int cantidad) async {
    final meses = [
      for (var i = cantidad - 1; i >= 0; i--)
        DateTime(mesFinal.year, mesFinal.month - i),
    ];
    final resultado = <TotalesMes>[];
    for (final mes in meses) {
      resultado.add(await _totalesDe(mes));
    }
    return resultado;
  }

  Future<TotalesMes> _totalesDe(DateTime mes) async {
    final suma = _db.movimientos.montoCentimos.sum();
    final consulta = _db.selectOnly(_db.movimientos)
      ..addColumns([suma, _db.movimientos.tipo])
      ..where(
        _db.movimientos.fecha.isBiggerOrEqualValue(inicioMes(mes)) &
            _db.movimientos.fecha.isSmallerThanValue(inicioMesSiguiente(mes)),
      )
      ..groupBy([_db.movimientos.tipo]);

    final filas = await consulta.get();
    var ingresos = 0;
    var gastos = 0;
    for (final fila in filas) {
      final total = fila.read(suma) ?? 0;
      if (fila.readWithConverter(_db.movimientos.tipo) ==
          TipoMovimiento.ingreso) {
        ingresos = total;
      } else {
        gastos = total;
      }
    }
    return TotalesMes(mes: inicioMes(mes), ingresos: ingresos, gastos: gastos);
  }
}
