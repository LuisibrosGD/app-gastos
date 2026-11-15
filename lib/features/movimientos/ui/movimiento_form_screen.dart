import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/enums.dart';
import '../../../core/errors.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/colores.dart';
import '../../../core/theme/dimensiones.dart';
import '../../../core/theme/tipografia.dart';
import '../../../core/utils/fechas.dart';
import '../../../core/utils/moneda.dart';
import '../../ajustes/providers/preferencias_providers.dart';
import '../../categorias/providers/categorias_providers.dart';
import '../data/modelos.dart';
import '../providers/movimientos_providers.dart';
import 'widgets/campo_monto.dart';
import 'widgets/form_fields.dart';

class MovimientoFormScreen extends ConsumerWidget {
  const MovimientoFormScreen({super.key, this.id});

  final int? id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = this.id;
    if (id == null) return const _Formulario();

    final movimiento = ref.watch(movimientoProvider(id));
    return movimiento.when(
      data: (item) => item == null
          ? MensajeCarga(texto: AppLocalizations.of(context).errorCargarMovimiento)
          : _Formulario(id: id, inicial: item),
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => MensajeCarga(
        texto: AppLocalizations.of(context).errorCargarMovimiento,
      ),
    );
  }
}

class _Formulario extends ConsumerStatefulWidget {
  const _Formulario({this.id, this.inicial});

  final int? id;
  final MovimientoConCategoria? inicial;

  @override
  ConsumerState<_Formulario> createState() => _FormularioState();
}

class _FormularioState extends ConsumerState<_Formulario> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _monto;
  late final TextEditingController _nota;
  late TipoMovimiento _tipo;
  late DateTime _fecha;
  int? _categoriaId;
  String? _errorMonto;
  String? _errorCategoria;
  String? _errorNota;
  bool _guardando = false;

  bool get _esEdicion => widget.id != null;

  @override
  void initState() {
    super.initState();
    final movimiento = widget.inicial?.movimiento;
    final centimos = movimiento?.montoCentimos ?? 0;
    _monto = TextEditingController(
      text: centimos == 0
          ? ''
          : '${centimos ~/ 100}.${(centimos % 100).toString().padLeft(2, '0')}',
    );
    _nota = TextEditingController(text: movimiento?.nota ?? '');
    _tipo = movimiento?.tipo ?? TipoMovimiento.gasto;
    _fecha = movimiento?.fecha ?? soloFecha(DateTime.now());
    _categoriaId = movimiento?.categoriaId;
  }

  @override
  void dispose() {
    _monto.dispose();
    _nota.dispose();
    super.dispose();
  }

  Future<void> _elegirFecha() async {
    final elegida = await showDatePicker(
      context: context,
      initialDate: _fecha,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (elegida != null && mounted) {
      setState(() => _fecha = soloFecha(elegida));
    }
  }

  Future<void> _guardar(AppLocalizations l10n) async {
    FocusScope.of(context).unfocus();
    setState(() {
      _errorMonto = null;
      _errorCategoria = null;
      _errorNota = null;
    });

    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_categoriaId == null) {
      setState(() => _errorCategoria = l10n.errorCategoriaRequerida);
      return;
    }

    final input = MovimientoInput(
      tipo: _tipo,
      montoCentimos: parseSoles(_monto.text)!,
      fecha: _fecha,
      categoriaId: _categoriaId!,
      nota: _nota.text,
    );

    setState(() => _guardando = true);
    try {
      await ref
          .read(movimientosControllerProvider.notifier)
          .guardar(id: widget.id, input: input);
      if (!mounted) return;
      Navigator.of(context).pop();
    } on ValidacionException catch (error) {
      final mensaje = mensajeValidacion(l10n, error);
      setState(() {
        _guardando = false;
        if (error.campo == 'monto') _errorMonto = mensaje;
        if (error.campo == 'nota') _errorNota = mensaje;
        if (error.campo == 'categoria') _errorCategoria = mensaje;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _guardando = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.errorGuardarMovimiento)));
    }
  }

  Future<void> _borrar(AppLocalizations l10n) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (contexto) => AlertDialog(
        title: Text(l10n.confirmarBorrarMovimientoTitulo),
        content: Text(l10n.confirmarBorrarMovimientoMensaje),
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

    await ref
        .read(movimientosControllerProvider.notifier)
        .eliminar(widget.id!);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final idioma = ref.watch(idiomaActualProvider).languageCode;
    final categorias = ref.watch(categoriasPorTipoProvider(_tipo));
    final insetInferior = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColores.fondo,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          _esEdicion ? l10n.editarMovimiento : l10n.nuevoMovimiento,
          style: AppTexto.titulo.copyWith(color: AppColores.textoPrincipal),
        ),
        actions: [
          if (_esEdicion)
            TextButton(
              onPressed: () => _borrar(l10n),
              child: Text(
                l10n.accionBorrar,
                style: AppTexto.cuerpo.copyWith(color: AppColores.error),
              ),
            ),
          const SizedBox(width: AppEspacio.s),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            AppEspacio.l,
            AppEspacio.l,
            AppEspacio.l,
            AppEspacio.l + insetInferior,
          ),
          children: [
            SelectorTipoMovimiento(
              tipo: _tipo,
              alCambiar: (tipo) => setState(() {
                _tipo = tipo;
                _categoriaId = null;
                _errorCategoria = null;
              }),
            ),
            const SizedBox(height: AppEspacio.xl),
            Text(l10n.campoMonto, style: AppTexto.etiqueta),
            const SizedBox(height: AppEspacio.s),
            CampoMonto(
              controller: _monto,
              errorText: _errorMonto,
              validator: (texto) {
                if (texto == null || texto.trim().isEmpty) {
                  return l10n.errorMontoRequerido;
                }
                final valor = parseSoles(texto);
                if (valor == null) return l10n.errorMontoFormato;
                if (valor <= 0) return l10n.errorMontoMayorACero;
                return null;
              },
            ),
            const SizedBox(height: AppEspacio.xl),
            Text(l10n.campoCategoria, style: AppTexto.etiqueta),
            const SizedBox(height: AppEspacio.s),
            categorias.when(
              data: (lista) => Wrap(
                spacing: AppEspacio.s,
                runSpacing: AppEspacio.s,
                children: [
                  for (final categoria in lista)
                    ChipCategoria(
                      categoria: categoria,
                      seleccionada: categoria.id == _categoriaId,
                      alTocar: () => setState(() {
                        _categoriaId = categoria.id;
                        _errorCategoria = null;
                      }),
                    ),
                ],
              ),
              loading: () => const SizedBox(
                height: AppEspacio.xxl,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, stackTrace) => const SizedBox.shrink(),
            ),
            if (_errorCategoria != null) ...[
              const SizedBox(height: AppEspacio.xs),
              Text(
                _errorCategoria!,
                style: AppTexto.pequeno.copyWith(color: AppColores.error),
              ),
            ],
            const SizedBox(height: AppEspacio.xl),
            Text(l10n.campoFecha, style: AppTexto.etiqueta),
            const SizedBox(height: AppEspacio.s),
            CampoFecha(
              alTocar: _elegirFecha,
              texto: _fecha == soloFecha(DateTime.now())
                  ? l10n.fechaHoy(formatFecha(_fecha, idioma))
                  : formatFecha(_fecha, idioma),
            ),
            const SizedBox(height: AppEspacio.xl),
            Text(l10n.campoNotaOpcional, style: AppTexto.etiqueta),
            const SizedBox(height: AppEspacio.s),
            TextField(
              controller: _nota,
              maxLength: 200,
              style: AppTexto.cuerpo,
              decoration: InputDecoration(
                hintText: l10n.notaEjemplo,
                errorText: _errorNota,
                counterText: '',
              ),
            ),
            const SizedBox(height: AppEspacio.xl),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _guardando ? null : () => _guardar(l10n),
                child: Text(l10n.accionGuardar),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

