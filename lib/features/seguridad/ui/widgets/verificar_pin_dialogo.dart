import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/colores.dart';
import '../../../../core/theme/dimensiones.dart';
import '../../../../core/theme/tipografia.dart';
import '../../providers/bloqueo_providers.dart';
import 'puntos_pin.dart';
import 'teclado_pin.dart';

Future<bool> mostrarVerificarPinDialogo(BuildContext context) async {
  final resultado = await showDialog<bool>(
    context: context,
    builder: (_) => const _VerificarPinDialogo(),
  );
  return resultado ?? false;
}

class _VerificarPinDialogo extends ConsumerStatefulWidget {
  const _VerificarPinDialogo();

  @override
  ConsumerState<_VerificarPinDialogo> createState() =>
      _VerificarPinDialogoState();
}

class _VerificarPinDialogoState extends ConsumerState<_VerificarPinDialogo> {
  String _pin = '';
  late List<int> _orden;
  String? _error;
  bool _verificando = false;
  bool _esperando = false;
  int _restantes = 0;
  Timer? _temporizador;

  @override
  void initState() {
    super.initState();
    _orden = mezclarDigitos(ref.read(randomPinProvider));
  }

  @override
  void dispose() {
    _temporizador?.cancel();
    super.dispose();
  }

  void _pulsar(int numero) {
    if (_esperando || _verificando || _pin.length >= 4) return;
    final pin = '$_pin$numero';
    setState(() {
      _pin = pin;
      _error = null;
    });
    if (pin.length == 4) _verificar();
  }

  void _borrar() {
    if (_esperando || _verificando || _pin.isEmpty) return;
    setState(() {
      _pin = _pin.substring(0, _pin.length - 1);
      _error = null;
    });
  }

  Future<void> _verificar() async {
    if (_esperando || _verificando) return;
    final l10n = AppLocalizations.of(context);
    setState(() => _verificando = true);

    final correcto = await ref
        .read(bloqueoControllerProvider.notifier)
        .verificarPinActual(_pin);
    if (!mounted) return;

    if (correcto) {
      Navigator.of(context).pop(true);
      return;
    }

    final estado = ref.read(bloqueoControllerProvider);
    final espera = estado.esperarHasta;
    if (espera != null && espera.isAfter(ref.read(relojProvider)())) {
      _iniciarEspera(espera);
      return;
    }

    setState(() {
      _verificando = false;
      _pin = '';
      _orden = mezclarDigitos(ref.read(randomPinProvider));
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
      _orden = mezclarDigitos(ref.read(randomPinProvider));
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Dialog(
      insetPadding: const EdgeInsets.all(AppEspacio.xl),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppEspacio.l),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.pinActualTitulo,
              textAlign: TextAlign.center,
              style: AppTexto.subtitulo,
            ),
            const SizedBox(height: AppEspacio.s),
            Text(
              l10n.pinActualAyuda,
              textAlign: TextAlign.center,
              style: AppTexto.pequeno.copyWith(
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
              orden: _orden,
              habilitado: !_esperando && !_verificando,
              alPulsar: _pulsar,
              alBorrar: _borrar,
            ),
            const SizedBox(height: AppEspacio.s),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.accionCancelar),
            ),
          ],
        ),
      ),
    );
  }
}
