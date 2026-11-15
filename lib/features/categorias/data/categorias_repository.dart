import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/enums.dart';
import '../../../core/errors.dart';
import '../../../core/theme/colores.dart';
import 'catalogo.dart';

class CategoriasRepository {
  CategoriasRepository(this._db);

  final AppDatabase _db;

  Stream<List<Categoria>> watchPorTipo(
    TipoMovimiento tipo, {
    bool incluirArchivadas = false,
  }) {
    final consulta = _db.select(_db.categorias)
      ..where((t) => t.tipo.equalsValue(tipo));
    if (!incluirArchivadas) {
      consulta.where((t) => t.archivada.equals(false));
    }
    consulta.orderBy([(t) => OrderingTerm(expression: t.nombre)]);
    return consulta.watch();
  }

  Stream<List<Categoria>> watchArchivadas() {
    return (_db.select(_db.categorias)
          ..where((t) => t.archivada.equals(true))
          ..orderBy([(t) => OrderingTerm(expression: t.nombre)]))
        .watch();
  }

  Future<void> restaurar(int id) async {
    await (_db.update(
      _db.categorias,
    )..where((t) => t.id.equals(id))).write(
      const CategoriasCompanion(archivada: Value(false)),
    );
  }

  Future<Categoria?> obtener(int id) {
    return (_db.select(
      _db.categorias,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<int> crear({
    required String nombre,
    required String icono,
    required int color,
    required TipoMovimiento tipo,
  }) async {
    return _db
        .into(_db.categorias)
        .insert(
          CategoriasCompanion.insert(
            nombre: _validarNombre(nombre),
            icono: icono,
            color: color,
            tipo: tipo,
          ),
        );
  }

  Future<void> actualizar(
    int id, {
    required String nombre,
    required String icono,
    required int color,
  }) async {
    await (_db.update(
      _db.categorias,
    )..where((t) => t.id.equals(id))).write(
      CategoriasCompanion(
        nombre: Value(_validarNombre(nombre)),
        icono: Value(icono),
        color: Value(color),
      ),
    );
  }

  Future<ResultadoEliminar> eliminarOArchivar(int id) {
    return _db.transaction(() async {
      final movimientos =
          await (_db.select(_db.movimientos)
                ..where((t) => t.categoriaId.equals(id))
                ..limit(1))
              .get();
      final recurrentes =
          await (_db.select(_db.recurrentes)
                ..where((t) => t.categoriaId.equals(id))
                ..limit(1))
              .get();

      if (movimientos.isEmpty && recurrentes.isEmpty) {
        await (_db.delete(
          _db.categorias,
        )..where((t) => t.id.equals(id))).go();
        return ResultadoEliminar.eliminada;
      }

      await (_db.update(
        _db.categorias,
      )..where((t) => t.id.equals(id))).write(
        const CategoriasCompanion(archivada: Value(true)),
      );
      return ResultadoEliminar.archivada;
    });
  }

  Future<bool> hayCategorias() async {
    final fila = await (_db.select(_db.categorias)..limit(1)).getSingleOrNull();
    return fila != null;
  }

  Future<void> crearPorDefecto({
    required List<String> gastos,
    required List<String> ingresos,
  }) async {
    if (await hayCategorias()) return;

    await _db.transaction(() async {
      var indice = 0;
      for (final nombre in gastos) {
        await _insertarPorDefecto(nombre, TipoMovimiento.gasto, indice);
        indice++;
      }
      for (final nombre in ingresos) {
        await _insertarPorDefecto(nombre, TipoMovimiento.ingreso, indice);
        indice++;
      }
    });
  }

  Future<void> _insertarPorDefecto(
    String nombre,
    TipoMovimiento tipo,
    int indice,
  ) {
    return _db
        .into(_db.categorias)
        .insert(
          CategoriasCompanion.insert(
            nombre: nombre,
            icono: claveIcono(nombre),
            color: AppColores.categorias[indice % AppColores.categorias.length]
                .toARGB32(),
            tipo: tipo,
          ),
        );
  }

  String _validarNombre(String nombre) {
    final limpio = nombre.trim();
    if (limpio.isEmpty) {
      throw ValidacionException('nombre', 'requerido');
    }
    if (limpio.length > 30) {
      throw ValidacionException('nombre', 'muyLargo');
    }
    return limpio;
  }
}
