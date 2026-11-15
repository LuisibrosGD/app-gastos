import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../movimientos/ui/widgets/form_fields.dart';
import '../data/recurrentes_repository.dart';
import '../providers/recurrentes_providers.dart';
import 'widgets/formulario_recurrente.dart';

class RecurrenteFormScreen extends ConsumerWidget {
  const RecurrenteFormScreen({super.key, this.id});

  final int? id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = this.id;
    if (id == null) return const FormularioRecurrente();

    final l10n = AppLocalizations.of(context);
    final reglas = ref.watch(recurrentesProvider);

    return reglas.when(
      data: (lista) {
        RecurrenteConCategoria? item;
        for (final candidata in lista) {
          if (candidata.regla.id == id) {
            item = candidata;
            break;
          }
        }
        if (item == null) {
          return MensajeCarga(texto: l10n.errorCargarRecurrente);
        }
        return FormularioRecurrente(id: id, inicial: item);
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) =>
          MensajeCarga(texto: l10n.errorCargarRecurrente),
    );
  }
}
