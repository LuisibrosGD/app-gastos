import 'package:flutter/material.dart';

import '../../../../core/theme/colores.dart';
import '../../../../core/theme/dimensiones.dart';
import '../../../../core/theme/tipografia.dart';

class TarjetaAjustes extends StatelessWidget {
  const TarjetaAjustes({super.key, required this.filas});

  final List<Widget> filas;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColores.superficie,
        borderRadius: BorderRadius.circular(AppRadio.l),
        border: Border.all(color: AppColores.borde),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadio.l),
        child: Column(
          children: [
            for (var i = 0; i < filas.length; i++) ...[
              if (i > 0) const Divider(height: 1),
              filas[i],
            ],
          ],
        ),
      ),
    );
  }
}

class FilaAjuste extends StatelessWidget {
  const FilaAjuste({
    super.key,
    required this.texto,
    this.valor,
    required this.alTocar,
  });

  final String texto;
  final String? valor;
  final VoidCallback alTocar;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: alTocar,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppEspacio.l,
          vertical: AppEspacio.l,
        ),
        child: Row(
          children: [
            Expanded(child: Text(texto, style: AppTexto.cuerpo)),
            if (valor != null)
              Text(
                valor!,
                style: AppTexto.etiqueta.copyWith(
                  color: AppColores.textoSecundario,
                ),
              ),
            const SizedBox(width: AppEspacio.s),
            const Icon(
              Icons.chevron_right,
              size: AppEspacio.xl,
              color: AppColores.textoSecundario,
            ),
          ],
        ),
      ),
    );
  }
}

class FilaSwitch extends StatelessWidget {
  const FilaSwitch({
    super.key,
    required this.texto,
    required this.valor,
    required this.alCambiar,
  });

  final String texto;
  final bool valor;
  final ValueChanged<bool> alCambiar;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppEspacio.l,
        vertical: AppEspacio.s,
      ),
      child: Row(
        children: [
          Expanded(child: Text(texto, style: AppTexto.cuerpo)),
          Switch(value: valor, onChanged: alCambiar),
        ],
      ),
    );
  }
}
