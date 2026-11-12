import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/preferencias_repository.dart';

part 'preferencias_providers.g.dart';

@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider se sobrescribe en main',
  );
}

@Riverpod(keepAlive: true)
PreferenciasRepository preferenciasRepository(Ref ref) {
  return PreferenciasRepository(ref.watch(sharedPreferencesProvider));
}

@Riverpod(keepAlive: true)
class IdiomaActual extends _$IdiomaActual {
  @override
  Locale build() {
    return Locale(ref.watch(preferenciasRepositoryProvider).idioma);
  }

  Future<void> cambiar(String codigo) async {
    await ref.read(preferenciasRepositoryProvider).setIdioma(codigo);
    state = Locale(codigo);
  }
}

@Riverpod(keepAlive: true)
class OnboardingCompleto extends _$OnboardingCompleto {
  @override
  bool build() {
    return ref.watch(preferenciasRepositoryProvider).onboardingCompleto;
  }

  Future<void> completar() async {
    await ref.read(preferenciasRepositoryProvider).marcarOnboardingCompleto();
    state = true;
  }
}
