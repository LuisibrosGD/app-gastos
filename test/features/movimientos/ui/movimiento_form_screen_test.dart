import 'package:app_gastos/core/database/app_database.dart';
import 'package:app_gastos/core/database/database_provider.dart';
import 'package:app_gastos/core/database/enums.dart';
import 'package:app_gastos/core/l10n/app_localizations.dart';
import 'package:app_gastos/core/theme/app_theme.dart';
import 'package:app_gastos/features/ajustes/providers/preferencias_providers.dart';
import 'package:app_gastos/features/movimientos/ui/movimiento_form_screen.dart';
import 'package:app_gastos/features/presupuesto/data/notificador.dart';
import 'package:app_gastos/features/presupuesto/data/presupuestos_repository.dart';
import 'package:app_gastos/features/presupuesto/providers/presupuesto_providers.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificadorFalso implements Notificador {
  final llamadas = <({String titulo, String cuerpo})>[];

  @override
  Future<void> mostrar({
    required String titulo,
    required String cuerpo,
  }) async {
    llamadas.add((titulo: titulo, cuerpo: cuerpo));
  }
}

void main() {
  late AppDatabase db;
  late SharedPreferences prefs;
  late NotificadorFalso notificador;
  late int catComida;
  late int catSueldo;

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

  Future<void> abrirFormulario(
    WidgetTester tester, {
    int? id,
  }) async {
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
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => MovimientoFormScreen(id: id),
                    ),
                  ),
                  child: const Text('abrir'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();
  }

  Future<void> cerrar(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  }

  tearDown(() async {
    await db.close();
  });

  testWidgets('guardar con monto vacío muestra error y no crea nada', (
    tester,
  ) async {
    await preparar();
    await abrirFormulario(tester);

    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    expect(find.text('Ingresa un monto'), findsOneWidget);
    expect(await db.select(db.movimientos).get(), isEmpty);
    await cerrar(tester);
  });

  testWidgets('guardar con "12,50" y categoría crea un gasto de 1250', (
    tester,
  ) async {
    await preparar();
    await abrirFormulario(tester);

    await tester.enterText(find.byType(TextFormField), '12,50');
    await tester.tap(find.text('Comida'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    final filas = await db.select(db.movimientos).get();
    expect(filas, hasLength(1));
    expect(filas.single.montoCentimos, 1250);
    expect(filas.single.tipo, TipoMovimiento.gasto);
    expect(filas.single.categoriaId, catComida);
    expect(find.text('abrir'), findsOneWidget);
    await cerrar(tester);
  });

  testWidgets(
    'guardar desde el formulario un gasto que cruza el 80 % notifica una vez',
    (tester) async {
      await preparar();
      await PresupuestosRepository(db).guardarTotal(10000);
      await abrirFormulario(tester);

      await tester.enterText(find.byType(TextFormField), '85');
      await tester.tap(find.text('Comida'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Guardar'));
      await tester.pumpAndSettle();

      expect(find.text('abrir'), findsOneWidget);
      expect(await db.select(db.movimientos).get(), hasLength(1));
      expect(notificador.llamadas, hasLength(1));
      await cerrar(tester);
    },
  );

  testWidgets('cambiar a Ingreso muestra solo categorías de ingreso', (
    tester,
  ) async {
    await preparar();
    await abrirFormulario(tester);

    expect(find.text('Comida'), findsOneWidget);
    expect(find.text('Sueldo'), findsNothing);

    await tester.tap(find.text('Comida'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ingreso'));
    await tester.pumpAndSettle();

    expect(find.text('Sueldo'), findsOneWidget);
    expect(find.text('Comida'), findsNothing);

    await tester.tap(find.text('Gasto'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), '12');
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    expect(find.text('Elige una categoría'), findsOneWidget);
    expect(await db.select(db.movimientos).get(), isEmpty);
    await cerrar(tester);
  });

  testWidgets('editar, guardar y reabrir muestra el valor nuevo', (
    tester,
  ) async {
    await preparar();
    final id = await db
        .into(db.movimientos)
        .insert(
          MovimientosCompanion.insert(
            tipo: TipoMovimiento.gasto,
            montoCentimos: 2450,
            fecha: DateTime(2026, 11, 12),
            categoriaId: catComida,
            creadoEn: DateTime(2026, 11, 12, 10),
          ),
        );

    await abrirFormulario(tester, id: id);
    await tester.enterText(find.byType(TextFormField), '30');
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    expect((await db.select(db.movimientos).get()).single.montoCentimos, 3000);

    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();

    expect(find.text('30.00'), findsOneWidget);
    await cerrar(tester);
  });

  testWidgets('en edición, Borrar pide confirmación y elimina', (tester) async {
    await preparar();
    final id = await db
        .into(db.movimientos)
        .insert(
          MovimientosCompanion.insert(
            tipo: TipoMovimiento.gasto,
            montoCentimos: 2450,
            fecha: DateTime(2026, 11, 12),
            categoriaId: catComida,
            creadoEn: DateTime(2026, 11, 12, 10),
          ),
        );
    expect(catSueldo, greaterThan(0));

    await abrirFormulario(tester, id: id);
    expect(find.text('Editar movimiento'), findsOneWidget);

    await tester.tap(find.text('Borrar'));
    await tester.pumpAndSettle();
    expect(find.text('¿Borrar movimiento?'), findsOneWidget);

    await tester.tap(find.text('Eliminar'));
    await tester.pumpAndSettle();

    expect(await db.select(db.movimientos).get(), isEmpty);
    await cerrar(tester);
  });
}
