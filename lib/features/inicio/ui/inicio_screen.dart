import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/colores.dart';
import '../../../core/theme/dimensiones.dart';
import '../../../core/theme/tipografia.dart';
import '../../../core/utils/fechas.dart';
import '../../ajustes/providers/preferencias_providers.dart';
import '../../movimientos/data/modelos.dart';
import '../../movimientos/providers/movimientos_providers.dart';
import '../../movimientos/ui/widgets/movimiento_tile.dart';
import 'widgets/tarjeta_balance.dart';

class InicioScreen extends ConsumerWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final idioma = ref.watch(idiomaActualProvider).languageCode;
    final mes = inicioMes(DateTime.now());
    final totales = ref.watch(totalesMesProvider(mes));
    final recientes = ref.watch(movimientosRecientesProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColores.fondo,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          l10n.inicioTitulo,
          style: AppTexto.titulo.copyWith(color: AppColores.textoPrincipal),
        ),
        actions: [
          Center(
            child: Text(
              _tituloMes(mes, idioma),
              style: AppTexto.etiqueta.copyWith(
                color: AppColores.textoSecundario,
              ),
            ),
          ),
          const SizedBox(width: AppEspacio.l),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(Rutas.nuevoMovimiento),
        child: const Icon(Icons.add),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppEspacio.l),
        children: [
          totales.when(
            data: (valor) => TarjetaBalance(totales: valor),
            loading: () => const SizedBox(
              height: 140,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stackTrace) => const SizedBox.shrink(),
          ),
          const SizedBox(height: AppEspacio.xl),
          recientes.when(
            data: (lista) => lista.isEmpty
                ? _EstadoVacioInicio(
                    alRegistrar: () => context.push(Rutas.nuevoMovimiento),
                  )
                : _UltimosMovimientos(lista: lista),
            loading: () => const Padding(
              padding: EdgeInsets.all(AppEspacio.xl),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stackTrace) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

String _tituloMes(DateTime mes, String idioma) {
  final texto = DateFormat('MMMM y', idioma).format(mes);
  return texto[0].toUpperCase() + texto.substring(1);
}

class _UltimosMovimientos extends StatelessWidget {
  const _UltimosMovimientos({required this.lista});

  final List<MovimientoConCategoria> lista;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(l10n.ultimosMovimientos, style: AppTexto.subtitulo),
            ),
            TextButton(
              onPressed: () => context.go(Rutas.movimientos),
              child: Text(
                l10n.verTodos,
                style: AppTexto.cuerpo.copyWith(color: AppColores.primario),
              ),
            ),
          ],
        ),
        for (final item in lista)
          MovimientoTile(
            item: item,
            mostrarFecha: true,
            onTap: () => context.push(Rutas.movimiento(item.movimiento.id)),
          ),
      ],
    );
  }
}

class _EstadoVacioInicio extends StatelessWidget {
  const _EstadoVacioInicio({required this.alRegistrar});

  final VoidCallback alRegistrar;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: AppEspacio.xxl),
      child: Column(
        children: [
          const Icon(
            Icons.credit_card_outlined,
            size: AppEspacio.xxl,
            color: AppColores.primario,
          ),
          const SizedBox(height: AppEspacio.l),
          Text(
            l10n.sinMovimientosInicioTitulo,
            textAlign: TextAlign.center,
            style: AppTexto.subtitulo,
          ),
          const SizedBox(height: AppEspacio.s),
          Text(
            l10n.sinMovimientosInicioAyuda,
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
    );
  }
}
