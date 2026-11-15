import 'package:app_gastos/core/database/app_database.dart';
import 'package:app_gastos/core/database/database_provider.dart';
import 'package:app_gastos/core/database/enums.dart';
import 'package:app_gastos/core/l10n/app_localizations.dart';
import 'package:app_gastos/core/theme/app_theme.dart';
import 'package:app_gastos/core/utils/fechas.dart';
import 'package:app_gastos/features/ajustes/providers/preferencias_providers.dart';
import 'package:app_gastos/features/movimientos/ui/movimientos_screen.dart';
import 'package:app_gastos/features/movimientos/ui/widgets/selector_mes.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late AppDatabase db;
  late SharedPreferences prefs;
  late int catComida;
  late int catSueldo;

  Future<void> preparar() async {
    SharedPreferences.setMockInitialValues({});
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
    catSueldo = await db
        .into(db.categorias)
        .insert(
          CategoriasCompanion.insert(
            nombre: 'Sueldo',
            icono: 'sueldo',
            color: 0xFFA21CAF,
            tipo: TipoMovimiento.ingreso,
          ),
        );
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
          home: const MovimientosScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> cerrar(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  }

  Future<int> insertar({
    required String? nota,
    required int monto,
    required DateTime fecha,
    required TipoMovimiento tipo,
    required int categoriaId,
  }) {
    return db
        .into(db.movimientos)
        .insert(
          MovimientosCompanion.insert(
            tipo: tipo,
            montoCentimos: monto,
            fecha: fecha,
            categoriaId: categoriaId,
            nota: Value(nota),
            creadoEn: DateTime(2026, 11, 12, 10),
          ),
        );
  }

  tearDown(() async {
    await db.close();
  });

  testWidgets('muestra los movimientos del mes agrupados por día', (
    tester,
  ) async {
    await preparar();
    final hoy = soloFecha(DateTime.now());
    final ayer = hoy.subtract(const Duration(days: 1));
    await insertar(
      nota: 'Almuerzo',
      monto: 2450,
      fecha: hoy,
      tipo: TipoMovimiento.gasto,
      categoriaId: catComida,
    );
    await insertar(
      nota: 'Sueldo',
      monto: 250000,
      fecha: ayer,
      tipo: TipoMovimiento.ingreso,
      categoriaId: catSueldo,
    );

    await abrir(tester);

    expect(
      find.text('Hoy · ${formatFecha(hoy, 'es')}'),
      findsOneWidget,
    );
    expect(
      find.text('Ayer · ${formatFecha(ayer, 'es')}'),
      findsOneWidget,
    );
    expect(find.text('Almuerzo'), findsOneWidget);
    expect(find.text('- S/ 24.50'), findsOneWidget);
    expect(find.text('+ S/ 2,500.00'), findsOneWidget);
    await cerrar(tester);
  });

  testWidgets('muestra el estado vacío sin movimientos', (tester) async {
    await preparar();
    await abrir(tester);

    expect(find.textContaining('Sin movimientos en'), findsOneWidget);
    expect(find.text('Registrar el primero'), findsOneWidget);
    await cerrar(tester);
  });

  testWidgets('el filtro de categoría abre el selector en el primer arranque', (
    tester,
  ) async {
    await preparar();
    await abrir(tester);

    await tester.tap(find.text('Categoría: Todas'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Categoría'), findsOneWidget);
    expect(find.text('Todas'), findsOneWidget);
    expect(find.text('Comida'), findsOneWidget);
    expect(find.text('Sueldo'), findsOneWidget);
    await cerrar(tester);
  });

  testWidgets('elegir una categoría filtra la lista y «Todas» lo quita', (
    tester,
  ) async {
    await preparar();
    final hoy = soloFecha(DateTime.now());
    await insertar(
      nota: 'Almuerzo',
      monto: 2450,
      fecha: hoy,
      tipo: TipoMovimiento.gasto,
      categoriaId: catComida,
    );
    await insertar(
      nota: 'Pago',
      monto: 250000,
      fecha: hoy,
      tipo: TipoMovimiento.ingreso,
      categoriaId: catSueldo,
    );

    await abrir(tester);
    expect(find.text('Almuerzo'), findsOneWidget);
    expect(find.text('Pago'), findsOneWidget);

    await tester.tap(find.text('Categoría: Todas'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(SimpleDialogOption, 'Comida'));
    await tester.pumpAndSettle();

    expect(find.text('Almuerzo'), findsOneWidget);
    expect(find.text('Pago'), findsNothing);
    expect(find.text('Categoría: Comida'), findsOneWidget);

    await tester.tap(find.text('Categoría: Comida'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(SimpleDialogOption, 'Todas'));
    await tester.pumpAndSettle();

    expect(find.text('Almuerzo'), findsOneWidget);
    expect(find.text('Pago'), findsOneWidget);
    await cerrar(tester);
  });

  testWidgets('cambiar de mes con SelectorMes actualiza la lista', (
    tester,
  ) async {
    await preparar();
    await insertar(
      nota: 'Cena',
      monto: 1000,
      fecha: DateTime(DateTime.now().year, 12, 5),
      tipo: TipoMovimiento.gasto,
      categoriaId: catComida,
    );

    await abrir(tester);
    expect(find.text('Cena'), findsNothing);

    await tester.tap(find.byType(SelectorMes));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Diciembre'));
    await tester.pumpAndSettle();

    expect(find.text('Cena'), findsOneWidget);
    await cerrar(tester);
  });
}
