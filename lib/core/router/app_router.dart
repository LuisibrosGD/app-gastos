import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/categorias/ui/categorias_screen.dart';

/// Router de la aplicación. Provisionalmente, P09 es la ruta inicial hasta
/// que la tarea 010 añada la navegación inferior y Ajustes.
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const CategoriasScreen(),
      ),
      GoRoute(
        path: '/ajustes/categorias',
        builder: (context, state) => const CategoriasScreen(),
      ),
    ],
  );
});
