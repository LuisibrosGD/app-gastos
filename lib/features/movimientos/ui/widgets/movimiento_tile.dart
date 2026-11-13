import 'package:flutter/material.dart';

import '../../../../core/database/enums.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/colores.dart';
import '../../../../core/theme/dimensiones.dart';
import '../../../../core/theme/tipografia.dart';
import '../../../../core/utils/moneda.dart';
import '../../../categorias/data/catalogo.dart';
import '../../data/modelos.dart';

class MovimientoTile extends StatelessWidget {
  const MovimientoTile({super.key, required this.item, this.onTap});

  final MovimientoConCategoria item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final movimiento = item.movimiento;
    final categoria = item.categoria;
    final esIngreso = movimiento.tipo == TipoMovimiento.ingreso;
    final nota = movimiento.nota;

    final titulo = (nota == null || nota.isEmpty) ? categoria.nombre : nota;
    final subtitulo = (nota == null || nota.isEmpty)
        ? (esIngreso ? l10n.tipoIngreso : l10n.tipoGasto)
        : categoria.nombre;
    final signo = esIngreso ? '+' : '-';

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppEspacio.m),
        child: Row(
          children: [
            Container(
              width: AppEspacio.xl + AppEspacio.l,
              height: AppEspacio.xl + AppEspacio.l,
              decoration: BoxDecoration(
                color: Color(categoria.color),
                shape: BoxShape.circle,
              ),
              child: Icon(
                iconosCategoria[categoria.icono] ?? Icons.category,
                size: AppEspacio.l + AppEspacio.xs,
                color: AppColores.superficie,
              ),
            ),
            const SizedBox(width: AppEspacio.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: AppTexto.cuerpo,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    subtitulo,
                    style: AppTexto.pequeno.copyWith(
                      color: AppColores.textoSecundario,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppEspacio.s),
            Text(
              '$signo ${formatSoles(movimiento.montoCentimos)}',
              style: AppTexto.cuerpo.copyWith(
                fontWeight: FontWeight.w500,
                color: esIngreso ? AppColores.ingreso : AppColores.gasto,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
