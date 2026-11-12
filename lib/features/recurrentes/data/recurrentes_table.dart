import 'package:drift/drift.dart';

import '../../../core/database/enums.dart';
import '../../categorias/data/categorias_table.dart';

@DataClassName('Recurrente')
class Recurrentes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get tipo => textEnum<TipoMovimiento>()();
  IntColumn get montoCentimos =>
      integer().check(CustomExpression('monto_centimos > 0'))();
  IntColumn get categoriaId => integer().references(Categorias, #id)();
  TextColumn get nota => text().withLength(max: 200).nullable()();
  TextColumn get frecuencia => textEnum<Frecuencia>()();
  IntColumn get dia => integer()();
  DateTimeColumn get fechaInicio => dateTime()();
  DateTimeColumn get ultimaGeneracion => dateTime().nullable()();
  BoolColumn get activo => boolean()();
}
