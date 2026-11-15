import 'package:app_gastos/core/database/app_database.dart';
import 'package:app_gastos/core/database/database_provider.dart';
import 'package:app_gastos/core/database/enums.dart';
import 'package:app_gastos/core/l10n/app_localizations.dart';
import 'package:app_gastos/core/theme/app_theme.dart';
import 'package:app_gastos/features/ajustes/providers/preferencias_providers.dart';
import 'package:app_gastos/features/recurrentes/data/recurrentes_repository.dart';
import 'package:app_gastos/features/recurrentes/ui/recurrente_form_screen.dart';
import 'package:app_gastos/features/recurrentes/ui/recurrentes_screen.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late AppDatabase db;
  late SharedPreferences prefs;
  late RecurrentesRepository repo;
  late int catComida;
  late int catSueldo;

  Future<void> preparar() async {
    SharedPreferences.setMockInitialValues({'onboardingCompleto': true});
    prefs = await SharedPreferences.getInstance();
    db = AppDatabase(NativeDatabase.memory());
    repo = RecurrentesRepository(db);
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
            color: 0xFF047857,
            tipo: TipoMovimiento.ingreso,
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

  Widget app(Widget home) {
    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        appDatabaseProvider.overrideWithValue(db),
      ],
      child: MaterialApp(
        theme: construirTemaClaro(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('es'),
        home: home,
      ),
    );
  }

  Widget appConRutas() {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const RecurrentesScreen(),
        ),
        GoRoute(
          path: '/ajustes/recurrentes/nueva',
          builder: (context, state) => const RecurrenteFormScreen(),
        ),
        GoRoute(
          path: '/ajustes/recurrentes/:id',
          builder: (context, state) => RecurrenteFormScreen(
            id: int.tryParse(state.pathParameters['id'] ?? ''),
          ),
        ),
      ],
    );
    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        appDatabaseProvider.overrideWithValue(db),
      ],
      child: MaterialApp.router(
        theme: construirTemaClaro(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('es'),
        routerConfig: router,
      ),
    );
  }

  Future<int> crearRegla({
    TipoMovimiento tipo = TipoMovimiento.gasto,
    int? categoriaId,
    String? nota,
    Frecuencia frecuencia = Frecuencia.mensual,
    int dia = 1,
    int monto = 75000,
    bool activo = true,
  }) {
    return repo.crear(
      RecurrenteInput(
        tipo: tipo,
        montoCentimos: monto,
        categoriaId: categoriaId ?? catComida,
        nota: nota,
        frecuencia: frecuencia,
        dia: dia,
        fechaInicio: DateTime(2026, 1, 1),
        activo: activo,
      ),
    );
  }

  testWidgets('P08 lista reglas con monto, frecuencia y estado', (tester) async {
    configurarPantalla(tester);
    await preparar();
    await crearRegla(nota: 'Alquiler');
    await crearRegla(
      tipo: TipoMovimiento.ingreso,
      categoriaId: catSueldo,
      nota: 'Sueldo',
      dia: 28,
      monto: 250000,
    );
    await crearRegla(
      frecuencia: Frecuencia.semanal,
      dia: 1,
      monto: 3000,
      activo: false,
    );

    await tester.pumpWidget(app(const RecurrentesScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Alquiler'), findsOneWidget);
    expect(find.text('- S/ 750.00'), findsOneWidget);
    expect(find.text('Mensual · día 1'), findsOneWidget);
    expect(find.text('Sueldo'), findsOneWidget);
    expect(find.text('+ S/ 2,500.00'), findsOneWidget);
    expect(find.text('Mensual · día 28'), findsOneWidget);
    expect(find.text('Semanal · lunes'), findsOneWidget);

    final switches = tester.widgetList<Switch>(find.byType(Switch)).toList();
    expect(switches.map((sw) => sw.value), [true, true, false]);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });

  testWidgets('crear una regla mensual día 5 la muestra en la lista',
      (tester) async {
    configurarPantalla(tester);
    await preparar();
    await tester.pumpWidget(appConRutas());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Nueva'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField), '500');
    await tester.tap(find.text('Comida'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButtonFormField<int>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Día 5 del mes').last);
    await tester.pumpAndSettle();

    await tester.drag(find.byType(ListView), const Offset(0, -400));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    expect(find.text('Mensual · día 5'), findsOneWidget);
    expect(find.text('- S/ 500.00'), findsOneWidget);
    expect(await db.select(db.recurrentes).get(), hasLength(1));

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });

  testWidgets('el formulario cambia el selector de día según la frecuencia',
      (tester) async {
    configurarPantalla(tester);
    await preparar();
    await tester.pumpWidget(app(const RecurrenteFormScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Día 1 del mes'), findsOneWidget);
    expect(find.text('lunes'), findsNothing);

    await tester.tap(find.text('Semanal'));
    await tester.pumpAndSettle();

    expect(find.text('Día 1 del mes'), findsNothing);
    expect(find.text('lunes'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });

  testWidgets('desactivar una regla con el switch la marca inactiva',
      (tester) async {
    configurarPantalla(tester);
    await preparar();
    final reglaId = await crearRegla();

    await tester.pumpWidget(app(const RecurrentesScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    final regla = await (db.select(
      db.recurrentes,
    )..where((t) => t.id.equals(reglaId))).getSingle();
    expect(regla.activo, isFalse);
    expect(
      tester.widget<Switch>(find.byType(Switch)).value,
      isFalse,
    );

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });
}
