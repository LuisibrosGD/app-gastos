import 'dart:async';

import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/enums.dart';
import '../../../core/utils/fechas.dart';
import '../domain/progreso.dart';

class PresupuestosRepository {
  PresupuestosRepository(this._db);

  final AppDatabase _db;

  Future<void> guardarTotal(int? montoCentimos) async {
    final existente = await (_db.select(
      _db.presupuestos,
    )..where((t) => t.categoriaId.isNull())).getSingleOrNull();

    if (montoCentimos == null) {
      if (existente != null) {
        await (_db.delete(
          _db.presupuestos,
        )..where((t) => t.id.equals(existente.id))).go();
      }
      return;
    }

    if (existente == null) {
      await _db
          .into(_db.presupuestos)
          .insert(
            PresupuestosCompanion.insert(montoCentimos: montoCentimos),
          );
    } else {
      await (_db.update(
        _db.presupuestos,
      )..where((t) => t.id.equals(existente.id))).write(
        PresupuestosCompanion(montoCentimos: Value(montoCentimos)),
      );
    }
  }

  Future<void> guardarCategoria(int categoriaId, int? montoCentimos) async {
    final existente = await (_db.select(
      _db.presupuestos,
    )..where((t) => t.categoriaId.equals(categoriaId))).getSingleOrNull();

    if (montoCentimos == null) {
      if (existente != null) {
        await (_db.delete(
          _db.presupuestos,
        )..where((t) => t.id.equals(existente.id))).go();
      }
      return;
    }

    if (existente == null) {
      await _db
          .into(_db.presupuestos)
          .insert(
            PresupuestosCompanion.insert(
              categoriaId: Value(categoriaId),
              montoCentimos: montoCentimos,
            ),
          );
    } else {
      await (_db.update(
        _db.presupuestos,
      )..where((t) => t.id.equals(existente.id))).write(
        PresupuestosCompanion(montoCentimos: Value(montoCentimos)),
      );
    }
  }

  Stream<List<ProgresoPresupuesto>> watchProgreso(DateTime mes) {
    late final StreamController<List<ProgresoPresupuesto>> controlador;
    StreamSubscription<Set<TableUpdate>>? suscripcion;

    Future<void> emitir() async {
      final lista = await _progresoActual(mes);
      if (!controlador.isClosed) controlador.add(lista);
    }

    controlador = StreamController<List<ProgresoPresupuesto>>(
      onListen: () {
        emitir();
        suscripcion = _db
            .tableUpdates(
              TableUpdateQuery.onAllTables([
                _db.presupuestos,
                _db.categorias,
                _db.movimientos,
              ]),
            )
            .listen((_) => emitir());
      },
      onCancel: () async {
        await suscripcion?.cancel();
      },
    );

    return controlador.stream;
  }

  Future<List<ProgresoPresupuesto>> _progresoActual(DateTime mes) async {
    final consulta = _db.select(_db.presupuestos).join([
      leftOuterJoin(
        _db.categorias,
        _db.categorias.id.equalsExp(_db.presupuestos.categoriaId),
      ),
    ]);

    final filas = await consulta.get();
    final lista = <ProgresoPresupuesto>[];
    for (final fila in filas) {
      final presupuesto = fila.readTable(_db.presupuestos);
      final categoria = fila.readTableOrNull(_db.categorias);
      lista.add(await _progreso(mes, presupuesto, categoria));
    }
    lista.sort((a, b) {
      final aTotal = a.categoria == null;
      final bTotal = b.categoria == null;
      if (aTotal != bTotal) return aTotal ? -1 : 1;
      final aNombre = a.categoria?.nombre.toLowerCase() ?? '';
      final bNombre = b.categoria?.nombre.toLowerCase() ?? '';
      return aNombre.compareTo(bNombre);
    });
    return lista;
  }

  Future<List<ProgresoPresupuesto>> progresoPara(
    DateTime mes,
    int categoriaId,
  ) async {
    final consulta = _db.select(_db.presupuestos)
      ..where(
        (t) => t.categoriaId.isNull() | t.categoriaId.equals(categoriaId),
      );

    final presupuestos = await consulta.get();
    final lista = <ProgresoPresupuesto>[];
    for (final presupuesto in presupuestos) {
      final categoria = await _categoriaDe(presupuesto.categoriaId);
      lista.add(await _progreso(mes, presupuesto, categoria));
    }
    lista.sort((a, b) {
      final aTotal = a.categoria == null;
      final bTotal = b.categoria == null;
      if (aTotal != bTotal) return aTotal ? -1 : 1;
      return 0;
    });
    return lista;
  }

  Future<Categoria?> _categoriaDe(int? id) {
    if (id == null) return Future.value();
    return (_db.select(
      _db.categorias,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<ProgresoPresupuesto> _progreso(
    DateTime mes,
    Presupuesto presupuesto,
    Categoria? categoria,
  ) async {
    final gastado = await _gastado(mes, presupuesto.categoriaId);
    return ProgresoPresupuesto(
      presupuesto: presupuesto,
      categoria: categoria,
      gastado: gastado,
    );
  }

  Future<int> _gastado(DateTime mes, int? categoriaId) async {
    final desde = inicioMes(mes);
    final hasta = inicioMesSiguiente(mes);
    final suma = _db.movimientos.montoCentimos.sum();

    final consulta = _db.selectOnly(_db.movimientos)
      ..addColumns([suma])
      ..where(
        _db.movimientos.tipo.equalsValue(TipoMovimiento.gasto) &
            _db.movimientos.fecha.isBiggerOrEqualValue(desde) &
            _db.movimientos.fecha.isSmallerThanValue(hasta),
      );

    if (categoriaId != null) {
      consulta.where(_db.movimientos.categoriaId.equals(categoriaId));
    }

    final fila = await consulta.getSingle();
    return fila.read(suma) ?? 0;
  }
}
