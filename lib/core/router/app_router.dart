import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/ajustes/providers/preferencias_providers.dart';
import '../../features/ajustes/ui/ajustes_screen.dart';
import '../../features/categorias/ui/categorias_screen.dart';
import '../../features/inicio/ui/inicio_screen.dart';
import '../../features/movimientos/ui/movimiento_form_screen.dart';
import '../../features/movimientos/ui/movimientos_screen.dart';
import '../../features/onboarding/ui/onboarding_screen.dart';
import '../../features/presupuesto/ui/presupuesto_screen.dart';
import '../../features/recurrentes/ui/recurrente_form_screen.dart';
import '../../features/recurrentes/ui/recurrentes_screen.dart';
import '../../features/resumen/ui/resumen_screen.dart';
import 'shell_scaffold.dart';

abstract final class Rutas {
  static const inicio = '/inicio';
  static const movimientos = '/movimientos';
  static const resumen = '/resumen';
  static const ajustes = '/ajustes';
  static const onboarding = '/onboarding';
  static const nuevoMovimiento = '/movimiento/nuevo';
  static String movimiento(int id) => '/movimiento/$id';
  static const categorias = '/ajustes/categorias';
  static const presupuesto = '/ajustes/presupuesto';
  static const recurrentes = '/ajustes/recurrentes';
  static const nuevaRecurrente = '/ajustes/recurrentes/nueva';
  static String recurrente(int id) => '/ajustes/recurrentes/$id';
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final onboardingCompleto = ref.watch(onboardingCompletoProvider);

  return GoRouter(
    initialLocation: Rutas.inicio,
    redirect: (context, state) {
      final enOnboarding = state.matchedLocation == Rutas.onboarding;
      if (!onboardingCompleto && !enOnboarding) return Rutas.onboarding;
      if (onboardingCompleto && enOnboarding) return Rutas.inicio;
      return null;
    },
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            ShellScaffold(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Rutas.inicio,
                builder: (context, state) => const InicioScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Rutas.movimientos,
                builder: (context, state) => const MovimientosScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Rutas.resumen,
                builder: (context, state) => const ResumenScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Rutas.ajustes,
                builder: (context, state) => const AjustesScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: Rutas.nuevoMovimiento,
        builder: (context, state) => const MovimientoFormScreen(),
      ),
      GoRoute(
        path: '/movimiento/:id',
        builder: (context, state) => MovimientoFormScreen(
          id: int.tryParse(state.pathParameters['id'] ?? ''),
        ),
      ),
      GoRoute(
        path: Rutas.categorias,
        builder: (context, state) => const CategoriasScreen(),
      ),
      GoRoute(
        path: Rutas.presupuesto,
        builder: (context, state) => const PresupuestoScreen(),
      ),
      GoRoute(
        path: Rutas.recurrentes,
        builder: (context, state) => const RecurrentesScreen(),
      ),
      GoRoute(
        path: Rutas.nuevaRecurrente,
        builder: (context, state) => const RecurrenteFormScreen(),
      ),
      GoRoute(
        path: '/ajustes/recurrentes/:id',
        builder: (context, state) => RecurrenteFormScreen(
          id: int.tryParse(state.pathParameters['id'] ?? ''),
        ),
      ),
      GoRoute(
        path: Rutas.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
    ],
  );
});
