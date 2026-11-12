import 'package:app_gastos/features/ajustes/data/preferencias_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SharedPreferences prefs;
  late PreferenciasRepository repo;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    repo = PreferenciasRepository(prefs);
  });

  test('valores por defecto: es, onboarding false, bloqueo false, huella false',
      () {
    expect(repo.idioma, 'es');
    expect(repo.onboardingCompleto, isFalse);
    expect(repo.bloqueoActivo, isFalse);
    expect(repo.usarHuella, isFalse);
  });

  test('setIdioma persiste en y lanza ArgumentError con fr', () async {
    await repo.setIdioma('en');

    expect(PreferenciasRepository(prefs).idioma, 'en');
    expect(() => repo.setIdioma('fr'), throwsArgumentError);
  });

  test('marcarOnboardingCompleto persiste true', () async {
    await repo.marcarOnboardingCompleto();

    expect(PreferenciasRepository(prefs).onboardingCompleto, isTrue);
  });
}
