import 'package:app_gastos/core/database/app_database.dart';
import 'package:app_gastos/core/database/database_provider.dart';
import 'package:app_gastos/core/database/enums.dart';
import 'package:app_gastos/core/l10n/app_localizations.dart';
import 'package:app_gastos/core/theme/app_theme.dart';
import 'package:app_gastos/features/categorias/ui/categorias_screen.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> abrir(WidgetTester tester, AppDatabase db) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: MaterialApp(
          theme: construirTemaClaro(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('es'),
          home: const CategoriasScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<int> sembrar(
    AppDatabase db,
    String nombre, {
    bool archivada = false,
    TipoMovimiento tipo = TipoMovimiento.gasto,
  }) {
    return db
        .into(db.categorias)
        .insert(
          CategoriasCompanion.insert(
            nombre: nombre,
            icono: 'otros',
            color: 0xFFC2410C,
            tipo: tipo,
            archivada: Value(archivada),
          ),
        );
  }

  testWidgets('valida el nombre vacío y crea la categoría «Café»', (
    tester,
  ) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await abrir(tester, db);

    await tester.tap(find.text('Nueva'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(find.text('El nombre es obligatorio'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Café');
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    expect(find.text('Café'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });

  testWidgets('sin archivadas no muestra la sección «Archivadas»', (
    tester,
  ) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    await sembrar(db, 'Comida');

    await abrir(tester, db);

    expect(find.text('Archivadas'), findsNothing);
    expect(find.text('Comida'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });

  testWidgets('una archivada aparece en «Archivadas» y no en su tipo', (
    tester,
  ) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    await sembrar(db, 'Comida');
    await sembrar(db, 'Cine', archivada: true);

    await abrir(tester, db);

    expect(find.text('Archivadas'), findsOneWidget);
    expect(find.text('Cine'), findsOneWidget);
    expect(find.text('Archivada'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('Cine')).dy,
      greaterThan(tester.getTopLeft(find.text('Archivadas')).dy),
    );
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });

  testWidgets('restaurar una archivada la devuelve a su sección', (
    tester,
  ) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    await sembrar(db, 'Comida');
    await sembrar(db, 'Cine', archivada: true);

    await abrir(tester, db);
    await tester.tap(find.text('Cine'));
    await tester.pumpAndSettle();

    expect(find.text('Restaurar'), findsOneWidget);
    expect(find.text('Eliminar'), findsNothing);

    await tester.ensureVisible(find.text('Restaurar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Restaurar'));
    await tester.pumpAndSettle();

    expect(find.text('La categoría se restauró.'), findsOneWidget);
    expect(find.text('Archivadas'), findsNothing);
    expect(find.text('Archivada'), findsNothing);
    expect(find.text('Cine'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });
}
