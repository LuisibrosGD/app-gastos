import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/utils/fechas.dart';
import '../../../core/utils/moneda.dart';
import '../domain/progreso.dart';
import 'notificador.dart';
import 'presupuestos_repository.dart';

class AlertasService {
  AlertasService({
    required this.db,
    required this.presupuestos,
    required this.notificador,
    required this.textos,
  });

  final AppDatabase db;
  final PresupuestosRepository presupuestos;
  final Notificador notificador;
  final AppLocalizations Function() textos;

  /// Revisa el presupuesto total y el de `categoriaId` para el mes de `fecha`.
  Future<void> revisar({
    required DateTime fecha,
    required int categoriaId,
  }) async {
    final mes = inicioMes(fecha);
    final clave = claveMes(mes);
    final progresos = await presupuestos.progresoPara(mes, categoriaId);

    for (final progreso in progresos) {
      final presupuesto = progreso.presupuesto;
      final alcanzados = umbralesAlcanzados(
        progreso.gastado,
        presupuesto.montoCentimos,
      );

      for (final umbral in alcanzados) {
        if (await _yaEnviada(presupuesto.id, clave, umbral)) continue;

        final l10n = textos();
        await notificador.mostrar(
          titulo: l10n.alertaPresupuestoTitulo(umbral),
          cuerpo: l10n.alertaPresupuestoCuerpo(
            progreso.categoria?.nombre ?? l10n.alertaPresupuestoTotal,
            formatSoles(progreso.gastado),
            formatSoles(presupuesto.montoCentimos),
          ),
        );

        await db
            .into(db.alertasEnviadas)
            .insert(
              AlertasEnviadasCompanion.insert(
                presupuestoId: presupuesto.id,
                mes: clave,
                umbral: umbral,
              ),
            );
      }
    }
  }

  Future<bool> _yaEnviada(int presupuestoId, String mes, int umbral) async {
    final fila =
        await (db.select(db.alertasEnviadas)..where(
              (t) =>
                  t.presupuestoId.equals(presupuestoId) &
                  t.mes.equals(mes) &
                  t.umbral.equals(umbral),
            ))
            .getSingleOrNull();
    return fila != null;
  }
}
