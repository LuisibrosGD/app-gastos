import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/colores.dart';
import '../../../../core/theme/dimensiones.dart';
import '../../../../core/theme/tipografia.dart';

List<int> mezclarDigitos(Random random) {
  return List<int>.generate(10, (indice) => indice)..shuffle(random);
}

class TecladoPin extends StatelessWidget {
  const TecladoPin({
    super.key,
    required this.orden,
    required this.alPulsar,
    required this.alBorrar,
    this.alHuella,
    this.habilitado = true,
  });

  final List<int> orden;
  final ValueChanged<int> alPulsar;
  final VoidCallback alBorrar;
  final VoidCallback? alHuella;
  final bool habilitado;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppEspacio.s,
      crossAxisSpacing: AppEspacio.s,
      childAspectRatio: 1.75,
      children: [
        for (final numero in orden.take(9))
          _Tecla(
            texto: '$numero',
            habilitada: habilitado,
            alTocar: () => alPulsar(numero),
          ),
        if (alHuella == null)
          const SizedBox.shrink()
        else
          Semantics(
            label: l10n.huellaTecla,
            button: true,
            child: _Tecla(
              icono: Icons.fingerprint,
              habilitada: habilitado,
              alTocar: alHuella,
            ),
          ),
        _Tecla(
          texto: '${orden[9]}',
          habilitada: habilitado,
          alTocar: () => alPulsar(orden[9]),
        ),
        _Tecla(
          icono: Icons.backspace_outlined,
          habilitada: habilitado,
          alTocar: alBorrar,
        ),
      ],
    );
  }
}

class _Tecla extends StatelessWidget {
  const _Tecla({
    this.texto,
    this.icono,
    required this.habilitada,
    this.alTocar,
  });

  final String? texto;
  final IconData? icono;
  final bool habilitada;
  final VoidCallback? alTocar;

  @override
  Widget build(BuildContext context) {
    final color = habilitada
        ? AppColores.textoPrincipal
        : AppColores.textoSecundario.withValues(alpha: 0.4);

    return Material(
      color: AppColores.superficie,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadio.m),
        side: const BorderSide(color: AppColores.borde),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadio.m),
        onTap: habilitada ? alTocar : null,
        child: Center(
          child: icono != null
              ? Icon(icono, size: AppEspacio.xl, color: color)
              : Text(
                  texto ?? '',
                  style: AppTexto.subtitulo.copyWith(color: color),
                ),
        ),
      ),
    );
  }
}
