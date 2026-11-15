import 'package:app_gastos/core/database/app_database.dart';
import 'package:app_gastos/core/database/database_provider.dart';
import 'package:app_gastos/core/database/enums.dart';
import 'package:app_gastos/core/l10n/app_localizations.dart';
import 'package:app_gastos/core/theme/app_theme.dart';
import 'package:app_gastos/features/ajustes/providers/preferencias_providers.dart';
import 'package:app_gastos/features/presupuesto/data/notificador.dart';
import 'package:app_gastos/features/presupuesto/data/presupuestos_repository.dart';
import 'package:app_gastos/features/presupuesto/providers/presupuesto_providers.dart';
import 'package:app_gastos/features/presupuesto/ui/presupuesto_screen.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificadorFalso extends NotificadorLocal {
  NotificadorFalso()
    : super(textos: () => lookupAppLocalizations(const Locale('es')));

  bool permisoPedido = false;

  @override
  Future<bool> pedirPermiso() async {
    permisoPedido = true;
    return false;
  }

  @override
  Future<void> mostrar({
    required String titulo,
    required String cuerpo,
  }) async {}
}

void main() {
  late AppDatabase db;
  late SharedPreferences prefs;
  late NotificadorFalso notificador;
  late int catComida;

  Future<void> preparar() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    db = AppDatabase(NativeDatabase.memory());
    notificador = NotificadorFalso();
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
  }

  Future<void> abrir(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          appDatabaseProvider.overrideWithValue(db),
          notificadorProvider.overrideWithValue(notificador),
        ],
        child: MaterialApp(
          theme: construirTemaClaro(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('es'),
          home: const PresupuestoScreen(),
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

  testWidgets('guardar total S/ 1000 crea el presupuesto y muestra su progreso',
      (tester) async {
    await preparar();
    await abrir(tester);

    expect(find.text('Sin definir'), findsOneWidget);

    await tester.tap(find.text('Editar'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), '1000');
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    final filas = await db.select(db.presupuestos).get();
    expect(filas, hasLength(1));
    expect(filas.single.categoriaId, isNull);
    expect(filas.single.montoCentimos, 100000);

    expect(find.text('S/ 1,000.00'), findsOneWidget);
    expect(find.text('Gastado este mes'), findsOneWidget);
    expect(find.text('0 %'), findsOneWidget);
    expect(find.text('S/ 0.00 de S/ 1,000.00'), findsOneWidget);
    expect(notificador.permisoPedido, isTrue);
    await cerrar(tester);
  });

  testWidgets('borrar el monto de una categoría elimina su presupuesto',
      (tester) async {
    await preparar();
    await PresupuestosRepository(db).guardarCategoria(catComida, 40000);
    await abrir(tester);

    expect(find.text('Comida'), findsOneWidget);
    expect(find.text('S/ 0.00 de S/ 400.00'), findsOneWidget);

    await tester.tap(find.text('Comida'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), '');
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    expect(await db.select(db.presupuestos).get(), isEmpty);
    expect(find.text('Comida'), findsNothing);
    expect(notificador.permisoPedido, isFalse);
    await cerrar(tester);
  });
}
