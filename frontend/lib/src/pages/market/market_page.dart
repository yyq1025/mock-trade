import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mock_trade/main.gr.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:intl/intl.dart';

import 'market_service.dart';
import 'models/market_data.dart';
import 'models/market_update.dart';

@RoutePage()
class MarketPage extends StatefulWidget {
  const MarketPage({
    super.key,
    @PathParam('quoteAsset') this.quoteAsset = 'USDT',
  });
  final String quoteAsset;

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage>
    with SingleTickerProviderStateMixin {
  late WebSocketChannel _channel;
  Map<String, MarketData> _marketData = {};
  Map<String, MarketData> _filteredData = {};
  final TextEditingController _searchController = TextEditingController();
  final MarketService _marketService = MarketService();
  late TabController _tabController;
  bool _isLoading = true;
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
    print('quoteAsset: ${widget.quoteAsset}');
    final initialIndex = quoteAssets.indexOf(widget.quoteAsset);
    _tabController = TabController(
      length: quoteAssets.length,
      vsync: this,
      initialIndex: initialIndex,
    );
    _tabController.addListener(_onTabChange);
    _connectToWebSocket();
    _fetchExchangeInfo();
    _fetchInitMarketData();
    _searchController.addListener(_onSearchChange);
  }

  Future<void> _fetchExchangeInfo() async {
    try {
      final symbols = await _marketService.fetchExchangeInfo();
      final marketDataEntries = symbols.map((symbol) {
        return MapEntry(symbol.symbol, MarketData.fromSymbolInfo(symbol));
      });
      setState(() {
        _marketData = Map.fromEntries(marketDataEntries);
        _filteredData = Map.fromEntries(marketDataEntries);
      });
    } catch (e) {
      print('Error fetching exchange info: $e');
    }
  }

  Future<void> _fetchInitMarketData() async {
    final initData = await _marketService.fetchInitMarketData();
    for (var data in initData) {
      final symbol = data.symbol;
      if (_marketData.containsKey(symbol)) {
        _marketData[symbol]!.init(data);
      }
    }
    setState(() {
      _filteredData = Map.of(_marketData);
      _isLoading = false;
    });
    _filterList();
  }

  void _connectToWebSocket() {
    _channel = WebSocketChannel.connect(
      Uri.parse('wss://data-stream.binance.vision/ws/!miniTicker@arr'),
    );
    _channel.stream.listen((data) {
      if (data == 'ping') {
        _channel.sink.add('pong');
        return;
      }

      final List<dynamic> tickerData = jsonDecode(data);
      final marketUpdates = tickerData.map((json) {
        return MarketUpdate.fromJson(json);
      }).toList();
      setState(() {
        for (var update in marketUpdates) {
          if (_marketData.containsKey(update.symbol)) {
            _marketData[update.symbol]!.update(update);
          }
        }
      });
    });
  }

  void _onTabChange() {
    _selectedQuoteAsset = quoteAssets[_tabController.index];
    _filterList();
    context.router.replaceNamed('/market/$_selectedQuoteAsset');
  }

  void _onSearchChange() {
    _searchQuery = _searchController.text.toLowerCase();
    _filterList();
  }

  void _filterList() {
    setState(() {
      _filteredData = Map.fromEntries(_marketData.entries.where((entry) {
        final crypto = entry.value;
        return crypto.quoteAsset == _selectedQuoteAsset &&
            (crypto.symbol.toLowerCase().contains(_searchQuery) ||
                crypto.baseAsset.toLowerCase().contains(_searchQuery) ||
                crypto.quoteAsset.toLowerCase().contains(_searchQuery));
      }));
    });
  }

  @override
  void dispose() {
    _channel.sink.close();
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Color _getChangeColor(double change) {
    return change < 0 ? Colors.red : Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Market",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: _isLoading
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
                  child: _filteredData.isEmpty
                      ? const Center(child: Text("No data found"))
                      : _getMarketList(),
                ),
              ],
            ),
    );
  }

  ListView _getMarketList() {
    final marketList = _filteredData.values.toList();
    marketList.sort((a, b) => b.volume.compareTo(a.volume));
    return ListView.builder(
      itemCount: marketList.length,
      itemBuilder: (context, index) {
        final data = marketList[index];
        return ListTile(
          onTap: () => {
            context.router.push(TradeRoute(symbol: data.symbol)),
          },
          title: Text.rich(
            TextSpan(
              text: data.baseAsset,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              children: [
                TextSpan(
                  text: " /${data.quoteAsset}",
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
            NumberFormat.compact(locale: "en_US", explicitSign: false)
                .format(data.volume),
            style: const TextStyle(color: Colors.blueGrey),
          ),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                data.price.toString(),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                "${data.percentChange.toStringAsFixed(2)}%",
                style: TextStyle(
                  color: _getChangeColor(data.percentChange),
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
