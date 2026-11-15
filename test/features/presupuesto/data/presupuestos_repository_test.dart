import 'dart:async';

import 'package:app_gastos/core/database/app_database.dart';
import 'package:app_gastos/core/database/enums.dart';
import 'package:app_gastos/features/presupuesto/data/presupuestos_repository.dart';
import 'package:app_gastos/features/presupuesto/domain/progreso.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late PresupuestosRepository repositorio;
  late int catComida;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    repositorio = PresupuestosRepository(db);
    catComida = await db
        .into(db.categorias)
        .insert(
          CategoriasCompanion.insert(
            nombre: 'Comida',
            icono: 'comida',
            color: 0xFFC2410C,
            tipo: TipoMovimiento.gasto,
          ),
        );
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> movimiento({
    required TipoMovimiento tipo,
    required int monto,
    required DateTime fecha,
    required int categoriaId,
  }) {
    return db
        .into(db.movimientos)
        .insert(
          MovimientosCompanion.insert(
            tipo: tipo,
            montoCentimos: monto,
            fecha: fecha,
            categoriaId: categoriaId,
            creadoEn: DateTime(2026, 11, 1),
          ),
        );
  }

  test('guardarTotal dos veces actualiza en lugar de duplicar; null lo elimina',
      () async {
    await repositorio.guardarTotal(100000);
    await repositorio.guardarTotal(200000);

    var filas = await db.select(db.presupuestos).get();
    expect(filas, hasLength(1));
    expect(filas.single.categoriaId, isNull);
    expect(filas.single.montoCentimos, 200000);

    await repositorio.guardarTotal(null);
    filas = await db.select(db.presupuestos).get();
    expect(filas, isEmpty);
  });

  test('guardarCategoria actualiza y elimina por categoría', () async {
    await repositorio.guardarCategoria(catComida, 40000);
    await repositorio.guardarCategoria(catComida, 50000);

    var filas = await db.select(db.presupuestos).get();
    expect(filas, hasLength(1));
    expect(filas.single.categoriaId, catComida);
    expect(filas.single.montoCentimos, 50000);

    await repositorio.guardarCategoria(catComida, null);
    filas = await db.select(db.presupuestos).get();
    expect(filas, isEmpty);
  });

  test('watchProgreso suma solo gastos del mes e ignora ingresos y otros meses',
      () async {
    await repositorio.guardarTotal(100000);
    await repositorio.guardarCategoria(catComida, 40000);

    final mes = DateTime(2026, 11);
    await movimiento(
      tipo: TipoMovimiento.gasto,
      monto: 2450,
      fecha: DateTime(2026, 11, 12),
      categoriaId: catComida,
    );
    await movimiento(
      tipo: TipoMovimiento.ingreso,
      monto: 99999,
      fecha: DateTime(2026, 11, 12),
      categoriaId: catComida,
    );
    await movimiento(
      tipo: TipoMovimiento.gasto,
      monto: 5000,
      fecha: DateTime(2026, 12, 1),
      categoriaId: catComida,
    );

    final lista = await repositorio.watchProgreso(mes).first;

    expect(lista, hasLength(2));
    expect(lista.first.categoria, isNull);
    expect(lista.first.gastado, 2450);
    expect(lista.first.porcentaje, 2);
    expect(lista.last.categoria?.nombre, 'Comida');
    expect(lista.last.gastado, 2450);
    expect(lista.last.porcentaje, 6);
  });

  test('watchProgreso emite de nuevo al añadir un gasto', () async {
    await repositorio.guardarTotal(100000);
    final mes = DateTime(2026, 11);
    final primera = Completer<List<ProgresoPresupuesto>>();
    final segunda = Completer<List<ProgresoPresupuesto>>();
    final suscripcion = repositorio.watchProgreso(mes).listen((lista) {
      if (!primera.isCompleted) {
        primera.complete(lista);
      } else if (!segunda.isCompleted) {
        segunda.complete(lista);
      }
    });
    addTearDown(suscripcion.cancel);

    final antes = await primera.future;
    expect(antes.single.gastado, 0);

    await movimiento(
      tipo: TipoMovimiento.gasto,
      monto: 2450,
      fecha: DateTime(2026, 11, 12),
      categoriaId: catComida,
    );

    final despues = await segunda.future.timeout(const Duration(seconds: 2));
    expect(despues.single.gastado, 2450);
  });

  test('progresoPara devuelve el total primero y luego la categoría', () async {
    await repositorio.guardarCategoria(catComida, 40000);
    await repositorio.guardarTotal(100000);
    await movimiento(
      tipo: TipoMovimiento.gasto,
      monto: 3000,
      fecha: DateTime(2026, 11, 5),
      categoriaId: catComida,
    );

    final lista = await repositorio.progresoPara(
      DateTime(2026, 11),
      catComida,
    );

    expect(lista, hasLength(2));
    expect(lista.first.categoria, isNull);
    expect(lista.first.gastado, 3000);
    expect(lista.last.categoria?.id, catComida);
  });
}
