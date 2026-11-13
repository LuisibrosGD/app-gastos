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

  @override
  String get movimientosTitulo => 'Movimientos';

  @override
  String get nuevoMovimiento => 'Nuevo movimiento';

  @override
  String get editarMovimiento => 'Editar movimiento';

  @override
  String get accionBorrar => 'Borrar';

  @override
  String get prefijoSoles => 'S/';

  @override
  String get campoMonto => 'Monto';

  @override
  String get campoCategoria => 'Categoría';

  @override
  String get campoFecha => 'Fecha';

  @override
  String get campoNotaOpcional => 'Nota (opcional)';

  @override
  String get notaEjemplo => 'Almuerzo con el equipo';

  @override
  String fechaHoy(String fecha) {
    return 'Hoy, $fecha';
  }

  @override
  String get hoy => 'Hoy';

  @override
  String get ayer => 'Ayer';

  @override
  String get filtroTodos => 'Todos';

  @override
  String get filtroGastos => 'Gastos';

  @override
  String get filtroIngresos => 'Ingresos';

  @override
  String categoriaFiltro(String valor) {
    return 'Categoría: $valor';
  }

  @override
  String get categoriaTodas => 'Todas';

  @override
  String sinMovimientosMes(String mes) {
    return 'Sin movimientos en $mes';
  }

  @override
  String get sinMovimientosAyuda => 'Prueba con otro mes o cambia los filtros.';

  @override
  String get registrarPrimero => 'Registrar el primero';

  @override
  String get errorMontoRequerido => 'Ingresa un monto';

  @override
  String get errorMontoFormato => 'Usa como máximo 2 decimales';

  @override
  String get errorMontoMayorACero => 'El monto debe ser mayor que cero';

  @override
  String get errorMontoMuyGrande => 'El monto es demasiado grande';

  @override
  String get errorNotaMuyLargo => 'La nota no puede superar los 200 caracteres';

  @override
  String get errorCategoriaRequerida => 'Elige una categoría';

  @override
  String get errorCategoriaTipoNoCoincide =>
      'La categoría no coincide con el tipo';

  @override
  String get errorGuardarMovimiento =>
      'No se pudo guardar. Inténtalo de nuevo.';

  @override
  String get errorCargarMovimiento => 'No se pudo cargar el movimiento.';

  @override
  String get confirmarBorrarMovimientoTitulo => '¿Borrar movimiento?';

  @override
  String get confirmarBorrarMovimientoMensaje =>
      'Esta acción no se puede deshacer.';
}
