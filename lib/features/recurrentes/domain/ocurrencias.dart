import '../../../core/database/enums.dart';
import '../../../core/utils/fechas.dart';

/// Fechas de ocurrencia en el intervalo `(desde, hoy]`, en orden ascendente,
/// donde `desde = ultimaGeneracion ?? (fechaInicio - 1 día)`.
///
/// Mensual: el día `dia` de cada mes; si el mes es más corto, su último día.
/// Semanal: el día de la semana `dia` (1 = lunes … 7 = domingo).
List<DateTime> ocurrenciasPendientes({
  required Frecuencia frecuencia,
  required int dia,
  required DateTime fechaInicio,
  DateTime? ultimaGeneracion,
  required DateTime hoy,
}) {
  final inicio = soloFecha(fechaInicio);
  final fin = soloFecha(hoy);
  final desde = ultimaGeneracion == null
      ? inicio.subtract(const Duration(days: 1))
      : soloFecha(ultimaGeneracion);

  if (!fin.isAfter(desde)) return [];

  if (frecuencia == Frecuencia.semanal) {
    return _semanales(desde: desde, fin: fin, dia: dia);
  }
  return _mensuales(desde: desde, fin: fin, dia: dia);
}

List<DateTime> _mensuales({
  required DateTime desde,
  required DateTime fin,
  required int dia,
}) {
  final resultado = <DateTime>[];
  var mes = DateTime(desde.year, desde.month);
  final ultimoMes = DateTime(fin.year, fin.month);

  while (!mes.isAfter(ultimoMes)) {
    final ultimoDia = ultimoDiaDelMes(mes.year, mes.month).day;
    final fecha = DateTime(mes.year, mes.month, dia > ultimoDia ? ultimoDia : dia);
    if (fecha.isAfter(desde) && !fecha.isAfter(fin)) resultado.add(fecha);
    mes = DateTime(mes.year, mes.month + 1);
  }

  return resultado;
}

List<DateTime> _semanales({
  required DateTime desde,
  required DateTime fin,
  required int dia,
}) {
  final resultado = <DateTime>[];
  var fecha = desde.add(const Duration(days: 1));

  while (!fecha.isAfter(fin)) {
    if (fecha.weekday == dia) resultado.add(fecha);
    fecha = fecha.add(const Duration(days: 1));
  }

  return resultado;
}
