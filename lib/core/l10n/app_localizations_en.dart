// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'App Gastos';

  @override
  String get categoriasTitulo => 'Categories';

  @override
  String get categoriasNueva => 'New';

  @override
  String get categoriasGastos => 'Expenses';

  @override
  String get categoriasIngresos => 'Income';

  @override
  String get categoriaArchivada => 'Archived';

  @override
  String get categoriaNueva => 'New category';

  @override
  String get categoriaEditar => 'Edit category';

  @override
  String get campoNombre => 'Name';

  @override
  String get campoTipo => 'Type';

  @override
  String get tipoGasto => 'Expense';

  @override
  String get tipoIngreso => 'Income';

  @override
  String get campoIcono => 'Icon';

  @override
  String get campoColor => 'Color';

  @override
  String get accionGuardar => 'Save';

  @override
  String get accionEliminar => 'Delete';

  @override
  String get accionCancelar => 'Cancel';

  @override
  String get errorNombreRequerido => 'Name is required';

  @override
  String get errorNombreMuyLargo => 'Name can\'t exceed 30 characters';

  @override
  String get eliminarCategoriaTitulo => 'Delete category?';

  @override
  String get eliminarCategoriaMensaje =>
      'If it has movements or recurring rules, it will be archived instead of deleted.';

  @override
  String get categoriaArchivadaAviso =>
      'The category was archived because it has movements or recurring rules.';
}
