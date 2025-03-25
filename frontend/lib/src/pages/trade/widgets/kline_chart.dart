import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mock_trade/src/pages/trade/providers/klines_provider.dart';

class KlineChart extends ConsumerWidget {
  final String symbol;
  const KlineChart({super.key, required this.symbol});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final klines = ref.watch(klinesProvider(symbol)).valueOrNull;
    return SizedBox(
      height: 400,
      child: klines == null
          ? Center(child: CircularProgressIndicator())
          : LineChart(
              LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: klines
                          .map((kline) =>
                              FlSpot(kline.openTime, kline.close.toDouble()))
                          .toList(),
                      dotData: const FlDotData(show: false),
                      color: klines.last.close > klines.first.open
                          ? Colors.green
                          : Colors.red,
                      belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                              colors: klines.last.close > klines.first.open
                                  ? [
                                      Colors.green.withValues(alpha: 0.3),
                                      Colors.green.withValues(alpha: 0)
                                    ]
                                  : [
                                      Colors.red.withValues(alpha: 0.3),
                                      Colors.red.withValues(alpha: 0)
                                    ],
                              stops: const [0.5, 1],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter)),
                    )
                  ],
                  titlesData: FlTitlesData(
                      show: true,
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                        ),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 60,
                          maxIncluded: false,
                          minIncluded: false,
                          getTitlesWidget: (value, meta) => Text(
                            value.toString(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                        showTitles: true,
                        interval: 4 * 60 * 60 * 1000,
                        maxIncluded: false,
                        minIncluded: false,
                        getTitlesWidget: (value, meta) => Text(
                          DateFormat.Hm().format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  value.toInt())),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                      ))),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                  extraLinesData: ExtraLinesData(horizontalLines: [
                    HorizontalLine(
                      y: klines.last.close,
                      color: Colors.grey,
                      strokeWidth: 1,
                      dashArray: [5, 5],
                      label: HorizontalLineLabel(
                        show: true,
                        alignment: Alignment.topLeft,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                        labelResolver: (line) => line.y.toString(),
                      ),
                    ),
                  ])),
              duration: const Duration(milliseconds: 0),
            ),
    );
  }
}
