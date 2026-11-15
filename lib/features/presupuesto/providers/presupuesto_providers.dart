import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/database/database_provider.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../ajustes/providers/preferencias_providers.dart';
import '../data/alertas_service.dart';
import '../data/notificador.dart';
import '../data/presupuestos_repository.dart';
import '../domain/progreso.dart';

part 'presupuesto_providers.g.dart';

AppLocalizations _textos(Ref ref) =>
    lookupAppLocalizations(ref.read(idiomaActualProvider));

@Riverpod(keepAlive: true)
PresupuestosRepository presupuestosRepository(Ref ref) {
  return PresupuestosRepository(ref.watch(appDatabaseProvider));
}

@Riverpod(keepAlive: true)
Notificador notificador(Ref ref) {
  return NotificadorLocal(textos: () => _textos(ref));
}

@Riverpod(keepAlive: true)
AlertasService alertasService(Ref ref) {
  return AlertasService(
    db: ref.watch(appDatabaseProvider),
    presupuestos: ref.watch(presupuestosRepositoryProvider),
    notificador: ref.watch(notificadorProvider),
    textos: () => _textos(ref),
  );
}

@riverpod
Stream<List<ProgresoPresupuesto>> progresoPresupuesto(Ref ref, DateTime mes) {
  return ref.watch(presupuestosRepositoryProvider).watchProgreso(mes);
}
