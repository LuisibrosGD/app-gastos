import 'package:flutter/material.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/enums.dart';
import '../../../../core/errors.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/colores.dart';
import '../../../../core/theme/dimensiones.dart';
import '../../../../core/theme/tipografia.dart';

String mensajeValidacion(AppLocalizations l10n, ValidacionException error) {
  return switch ('${error.campo}/${error.codigo}') {
    'monto/mayorACero' => l10n.errorMontoMayorACero,
    'monto/muyGrande' => l10n.errorMontoMuyGrande,
    'nota/muyLargo' => l10n.errorNotaMuyLargo,
    'categoria/requerido' => l10n.errorCategoriaRequerida,
    'categoria/tipoNoCoincide' => l10n.errorCategoriaTipoNoCoincide,
    _ => l10n.errorGuardarMovimiento,
  };
}

class CampoFecha extends StatelessWidget {
  const CampoFecha({
    super.key,
    required this.texto,
    required this.alTocar,
  });

  final String texto;
  final VoidCallback alTocar;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadio.m),
      onTap: alTocar,
      child: Container(
        padding: const EdgeInsets.all(AppEspacio.l),
        decoration: BoxDecoration(
          color: AppColores.superficie,
          borderRadius: BorderRadius.circular(AppRadio.m),
          border: Border.all(color: AppColores.borde),
        ),
        child: Text(texto, style: AppTexto.cuerpo),
      ),
    );
  }
}

class MensajeCarga extends StatelessWidget {
  const MensajeCarga({super.key, required this.texto});

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(texto, style: AppTexto.cuerpo)));
  }
}

class SelectorTipoMovimiento extends StatelessWidget {
  const SelectorTipoMovimiento({
    super.key,
    required this.tipo,
    required this.alCambiar,
  });

  final TipoMovimiento tipo;
  final ValueChanged<TipoMovimiento> alCambiar;

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
          _opcion(l10n.tipoGasto, TipoMovimiento.gasto),
          _opcion(l10n.tipoIngreso, TipoMovimiento.ingreso),
        ],
      ),
    );
  }

  Widget _opcion(String texto, TipoMovimiento valor) {
    final activo = tipo == valor;

    return Expanded(
      child: GestureDetector(
        onTap: () => alCambiar(valor),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: AppEspacio.m),
          decoration: BoxDecoration(
            color: activo ? AppColores.primario : null,
            borderRadius: BorderRadius.circular(AppRadio.s),
          ),
          child: Text(
            texto,
            style: AppTexto.cuerpo.copyWith(
              color: activo
                  ? AppColores.superficie
                  : AppColores.textoSecundario,
            ),
          ),
        ),
      ),
    );
  }
}

class ChipCategoria extends StatelessWidget {
  const ChipCategoria({
    super.key,
    required this.categoria,
    required this.seleccionada,
    required this.alTocar,
  });

  final Categoria categoria;
  final bool seleccionada;
  final VoidCallback alTocar;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: alTocar,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppEspacio.m,
          vertical: AppEspacio.s,
        ),
        decoration: BoxDecoration(
          color: AppColores.primarioSuave,
          borderRadius: BorderRadius.circular(AppRadio.l),
          border: seleccionada
              ? Border.all(color: AppColores.primario)
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: AppEspacio.s,
              height: AppEspacio.s,
              decoration: BoxDecoration(
                color: Color(categoria.color),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppEspacio.s),
            Text(categoria.nombre, style: AppTexto.etiqueta),
          ],
        ),
      ),
    );
  }
}
