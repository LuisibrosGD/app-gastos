import 'package:app_gastos/core/database/app_database.dart';
import 'package:app_gastos/core/database/database_provider.dart';
import 'package:app_gastos/core/database/enums.dart';
import 'package:app_gastos/core/l10n/app_localizations.dart';
import 'package:app_gastos/core/theme/app_theme.dart';
import 'package:app_gastos/features/ajustes/providers/preferencias_providers.dart';
import 'package:app_gastos/features/resumen/ui/resumen_screen.dart';
import 'package:drift/native.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late AppDatabase db;
  late SharedPreferences prefs;
  late int catComida;
  late int catTransporte;

  Future<void> preparar() async {
    SharedPreferences.setMockInitialValues({'onboardingCompleto': true});
    prefs = await SharedPreferences.getInstance();
    db = AppDatabase(NativeDatabase.memory());
    catComida = await db
        .into(db.categorias)
        .insert(
          CategoriasCompanion.insert(
            nombre: 'Comida',
            icono: 'comida',
            color: 0xFFC2410C,
            tipo: TipoMovimiento.gasto,
          ),
        );
    catTransporte = await db
        .into(db.categorias)
        .insert(
          CategoriasCompanion.insert(
            nombre: 'Transporte',
            icono: 'transporte',
            color: 0xFF0E7490,
            tipo: TipoMovimiento.gasto,
          ),
        );
  }

  tearDown(() async {
    await db.close();
  });

  void configurarPantalla(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Future<void> abrir(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          appDatabaseProvider.overrideWithValue(db),
        ],
        child: MaterialApp(
          theme: construirTemaClaro(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('es'),
          home: const ResumenScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> cerrar(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  }

  Future<void> gasto(int monto, DateTime fecha, int categoriaId) {
    return db
        .into(db.movimientos)
        .insert(
          MovimientosCompanion.insert(
            tipo: TipoMovimiento.gasto,
            montoCentimos: monto,
            fecha: fecha,
            categoriaId: categoriaId,
            creadoEn: DateTime(2026, 1, 1),
          ),
        );
  }

  testWidgets('con datos muestra la leyenda, los montos y ambos gráficos',
      (tester) async {
    configurarPantalla(tester);
    await preparar();
    final hoy = DateTime.now();
    await gasto(30000, DateTime(hoy.year, hoy.month, 2), catComida);
    await gasto(20000, DateTime(hoy.year, hoy.month, 3), catTransporte);
    await db
        .into(db.movimientos)
        .insert(
          MovimientosCompanion.insert(
            tipo: TipoMovimiento.ingreso,
            montoCentimos: 100000,
            fecha: DateTime(hoy.year, hoy.month, 1),
            categoriaId: catComida,
            creadoEn: DateTime(2026, 1, 1),
          ),
        );

    await abrir(tester);

    expect(find.byType(PieChart), findsOneWidget);
    expect(find.byType(BarChart), findsOneWidget);
    expect(find.text('Comida'), findsOneWidget);
    expect(find.text('Transporte'), findsOneWidget);
    expect(find.text('60 %'), findsOneWidget);
    expect(find.text('40 %'), findsOneWidget);
    expect(find.text('S/ 500.00'), findsOneWidget);
    expect(find.text('Ingresos vs. gastos'), findsOneWidget);

    await cerrar(tester);
  });

  testWidgets('sin datos muestra el estado vacío', (tester) async {
    configurarPantalla(tester);
    await preparar();

    await abrir(tester);

    final nombre = DateFormat('MMMM', 'es').format(DateTime.now());
    expect(find.text('Sin datos en $nombre'), findsOneWidget);
    expect(find.text('Ingresos vs. gastos'), findsNothing);
    expect(find.byType(PieChart), findsNothing);
    expect(find.byType(BarChart), findsNothing);

    await cerrar(tester);
  });
}
