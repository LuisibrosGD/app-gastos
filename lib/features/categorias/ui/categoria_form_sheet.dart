import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/enums.dart';
import '../../../core/errors.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/colores.dart';
import '../../../core/theme/dimensiones.dart';
import '../../../core/theme/tipografia.dart';
import '../data/catalogo.dart';
import '../providers/categorias_providers.dart';
import 'categoria_form_campos.dart';

class CategoriaFormSheet extends ConsumerStatefulWidget {
  const CategoriaFormSheet({super.key, this.categoria});

  final Categoria? categoria;

  static Future<void> mostrar(BuildContext context, {Categoria? categoria}) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColores.superficie,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadio.l)),
      ),
      builder: (contexto) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(contexto).bottom,
        ),
        child: CategoriaFormSheet(categoria: categoria),
      ),
    );
  }

  @override
  ConsumerState<CategoriaFormSheet> createState() => _CategoriaFormSheetState();
}

class _CategoriaFormSheetState extends ConsumerState<CategoriaFormSheet> {
  late final TextEditingController _nombre;
  late String _icono;
  late int _color;
  late TipoMovimiento _tipo;
  String? _codigoError;
  bool _guardando = false;

  bool get _esEdicion => widget.categoria != null;

  @override
  void initState() {
    super.initState();
    final categoria = widget.categoria;
    _nombre = TextEditingController(text: categoria?.nombre ?? '');
    _icono = categoria?.icono ?? iconosCategoria.keys.first;
    _color =
        categoria?.color ?? AppColores.categorias.first.toARGB32();
    _tipo = categoria?.tipo ?? TipoMovimiento.gasto;
  }

  @override
  void dispose() {
    _nombre.dispose();
    super.dispose();
  }

  String? _mensajeError(AppLocalizations l10n) {
    return switch (_codigoError) {
      'requerido' => l10n.errorNombreRequerido,
      'muyLargo' => l10n.errorNombreMuyLargo,
      _ => null,
    };
  }

  Future<void> _guardar() async {
    if (_guardando) return;
    setState(() {
      _guardando = true;
      _codigoError = null;
    });

    final repositorio = ref.read(categoriasRepositoryProvider);
    try {
      if (_esEdicion) {
        await repositorio.actualizar(
          widget.categoria!.id,
          nombre: _nombre.text,
          icono: _icono,
          color: _color,
        );
      } else {
        await repositorio.crear(
          nombre: _nombre.text,
          icono: _icono,
          color: _color,
          tipo: _tipo,
        );
      }
      if (!mounted) return;
      Navigator.of(context).pop();
    } on ValidacionException catch (error) {
      setState(() => _codigoError = error.codigo);
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  Future<void> _restaurar() async {
    final l10n = AppLocalizations.of(context);
    await ref
        .read(categoriasRepositoryProvider)
        .restaurar(widget.categoria!.id);
    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).pop();
    messenger.showSnackBar(
      SnackBar(content: Text(l10n.categoriaRestauradaAviso)),
    );
  }

  Future<void> _eliminar() async {
    final l10n = AppLocalizations.of(context);
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (contexto) => AlertDialog(
        title: Text(l10n.eliminarCategoriaTitulo),
        content: Text(l10n.eliminarCategoriaMensaje),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(contexto).pop(false),
            child: Text(l10n.accionCancelar),
          ),
          TextButton(
            onPressed: () => Navigator.of(contexto).pop(true),
            child: Text(
              l10n.accionEliminar,
              style: const TextStyle(color: AppColores.error),
            ),
          ),
        ],
      ),
    );
    if (confirmado != true) return;

    final resultado = await ref
        .read(categoriasRepositoryProvider)
        .eliminarOArchivar(widget.categoria!.id);
    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).pop();
    if (resultado == ResultadoEliminar.archivada) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.categoriaArchivadaAviso)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppEspacio.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _esEdicion ? l10n.categoriaEditar : l10n.categoriaNueva,
              style: AppTexto.titulo,
            ),
            const SizedBox(height: AppEspacio.xl),
            Text(l10n.campoNombre, style: AppTexto.etiqueta),
            const SizedBox(height: AppEspacio.s),
            TextField(
              controller: _nombre,
              style: AppTexto.cuerpo,
              decoration: InputDecoration(
                errorText: _mensajeError(l10n),
                hintText: l10n.campoNombre,
              ),
            ),
            const SizedBox(height: AppEspacio.xl),
            Text(l10n.campoTipo, style: AppTexto.etiqueta),
            const SizedBox(height: AppEspacio.s),
            SelectorTipo(
              tipo: _tipo,
              habilitado: !_esEdicion,
              alCambiar: (tipo) => setState(() => _tipo = tipo),
            ),
            const SizedBox(height: AppEspacio.xl),
            Text(l10n.campoIcono, style: AppTexto.etiqueta),
            const SizedBox(height: AppEspacio.s),
            Wrap(
              spacing: AppEspacio.s,
              runSpacing: AppEspacio.s,
              children: [
                for (final entrada in iconosCategoria.entries)
                  BotonIcono(
                    icono: entrada.value,
                    seleccionado: entrada.key == _icono,
                    alTocar: () => setState(() => _icono = entrada.key),
                  ),
              ],
            ),
            const SizedBox(height: AppEspacio.xl),
            Text(l10n.campoColor, style: AppTexto.etiqueta),
            const SizedBox(height: AppEspacio.s),
            Wrap(
              spacing: AppEspacio.s,
              runSpacing: AppEspacio.s,
              children: [
                for (final color in AppColores.categorias)
                  BotonColor(
                    color: color,
                    seleccionado: color.toARGB32() == _color,
                    alTocar: () => setState(() => _color = color.toARGB32()),
                  ),
              ],
            ),
            const SizedBox(height: AppEspacio.xl),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _guardando ? null : _guardar,
                child: Text(l10n.accionGuardar),
              ),
            ),
            if (_esEdicion) ...[
              const SizedBox(height: AppEspacio.s),
              Center(
                child: widget.categoria!.archivada
                    ? TextButton.icon(
                        onPressed: _restaurar,
                        icon: const Icon(Icons.restore),
                        label: Text(l10n.accionRestaurar),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColores.primario,
                        ),
                      )
                    : TextButton.icon(
                        onPressed: _eliminar,
                        icon: const Icon(Icons.delete_outline),
                        label: Text(l10n.accionEliminar),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColores.error,
                        ),
                      ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

