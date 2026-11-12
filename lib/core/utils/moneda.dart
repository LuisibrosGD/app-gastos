import 'package:intl/intl.dart';

/// Límite máximo aceptado: S/ 99,999,999.99.
const int kMaxCentimos = 9999999999;

final NumberFormat _entero = NumberFormat('#,##0', 'en_US');

/// Formatea céntimos como soles: `123450` → `S/ 1,234.50`.
String formatSoles(int centimos) {
  final signo = centimos < 0 ? '-' : '';
  final absoluto = centimos.abs();
  final enteros = _entero.format(absoluto ~/ 100);
  final decimales = (absoluto % 100).toString().padLeft(2, '0');
  return '${signo}S/ $enteros.$decimales';
}

/// Convierte un texto en céntimos. Devuelve `null` si no es válido.
///
/// Acepta espacios, un prefijo `S/` opcional y un único separador decimal
/// (`.` o `,`) con hasta dos decimales. No acepta separadores de miles,
/// signos ni letras.
int? parseSoles(String texto) {
  final limpio = texto.replaceAll(RegExp(r'\s+'), '');
  final sinPrefijo = limpio.startsWith('S/') ? limpio.substring(2) : limpio;
  if (sinPrefijo.isEmpty) return null;
  if (!RegExp(r'^\d+([.,]\d{1,2})?$').hasMatch(sinPrefijo)) return null;

  final partes = sinPrefijo.split(RegExp(r'[.,]'));
  final enteros = int.tryParse(partes[0]);
  if (enteros == null) return null;
  if (enteros > kMaxCentimos ~/ 100) return null;
  final decimales = partes.length > 1
      ? int.parse(partes[1].padRight(2, '0'))
      : 0;

  final centimos = enteros * 100 + decimales;
  if (centimos > kMaxCentimos) return null;
  return centimos;
}
