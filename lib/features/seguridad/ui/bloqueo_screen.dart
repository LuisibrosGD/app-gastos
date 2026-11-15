import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/colores.dart';
import '../../../core/theme/dimensiones.dart';
import '../../../core/theme/tipografia.dart';
import '../../ajustes/providers/preferencias_providers.dart';
import '../providers/bloqueo_providers.dart';
import 'widgets/puntos_pin.dart';
import 'widgets/teclado_pin.dart';

class BloqueoScreen extends ConsumerStatefulWidget {
  const BloqueoScreen({super.key});

  @override
  ConsumerState<BloqueoScreen> createState() => _BloqueoScreenState();
}

class _BloqueoScreenState extends ConsumerState<BloqueoScreen> {
  String _pin = '';
  String? _error;
  bool _verificando = false;
  bool _huellaDisponible = false;
  bool _huellaActivada = false;
  bool _esperando = false;
  int _restantes = 0;
  Timer? _temporizador;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _prepararHuella());
  }

  @override
  void dispose() {
    _temporizador?.cancel();
    super.dispose();
  }

  Future<void> _prepararHuella() async {
    final disponible = await ref
        .read(biometriaServiceProvider)
        .disponible();
    final activada = ref.read(preferenciasRepositoryProvider).usarHuella;
    if (!mounted) return;

    setState(() {
      _huellaDisponible = disponible;
      _huellaActivada = activada;
    });

    if (disponible && activada) await _intentarHuella();
  }

  void _pulsar(int numero) {
    if (_esperando || _verificando || _pin.length >= 6) return;
    setState(() {
      _pin += '$numero';
      _error = null;
    });
  }

  void _borrar() {
    if (_esperando || _verificando || _pin.isEmpty) return;
    setState(() {
      _pin = _pin.substring(0, _pin.length - 1);
      _error = null;
    });
  }

  Future<void> _confirmar(AppLocalizations l10n) async {
    if (_esperando || _verificando) return;
    if (_pin.length < 4) {
      setState(() => _error = l10n.errorPinFormato);
      return;
    }

    setState(() => _verificando = true);
    final correcto = await ref
        .read(bloqueoControllerProvider.notifier)
        .intentarPin(_pin);
    if (!mounted) return;

    if (correcto) return;

    final estado = ref.read(bloqueoControllerProvider);
    final espera = estado.esperarHasta;
    if (espera != null && espera.isAfter(ref.read(relojProvider)())) {
      _iniciarEspera(espera);
      return;
    }

    setState(() {
      _verificando = false;
      _pin = '';
      _error = l10n.pinIncorrecto;
    });
  }

  void _iniciarEspera(DateTime hasta) {
    _temporizador?.cancel();
    final diferencia = hasta.difference(ref.read(relojProvider)()).inSeconds;
    final restantes = diferencia < 0 ? 0 : diferencia;

    setState(() {
      _verificando = false;
      _pin = '';
      _error = null;
      _esperando = restantes > 0;
      _restantes = restantes;
    });
    if (restantes == 0) return;

    _temporizador = Timer.periodic(const Duration(seconds: 1), (temporizador) {
      if (!mounted) {
        temporizador.cancel();
        return;
      }
      setState(() {
        _restantes--;
        if (_restantes <= 0) {
          _restantes = 0;
          _esperando = false;
          temporizador.cancel();
        }
      });
    });
  }

  Future<void> _intentarHuella() async {
    if (_verificando || _esperando) return;
    setState(() => _verificando = true);
    final correcto = await ref
        .read(bloqueoControllerProvider.notifier)
        .intentarHuella();
    if (!mounted) return;
    if (!correcto) setState(() => _verificando = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColores.fondo,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppEspacio.l),
          child: Column(
            children: [
              const Spacer(),
              const Icon(
                Icons.lock_outline,
                size: 40,
                color: AppColores.primario,
              ),
              const SizedBox(height: AppEspacio.l),
              Text(l10n.appTitle, style: AppTexto.subtitulo),
              const SizedBox(height: AppEspacio.s),
              Text(
                l10n.pinIngresa,
                style: AppTexto.cuerpo.copyWith(
                  color: AppColores.textoSecundario,
                ),
              ),
              const SizedBox(height: AppEspacio.l),
              PuntosPin(rellenos: _pin.length),
              const SizedBox(height: AppEspacio.m),
              SizedBox(
                height: AppEspacio.xl,
                child: _esperando
                    ? Text(
                        l10n.pinEspera(_restantes),
                        style: AppTexto.pequeno.copyWith(
                          color: AppColores.error,
                        ),
                      )
                    : _error != null
                    ? Text(
                        _error!,
                        style: AppTexto.pequeno.copyWith(
                          color: AppColores.error,
                        ),
                      )
                    : null,
              ),
              const SizedBox(height: AppEspacio.m),
              TecladoPin(
                habilitado: !_esperando && !_verificando,
                alPulsar: _pulsar,
                alBorrar: _borrar,
                alConfirmar: () => _confirmar(l10n),
              ),
              const SizedBox(height: AppEspacio.l),
              SizedBox(
                height: AppEspacio.xxl,
                child: _huellaDisponible && _huellaActivada
                    ? TextButton.icon(
                        onPressed: _intentarHuella,
                        icon: const Icon(Icons.fingerprint),
                        label: Text(l10n.huellaUsar),
                      )
                    : null,
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
