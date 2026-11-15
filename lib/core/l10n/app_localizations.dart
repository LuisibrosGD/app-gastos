import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// Nombre visible de la aplicación
  ///
  /// In es, this message translates to:
  /// **'App Gastos'**
  String get appTitle;

  /// Título de la pantalla P09
  ///
  /// In es, this message translates to:
  /// **'Categorías'**
  String get categoriasTitulo;

  /// Acción para crear una categoría
  ///
  /// In es, this message translates to:
  /// **'Nueva'**
  String get categoriasNueva;

  /// Título de la sección de categorías de gasto
  ///
  /// In es, this message translates to:
  /// **'Gastos'**
  String get categoriasGastos;

  /// Título de la sección de categorías de ingreso
  ///
  /// In es, this message translates to:
  /// **'Ingresos'**
  String get categoriasIngresos;

  /// Marca de una categoría archivada
  ///
  /// In es, this message translates to:
  /// **'Archivada'**
  String get categoriaArchivada;

  /// Título del formulario para crear una categoría
  ///
  /// In es, this message translates to:
  /// **'Nueva categoría'**
  String get categoriaNueva;

  /// Título del formulario para editar una categoría
  ///
  /// In es, this message translates to:
  /// **'Editar categoría'**
  String get categoriaEditar;

  /// Etiqueta del campo nombre
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get campoNombre;

  /// Etiqueta del campo tipo
  ///
  /// In es, this message translates to:
  /// **'Tipo'**
  String get campoTipo;

  /// Tipo de movimiento gasto
  ///
  /// In es, this message translates to:
  /// **'Gasto'**
  String get tipoGasto;

  /// Tipo de movimiento ingreso
  ///
  /// In es, this message translates to:
  /// **'Ingreso'**
  String get tipoIngreso;

  /// Etiqueta del selector de ícono
  ///
  /// In es, this message translates to:
  /// **'Ícono'**
  String get campoIcono;

  /// Etiqueta del selector de color
  ///
  /// In es, this message translates to:
  /// **'Color'**
  String get campoColor;

  /// Acción para guardar el formulario
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get accionGuardar;

  /// Acción para eliminar una categoría
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get accionEliminar;

  /// Acción para cancelar el diálogo
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get accionCancelar;

  /// Error cuando el nombre está vacío
  ///
  /// In es, this message translates to:
  /// **'El nombre es obligatorio'**
  String get errorNombreRequerido;

  /// Error cuando el nombre supera los 30 caracteres
  ///
  /// In es, this message translates to:
  /// **'El nombre no puede superar los 30 caracteres'**
  String get errorNombreMuyLargo;

  /// Título del diálogo de confirmación
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar categoría?'**
  String get eliminarCategoriaTitulo;

  /// Mensaje del diálogo de confirmación
  ///
  /// In es, this message translates to:
  /// **'Si tiene movimientos o reglas recurrentes, se archivará en lugar de borrarse.'**
  String get eliminarCategoriaMensaje;

  /// Mensaje tras archivar en lugar de eliminar
  ///
  /// In es, this message translates to:
  /// **'La categoría se archivó porque tiene movimientos o reglas recurrentes.'**
  String get categoriaArchivadaAviso;

  /// No description provided for @onboardingEligeIdioma.
  ///
  /// In es, this message translates to:
  /// **'Elige tu idioma'**
  String get onboardingEligeIdioma;

  /// No description provided for @onboardingAyudaIdioma.
  ///
  /// In es, this message translates to:
  /// **'Podrás cambiarlo cuando quieras en Ajustes.'**
  String get onboardingAyudaIdioma;

  /// No description provided for @idiomaEspanol.
  ///
  /// In es, this message translates to:
  /// **'Español'**
  String get idiomaEspanol;

  /// No description provided for @idiomaIngles.
  ///
  /// In es, this message translates to:
  /// **'English'**
  String get idiomaIngles;

  /// No description provided for @accionContinuar.
  ///
  /// In es, this message translates to:
  /// **'Continuar'**
  String get accionContinuar;

  /// No description provided for @onboardingCategoriasTitulo.
  ///
  /// In es, this message translates to:
  /// **'Categorías listas'**
  String get onboardingCategoriasTitulo;

  /// No description provided for @onboardingCategoriasAyuda.
  ///
  /// In es, this message translates to:
  /// **'Creamos estas categorías por defecto. Puedes editarlas en Ajustes.'**
  String get onboardingCategoriasAyuda;

  /// No description provided for @catComida.
  ///
  /// In es, this message translates to:
  /// **'Comida'**
  String get catComida;

  /// No description provided for @catTransporte.
  ///
  /// In es, this message translates to:
  /// **'Transporte'**
  String get catTransporte;

  /// No description provided for @catVivienda.
  ///
  /// In es, this message translates to:
  /// **'Vivienda'**
  String get catVivienda;

  /// No description provided for @catServicios.
  ///
  /// In es, this message translates to:
  /// **'Servicios'**
  String get catServicios;

  /// No description provided for @catSalud.
  ///
  /// In es, this message translates to:
  /// **'Salud'**
  String get catSalud;

  /// No description provided for @catEntretenimiento.
  ///
  /// In es, this message translates to:
  /// **'Entretenimiento'**
  String get catEntretenimiento;

  /// No description provided for @catCompras.
  ///
  /// In es, this message translates to:
  /// **'Compras'**
  String get catCompras;

  /// No description provided for @catEducacion.
  ///
  /// In es, this message translates to:
  /// **'Educación'**
  String get catEducacion;

  /// No description provided for @catOtrosGasto.
  ///
  /// In es, this message translates to:
  /// **'Otros'**
  String get catOtrosGasto;

  /// No description provided for @catSueldo.
  ///
  /// In es, this message translates to:
  /// **'Sueldo'**
  String get catSueldo;

  /// No description provided for @catExtra.
  ///
  /// In es, this message translates to:
  /// **'Extra'**
  String get catExtra;

  /// No description provided for @catOtrosIngreso.
  ///
  /// In es, this message translates to:
  /// **'Otros'**
  String get catOtrosIngreso;

  /// No description provided for @movimientosTitulo.
  ///
  /// In es, this message translates to:
  /// **'Movimientos'**
  String get movimientosTitulo;

  /// No description provided for @nuevoMovimiento.
  ///
  /// In es, this message translates to:
  /// **'Nuevo movimiento'**
  String get nuevoMovimiento;

  /// No description provided for @editarMovimiento.
  ///
  /// In es, this message translates to:
  /// **'Editar movimiento'**
  String get editarMovimiento;

  /// No description provided for @accionBorrar.
  ///
  /// In es, this message translates to:
  /// **'Borrar'**
  String get accionBorrar;

  /// No description provided for @prefijoSoles.
  ///
  /// In es, this message translates to:
  /// **'S/'**
  String get prefijoSoles;

  /// No description provided for @campoMonto.
  ///
  /// In es, this message translates to:
  /// **'Monto'**
  String get campoMonto;

  /// No description provided for @campoCategoria.
  ///
  /// In es, this message translates to:
  /// **'Categoría'**
  String get campoCategoria;

  /// No description provided for @campoFecha.
  ///
  /// In es, this message translates to:
  /// **'Fecha'**
  String get campoFecha;

  /// No description provided for @campoNotaOpcional.
  ///
  /// In es, this message translates to:
  /// **'Nota (opcional)'**
  String get campoNotaOpcional;

  /// No description provided for @notaEjemplo.
  ///
  /// In es, this message translates to:
  /// **'Almuerzo con el equipo'**
  String get notaEjemplo;

  /// No description provided for @fechaHoy.
  ///
  /// In es, this message translates to:
  /// **'Hoy, {fecha}'**
  String fechaHoy(String fecha);

  /// No description provided for @hoy.
  ///
  /// In es, this message translates to:
  /// **'Hoy'**
  String get hoy;

  /// No description provided for @ayer.
  ///
  /// In es, this message translates to:
  /// **'Ayer'**
  String get ayer;

  /// No description provided for @filtroTodos.
  ///
  /// In es, this message translates to:
  /// **'Todos'**
  String get filtroTodos;

  /// No description provided for @filtroGastos.
  ///
  /// In es, this message translates to:
  /// **'Gastos'**
  String get filtroGastos;

  /// No description provided for @filtroIngresos.
  ///
  /// In es, this message translates to:
  /// **'Ingresos'**
  String get filtroIngresos;

  /// No description provided for @categoriaFiltro.
  ///
  /// In es, this message translates to:
  /// **'Categoría: {valor}'**
  String categoriaFiltro(String valor);

  /// No description provided for @categoriaTodas.
  ///
  /// In es, this message translates to:
  /// **'Todas'**
  String get categoriaTodas;

  /// No description provided for @sinMovimientosMes.
  ///
  /// In es, this message translates to:
  /// **'Sin movimientos en {mes}'**
  String sinMovimientosMes(String mes);

  /// No description provided for @sinMovimientosAyuda.
  ///
  /// In es, this message translates to:
  /// **'Prueba con otro mes o cambia los filtros.'**
  String get sinMovimientosAyuda;

  /// No description provided for @registrarPrimero.
  ///
  /// In es, this message translates to:
  /// **'Registrar el primero'**
  String get registrarPrimero;

  /// No description provided for @errorMontoRequerido.
  ///
  /// In es, this message translates to:
  /// **'Ingresa un monto'**
  String get errorMontoRequerido;

  /// No description provided for @errorMontoFormato.
  ///
  /// In es, this message translates to:
  /// **'Usa como máximo 2 decimales'**
  String get errorMontoFormato;

  /// No description provided for @errorMontoMayorACero.
  ///
  /// In es, this message translates to:
  /// **'El monto debe ser mayor que cero'**
  String get errorMontoMayorACero;

  /// No description provided for @errorMontoMuyGrande.
  ///
  /// In es, this message translates to:
  /// **'El monto es demasiado grande'**
  String get errorMontoMuyGrande;

  /// No description provided for @errorNotaMuyLargo.
  ///
  /// In es, this message translates to:
  /// **'La nota no puede superar los 200 caracteres'**
  String get errorNotaMuyLargo;

  /// No description provided for @errorCategoriaRequerida.
  ///
  /// In es, this message translates to:
  /// **'Elige una categoría'**
  String get errorCategoriaRequerida;

  /// No description provided for @errorCategoriaTipoNoCoincide.
  ///
  /// In es, this message translates to:
  /// **'La categoría no coincide con el tipo'**
  String get errorCategoriaTipoNoCoincide;

  /// No description provided for @errorGuardarMovimiento.
  ///
  /// In es, this message translates to:
  /// **'No se pudo guardar. Inténtalo de nuevo.'**
  String get errorGuardarMovimiento;

  /// No description provided for @errorCargarMovimiento.
  ///
  /// In es, this message translates to:
  /// **'No se pudo cargar el movimiento.'**
  String get errorCargarMovimiento;

  /// No description provided for @errorGuardarCategoria.
  ///
  /// In es, this message translates to:
  /// **'No se pudieron guardar las categorías.'**
  String get errorGuardarCategoria;

  /// No description provided for @confirmarBorrarMovimientoTitulo.
  ///
  /// In es, this message translates to:
  /// **'¿Borrar movimiento?'**
  String get confirmarBorrarMovimientoTitulo;

  /// No description provided for @confirmarBorrarMovimientoMensaje.
  ///
  /// In es, this message translates to:
  /// **'Esta acción no se puede deshacer.'**
  String get confirmarBorrarMovimientoMensaje;

  /// No description provided for @inicioTitulo.
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get inicioTitulo;

  /// No description provided for @navInicio.
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get navInicio;

  /// No description provided for @navResumen.
  ///
  /// In es, this message translates to:
  /// **'Resumen'**
  String get navResumen;

  /// No description provided for @navAjustes.
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get navAjustes;

  /// No description provided for @balanceDeMes.
  ///
  /// In es, this message translates to:
  /// **'Balance de {mes}'**
  String balanceDeMes(String mes);

  /// No description provided for @ultimosMovimientos.
  ///
  /// In es, this message translates to:
  /// **'Últimos movimientos'**
  String get ultimosMovimientos;

  /// No description provided for @verTodos.
  ///
  /// In es, this message translates to:
  /// **'Ver todos'**
  String get verTodos;

  /// No description provided for @sinMovimientosInicioTitulo.
  ///
  /// In es, this message translates to:
  /// **'Aún no hay movimientos'**
  String get sinMovimientosInicioTitulo;

  /// No description provided for @sinMovimientosInicioAyuda.
  ///
  /// In es, this message translates to:
  /// **'Registra tu primer gasto o ingreso para ver tu balance y tus resúmenes.'**
  String get sinMovimientosInicioAyuda;

  /// No description provided for @resumenTitulo.
  ///
  /// In es, this message translates to:
  /// **'Resumen'**
  String get resumenTitulo;

  /// No description provided for @resumenGastos.
  ///
  /// In es, this message translates to:
  /// **'Gastos'**
  String get resumenGastos;

  /// No description provided for @resumenIngresos.
  ///
  /// In es, this message translates to:
  /// **'Ingresos'**
  String get resumenIngresos;

  /// No description provided for @resumenIngresosVsGastos.
  ///
  /// In es, this message translates to:
  /// **'Ingresos vs. gastos'**
  String get resumenIngresosVsGastos;

  /// No description provided for @resumenSinDatosTitulo.
  ///
  /// In es, this message translates to:
  /// **'Sin datos en {mes}'**
  String resumenSinDatosTitulo(String mes);

  /// No description provided for @resumenSinDatosCuerpo.
  ///
  /// In es, this message translates to:
  /// **'Cuando registres gastos e ingresos verás aquí el resumen por categoría y la comparación de los últimos 6 meses.'**
  String get resumenSinDatosCuerpo;

  /// No description provided for @ajustesTitulo.
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get ajustesTitulo;

  /// No description provided for @preferencias.
  ///
  /// In es, this message translates to:
  /// **'Preferencias'**
  String get preferencias;

  /// No description provided for @organizacion.
  ///
  /// In es, this message translates to:
  /// **'Organización'**
  String get organizacion;

  /// No description provided for @idioma.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get idioma;

  /// No description provided for @seguridad.
  ///
  /// In es, this message translates to:
  /// **'Seguridad'**
  String get seguridad;

  /// No description provided for @bloqueo.
  ///
  /// In es, this message translates to:
  /// **'Bloqueo'**
  String get bloqueo;

  /// No description provided for @cambiarPin.
  ///
  /// In es, this message translates to:
  /// **'Cambiar PIN'**
  String get cambiarPin;

  /// No description provided for @usarHuella.
  ///
  /// In es, this message translates to:
  /// **'Usar huella'**
  String get usarHuella;

  /// No description provided for @pinIngresa.
  ///
  /// In es, this message translates to:
  /// **'Ingresa tu PIN para continuar'**
  String get pinIngresa;

  /// No description provided for @pinIncorrecto.
  ///
  /// In es, this message translates to:
  /// **'PIN incorrecto'**
  String get pinIncorrecto;

  /// No description provided for @pinEspera.
  ///
  /// In es, this message translates to:
  /// **'Demasiados intentos. Espera {segundos} s'**
  String pinEspera(int segundos);

  /// No description provided for @huellaUsar.
  ///
  /// In es, this message translates to:
  /// **'Usar huella digital'**
  String get huellaUsar;

  /// No description provided for @huellaMotivo.
  ///
  /// In es, this message translates to:
  /// **'Desbloquea App Gastos'**
  String get huellaMotivo;

  /// No description provided for @protegerTusGastos.
  ///
  /// In es, this message translates to:
  /// **'Protege tus gastos'**
  String get protegerTusGastos;

  /// No description provided for @protegerAyuda.
  ///
  /// In es, this message translates to:
  /// **'Activa un PIN de 4 a 6 dígitos o usa tu huella. Podrás cambiarlo cuando quieras en Ajustes.'**
  String get protegerAyuda;

  /// No description provided for @configurarPin.
  ///
  /// In es, this message translates to:
  /// **'Configurar PIN'**
  String get configurarPin;

  /// No description provided for @ahoraNo.
  ///
  /// In es, this message translates to:
  /// **'Ahora no'**
  String get ahoraNo;

  /// No description provided for @crearPinTitulo.
  ///
  /// In es, this message translates to:
  /// **'Crear PIN'**
  String get crearPinTitulo;

  /// No description provided for @crearPinIntroduce.
  ///
  /// In es, this message translates to:
  /// **'Introduce un PIN de 4 a 6 dígitos'**
  String get crearPinIntroduce;

  /// No description provided for @crearPinRepite.
  ///
  /// In es, this message translates to:
  /// **'Repite el PIN'**
  String get crearPinRepite;

  /// No description provided for @errorPinFormato.
  ///
  /// In es, this message translates to:
  /// **'El PIN debe tener de 4 a 6 dígitos'**
  String get errorPinFormato;

  /// No description provided for @errorPinNoCoincide.
  ///
  /// In es, this message translates to:
  /// **'Los PIN no coinciden'**
  String get errorPinNoCoincide;

  /// No description provided for @pinActualTitulo.
  ///
  /// In es, this message translates to:
  /// **'Introduce tu PIN actual'**
  String get pinActualTitulo;

  /// No description provided for @pinActualAyuda.
  ///
  /// In es, this message translates to:
  /// **'Confirma tu PIN para continuar'**
  String get pinActualAyuda;

  /// No description provided for @huellaPreguntaTitulo.
  ///
  /// In es, this message translates to:
  /// **'¿Usar huella?'**
  String get huellaPreguntaTitulo;

  /// No description provided for @huellaPreguntaMensaje.
  ///
  /// In es, this message translates to:
  /// **'También podrás desbloquear la app con tu huella.'**
  String get huellaPreguntaMensaje;

  /// No description provided for @accionSi.
  ///
  /// In es, this message translates to:
  /// **'Sí'**
  String get accionSi;

  /// No description provided for @errorGuardarPin.
  ///
  /// In es, this message translates to:
  /// **'No se pudo guardar el PIN'**
  String get errorGuardarPin;

  /// No description provided for @appVersion.
  ///
  /// In es, this message translates to:
  /// **'App Gastos · versión 1.0'**
  String get appVersion;

  /// No description provided for @alertaPresupuestoTitulo.
  ///
  /// In es, this message translates to:
  /// **'Presupuesto al {porcentaje}%'**
  String alertaPresupuestoTitulo(int porcentaje);

  /// No description provided for @alertaPresupuestoCuerpo.
  ///
  /// In es, this message translates to:
  /// **'{nombre}: {gastado} de {limite}'**
  String alertaPresupuestoCuerpo(String nombre, String gastado, String limite);

  /// No description provided for @alertaPresupuestoTotal.
  ///
  /// In es, this message translates to:
  /// **'Total'**
  String get alertaPresupuestoTotal;

  /// No description provided for @canalPresupuesto.
  ///
  /// In es, this message translates to:
  /// **'Presupuesto'**
  String get canalPresupuesto;

  /// No description provided for @presupuestoTitulo.
  ///
  /// In es, this message translates to:
  /// **'Presupuesto'**
  String get presupuestoTitulo;

  /// No description provided for @errorCargarPresupuesto.
  ///
  /// In es, this message translates to:
  /// **'No se pudo cargar el presupuesto.'**
  String get errorCargarPresupuesto;

  /// No description provided for @presupuestoTotal.
  ///
  /// In es, this message translates to:
  /// **'Presupuesto total'**
  String get presupuestoTotal;

  /// No description provided for @totalMensual.
  ///
  /// In es, this message translates to:
  /// **'Total mensual'**
  String get totalMensual;

  /// No description provided for @editar.
  ///
  /// In es, this message translates to:
  /// **'Editar'**
  String get editar;

  /// No description provided for @gastadoEsteMes.
  ///
  /// In es, this message translates to:
  /// **'Gastado este mes'**
  String get gastadoEsteMes;

  /// No description provided for @porCategoria.
  ///
  /// In es, this message translates to:
  /// **'Por categoría'**
  String get porCategoria;

  /// No description provided for @anadirLimiteCategoria.
  ///
  /// In es, this message translates to:
  /// **'Añadir límite por categoría'**
  String get anadirLimiteCategoria;

  /// No description provided for @presupuestoSinDefinir.
  ///
  /// In es, this message translates to:
  /// **'Sin definir'**
  String get presupuestoSinDefinir;

  /// No description provided for @elegirCategoria.
  ///
  /// In es, this message translates to:
  /// **'Elige una categoría'**
  String get elegirCategoria;

  /// No description provided for @porcentaje.
  ///
  /// In es, this message translates to:
  /// **'{valor} %'**
  String porcentaje(int valor);

  /// No description provided for @gastadoDeLimite.
  ///
  /// In es, this message translates to:
  /// **'{gastado} de {limite}'**
  String gastadoDeLimite(String gastado, String limite);

  /// No description provided for @presupuestoAlertaTitulo.
  ///
  /// In es, this message translates to:
  /// **'Presupuesto al {porcentaje} %'**
  String presupuestoAlertaTitulo(int porcentaje);

  /// No description provided for @categoriaAlertaTitulo.
  ///
  /// In es, this message translates to:
  /// **'{categoria} al {porcentaje} %'**
  String categoriaAlertaTitulo(String categoria, int porcentaje);

  /// No description provided for @recurrentesTitulo.
  ///
  /// In es, this message translates to:
  /// **'Recurrentes'**
  String get recurrentesTitulo;

  /// No description provided for @recurrentesAyuda.
  ///
  /// In es, this message translates to:
  /// **'Se generan automáticamente al abrir la app.'**
  String get recurrentesAyuda;

  /// No description provided for @recurrentesNueva.
  ///
  /// In es, this message translates to:
  /// **'Nueva'**
  String get recurrentesNueva;

  /// No description provided for @recurrenteNueva.
  ///
  /// In es, this message translates to:
  /// **'Nueva regla'**
  String get recurrenteNueva;

  /// No description provided for @recurrenteEditar.
  ///
  /// In es, this message translates to:
  /// **'Editar regla'**
  String get recurrenteEditar;

  /// No description provided for @campoFrecuencia.
  ///
  /// In es, this message translates to:
  /// **'Frecuencia'**
  String get campoFrecuencia;

  /// No description provided for @frecuenciaMensual.
  ///
  /// In es, this message translates to:
  /// **'Mensual'**
  String get frecuenciaMensual;

  /// No description provided for @frecuenciaSemanal.
  ///
  /// In es, this message translates to:
  /// **'Semanal'**
  String get frecuenciaSemanal;

  /// No description provided for @campoDia.
  ///
  /// In es, this message translates to:
  /// **'Día'**
  String get campoDia;

  /// No description provided for @diaDelMes.
  ///
  /// In es, this message translates to:
  /// **'Día {dia} del mes'**
  String diaDelMes(int dia);

  /// No description provided for @campoFechaInicio.
  ///
  /// In es, this message translates to:
  /// **'Fecha de inicio'**
  String get campoFechaInicio;

  /// No description provided for @activa.
  ///
  /// In es, this message translates to:
  /// **'Activa'**
  String get activa;

  /// No description provided for @recurrenteMensual.
  ///
  /// In es, this message translates to:
  /// **'Mensual · día {dia}'**
  String recurrenteMensual(int dia);

  /// No description provided for @recurrenteSemanal.
  ///
  /// In es, this message translates to:
  /// **'Semanal · {dia}'**
  String recurrenteSemanal(String dia);

  /// No description provided for @diaLunes.
  ///
  /// In es, this message translates to:
  /// **'lunes'**
  String get diaLunes;

  /// No description provided for @diaMartes.
  ///
  /// In es, this message translates to:
  /// **'martes'**
  String get diaMartes;

  /// No description provided for @diaMiercoles.
  ///
  /// In es, this message translates to:
  /// **'miércoles'**
  String get diaMiercoles;

  /// No description provided for @diaJueves.
  ///
  /// In es, this message translates to:
  /// **'jueves'**
  String get diaJueves;

  /// No description provided for @diaViernes.
  ///
  /// In es, this message translates to:
  /// **'viernes'**
  String get diaViernes;

  /// No description provided for @diaSabado.
  ///
  /// In es, this message translates to:
  /// **'sábado'**
  String get diaSabado;

  /// No description provided for @diaDomingo.
  ///
  /// In es, this message translates to:
  /// **'domingo'**
  String get diaDomingo;

  /// No description provided for @errorDiaFueraDeRango.
  ///
  /// In es, this message translates to:
  /// **'Elige un día válido'**
  String get errorDiaFueraDeRango;

  /// No description provided for @errorGuardarRecurrente.
  ///
  /// In es, this message translates to:
  /// **'No se pudo guardar la regla'**
  String get errorGuardarRecurrente;

  /// No description provided for @errorCargarRecurrente.
  ///
  /// In es, this message translates to:
  /// **'No se pudo cargar la regla'**
  String get errorCargarRecurrente;

  /// No description provided for @confirmarBorrarRecurrenteTitulo.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar la regla?'**
  String get confirmarBorrarRecurrenteTitulo;

  /// No description provided for @confirmarBorrarRecurrenteMensaje.
  ///
  /// In es, this message translates to:
  /// **'Los movimientos ya creados se conservarán.'**
  String get confirmarBorrarRecurrenteMensaje;

  /// No description provided for @presupuestoAlertaCuerpo.
  ///
  /// In es, this message translates to:
  /// **'Llevas {gastado} de {limite} este mes.'**
  String presupuestoAlertaCuerpo(String gastado, String limite);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
