import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/colores.dart';
import '../../../../core/theme/dimensiones.dart';
import '../../../../core/theme/tipografia.dart';
import '../../../../core/utils/moneda.dart';
import '../../domain/progreso.dart';

class BarraProgreso extends StatelessWidget {
  const BarraProgreso({super.key, required this.progreso});

  final ProgresoPresupuesto progreso;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final avance = (progreso.porcentaje / 100).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadio.s),
          child: LinearProgressIndicator(
            value: avance,
            minHeight: AppEspacio.s,
            backgroundColor: AppColores.primarioSuave,
            color: _color(),
          ),
        ),
        const SizedBox(height: AppEspacio.xs),
        Text(
          l10n.gastadoDeLimite(
            formatSoles(progreso.gastado),
            formatSoles(progreso.presupuesto.montoCentimos),
          ),
          style: AppTexto.pequeno.copyWith(
            color: AppColores.textoSecundario,
          ),
        ),
      ],
    );
  }

  Color _color() {
    if (progreso.excedido) return AppColores.gasto;
    if (progreso.enAlerta) return AppColores.alerta;
    return AppColores.primario;
  }
}

class EncabezadoProgreso extends StatelessWidget {
  const EncabezadoProgreso({
    super.key,
    required this.texto,
    required this.porcentaje,
  });

  final String texto;
  final int porcentaje;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Row(
      children: [
        Expanded(child: Text(texto, style: AppTexto.etiqueta)),
        Text(l10n.porcentaje(porcentaje), style: AppTexto.etiqueta),
      ],
    );
  }
}
