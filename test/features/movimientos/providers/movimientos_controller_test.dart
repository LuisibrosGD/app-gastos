import 'package:app_gastos/core/database/app_database.dart';
import 'package:app_gastos/core/database/database_provider.dart';
import 'package:app_gastos/core/database/enums.dart';
import 'package:app_gastos/core/errors.dart';
import 'package:app_gastos/features/ajustes/providers/preferencias_providers.dart';
import 'package:app_gastos/features/movimientos/data/modelos.dart';
import 'package:app_gastos/features/movimientos/providers/movimientos_providers.dart';
import 'package:app_gastos/features/presupuesto/data/notificador.dart';
import 'package:app_gastos/features/presupuesto/providers/presupuesto_providers.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificadorFalso implements Notificador {
  final llamadas = <({String titulo, String cuerpo})>[];

  @override
  Future<void> mostrar({
    required String titulo,
    required String cuerpo,
  }) async {
    llamadas.add((titulo: titulo, cuerpo: cuerpo));
  }
}

void main() {
  late AppDatabase db;
  late ProviderContainer container;
  late NotificadorFalso notificador;
  late int categoriaId;
  late int categoriaIngresoId;

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
    categoriaIngresoId = await db
        .into(db.categorias)
        .insert(
          CategoriasCompanion.insert(
            nombre: 'Sueldo',
            icono: 'sueldo',
            color: 0xFFA21CAF,
            tipo: TipoMovimiento.ingreso,
          ),
        );
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    notificador = NotificadorFalso();
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        sharedPreferencesProvider.overrideWithValue(prefs),
        notificadorProvider.overrideWithValue(notificador),
      ],
    );
    addTearDown(container.dispose);
  });

  tearDown(() async {
    await db.close();
  });

  MovimientoInput entrada({
    int montoCentimos = 1000,
    DateTime? fecha,
    TipoMovimiento? tipo,
    int? categoria,
  }) {
    return MovimientoInput(
      tipo: tipo ?? TipoMovimiento.gasto,
      montoCentimos: montoCentimos,
      fecha: fecha ?? DateTime(2026, 11, 11),
      categoriaId: categoria ?? categoriaId,
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

  test('guardar un ingreso no llama a revisar', () async {
    await container.read(presupuestosRepositoryProvider).guardarTotal(100000);
    final controller = container.read(movimientosControllerProvider.notifier);

    await controller.guardar(
      input: entrada(
        montoCentimos: 90000,
        tipo: TipoMovimiento.ingreso,
        categoria: categoriaIngresoId,
      ),
    );

    expect(notificador.llamadas, isEmpty);
    expect(await db.select(db.alertasEnviadas).get(), isEmpty);
  });

  test('editar un gasto moviéndolo a otro mes revisa el mes nuevo', () async {
    await container.read(presupuestosRepositoryProvider).guardarTotal(100000);
    final controller = container.read(movimientosControllerProvider.notifier);

    final id = await controller.guardar(
      input: entrada(montoCentimos: 85000),
    );
    expect(notificador.llamadas, hasLength(1));
    expect(
      (await db.select(db.alertasEnviadas).get()).single.mes,
      '2026-11',
    );

    notificador.llamadas.clear();
    await controller.guardar(
      id: id,
      input: entrada(
        montoCentimos: 85000,
        fecha: DateTime(2026, 12, 1),
      ),
    );

    expect(notificador.llamadas, hasLength(1));
    final alertas = await db.select(db.alertasEnviadas).get();
    expect(alertas.map((a) => a.mes), contains('2026-12'));
  });

  test('eliminar borra el movimiento', () async {
    final controller = container.read(movimientosControllerProvider.notifier);
    final id = await controller.guardar(input: entrada());

    await controller.eliminar(id);

    final filas = await db.select(db.movimientos).get();
    expect(filas, isEmpty);
  });
}
