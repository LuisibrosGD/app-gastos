import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/colores.dart';
import '../../../../core/theme/dimensiones.dart';
import '../../../../core/theme/tipografia.dart';
import '../../../../core/utils/moneda.dart';
import '../../data/resumen_repository.dart';

class GraficoCategorias extends StatelessWidget {
  const GraficoCategorias({super.key, required this.gastos});

  final List<GastoPorCategoria> gastos;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final total = gastos.fold<int>(0, (acc, item) => acc + item.totalCentimos);

    return Container(
      padding: const EdgeInsets.all(AppEspacio.l),
      decoration: BoxDecoration(
        color: AppColores.superficie,
        borderRadius: BorderRadius.circular(AppRadio.l),
        border: Border.all(color: AppColores.borde),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 148,
            height: 148,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sections: [
                      for (final item in gastos)
                        PieChartSectionData(
                          value: item.totalCentimos.toDouble(),
                          color: Color(item.categoria.color),
                          radius: 22,
                          showTitle: false,
                        ),
                    ],
                    centerSpaceRadius: 48,
                    sectionsSpace: 2,
                    startDegreeOffset: -90,
                    pieTouchData: PieTouchData(enabled: false),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(formatSoles(total), style: AppTexto.etiqueta),
                    Text(
                      l10n.resumenGastos,
                      style: AppTexto.pequeno.copyWith(
                        color: AppColores.textoSecundario,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppEspacio.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final item in gastos)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppEspacio.xs),
                    child: Row(
                      children: [
                        Container(
                          width: AppEspacio.s,
                          height: AppEspacio.s,
                          decoration: BoxDecoration(
                            color: Color(item.categoria.color),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: AppEspacio.s),
                        Expanded(
                          child: Text(
                            item.categoria.nombre,
                            style: AppTexto.pequeno,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: AppEspacio.xs),
                        Text(
                          l10n.porcentaje(item.porcentaje.round()),
                          style: AppTexto.pequeno.copyWith(
                            color: AppColores.textoSecundario,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
