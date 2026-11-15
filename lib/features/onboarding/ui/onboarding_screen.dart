import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/colores.dart';
import '../../../core/theme/dimensiones.dart';
import '../../../core/theme/tipografia.dart';
import '../../ajustes/providers/preferencias_providers.dart';
import '../../categorias/providers/categorias_providers.dart';
import '../../seguridad/ui/crear_pin_screen.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _paso = 0;
  bool _creando = false;

  List<String> _nombresGasto(AppLocalizations l10n) => [
    l10n.catComida,
    l10n.catTransporte,
    l10n.catVivienda,
    l10n.catServicios,
    l10n.catSalud,
    l10n.catEntretenimiento,
    l10n.catCompras,
    l10n.catEducacion,
    l10n.catOtrosGasto,
  ];

  List<String> _nombresIngreso(AppLocalizations l10n) => [
    l10n.catSueldo,
    l10n.catExtra,
    l10n.catOtrosIngreso,
  ];

  Future<void> _finalizar(AppLocalizations l10n) async {
    if (_creando) return;
    setState(() => _creando = true);

    try {
      await ref
          .read(categoriasRepositoryProvider)
          .crearPorDefecto(
            gastos: _nombresGasto(l10n),
            ingresos: _nombresIngreso(l10n),
          );
      if (!mounted) return;
      setState(() {
        _creando = false;
        _paso = 2;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _creando = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.errorGuardarCategoria)));
    }
  }

  Future<void> _configurarPin() async {
    final creado = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => const CrearPinScreen(ofrecerHuella: true),
      ),
    );
    if (creado == true) await _completar();
  }

  Future<void> _completar() async {
    await ref.read(onboardingCompletoProvider.notifier).completar();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppEspacio.l),
          child: switch (_paso) {
            0 => _pasoIdioma(l10n),
            1 => _pasoCategorias(l10n),
            _ => _pasoSeguridad(l10n),
          },
        ),
      ),
    );
  }

  Widget _pasoIdioma(AppLocalizations l10n) {
    final idioma = ref.watch(idiomaActualProvider).languageCode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.appTitle, style: AppTexto.subtitulo),
        const SizedBox(height: AppEspacio.xxl),
        Text(l10n.onboardingEligeIdioma, style: AppTexto.titulo),
        const SizedBox(height: AppEspacio.s),
        Text(
          l10n.onboardingAyudaIdioma,
          style: AppTexto.cuerpo.copyWith(color: AppColores.textoSecundario),
        ),
        const SizedBox(height: AppEspacio.xl),
        _OpcionIdioma(
          texto: l10n.idiomaEspanol,
          seleccionado: idioma == 'es',
          alTocar: () => ref.read(idiomaActualProvider.notifier).cambiar('es'),
        ),
        const SizedBox(height: AppEspacio.m),
        _OpcionIdioma(
          texto: l10n.idiomaIngles,
          seleccionado: idioma == 'en',
          alTocar: () => ref.read(idiomaActualProvider.notifier).cambiar('en'),
        ),
        const SizedBox(height: AppEspacio.xxl),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () => setState(() => _paso = 1),
            child: Text(l10n.accionContinuar),
          ),
        ),
      ],
    );
  }

  Widget _pasoSeguridad(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppEspacio.xl),
        const Icon(
          Icons.lock_outline,
          size: 40,
          color: AppColores.primario,
        ),
        const SizedBox(height: AppEspacio.l),
        Text(l10n.protegerTusGastos, style: AppTexto.titulo),
        const SizedBox(height: AppEspacio.s),
        Text(
          l10n.protegerAyuda,
          style: AppTexto.cuerpo.copyWith(color: AppColores.textoSecundario),
        ),
        const SizedBox(height: AppEspacio.xxl),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: _configurarPin,
            child: Text(l10n.configurarPin),
          ),
        ),
        const SizedBox(height: AppEspacio.m),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: _completar,
            child: Text(l10n.ahoraNo),
          ),
        ),
      ],
    );
  }

  Widget _pasoCategorias(AppLocalizations l10n) {
    final gastos = _nombresGasto(l10n);
    final ingresos = _nombresIngreso(l10n);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.onboardingCategoriasTitulo, style: AppTexto.titulo),
        const SizedBox(height: AppEspacio.s),
        Text(
          l10n.onboardingCategoriasAyuda,
          style: AppTexto.cuerpo.copyWith(color: AppColores.textoSecundario),
        ),
        const SizedBox(height: AppEspacio.xl),
        Text(
          l10n.categoriasGastos,
          style: AppTexto.etiqueta.copyWith(color: AppColores.textoSecundario),
        ),
        const SizedBox(height: AppEspacio.s),
        _ChipsCategorias(nombres: gastos, desdeColor: 0),
        const SizedBox(height: AppEspacio.xl),
        Text(
          l10n.categoriasIngresos,
          style: AppTexto.etiqueta.copyWith(color: AppColores.textoSecundario),
        ),
        const SizedBox(height: AppEspacio.s),
        _ChipsCategorias(nombres: ingresos, desdeColor: gastos.length),
        const SizedBox(height: AppEspacio.xxl),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: _creando ? null : () => _finalizar(l10n),
            child: Text(l10n.accionContinuar),
          ),
        ),
      ],
    );
  }
}

class _OpcionIdioma extends StatelessWidget {
  const _OpcionIdioma({
    required this.texto,
    required this.seleccionado,
    required this.alTocar,
  });

  final String texto;
  final bool seleccionado;
  final VoidCallback alTocar;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: alTocar,
      child: Container(
        padding: const EdgeInsets.all(AppEspacio.l),
        decoration: BoxDecoration(
          color: AppColores.superficie,
          borderRadius: BorderRadius.circular(AppRadio.m),
          border: Border.all(
            color: seleccionado ? AppColores.primario : AppColores.borde,
            width: seleccionado ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(child: Text(texto, style: AppTexto.cuerpo)),
            if (seleccionado)
              Icon(
                Icons.check,
                color: AppColores.primario,
                size: IconTheme.of(context).size,
              ),
          ],
        ),
      ),
    );
  }
}

class _ChipsCategorias extends StatelessWidget {
  const _ChipsCategorias({
    required this.nombres,
    required this.desdeColor,
  });

  final List<String> nombres;
  final int desdeColor;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppEspacio.s,
      runSpacing: AppEspacio.s,
      children: [
        for (var i = 0; i < nombres.length; i++)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppEspacio.m,
              vertical: AppEspacio.s,
            ),
            decoration: BoxDecoration(
              color: AppColores.primarioSuave,
              borderRadius: BorderRadius.circular(AppRadio.l),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: AppEspacio.s,
                  height: AppEspacio.s,
                  decoration: BoxDecoration(
                    color:
                        AppColores.categorias[(desdeColor + i) %
                            AppColores.categorias.length],
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppEspacio.s),
                Text(nombres[i], style: AppTexto.etiqueta),
              ],
            ),
          ),
      ],
    );
  }
}
