import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/enums.dart';
import '../../../core/errors.dart';
import '../../../core/utils/fechas.dart';
import '../../../core/utils/moneda.dart';
import 'modelos.dart';

class MovimientosRepository {
  MovimientosRepository(this._db);

  final AppDatabase _db;

  Future<int> crear(MovimientoInput input) async {
    await _validar(input);

    return _db
        .into(_db.movimientos)
        .insert(
          MovimientosCompanion.insert(
            tipo: input.tipo,
            montoCentimos: input.montoCentimos,
            fecha: soloFecha(input.fecha),
            categoriaId: input.categoriaId,
            nota: Value(_notaLimpia(input.nota)),
            recurrenteId: Value(input.recurrenteId),
            creadoEn: DateTime.now(),
          ),
        );
  }

  Future<void> actualizar(int id, MovimientoInput input) async {
    await _validar(input);

    await (_db.update(
      _db.movimientos,
    )..where((t) => t.id.equals(id))).write(
      MovimientosCompanion(
        tipo: Value(input.tipo),
        montoCentimos: Value(input.montoCentimos),
        fecha: Value(soloFecha(input.fecha)),
        categoriaId: Value(input.categoriaId),
        nota: Value(_notaLimpia(input.nota)),
        recurrenteId: Value(input.recurrenteId),
      ),
    );
  }

  Future<void> eliminar(int id) async {
    await (_db.delete(_db.movimientos)..where((t) => t.id.equals(id))).go();
  }

  Future<MovimientoConCategoria?> obtener(int id) async {
    final consulta = _consultaConCategoria()
      ..where(_db.movimientos.id.equals(id));

    final fila = await consulta.getSingleOrNull();
    return fila == null ? null : _aModelo(fila);
  }

  Stream<List<MovimientoConCategoria>> watchMes(FiltroMovimientos filtro) {
    final desde = inicioMes(filtro.mes);
    final hasta = inicioMesSiguiente(filtro.mes);

    final consulta = _consultaConCategoria()
      ..where(
        _db.movimientos.fecha.isBiggerOrEqualValue(desde) &
            _db.movimientos.fecha.isSmallerThanValue(hasta),
      );

    final tipo = filtro.tipo;
    if (tipo != null) {
      consulta.where(_db.movimientos.tipo.equalsValue(tipo));
    }
    final categoriaId = filtro.categoriaId;
    if (categoriaId != null) {
      consulta.where(_db.movimientos.categoriaId.equals(categoriaId));
    }

    consulta.orderBy([
      OrderingTerm.desc(_db.movimientos.fecha),
      OrderingTerm.desc(_db.movimientos.id),
    ]);

    return consulta.watch().map(_aModelos);
  }

  Stream<List<MovimientoConCategoria>> watchRecientes({int limite = 5}) {
    final consulta = _consultaConCategoria()
      ..orderBy([
        OrderingTerm.desc(_db.movimientos.fecha),
        OrderingTerm.desc(_db.movimientos.id),
      ])
      ..limit(limite);

    return consulta.watch().map(_aModelos);
  }

  Stream<TotalesMes> watchTotalesMes(DateTime mes) {
    final desde = inicioMes(mes);
    final hasta = inicioMesSiguiente(mes);
    final suma = _db.movimientos.montoCentimos.sum();

    final consulta = _db.selectOnly(_db.movimientos)
      ..addColumns([suma, _db.movimientos.tipo])
      ..where(
        _db.movimientos.fecha.isBiggerOrEqualValue(desde) &
            _db.movimientos.fecha.isSmallerThanValue(hasta),
      )
      ..groupBy([_db.movimientos.tipo]);

    return consulta.watch().map((filas) {
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
      return TotalesMes(mes: desde, ingresos: ingresos, gastos: gastos);
    });
  }

  JoinedSelectStatement<HasResultSet, dynamic> _consultaConCategoria() {
    return _db.select(_db.movimientos).join([
      innerJoin(
        _db.categorias,
        _db.categorias.id.equalsExp(_db.movimientos.categoriaId),
      ),
    ]);
  }

  MovimientoConCategoria _aModelo(TypedResult fila) {
    return MovimientoConCategoria(
      fila.readTable(_db.movimientos),
      fila.readTable(_db.categorias),
    );
  }

  List<MovimientoConCategoria> _aModelos(List<TypedResult> filas) {
    return filas.map(_aModelo).toList();
  }

  Future<void> _validar(MovimientoInput input) async {
    if (input.montoCentimos <= 0) {
      throw ValidacionException('monto', 'mayorACero');
    }
    if (input.montoCentimos > kMaxCentimos) {
      throw ValidacionException('monto', 'muyGrande');
    }
    if ((input.nota ?? '').trim().length > 200) {
      throw ValidacionException('nota', 'muyLargo');
    }

    final categoria =
        await (_db.select(_db.categorias)
              ..where((t) => t.id.equals(input.categoriaId)))
            .getSingleOrNull();
    if (categoria == null) {
      throw ValidacionException('categoria', 'requerido');
    }
    if (categoria.tipo != input.tipo) {
      throw ValidacionException('categoria', 'tipoNoCoincide');
    }
  }

  String? _notaLimpia(String? nota) {
    final limpia = nota?.trim();
    return (limpia == null || limpia.isEmpty) ? null : limpia;
  }
}
