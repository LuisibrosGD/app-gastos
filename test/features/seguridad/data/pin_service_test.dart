import 'package:app_gastos/core/errors.dart';
import 'package:app_gastos/features/seguridad/data/pin_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

class StorageFalso extends FlutterSecureStorage {
  final datos = <String, String>{};

  @override
  Future<String?> read({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    return datos[key];
  }

  @override
  Future<void> write({
    required String key,
    required String? value,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    if (value == null) {
      datos.remove(key);
    } else {
      datos[key] = value;
    }
  }

  @override
  Future<void> delete({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    datos.remove(key);
  }
}

void main() {
  late StorageFalso storage;
  late PinService servicio;

  setUp(() {
    storage = StorageFalso();
    servicio = PinService(storage);
  });

  test('guardar "1234" y verificar "1234" es true, "1235" es false', () async {
    await servicio.guardarPin('1234');

    expect(await servicio.verificar('1234'), isTrue);
    expect(await servicio.verificar('1235'), isFalse);
    expect(await servicio.tienePin(), isTrue);
  });

  test('guardar con 3, 5 o 6 dígitos lanza ValidacionException', () async {
    for (final pin in ['123', '12345', '123456']) {
      await expectLater(
        servicio.guardarPin(pin),
        throwsA(
          isA<ValidacionException>()
              .having((e) => e.campo, 'campo', 'pin')
              .having((e) => e.codigo, 'codigo', 'formato'),
        ),
      );
    }
  });

  test('el almacenamiento no contiene "1234" en texto plano', () async {
    await servicio.guardarPin('1234');

    expect(storage.datos.values, isNotEmpty);
    expect(storage.datos.values.any((valor) => valor.contains('1234')), isFalse);
  });

  test('dos guardados del mismo PIN generan hashes distintos', () async {
    await servicio.guardarPin('1234');
    final primerHash = storage.datos['pinHash'];

    await servicio.guardarPin('1234');
    final segundoHash = storage.datos['pinHash'];

    expect(primeroNoIgual(primerHash, segundoHash), isTrue);
  });

  test('borrarPin elimina el PIN', () async {
    await servicio.guardarPin('1234');
    await servicio.borrarPin();

    expect(await servicio.tienePin(), isFalse);
    expect(await servicio.verificar('1234'), isFalse);
    expect(storage.datos, isEmpty);
  });
}

bool primeroNoIgual(String? primero, String? segundo) {
  return primero != null && segundo != null && primero != segundo;
}
