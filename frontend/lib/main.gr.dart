// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i6;
import 'package:flutter/material.dart' as _i7;
import 'package:mock_trade/main.dart' as _i2;
import 'package:mock_trade/src/pages/auth/sign_in_page.dart' as _i3;
import 'package:mock_trade/src/pages/market/market_page.dart' as _i1;
import 'package:mock_trade/src/pages/trade/trade_page.dart' as _i4;
import 'package:mock_trade/src/pages/wallet/wallet_page.dart' as _i5;

/// generated route for
/// [_i1.MarketPage]
class MarketRoute extends _i6.PageRouteInfo<MarketRouteArgs> {
  MarketRoute({
    _i7.Key? key,
    String quoteAsset = 'USDT',
    List<_i6.PageRouteInfo>? children,
  }) : super(
          MarketRoute.name,
          args: MarketRouteArgs(
            key: key,
            quoteAsset: quoteAsset,
          ),
          rawPathParams: {'quoteAsset': quoteAsset},
          initialChildren: children,
        );

  static const String name = 'MarketRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<MarketRouteArgs>(
          orElse: () => MarketRouteArgs(
                  quoteAsset: pathParams.getString(
                'quoteAsset',
                'USDT',
              )));
      return _i1.MarketPage(
        key: args.key,
        quoteAsset: args.quoteAsset,
      );
    },
  );
}

class MarketRouteArgs {
  const MarketRouteArgs({
    this.key,
    this.quoteAsset = 'USDT',
  });

  final _i7.Key? key;

  final String quoteAsset;

  @override
  String toString() {
    return 'MarketRouteArgs{key: $key, quoteAsset: $quoteAsset}';
  }
}

/// generated route for
/// [_i2.MyHomePage]
class MyHomeRoute extends _i6.PageRouteInfo<void> {
  const MyHomeRoute({List<_i6.PageRouteInfo>? children})
      : super(
          MyHomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'MyHomeRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return _i2.MyHomePage();
    },
  );
}

/// generated route for
/// [_i3.SignInPage]
class SignInRoute extends _i6.PageRouteInfo<void> {
  const SignInRoute({List<_i6.PageRouteInfo>? children})
      : super(
          SignInRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignInRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return _i3.SignInPage();
    },
  );
}

/// generated route for
/// [_i4.TradePage]
class TradeRoute extends _i6.PageRouteInfo<TradeRouteArgs> {
  TradeRoute({
    _i7.Key? key,
    required String symbol,
    List<_i6.PageRouteInfo>? children,
  }) : super(
          TradeRoute.name,
          args: TradeRouteArgs(
            key: key,
            symbol: symbol,
          ),
          rawPathParams: {'symbol': symbol},
          initialChildren: children,
        );

  static const String name = 'TradeRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<TradeRouteArgs>(
          orElse: () => TradeRouteArgs(symbol: pathParams.getString('symbol')));
      return _i4.TradePage(
        key: args.key,
        symbol: args.symbol,
      );
    },
  );
}

class TradeRouteArgs {
  const TradeRouteArgs({
    this.key,
    required this.symbol,
  });

  final _i7.Key? key;

  final String symbol;

  @override
  String toString() {
    return 'TradeRouteArgs{key: $key, symbol: $symbol}';
  }
}

/// generated route for
/// [_i5.WalletPage]
class WalletRoute extends _i6.PageRouteInfo<void> {
  const WalletRoute({List<_i6.PageRouteInfo>? children})
      : super(
          WalletRoute.name,
          initialChildren: children,
        );

  static const String name = 'WalletRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return _i5.WalletPage();
    },
  );
}
