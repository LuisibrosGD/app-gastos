// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurrentes_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(recurrentesRepository)
final recurrentesRepositoryProvider = RecurrentesRepositoryProvider._();

final class RecurrentesRepositoryProvider
    extends
        $FunctionalProvider<
          RecurrentesRepository,
          RecurrentesRepository,
          RecurrentesRepository
        >
    with $Provider<RecurrentesRepository> {
  RecurrentesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recurrentesRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recurrentesRepositoryHash();

  @$internal
  @override
  $ProviderElement<RecurrentesRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RecurrentesRepository create(Ref ref) {
    return recurrentesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecurrentesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecurrentesRepository>(value),
    );
  }
}

String _$recurrentesRepositoryHash() =>
    r'371ea97e7934ea31142650f833f6f87a9ead3e15';

@ProviderFor(generadorRecurrentes)
final generadorRecurrentesProvider = GeneradorRecurrentesProvider._();

final class GeneradorRecurrentesProvider
    extends
        $FunctionalProvider<
          GeneradorRecurrentes,
          GeneradorRecurrentes,
          GeneradorRecurrentes
        >
    with $Provider<GeneradorRecurrentes> {
  GeneradorRecurrentesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'generadorRecurrentesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$generadorRecurrentesHash();

  @$internal
  @override
  $ProviderElement<GeneradorRecurrentes> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GeneradorRecurrentes create(Ref ref) {
    return generadorRecurrentes(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GeneradorRecurrentes value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GeneradorRecurrentes>(value),
    );
  }
}

String _$generadorRecurrentesHash() =>
    r'930804f835ff959b35b16aaa4385a665f6dcaa3b';

@ProviderFor(recurrentes)
final recurrentesProvider = RecurrentesProvider._();

final class RecurrentesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RecurrenteConCategoria>>,
          List<RecurrenteConCategoria>,
          Stream<List<RecurrenteConCategoria>>
        >
    with
        $FutureModifier<List<RecurrenteConCategoria>>,
        $StreamProvider<List<RecurrenteConCategoria>> {
  RecurrentesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recurrentesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recurrentesHash();

  @$internal
  @override
  $StreamProviderElement<List<RecurrenteConCategoria>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<RecurrenteConCategoria>> create(Ref ref) {
    return recurrentes(ref);
  }
}

String _$recurrentesHash() => r'b0da883cb0f51efeeed9089fcdc48444a7c3ea29';
