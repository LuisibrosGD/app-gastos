import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/database/database_provider.dart';
import '../../movimientos/providers/movimientos_providers.dart';
import '../../presupuesto/providers/presupuesto_providers.dart';
import '../data/generador_recurrentes.dart';
import '../data/recurrentes_repository.dart';

part 'recurrentes_providers.g.dart';

@Riverpod(keepAlive: true)
RecurrentesRepository recurrentesRepository(Ref ref) {
  return RecurrentesRepository(ref.watch(appDatabaseProvider));
}

@Riverpod(keepAlive: true)
GeneradorRecurrentes generadorRecurrentes(Ref ref) {
  return GeneradorRecurrentes(
    db: ref.watch(appDatabaseProvider),
    movimientos: ref.watch(movimientosRepositoryProvider),
    alertas: ref.watch(alertasServiceProvider),
  );
}

@riverpod
Stream<List<RecurrenteConCategoria>> recurrentes(Ref ref) {
  return ref.watch(recurrentesRepositoryProvider).watchTodas();
}
