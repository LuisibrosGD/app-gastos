import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/enums.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/colores.dart';
import '../../../core/theme/dimensiones.dart';
import '../../../core/theme/tipografia.dart';
import '../../../core/utils/fechas.dart';
import '../../ajustes/providers/preferencias_providers.dart';
import '../../categorias/providers/categorias_providers.dart';
import '../data/modelos.dart';
import '../providers/movimientos_providers.dart';
import 'widgets/estado_vacio.dart';
import 'widgets/movimiento_tile.dart';
import 'widgets/selector_mes.dart';

class MovimientosScreen extends ConsumerStatefulWidget {
  const MovimientosScreen({super.key});

  @override
  ConsumerState<MovimientosScreen> createState() => _MovimientosScreenState();
}

class _MovimientosScreenState extends ConsumerState<MovimientosScreen> {
  DateTime _mes = inicioMes(DateTime.now());
  TipoMovimiento? _tipo;
  Categoria? _categoria;

  Future<void> _elegirCategoria(AppLocalizations l10n) async {
    final gastos = await ref.read(
      categoriasPorTipoProvider(TipoMovimiento.gasto).future,
    );
    final ingresos = await ref.read(
      categoriasPorTipoProvider(TipoMovimiento.ingreso).future,
    );
    if (!mounted) return;

    final seleccion = await showDialog<_SeleccionCategoria>(
      context: context,
      builder: (contexto) => SimpleDialog(
        title: Text(l10n.campoCategoria),
        children: [
          SimpleDialogOption(
            onPressed: () =>
                Navigator.of(contexto).pop(const _SeleccionCategoria(null)),
            child: Text(l10n.categoriaTodas, style: AppTexto.cuerpo),
          ),
          for (final categoria in [...gastos, ...ingresos])
            SimpleDialogOption(
              onPressed: () => Navigator.of(
                contexto,
              ).pop(_SeleccionCategoria(categoria)),
              child: Text(categoria.nombre, style: AppTexto.cuerpo),
            ),
        ],
      ),
    );
    if (seleccion != null) {
      setState(() => _categoria = seleccion.categoria);
    }
  }

  String _etiquetaDia(DateTime dia, AppLocalizations l10n, String idioma) {
    final hoy = soloFecha(DateTime.now());
    final ayer = hoy.subtract(const Duration(days: 1));
    if (dia == hoy) return '${l10n.hoy} · ${formatFecha(dia, idioma)}';
    if (dia == ayer) return '${l10n.ayer} · ${formatFecha(dia, idioma)}';
    return formatFecha(dia, idioma);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final idioma = ref.watch(idiomaActualProvider).languageCode;
    final movimientos = ref.watch(
      movimientosMesProvider(
        FiltroMovimientos(
          mes: _mes,
          tipo: _tipo,
          categoriaId: _categoria?.id,
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColores.fondo,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          l10n.movimientosTitulo,
          style: AppTexto.titulo.copyWith(color: AppColores.textoPrincipal),
        ),
        actions: [
          SelectorMes(
            mes: _mes,
            onCambio: (mes) => setState(() => _mes = inicioMes(mes)),
          ),
          const SizedBox(width: AppEspacio.l),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppEspacio.l,
              AppEspacio.s,
              AppEspacio.l,
              0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: AppEspacio.s,
                  children: [
                    _ChipFiltro(
                      texto: l10n.filtroTodos,
                      activo: _tipo == null,
                      alTocar: () => setState(() => _tipo = null),
                    ),
                    _ChipFiltro(
                      texto: l10n.filtroGastos,
                      activo: _tipo == TipoMovimiento.gasto,
                      alTocar: () => setState(
                        () => _tipo = TipoMovimiento.gasto,
                      ),
                    ),
                    _ChipFiltro(
                      texto: l10n.filtroIngresos,
                      activo: _tipo == TipoMovimiento.ingreso,
                      alTocar: () => setState(
                        () => _tipo = TipoMovimiento.ingreso,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppEspacio.m),
                InkWell(
                  borderRadius: BorderRadius.circular(AppRadio.l),
                  onTap: () => _elegirCategoria(l10n),
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
                          l10n.categoriaFiltro(
                            _categoria?.nombre ?? l10n.categoriaTodas,
                          ),
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
                ),
              ],
            ),
          ),
          Expanded(
            child: movimientos.when(
              data: (lista) => lista.isEmpty
                  ? EstadoVacio(
                      mes: _mes,
                      idioma: idioma,
                      alRegistrar: () => context.push('/movimiento/nuevo'),
                    )
                  : _ListaMovimientos(
                      movimientos: lista,
                      etiquetaDia: (dia) => _etiquetaDia(dia, l10n, idioma),
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(
                child: Text(
                  l10n.errorCargarMovimiento,
                  style: AppTexto.cuerpo,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ListaMovimientos extends StatelessWidget {
  const _ListaMovimientos({
    required this.movimientos,
    required this.etiquetaDia,
  });

  final List<MovimientoConCategoria> movimientos;
  final String Function(DateTime) etiquetaDia;

  @override
  Widget build(BuildContext context) {
    final hijos = <Widget>[];
    DateTime? diaActual;

    for (final item in movimientos) {
      final dia = soloFecha(item.movimiento.fecha);
      if (dia != diaActual) {
        hijos.add(
          Padding(
            padding: const EdgeInsets.only(
              top: AppEspacio.l,
              bottom: AppEspacio.xs,
            ),
            child: Text(
              etiquetaDia(dia),
              style: AppTexto.etiqueta.copyWith(
                color: AppColores.textoSecundario,
              ),
            ),
          ),
        );
        diaActual = dia;
      }
      final id = item.movimiento.id;
      hijos.add(
        MovimientoTile(
          item: item,
          onTap: () => context.push('/movimiento/$id'),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppEspacio.l),
      children: hijos,
    );
  }
}

class _ChipFiltro extends StatelessWidget {
  const _ChipFiltro({
    required this.texto,
    required this.activo,
    required this.alTocar,
  });

  final String texto;
  final bool activo;
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
          color: activo ? AppColores.primario : AppColores.primarioSuave,
          borderRadius: BorderRadius.circular(AppRadio.l),
        ),
        child: Text(
          texto,
          style: AppTexto.etiqueta.copyWith(
            color: activo ? AppColores.superficie : AppColores.primario,
          ),
        ),
      ),
    );
  }
}

class _SeleccionCategoria {
  const _SeleccionCategoria(this.categoria);

  final Categoria? categoria;
}
