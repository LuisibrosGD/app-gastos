import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/database/enums.dart';
import '../data/categorias_repository.dart';

part 'categorias_providers.g.dart';

@Riverpod(keepAlive: true)
CategoriasRepository categoriasRepository(Ref ref) {
  return CategoriasRepository(ref.watch(appDatabaseProvider));
}

/// `StreamProvider.family` a mano: `riverpod_generator` 4.0.10 no resuelve
/// tipos generados por Drift (`Categoria`) en el tipo de retorno de una
/// función anotada con `@riverpod`.
final categoriasPorTipoProvider =
    StreamProvider.family<List<Categoria>, TipoMovimiento>((ref, tipo) {
      return ref.watch(categoriasRepositoryProvider).watchPorTipo(tipo);
    });
