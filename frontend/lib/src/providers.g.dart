// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$backendDioHash() => r'588a8210c6be512463715c2f1ac1669858e5d783';

/// See also [backendDio].
@ProviderFor(backendDio)
final backendDioProvider = AutoDisposeProvider<Dio>.internal(
  backendDio,
  name: r'backendDioProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$backendDioHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BackendDioRef = AutoDisposeProviderRef<Dio>;
String _$binanceDioHash() => r'7f08c895a5912df110a384625fea91b5b5a41bf8';

/// See also [binanceDio].
@ProviderFor(binanceDio)
final binanceDioProvider = AutoDisposeProvider<Dio>.internal(
  binanceDio,
  name: r'binanceDioProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$binanceDioHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BinanceDioRef = AutoDisposeProviderRef<Dio>;
String _$firebaseAuthHash() => r'912368c3df3f72e4295bf7a8cda93b9c5749d923';

/// See also [firebaseAuth].
@ProviderFor(firebaseAuth)
final firebaseAuthProvider = AutoDisposeProvider<FirebaseAuth>.internal(
  firebaseAuth,
  name: r'firebaseAuthProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$firebaseAuthHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FirebaseAuthRef = AutoDisposeProviderRef<FirebaseAuth>;
String _$authStateHash() => r'afdf515e14d0bb725ca181867cf6d626a5d85246';

/// See also [authState].
@ProviderFor(authState)
final authStateProvider = AutoDisposeStreamProvider<User?>.internal(
  authState,
  name: r'authStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthStateRef = AutoDisposeStreamProviderRef<User?>;
String _$pusherHash() => r'd1a98fa3f3832c715dffd530c7d916aa383effd8';

/// See also [pusher].
@ProviderFor(pusher)
final pusherProvider =
    AutoDisposeFutureProvider<PusherChannelsFlutter>.internal(
  pusher,
  name: r'pusherProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$pusherHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PusherRef = AutoDisposeFutureProviderRef<PusherChannelsFlutter>;
String _$binanceWSChannelHash() => r'92e20b1073a8878f85257866d10480b98f08211a';

/// See also [binanceWSChannel].
@ProviderFor(binanceWSChannel)
final binanceWSChannelProvider =
    AutoDisposeFutureProvider<(WebSocketChannel, Stream<dynamic>)>.internal(
  binanceWSChannel,
  name: r'binanceWSChannelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$binanceWSChannelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BinanceWSChannelRef
    = AutoDisposeFutureProviderRef<(WebSocketChannel, Stream<dynamic>)>;
String _$exchangeInfoHash() => r'8a4e0746d3c298aec2a57b809148628df8239e18';

/// See also [exchangeInfo].
@ProviderFor(exchangeInfo)
final exchangeInfoProvider =
    AutoDisposeFutureProvider<Map<String, SymbolInfo>>.internal(
  exchangeInfo,
  name: r'exchangeInfoProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$exchangeInfoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ExchangeInfoRef = AutoDisposeFutureProviderRef<Map<String, SymbolInfo>>;
String _$pusherSubHash() => r'dd4424010671f3b95891d3aaee2d91ad4a0b17b1';

/// See also [PusherSub].
@ProviderFor(PusherSub)
final pusherSubProvider =
    AutoDisposeAsyncNotifierProvider<PusherSub, void>.internal(
  PusherSub.new,
  name: r'pusherSubProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$pusherSubHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PusherSub = AutoDisposeAsyncNotifier<void>;
String _$binanceTickersHash() => r'3bd415a27dd54c3d1e0f3823aec9f1891903edcf';

/// See also [BinanceTickers].
@ProviderFor(BinanceTickers)
final binanceTickersProvider = AutoDisposeAsyncNotifierProvider<BinanceTickers,
    Map<String, MarketTicker>>.internal(
  BinanceTickers.new,
  name: r'binanceTickersProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$binanceTickersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BinanceTickers = AutoDisposeAsyncNotifier<Map<String, MarketTicker>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
