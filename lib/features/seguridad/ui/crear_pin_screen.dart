import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/colores.dart';
import '../../../core/theme/dimensiones.dart';
import '../../../core/theme/tipografia.dart';
import '../../ajustes/providers/preferencias_providers.dart';
import '../providers/bloqueo_providers.dart';
import 'widgets/puntos_pin.dart';
import 'widgets/teclado_pin.dart';

class CrearPinScreen extends ConsumerStatefulWidget {
  const CrearPinScreen({
    super.key,
    this.ofrecerHuella = false,
    this.activarBloqueo = true,
  });

  final bool ofrecerHuella;
  final bool activarBloqueo;

  @override
  ConsumerState<CrearPinScreen> createState() => _CrearPinScreenState();
}

class _CrearPinScreenState extends ConsumerState<CrearPinScreen> {
  String _pin = '';
  String? _primerPin;
  late List<int> _orden;
  String? _error;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _orden = mezclarDigitos(ref.read(randomPinProvider));
  }

  void _pulsar(int numero) {
    if (_guardando || _pin.length >= 4) return;
    final pin = '$_pin$numero';
    setState(() {
      _pin = pin;
      _error = null;
    });
    if (pin.length == 4) _procesar();
  }

  void _borrar() {
    if (_guardando || _pin.isEmpty) return;
    setState(() {
      _pin = _pin.substring(0, _pin.length - 1);
      _error = null;
    });
  }

  Future<void> _procesar() async {
    if (_guardando) return;
    final l10n = AppLocalizations.of(context);

    if (_primerPin == null) {
      setState(() {
        _primerPin = _pin;
        _pin = '';
        _error = null;
      });
      return;
    }

    if (_pin != _primerPin) {
      setState(() {
        _pin = '';
        _orden = mezclarDigitos(ref.read(randomPinProvider));
        _error = l10n.errorPinNoCoincide;
      });
      return;
    }

    await _guardar(l10n);
  }

  Future<void> _guardar(AppLocalizations l10n) async {
    setState(() => _guardando = true);
    try {
      await ref.read(pinServiceProvider).guardarPin(_pin);
      if (widget.activarBloqueo) {
        await ref
            .read(preferenciasRepositoryProvider)
            .setBloqueoActivo(true);
      }

      if (widget.ofrecerHuella) {
        final disponible = await ref
            .read(biometriaServiceProvider)
            .disponible();
        if (disponible && mounted) {
          final usar = await _preguntarHuella(l10n);
          if (usar == true) {
            await ref
                .read(preferenciasRepositoryProvider)
                .setUsarHuella(true);
          }
        }
      }

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } on ValidacionException {
      setState(() {
        _guardando = false;
        _error = l10n.errorPinFormato;
        _pin = '';
        _orden = mezclarDigitos(ref.read(randomPinProvider));
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _guardando = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.errorGuardarPin)));
    }
  }

  Future<bool?> _preguntarHuella(AppLocalizations l10n) {
    return showDialog<bool>(
      context: context,
      builder: (contexto) => AlertDialog(
        title: Text(l10n.huellaPreguntaTitulo),
        content: Text(l10n.huellaPreguntaMensaje),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(contexto).pop(false),
            child: Text(l10n.ahoraNo),
          ),
          TextButton(
            onPressed: () => Navigator.of(contexto).pop(true),
            child: Text(l10n.accionSi),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColores.fondo,
      appBar: AppBar(
        backgroundColor: AppColores.fondo,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          l10n.crearPinTitulo,
          style: AppTexto.titulo.copyWith(color: AppColores.textoPrincipal),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppEspacio.l),
          child: Column(
            children: [
              const SizedBox(height: AppEspacio.xl),
              const Icon(
                Icons.lock_outline,
                size: 40,
                color: AppColores.primario,
              ),
              const SizedBox(height: AppEspacio.l),
              Text(
                _primerPin == null
                    ? l10n.crearPinIntroduce
                    : l10n.crearPinRepite,
                textAlign: TextAlign.center,
                style: AppTexto.cuerpo.copyWith(
                  color: AppColores.textoSecundario,
                ),
              ),
              const SizedBox(height: AppEspacio.l),
              PuntosPin(rellenos: _pin.length),
              const SizedBox(height: AppEspacio.m),
              SizedBox(
                height: AppEspacio.xl,
                child: _error == null
                    ? null
                    : Text(
                        _error!,
                        style: AppTexto.pequeno.copyWith(
                          color: AppColores.error,
                        ),
                      ),
              ),
              const SizedBox(height: AppEspacio.m),
              TecladoPin(
                orden: _orden,
                habilitado: !_guardando,
                alPulsar: _pulsar,
                alBorrar: _borrar,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
