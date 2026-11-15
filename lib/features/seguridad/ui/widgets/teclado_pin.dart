import 'package:flutter/material.dart';

import '../../../../core/theme/colores.dart';
import '../../../../core/theme/dimensiones.dart';
import '../../../../core/theme/tipografia.dart';

class TecladoPin extends StatelessWidget {
  const TecladoPin({
    super.key,
    required this.alPulsar,
    required this.alBorrar,
    this.alConfirmar,
    this.habilitado = true,
  });

  final ValueChanged<int> alPulsar;
  final VoidCallback alBorrar;
  final VoidCallback? alConfirmar;
  final bool habilitado;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppEspacio.s,
      crossAxisSpacing: AppEspacio.s,
      childAspectRatio: 1.75,
      children: [
        for (var numero = 1; numero <= 9; numero++)
          _Tecla(
            texto: '$numero',
            habilitada: habilitado,
            alTocar: () => alPulsar(numero),
          ),
        _Tecla(
          icono: Icons.check,
          habilitada: habilitado && alConfirmar != null,
          alTocar: alConfirmar,
        ),
        _Tecla(
          texto: '0',
          habilitada: habilitado,
          alTocar: () => alPulsar(0),
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
