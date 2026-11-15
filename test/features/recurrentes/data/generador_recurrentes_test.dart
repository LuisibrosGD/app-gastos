import 'package:app_gastos/core/database/app_database.dart';
import 'package:app_gastos/core/database/enums.dart';
import 'package:app_gastos/core/l10n/app_localizations.dart';
import 'package:app_gastos/features/movimientos/data/movimientos_repository.dart';
import 'package:app_gastos/features/presupuesto/data/alertas_service.dart';
import 'package:app_gastos/features/presupuesto/data/notificador.dart';
import 'package:app_gastos/features/presupuesto/data/presupuestos_repository.dart';
import 'package:app_gastos/features/recurrentes/data/generador_recurrentes.dart';
import 'package:app_gastos/features/recurrentes/data/recurrentes_repository.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

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
  late RecurrentesRepository recurrentes;
  late GeneradorRecurrentes generador;
  late NotificadorFalso notificador;
  late int catComida;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    recurrentes = RecurrentesRepository(db);
    notificador = NotificadorFalso();
    generador = GeneradorRecurrentes(
      db: db,
      movimientos: MovimientosRepository(db),
      alertas: AlertasService(
        db: db,
        presupuestos: PresupuestosRepository(db),
        notificador: notificador,
        textos: () => lookupAppLocalizations(const Locale('es')),
      ),
    );
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

  Future<int> crearRegla({
    int monto = 1000,
    int dia = 15,
    DateTime? fechaInicio,
    bool activo = true,
  }) {
    return recurrentes.crear(
      RecurrenteInput(
        tipo: TipoMovimiento.gasto,
        montoCentimos: monto,
        categoriaId: catComida,
        frecuencia: Frecuencia.mensual,
        dia: dia,
        fechaInicio: fechaInicio ?? DateTime(2026, 1, 1),
        activo: activo,
      ),
    );
  }

  test('generar 3 meses atrasados crea 3 movimientos y actualiza ultimaGeneracion',
      () async {
    final reglaId = await crearRegla();
    final hoy = DateTime(2026, 3, 20);

    final creados = await generador.generarPendientes(hoy);

    expect(creados, 3);
    final movimientos = await db.select(db.movimientos).get();
    expect(
      movimientos.map((m) => m.fecha),
      [DateTime(2026, 1, 15), DateTime(2026, 2, 15), DateTime(2026, 3, 15)],
    );
    expect(movimientos.every((m) => m.recurrenteId == reglaId), isTrue);

    final regla = await (db.select(
      db.recurrentes,
    )..where((t) => t.id.equals(reglaId))).getSingle();
    expect(regla.ultimaGeneracion, DateTime(2026, 3, 20));
  });

  test('generar dos veces el mismo día no duplica', () async {
    await crearRegla();
    final hoy = DateTime(2026, 3, 20);

    expect(await generador.generarPendientes(hoy), 3);
    expect(await generador.generarPendientes(hoy), 0);

    expect(await db.select(db.movimientos).get(), hasLength(3));
  });

  test('dos generaciones simultáneas no duplican', () async {
    await crearRegla();
    final hoy = DateTime(2026, 3, 20);

    final resultados = await Future.wait([
      generador.generarPendientes(hoy),
      generador.generarPendientes(hoy),
    ]);

    expect(resultados.reduce((a, b) => a + b), 3);
    expect(await db.select(db.movimientos).get(), hasLength(3));
  });

  test('borrar un movimiento generado y volver a generar no lo recrea',
      () async {
    await crearRegla();
    final hoy = DateTime(2026, 3, 20);
    await generador.generarPendientes(hoy);

    final primero = (await db.select(db.movimientos).get()).first;
    await (db.delete(
      db.movimientos,
    )..where((t) => t.id.equals(primero.id))).go();

    expect(await generador.generarPendientes(hoy), 0);
    expect(await db.select(db.movimientos).get(), hasLength(2));
  });

  test('regla inactiva no genera', () async {
    await crearRegla(activo: false);

    expect(await generador.generarPendientes(DateTime(2026, 3, 20)), 0);
    expect(await db.select(db.movimientos).get(), isEmpty);
  });

  test('regla con categoría archivada sigue generando', () async {
    await crearRegla();
    await (db.update(
      db.categorias,
    )..where((t) => t.id.equals(catComida))).write(
      const CategoriasCompanion(archivada: Value(true)),
    );

    expect(await generador.generarPendientes(DateTime(2026, 3, 20)), 3);
    expect(await db.select(db.movimientos).get(), hasLength(3));
  });

  test('un gasto generado que cruza el 80% dispara una notificación', () async {
    await PresupuestosRepository(db).guardarTotal(100000);
    await crearRegla(
      monto: 85000,
      dia: 12,
      fechaInicio: DateTime(2026, 11, 1),
    );

    final creados = await generador.generarPendientes(DateTime(2026, 11, 12));

    expect(creados, 1);
    expect(notificador.llamadas, hasLength(1));
    expect(notificador.llamadas.single.titulo, 'Presupuesto al 80%');
  });
}
