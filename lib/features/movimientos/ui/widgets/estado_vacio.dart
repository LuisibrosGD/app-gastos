import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/colores.dart';
import '../../../../core/theme/dimensiones.dart';
import '../../../../core/theme/tipografia.dart';

class EstadoVacio extends StatelessWidget {
  const EstadoVacio({
    super.key,
    required this.mes,
    required this.idioma,
    required this.alRegistrar,
  });

  final DateTime mes;
  final String idioma;
  final VoidCallback alRegistrar;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final nombreMes = DateFormat('MMMM', idioma).format(mes);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppEspacio.l),
        child: Column(
          children: [
            const Icon(
              Icons.credit_card_outlined,
              size: AppEspacio.xxl,
              color: AppColores.primario,
            ),
            const SizedBox(height: AppEspacio.l),
            Text(
              l10n.sinMovimientosMes(nombreMes),
              textAlign: TextAlign.center,
              style: AppTexto.subtitulo,
            ),
            const SizedBox(height: AppEspacio.s),
            Text(
              l10n.sinMovimientosAyuda,
              textAlign: TextAlign.center,
              style: AppTexto.cuerpo.copyWith(
                color: AppColores.textoSecundario,
              ),
            ),
            const SizedBox(height: AppEspacio.xl),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: alRegistrar,
                child: Text(l10n.registrarPrimero),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
