import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/colores.dart';
import '../../../core/theme/dimensiones.dart';
import '../../../core/theme/tipografia.dart';
import '../providers/preferencias_providers.dart';

class AjustesScreen extends ConsumerWidget {
  const AjustesScreen({super.key});

  Future<void> _elegirIdioma(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final idioma = ref.watch(idiomaActualProvider).languageCode;

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
          _TarjetaAjustes(
            filas: [
              _FilaAjuste(
                texto: l10n.idioma,
                valor: idioma == 'en'
                    ? l10n.idiomaIngles
                    : l10n.idiomaEspanol,
                alTocar: () => _elegirIdioma(context, ref, l10n),
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
          _TarjetaAjustes(
            filas: [
              _FilaAjuste(
                texto: l10n.presupuestoTitulo,
                alTocar: () => context.push(Rutas.presupuesto),
              ),
              _FilaAjuste(
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

class _TarjetaAjustes extends StatelessWidget {
  const _TarjetaAjustes({required this.filas});

  final List<Widget> filas;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColores.superficie,
        borderRadius: BorderRadius.circular(AppRadio.l),
        border: Border.all(color: AppColores.borde),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadio.l),
        child: Column(
          children: [
            for (var i = 0; i < filas.length; i++) ...[
              if (i > 0) const Divider(height: 1),
              filas[i],
            ],
          ],
        ),
      ),
    );
  }
}

class _FilaAjuste extends StatelessWidget {
  const _FilaAjuste({required this.texto, this.valor, required this.alTocar});

  final String texto;
  final String? valor;
  final VoidCallback alTocar;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: alTocar,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppEspacio.l,
          vertical: AppEspacio.l,
        ),
        child: Row(
          children: [
            Expanded(child: Text(texto, style: AppTexto.cuerpo)),
            if (valor != null)
              Text(
                valor!,
                style: AppTexto.etiqueta.copyWith(
                  color: AppColores.textoSecundario,
                ),
              ),
            const SizedBox(width: AppEspacio.s),
            const Icon(
              Icons.chevron_right,
              size: AppEspacio.xl,
              color: AppColores.textoSecundario,
            ),
          ],
        ),
      ),
    );
  }
}
