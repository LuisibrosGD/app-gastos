import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/colores.dart';
import '../../../../core/theme/dimensiones.dart';
import '../../../../core/theme/tipografia.dart';

class SelectorMes extends StatelessWidget {
  const SelectorMes({super.key, required this.mes, required this.onCambio});

  final DateTime mes;
  final ValueChanged<DateTime> onCambio;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;

    return InkWell(
      borderRadius: BorderRadius.circular(AppRadio.l),
      onTap: () async {
        final elegido = await showDialog<DateTime>(
          context: context,
          builder: (_) => _DialogoMes(anio: mes.year, mes: mes.month),
        );
        if (elegido != null) onCambio(elegido);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppEspacio.m,
          vertical: AppEspacio.s,
        ),
        decoration: BoxDecoration(
          color: AppColores.superficie,
          borderRadius: BorderRadius.circular(AppRadio.l),
          border: Border.all(color: AppColores.borde),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _tituloMes(mes, locale),
              style: AppTexto.etiqueta,
            ),
            const SizedBox(width: AppEspacio.xs),
            const Icon(
              Icons.chevron_right,
              size: AppEspacio.l + AppEspacio.xs,
              color: AppColores.textoSecundario,
            ),
          ],
        ),
      ),
    );
  }
}

String _tituloMes(DateTime mes, String locale) {
  final texto = DateFormat('MMMM y', locale).format(mes);
  return texto[0].toUpperCase() + texto.substring(1);
}

class _DialogoMes extends StatefulWidget {
  const _DialogoMes({required this.anio, required this.mes});

  final int anio;
  final int mes;

  @override
  State<_DialogoMes> createState() => _DialogoMesState();
}

class _DialogoMesState extends State<_DialogoMes> {
  late int _anio = widget.anio;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;

    return AlertDialog(
      contentPadding: const EdgeInsets.all(AppEspacio.l),
      content: SizedBox(
        width: 320,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => setState(() => _anio--),
                  icon: const Icon(Icons.chevron_left),
                ),
                Expanded(
                  child: Text(
                    '$_anio',
                    textAlign: TextAlign.center,
                    style: AppTexto.subtitulo,
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() => _anio++),
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
            const SizedBox(height: AppEspacio.s),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              childAspectRatio: 2.2,
              mainAxisSpacing: AppEspacio.s,
              crossAxisSpacing: AppEspacio.s,
              children: [
                for (var i = 1; i <= 12; i++)
                  InkWell(
                    onTap: () => Navigator.of(
                      context,
                    ).pop(DateTime(_anio, i)),
                    borderRadius: BorderRadius.circular(AppRadio.s),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: (_anio == widget.anio && i == widget.mes)
                            ? AppColores.primarioSuave
                            : null,
                        borderRadius: BorderRadius.circular(AppRadio.s),
                      ),
                      child: Text(
                        _nombreMes(i, locale),
                        style: AppTexto.etiqueta,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

String _nombreMes(int mes, String locale) {
  final texto = DateFormat('MMMM', locale).format(DateTime(2026, mes));
  return texto[0].toUpperCase() + texto.substring(1);
}
