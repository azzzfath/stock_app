class StockModel {
  final String symbol;
  final String companyName;
  final double price;
  final int volume;
  final String changePercent;
  final String description;
  final String marketCap;
  final String peRatio;
  final String divYield;
  final String sector;

  StockModel({
    required this.symbol,
    required this.companyName,
    required this.price,
    required this.volume,
    required this.changePercent,
    this.description ='',
    this.marketCap = '',
    this.peRatio = '',
    this.divYield = '',
    this.sector = '',
  });
}