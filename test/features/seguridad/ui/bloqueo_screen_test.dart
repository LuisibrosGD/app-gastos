import 'dart:async';
import 'dart:math';

import 'package:app_gastos/core/l10n/app_localizations.dart';
import 'package:app_gastos/core/theme/app_theme.dart';
import 'package:app_gastos/features/ajustes/providers/preferencias_providers.dart';
import 'package:app_gastos/features/seguridad/data/biometria_service.dart';
import 'package:app_gastos/features/seguridad/data/pin_service.dart';
import 'package:app_gastos/features/seguridad/providers/bloqueo_providers.dart';
import 'package:app_gastos/features/seguridad/ui/bloqueo_screen.dart';
import 'package:app_gastos/features/seguridad/ui/widgets/puntos_pin.dart';
import 'package:app_gastos/features/seguridad/ui/widgets/teclado_pin.dart';
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

class PinServiceLento extends PinService {
  PinServiceLento() : super(StorageFalso());

  final completer = Completer<bool>();
  String? recibido;

  @override
  Future<bool> verificar(String pin) {
    recibido = pin;
    return completer.future;
  }
}

class BiometriaFalsa implements BiometriaService {
  BiometriaFalsa({this.soportada = false, this.autentica = false});

  final bool soportada;
  final bool autentica;
  int llamadas = 0;

  @override
  Future<bool> disponible() async => soportada;

  @override
  Future<bool> autenticar(String motivo) async {
    llamadas++;
    return autentica;
  }
}

void main() {
  Future<ProviderContainer> abrir(
    WidgetTester tester, {
    bool usarHuella = false,
    PinService? pin,
    BiometriaService? biometria,
  }) async {
    SharedPreferences.setMockInitialValues({
      'bloqueoActivo': true,
      'usarHuella': usarHuella,
    });
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          pinServiceProvider.overrideWithValue(pin ?? PinServiceFalso()),
          biometriaServiceProvider.overrideWithValue(
            biometria ?? BiometriaFalsa(),
          ),
          randomPinProvider.overrideWithValue(Random(7)),
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

  void configurarPantalla(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Future<void> escribir(WidgetTester tester, String pin) async {
    for (final digito in pin.split('')) {
      await tester.tap(find.text(digito));
      await tester.pump();
    }
    await tester.pumpAndSettle();
  }

  Future<void> cerrar(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  }

  testWidgets('un PIN correcto de 4 dígitos desbloquea sin confirmar', (
    tester,
  ) async {
    configurarPantalla(tester);
    final container = await abrir(tester);
    expect(container.read(bloqueoControllerProvider).bloqueado, isTrue);

    await escribir(tester, '1234');

    expect(container.read(bloqueoControllerProvider).bloqueado, isFalse);
    expect(find.byIcon(Icons.check), findsNothing);
    await cerrar(tester);
  });

  testWidgets('un quinto dígito no se tiene en cuenta', (tester) async {
    configurarPantalla(tester);
    final pin = PinServiceLento();
    await abrir(tester, pin: pin);

    for (final digito in '1234'.split('')) {
      await tester.tap(find.text(digito));
      await tester.pump();
    }
    expect(tester.widget<PuntosPin>(find.byType(PuntosPin)).rellenos, 4);

    await tester.tap(find.text('5'));
    await tester.pump();

    expect(tester.widget<PuntosPin>(find.byType(PuntosPin)).rellenos, 4);
    expect(pin.recibido, '1234');

    pin.completer.complete(false);
    await tester.pumpAndSettle();
    expect(tester.widget<PuntosPin>(find.byType(PuntosPin)).rellenos, 0);
    await cerrar(tester);
  });

  testWidgets('un PIN incorrecto vacía los puntos y cambia el orden', (
    tester,
  ) async {
    configurarPantalla(tester);
    await abrir(tester);
    final ordenInicial = tester
        .widget<TecladoPin>(find.byType(TecladoPin))
        .orden;

    await escribir(tester, '0000');

    expect(find.text('PIN incorrecto'), findsOneWidget);
    expect(tester.widget<PuntosPin>(find.byType(PuntosPin)).rellenos, 0);
    final ordenNuevo = tester
        .widget<TecladoPin>(find.byType(TecladoPin))
        .orden;
    expect(ordenNuevo, isNot(equals(ordenInicial)));
    await cerrar(tester);
  });

  testWidgets('sin huella disponible el hueco de la huella queda vacío', (
    tester,
  ) async {
    configurarPantalla(tester);
    await abrir(tester);

    expect(find.byIcon(Icons.fingerprint), findsNothing);
    expect(
      tester.widget<TecladoPin>(find.byType(TecladoPin)).alHuella,
      isNull,
    );
    await cerrar(tester);
  });

  testWidgets('con huella activada la tecla está abajo a la izquierda', (
    tester,
  ) async {
    configurarPantalla(tester);
    final biometria = BiometriaFalsa(soportada: true, autentica: false);
    await abrir(tester, usarHuella: true, biometria: biometria);

    final huella = find.byIcon(Icons.fingerprint);
    expect(huella, findsOneWidget);
    expect(biometria.llamadas, 1);

    await tester.tap(huella);
    await tester.pumpAndSettle();
    expect(biometria.llamadas, 2);
    await cerrar(tester);
  });

  testWidgets('5 PIN incorrectos muestran la espera de 30 s', (tester) async {
    configurarPantalla(tester);
    final container = await abrir(tester);

    for (var i = 0; i < 5; i++) {
      await escribir(tester, '0000');
    }

    expect(find.textContaining('Demasiados intentos'), findsOneWidget);
    final estado = container.read(bloqueoControllerProvider);
    expect(estado.bloqueado, isTrue);
    expect(estado.esperarHasta, isNotNull);
    await cerrar(tester);
  });
}
