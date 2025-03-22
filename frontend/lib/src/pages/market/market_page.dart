import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:mock_trade/main.gr.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers.dart';

@RoutePage()
class MarketPage extends ConsumerStatefulWidget {
  const MarketPage({
    super.key,
    @PathParam('quoteAsset') this.quoteAsset = 'USDT',
  });
  final String quoteAsset;

  @override
  ConsumerState<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends ConsumerState<MarketPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  String _searchQuery = '';
  String _selectedQuoteAsset = 'USDT';

  static const List<String> quoteAssets = [
    'USDT',
    'FDUSD',
    'USDC',
    'TUSD',
    'BNB',
    'BTC',
    'ETH',
    'DAI',
    'EUR',
    'TRY'
  ];

  @override
  void initState() {
    super.initState();
    final initialIndex = quoteAssets.indexOf(widget.quoteAsset);
    _tabController = TabController(
      length: quoteAssets.length,
      vsync: this,
      initialIndex: initialIndex,
    );
    _tabController.addListener(_onTabChange);
    _searchController.addListener(_onSearchChange);
  }

  void _onTabChange() {
    setState(() {
      _selectedQuoteAsset = quoteAssets[_tabController.index];
    });
    context.router.replaceNamed('/market/$_selectedQuoteAsset');
  }

  void _onSearchChange() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final symbolInfos = ref.watch(exchangeInfoProvider).valueOrNull;
    final binanceTickers = ref.watch(binanceTickersProvider).valueOrNull;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Market",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        elevation: 1,
      ),
      body: (symbolInfos == null || binanceTickers == null)
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Search Coin Pair...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  controller: _tabController,
                  tabs: quoteAssets.map((e) => Tab(text: e)).toList(),
                ),
                Expanded(
                  child: _getMarketList(),
                ),
              ],
            ),
    );
  }

  ListView _getMarketList() {
    final symbolInfos = ref.watch(exchangeInfoProvider).valueOrNull;
    final binanceTickers =
        ref.watch(binanceTickersProvider).valueOrNull!.values;

    final filteredTickers = binanceTickers
        .where((ticker) =>
            ticker.symbol.endsWith(_selectedQuoteAsset) &&
            ticker.symbol.toUpperCase().contains(_searchQuery.toUpperCase()) &&
            symbolInfos!.containsKey(ticker.symbol))
        .toList();
    filteredTickers.sort((a, b) => b.quoteVolume.compareTo(a.quoteVolume));
    return ListView.builder(
      itemCount: filteredTickers.length,
      itemBuilder: (context, index) {
        final data = filteredTickers[index];
        return ListTile(
          onTap: () => {
            context.router.push(TradeRoute(symbol: data.symbol)),
          },
          title: Text.rich(
            TextSpan(
              text: symbolInfos![data.symbol]?.baseAsset,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              children: [
                TextSpan(
                  text: " /${symbolInfos[data.symbol]?.quoteAsset}",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          subtitle: Text(
            NumberFormat.compact(locale: "en_US").format(data.quoteVolume),
            style: const TextStyle(color: Colors.blueGrey),
          ),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                data.lastPrice.toString(),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                "${(((data.lastPrice - data.openPrice) * Decimal.fromInt(100)) / data.openPrice).toDouble().toStringAsFixed(2)}%",
                style: TextStyle(
                  color: data.lastPrice < data.openPrice
                      ? Colors.red
                      : Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
