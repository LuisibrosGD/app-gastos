import 'package:app_gastos/core/database/app_database.dart';
import 'package:app_gastos/core/database/enums.dart';
import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  Future<int> crearCategoria() {
    return db
        .into(db.categorias)
        .insert(
          CategoriasCompanion.insert(
            nombre: 'Comida',
            icono: 'comida',
            color: 0xFFC2410C,
            tipo: TipoMovimiento.gasto,
          ),
        );
  }

  Future<int> crearRecurrente(int categoriaId) {
    return db
        .into(db.recurrentes)
        .insert(
          RecurrentesCompanion.insert(
            tipo: TipoMovimiento.gasto,
            montoCentimos: 1000,
            categoriaId: categoriaId,
            frecuencia: Frecuencia.mensual,
            dia: 1,
            fechaInicio: DateTime(2026, 1, 1),
            activo: true,
          ),
        );
  }

  MovimientosCompanion movimiento({
    int categoriaId = 1,
    int montoCentimos = 1000,
    int? recurrenteId,
  }) {
    return MovimientosCompanion.insert(
      tipo: TipoMovimiento.gasto,
      montoCentimos: montoCentimos,
      fecha: DateTime(2026, 11, 11),
      categoriaId: categoriaId,
      creadoEn: DateTime(2026, 11, 11, 10),
      recurrenteId: Value(recurrenteId),
    );
  }

  test('crea las 5 tablas', () async {
    final categoriaId = await crearCategoria();
    final recurrenteId = await crearRecurrente(categoriaId);
    final presupuestoId = await db
        .into(db.presupuestos)
        .insert(
          PresupuestosCompanion.insert(montoCentimos: 50000),
        );
    await db
        .into(db.movimientos)
        .insert(movimiento(categoriaId: categoriaId, recurrenteId: recurrenteId));
    await db
        .into(db.alertasEnviadas)
        .insert(
          AlertasEnviadasCompanion.insert(
            presupuestoId: presupuestoId,
            mes: '2026-11',
            umbral: 80,
          ),
        );

    expect(await db.select(db.categorias).get(), hasLength(1));
    expect(await db.select(db.recurrentes).get(), hasLength(1));
    expect(await db.select(db.presupuestos).get(), hasLength(1));
    expect(await db.select(db.movimientos).get(), hasLength(1));
    expect(await db.select(db.alertasEnviadas).get(), hasLength(1));
    expect(db.schemaVersion, 1);
  });

  test('rechaza movimiento con categoria inexistente', () async {
    await expectLater(
      db.into(db.movimientos).insert(movimiento(categoriaId: 999)),
      throwsA(isA<SqliteException>()),
    );
  });

  test('rechaza monto <= 0', () async {
    final categoriaId = await crearCategoria();

    await expectLater(
      db.into(db.movimientos).insert(movimiento(montoCentimos: 0)),
      throwsA(isA<SqliteException>()),
    );
    await expectLater(
      db
          .into(db.presupuestos)
          .insert(PresupuestosCompanion.insert(montoCentimos: 0)),
      throwsA(isA<SqliteException>()),
    );
    await expectLater(
      db
          .into(db.recurrentes)
          .insert(
            RecurrentesCompanion.insert(
              tipo: TipoMovimiento.gasto,
              montoCentimos: -1,
              categoriaId: categoriaId,
              frecuencia: Frecuencia.mensual,
              dia: 1,
              fechaInicio: DateTime(2026, 1, 1),
              activo: true,
            ),
          ),
      throwsA(isA<SqliteException>()),
    );
  });

  test('solo un presupuesto total', () async {
    await db
        .into(db.presupuestos)
        .insert(PresupuestosCompanion.insert(montoCentimos: 50000));

    await expectLater(
      db
          .into(db.presupuestos)
          .insert(PresupuestosCompanion.insert(montoCentimos: 60000)),
      throwsA(isA<SqliteException>()),
    );
  });

  test('solo un presupuesto por categoria', () async {
    final categoriaId = await crearCategoria();

    await db
        .into(db.presupuestos)
        .insert(
          PresupuestosCompanion.insert(
            categoriaId: Value(categoriaId),
            montoCentimos: 50000,
          ),
        );

    await expectLater(
      db
          .into(db.presupuestos)
          .insert(
            PresupuestosCompanion.insert(
              categoriaId: Value(categoriaId),
              montoCentimos: 60000,
            ),
          ),
      throwsA(isA<SqliteException>()),
    );
  });

  test('borrar recurrente deja movimiento con recurrenteId null', () async {
    final categoriaId = await crearCategoria();
    final recurrenteId = await crearRecurrente(categoriaId);
    await db
        .into(db.movimientos)
        .insert(movimiento(categoriaId: categoriaId, recurrenteId: recurrenteId));

    await (db.delete(db.recurrentes)..where((t) => t.id.equals(recurrenteId))).go();

    final guardado = await db.select(db.movimientos).getSingle();
    expect(guardado.recurrenteId, isNull);
  });

  test('borrar presupuesto borra sus alertas enviadas', () async {
    final presupuestoId = await db
        .into(db.presupuestos)
        .insert(PresupuestosCompanion.insert(montoCentimos: 50000));
    await db
        .into(db.alertasEnviadas)
        .insert(
          AlertasEnviadasCompanion.insert(
            presupuestoId: presupuestoId,
            mes: '2026-11',
            umbral: 80,
          ),
        );

    await (db.delete(db.presupuestos)..where((t) => t.id.equals(presupuestoId)))
        .go();

    expect(await db.select(db.alertasEnviadas).get(), isEmpty);
  });

  test('borrar categoría borra su presupuesto', () async {
    final categoriaId = await crearCategoria();
    await db
        .into(db.presupuestos)
        .insert(
          PresupuestosCompanion.insert(
            categoriaId: Value(categoriaId),
            montoCentimos: 50000,
          ),
        );

    await (db.delete(db.categorias)..where((t) => t.id.equals(categoriaId)))
        .go();

    expect(await db.select(db.presupuestos).get(), isEmpty);
  });

  test('alertasEnviadas no admite duplicado (presupuestoId, mes, umbral)',
      () async {
    final presupuestoId = await db
        .into(db.presupuestos)
        .insert(PresupuestosCompanion.insert(montoCentimos: 50000));
    final alerta = AlertasEnviadasCompanion.insert(
      presupuestoId: presupuestoId,
      mes: '2026-11',
      umbral: 80,
    );

    await db.into(db.alertasEnviadas).insert(alerta);

    await expectLater(
      db.into(db.alertasEnviadas).insert(alerta),
      throwsA(isA<SqliteException>()),
    );
  });
}
