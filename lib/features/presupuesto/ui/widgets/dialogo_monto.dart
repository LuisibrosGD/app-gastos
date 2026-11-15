import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/utils/moneda.dart';
import '../../../movimientos/ui/widgets/campo_monto.dart';

class ResultadoMonto {
  const ResultadoMonto(this.monto);

  final int? monto;
}

Future<ResultadoMonto?> pedirMonto(
  BuildContext context, {
  required String titulo,
  int? inicial,
}) {
  return showDialog<ResultadoMonto>(
    context: context,
    builder: (_) => DialogoMonto(titulo: titulo, inicial: inicial),
  );
}

class DialogoMonto extends StatefulWidget {
  const DialogoMonto({super.key, required this.titulo, this.inicial});

  final String titulo;
  final int? inicial;

  @override
  State<DialogoMonto> createState() => _DialogoMontoState();
}

class _DialogoMontoState extends State<DialogoMonto> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.inicial == null
        ? ''
        : '${widget.inicial! ~/ 100}.'
              '${(widget.inicial! % 100).toString().padLeft(2, '0')}',
  );
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _guardar(AppLocalizations l10n) {
    final texto = _controller.text.trim();
    int? monto;
    if (texto.isNotEmpty) {
      monto = parseSoles(texto);
      if (monto == null) {
        setState(() => _error = l10n.errorMontoFormato);
        return;
      }
      if (monto <= 0) {
        setState(() => _error = l10n.errorMontoMayorACero);
        return;
      }
    }
    Navigator.of(context).pop(ResultadoMonto(monto));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(widget.titulo),
      content: CampoMonto(controller: _controller, errorText: _error),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.accionCancelar),
        ),
        TextButton(
          onPressed: () => _guardar(l10n),
          child: Text(l10n.accionGuardar),
        ),
      ],
    );
  }
}
