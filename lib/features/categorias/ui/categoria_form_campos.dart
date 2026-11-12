import 'package:flutter/material.dart';

import '../../../core/database/enums.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/colores.dart';
import '../../../core/theme/dimensiones.dart';
import '../../../core/theme/tipografia.dart';

class SelectorTipo extends StatelessWidget {
  const SelectorTipo({
    super.key,
    required this.tipo,
    required this.habilitado,
    required this.alCambiar,
  });

  final TipoMovimiento tipo;
  final bool habilitado;
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
        onTap: habilitado ? () => alCambiar(valor) : null,
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

class BotonIcono extends StatelessWidget {
  const BotonIcono({
    super.key,
    required this.icono,
    required this.seleccionado,
    required this.alTocar,
  });

  final IconData icono;
  final bool seleccionado;
  final VoidCallback alTocar;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: alTocar,
      child: Container(
        width: AppEspacio.xxl + AppEspacio.m,
        height: AppEspacio.xxl + AppEspacio.m,
        decoration: BoxDecoration(
          color: AppColores.superficie,
          borderRadius: BorderRadius.circular(AppRadio.m),
          border: Border.all(
            color: seleccionado ? AppColores.primario : AppColores.borde,
            width: seleccionado ? 2 : 1,
          ),
        ),
        child: Icon(
          icono,
          size: AppEspacio.xl - AppEspacio.xs,
          color: seleccionado
              ? AppColores.primario
              : AppColores.textoPrincipal,
        ),
      ),
    );
  }
}

class BotonColor extends StatelessWidget {
  const BotonColor({
    super.key,
    required this.color,
    required this.seleccionado,
    required this.alTocar,
  });

  final Color color;
  final bool seleccionado;
  final VoidCallback alTocar;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: alTocar,
      child: Container(
        width: AppEspacio.xxl,
        height: AppEspacio.xxl,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: seleccionado
              ? Border.all(color: AppColores.primario, width: 2)
              : null,
        ),
        child: seleccionado
            ? const Icon(
                Icons.check,
                color: AppColores.superficie,
                size: AppEspacio.l,
              )
            : null,
      ),
    );
  }
}
