import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/l10n/app_localizations.dart';
import 'core/lifecycle/ciclo_vida.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/ajustes/providers/preferencias_providers.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: construirTemaClaro(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: ref.watch(idiomaActualProvider),
      routerConfig: router,
      builder: (context, child) =>
          CicloDeVida(child: child ?? const SizedBox.shrink()),
    );
  }
}
