import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/enums.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/colores.dart';
import '../../../core/theme/dimensiones.dart';
import '../../../core/theme/tipografia.dart';
import '../data/catalogo.dart';
import '../providers/categorias_providers.dart';
import 'categoria_form_sheet.dart';

class CategoriasScreen extends ConsumerWidget {
  const CategoriasScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColores.fondo,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        leading: Navigator.canPop(context) ? const BackButton() : null,
        title: Text(
          l10n.categoriasTitulo,
          style: AppTexto.titulo.copyWith(color: AppColores.textoPrincipal),
        ),
        actions: [
          TextButton(
            onPressed: () => CategoriaFormSheet.mostrar(context),
            child: Text(
              l10n.categoriasNueva,
              style: AppTexto.cuerpo.copyWith(color: AppColores.primario),
            ),
          ),
          const SizedBox(width: AppEspacio.s),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppEspacio.l),
        children: [
          _SeccionCategorias(
            titulo: l10n.categoriasGastos,
            tipo: TipoMovimiento.gasto,
          ),
          const SizedBox(height: AppEspacio.xl),
          _SeccionCategorias(
            titulo: l10n.categoriasIngresos,
            tipo: TipoMovimiento.ingreso,
          ),
          _SeccionArchivadas(titulo: l10n.categoriasArchivadas),
        ],
      ),
    );
  }
}

class _SeccionArchivadas extends ConsumerWidget {
  const _SeccionArchivadas({required this.titulo});

  final String titulo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final archivadas = ref.watch(categoriasArchivadasProvider);

    return archivadas.when(
      data: (lista) => lista.isEmpty
          ? const SizedBox.shrink()
          : Padding(
              padding: const EdgeInsets.only(top: AppEspacio.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: AppTexto.etiqueta.copyWith(
                      color: AppColores.textoSecundario,
                    ),
                  ),
                  const SizedBox(height: AppEspacio.s),
                  _TarjetaCategorias(categorias: lista),
                ],
              ),
            ),
      loading: () => const SizedBox.shrink(),
      error: (error, stackTrace) => const SizedBox.shrink(),
    );
  }
}

class _SeccionCategorias extends ConsumerWidget {
  const _SeccionCategorias({required this.titulo, required this.tipo});

  final String titulo;
  final TipoMovimiento tipo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categorias = ref.watch(categoriasPorTipoProvider(tipo));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: AppTexto.etiqueta.copyWith(color: AppColores.textoSecundario),
        ),
        const SizedBox(height: AppEspacio.s),
        categorias.when(
          data: (lista) => lista.isEmpty
              ? const SizedBox.shrink()
              : _TarjetaCategorias(categorias: lista),
          loading: () => const Padding(
            padding: EdgeInsets.all(AppEspacio.xl),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, stackTrace) => const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _TarjetaCategorias extends StatelessWidget {
  const _TarjetaCategorias({required this.categorias});

  final List<Categoria> categorias;

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
            for (var i = 0; i < categorias.length; i++) ...[
              if (i > 0) const Divider(height: 1, indent: AppEspacio.xxl + AppEspacio.xl),
              _FilaCategoria(categoria: categorias[i]),
            ],
          ],
        ),
      ),
    );
  }
}

class _FilaCategoria extends StatelessWidget {
  const _FilaCategoria({required this.categoria});

  final Categoria categoria;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return InkWell(
      onTap: () => CategoriaFormSheet.mostrar(context, categoria: categoria),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppEspacio.l,
          vertical: AppEspacio.m,
        ),
        child: Row(
          children: [
            Container(
              width: AppEspacio.xxl,
              height: AppEspacio.xxl,
              decoration: BoxDecoration(
                color: Color(categoria.color),
                shape: BoxShape.circle,
              ),
              child: Icon(
                iconosCategoria[categoria.icono] ?? Icons.category,
                size: AppEspacio.xl - AppEspacio.xs,
                color: AppColores.superficie,
              ),
            ),
            const SizedBox(width: AppEspacio.m),
            Expanded(
              child: Text(
                categoria.nombre,
                style: AppTexto.cuerpo,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (categoria.archivada) ...[
              Text(
                l10n.categoriaArchivada,
                style: AppTexto.pequeno.copyWith(
                  color: AppColores.textoSecundario,
                ),
              ),
              const SizedBox(width: AppEspacio.s),
            ],
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
