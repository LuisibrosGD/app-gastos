// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bloqueo_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(reloj)
final relojProvider = RelojProvider._();

final class RelojProvider
    extends
        $FunctionalProvider<
          DateTime Function(),
          DateTime Function(),
          DateTime Function()
        >
    with $Provider<DateTime Function()> {
  RelojProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'relojProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$relojHash();

  @$internal
  @override
  $ProviderElement<DateTime Function()> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DateTime Function() create(Ref ref) {
    return reloj(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime Function() value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime Function()>(value),
    );
  }
}

String _$relojHash() => r'614099210aea97dccb5b899b144ebf30c42577ec';

@ProviderFor(pinService)
final pinServiceProvider = PinServiceProvider._();

final class PinServiceProvider
    extends $FunctionalProvider<PinService, PinService, PinService>
    with $Provider<PinService> {
  PinServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pinServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pinServiceHash();

  @$internal
  @override
  $ProviderElement<PinService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PinService create(Ref ref) {
    return pinService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PinService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PinService>(value),
    );
  }
}

String _$pinServiceHash() => r'921f97d2151ed8f391608a94d24f99caf3a73610';

@ProviderFor(biometriaService)
final biometriaServiceProvider = BiometriaServiceProvider._();

final class BiometriaServiceProvider
    extends
        $FunctionalProvider<
          BiometriaService,
          BiometriaService,
          BiometriaService
        >
    with $Provider<BiometriaService> {
  BiometriaServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'biometriaServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$biometriaServiceHash();

  @$internal
  @override
  $ProviderElement<BiometriaService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BiometriaService create(Ref ref) {
    return biometriaService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BiometriaService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BiometriaService>(value),
    );
  }
}

String _$biometriaServiceHash() => r'12487c06c906aa713b082ebc54325b05221a4398';

@ProviderFor(biometriaDisponible)
final biometriaDisponibleProvider = BiometriaDisponibleProvider._();

final class BiometriaDisponibleProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  BiometriaDisponibleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'biometriaDisponibleProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$biometriaDisponibleHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return biometriaDisponible(ref);
  }
}

String _$biometriaDisponibleHash() =>
    r'ecc8c92a137f98032480bf390f18863216688ac0';

@ProviderFor(BloqueoController)
final bloqueoControllerProvider = BloqueoControllerProvider._();

final class BloqueoControllerProvider
    extends $NotifierProvider<BloqueoController, EstadoBloqueo> {
  BloqueoControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bloqueoControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bloqueoControllerHash();

  @$internal
  @override
  BloqueoController create() => BloqueoController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EstadoBloqueo value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EstadoBloqueo>(value),
    );
  }
}

String _$bloqueoControllerHash() => r'f3a796c26fd83bd538cf4841942693d57be9d7e0';

abstract class _$BloqueoController extends $Notifier<EstadoBloqueo> {
  EstadoBloqueo build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<EstadoBloqueo, EstadoBloqueo>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<EstadoBloqueo, EstadoBloqueo>,
              EstadoBloqueo,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
