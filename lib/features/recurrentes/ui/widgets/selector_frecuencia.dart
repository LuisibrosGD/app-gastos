import 'package:flutter/material.dart';

import '../../../../core/database/enums.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/colores.dart';
import '../../../../core/theme/dimensiones.dart';
import '../../../../core/theme/tipografia.dart';

class SelectorFrecuencia extends StatelessWidget {
  const SelectorFrecuencia({
    super.key,
    required this.frecuencia,
    required this.alCambiar,
  });

  final Frecuencia frecuencia;
  final ValueChanged<Frecuencia> alCambiar;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(AppEspacio.xs),
      decoration: BoxDecoration(
        color: AppColores.primarioSuave,
        borderRadius: BorderRadius.circular(AppRadio.m),
      ),
      child: Row(
        children: [
          _opcion(l10n.frecuenciaMensual, Frecuencia.mensual),
          _opcion(l10n.frecuenciaSemanal, Frecuencia.semanal),
        ],
      ),
    );
  }

  Widget _opcion(String texto, Frecuencia valor) {
    final activa = frecuencia == valor;

    return Expanded(
      child: GestureDetector(
        onTap: () => alCambiar(valor),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: AppEspacio.m),
          decoration: BoxDecoration(
            color: activa ? AppColores.primario : null,
            borderRadius: BorderRadius.circular(AppRadio.s),
          ),
          child: Text(
            texto,
            style: AppTexto.cuerpo.copyWith(
              color: activa
                  ? AppColores.superficie
                  : AppColores.textoSecundario,
            ),
          ),
        ),
      ),
    );
  }
}

String etiquetaDiaSemana(AppLocalizations l10n, int dia) {
  return switch (dia) {
    1 => l10n.diaLunes,
    2 => l10n.diaMartes,
    3 => l10n.diaMiercoles,
    4 => l10n.diaJueves,
    5 => l10n.diaViernes,
    6 => l10n.diaSabado,
    _ => l10n.diaDomingo,
  };
}
