import 'package:app_gastos/core/database/app_database.dart';
import 'package:app_gastos/core/l10n/app_localizations.dart';
import 'package:app_gastos/core/lifecycle/ciclo_vida.dart';
import 'package:app_gastos/features/ajustes/providers/preferencias_providers.dart';
import 'package:app_gastos/features/movimientos/data/movimientos_repository.dart';
import 'package:app_gastos/features/presupuesto/data/alertas_service.dart';
import 'package:app_gastos/features/presupuesto/data/notificador.dart';
import 'package:app_gastos/features/presupuesto/data/presupuestos_repository.dart';
import 'package:app_gastos/features/recurrentes/data/generador_recurrentes.dart';
import 'package:app_gastos/features/recurrentes/providers/recurrentes_providers.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificadorFalso implements Notificador {
  @override
  Future<void> mostrar({
    required String titulo,
    required String cuerpo,
  }) async {}
}

class GeneradorFalso extends GeneradorRecurrentes {
  GeneradorFalso(AppDatabase db)
    : super(
        db: db,
        movimientos: MovimientosRepository(db),
        alertas: AlertasService(
          db: db,
          presupuestos: PresupuestosRepository(db),
          notificador: NotificadorFalso(),
          textos: () => lookupAppLocalizations(const Locale('es')),
        ),
      );

  final llamadas = <DateTime>[];

  @override
  Future<int> generarPendientes(DateTime hoy) async {
    llamadas.add(hoy);
    return 0;
  }
}

void main() {
  testWidgets('CicloDeVida genera al montarse y al recibir resumed',
      (tester) async {
    SharedPreferences.setMockInitialValues({'onboardingCompleto': true});
    final prefs = await SharedPreferences.getInstance();
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final generador = GeneradorFalso(db);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          generadorRecurrentesProvider.overrideWithValue(generador),
        ],
        child: const MaterialApp(
          home: CicloDeVida(child: SizedBox.shrink()),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(generador.llamadas, hasLength(1));

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pump();
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();

    expect(generador.llamadas, hasLength(2));

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });
}
