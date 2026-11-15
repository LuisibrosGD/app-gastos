import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/ajustes/providers/preferencias_providers.dart';
import '../../features/recurrentes/providers/recurrentes_providers.dart';

class CicloDeVida extends ConsumerStatefulWidget {
  const CicloDeVida({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<CicloDeVida> createState() => _CicloDeVidaState();
}

class _CicloDeVidaState extends ConsumerState<CicloDeVida> {
  AppLifecycleListener? _escucha;

  @override
  void initState() {
    super.initState();
    _escucha = AppLifecycleListener(onResume: _generar);
    WidgetsBinding.instance.addPostFrameCallback((_) => _generar());
  }

  @override
  void dispose() {
    _escucha?.dispose();
    super.dispose();
  }

  Future<void> _generar() async {
    if (!mounted) return;
    if (!ref.read(onboardingCompletoProvider)) return;

    try {
      await ref
          .read(generadorRecurrentesProvider)
          .generarPendientes(DateTime.now());
    } catch (error) {
      debugPrint('Error generando recurrentes: $error');
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
