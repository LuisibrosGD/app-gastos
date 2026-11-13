import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/ajustes/providers/preferencias_providers.dart';
import '../../features/categorias/ui/categorias_screen.dart';
import '../../features/movimientos/ui/movimiento_form_screen.dart';
import '../../features/movimientos/ui/movimientos_screen.dart';
import '../../features/onboarding/ui/onboarding_screen.dart';

const _rutaOnboarding = '/onboarding';

/// Router de la aplicación. Provisionalmente, P05 es la ruta inicial hasta
/// que la tarea 010 añada la navegación inferior y Ajustes.
final appRouterProvider = Provider<GoRouter>((ref) {
  final onboardingCompleto = ref.watch(onboardingCompletoProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final enOnboarding = state.matchedLocation == _rutaOnboarding;
      if (!onboardingCompleto && !enOnboarding) return _rutaOnboarding;
      if (onboardingCompleto && enOnboarding) return '/';
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const MovimientosScreen(),
      ),
      GoRoute(
        path: '/movimientos',
        builder: (context, state) => const MovimientosScreen(),
      ),
      GoRoute(
        path: '/movimiento/nuevo',
        builder: (context, state) => const MovimientoFormScreen(),
      ),
      GoRoute(
        path: '/movimiento/:id',
        builder: (context, state) => MovimientoFormScreen(
          id: int.tryParse(state.pathParameters['id'] ?? ''),
        ),
      ),
      GoRoute(
        path: '/ajustes/categorias',
        builder: (context, state) => const CategoriasScreen(),
      ),
      GoRoute(
        path: _rutaOnboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
    ],
  );
});
