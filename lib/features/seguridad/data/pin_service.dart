import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/errors.dart';

class PinService {
  PinService(this._storage, {Random? random})
    : _random = random ?? Random.secure();

  static const _claveHash = 'pinHash';
  static const _claveSal = 'pinSal';

  final FlutterSecureStorage _storage;
  final Random _random;

  Future<void> guardarPin(String pin) async {
    if (!RegExp(r'^\d{4}$').hasMatch(pin)) {
      throw ValidacionException('pin', 'formato');
    }

    final sal = List<int>.generate(16, (_) => _random.nextInt(256));
    await _storage.write(key: _claveSal, value: base64Encode(sal));
    await _storage.write(key: _claveHash, value: _hash(sal, pin));
  }

  Future<bool> verificar(String pin) async {
    final salGuardada = await _storage.read(key: _claveSal);
    final hashGuardado = await _storage.read(key: _claveHash);
    if (salGuardada == null || hashGuardado == null) return false;

    return _hash(base64Decode(salGuardada), pin) == hashGuardado;
  }

  Future<bool> tienePin() async {
    return await _storage.read(key: _claveHash) != null;
  }

  Future<void> borrarPin() async {
    await _storage.delete(key: _claveHash);
    await _storage.delete(key: _claveSal);
  }

  String _hash(List<int> sal, String pin) {
    return sha256.convert([...sal, ...utf8.encode(pin)]).toString();
  }
}
