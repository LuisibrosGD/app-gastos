import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/enums.dart';
import '../../../core/utils/fechas.dart';
import '../../movimientos/data/modelos.dart';
import '../../movimientos/data/movimientos_repository.dart';
import '../../presupuesto/data/alertas_service.dart';
import '../domain/ocurrencias.dart';

class GeneradorRecurrentes {
  GeneradorRecurrentes({
    required this.db,
    required this.movimientos,
    required this.alertas,
  });

  final AppDatabase db;
  final MovimientosRepository movimientos;
  final AlertasService alertas;

  /// Crea un movimiento por cada ocurrencia pendiente de las reglas activas y
  /// adelanta `ultimaGeneracion` a [hoy]. Devuelve cuántos movimientos creó.
  Future<int> generarPendientes(DateTime hoy) async {
    final candidatas = await (db.select(
      db.recurrentes,
    )..where((t) => t.activo.equals(true))).get();

    final gastosCreados = <({DateTime fecha, int categoriaId})>[];
    var creados = 0;

    for (final candidata in candidatas) {
      await db.transaction(() async {
        final regla =
            await (db.select(db.recurrentes)
                  ..where((t) => t.id.equals(candidata.id)))
                .getSingleOrNull();
        if (regla == null || !regla.activo) return;

        final fechas = ocurrenciasPendientes(
          frecuencia: regla.frecuencia,
          dia: regla.dia,
          fechaInicio: regla.fechaInicio,
          ultimaGeneracion: regla.ultimaGeneracion,
          hoy: hoy,
        );
        if (fechas.isEmpty) return;

        var nuevos = 0;
        final gastos = <({DateTime fecha, int categoriaId})>[];

        for (final fecha in fechas) {
          await movimientos.crear(
            MovimientoInput(
              tipo: regla.tipo,
              montoCentimos: regla.montoCentimos,
              fecha: fecha,
              categoriaId: regla.categoriaId,
              nota: regla.nota,
              recurrenteId: regla.id,
            ),
          );
          nuevos++;
          if (regla.tipo == TipoMovimiento.gasto) {
            gastos.add((fecha: fecha, categoriaId: regla.categoriaId));
          }
        }

        await (db.update(
          db.recurrentes,
        )..where((t) => t.id.equals(regla.id))).write(
          RecurrentesCompanion(
            ultimaGeneracion: Value(soloFecha(hoy)),
          ),
        );

        creados += nuevos;
        gastosCreados.addAll(gastos);
      });
    }

    for (final gasto in gastosCreados) {
      try {
        await alertas.revisar(
          fecha: gasto.fecha,
          categoriaId: gasto.categoriaId,
        );
      } catch (_) {}
    }

    return creados;
  }
}
