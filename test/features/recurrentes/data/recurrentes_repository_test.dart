import 'package:app_gastos/core/database/app_database.dart';
import 'package:app_gastos/core/database/enums.dart';
import 'package:app_gastos/core/errors.dart';
import 'package:app_gastos/features/movimientos/data/modelos.dart';
import 'package:app_gastos/features/movimientos/data/movimientos_repository.dart';
import 'package:app_gastos/features/recurrentes/data/recurrentes_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late RecurrentesRepository repo;
  late int catComida;
  late int catSueldo;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    repo = RecurrentesRepository(db);
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
    catSueldo = await db
        .into(db.categorias)
        .insert(
          CategoriasCompanion.insert(
            nombre: 'Sueldo',
            icono: 'sueldo',
            color: 0xFF047857,
            tipo: TipoMovimiento.ingreso,
          ),
        );
  });

  tearDown(() async {
    await db.close();
  });

  RecurrenteInput input({
    TipoMovimiento tipo = TipoMovimiento.gasto,
    int? categoriaId,
    Frecuencia frecuencia = Frecuencia.mensual,
    int dia = 15,
    int monto = 1000,
  }) {
    return RecurrenteInput(
      tipo: tipo,
      montoCentimos: monto,
      categoriaId: categoriaId ?? catComida,
      frecuencia: frecuencia,
      dia: dia,
      fechaInicio: DateTime(2026, 1, 1),
    );
  }

  test('crear valida dia fuera de rango y tipo de categoría', () async {
    await expectLater(
      repo.crear(input(dia: 32)),
      throwsA(
        isA<ValidacionException>()
            .having((e) => e.campo, 'campo', 'dia')
            .having((e) => e.codigo, 'codigo', 'fueraDeRango'),
      ),
    );

    await expectLater(
      repo.crear(input(frecuencia: Frecuencia.semanal, dia: 8)),
      throwsA(
        isA<ValidacionException>()
            .having((e) => e.campo, 'campo', 'dia')
            .having((e) => e.codigo, 'codigo', 'fueraDeRango'),
      ),
    );

    await expectLater(
      repo.crear(input(categoriaId: catSueldo)),
      throwsA(
        isA<ValidacionException>()
            .having((e) => e.campo, 'campo', 'categoria')
            .having((e) => e.codigo, 'codigo', 'tipoNoCoincide'),
      ),
    );
  });

  test('eliminar regla conserva sus movimientos con recurrenteId null',
      () async {
    final reglaId = await repo.crear(input());
    final movimientoId = await MovimientosRepository(db).crear(
      MovimientoInput(
        tipo: TipoMovimiento.gasto,
        montoCentimos: 1000,
        fecha: DateTime(2026, 1, 15),
        categoriaId: catComida,
        recurrenteId: reglaId,
      ),
    );

    await repo.eliminar(reglaId);

    expect(await db.select(db.recurrentes).get(), isEmpty);
    final movimiento = await (db.select(
      db.movimientos,
    )..where((t) => t.id.equals(movimientoId))).getSingle();
    expect(movimiento.recurrenteId, isNull);
  });
}
