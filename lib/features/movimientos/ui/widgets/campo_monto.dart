import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/tipografia.dart';

class CampoMonto extends StatelessWidget {
  const CampoMonto({
    super.key,
    required this.controller,
    this.errorText,
    this.validator,
  });

  final TextEditingController controller;
  final String? errorText;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: AppTexto.titulo,
      decoration: InputDecoration(
        prefixText: l10n.prefijoSoles,
        errorText: errorText,
      ),
    );
  }
}
