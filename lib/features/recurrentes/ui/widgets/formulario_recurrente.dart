import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/enums.dart';
import '../../../../core/errors.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/colores.dart';
import '../../../../core/theme/dimensiones.dart';
import '../../../../core/theme/tipografia.dart';
import '../../../../core/utils/fechas.dart';
import '../../../../core/utils/moneda.dart';
import '../../../ajustes/providers/preferencias_providers.dart';
import '../../../categorias/providers/categorias_providers.dart';
import '../../../movimientos/ui/widgets/campo_monto.dart';
import '../../../movimientos/ui/widgets/form_fields.dart';
import '../../data/recurrentes_repository.dart';
import '../../providers/recurrentes_providers.dart';
import 'campo_dia.dart';
import 'campos_formulario.dart';
import 'selector_frecuencia.dart';

class FormularioRecurrente extends ConsumerStatefulWidget {
  const FormularioRecurrente({super.key, this.id, this.inicial});

  final int? id;
  final RecurrenteConCategoria? inicial;

  @override
  ConsumerState<FormularioRecurrente> createState() =>
      _FormularioRecurrenteState();
}

class _FormularioRecurrenteState extends ConsumerState<FormularioRecurrente> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _monto;
  late final TextEditingController _nota;
  late TipoMovimiento _tipo;
  late Frecuencia _frecuencia;
  late int _dia;
  late DateTime _fechaInicio;
  late bool _activa;
  int? _categoriaId;
  String? _errorMonto;
  String? _errorCategoria;
  String? _errorNota;
  String? _errorDia;
  bool _guardando = false;

  bool get _esEdicion => widget.id != null;

  @override
  void initState() {
    super.initState();
    final regla = widget.inicial?.regla;
    final centimos = regla?.montoCentimos ?? 0;
    _monto = TextEditingController(
      text: centimos == 0
          ? ''
          : '${centimos ~/ 100}.${(centimos % 100).toString().padLeft(2, '0')}',
    );
    _nota = TextEditingController(text: regla?.nota ?? '');
    _tipo = regla?.tipo ?? TipoMovimiento.gasto;
    _frecuencia = regla?.frecuencia ?? Frecuencia.mensual;
    _dia = regla?.dia ?? 1;
    _fechaInicio = regla?.fechaInicio ?? soloFecha(DateTime.now());
    _activa = regla?.activo ?? true;
    _categoriaId = regla?.categoriaId;
  }

  @override
  void dispose() {
    _monto.dispose();
    _nota.dispose();
    super.dispose();
  }

  void _cambiarFrecuencia(Frecuencia frecuencia) {
    if (frecuencia == _frecuencia) return;
    setState(() {
      _frecuencia = frecuencia;
      if (frecuencia == Frecuencia.semanal && _dia > 7) _dia = 1;
      _errorDia = null;
    });
  }

  Future<void> _elegirFecha() async {
    final elegida = await showDatePicker(
      context: context,
      initialDate: _fechaInicio,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (elegida != null && mounted) {
      setState(() => _fechaInicio = soloFecha(elegida));
    }
  }

  Future<void> _guardar(AppLocalizations l10n) async {
    FocusScope.of(context).unfocus();
    setState(() {
      _errorMonto = null;
      _errorCategoria = null;
      _errorNota = null;
      _errorDia = null;
    });

    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_categoriaId == null) {
      setState(() => _errorCategoria = l10n.errorCategoriaRequerida);
      return;
    }

    final input = RecurrenteInput(
      tipo: _tipo,
      montoCentimos: parseSoles(_monto.text)!,
      categoriaId: _categoriaId!,
      nota: _nota.text,
      frecuencia: _frecuencia,
      dia: _dia,
      fechaInicio: _fechaInicio,
      activo: _activa,
    );

    setState(() => _guardando = true);
    try {
      final repo = ref.read(recurrentesRepositoryProvider);
      if (_esEdicion) {
        await repo.actualizar(widget.id!, input);
      } else {
        await repo.crear(input);
      }
      if (!mounted) return;
      Navigator.of(context).pop();
    } on ValidacionException catch (error) {
      final mensaje = error.campo == 'dia'
          ? l10n.errorDiaFueraDeRango
          : mensajeValidacion(l10n, error);
      setState(() {
        _guardando = false;
        if (error.campo == 'monto') _errorMonto = mensaje;
        if (error.campo == 'nota') _errorNota = mensaje;
        if (error.campo == 'categoria') _errorCategoria = mensaje;
        if (error.campo == 'dia') _errorDia = mensaje;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _guardando = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.errorGuardarRecurrente)));
    }
  }

  Future<void> _borrar(AppLocalizations l10n) async {
    if (!await confirmarEliminarRecurrente(context, l10n)) return;

    await ref.read(recurrentesRepositoryProvider).eliminar(widget.id!);
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
          _esEdicion ? l10n.recurrenteEditar : l10n.recurrenteNueva,
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
            CampoNota(controller: _nota, errorText: _errorNota),
            const SizedBox(height: AppEspacio.xl),
            Text(l10n.campoFrecuencia, style: AppTexto.etiqueta),
            const SizedBox(height: AppEspacio.s),
            SelectorFrecuencia(
              frecuencia: _frecuencia,
              alCambiar: _cambiarFrecuencia,
            ),
            const SizedBox(height: AppEspacio.xl),
            Text(l10n.campoDia, style: AppTexto.etiqueta),
            const SizedBox(height: AppEspacio.s),
            CampoDia(
              frecuencia: _frecuencia,
              dia: _dia,
              errorText: _errorDia,
              alCambiar: (valor) => setState(() {
                _dia = valor;
                _errorDia = null;
              }),
            ),
            const SizedBox(height: AppEspacio.xl),
            Text(l10n.campoFechaInicio, style: AppTexto.etiqueta),
            const SizedBox(height: AppEspacio.s),
            CampoFecha(
              alTocar: _elegirFecha,
              texto: formatFecha(_fechaInicio, idioma),
            ),
            const SizedBox(height: AppEspacio.xl),
            CampoActiva(
              valor: _activa,
              alCambiar: (valor) => setState(() => _activa = valor),
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
