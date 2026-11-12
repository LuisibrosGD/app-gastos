// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferencias_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = SharedPreferencesProvider._();

final class SharedPreferencesProvider
    extends
        $FunctionalProvider<
          SharedPreferences,
          SharedPreferences,
          SharedPreferences
        >
    with $Provider<SharedPreferences> {
  SharedPreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sharedPreferencesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sharedPreferencesHash();

  @$internal
  @override
  $ProviderElement<SharedPreferences> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SharedPreferences create(Ref ref) {
    return sharedPreferences(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SharedPreferences value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SharedPreferences>(value),
    );
  }
}

String _$sharedPreferencesHash() => r'50ab210fed14d5481a9c75346652aa24f72105ab';

@ProviderFor(preferenciasRepository)
final preferenciasRepositoryProvider = PreferenciasRepositoryProvider._();

final class PreferenciasRepositoryProvider
    extends
        $FunctionalProvider<
          PreferenciasRepository,
          PreferenciasRepository,
          PreferenciasRepository
        >
    with $Provider<PreferenciasRepository> {
  PreferenciasRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'preferenciasRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$preferenciasRepositoryHash();

  @$internal
  @override
  $ProviderElement<PreferenciasRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PreferenciasRepository create(Ref ref) {
    return preferenciasRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PreferenciasRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PreferenciasRepository>(value),
    );
  }
}

String _$preferenciasRepositoryHash() =>
    r'7860c41b3a60030858ed48da74963f5f563a8bb5';

@ProviderFor(IdiomaActual)
final idiomaActualProvider = IdiomaActualProvider._();

final class IdiomaActualProvider
    extends $NotifierProvider<IdiomaActual, Locale> {
  IdiomaActualProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'idiomaActualProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$idiomaActualHash();

  @$internal
  @override
  IdiomaActual create() => IdiomaActual();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Locale value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Locale>(value),
    );
  }
}

String _$idiomaActualHash() => r'114f51c40acc8dcd3797e22392cd78484d96d4ae';

abstract class _$IdiomaActual extends $Notifier<Locale> {
  Locale build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Locale, Locale>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Locale, Locale>,
              Locale,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(OnboardingCompleto)
final onboardingCompletoProvider = OnboardingCompletoProvider._();

final class OnboardingCompletoProvider
    extends $NotifierProvider<OnboardingCompleto, bool> {
  OnboardingCompletoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardingCompletoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onboardingCompletoHash();

  @$internal
  @override
  OnboardingCompleto create() => OnboardingCompleto();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$onboardingCompletoHash() =>
    r'80d209a69855ed1158a147be1bfa9ad1a60237a5';

abstract class _$OnboardingCompleto extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
