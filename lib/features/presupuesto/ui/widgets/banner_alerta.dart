import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/colores.dart';
import '../../../../core/theme/dimensiones.dart';
import '../../../../core/theme/tipografia.dart';
import '../../../../core/utils/moneda.dart';
import '../../domain/progreso.dart';

class BannerAlerta extends StatelessWidget {
  const BannerAlerta({super.key, required this.progresos});

  final List<ProgresoPresupuesto> progresos;

  @override
  Widget build(BuildContext context) {
    final enAlerta = progresos.where((progreso) => progreso.enAlerta).toList();
    if (enAlerta.isEmpty) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    final progreso = enAlerta.first;
    final categoria = progreso.categoria;
    final titulo = categoria == null
        ? l10n.presupuestoAlertaTitulo(progreso.porcentaje)
        : l10n.categoriaAlertaTitulo(categoria.nombre, progreso.porcentaje);

    return Container(
      decoration: BoxDecoration(
        color: AppColores.superficie,
        borderRadius: BorderRadius.circular(AppRadio.m),
        border: Border.all(color: AppColores.borde),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadio.m),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: AppEspacio.xs, color: AppColores.alerta),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppEspacio.l),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titulo,
                        style: AppTexto.cuerpo.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: AppEspacio.xs),
                      Text(
                        l10n.presupuestoAlertaCuerpo(
                          formatSoles(progreso.gastado),
                          formatSoles(progreso.presupuesto.montoCentimos),
                        ),
                        style: AppTexto.etiqueta.copyWith(
                          color: AppColores.textoSecundario,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
