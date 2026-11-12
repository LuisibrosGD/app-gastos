import 'package:drift/drift.dart';

import '../../../core/database/enums.dart';

@DataClassName('Categoria')
class Categorias extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text().withLength(min: 1, max: 30)();
  TextColumn get icono => text()();
  IntColumn get color => integer()();
  TextColumn get tipo => textEnum<TipoMovimiento>()();
  BoolColumn get archivada => boolean().withDefault(const Constant(false))();
}
