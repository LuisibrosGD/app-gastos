import 'package:drift/drift.dart';

import '../../categorias/data/categorias_table.dart';

@DataClassName('Presupuesto')
class Presupuestos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get categoriaId => integer()
      .nullable()
      .unique()
      .references(Categorias, #id, onDelete: KeyAction.cascade)();
  IntColumn get montoCentimos =>
      integer().check(CustomExpression('monto_centimos > 0'))();
}
