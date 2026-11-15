import 'package:app_gastos/features/ajustes/providers/preferencias_providers.dart';
import 'package:app_gastos/features/seguridad/data/biometria_service.dart';
import 'package:app_gastos/features/seguridad/data/pin_service.dart';
import 'package:app_gastos/features/seguridad/providers/bloqueo_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/pin_service_test.dart' show StorageFalso;

class PinServiceFalso extends PinService {
  PinServiceFalso() : super(StorageFalso());

  int verificaciones = 0;

  @override
  Future<bool> verificar(String pin) async {
    verificaciones++;
    return pin == '1234';
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
  late PinServiceFalso pin;
  late BiometriaFalsa biometria;
  late DateTime ahora;

  Future<ProviderContainer> contenedor({
    bool bloqueoActivo = false,
    bool usarHuella = false,
  }) async {
    SharedPreferences.setMockInitialValues({
      'bloqueoActivo': bloqueoActivo,
      'usarHuella': usarHuella,
    });
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        pinServiceProvider.overrideWithValue(pin),
        biometriaServiceProvider.overrideWithValue(biometria),
        relojProvider.overrideWithValue(() => ahora),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUp(() {
    pin = PinServiceFalso();
    biometria = BiometriaFalsa();
    ahora = DateTime(2026, 11, 15, 12);
  });

  test('con bloqueo inactivo arranca desbloqueado', () async {
    final container = await contenedor();
    final estado = container.read(bloqueoControllerProvider);

    expect(estado.bloqueado, isFalse);
  });

  test('5 PIN incorrectos esperan 30 s; antes de eso no se verifica', () async {
    final container = await contenedor(bloqueoActivo: true);
    final notifier = container.read(bloqueoControllerProvider.notifier);

    for (var i = 0; i < 5; i++) {
      expect(await notifier.intentarPin('0000'), isFalse);
    }

    expect(container.read(bloqueoControllerProvider).esperarHasta,
        ahora.add(const Duration(seconds: 30)));
    expect(pin.verificaciones, 5);

    expect(await notifier.intentarPin('1234'), isFalse);
    expect(pin.verificaciones, 5);
    expect(container.read(bloqueoControllerProvider).bloqueado, isTrue);

    ahora = ahora.add(const Duration(seconds: 31));
    expect(await notifier.intentarPin('1234'), isTrue);
    expect(container.read(bloqueoControllerProvider).bloqueado, isFalse);
  });

  test(
      'verificarPinActual: 5 fallos impiden verificar durante 30 s y no '
      'cambian bloqueado', () async {
    final container = await contenedor(bloqueoActivo: false);
    final notifier = container.read(bloqueoControllerProvider.notifier);

    for (var i = 0; i < 5; i++) {
      expect(await notifier.verificarPinActual('0000'), isFalse);
    }

    final estado = container.read(bloqueoControllerProvider);
    expect(estado.esperarHasta, ahora.add(const Duration(seconds: 30)));
    expect(estado.bloqueado, isFalse);
    expect(pin.verificaciones, 5);

    expect(await notifier.verificarPinActual('1234'), isFalse);
    expect(pin.verificaciones, 5);

    ahora = ahora.add(const Duration(seconds: 31));
    expect(await notifier.verificarPinActual('1234'), isTrue);
    expect(container.read(bloqueoControllerProvider).bloqueado, isFalse);
  });

  test('alVolver bloquea a los 61 s pero no a los 59 s', () async {
    final container = await contenedor(bloqueoActivo: true);
    final notifier = container.read(bloqueoControllerProvider.notifier);

    expect(await notifier.intentarPin('1234'), isTrue);
    expect(container.read(bloqueoControllerProvider).bloqueado, isFalse);

    notifier.alPasarASegundoPlano();
    ahora = ahora.add(const Duration(seconds: 59));
    notifier.alVolver();
    expect(container.read(bloqueoControllerProvider).bloqueado, isFalse);

    notifier.alPasarASegundoPlano();
    ahora = ahora.add(const Duration(seconds: 61));
    notifier.alVolver();
    expect(container.read(bloqueoControllerProvider).bloqueado, isTrue);
  });

  test('intentarHuella sin biometría disponible devuelve false', () async {
    biometria = BiometriaFalsa(soportada: false);
    final container = await contenedor(bloqueoActivo: true, usarHuella: true);
    final notifier = container.read(bloqueoControllerProvider.notifier);

    expect(await notifier.intentarHuella(), isFalse);
    expect(container.read(bloqueoControllerProvider).bloqueado, isTrue);
  });

  test('si la huella falla se puede seguir usando el PIN', () async {
    biometria = BiometriaFalsa(soportada: true, autentica: false);
    final container = await contenedor(bloqueoActivo: true, usarHuella: true);
    final notifier = container.read(bloqueoControllerProvider.notifier);

    expect(await notifier.intentarHuella(), isFalse);
    expect(biometria.llamadas, 1);
    expect(container.read(bloqueoControllerProvider).bloqueado, isTrue);

    expect(await notifier.intentarPin('1234'), isTrue);
    expect(container.read(bloqueoControllerProvider).bloqueado, isFalse);
  });
}
