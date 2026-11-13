import 'package:app_gastos/app.dart';
import 'package:app_gastos/core/database/app_database.dart';
import 'package:app_gastos/core/database/database_provider.dart';
import 'package:app_gastos/core/database/enums.dart';
import 'package:app_gastos/features/ajustes/providers/preferencias_providers.dart';
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

  Future<void> preparar() async {
    SharedPreferences.setMockInitialValues({'onboardingCompleto': true});
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
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> cerrar(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  }

  Future<void> tocarPestana(WidgetTester tester, String etiqueta) async {
    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text(etiqueta),
      ),
    );
    await tester.pumpAndSettle();
  }

  tearDown(() async {
    await db.close();
  });

  testWidgets('con onboarding completo la ruta inicial es /inicio', (
    tester,
  ) async {
    await preparar();
    await abrir(tester);

    expect(find.text('Aún no hay movimientos'), findsOneWidget);
    await cerrar(tester);
  });

  testWidgets('la barra inferior navega y conserva el estado de cada pestaña', (
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
    await db
        .into(db.movimientos)
        .insert(
          MovimientosCompanion.insert(
            tipo: TipoMovimiento.gasto,
            montoCentimos: 1000,
            fecha: DateTime(DateTime.now().year, 12, 5),
            categoriaId: catComida,
            nota: const Value('Cena'),
            creadoEn: DateTime(2026, 11, 12, 10),
          ),
        );
    await abrir(tester);

    await tocarPestana(tester, 'Movimientos');
    expect(find.text('Cena'), findsNothing);

    await tester.tap(find.byType(SelectorMes));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Diciembre'));
    await tester.pumpAndSettle();
    expect(find.text('Cena'), findsOneWidget);

    await tocarPestana(tester, 'Inicio');
    expect(find.text('Últimos movimientos'), findsOneWidget);

    await tocarPestana(tester, 'Movimientos');
    expect(find.text('Cena'), findsOneWidget);
    expect(find.textContaining('Diciembre'), findsOneWidget);

    await tocarPestana(tester, 'Resumen');
    expect(find.text('Resumen'), findsWidgets);

    await cerrar(tester);
  });

  testWidgets('el botón + abre /movimiento/nuevo', (tester) async {
    await preparar();
    await abrir(tester);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.text('Nuevo movimiento'), findsOneWidget);
    await cerrar(tester);
  });
}
