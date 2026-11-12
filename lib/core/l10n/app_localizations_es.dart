// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'App Gastos';

  @override
  String get categoriasTitulo => 'Categorías';

  @override
  String get categoriasNueva => 'Nueva';

  @override
  String get categoriasGastos => 'Gastos';

  @override
  String get categoriasIngresos => 'Ingresos';

  @override
  String get categoriaArchivada => 'Archivada';

  @override
  String get categoriaNueva => 'Nueva categoría';

  @override
  String get categoriaEditar => 'Editar categoría';

  @override
  String get campoNombre => 'Nombre';

  @override
  String get campoTipo => 'Tipo';

  @override
  String get tipoGasto => 'Gasto';

  @override
  String get tipoIngreso => 'Ingreso';

  @override
  String get campoIcono => 'Ícono';

  @override
  String get campoColor => 'Color';

  @override
  String get accionGuardar => 'Guardar';

  @override
  String get accionEliminar => 'Eliminar';

  @override
  String get accionCancelar => 'Cancelar';

  @override
  String get errorNombreRequerido => 'El nombre es obligatorio';

  @override
  String get errorNombreMuyLargo =>
      'El nombre no puede superar los 30 caracteres';

  @override
  String get eliminarCategoriaTitulo => '¿Eliminar categoría?';

  @override
  String get eliminarCategoriaMensaje =>
      'Si tiene movimientos o reglas recurrentes, se archivará en lugar de borrarse.';

  @override
  String get categoriaArchivadaAviso =>
      'La categoría se archivó porque tiene movimientos o reglas recurrentes.';

  @override
  String get onboardingEligeIdioma => 'Elige tu idioma';

  @override
  String get onboardingAyudaIdioma =>
      'Podrás cambiarlo cuando quieras en Ajustes.';

  @override
  String get idiomaEspanol => 'Español';

  @override
  String get idiomaIngles => 'English';

  @override
  String get accionContinuar => 'Continuar';

  @override
  String get onboardingCategoriasTitulo => 'Categorías listas';

  @override
  String get onboardingCategoriasAyuda =>
      'Creamos estas categorías por defecto. Puedes editarlas en Ajustes.';

  @override
  String get catComida => 'Comida';

  @override
  String get catTransporte => 'Transporte';

  @override
  String get catVivienda => 'Vivienda';

  @override
  String get catServicios => 'Servicios';

  @override
  String get catSalud => 'Salud';

  @override
  String get catEntretenimiento => 'Entretenimiento';

  @override
  String get catCompras => 'Compras';

  @override
  String get catEducacion => 'Educación';

  @override
  String get catOtrosGasto => 'Otros';

  @override
  String get catSueldo => 'Sueldo';

  @override
  String get catExtra => 'Extra';

  @override
  String get catOtrosIngreso => 'Otros';
}
