import 'package:app_gastos/core/database/app_database.dart';
import 'package:app_gastos/core/database/database_provider.dart';
import 'package:app_gastos/core/l10n/app_localizations.dart';
import 'package:app_gastos/core/theme/app_theme.dart';
import 'package:app_gastos/features/categorias/ui/categorias_screen.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('valida el nombre vacío y crea la categoría «Café»', (
    tester,
  ) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

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
}
