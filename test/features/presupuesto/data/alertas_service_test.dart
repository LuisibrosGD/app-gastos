import 'package:app_gastos/core/database/app_database.dart';
import 'package:app_gastos/core/database/enums.dart';
import 'package:app_gastos/core/l10n/app_localizations.dart';
import 'package:app_gastos/features/presupuesto/data/alertas_service.dart';
import 'package:app_gastos/features/presupuesto/data/notificador.dart';
import 'package:app_gastos/features/presupuesto/data/presupuestos_repository.dart';
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
  late PresupuestosRepository presupuestos;
  late NotificadorFalso notificador;
  late AlertasService servicio;
  late int catComida;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    presupuestos = PresupuestosRepository(db);
    notificador = NotificadorFalso();
    servicio = AlertasService(
      db: db,
      presupuestos: presupuestos,
      notificador: notificador,
      textos: () => lookupAppLocalizations(const Locale('es')),
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

  Future<void> gasto(int monto, DateTime fecha) {
    return db
        .into(db.movimientos)
        .insert(
          MovimientosCompanion.insert(
            tipo: TipoMovimiento.gasto,
            montoCentimos: monto,
            fecha: fecha,
            categoriaId: catComida,
            creadoEn: DateTime(2026, 11, 1),
          ),
        );
  }

  test('revisar al 85% notifica 1 vez (80); repetir no vuelve a notificar',
      () async {
    await presupuestos.guardarTotal(100000);
    await gasto(85000, DateTime(2026, 11, 12));

    await servicio.revisar(
      fecha: DateTime(2026, 11, 12),
      categoriaId: catComida,
    );

    expect(notificador.llamadas, hasLength(1));
    expect(notificador.llamadas.single.titulo, 'Presupuesto al 80%');
    expect(
      notificador.llamadas.single.cuerpo,
      'Total: S/ 850.00 de S/ 1,000.00',
    );

    await servicio.revisar(
      fecha: DateTime(2026, 11, 13),
      categoriaId: catComida,
    );
    expect(notificador.llamadas, hasLength(1));

    final alertas = await db.select(db.alertasEnviadas).get();
    expect(alertas, hasLength(1));
    expect(alertas.single.mes, '2026-11');
    expect(alertas.single.umbral, 80);
  });

  test('revisar al 120% sin alertas previas notifica 80 y 100', () async {
    await presupuestos.guardarTotal(100000);
    await gasto(120000, DateTime(2026, 11, 12));

    await servicio.revisar(
      fecha: DateTime(2026, 11, 12),
      categoriaId: catComida,
    );

    expect(notificador.llamadas, hasLength(2));
    expect(
      notificador.llamadas.map((llamada) => llamada.titulo),
      ['Presupuesto al 80%', 'Presupuesto al 100%'],
    );
  });

  test('alerta del mes siguiente es independiente del mes actual', () async {
    await presupuestos.guardarTotal(100000);
    await gasto(85000, DateTime(2026, 11, 12));

    await servicio.revisar(
      fecha: DateTime(2026, 11, 12),
      categoriaId: catComida,
    );
    expect(notificador.llamadas, hasLength(1));

    await gasto(85000, DateTime(2026, 12, 3));
    await servicio.revisar(
      fecha: DateTime(2026, 12, 3),
      categoriaId: catComida,
    );

    expect(notificador.llamadas, hasLength(2));
    final alertas = await db.select(db.alertasEnviadas).get();
    expect(alertas.map((a) => a.mes), containsAll(['2026-11', '2026-12']));
  });

  test('revisar notifica por presupuesto de categoría y por total por separado',
      () async {
    await presupuestos.guardarTotal(45000);
    await presupuestos.guardarCategoria(catComida, 50000);
    await gasto(45000, DateTime(2026, 11, 12));

    await servicio.revisar(
      fecha: DateTime(2026, 11, 12),
      categoriaId: catComida,
    );

    expect(notificador.llamadas, hasLength(3));
    expect(
      notificador.llamadas.map((llamada) => llamada.cuerpo),
      contains('Comida: S/ 450.00 de S/ 500.00'),
    );

    final alertas = await db.select(db.alertasEnviadas).get();
    expect(alertas, hasLength(3));
    expect(alertas.map((a) => a.presupuestoId).toSet(), hasLength(2));
  });

  test('sin presupuestos no notifica nada', () async {
    await gasto(85000, DateTime(2026, 11, 12));

    await servicio.revisar(
      fecha: DateTime(2026, 11, 12),
      categoriaId: catComida,
    );

    expect(notificador.llamadas, isEmpty);
    expect(await db.select(db.alertasEnviadas).get(), isEmpty);
  });
}
