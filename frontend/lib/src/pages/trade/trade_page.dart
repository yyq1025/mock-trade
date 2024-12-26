import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

@RoutePage()
class TradePage extends StatelessWidget {
  TradePage({
    Key? key,
    @PathParam('symbol') required this.symbol,
  }) : super(key: key);
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
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: Text(symbol),
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
                                  '101,093.99',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                                Text(
                                  '-2,789.91 (-2.69%)',
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
                                    Text('105,350.00'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('24h Low',
                                        style:
                                            TextStyle(color: Colors.blueGrey)),
                                    Text('98,802.00'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('24h Vol. (BTC)',
                                        style:
                                            TextStyle(color: Colors.blueGrey)),
                                    Text('52.88K'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('24h Vol. (USDT)',
                                        style:
                                            TextStyle(color: Colors.blueGrey)),
                                    Text('5.405B'),
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
                          Tab(text: 'Order History'),
                          Tab(text: 'Trade History'),
                          Tab(text: 'Funds'),
                        ],
                      ),
                    ),
                  ),
                ],
                body: TabBarView(
                  children: [
                    ListView(children: [Placeholder()]),
                    ListView(children: [Placeholder()]),
                    ListView(children: [Placeholder()]),
                    ListView(children: [Placeholder()]),
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
                                  height: 400,
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      children: [
                                        _ActionButton(
                                            initialAction: ActionType.buy),
                                        SizedBox(height: 16),
                                        TextField(
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Price'),
                                        ),
                                        SizedBox(height: 16),
                                        TextField(),
                                        SizedBox(height: 16),
                                        TextField(),
                                      ],
                                    ),
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
                        onPressed: () {},
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

enum ActionType {
  buy,
  sell,
}

class _ActionButton extends StatefulWidget {
  const _ActionButton({required this.initialAction});
  final ActionType initialAction;
  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  late ActionType selectedAction;

  @override
  void initState() {
    super.initState();
    selectedAction = widget.initialAction;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SegmentedButton(
        style: SegmentedButton.styleFrom(
          selectedBackgroundColor:
              selectedAction == ActionType.buy ? Colors.green : Colors.red,
          selectedForegroundColor: Colors.white,
          foregroundColor: Colors.blueGrey,
        ),
        showSelectedIcon: false,
        segments: [
          ButtonSegment(value: ActionType.buy, label: Text('Buy')),
          ButtonSegment(value: ActionType.sell, label: Text('Sell')),
        ],
        selected: {selectedAction},
        onSelectionChanged: (Set<ActionType> newSelection) {
          setState(() {
            selectedAction = newSelection.first;
          });
        },
      ),
    );
  }
}
