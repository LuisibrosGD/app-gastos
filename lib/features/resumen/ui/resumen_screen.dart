import 'package:flutter/material.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/colores.dart';
import '../../../core/theme/tipografia.dart';

class ResumenScreen extends StatelessWidget {
  const ResumenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

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
      ),
      body: const SizedBox.shrink(),
    );
  }
}
