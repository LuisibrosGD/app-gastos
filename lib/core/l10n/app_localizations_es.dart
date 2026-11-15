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
  String get categoriasArchivadas => 'Archivadas';

  @override
  String get accionRestaurar => 'Restaurar';

  @override
  String get categoriaRestauradaAviso => 'La categoría se restauró.';

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
  String get errorGuardarCategoria => 'No se pudieron guardar las categorías.';

  @override
  String get confirmarBorrarMovimientoTitulo => '¿Borrar movimiento?';

  @override
  String get confirmarBorrarMovimientoMensaje =>
      'Esta acción no se puede deshacer.';

  @override
  String get inicioTitulo => 'Inicio';

  @override
  String get navInicio => 'Inicio';

  @override
  String get navResumen => 'Resumen';

  @override
  String get navAjustes => 'Ajustes';

  @override
  String balanceDeMes(String mes) {
    return 'Balance de $mes';
  }

  @override
  String get ultimosMovimientos => 'Últimos movimientos';

  @override
  String get verTodos => 'Ver todos';

  @override
  String get sinMovimientosInicioTitulo => 'Aún no hay movimientos';

  @override
  String get sinMovimientosInicioAyuda =>
      'Registra tu primer gasto o ingreso para ver tu balance y tus resúmenes.';

  @override
  String get resumenTitulo => 'Resumen';

  @override
  String get resumenGastos => 'Gastos';

  @override
  String get resumenIngresos => 'Ingresos';

  @override
  String get resumenIngresosVsGastos => 'Ingresos vs. gastos';

  @override
  String resumenSinDatosTitulo(String mes) {
    return 'Sin datos en $mes';
  }

  @override
  String get resumenSinDatosCuerpo =>
      'Cuando registres gastos e ingresos verás aquí el resumen por categoría y la comparación de los últimos 6 meses.';

  @override
  String get ajustesTitulo => 'Ajustes';

  @override
  String get preferencias => 'Preferencias';

  @override
  String get organizacion => 'Organización';

  @override
  String get idioma => 'Idioma';

  @override
  String get seguridad => 'Seguridad';

  @override
  String get bloqueo => 'Bloqueo';

  @override
  String get cambiarPin => 'Cambiar PIN';

  @override
  String get usarHuella => 'Usar huella';

  @override
  String get pinIngresa => 'Ingresa tu PIN para continuar';

  @override
  String get pinIncorrecto => 'PIN incorrecto';

  @override
  String pinEspera(int segundos) {
    return 'Demasiados intentos. Espera $segundos s';
  }

  @override
  String get huellaUsar => 'Usar huella digital';

  @override
  String get huellaMotivo => 'Desbloquea App Gastos';

  @override
  String get protegerTusGastos => 'Protege tus gastos';

  @override
  String get protegerAyuda =>
      'Activa un PIN de 4 a 6 dígitos o usa tu huella. Podrás cambiarlo cuando quieras en Ajustes.';

  @override
  String get configurarPin => 'Configurar PIN';

  @override
  String get ahoraNo => 'Ahora no';

  @override
  String get crearPinTitulo => 'Crear PIN';

  @override
  String get crearPinIntroduce => 'Introduce un PIN de 4 a 6 dígitos';

  @override
  String get crearPinRepite => 'Repite el PIN';

  @override
  String get errorPinFormato => 'El PIN debe tener de 4 a 6 dígitos';

  @override
  String get errorPinNoCoincide => 'Los PIN no coinciden';

  @override
  String get pinActualTitulo => 'Introduce tu PIN actual';

  @override
  String get pinActualAyuda => 'Confirma tu PIN para continuar';

  @override
  String get huellaPreguntaTitulo => '¿Usar huella?';

  @override
  String get huellaPreguntaMensaje =>
      'También podrás desbloquear la app con tu huella.';

  @override
  String get accionSi => 'Sí';

  @override
  String get errorGuardarPin => 'No se pudo guardar el PIN';

  @override
  String get appVersion => 'App Gastos · versión 1.0';

  @override
  String alertaPresupuestoTitulo(int porcentaje) {
    return 'Presupuesto al $porcentaje%';
  }

  @override
  String alertaPresupuestoCuerpo(String nombre, String gastado, String limite) {
    return '$nombre: $gastado de $limite';
  }

  @override
  String get alertaPresupuestoTotal => 'Total';

  @override
  String get canalPresupuesto => 'Presupuesto';

  @override
  String get presupuestoTitulo => 'Presupuesto';

  @override
  String get errorCargarPresupuesto => 'No se pudo cargar el presupuesto.';

  @override
  String get presupuestoTotal => 'Presupuesto total';

  @override
  String get totalMensual => 'Total mensual';

  @override
  String get editar => 'Editar';

  @override
  String get gastadoEsteMes => 'Gastado este mes';

  @override
  String get porCategoria => 'Por categoría';

  @override
  String get anadirLimiteCategoria => 'Añadir límite por categoría';

  @override
  String get presupuestoSinDefinir => 'Sin definir';

  @override
  String get elegirCategoria => 'Elige una categoría';

  @override
  String porcentaje(int valor) {
    return '$valor %';
  }

  @override
  String gastadoDeLimite(String gastado, String limite) {
    return '$gastado de $limite';
  }

  @override
  String presupuestoAlertaTitulo(int porcentaje) {
    return 'Presupuesto al $porcentaje %';
  }

  @override
  String categoriaAlertaTitulo(String categoria, int porcentaje) {
    return '$categoria al $porcentaje %';
  }

  @override
  String get recurrentesTitulo => 'Recurrentes';

  @override
  String get recurrentesAyuda => 'Se generan automáticamente al abrir la app.';

  @override
  String get recurrentesNueva => 'Nueva';

  @override
  String get recurrenteNueva => 'Nueva regla';

  @override
  String get recurrenteEditar => 'Editar regla';

  @override
  String get campoFrecuencia => 'Frecuencia';

  @override
  String get frecuenciaMensual => 'Mensual';

  @override
  String get frecuenciaSemanal => 'Semanal';

  @override
  String get campoDia => 'Día';

  @override
  String diaDelMes(int dia) {
    return 'Día $dia del mes';
  }

  @override
  String get campoFechaInicio => 'Fecha de inicio';

  @override
  String get activa => 'Activa';

  @override
  String recurrenteMensual(int dia) {
    return 'Mensual · día $dia';
  }

  @override
  String recurrenteSemanal(String dia) {
    return 'Semanal · $dia';
  }

  @override
  String get diaLunes => 'lunes';

  @override
  String get diaMartes => 'martes';

  @override
  String get diaMiercoles => 'miércoles';

  @override
  String get diaJueves => 'jueves';

  @override
  String get diaViernes => 'viernes';

  @override
  String get diaSabado => 'sábado';

  @override
  String get diaDomingo => 'domingo';

  @override
  String get errorDiaFueraDeRango => 'Elige un día válido';

  @override
  String get errorGuardarRecurrente => 'No se pudo guardar la regla';

  @override
  String get errorCargarRecurrente => 'No se pudo cargar la regla';

  @override
  String get confirmarBorrarRecurrenteTitulo => '¿Eliminar la regla?';

  @override
  String get confirmarBorrarRecurrenteMensaje =>
      'Los movimientos ya creados se conservarán.';

  @override
  String presupuestoAlertaCuerpo(String gastado, String limite) {
    return 'Llevas $gastado de $limite este mes.';
  }
}
