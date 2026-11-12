import 'package:drift/drift.dart';

import '../../../core/database/enums.dart';
import '../../categorias/data/categorias_table.dart';
import '../../recurrentes/data/recurrentes_table.dart';

@DataClassName('Movimiento')
class Movimientos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get tipo => textEnum<TipoMovimiento>()();
  IntColumn get montoCentimos =>
      integer().check(CustomExpression('monto_centimos > 0'))();
  DateTimeColumn get fecha => dateTime()();
  IntColumn get categoriaId => integer().references(Categorias, #id)();
  TextColumn get nota => text().withLength(max: 200).nullable()();
  IntColumn get recurrenteId => integer()
      .nullable()
      .references(Recurrentes, #id, onDelete: KeyAction.setNull)();
  DateTimeColumn get creadoEn => dateTime()();
}
