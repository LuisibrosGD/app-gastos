import 'package:app_gastos/core/l10n/app_localizations.dart';
import 'package:app_gastos/core/theme/app_theme.dart';
import 'package:app_gastos/features/ajustes/providers/preferencias_providers.dart';
import 'package:app_gastos/features/seguridad/data/biometria_service.dart';
import 'package:app_gastos/features/seguridad/data/pin_service.dart';
import 'package:app_gastos/features/seguridad/providers/bloqueo_providers.dart';
import 'package:app_gastos/features/seguridad/ui/bloqueo_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/pin_service_test.dart' show StorageFalso;

class PinServiceFalso extends PinService {
  PinServiceFalso() : super(StorageFalso());

  @override
  Future<bool> verificar(String pin) async => pin == '1234';
}

class BiometriaFalsa implements BiometriaService {
  @override
  Future<bool> disponible() async => false;

  @override
  Future<bool> autenticar(String motivo) async => false;
}

void main() {
  Future<ProviderContainer> abrir(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({
      'bloqueoActivo': true,
      'usarHuella': false,
    });
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          pinServiceProvider.overrideWithValue(PinServiceFalso()),
          biometriaServiceProvider.overrideWithValue(BiometriaFalsa()),
        ],
        child: MaterialApp(
          theme: construirTemaClaro(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('es'),
          home: const BloqueoScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return ProviderScope.containerOf(
      tester.element(find.byType(BloqueoScreen)),
    );
  }

  Future<void> escribir(WidgetTester tester, String pin) async {
    for (final digito in pin.split('')) {
      await tester.tap(find.text(digito));
      await tester.pump();
    }
    await tester.tap(find.byIcon(Icons.check));
    await tester.pumpAndSettle();
  }

  testWidgets('un PIN correcto desbloquea', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = await abrir(tester);
    expect(container.read(bloqueoControllerProvider).bloqueado, isTrue);

    await escribir(tester, '1234');

    expect(container.read(bloqueoControllerProvider).bloqueado, isFalse);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });

  testWidgets('5 PIN incorrectos muestran la espera de 30 s', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = await abrir(tester);

    for (var i = 0; i < 5; i++) {
      await escribir(tester, '0000');
    }

    expect(find.textContaining('Demasiados intentos'), findsOneWidget);
    final estado = container.read(bloqueoControllerProvider);
    expect(estado.bloqueado, isTrue);
    expect(estado.esperarHasta, isNotNull);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });
}
