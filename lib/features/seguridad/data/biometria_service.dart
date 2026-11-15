import 'package:local_auth/local_auth.dart';

abstract interface class BiometriaService {
  /// El dispositivo la soporta y tiene alguna huella registrada.
  Future<bool> disponible();

  /// Devuelve `false` ante cualquier excepción; nunca lanza.
  Future<bool> autenticar(String motivo);
}

class BiometriaLocalAuth implements BiometriaService {
  BiometriaLocalAuth([LocalAuthentication? auth])
    : _auth = auth ?? LocalAuthentication();

  final LocalAuthentication _auth;

  @override
  Future<bool> disponible() async {
    try {
      if (!await _auth.isDeviceSupported()) return false;
      final biometricos = await _auth.getAvailableBiometrics();
      return biometricos.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> autenticar(String motivo) async {
    try {
      return await _auth.authenticate(
        localizedReason: motivo,
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
    } catch (_) {
      return false;
    }
  }
}
