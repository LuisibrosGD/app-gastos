import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/colores.dart';
import '../../../../core/theme/dimensiones.dart';
import '../../../../core/theme/tipografia.dart';
import '../../../movimientos/data/modelos.dart';

class GraficoMeses extends StatelessWidget {
  const GraficoMeses({super.key, required this.totales});

  final List<TotalesMes> totales;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    var mayor = 0.0;
    for (final total in totales) {
      mayor = max(mayor, max(total.ingresos, total.gastos) / 100);
    }
    final maxY = mayor == 0 ? 1.0 : mayor * 1.15;

    return Container(
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
                  l10n.resumenIngresosVsGastos,
                  style: AppTexto.subtitulo,
                ),
              ),
              _leyenda(AppColores.ingreso, l10n.resumenIngresos),
              const SizedBox(width: AppEspacio.m),
              _leyenda(AppColores.gasto, l10n.resumenGastos),
            ],
          ),
          const SizedBox(height: AppEspacio.l),
          SizedBox(
            height: 170,
            child: BarChart(
              BarChartData(
                maxY: maxY,
                alignment: BarChartAlignment.spaceAround,
                barGroups: [
                  for (var i = 0; i < totales.length; i++)
                    BarChartGroupData(
                      x: i,
                      barsSpace: 4,
                      barRods: [
                        _barra(totales[i].ingresos, AppColores.ingreso),
                        _barra(totales[i].gastos, AppColores.gasto),
                      ],
                    ),
                ],
                barTouchData: BarTouchData(enabled: false),
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (valor, meta) {
                        final indice = valor.toInt();
                        if (indice < 0 || indice >= totales.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: AppEspacio.xs),
                          child: Text(
                            _abreviatura(totales[indice].mes, locale),
                            style: AppTexto.pequeno.copyWith(
                              color: AppColores.textoSecundario,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartRodData _barra(int centimos, Color color) {
    return BarChartRodData(
      toY: centimos / 100,
      color: color,
      width: 7,
      borderRadius: BorderRadius.circular(AppRadio.s),
    );
  }

  Widget _leyenda(Color color, String texto) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: AppEspacio.s,
          height: AppEspacio.s,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: AppEspacio.xs),
        Text(
          texto,
          style: AppTexto.pequeno.copyWith(
            color: AppColores.textoSecundario,
          ),
        ),
      ],
    );
  }

  String _abreviatura(DateTime mes, String locale) {
    final texto = DateFormat('MMM', locale).format(mes);
    return texto[0].toUpperCase() + texto.substring(1);
  }
}
