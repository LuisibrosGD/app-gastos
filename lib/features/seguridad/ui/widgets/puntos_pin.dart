import 'package:flutter/material.dart';

import '../../../../core/theme/colores.dart';
import '../../../../core/theme/dimensiones.dart';

class PuntosPin extends StatelessWidget {
  const PuntosPin({super.key, required this.rellenos});

  final int rellenos;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < 4; i++)
          Container(
            width: AppEspacio.s,
            height: AppEspacio.s,
            margin: const EdgeInsets.symmetric(horizontal: AppEspacio.xs),
            decoration: BoxDecoration(
              color: i < rellenos ? AppColores.primario : null,
              shape: BoxShape.circle,
              border: Border.all(color: AppColores.borde),
            ),
          ),
      ],
    );
  }
}
