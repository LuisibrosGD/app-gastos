import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/enums.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/colores.dart';
import '../../../core/theme/dimensiones.dart';
import '../../../core/theme/tipografia.dart';
import '../../../core/utils/fechas.dart';
import '../../../core/utils/moneda.dart';
import '../../categorias/providers/categorias_providers.dart';
import '../data/notificador.dart';
import '../domain/progreso.dart';
import '../providers/presupuesto_providers.dart';
import 'widgets/barra_progreso.dart';
import 'widgets/dialogo_monto.dart';

class PresupuestoScreen extends ConsumerWidget {
  const PresupuestoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final mes = inicioMes(DateTime.now());
    final progresos = ref.watch(progresoPresupuestoProvider(mes));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColores.fondo,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          l10n.presupuestoTitulo,
          style: AppTexto.titulo.copyWith(color: AppColores.textoPrincipal),
        ),
      ),
      body: progresos.when(
        data: (lista) => _Contenido(progresos: lista),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text(
            l10n.errorCargarPresupuesto,
            style: AppTexto.cuerpo,
          ),
        ),
      ),
    );
  }
}

class _Contenido extends ConsumerWidget {
  const _Contenido({required this.progresos});

  final List<ProgresoPresupuesto> progresos;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final categorias =
        ref.watch(categoriasPorTipoProvider(TipoMovimiento.gasto)).value ??
        const <Categoria>[];
    final total = _buscarTotal();
    final porCategoria = progresos
        .where((progreso) => progreso.categoria != null)
        .toList();
    final esPrimero = progresos.isEmpty;
    final insetInferior = MediaQuery.paddingOf(context).bottom;

    return ListView(
      padding: EdgeInsets.fromLTRB(
        AppEspacio.l,
        AppEspacio.l,
        AppEspacio.l,
        AppEspacio.l + insetInferior,
      ),
      children: [
        Container(
          padding: const EdgeInsets.all(AppEspacio.l),
          decoration: BoxDecoration(
            color: AppColores.superficie,
            borderRadius: BorderRadius.circular(AppRadio.l),
            border: Border.all(color: AppColores.borde),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.totalMensual,
                      style: AppTexto.etiqueta.copyWith(
                        color: AppColores.textoSecundario,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => _editarTotal(context, ref, esPrimero),
                    child: Text(
                      l10n.editar,
                      style: AppTexto.etiqueta.copyWith(
                        color: AppColores.primario,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                total == null
                    ? l10n.presupuestoSinDefinir
                    : formatSoles(total.presupuesto.montoCentimos),
                style: AppTexto.montoGrande,
              ),
            ],
          ),
        ),
        if (total != null) ...[
          const SizedBox(height: AppEspacio.l),
          EncabezadoProgreso(
            texto: l10n.gastadoEsteMes,
            porcentaje: total.porcentaje,
          ),
          const SizedBox(height: AppEspacio.xs),
          BarraProgreso(progreso: total),
        ],
        const SizedBox(height: AppEspacio.xl),
        Text(l10n.porCategoria, style: AppTexto.subtitulo),
        for (final progreso in porCategoria)
          Padding(
            padding: const EdgeInsets.only(top: AppEspacio.l),
            child: InkWell(
              onTap: () => _editarCategoria(
                context,
                ref,
                progreso.categoria!,
                esPrimero,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EncabezadoProgreso(
                    texto: progreso.categoria!.nombre,
                    porcentaje: progreso.porcentaje,
                  ),
                  const SizedBox(height: AppEspacio.xs),
                  BarraProgreso(progreso: progreso),
                ],
              ),
            ),
          ),
        const SizedBox(height: AppEspacio.xl),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () =>
                _anadirCategoria(context, ref, esPrimero, categorias),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
              foregroundColor: AppColores.primario,
              side: const BorderSide(color: AppColores.borde),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadio.m),
              ),
            ),
            child: Text(
              l10n.anadirLimiteCategoria,
              style: AppTexto.cuerpo.copyWith(color: AppColores.primario),
            ),
          ),
        ),
      ],
    );
  }

  ProgresoPresupuesto? _buscarTotal() {
    for (final progreso in progresos) {
      if (progreso.categoria == null) return progreso;
    }
    return null;
  }

  ProgresoPresupuesto? _buscarCategoria(int categoriaId) {
    for (final progreso in progresos) {
      if (progreso.categoria?.id == categoriaId) return progreso;
    }
    return null;
  }

  Future<void> _editarTotal(
    BuildContext context,
    WidgetRef ref,
    bool esPrimero,
  ) async {
    final l10n = AppLocalizations.of(context);
    final total = _buscarTotal();
    final resultado = await pedirMonto(
      context,
      titulo: l10n.totalMensual,
      inicial: total?.presupuesto.montoCentimos,
    );
    if (resultado == null) return;

    await ref.read(presupuestosRepositoryProvider).guardarTotal(resultado.monto);
    if (resultado.monto != null && esPrimero) {
      await _pedirPermiso(ref);
    }
  }

  Future<void> _editarCategoria(
    BuildContext context,
    WidgetRef ref,
    Categoria categoria,
    bool esPrimero,
  ) async {
    final actual = _buscarCategoria(categoria.id);
    final resultado = await pedirMonto(
      context,
      titulo: categoria.nombre,
      inicial: actual?.presupuesto.montoCentimos,
    );
    if (resultado == null) return;

    await ref
        .read(presupuestosRepositoryProvider)
        .guardarCategoria(categoria.id, resultado.monto);
    if (resultado.monto != null && esPrimero) {
      await _pedirPermiso(ref);
    }
  }

  Future<void> _anadirCategoria(
    BuildContext context,
    WidgetRef ref,
    bool esPrimero,
    List<Categoria> categorias,
  ) async {
    final l10n = AppLocalizations.of(context);
    if (categorias.isEmpty) return;

    final categoria = await showDialog<Categoria>(
      context: context,
      builder: (contexto) => SimpleDialog(
        title: Text(l10n.elegirCategoria),
        children: [
          for (final item in categorias)
            SimpleDialogOption(
              onPressed: () => Navigator.of(contexto).pop(item),
              child: Text(item.nombre, style: AppTexto.cuerpo),
            ),
        ],
      ),
    );
    if (categoria == null || !context.mounted) return;

    await _editarCategoria(context, ref, categoria, esPrimero);
  }

  Future<void> _pedirPermiso(WidgetRef ref) async {
    try {
      final notificador = ref.read(notificadorProvider);
      if (notificador is NotificadorLocal) {
        await notificador.pedirPermiso();
      }
    } catch (_) {}
  }
}

