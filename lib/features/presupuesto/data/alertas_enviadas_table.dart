import 'package:drift/drift.dart';

import 'presupuestos_table.dart';

@DataClassName('AlertaEnviada')
class AlertasEnviadas extends Table {
  IntColumn get presupuestoId =>
      integer().references(Presupuestos, #id, onDelete: KeyAction.cascade)();
  TextColumn get mes => text()();
  IntColumn get umbral => integer()();

  @override
  Set<Column> get primaryKey => {presupuestoId, mes, umbral};
}
