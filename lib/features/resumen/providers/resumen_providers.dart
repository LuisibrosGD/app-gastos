import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/database/database_provider.dart';
import '../../movimientos/data/modelos.dart';
import '../data/resumen_repository.dart';

part 'resumen_providers.g.dart';

@Riverpod(keepAlive: true)
ResumenRepository resumenRepository(Ref ref) {
  return ResumenRepository(ref.watch(appDatabaseProvider));
}

@riverpod
Stream<List<GastoPorCategoria>> gastosPorCategoria(Ref ref, DateTime mes) {
  return ref.watch(resumenRepositoryProvider).watchGastosPorCategoria(mes);
}

@riverpod
Stream<List<TotalesMes>> ultimosMeses(Ref ref, DateTime mesFinal) {
  return ref.watch(resumenRepositoryProvider).watchUltimosMeses(mesFinal);
}
