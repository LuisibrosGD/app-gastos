import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/database/database_provider.dart';
import '../data/modelos.dart';
import '../data/movimientos_repository.dart';

part 'movimientos_providers.g.dart';

@Riverpod(keepAlive: true)
MovimientosRepository movimientosRepository(Ref ref) {
  return MovimientosRepository(ref.watch(appDatabaseProvider));
}

@riverpod
Stream<List<MovimientoConCategoria>> movimientosMes(
  Ref ref,
  FiltroMovimientos filtro,
) {
  return ref.watch(movimientosRepositoryProvider).watchMes(filtro);
}

@riverpod
Stream<List<MovimientoConCategoria>> movimientosRecientes(Ref ref) {
  return ref.watch(movimientosRepositoryProvider).watchRecientes();
}

@riverpod
Stream<TotalesMes> totalesMes(Ref ref, DateTime mes) {
  return ref.watch(movimientosRepositoryProvider).watchTotalesMes(mes);
}

@riverpod
class MovimientosController extends _$MovimientosController {
  @override
  FutureOr<void> build() {}

  Future<int> guardar({int? id, required MovimientoInput input}) async {
    final repositorio = ref.read(movimientosRepositoryProvider);
    if (id == null) {
      return repositorio.crear(input);
    }
    await repositorio.actualizar(id, input);
    return id;
  }

  Future<void> eliminar(int id) {
    return ref.read(movimientosRepositoryProvider).eliminar(id);
  }
}
