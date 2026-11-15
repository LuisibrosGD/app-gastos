import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/colores.dart';
import '../../../../core/theme/dimensiones.dart';
import '../../../../core/theme/tipografia.dart';

class CampoNota extends StatelessWidget {
  const CampoNota({super.key, required this.controller, this.errorText});

  final TextEditingController controller;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.campoNotaOpcional, style: AppTexto.etiqueta),
        const SizedBox(height: AppEspacio.s),
        TextField(
          controller: controller,
          maxLength: 200,
          style: AppTexto.cuerpo,
          decoration: InputDecoration(
            hintText: l10n.notaEjemplo,
            errorText: errorText,
            counterText: '',
          ),
        ),
      ],
    );
  }
}

class CampoActiva extends StatelessWidget {
  const CampoActiva({
    super.key,
    required this.valor,
    required this.alCambiar,
  });

  final bool valor;
  final ValueChanged<bool> alCambiar;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Row(
      children: [
        Expanded(child: Text(l10n.activa, style: AppTexto.cuerpo)),
        Switch(value: valor, onChanged: alCambiar),
      ],
    );
  }
}

Future<bool> confirmarEliminarRecurrente(
  BuildContext context,
  AppLocalizations l10n,
) async {
  final confirmado = await showDialog<bool>(
    context: context,
    builder: (contexto) => AlertDialog(
      title: Text(l10n.confirmarBorrarRecurrenteTitulo),
      content: Text(l10n.confirmarBorrarRecurrenteMensaje),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(contexto).pop(false),
          child: Text(l10n.accionCancelar),
        ),
        TextButton(
          onPressed: () => Navigator.of(contexto).pop(true),
          child: Text(
            l10n.accionEliminar,
            style: const TextStyle(color: AppColores.error),
          ),
        ),
      ],
    ),
  );
  return confirmado ?? false;
}
