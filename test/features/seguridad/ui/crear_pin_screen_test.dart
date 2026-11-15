import 'dart:math';

import 'package:app_gastos/core/l10n/app_localizations.dart';
import 'package:app_gastos/core/theme/app_theme.dart';
import 'package:app_gastos/features/ajustes/providers/preferencias_providers.dart';
import 'package:app_gastos/features/seguridad/data/biometria_service.dart';
import 'package:app_gastos/features/seguridad/data/pin_service.dart';
import 'package:app_gastos/features/seguridad/providers/bloqueo_providers.dart';
import 'package:app_gastos/features/seguridad/ui/crear_pin_screen.dart';
import 'package:app_gastos/features/seguridad/ui/widgets/puntos_pin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/pin_service_test.dart' show StorageFalso;

class PinServiceFalso extends PinService {
  PinServiceFalso() : super(StorageFalso());

  String? guardado;

  @override
  Future<void> guardarPin(String pin) async {
    guardado = pin;
  }

  @override
  Future<bool> tienePin() async => guardado != null;
}

class BiometriaFalsa implements BiometriaService {
  @override
  Future<bool> disponible() async => false;

  @override
  Future<bool> autenticar(String motivo) async => false;
}

void main() {
  Future<void> abrir(WidgetTester tester, PinService pin) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          pinServiceProvider.overrideWithValue(pin),
          biometriaServiceProvider.overrideWithValue(BiometriaFalsa()),
          randomPinProvider.overrideWithValue(Random(3)),
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
                      builder: (_) =>
                          const CrearPinScreen(activarBloqueo: false),
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
    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();
  }

  void configurarPantalla(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Future<void> pulsar(WidgetTester tester, String pin) async {
    for (final digito in pin.split('')) {
      await tester.tap(find.text(digito));
      await tester.pump();
    }
    await tester.pumpAndSettle();
  }

  testWidgets('el cuarto dígito pasa a confirmar y el segundo guarda', (
    tester,
  ) async {
    configurarPantalla(tester);
    final pin = PinServiceFalso();
    await abrir(tester, pin);

    await pulsar(tester, '1234');

    expect(find.text('Repite el PIN'), findsOneWidget);
    expect(tester.widget<PuntosPin>(find.byType(PuntosPin)).rellenos, 0);
    expect(pin.guardado, isNull);
    expect(find.byIcon(Icons.check), findsNothing);

    await pulsar(tester, '1234');

    expect(pin.guardado, '1234');
    expect(find.text('abrir'), findsOneWidget);
  });

  testWidgets('si los PIN no coinciden muestra el error y no guarda', (
    tester,
  ) async {
    configurarPantalla(tester);
    final pin = PinServiceFalso();
    await abrir(tester, pin);

    await pulsar(tester, '1234');
    await pulsar(tester, '1235');

    expect(find.text('Los PIN no coinciden'), findsOneWidget);
    expect(pin.guardado, isNull);
    expect(tester.widget<PuntosPin>(find.byType(PuntosPin)).rellenos, 0);
  });
}
