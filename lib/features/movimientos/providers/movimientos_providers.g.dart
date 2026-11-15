// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movimientos_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(movimientosRepository)
final movimientosRepositoryProvider = MovimientosRepositoryProvider._();

final class MovimientosRepositoryProvider
    extends
        $FunctionalProvider<
          MovimientosRepository,
          MovimientosRepository,
          MovimientosRepository
        >
    with $Provider<MovimientosRepository> {
  MovimientosRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'movimientosRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$movimientosRepositoryHash();

  @$internal
  @override
  $ProviderElement<MovimientosRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MovimientosRepository create(Ref ref) {
    return movimientosRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MovimientosRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MovimientosRepository>(value),
    );
  }
}

String _$movimientosRepositoryHash() =>
    r'9e86a120d205a11f9574a4a93059a66c108438be';

@ProviderFor(movimientosMes)
final movimientosMesProvider = MovimientosMesFamily._();

final class MovimientosMesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MovimientoConCategoria>>,
          List<MovimientoConCategoria>,
          Stream<List<MovimientoConCategoria>>
        >
    with
        $FutureModifier<List<MovimientoConCategoria>>,
        $StreamProvider<List<MovimientoConCategoria>> {
  MovimientosMesProvider._({
    required MovimientosMesFamily super.from,
    required FiltroMovimientos super.argument,
  }) : super(
         retry: null,
         name: r'movimientosMesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$movimientosMesHash();

  @override
  String toString() {
    return r'movimientosMesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<MovimientoConCategoria>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<MovimientoConCategoria>> create(Ref ref) {
    final argument = this.argument as FiltroMovimientos;
    return movimientosMes(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MovimientosMesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$movimientosMesHash() => r'44d12643141cb1154a4493f6662ed76457503ff3';

final class MovimientosMesFamily extends $Family
    with
        $FunctionalFamilyOverride<
          Stream<List<MovimientoConCategoria>>,
          FiltroMovimientos
        > {
  MovimientosMesFamily._()
    : super(
        retry: null,
        name: r'movimientosMesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MovimientosMesProvider call(FiltroMovimientos filtro) =>
      MovimientosMesProvider._(argument: filtro, from: this);

  @override
  String toString() => r'movimientosMesProvider';
}

@ProviderFor(movimientosRecientes)
final movimientosRecientesProvider = MovimientosRecientesProvider._();

final class MovimientosRecientesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MovimientoConCategoria>>,
          List<MovimientoConCategoria>,
          Stream<List<MovimientoConCategoria>>
        >
    with
        $FutureModifier<List<MovimientoConCategoria>>,
        $StreamProvider<List<MovimientoConCategoria>> {
  MovimientosRecientesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'movimientosRecientesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$movimientosRecientesHash();

  @$internal
  @override
  $StreamProviderElement<List<MovimientoConCategoria>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<MovimientoConCategoria>> create(Ref ref) {
    return movimientosRecientes(ref);
  }
}

String _$movimientosRecientesHash() =>
    r'fa5201a6a3468f6b777c4bf0de1607befbe8bda5';

@ProviderFor(movimiento)
final movimientoProvider = MovimientoFamily._();

final class MovimientoProvider
    extends
        $FunctionalProvider<
          AsyncValue<MovimientoConCategoria?>,
          MovimientoConCategoria?,
          FutureOr<MovimientoConCategoria?>
        >
    with
        $FutureModifier<MovimientoConCategoria?>,
        $FutureProvider<MovimientoConCategoria?> {
  MovimientoProvider._({
    required MovimientoFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'movimientoProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$movimientoHash();

  @override
  String toString() {
    return r'movimientoProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<MovimientoConCategoria?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<MovimientoConCategoria?> create(Ref ref) {
    final argument = this.argument as int;
    return movimiento(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MovimientoProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$movimientoHash() => r'16f2c435ad32aae582e034e7879a30d53d008812';

final class MovimientoFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<MovimientoConCategoria?>, int> {
  MovimientoFamily._()
    : super(
        retry: null,
        name: r'movimientoProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MovimientoProvider call(int id) =>
      MovimientoProvider._(argument: id, from: this);

  @override
  String toString() => r'movimientoProvider';
}

@ProviderFor(totalesMes)
final totalesMesProvider = TotalesMesFamily._();

final class TotalesMesProvider
    extends
        $FunctionalProvider<
          AsyncValue<TotalesMes>,
          TotalesMes,
          Stream<TotalesMes>
        >
    with $FutureModifier<TotalesMes>, $StreamProvider<TotalesMes> {
  TotalesMesProvider._({
    required TotalesMesFamily super.from,
    required DateTime super.argument,
  }) : super(
         retry: null,
         name: r'totalesMesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$totalesMesHash();

  @override
  String toString() {
    return r'totalesMesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<TotalesMes> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<TotalesMes> create(Ref ref) {
    final argument = this.argument as DateTime;
    return totalesMes(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TotalesMesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$totalesMesHash() => r'ec2f23ec84d976b2cd08973d1dec100262cd6377';

final class TotalesMesFamily extends $Family
    with $FunctionalFamilyOverride<Stream<TotalesMes>, DateTime> {
  TotalesMesFamily._()
    : super(
        retry: null,
        name: r'totalesMesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TotalesMesProvider call(DateTime mes) =>
      TotalesMesProvider._(argument: mes, from: this);

  @override
  String toString() => r'totalesMesProvider';
}

@ProviderFor(MovimientosController)
final movimientosControllerProvider = MovimientosControllerProvider._();

final class MovimientosControllerProvider
    extends $AsyncNotifierProvider<MovimientosController, void> {
  MovimientosControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'movimientosControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$movimientosControllerHash();

  @$internal
  @override
  MovimientosController create() => MovimientosController();
}

String _$movimientosControllerHash() =>
    r'ef33fd2c2ea2b43b6304d3f2e4045ec40854d96b';

abstract class _$MovimientosController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
