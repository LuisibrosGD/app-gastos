// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resumen_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(resumenRepository)
final resumenRepositoryProvider = ResumenRepositoryProvider._();

final class ResumenRepositoryProvider
    extends
        $FunctionalProvider<
          ResumenRepository,
          ResumenRepository,
          ResumenRepository
        >
    with $Provider<ResumenRepository> {
  ResumenRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'resumenRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$resumenRepositoryHash();

  @$internal
  @override
  $ProviderElement<ResumenRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ResumenRepository create(Ref ref) {
    return resumenRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ResumenRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ResumenRepository>(value),
    );
  }
}

String _$resumenRepositoryHash() => r'465151969d4aa816d7b2101d53c883bdf9c2260b';

@ProviderFor(gastosPorCategoria)
final gastosPorCategoriaProvider = GastosPorCategoriaFamily._();

final class GastosPorCategoriaProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<GastoPorCategoria>>,
          List<GastoPorCategoria>,
          Stream<List<GastoPorCategoria>>
        >
    with
        $FutureModifier<List<GastoPorCategoria>>,
        $StreamProvider<List<GastoPorCategoria>> {
  GastosPorCategoriaProvider._({
    required GastosPorCategoriaFamily super.from,
    required DateTime super.argument,
  }) : super(
         retry: null,
         name: r'gastosPorCategoriaProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$gastosPorCategoriaHash();

  @override
  String toString() {
    return r'gastosPorCategoriaProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<GastoPorCategoria>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<GastoPorCategoria>> create(Ref ref) {
    final argument = this.argument as DateTime;
    return gastosPorCategoria(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GastosPorCategoriaProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$gastosPorCategoriaHash() =>
    r'0cbb0bc6af6b67fa0e93d1f04a180032cdc66399';

final class GastosPorCategoriaFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<GastoPorCategoria>>, DateTime> {
  GastosPorCategoriaFamily._()
    : super(
        retry: null,
        name: r'gastosPorCategoriaProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GastosPorCategoriaProvider call(DateTime mes) =>
      GastosPorCategoriaProvider._(argument: mes, from: this);

  @override
  String toString() => r'gastosPorCategoriaProvider';
}

@ProviderFor(ultimosMeses)
final ultimosMesesProvider = UltimosMesesFamily._();

final class UltimosMesesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TotalesMes>>,
          List<TotalesMes>,
          Stream<List<TotalesMes>>
        >
    with $FutureModifier<List<TotalesMes>>, $StreamProvider<List<TotalesMes>> {
  UltimosMesesProvider._({
    required UltimosMesesFamily super.from,
    required DateTime super.argument,
  }) : super(
         retry: null,
         name: r'ultimosMesesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$ultimosMesesHash();

  @override
  String toString() {
    return r'ultimosMesesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<TotalesMes>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<TotalesMes>> create(Ref ref) {
    final argument = this.argument as DateTime;
    return ultimosMeses(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UltimosMesesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$ultimosMesesHash() => r'9fbc51c8f2a6a21fa29a441475c0547c2a5483e1';

final class UltimosMesesFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<TotalesMes>>, DateTime> {
  UltimosMesesFamily._()
    : super(
        retry: null,
        name: r'ultimosMesesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UltimosMesesProvider call(DateTime mesFinal) =>
      UltimosMesesProvider._(argument: mesFinal, from: this);

  @override
  String toString() => r'ultimosMesesProvider';
}
