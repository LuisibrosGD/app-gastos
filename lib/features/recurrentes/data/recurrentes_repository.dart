import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/enums.dart';
import '../../../core/errors.dart';
import '../../../core/utils/fechas.dart';

class RecurrenteInput {
  const RecurrenteInput({
    required this.tipo,
    required this.montoCentimos,
    required this.categoriaId,
    this.nota,
    required this.frecuencia,
    required this.dia,
    required this.fechaInicio,
    this.activo = true,
  });

  final TipoMovimiento tipo;
  final int montoCentimos;
  final int categoriaId;
  final String? nota;
  final Frecuencia frecuencia;
  final int dia;
  final DateTime fechaInicio;
  final bool activo;
}

class RecurrenteConCategoria {
  const RecurrenteConCategoria(this.regla, this.categoria);

  final Recurrente regla;
  final Categoria categoria;
}

class RecurrentesRepository {
  RecurrentesRepository(this._db);

  final AppDatabase _db;

  Stream<List<RecurrenteConCategoria>> watchTodas() {
    final consulta = _db.select(_db.recurrentes).join([
      innerJoin(
        _db.categorias,
        _db.categorias.id.equalsExp(_db.recurrentes.categoriaId),
      ),
    ])
      ..orderBy([
        OrderingTerm.desc(_db.recurrentes.activo),
        OrderingTerm.asc(_db.categorias.nombre),
        OrderingTerm.asc(_db.recurrentes.id),
      ]);

    return consulta.watch().map(
      (filas) => filas
          .map(
            (fila) => RecurrenteConCategoria(
              fila.readTable(_db.recurrentes),
              fila.readTable(_db.categorias),
            ),
          )
          .toList(),
    );
  }

  Future<int> crear(RecurrenteInput input) async {
    await _validar(input);

    return _db
        .into(_db.recurrentes)
        .insert(
          RecurrentesCompanion.insert(
            tipo: input.tipo,
            montoCentimos: input.montoCentimos,
            categoriaId: input.categoriaId,
            nota: Value(_notaLimpia(input.nota)),
            frecuencia: input.frecuencia,
            dia: input.dia,
            fechaInicio: soloFecha(input.fechaInicio),
            activo: input.activo,
          ),
        );
  }

  Future<void> actualizar(int id, RecurrenteInput input) async {
    await _validar(input);

    await (_db.update(
      _db.recurrentes,
    )..where((t) => t.id.equals(id))).write(
      RecurrentesCompanion(
        tipo: Value(input.tipo),
        montoCentimos: Value(input.montoCentimos),
        categoriaId: Value(input.categoriaId),
        nota: Value(_notaLimpia(input.nota)),
        frecuencia: Value(input.frecuencia),
        dia: Value(input.dia),
        fechaInicio: Value(soloFecha(input.fechaInicio)),
        activo: Value(input.activo),
      ),
    );
  }

  Future<void> eliminar(int id) async {
    await (_db.delete(_db.recurrentes)..where((t) => t.id.equals(id))).go();
  }

  Future<void> _validar(RecurrenteInput input) async {
    if (input.montoCentimos <= 0) {
      throw ValidacionException('monto', 'mayorACero');
    }

    final maxDia = input.frecuencia == Frecuencia.mensual ? 31 : 7;
    if (input.dia < 1 || input.dia > maxDia) {
      throw ValidacionException('dia', 'fueraDeRango');
    }

    if ((input.nota ?? '').trim().length > 200) {
      throw ValidacionException('nota', 'muyLargo');
    }

    final categoria =
        await (_db.select(_db.categorias)
              ..where((t) => t.id.equals(input.categoriaId)))
            .getSingleOrNull();
    if (categoria == null) {
      throw ValidacionException('categoria', 'requerido');
    }
    if (categoria.tipo != input.tipo) {
      throw ValidacionException('categoria', 'tipoNoCoincide');
    }
  }

  String? _notaLimpia(String? nota) {
    final limpia = nota?.trim();
    return (limpia == null || limpia.isEmpty) ? null : limpia;
  }
}
