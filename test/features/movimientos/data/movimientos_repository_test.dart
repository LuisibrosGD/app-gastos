import 'package:app_gastos/core/database/app_database.dart';
import 'package:app_gastos/core/database/enums.dart';
import 'package:app_gastos/core/errors.dart';
import 'package:app_gastos/core/utils/moneda.dart';
import 'package:app_gastos/features/movimientos/data/modelos.dart';
import 'package:app_gastos/features/movimientos/data/movimientos_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

Future<int> nuevaCategoria(
  AppDatabase db,
  String nombre,
  TipoMovimiento tipo,
) {
  return db
      .into(db.categorias)
      .insert(
        CategoriasCompanion.insert(
          nombre: nombre,
          icono: 'otros',
          color: 0xFFC2410C,
          tipo: tipo,
        ),
      );
}

void main() {
  late AppDatabase db;
  late MovimientosRepository repo;
  late int catGasto;
  late int catIngreso;
  late int catGasto2;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    repo = MovimientosRepository(db);
    catGasto = await nuevaCategoria(db, 'Comida', TipoMovimiento.gasto);
    catIngreso = await nuevaCategoria(db, 'Sueldo', TipoMovimiento.ingreso);
    catGasto2 = await nuevaCategoria(db, 'Transporte', TipoMovimiento.gasto);
  });

  tearDown(() async {
    await db.close();
  });

  MovimientoInput entrada({
    TipoMovimiento tipo = TipoMovimiento.gasto,
    int montoCentimos = 1000,
    DateTime? fecha,
    int? categoriaId,
    String? nota,
  }) {
    return MovimientoInput(
      tipo: tipo,
      montoCentimos: montoCentimos,
      fecha: fecha ?? DateTime(2026, 11, 11),
      categoriaId: categoriaId ?? catGasto,
      nota: nota,
    );
  }

  Matcher errorValidacion(String campo, String codigo) {
    return throwsA(
      isA<ValidacionException>()
          .having((e) => e.campo, 'campo', campo)
          .having((e) => e.codigo, 'codigo', codigo),
    );
  }

  test('crear guarda fecha sin hora y nota vacía como null', () async {
    final id = await repo.crear(
      entrada(fecha: DateTime(2026, 11, 11, 18, 45), nota: '   '),
    );

    final fila = await (db.select(
      db.movimientos,
    )..where((t) => t.id.equals(id))).getSingle();

    expect(fila.fecha, DateTime(2026, 11, 11));
    expect(fila.nota, isNull);
    expect(fila.creadoEn, isNotNull);
  });

  test('monto 0 lanza ValidacionException(monto, mayorACero)', () async {
    await expectLater(
      repo.crear(entrada(montoCentimos: 0)),
      errorValidacion('monto', 'mayorACero'),
    );
    await expectLater(
      repo.crear(entrada(montoCentimos: kMaxCentimos + 1)),
      errorValidacion('monto', 'muyGrande'),
    );
  });

  test('nota de 201 caracteres lanza ValidacionException(nota, muyLargo)',
      () async {
    await expectLater(
      repo.crear(entrada(nota: 'a' * 201)),
      errorValidacion('nota', 'muyLargo'),
    );
  });

  test('gasto con categoría de ingreso lanza tipoNoCoincide', () async {
    await expectLater(
      repo.crear(entrada(categoriaId: catIngreso)),
      errorValidacion('categoria', 'tipoNoCoincide'),
    );
    await expectLater(
      repo.crear(entrada(categoriaId: 9999)),
      errorValidacion('categoria', 'requerido'),
    );
  });

  test(
    'actualizar de gasto a ingreso sin cambiar a una categoría de ingreso '
    'lanza tipoNoCoincide',
    () async {
      final id = await repo.crear(entrada());

      await expectLater(
        repo.actualizar(id, entrada(tipo: TipoMovimiento.ingreso)),
        errorValidacion('categoria', 'tipoNoCoincide'),
      );
    },
  );

  test('watchMes devuelve solo el mes pedido, ordenado por fecha desc',
      () async {
    final noviembre2 = await repo.crear(entrada(fecha: DateTime(2026, 11, 2)));
    final noviembre20 = await repo.crear(entrada(fecha: DateTime(2026, 11, 20)));
    final noviembre10 = await repo.crear(entrada(fecha: DateTime(2026, 11, 10)));
    await repo.crear(entrada(fecha: DateTime(2026, 12, 1)));

    final resultado = await repo
        .watchMes(FiltroMovimientos(mes: DateTime(2026, 11)))
        .first;

    expect(
      resultado.map((m) => m.movimiento.id),
      [noviembre20, noviembre10, noviembre2],
    );
  });

  test('watchMes filtra por tipo y por categoriaId', () async {
    final gasto = await repo.crear(entrada());
    final ingreso = await repo.crear(
      entrada(tipo: TipoMovimiento.ingreso, categoriaId: catIngreso),
    );
    final otroGasto = await repo.crear(entrada(categoriaId: catGasto2));

    final soloGastos = await repo
        .watchMes(
          FiltroMovimientos(
            mes: DateTime(2026, 11),
            tipo: TipoMovimiento.gasto,
          ),
        )
        .first;
    final soloComida = await repo
        .watchMes(
          FiltroMovimientos(mes: DateTime(2026, 11), categoriaId: catGasto),
        )
        .first;

    expect(soloGastos.map((m) => m.movimiento.id), [otroGasto, gasto]);
    expect(soloComida.map((m) => m.movimiento.id), [gasto]);
    expect(soloGastos.map((m) => m.movimiento.id), isNot(contains(ingreso)));
  });

  test(
    'watchMes incluye el 1 y el último día del mes y excluye el 1 del mes '
    'siguiente',
    () async {
      await repo.crear(entrada(fecha: DateTime(2026, 10, 31)));
      final primero = await repo.crear(entrada(fecha: DateTime(2026, 11, 1)));
      final ultimo = await repo.crear(entrada(fecha: DateTime(2026, 11, 30)));
      await repo.crear(entrada(fecha: DateTime(2026, 12, 1)));

      final resultado = await repo
          .watchMes(FiltroMovimientos(mes: DateTime(2026, 11)))
          .first;

      expect(
        resultado.map((m) => m.movimiento.id),
        [ultimo, primero],
      );
    },
  );

  test('watchRecientes devuelve como máximo 5, los más recientes', () async {
    final ids = <int>[];
    for (var dia = 1; dia <= 6; dia++) {
      ids.add(await repo.crear(entrada(fecha: DateTime(2026, 11, dia))));
    }

    final recientes = await repo.watchRecientes().first;

    expect(recientes, hasLength(5));
    expect(recientes.first.movimiento.id, ids[5]);
    expect(recientes.last.movimiento.id, ids[1]);
  });

  test('watchTotalesMes: ingresos 100000, gastos 35050 -> balance 64950',
      () async {
    await repo.crear(
      entrada(
        tipo: TipoMovimiento.ingreso,
        montoCentimos: 100000,
        categoriaId: catIngreso,
      ),
    );
    await repo.crear(entrada(montoCentimos: 35050));
    await repo.crear(entrada(fecha: DateTime(2026, 12, 1), montoCentimos: 999));

    final totales = await repo.watchTotalesMes(DateTime(2026, 11)).first;

    expect(totales.ingresos, 100000);
    expect(totales.gastos, 35050);
    expect(totales.balance, 64950);
  });

  test('eliminar lo quita de watchMes', () async {
    final id = await repo.crear(entrada());

    await repo.eliminar(id);

    final resultado = await repo
        .watchMes(FiltroMovimientos(mes: DateTime(2026, 11)))
        .first;
    expect(resultado, isEmpty);
  });
}
