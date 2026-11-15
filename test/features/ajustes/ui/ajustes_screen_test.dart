import 'dart:math';

import 'package:app_gastos/app.dart';
import 'package:app_gastos/core/database/app_database.dart';
import 'package:app_gastos/core/database/database_provider.dart';
import 'package:app_gastos/features/ajustes/providers/preferencias_providers.dart';
import 'package:app_gastos/features/seguridad/data/pin_service.dart';
import 'package:app_gastos/features/seguridad/providers/bloqueo_providers.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../seguridad/data/pin_service_test.dart' show StorageFalso;

class PinServiceFalso extends PinService {
  PinServiceFalso() : super(StorageFalso());

  @override
  Future<bool> tienePin() async => true;

  @override
  Future<bool> verificar(String pin) async => pin == '1234';
}

Future<void> abrirAjustes(
  WidgetTester tester,
  PinService pin,
) async {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  SharedPreferences.setMockInitialValues({'onboardingCompleto': true});
  final prefs = await SharedPreferences.getInstance();
  final db = AppDatabase(NativeDatabase.memory());
  addTearDown(db.close);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        appDatabaseProvider.overrideWithValue(db),
        pinServiceProvider.overrideWithValue(pin),
        randomPinProvider.overrideWithValue(Random(5)),
      ],
      child: const App(),
    ),
  );
  await tester.pumpAndSettle();

  await tester.tap(
    find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text('Ajustes'),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> escribirPin(WidgetTester tester, String pin) async {
  for (final digito in pin.split('')) {
    await tester.tap(find.text(digito));
    await tester.pump();
  }
  await tester.pump(const Duration(milliseconds: 300));
}

void main() {
  testWidgets('cambiar a English traduce la pantalla de Ajustes', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({'onboardingCompleto': true});
    final prefs = await SharedPreferences.getInstance();
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

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

    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Ajustes'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Preferencias'), findsOneWidget);
    expect(find.text('Categorías'), findsOneWidget);

    await tester.tap(find.text('Idioma'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsWidgets);
    expect(find.text('Preferences'), findsOneWidget);
    expect(find.text('Language'), findsOneWidget);
    expect(find.text('Categories'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });

  testWidgets('el diálogo de PIN verifica al cuarto dígito', (tester) async {
    await abrirAjustes(tester, PinServiceFalso());

    await tester.tap(find.text('Cambiar PIN'));
    await tester.pumpAndSettle();
    expect(find.text('Introduce tu PIN actual'), findsOneWidget);

    await escribirPin(tester, '1234');

    expect(find.text('Crear PIN'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });

  testWidgets('tras 5 PIN incorrectos el diálogo muestra la espera', (
    tester,
  ) async {
    await abrirAjustes(tester, PinServiceFalso());

    await tester.tap(find.text('Cambiar PIN'));
    await tester.pumpAndSettle();

    for (var i = 0; i < 5; i++) {
      await escribirPin(tester, '0000');
    }

    expect(find.textContaining('Demasiados intentos'), findsOneWidget);
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });
}
