import 'package:app_gastos/core/database/app_database.dart';
import 'package:app_gastos/core/database/enums.dart';
import 'package:app_gastos/features/resumen/data/resumen_repository.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late ResumenRepository repo;
  late int catComida;
  late int catTransporte;
  late int catArchivada;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    repo = ResumenRepository(db);
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
    catTransporte = await db
        .into(db.categorias)
        .insert(
          CategoriasCompanion.insert(
            nombre: 'Transporte',
            icono: 'transporte',
            color: 0xFF0E7490,
            tipo: TipoMovimiento.gasto,
          ),
        );
    catArchivada = await db
        .into(db.categorias)
        .insert(
          CategoriasCompanion.insert(
            nombre: 'Antigua',
            icono: 'otros',
            color: 0xFF5A6577,
            tipo: TipoMovimiento.gasto,
            archivada: const Value(true),
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
    int? categoriaId,
  }) {
    return db
        .into(db.movimientos)
        .insert(
          MovimientosCompanion.insert(
            tipo: tipo,
            montoCentimos: monto,
            fecha: fecha,
            categoriaId: categoriaId ?? catComida,
            creadoEn: DateTime(2026, 1, 1),
          ),
        );
  }

  test('agrupa gastos por categoría y porcentajes que suman 100', () async {
    await movimiento(
      tipo: TipoMovimiento.gasto,
      monto: 5000,
      fecha: DateTime(2026, 11, 3),
    );
    await movimiento(
      tipo: TipoMovimiento.gasto,
      monto: 3000,
      fecha: DateTime(2026, 11, 4),
      categoriaId: catTransporte,
    );
    await movimiento(
      tipo: TipoMovimiento.gasto,
      monto: 2000,
      fecha: DateTime(2026, 11, 5),
      categoriaId: catArchivada,
    );

    final lista = await repo
        .watchGastosPorCategoria(DateTime(2026, 11))
        .first;

    expect(lista, hasLength(3));
    expect(
      lista.map((item) => item.categoria.nombre),
      ['Comida', 'Transporte', 'Antigua'],
    );
    expect(lista.map((item) => item.totalCentimos), [5000, 3000, 2000]);
    expect(lista.map((item) => item.porcentaje), [50, 30, 20]);
    expect(
      lista.fold<double>(0, (acc, item) => acc + item.porcentaje),
      closeTo(100, 0.001),
    );
  });

  test('ignora ingresos y otros meses', () async {
    await movimiento(
      tipo: TipoMovimiento.gasto,
      monto: 5000,
      fecha: DateTime(2026, 11, 3),
    );
    await movimiento(
      tipo: TipoMovimiento.ingreso,
      monto: 99999,
      fecha: DateTime(2026, 11, 4),
      categoriaId: catComida,
    );
    await movimiento(
      tipo: TipoMovimiento.gasto,
      monto: 7000,
      fecha: DateTime(2026, 10, 3),
    );

    final lista = await repo
        .watchGastosPorCategoria(DateTime(2026, 11))
        .first;

    expect(lista, hasLength(1));
    expect(lista.single.totalCentimos, 5000);
  });

  test('incluye categorías archivadas con gastos', () async {
    await movimiento(
      tipo: TipoMovimiento.gasto,
      monto: 4200,
      fecha: DateTime(2026, 11, 6),
      categoriaId: catArchivada,
    );

    final lista = await repo
        .watchGastosPorCategoria(DateTime(2026, 11))
        .first;

    expect(lista, hasLength(1));
    expect(lista.single.categoria.nombre, 'Antigua');
    expect(lista.single.porcentaje, 100);
  });

  test('ultimosMeses(2026-03) devuelve 6 meses con ceros en los vacíos',
      () async {
    await movimiento(
      tipo: TipoMovimiento.ingreso,
      monto: 100000,
      fecha: DateTime(2026, 1, 15),
    );
    await movimiento(
      tipo: TipoMovimiento.gasto,
      monto: 40000,
      fecha: DateTime(2026, 3, 10),
    );

    final lista = await repo.watchUltimosMeses(DateTime(2026, 3)).first;

    expect(lista, hasLength(6));
    expect(
      lista.map((item) => item.mes),
      [
        DateTime(2025, 10),
        DateTime(2025, 11),
        DateTime(2025, 12),
        DateTime(2026, 1),
        DateTime(2026, 2),
        DateTime(2026, 3),
      ],
    );
    expect(lista[3].ingresos, 100000);
    expect(lista[3].gastos, 0);
    expect(lista[5].gastos, 40000);
    expect(lista[0].ingresos, 0);
    expect(lista[0].gastos, 0);
  });
}
