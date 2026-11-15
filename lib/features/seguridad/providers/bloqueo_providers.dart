import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../ajustes/providers/preferencias_providers.dart';
import '../data/biometria_service.dart';
import '../data/pin_service.dart';

part 'bloqueo_providers.g.dart';

AppLocalizations _textos(Ref ref) =>
    lookupAppLocalizations(ref.read(idiomaActualProvider));

@Riverpod(keepAlive: true)
DateTime Function() reloj(Ref ref) => DateTime.now;

@Riverpod(keepAlive: true)
PinService pinService(Ref ref) {
  return PinService(const FlutterSecureStorage());
}

@Riverpod(keepAlive: true)
BiometriaService biometriaService(Ref ref) => BiometriaLocalAuth();

@Riverpod(keepAlive: true)
Future<bool> biometriaDisponible(Ref ref) {
  return ref.watch(biometriaServiceProvider).disponible();
}

class EstadoBloqueo {
  const EstadoBloqueo({
    required this.bloqueado,
    this.intentosFallidos = 0,
    this.esperarHasta,
  });

  final bool bloqueado;
  final int intentosFallidos;
  final DateTime? esperarHasta;
}

@Riverpod(keepAlive: true)
class BloqueoController extends _$BloqueoController {
  DateTime? _pasoASegundoPlano;

  @override
  EstadoBloqueo build() {
    final prefs = ref.watch(preferenciasRepositoryProvider);
    return EstadoBloqueo(bloqueado: prefs.bloqueoActivo);
  }

  Future<bool> intentarPin(String pin) async {
    final ahora = ref.read(relojProvider)();
    final espera = state.esperarHasta;
    if (espera != null && espera.isAfter(ahora)) return false;

    final correcto = await ref.read(pinServiceProvider).verificar(pin);
    if (correcto) {
      state = const EstadoBloqueo(bloqueado: false);
      return true;
    }

    final intentos = state.intentosFallidos + 1;
    if (intentos >= 5) {
      state = EstadoBloqueo(
        bloqueado: true,
        esperarHasta: ahora.add(const Duration(seconds: 30)),
      );
    } else {
      state = EstadoBloqueo(bloqueado: true, intentosFallidos: intentos);
    }
    return false;
  }

  /// Verifica el PIN desde Ajustes usando el mismo límite de intentos que
  /// [intentarPin], pero sin modificar [EstadoBloqueo.bloqueado].
  Future<bool> verificarPinActual(String pin) async {
    final ahora = ref.read(relojProvider)();
    final espera = state.esperarHasta;
    if (espera != null && espera.isAfter(ahora)) return false;

    final correcto = await ref.read(pinServiceProvider).verificar(pin);
    if (correcto) {
      state = EstadoBloqueo(bloqueado: state.bloqueado);
      return true;
    }

    final intentos = state.intentosFallidos + 1;
    if (intentos >= 5) {
      state = EstadoBloqueo(
        bloqueado: state.bloqueado,
        esperarHasta: ahora.add(const Duration(seconds: 30)),
      );
    } else {
      state = EstadoBloqueo(
        bloqueado: state.bloqueado,
        intentosFallidos: intentos,
      );
    }
    return false;
  }

  Future<bool> intentarHuella() async {
    final prefs = ref.read(preferenciasRepositoryProvider);
    if (!prefs.usarHuella) return false;

    final biometria = ref.read(biometriaServiceProvider);
    if (!await biometria.disponible()) return false;

    final autenticado = await biometria.autenticar(_textos(ref).huellaMotivo);
    if (autenticado) {
      state = const EstadoBloqueo(bloqueado: false);
    }
    return autenticado;
  }

  void alPasarASegundoPlano() {
    _pasoASegundoPlano = ref.read(relojProvider)();
  }

  void alVolver() {
    final desde = _pasoASegundoPlano;
    _pasoASegundoPlano = null;
    if (desde == null) return;

    final prefs = ref.read(preferenciasRepositoryProvider);
    if (!prefs.bloqueoActivo) return;

    final transcurrido = ref.read(relojProvider)().difference(desde);
    if (transcurrido > const Duration(seconds: 60)) {
      state = const EstadoBloqueo(bloqueado: true);
    }
  }
}
