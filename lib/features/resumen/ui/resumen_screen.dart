import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/colores.dart';
import '../../../core/theme/dimensiones.dart';
import '../../../core/theme/tipografia.dart';
import '../../../core/utils/fechas.dart';
import '../../movimientos/ui/widgets/selector_mes.dart';
import '../providers/resumen_providers.dart';
import 'widgets/grafico_categorias.dart';
import 'widgets/grafico_meses.dart';

class ResumenScreen extends ConsumerStatefulWidget {
  const ResumenScreen({super.key});

  @override
  ConsumerState<ResumenScreen> createState() => _ResumenScreenState();
}

class _ResumenScreenState extends ConsumerState<ResumenScreen> {
  late DateTime _mes = inicioMes(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final gastos = ref.watch(gastosPorCategoriaProvider(_mes));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColores.fondo,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          l10n.resumenTitulo,
          style: AppTexto.titulo.copyWith(color: AppColores.textoPrincipal),
        ),
        actions: [
          SelectorMes(
            mes: _mes,
            onCambio: (mes) => setState(() => _mes = inicioMes(mes)),
          ),
          const SizedBox(width: AppEspacio.l),
        ],
      ),
      body: gastos.when(
        data: (lista) => lista.isEmpty
            ? _SinDatos(mes: _mes)
            : ListView(
                padding: const EdgeInsets.all(AppEspacio.l),
                children: [
                  GraficoCategorias(gastos: lista),
                  const SizedBox(height: AppEspacio.m),
                  _Meses(mesFinal: _mes),
                ],
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => const SizedBox.shrink(),
      ),
    );
  }
}

class _Meses extends ConsumerWidget {
  const _Meses({required this.mesFinal});

  final DateTime mesFinal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totales = ref.watch(ultimosMesesProvider(mesFinal));

    return totales.when(
      data: (lista) => GraficoMeses(totales: lista),
      loading: () => const SizedBox(height: 240),
      error: (error, stackTrace) => const SizedBox.shrink(),
    );
  }
}

class _SinDatos extends StatelessWidget {
  const _SinDatos({required this.mes});

  final DateTime mes;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final nombre = DateFormat('MMMM', locale).format(mes);

    return ListView(
      padding: const EdgeInsets.all(AppEspacio.l),
      children: [
        Container(
          padding: const EdgeInsets.all(AppEspacio.xl),
          decoration: BoxDecoration(
            color: AppColores.superficie,
            borderRadius: BorderRadius.circular(AppRadio.l),
            border: Border.all(color: AppColores.borde),
          ),
          child: Column(
            children: [
              const Icon(
                Icons.pie_chart_outline,
                size: AppEspacio.xxl,
                color: AppColores.primario,
              ),
              const SizedBox(height: AppEspacio.l),
              Text(
                l10n.resumenSinDatosTitulo(nombre),
                textAlign: TextAlign.center,
                style: AppTexto.subtitulo,
              ),
              const SizedBox(height: AppEspacio.m),
              Text(
                l10n.resumenSinDatosCuerpo,
                textAlign: TextAlign.center,
                style: AppTexto.etiqueta.copyWith(
                  color: AppColores.textoSecundario,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
