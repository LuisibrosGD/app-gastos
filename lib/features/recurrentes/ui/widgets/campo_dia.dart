import 'package:flutter/material.dart';

import '../../../../core/database/enums.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/tipografia.dart';
import 'selector_frecuencia.dart';

class CampoDia extends StatelessWidget {
  const CampoDia({
    super.key,
    required this.frecuencia,
    required this.dia,
    this.errorText,
    required this.alCambiar,
  });

  final Frecuencia frecuencia;
  final int dia;
  final String? errorText;
  final ValueChanged<int> alCambiar;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return DropdownButtonFormField<int>(
      key: ValueKey('${frecuencia.name}-$dia'),
      initialValue: dia,
      decoration: InputDecoration(errorText: errorText),
      items: [
        for (var valor = 1;
            valor <= (frecuencia == Frecuencia.mensual ? 31 : 7);
            valor++)
          DropdownMenuItem(
            value: valor,
            child: Text(
              frecuencia == Frecuencia.mensual
                  ? l10n.diaDelMes(valor)
                  : etiquetaDiaSemana(l10n, valor),
              style: AppTexto.cuerpo,
            ),
          ),
      ],
      onChanged: (valor) {
        if (valor != null) alCambiar(valor);
      },
    );
  }
}
