import 'package:drift/drift.dart';

import '../../features/categorias/data/categorias_table.dart';
import '../../features/movimientos/data/movimientos_table.dart';
import '../../features/presupuesto/data/alertas_enviadas_table.dart';
import '../../features/presupuesto/data/presupuestos_table.dart';
import '../../features/recurrentes/data/recurrentes_table.dart';
import 'enums.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Categorias, Movimientos, Presupuestos, Recurrentes, AlertasEnviadas],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
      await customStatement(
        'CREATE INDEX IF NOT EXISTS movimientos_fecha '
        'ON movimientos (fecha)',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS movimientos_categoria_id '
        'ON movimientos (categoria_id)',
      );
      await customStatement(
        'CREATE UNIQUE INDEX IF NOT EXISTS presupuesto_total_unico '
        'ON presupuestos ((categoria_id IS NULL)) '
        'WHERE categoria_id IS NULL',
      );
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
