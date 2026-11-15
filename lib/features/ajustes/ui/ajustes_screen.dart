import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/colores.dart';
import '../../../core/theme/dimensiones.dart';
import '../../../core/theme/tipografia.dart';
import '../../seguridad/providers/bloqueo_providers.dart';
import '../../seguridad/ui/crear_pin_screen.dart';
import '../providers/preferencias_providers.dart';
import 'widgets/filas_ajustes.dart';

class AjustesScreen extends ConsumerStatefulWidget {
  const AjustesScreen({super.key});

  @override
  ConsumerState<AjustesScreen> createState() => _AjustesScreenState();
}

class _AjustesScreenState extends ConsumerState<AjustesScreen> {
  late bool _bloqueoActivo = ref
      .read(preferenciasRepositoryProvider)
      .bloqueoActivo;
  late bool _usarHuella = ref
      .read(preferenciasRepositoryProvider)
      .usarHuella;

  Future<void> _elegirIdioma(AppLocalizations l10n) async {
    final codigo = await showDialog<String>(
      context: context,
      builder: (contexto) => SimpleDialog(
        title: Text(l10n.idioma),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.of(contexto).pop('es'),
            child: Text(l10n.idiomaEspanol, style: AppTexto.cuerpo),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.of(contexto).pop('en'),
            child: Text(l10n.idiomaIngles, style: AppTexto.cuerpo),
          ),
        ],
      ),
    );
    if (codigo != null) {
      await ref.read(idiomaActualProvider.notifier).cambiar(codigo);
    }
  }

  Future<bool> _verificarPinActual(AppLocalizations l10n) async {
    final servicio = ref.read(pinServiceProvider);
    if (!await servicio.tienePin()) return true;
    if (!mounted) return false;

    final controlador = TextEditingController();
    final pin = await showDialog<String>(
      context: context,
      builder: (contexto) => AlertDialog(
        title: Text(l10n.pinActualTitulo),
        content: TextField(
          controller: controlador,
          autofocus: true,
          obscureText: true,
          keyboardType: TextInputType.number,
          maxLength: 6,
          decoration: InputDecoration(
            labelText: l10n.pinActualAyuda,
            counterText: '',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(contexto).pop(),
            child: Text(l10n.accionCancelar),
          ),
          TextButton(
            onPressed: () => Navigator.of(contexto).pop(controlador.text),
            child: Text(l10n.accionContinuar),
          ),
        ],
      ),
    );
    controlador.dispose();
    if (pin == null) return false;

    final correcto = await ref
        .read(bloqueoControllerProvider.notifier)
        .verificarPinActual(pin);
    if (!correcto && mounted) {
      final estado = ref.read(bloqueoControllerProvider);
      final espera = estado.esperarHasta;
      final ahora = ref.read(relojProvider)();
      final mensaje = espera != null && espera.isAfter(ahora)
          ? l10n.pinEspera(espera.difference(ahora).inSeconds)
          : l10n.pinIncorrecto;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(mensaje)));
    }
    return correcto;
  }

  Future<void> _refrescarSeguridad() async {
    final prefs = ref.read(preferenciasRepositoryProvider);
    if (!mounted) return;
    setState(() {
      _bloqueoActivo = prefs.bloqueoActivo;
      _usarHuella = prefs.usarHuella;
    });
  }

  Future<void> _cambiarBloqueo(
    AppLocalizations l10n,
    bool valor,
  ) async {
    if (valor && !await ref.read(pinServiceProvider).tienePin()) {
      if (!mounted) return;
      final creado = await Navigator.of(context).push<bool>(
        MaterialPageRoute(
          builder: (_) => const CrearPinScreen(ofrecerHuella: true),
        ),
      );
      if (creado == true) await _refrescarSeguridad();
      return;
    }

    if (!await _verificarPinActual(l10n)) return;
    await ref.read(preferenciasRepositoryProvider).setBloqueoActivo(valor);
    if (mounted) setState(() => _bloqueoActivo = valor);
  }

  Future<void> _cambiarPin(AppLocalizations l10n) async {
    if (!await _verificarPinActual(l10n)) return;
    if (!mounted) return;
    await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => const CrearPinScreen(activarBloqueo: false),
      ),
    );
    await _refrescarSeguridad();
  }

  Future<void> _cambiarHuella(bool valor) async {
    await ref.read(preferenciasRepositoryProvider).setUsarHuella(valor);
    if (mounted) setState(() => _usarHuella = valor);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final idioma = ref.watch(idiomaActualProvider).languageCode;
    final huella = ref.watch(biometriaDisponibleProvider).value ?? false;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColores.fondo,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          l10n.ajustesTitulo,
          style: AppTexto.titulo.copyWith(color: AppColores.textoPrincipal),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppEspacio.l),
        children: [
          Text(
            l10n.preferencias,
            style: AppTexto.etiqueta.copyWith(
              color: AppColores.textoSecundario,
            ),
          ),
          const SizedBox(height: AppEspacio.s),
          TarjetaAjustes(
            filas: [
              FilaAjuste(
                texto: l10n.idioma,
                valor: idioma == 'en'
                    ? l10n.idiomaIngles
                    : l10n.idiomaEspanol,
                alTocar: () => _elegirIdioma(l10n),
              ),
              FilaSwitch(
                texto: l10n.bloqueo,
                valor: _bloqueoActivo,
                alCambiar: (valor) => _cambiarBloqueo(l10n, valor),
              ),
              FilaAjuste(
                texto: l10n.cambiarPin,
                alTocar: () => _cambiarPin(l10n),
              ),
              if (huella)
                FilaSwitch(
                  texto: l10n.usarHuella,
                  valor: _usarHuella,
                  alCambiar: _cambiarHuella,
                ),
            ],
          ),
          const SizedBox(height: AppEspacio.xl),
          Text(
            l10n.organizacion,
            style: AppTexto.etiqueta.copyWith(
              color: AppColores.textoSecundario,
            ),
          ),
          const SizedBox(height: AppEspacio.s),
          TarjetaAjustes(
            filas: [
              FilaAjuste(
                texto: l10n.presupuestoTitulo,
                alTocar: () => context.push(Rutas.presupuesto),
              ),
              FilaAjuste(
                texto: l10n.recurrentesTitulo,
                alTocar: () => context.push(Rutas.recurrentes),
              ),
              FilaAjuste(
                texto: l10n.categoriasTitulo,
                alTocar: () => context.push(Rutas.categorias),
              ),
            ],
          ),
          const SizedBox(height: AppEspacio.xxl),
          Text(
            l10n.appVersion,
            textAlign: TextAlign.center,
            style: AppTexto.pequeno.copyWith(
              color: AppColores.textoSecundario,
            ),
          ),
        ],
      ),
    );
  }
}
