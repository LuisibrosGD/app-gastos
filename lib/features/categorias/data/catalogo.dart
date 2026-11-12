import 'package:flutter/material.dart';

const Map<String, IconData> iconosCategoria = {
  'comida': Icons.restaurant,
  'transporte': Icons.directions_car,
  'vivienda': Icons.home_outlined,
  'servicios': Icons.bolt,
  'salud': Icons.favorite_border,
  'entretenimiento': Icons.movie_outlined,
  'compras': Icons.shopping_bag_outlined,
  'educacion': Icons.school_outlined,
  'otros': Icons.more_horiz,
  'sueldo': Icons.arrow_downward,
  'extra': Icons.add,
  'regalo': Icons.card_giftcard,
  'mascota': Icons.pets,
  'viaje': Icons.flight,
  'deporte': Icons.sports_soccer,
  'ahorro': Icons.savings_outlined,
};

enum ResultadoEliminar { eliminada, archivada }

String claveIcono(String nombre) {
  final base = nombre
      .trim()
      .toLowerCase()
      .replaceAll('á', 'a')
      .replaceAll('é', 'e')
      .replaceAll('í', 'i')
      .replaceAll('ó', 'o')
      .replaceAll('ú', 'u');
  return iconosCategoria.containsKey(base) ? base : 'otros';
}
