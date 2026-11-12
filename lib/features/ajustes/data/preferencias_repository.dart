import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasRepository {
  PreferenciasRepository(this._prefs);

  static const _claveIdioma = 'idioma';
  static const _claveOnboardingCompleto = 'onboardingCompleto';
  static const _claveBloqueoActivo = 'bloqueoActivo';
  static const _claveUsarHuella = 'usarHuella';

  final SharedPreferences _prefs;

  String get idioma => _prefs.getString(_claveIdioma) ?? 'es';

  Future<void> setIdioma(String codigo) async {
    if (codigo != 'es' && codigo != 'en') {
      throw ArgumentError.value(codigo, 'codigo', 'Solo se admite es o en');
    }
    await _prefs.setString(_claveIdioma, codigo);
  }

  bool get onboardingCompleto =>
      _prefs.getBool(_claveOnboardingCompleto) ?? false;

  Future<void> marcarOnboardingCompleto() async {
    await _prefs.setBool(_claveOnboardingCompleto, true);
  }

  bool get bloqueoActivo => _prefs.getBool(_claveBloqueoActivo) ?? false;

  Future<void> setBloqueoActivo(bool valor) async {
    await _prefs.setBool(_claveBloqueoActivo, valor);
  }

  bool get usarHuella => _prefs.getBool(_claveUsarHuella) ?? false;

  Future<void> setUsarHuella(bool valor) async {
    await _prefs.setBool(_claveUsarHuella, valor);
  }
}
