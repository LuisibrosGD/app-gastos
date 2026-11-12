// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categorias_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(categoriasRepository)
final categoriasRepositoryProvider = CategoriasRepositoryProvider._();

final class CategoriasRepositoryProvider
    extends
        $FunctionalProvider<
          CategoriasRepository,
          CategoriasRepository,
          CategoriasRepository
        >
    with $Provider<CategoriasRepository> {
  CategoriasRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoriasRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoriasRepositoryHash();

  @$internal
  @override
  $ProviderElement<CategoriasRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CategoriasRepository create(Ref ref) {
    return categoriasRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CategoriasRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CategoriasRepository>(value),
    );
  }
}

String _$categoriasRepositoryHash() =>
    r'b3452d8957c63315eb967521665a833a907efada';
