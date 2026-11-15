import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/enums.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/colores.dart';
import '../../../core/theme/dimensiones.dart';
import '../../../core/theme/tipografia.dart';
import '../../../core/utils/moneda.dart';
import '../../categorias/data/catalogo.dart';
import '../data/recurrentes_repository.dart';
import '../providers/recurrentes_providers.dart';
import 'widgets/selector_frecuencia.dart';

class RecurrentesScreen extends ConsumerWidget {
  const RecurrentesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final reglas = ref.watch(recurrentesProvider);
    final insetInferior = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColores.fondo,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Navigator.canPop(context) ? const BackButton() : null,
        title: Text(
          l10n.recurrentesTitulo,
          style: AppTexto.titulo.copyWith(color: AppColores.textoPrincipal),
        ),
        actions: [
          TextButton(
            onPressed: () => context.push(Rutas.nuevaRecurrente),
            child: Text(
              l10n.recurrentesNueva,
              style: AppTexto.cuerpo.copyWith(color: AppColores.primario),
            ),
          ),
          const SizedBox(width: AppEspacio.s),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          AppEspacio.l,
          AppEspacio.l,
          AppEspacio.l,
          AppEspacio.l + insetInferior,
        ),
        children: [
          Text(
            l10n.recurrentesAyuda,
            style: AppTexto.pequeno.copyWith(
              color: AppColores.textoSecundario,
            ),
          ),
          const SizedBox(height: AppEspacio.m),
          reglas.when(
            data: (lista) => Column(
              children: [
                for (final item in lista)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppEspacio.m),
                    child: _TarjetaRecurrente(item: item),
                  ),
              ],
            ),
            loading: () => const Padding(
              padding: EdgeInsets.all(AppEspacio.xl),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stackTrace) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _TarjetaRecurrente extends ConsumerWidget {
  const _TarjetaRecurrente({required this.item});

  final RecurrenteConCategoria item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final regla = item.regla;
    final categoria = item.categoria;
    final esIngreso = regla.tipo == TipoMovimiento.ingreso;
    final titulo = (regla.nota == null || regla.nota!.isEmpty)
        ? categoria.nombre
        : regla.nota!;

    return Material(
      color: AppColores.superficie,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadio.l),
        side: const BorderSide(color: AppColores.borde),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadio.l),
        onTap: () => context.push(Rutas.recurrente(regla.id)),
        child: Padding(
          padding: const EdgeInsets.all(AppEspacio.l),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) => Row(
                        children: [
                          Expanded(
                            child: Text(
                              titulo,
                              style: AppTexto.cuerpo,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: AppEspacio.s),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: constraints.maxWidth * 0.65,
                            ),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerRight,
                              child: Text(
                                '${esIngreso ? '+' : '-'} '
                                '${formatSoles(regla.montoCentimos)}',
                                style: AppTexto.cuerpo.copyWith(
                                  color: esIngreso
                                      ? AppColores.ingreso
                                      : AppColores.gasto,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppEspacio.xs),
                    Text(
                      _subtitulo(l10n, regla),
                      style: AppTexto.pequeno.copyWith(
                        color: AppColores.textoSecundario,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppEspacio.s),
              Switch(
                value: regla.activo,
                onChanged: (valor) =>
                    _cambiarActivo(context, ref, regla, valor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _subtitulo(AppLocalizations l10n, Recurrente regla) {
    if (regla.frecuencia == Frecuencia.mensual) {
      return l10n.recurrenteMensual(regla.dia);
    }
    return l10n.recurrenteSemanal(etiquetaDiaSemana(l10n, regla.dia));
  }

  Future<void> _cambiarActivo(
    BuildContext context,
    WidgetRef ref,
    Recurrente regla,
    bool valor,
  ) async {
    final l10n = AppLocalizations.of(context);
    try {
      await ref
          .read(recurrentesRepositoryProvider)
          .actualizar(
            regla.id,
            RecurrenteInput(
              tipo: regla.tipo,
              montoCentimos: regla.montoCentimos,
              categoriaId: regla.categoriaId,
              nota: regla.nota,
              frecuencia: regla.frecuencia,
              dia: regla.dia,
              fechaInicio: regla.fechaInicio,
              activo: valor,
            ),
          );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.errorGuardarRecurrente)),
      );
    }
  }
}
