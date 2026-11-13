import 'package:app_gastos/core/database/app_database.dart';
import 'package:app_gastos/core/database/database_provider.dart';
import 'package:app_gastos/core/database/enums.dart';
import 'package:app_gastos/core/errors.dart';
import 'package:app_gastos/features/movimientos/data/modelos.dart';
import 'package:app_gastos/features/movimientos/providers/movimientos_providers.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late ProviderContainer container;
  late int categoriaId;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    categoriaId = await db
        .into(db.categorias)
        .insert(
          CategoriasCompanion.insert(
            nombre: 'Comida',
            icono: 'comida',
            color: 0xFFC2410C,
            tipo: TipoMovimiento.gasto,
          ),
        );
    container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
    );
    addTearDown(container.dispose);
  });

  tearDown(() async {
    await db.close();
  });

  MovimientoInput entrada({int montoCentimos = 1000}) {
    return MovimientoInput(
      tipo: TipoMovimiento.gasto,
      montoCentimos: montoCentimos,
      fecha: DateTime(2026, 11, 11),
      categoriaId: categoriaId,
    );
  }

  test('guardar sin id crea y con id actualiza, y relanza la validación',
      () async {
    final controller = container.read(movimientosControllerProvider.notifier);

    final id = await controller.guardar(input: entrada());
    expect(id, greaterThan(0));

    final creado = await (db.select(
      db.movimientos,
    )..where((t) => t.id.equals(id))).getSingle();
    expect(creado.montoCentimos, 1000);

    final mismoId = await controller.guardar(
      id: id,
      input: entrada(montoCentimos: 2000),
    );
    expect(mismoId, id);

    final actualizado = await (db.select(
      db.movimientos,
    )..where((t) => t.id.equals(id))).getSingle();
    expect(actualizado.montoCentimos, 2000);

    await expectLater(
      controller.guardar(input: entrada(montoCentimos: 0)),
      throwsA(
        isA<ValidacionException>()
            .having((e) => e.campo, 'campo', 'monto')
            .having((e) => e.codigo, 'codigo', 'mayorACero'),
      ),
    );
  });

  test('eliminar borra el movimiento', () async {
    final controller = container.read(movimientosControllerProvider.notifier);
    final id = await controller.guardar(input: entrada());

    await controller.eliminar(id);

    final filas = await db.select(db.movimientos).get();
    expect(filas, isEmpty);
  });
}
