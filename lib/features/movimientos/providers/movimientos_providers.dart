import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/database/database_provider.dart';
import '../../../core/database/enums.dart';
import '../../presupuesto/providers/presupuesto_providers.dart';
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
Future<MovimientoConCategoria?> movimiento(Ref ref, int id) {
  return ref.watch(movimientosRepositoryProvider).obtener(id);
}

@riverpod
Stream<TotalesMes> totalesMes(Ref ref, DateTime mes) {
  return ref.watch(movimientosRepositoryProvider).watchTotalesMes(mes);
}

@Riverpod(keepAlive: true)
class MovimientosController extends _$MovimientosController {
  @override
  FutureOr<void> build() {}

  Future<int> guardar({int? id, required MovimientoInput input}) async {
    final repositorio = ref.read(movimientosRepositoryProvider);
    final int guardadoId;
    if (id == null) {
      guardadoId = await repositorio.crear(input);
    } else {
      await repositorio.actualizar(id, input);
      guardadoId = id;
    }

    if (input.tipo == TipoMovimiento.gasto) {
      try {
        await ref
            .read(alertasServiceProvider)
            .revisar(fecha: input.fecha, categoriaId: input.categoriaId);
      } catch (error, pila) {
        FlutterError.reportError(
          FlutterErrorDetails(
            exception: error,
            stack: pila,
            library: 'alertas',
          ),
        );
      }
    }

    return guardadoId;
  }

  Future<void> eliminar(int id) {
    return ref.read(movimientosRepositoryProvider).eliminar(id);
  }
}
