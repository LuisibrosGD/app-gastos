import 'package:app_gastos/core/database/app_database.dart';
import 'package:app_gastos/core/database/enums.dart';
import 'package:app_gastos/core/errors.dart';
import 'package:app_gastos/features/categorias/data/catalogo.dart';
import 'package:app_gastos/features/categorias/data/categorias_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late CategoriasRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = CategoriasRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  Future<int> crearCategoria(
    String nombre, {
    TipoMovimiento tipo = TipoMovimiento.gasto,
  }) {
    return repo.crear(
      nombre: nombre,
      icono: 'otros',
      color: 0xFFC2410C,
      tipo: tipo,
    );
  }

  test('crear y listar por tipo ordenado por nombre', () async {
    await crearCategoria('Zeta');
    await crearCategoria('Alfa');
    await crearCategoria('Sueldo', tipo: TipoMovimiento.ingreso);

    final gastos = await repo.watchPorTipo(TipoMovimiento.gasto).first;
    final ingresos = await repo.watchPorTipo(TipoMovimiento.ingreso).first;

    expect(gastos.map((c) => c.nombre), ['Alfa', 'Zeta']);
    expect(ingresos.map((c) => c.nombre), ['Sueldo']);
  });

  test('nombre vacío o de 31 caracteres lanza ValidacionException', () async {
    await expectLater(
      crearCategoria('   '),
      throwsA(
        isA<ValidacionException>()
            .having((e) => e.campo, 'campo', 'nombre')
            .having((e) => e.codigo, 'codigo', 'requerido'),
      ),
    );
    await expectLater(
      crearCategoria('a' * 31),
      throwsA(
        isA<ValidacionException>()
            .having((e) => e.campo, 'campo', 'nombre')
            .having((e) => e.codigo, 'codigo', 'muyLargo'),
      ),
    );

    final id = await crearCategoria('Comida');
    await expectLater(
      repo.actualizar(id, nombre: '', icono: 'comida', color: 0xFFC2410C),
      throwsA(isA<ValidacionException>()),
    );
  });

  test('eliminar sin movimientos devuelve eliminada y desaparece', () async {
    final id = await crearCategoria('Comida');

    final resultado = await repo.eliminarOArchivar(id);

    expect(resultado, ResultadoEliminar.eliminada);
    expect(await repo.watchPorTipo(TipoMovimiento.gasto).first, isEmpty);
  });

  test(
    'eliminar con movimientos devuelve archivada y no aparece en watchPorTipo',
    () async {
      final id = await crearCategoria('Comida');
      await db
          .into(db.movimientos)
          .insert(
            MovimientosCompanion.insert(
              tipo: TipoMovimiento.gasto,
              montoCentimos: 1000,
              fecha: DateTime(2026, 11, 11),
              categoriaId: id,
              creadoEn: DateTime(2026, 11, 11, 10),
            ),
          );

      final resultado = await repo.eliminarOArchivar(id);

      expect(resultado, ResultadoEliminar.archivada);
      expect(await repo.watchPorTipo(TipoMovimiento.gasto).first, isEmpty);
    },
  );

  test('eliminar con regla recurrente devuelve archivada', () async {
    final id = await crearCategoria('Comida');
    await db
        .into(db.recurrentes)
        .insert(
          RecurrentesCompanion.insert(
            tipo: TipoMovimiento.gasto,
            montoCentimos: 1000,
            categoriaId: id,
            frecuencia: Frecuencia.mensual,
            dia: 1,
            fechaInicio: DateTime(2026, 1, 1),
            activo: true,
          ),
        );

    final resultado = await repo.eliminarOArchivar(id);

    expect(resultado, ResultadoEliminar.archivada);
    expect(await repo.watchPorTipo(TipoMovimiento.gasto).first, isEmpty);
  });

  test('watchPorTipo(incluirArchivadas: true) incluye las archivadas', () async {
    final archivada = await crearCategoria('Cine');
    await crearCategoria('Comida');
    await db
        .into(db.movimientos)
        .insert(
          MovimientosCompanion.insert(
            tipo: TipoMovimiento.gasto,
            montoCentimos: 1000,
            fecha: DateTime(2026, 11, 11),
            categoriaId: archivada,
            creadoEn: DateTime(2026, 11, 11, 10),
          ),
        );
    await repo.eliminarOArchivar(archivada);

    final activas = await repo.watchPorTipo(TipoMovimiento.gasto).first;
    final todas = await repo.watchPorTipo(
      TipoMovimiento.gasto,
      incluirArchivadas: true,
    ).first;

    expect(activas.map((c) => c.nombre), ['Comida']);
    expect(todas.map((c) => c.nombre), ['Cine', 'Comida']);
    expect(todas.first.archivada, isTrue);
  });

  test('crearPorDefecto crea 9 de gasto y 3 de ingreso; no duplica', () async {
    const gastos = [
      'Comida',
      'Transporte',
      'Vivienda',
      'Servicios',
      'Salud',
      'Entretenimiento',
      'Compras',
      'Educación',
      'Otros',
    ];
    const ingresos = ['Sueldo', 'Extra', 'Otros'];

    await repo.crearPorDefecto(gastos: gastos, ingresos: ingresos);

    final deGasto = await repo
        .watchPorTipo(TipoMovimiento.gasto, incluirArchivadas: true)
        .first;
    final deIngreso = await repo
        .watchPorTipo(TipoMovimiento.ingreso, incluirArchivadas: true)
        .first;

    expect(deGasto, hasLength(9));
    expect(deIngreso, hasLength(3));

    final gastoPorNombre = {for (final c in deGasto) c.nombre: c};
    final ingresoPorNombre = {for (final c in deIngreso) c.nombre: c};
    expect(gastoPorNombre['Comida']!.icono, 'comida');
    expect(gastoPorNombre['Educación']!.icono, 'educacion');
    expect(gastoPorNombre['Otros']!.icono, 'otros');
    expect(ingresoPorNombre['Sueldo']!.icono, 'sueldo');
    expect(ingresoPorNombre['Sueldo']!.color, 0xFFA21CAF);
    expect(ingresoPorNombre['Otros']!.color, 0xFFB91C1C);
    expect(await repo.hayCategorias(), isTrue);

    await repo.crearPorDefecto(gastos: gastos, ingresos: ingresos);

    expect(
      await repo
          .watchPorTipo(TipoMovimiento.gasto, incluirArchivadas: true)
          .first,
      hasLength(9),
    );
    expect(
      await repo
          .watchPorTipo(TipoMovimiento.ingreso, incluirArchivadas: true)
          .first,
      hasLength(3),
    );
  });
}
