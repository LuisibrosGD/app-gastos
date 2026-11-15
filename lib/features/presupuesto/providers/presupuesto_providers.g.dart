// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'presupuesto_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(presupuestosRepository)
final presupuestosRepositoryProvider = PresupuestosRepositoryProvider._();

final class PresupuestosRepositoryProvider
    extends
        $FunctionalProvider<
          PresupuestosRepository,
          PresupuestosRepository,
          PresupuestosRepository
        >
    with $Provider<PresupuestosRepository> {
  PresupuestosRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'presupuestosRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$presupuestosRepositoryHash();

  @$internal
  @override
  $ProviderElement<PresupuestosRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PresupuestosRepository create(Ref ref) {
    return presupuestosRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PresupuestosRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PresupuestosRepository>(value),
    );
  }
}

String _$presupuestosRepositoryHash() =>
    r'd233a3c02edba0827f7f4cdfd7fcb202ac8b31fd';

@ProviderFor(notificador)
final notificadorProvider = NotificadorProvider._();

final class NotificadorProvider
    extends $FunctionalProvider<Notificador, Notificador, Notificador>
    with $Provider<Notificador> {
  NotificadorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificadorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificadorHash();

  @$internal
  @override
  $ProviderElement<Notificador> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Notificador create(Ref ref) {
    return notificador(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Notificador value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Notificador>(value),
    );
  }
}

String _$notificadorHash() => r'3c5f8f8138afd8ceeb4fa0c838ec215ec376d361';

@ProviderFor(alertasService)
final alertasServiceProvider = AlertasServiceProvider._();

final class AlertasServiceProvider
    extends $FunctionalProvider<AlertasService, AlertasService, AlertasService>
    with $Provider<AlertasService> {
  AlertasServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'alertasServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$alertasServiceHash();

  @$internal
  @override
  $ProviderElement<AlertasService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AlertasService create(Ref ref) {
    return alertasService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AlertasService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AlertasService>(value),
    );
  }
}

String _$alertasServiceHash() => r'496a280306dfb0804a5ccb48c20068a55239eac1';

@ProviderFor(progresoPresupuesto)
final progresoPresupuestoProvider = ProgresoPresupuestoFamily._();

final class ProgresoPresupuestoProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ProgresoPresupuesto>>,
          List<ProgresoPresupuesto>,
          Stream<List<ProgresoPresupuesto>>
        >
    with
        $FutureModifier<List<ProgresoPresupuesto>>,
        $StreamProvider<List<ProgresoPresupuesto>> {
  ProgresoPresupuestoProvider._({
    required ProgresoPresupuestoFamily super.from,
    required DateTime super.argument,
  }) : super(
         retry: null,
         name: r'progresoPresupuestoProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$progresoPresupuestoHash();

  @override
  String toString() {
    return r'progresoPresupuestoProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<ProgresoPresupuesto>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ProgresoPresupuesto>> create(Ref ref) {
    final argument = this.argument as DateTime;
    return progresoPresupuesto(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProgresoPresupuestoProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$progresoPresupuestoHash() =>
    r'121424f77149a7f12aaa737373f58e87227dc1d4';

final class ProgresoPresupuestoFamily extends $Family
    with
        $FunctionalFamilyOverride<Stream<List<ProgresoPresupuesto>>, DateTime> {
  ProgresoPresupuestoFamily._()
    : super(
        retry: null,
        name: r'progresoPresupuestoProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProgresoPresupuestoProvider call(DateTime mes) =>
      ProgresoPresupuestoProvider._(argument: mes, from: this);

  @override
  String toString() => r'progresoPresupuestoProvider';
}
