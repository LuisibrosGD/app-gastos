import 'package:intl/intl.dart';

/// La misma fecha a las 00:00 local.
DateTime soloFecha(DateTime fecha) =>
    DateTime(fecha.year, fecha.month, fecha.day);

/// Clave de mes con formato `YYYY-MM`.
String claveMes(DateTime fecha) =>
    '${fecha.year}-${fecha.month.toString().padLeft(2, '0')}';

/// Primer día del mes a las 00:00.
DateTime inicioMes(DateTime fecha) => DateTime(fecha.year, fecha.month);

/// Primer día del mes siguiente: límite exclusivo del mes.
DateTime inicioMesSiguiente(DateTime fecha) =>
    DateTime(fecha.year, fecha.month + 1);

/// Último día del mes indicado a las 00:00.
DateTime ultimoDiaDelMes(int anio, int mes) => DateTime(anio, mes + 1, 0);

/// Fecha abreviada: `es` → `11 nov 2026`; `en` → `Nov 11, 2026`.
String formatFecha(DateTime fecha, String localeCode) {
  final patron = localeCode == 'en' ? 'MMM d, y' : 'd MMM y';
  return DateFormat(patron, localeCode).format(fecha);
}
