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

  @override
  String get onboardingEligeIdioma => 'Choose your language';

  @override
  String get onboardingAyudaIdioma => 'You can change it later in Settings.';

  @override
  String get idiomaEspanol => 'Spanish';

  @override
  String get idiomaIngles => 'English';

  @override
  String get accionContinuar => 'Continue';

  @override
  String get onboardingCategoriasTitulo => 'Categories ready';

  @override
  String get onboardingCategoriasAyuda =>
      'We created these default categories. You can edit them in Settings.';

  @override
  String get catComida => 'Food';

  @override
  String get catTransporte => 'Transport';

  @override
  String get catVivienda => 'Housing';

  @override
  String get catServicios => 'Utilities';

  @override
  String get catSalud => 'Health';

  @override
  String get catEntretenimiento => 'Entertainment';

  @override
  String get catCompras => 'Shopping';

  @override
  String get catEducacion => 'Education';

  @override
  String get catOtrosGasto => 'Other';

  @override
  String get catSueldo => 'Salary';

  @override
  String get catExtra => 'Extra';

  @override
  String get catOtrosIngreso => 'Other';

  @override
  String get movimientosTitulo => 'Movements';

  @override
  String get nuevoMovimiento => 'New movement';

  @override
  String get editarMovimiento => 'Edit movement';

  @override
  String get accionBorrar => 'Delete';

  @override
  String get prefijoSoles => 'S/';

  @override
  String get campoMonto => 'Amount';

  @override
  String get campoCategoria => 'Category';

  @override
  String get campoFecha => 'Date';

  @override
  String get campoNotaOpcional => 'Note (optional)';

  @override
  String get notaEjemplo => 'Lunch with the team';

  @override
  String fechaHoy(String fecha) {
    return 'Today, $fecha';
  }

  @override
  String get hoy => 'Today';

  @override
  String get ayer => 'Yesterday';

  @override
  String get filtroTodos => 'All';

  @override
  String get filtroGastos => 'Expenses';

  @override
  String get filtroIngresos => 'Income';

  @override
  String categoriaFiltro(String valor) {
    return 'Category: $valor';
  }

  @override
  String get categoriaTodas => 'All';

  @override
  String sinMovimientosMes(String mes) {
    return 'No movements in $mes';
  }

  @override
  String get sinMovimientosAyuda => 'Try another month or change the filters.';

  @override
  String get registrarPrimero => 'Add the first one';

  @override
  String get errorMontoRequerido => 'Enter an amount';

  @override
  String get errorMontoFormato => 'Use at most 2 decimals';

  @override
  String get errorMontoMayorACero => 'Amount must be greater than zero';

  @override
  String get errorMontoMuyGrande => 'Amount is too large';

  @override
  String get errorNotaMuyLargo => 'Note can\'t exceed 200 characters';

  @override
  String get errorCategoriaRequerida => 'Choose a category';

  @override
  String get errorCategoriaTipoNoCoincide => 'Category doesn\'t match the type';

  @override
  String get errorGuardarMovimiento => 'Couldn\'t save. Try again.';

  @override
  String get errorCargarMovimiento => 'Couldn\'t load the movement.';

  @override
  String get confirmarBorrarMovimientoTitulo => 'Delete movement?';

  @override
  String get confirmarBorrarMovimientoMensaje =>
      'This action can\'t be undone.';

  @override
  String get inicioTitulo => 'Home';

  @override
  String get navInicio => 'Home';

  @override
  String get navResumen => 'Summary';

  @override
  String get navAjustes => 'Settings';

  @override
  String balanceDeMes(String mes) {
    return 'Balance for $mes';
  }

  @override
  String get ultimosMovimientos => 'Latest movements';

  @override
  String get verTodos => 'See all';

  @override
  String get sinMovimientosInicioTitulo => 'No movements yet';

  @override
  String get sinMovimientosInicioAyuda =>
      'Add your first expense or income to see your balance and summaries.';

  @override
  String get resumenTitulo => 'Summary';

  @override
  String get ajustesTitulo => 'Settings';

  @override
  String get preferencias => 'Preferences';

  @override
  String get organizacion => 'Organization';

  @override
  String get idioma => 'Language';

  @override
  String get appVersion => 'App Gastos · version 1.0';

  @override
  String alertaPresupuestoTitulo(int porcentaje) {
    return 'Budget at $porcentaje%';
  }

  @override
  String alertaPresupuestoCuerpo(String nombre, String gastado, String limite) {
    return '$nombre: $gastado of $limite';
  }

  @override
  String get alertaPresupuestoTotal => 'Total';

  @override
  String get canalPresupuesto => 'Budget';

  @override
  String get presupuestoTitulo => 'Budget';

  @override
  String get errorCargarPresupuesto => 'Couldn\'t load the budget.';

  @override
  String get presupuestoTotal => 'Total budget';

  @override
  String get totalMensual => 'Monthly total';

  @override
  String get editar => 'Edit';

  @override
  String get gastadoEsteMes => 'Spent this month';

  @override
  String get porCategoria => 'By category';

  @override
  String get anadirLimiteCategoria => 'Add category limit';

  @override
  String get presupuestoSinDefinir => 'Not set';

  @override
  String get elegirCategoria => 'Choose a category';

  @override
  String porcentaje(int valor) {
    return '$valor%';
  }

  @override
  String gastadoDeLimite(String gastado, String limite) {
    return '$gastado of $limite';
  }

  @override
  String presupuestoAlertaTitulo(int porcentaje) {
    return 'Budget at $porcentaje%';
  }

  @override
  String categoriaAlertaTitulo(String categoria, int porcentaje) {
    return '$categoria at $porcentaje%';
  }

  @override
  String get recurrentesTitulo => 'Recurring';

  @override
  String get recurrentesAyuda =>
      'They\'re created automatically when you open the app.';

  @override
  String get recurrentesNueva => 'New';

  @override
  String get recurrenteNueva => 'New rule';

  @override
  String get recurrenteEditar => 'Edit rule';

  @override
  String get campoFrecuencia => 'Frequency';

  @override
  String get frecuenciaMensual => 'Monthly';

  @override
  String get frecuenciaSemanal => 'Weekly';

  @override
  String get campoDia => 'Day';

  @override
  String diaDelMes(int dia) {
    return 'Day $dia of the month';
  }

  @override
  String get campoFechaInicio => 'Start date';

  @override
  String get activa => 'Active';

  @override
  String recurrenteMensual(int dia) {
    return 'Monthly · day $dia';
  }

  @override
  String recurrenteSemanal(String dia) {
    return 'Weekly · $dia';
  }

  @override
  String get diaLunes => 'Monday';

  @override
  String get diaMartes => 'Tuesday';

  @override
  String get diaMiercoles => 'Wednesday';

  @override
  String get diaJueves => 'Thursday';

  @override
  String get diaViernes => 'Friday';

  @override
  String get diaSabado => 'Saturday';

  @override
  String get diaDomingo => 'Sunday';

  @override
  String get errorDiaFueraDeRango => 'Choose a valid day';

  @override
  String get errorGuardarRecurrente => 'Couldn\'t save the rule';

  @override
  String get errorCargarRecurrente => 'Couldn\'t load the rule';

  @override
  String get confirmarBorrarRecurrenteTitulo => 'Delete the rule?';

  @override
  String get confirmarBorrarRecurrenteMensaje =>
      'Movements already created will be kept.';

  @override
  String presupuestoAlertaCuerpo(String gastado, String limite) {
    return 'You\'ve spent $gastado of $limite this month.';
  }
}
