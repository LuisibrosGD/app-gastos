import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/colores.dart';
import '../../../../core/theme/dimensiones.dart';
import '../../../../core/theme/tipografia.dart';
import '../../../../core/utils/moneda.dart';
import '../../../movimientos/data/modelos.dart';

class TarjetaBalance extends StatelessWidget {
  const TarjetaBalance({super.key, required this.totales});

  final TotalesMes totales;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final idioma = Localizations.localeOf(context).languageCode;
    final nombreMes = DateFormat('MMMM', idioma).format(totales.mes);

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
          Text(
            l10n.balanceDeMes(nombreMes),
            style: AppTexto.etiqueta.copyWith(
              color: AppColores.textoSecundario,
            ),
          ),
          const SizedBox(height: AppEspacio.s),
          Text(formatSoles(totales.balance), style: AppTexto.montoGrande),
          const SizedBox(height: AppEspacio.m),
          Wrap(
            spacing: AppEspacio.s,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                '${l10n.categoriasIngresos} ${formatSoles(totales.ingresos)}',
                style: AppTexto.pequeno.copyWith(color: AppColores.ingreso),
              ),
              Text(
                '·',
                style: AppTexto.pequeno.copyWith(
                  color: AppColores.textoSecundario,
                ),
              ),
              Text(
                '${l10n.categoriasGastos} ${formatSoles(totales.gastos)}',
                style: AppTexto.pequeno.copyWith(color: AppColores.gasto),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
