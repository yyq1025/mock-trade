// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'klines_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$klinesHash() => r'eab838baa180930c0554ba423159bf006260525e';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$Klines extends BuildlessAutoDisposeAsyncNotifier<List<Kline>> {
  late final String symbol;
  late final String interval;

  FutureOr<List<Kline>> build(
    String symbol, {
    String interval = '15m',
  });
}

/// See also [Klines].
@ProviderFor(Klines)
const klinesProvider = KlinesFamily();

/// See also [Klines].
class KlinesFamily extends Family<AsyncValue<List<Kline>>> {
  /// See also [Klines].
  const KlinesFamily();

  /// See also [Klines].
  KlinesProvider call(
    String symbol, {
    String interval = '15m',
  }) {
    return KlinesProvider(
      symbol,
      interval: interval,
    );
  }

  @override
  KlinesProvider getProviderOverride(
    covariant KlinesProvider provider,
  ) {
    return call(
      provider.symbol,
      interval: provider.interval,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'klinesProvider';
}

/// See also [Klines].
class KlinesProvider
    extends AutoDisposeAsyncNotifierProviderImpl<Klines, List<Kline>> {
  /// See also [Klines].
  KlinesProvider(
    String symbol, {
    String interval = '15m',
  }) : this._internal(
          () => Klines()
            ..symbol = symbol
            ..interval = interval,
          from: klinesProvider,
          name: r'klinesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$klinesHash,
          dependencies: KlinesFamily._dependencies,
          allTransitiveDependencies: KlinesFamily._allTransitiveDependencies,
          symbol: symbol,
          interval: interval,
        );

  KlinesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.symbol,
    required this.interval,
  }) : super.internal();

  final String symbol;
  final String interval;

  @override
  FutureOr<List<Kline>> runNotifierBuild(
    covariant Klines notifier,
  ) {
    return notifier.build(
      symbol,
      interval: interval,
    );
  }

  @override
  Override overrideWith(Klines Function() create) {
    return ProviderOverride(
      origin: this,
      override: KlinesProvider._internal(
        () => create()
          ..symbol = symbol
          ..interval = interval,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        symbol: symbol,
        interval: interval,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<Klines, List<Kline>> createElement() {
    return _KlinesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is KlinesProvider &&
        other.symbol == symbol &&
        other.interval == interval;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, symbol.hashCode);
    hash = _SystemHash.combine(hash, interval.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin KlinesRef on AutoDisposeAsyncNotifierProviderRef<List<Kline>> {
  /// The parameter `symbol` of this provider.
  String get symbol;

  /// The parameter `interval` of this provider.
  String get interval;
}

class _KlinesProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<Klines, List<Kline>>
    with KlinesRef {
  _KlinesProviderElement(super.provider);

  @override
  String get symbol => (origin as KlinesProvider).symbol;
  @override
  String get interval => (origin as KlinesProvider).interval;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
