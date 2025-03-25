class Kline {
  final double openTime;
  final double open;
  final double high;
  final double low;
  final double close;
  final double volume;
  final double closeTime;
  final double quoteVolume;

  Kline({
    required this.openTime,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
    required this.closeTime,
    required this.quoteVolume,
  });

  factory Kline.fromRestJson(List<dynamic> json) {
    return Kline(
      openTime: json[0].toDouble(),
      open: double.parse(json[1]),
      high: double.parse(json[2]),
      low: double.parse(json[3]),
      close: double.parse(json[4]),
      volume: double.parse(json[5]),
      closeTime: json[6].toDouble(),
      quoteVolume: double.parse(json[7]),
    );
  }

  factory Kline.fromWSJson(Map<String, dynamic> json) {
    return Kline(
      openTime: json['t'].toDouble(),
      open: double.parse(json['o']),
      high: double.parse(json['h']),
      low: double.parse(json['l']),
      close: double.parse(json['c']),
      volume: double.parse(json['v']),
      closeTime: json['T'].toDouble(),
      quoteVolume: double.parse(json['q']),
    );
  }
}
