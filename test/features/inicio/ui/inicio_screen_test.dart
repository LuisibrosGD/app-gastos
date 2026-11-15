import 'package:app_gastos/core/database/app_database.dart';
import 'package:app_gastos/core/database/database_provider.dart';
import 'package:app_gastos/core/database/enums.dart';
import 'package:app_gastos/core/l10n/app_localizations.dart';
import 'package:app_gastos/core/theme/app_theme.dart';
import 'package:app_gastos/features/ajustes/providers/preferencias_providers.dart';
import 'package:app_gastos/features/inicio/ui/inicio_screen.dart';
import 'package:app_gastos/features/presupuesto/data/presupuestos_repository.dart';
import 'package:app_gastos/features/presupuesto/ui/widgets/banner_alerta.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late AppDatabase db;
  late SharedPreferences prefs;

  Future<void> preparar() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    db = AppDatabase(NativeDatabase.memory());
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
          home: const InicioScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> cerrar(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  }

  tearDown(() async {
    await db.close();
  });

  testWidgets('muestra balance S/ 649.50 con ingresos 100000 y gastos 35050', (
    tester,
  ) async {
    await preparar();
    final catComida = await db
        .into(db.categorias)
        .insert(
          CategoriasCompanion.insert(
            nombre: 'Comida',
            icono: 'comida',
            color: 0xFFC2410C,
            tipo: TipoMovimiento.gasto,
          ),
        );
    final catSueldo = await db
        .into(db.categorias)
        .insert(
          CategoriasCompanion.insert(
            nombre: 'Sueldo',
            icono: 'sueldo',
            color: 0xFFA21CAF,
            tipo: TipoMovimiento.ingreso,
          ),
        );
    await db
        .into(db.movimientos)
        .insert(
          MovimientosCompanion.insert(
            tipo: TipoMovimiento.ingreso,
            montoCentimos: 100000,
            fecha: DateTime.now(),
            categoriaId: catSueldo,
            nota: const Value('Sueldo'),
            creadoEn: DateTime.now(),
          ),
        );
    await db
        .into(db.movimientos)
        .insert(
          MovimientosCompanion.insert(
            tipo: TipoMovimiento.gasto,
            montoCentimos: 35050,
            fecha: DateTime.now(),
            categoriaId: catComida,
            nota: const Value('Compras'),
            creadoEn: DateTime.now(),
          ),
        );

    await abrir(tester);

    expect(find.text('S/ 649.50'), findsOneWidget);
    expect(find.text('Ingresos S/ 1,000.00'), findsOneWidget);
    expect(find.text('Gastos S/ 350.50'), findsOneWidget);
    expect(find.text('Últimos movimientos'), findsOneWidget);
    expect(find.text('Ver todos'), findsOneWidget);
    await cerrar(tester);
  });

  testWidgets('con total 100000 y gastos 85000 muestra barra al 85% y banner',
      (tester) async {
    await preparar();
    final catComida = await db
        .into(db.categorias)
        .insert(
          CategoriasCompanion.insert(
            nombre: 'Comida',
            icono: 'comida',
            color: 0xFFC2410C,
            tipo: TipoMovimiento.gasto,
          ),
        );
    await PresupuestosRepository(db).guardarTotal(100000);
    await db
        .into(db.movimientos)
        .insert(
          MovimientosCompanion.insert(
            tipo: TipoMovimiento.gasto,
            montoCentimos: 85000,
            fecha: DateTime.now(),
            categoriaId: catComida,
            nota: const Value('Compras'),
            creadoEn: DateTime.now(),
          ),
        );

    await abrir(tester);

    expect(find.text('Presupuesto total'), findsOneWidget);
    expect(find.text('85 %'), findsOneWidget);
    expect(find.byType(BannerAlerta), findsOneWidget);
    expect(find.text('Presupuesto al 85 %'), findsOneWidget);
    expect(
      find.text('Llevas S/ 850.00 de S/ 1,000.00 este mes.'),
      findsOneWidget,
    );
    await cerrar(tester);
  });

  testWidgets(
      'solo con presupuesto de Comida al 85 % muestra el banner con el nombre '
      'y sin barra', (tester) async {
    await preparar();
    final catComida = await db
        .into(db.categorias)
        .insert(
          CategoriasCompanion.insert(
            nombre: 'Comida',
            icono: 'comida',
            color: 0xFFC2410C,
            tipo: TipoMovimiento.gasto,
          ),
        );
    await PresupuestosRepository(db).guardarCategoria(catComida, 100000);
    await db
        .into(db.movimientos)
        .insert(
          MovimientosCompanion.insert(
            tipo: TipoMovimiento.gasto,
            montoCentimos: 85000,
            fecha: DateTime.now(),
            categoriaId: catComida,
            nota: const Value('Compras'),
            creadoEn: DateTime.now(),
          ),
        );

    await abrir(tester);

    expect(find.byType(BannerAlerta), findsOneWidget);
    expect(find.text('Comida al 85 %'), findsOneWidget);
    expect(find.text('Presupuesto total'), findsNothing);
    await cerrar(tester);
  });

  testWidgets('sin presupuesto no muestra ni barra ni banner', (tester) async {
    await preparar();
    await abrir(tester);

    expect(find.text('Presupuesto total'), findsNothing);
    expect(find.byType(BannerAlerta), findsNothing);
    await cerrar(tester);
  });

  testWidgets('sin movimientos muestra el estado vacío', (tester) async {
    await preparar();
    await abrir(tester);

    expect(find.text('S/ 0.00'), findsOneWidget);
    expect(find.text('Aún no hay movimientos'), findsOneWidget);
    expect(find.text('Registrar el primero'), findsOneWidget);
    await cerrar(tester);
  });
}
