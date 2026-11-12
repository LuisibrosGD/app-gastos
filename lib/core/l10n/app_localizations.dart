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
