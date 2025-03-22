import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mock_trade/src/providers.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../wallet/providers/balances_provider.dart';
import 'order_form.dart';
import 'providers/open_orders_provider.dart';
import 'providers/trade_history_provider.dart';

@RoutePage()
class TradePage extends ConsumerWidget {
  TradePage({
    super.key,
    @PathParam('symbol') required this.symbol,
  });
  final String symbol;
  late final WebViewController controller = _initController();

  WebViewController _initController() {
    return WebViewController()
      ..loadHtmlString('''
       <!DOCTYPE html>
       <html>
         <head>
           <meta name="viewport" content="width=device-width, initial-scale=1.0">
           <style>
             body { margin: 0; height: 400px; }
           </style>
         </head>
         <body>
           <div class="tradingview-widget-container" style="height:100%;width:100%">
            <div class="tradingview-widget-container__widget" style="height:100%;width:100%"></div>
            <script type="text/javascript" src="https://s3.tradingview.com/external-embedding/embed-widget-advanced-chart.js" async>
              {
                "autosize": true,
                "symbol": "BINANCE:$symbol",
                "interval": "D",
                "timezone": "Etc/UTC",
                "theme": "light",
                "style": "1",
                "locale": "en",
                "hide_legend": true,
                "allow_symbol_change": false,
                "save_image": false,
                "calendar": false,
                "support_host": "https://www.tradingview.com"
              }
            </script>
          </div>
         </body>
       </html>
     ''')
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ticker = ref.watch(binanceTickersProvider).valueOrNull?[symbol];
    final symbolInfo = ref.watch(exchangeInfoProvider).valueOrNull?[symbol];
    ref.listen(tradeHistoryProvider, (previous, tradeHistory) {
      if (previous?.valueOrNull != null) {
        tradeHistory.valueOrNull
            ?.where((trade) => !previous!.value!.contains(trade))
            .forEach((trade) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  '${trade.side} ${trade.quantity} ${trade.symbolInfo.baseAsset} Filled @ ${trade.executionPrice} ${trade.symbolInfo.quoteAsset}'),
              showCloseIcon: true,
            ),
          );
        });
      }
    });
    if (ticker == null) {
      return Scaffold(
        appBar: AppBar(title: Text(symbol)),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: Text('${symbolInfo?.baseAsset}/${symbolInfo?.quoteAsset}',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        body: Column(
          children: [
            Expanded(
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverToBoxAdapter(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${ticker.lastPrice}',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                                Text(
                                  '${ticker.lastPrice - ticker.openPrice} (${(((ticker.lastPrice - ticker.openPrice) * Decimal.fromInt(100)) / ticker.openPrice).toDouble().toStringAsFixed(2)}%)',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('24h High',
                                        style:
                                            TextStyle(color: Colors.blueGrey)),
                                    Text('${ticker.highPrice}'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('24h Low',
                                        style:
                                            TextStyle(color: Colors.blueGrey)),
                                    Text('${ticker.lowPrice}'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('24h Vol. (${symbolInfo?.baseAsset})',
                                        style:
                                            TextStyle(color: Colors.blueGrey)),
                                    Text(NumberFormat.compact(locale: "en_US")
                                        .format(ticker.volume)),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('24h Vol. (${symbolInfo?.quoteAsset})',
                                        style:
                                            TextStyle(color: Colors.blueGrey)),
                                    Text(NumberFormat.compact(locale: "en_US")
                                        .format(ticker.quoteVolume)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 400,
                      child: WebViewWidget(controller: controller),
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _StickyTabBarDelegate(
                      TabBar(
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                        tabs: [
                          Tab(text: 'Open Orders'),
                          Tab(text: 'Trade History'),
                          Tab(text: 'Funds'),
                        ],
                      ),
                    ),
                  ),
                ],
                body: TabBarView(
                  children: [
                    OpenOrdersList(),
                    TradeHistoryList(),
                    BalancesList()
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return SizedBox(
                                  height: 450,
                                  width: double.infinity,
                                  child: OrderForm(
                                    initialValues: {
                                      'symbol': symbol,
                                      'side': 'BUY',
                                      'orderType': 'LIMIT',
                                    },
                                    onfinished: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                );
                              });
                        },
                        child: Text('Buy',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return SizedBox(
                                  height: 450,
                                  width: double.infinity,
                                  child: OrderForm(
                                    initialValues: {
                                      'symbol': symbol,
                                      'side': 'SELL',
                                      'orderType': 'LIMIT',
                                    },
                                    onfinished: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                );
                              });
                        },
                        child: Text('Sell',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  _StickyTabBarDelegate(this.tabBar);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;
  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  bool shouldRebuild(covariant _StickyTabBarDelegate oldDelegate) {
    return false;
  }
}

class OpenOrdersList extends ConsumerWidget {
  const OpenOrdersList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final openOrders = ref.watch(openOrdersProvider).valueOrNull;
    return openOrders == null
        ? Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: () => ref.refresh(openOrdersProvider.future),
            child: ListView.separated(
              itemCount: openOrders.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final order = openOrders[index];
                return ListTile(
                  title: Text(
                      '${order.side} ${order.symbolInfo.baseAsset}/${order.symbolInfo.quoteAsset}'),
                  subtitle: Text(
                      '${order.quantity} ${order.symbolInfo.baseAsset} @ ${order.price} ${order.symbolInfo.quoteAsset}'),
                  trailing: FilledButton.tonal(
                      onPressed: () {
                        ref
                            .read(openOrdersProvider.notifier)
                            .cancelOrder(order.orderId);
                      },
                      child: Text('Cancel')),
                );
              },
            ),
          );
  }
}

class TradeHistoryList extends ConsumerWidget {
  const TradeHistoryList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tradeHistory = ref.watch(tradeHistoryProvider).valueOrNull;
    return tradeHistory == null
        ? Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: () => ref.refresh(tradeHistoryProvider.future),
            child: ListView.builder(
              itemCount: tradeHistory.length,
              itemBuilder: (context, index) {
                final trade = tradeHistory[index];
                return ListTile(
                  title: Text(
                      '${trade.side} ${trade.symbolInfo.baseAsset}/${trade.symbolInfo.quoteAsset}'),
                  subtitle: Text(
                      '${trade.quantity} ${trade.symbolInfo.baseAsset} @ ${trade.executionPrice} ${trade.symbolInfo.quoteAsset}'),
                );
              },
            ),
          );
  }
}

class BalancesList extends ConsumerWidget {
  const BalancesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balances = ref.watch(balancesProvider).valueOrNull;
    return balances == null
        ? Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: () => ref.refresh(balancesProvider.future),
            child: ListView.separated(
              itemCount: balances.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final balance = balances[index];
                return ListTile(
                  title: Text(balance.asset),
                  subtitle: Text(balance.free.toString()),
                );
              },
            ),
          );
  }
}
