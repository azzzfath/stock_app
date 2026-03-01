import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../../core/network/api_client.dart';
import '../models/chart_point_model.dart';
import '../models/stock_model.dart';

final stockDetailProvider = FutureProvider.autoDispose.family<StockModel, StockModel>((ref, initialStock) async {
  final dio = ref.watch(dioProvider);

  final bool needsPrice = initialStock.price <= 0;
  final bool needsOverview = initialStock.description.isEmpty;

  if (!needsPrice && !needsOverview) {
    return initialStock;
  }

  try {
    List<Future> requests = [];

    if (needsOverview) {
      requests.add(dio.get('', queryParameters: {
        'function': 'OVERVIEW',
        'symbol': initialStock.symbol
      }));
    }

    if (needsPrice) {
      requests.add(dio.get('', queryParameters: {
        'function': 'GLOBAL_QUOTE',
        'symbol': initialStock.symbol
      }));
    }

    final results = await Future.wait(requests);

    Map<String, dynamic> overviewData = {};
    Map<String, dynamic> quoteData = {};

    int index = 0;
    if (needsOverview) {
      overviewData = results[index++].data ?? {};
    }
    if (needsPrice) {
      final rawQuote = results[index++].data;
      if (rawQuote != null && rawQuote['Global Quote'] != null) {
        quoteData = rawQuote['Global Quote'];
      }
    }

    if (overviewData.containsKey('Note') ||
        overviewData.containsKey('Information') ||
        quoteData.isEmpty && needsPrice) {
      return _getDummyDetailData(initialStock);
    }

    return StockModel(
      symbol: initialStock.symbol,

      price: needsPrice
          ? (double.tryParse(quoteData['05. price']?.toString() ?? '') ?? initialStock.price)
          : initialStock.price,

      companyName: needsOverview
          ? (overviewData['Name'] ?? initialStock.companyName)
          : initialStock.companyName,

      description: needsOverview
          ? (overviewData['Description'] ?? initialStock.description)
          : initialStock.description,

      marketCap: overviewData['MarketCapitalization'] ?? initialStock.marketCap,
      peRatio: overviewData['PERatio'] ?? initialStock.peRatio,
      divYield: overviewData['DividendYield'] ?? initialStock.divYield,
      sector: overviewData['Sector'] ?? initialStock.sector,

      changePercent: needsPrice
          ? (quoteData['10. change percent'] ?? initialStock.changePercent)
          : initialStock.changePercent,

      volume: needsPrice
          ? (int.tryParse(quoteData['06. volume']?.toString() ?? '') ?? initialStock.volume)
          : initialStock.volume,
    );
  } catch (e) {
    return _getDummyDetailData(initialStock);
  }
});

final stockChartProvider = FutureProvider.autoDispose.family<List<ChartPointModel>, String>((ref, symbol) async {
  final filter = ref.watch(chartTimeFilterProvider);
  final dio = ref.watch(dioProvider);

  await Future.delayed(const Duration(milliseconds: 500));

  final queryParams = {
    'function': filter.apiFunction,
    'symbol': symbol,
  };

  try {
    final response = await dio.get('', queryParameters: queryParams);
    final data = response.data;

    if (data == null || data[filter.jsonKey] == null || data.containsKey('Note') || data.containsKey('Information')) {
      return _getDummyChartData(filter);
    }

    final Map<String, dynamic> timeSeries = data[filter.jsonKey];
    List<ChartPointModel> points = [];

    timeSeries.forEach((dateString, priceData) {
      final closePrice = double.tryParse(priceData['4. close']?.toString() ?? '0') ?? 0.0;
      points.add(ChartPointModel(
        date: DateTime.parse(dateString),
        price: closePrice,
      ));
    });

    points.sort((a, b) => a.date.compareTo(b.date));

    return filter.filterPoints(points);

  } catch (e) {
    return _getDummyChartData(filter);
  }
});

StockModel _getDummyDetailData(StockModel initialStock) {
  return StockModel(
    symbol: initialStock.symbol,
    price: initialStock.price,
    volume: initialStock.volume,
    companyName: initialStock.companyName.isEmpty ? 'Perusahaan Simulasi' : initialStock.companyName,
    description: 'Ini adalah data simulasi karena API Limit Alpha Vantage tercapai. ${initialStock.companyName} adalah perusahaan teknologi multinasional.',
    marketCap: '1.5T',
    peRatio: '28.5',
    divYield: '1.2%',
    sector: 'Technology',
    changePercent: initialStock.changePercent,
  );
}

enum ChartTimeFilter { oneMonth, oneYear, fiveYears }

extension ChartTimeFilterExt on ChartTimeFilter {
  String get label {
    switch (this) {
      case ChartTimeFilter.oneMonth: return 'Month';
      case ChartTimeFilter.oneYear: return 'Year';
      case ChartTimeFilter.fiveYears: return '5 Year';
    }
  }

  String get apiFunction {
    switch (this) {
      case ChartTimeFilter.oneMonth: return 'TIME_SERIES_DAILY';
      case ChartTimeFilter.oneYear: return 'TIME_SERIES_WEEKLY';
      case ChartTimeFilter.fiveYears: return 'TIME_SERIES_MONTHLY';
    }
  }

  String get jsonKey {
    switch (this) {
      case ChartTimeFilter.oneMonth: return 'Time Series (Daily)';
      case ChartTimeFilter.oneYear: return 'Weekly Time Series';
      case ChartTimeFilter.fiveYears: return 'Monthly Time Series';
    }
  }

  List<ChartPointModel> filterPoints(List<ChartPointModel> points) {
    if (points.isEmpty) return points;
    switch (this) {
      case ChartTimeFilter.oneMonth:
        return points.length > 22 ? points.sublist(points.length - 22) : points;
      case ChartTimeFilter.oneYear:
        return points.length > 52 ? points.sublist(points.length - 52) : points;
      case ChartTimeFilter.fiveYears:
        return points.length > 60 ? points.sublist(points.length - 60) : points;
    }
  }
}

final chartTimeFilterProvider = StateProvider.autoDispose<ChartTimeFilter>((ref) => ChartTimeFilter.oneMonth);

List<ChartPointModel> _getDummyChartData(ChartTimeFilter filter) {
  final now = DateTime.now();
  int dataPoints = 0;
  Duration timeStep;

  switch (filter) {
    case ChartTimeFilter.oneMonth: dataPoints = 22; timeStep = const Duration(days: 1); break;
    case ChartTimeFilter.oneYear: dataPoints = 52; timeStep = const Duration(days: 7); break;
    case ChartTimeFilter.fiveYears: dataPoints = 60; timeStep = const Duration(days: 30); break;
  }

  List<ChartPointModel> dummyPoints = [];
  double basePrice = 150.0;
  for (int i = dataPoints; i >= 0; i--) {
    basePrice = basePrice + (i % 2 == 0 ? 3.5 : -2.1);
    dummyPoints.add(ChartPointModel(date: now.subtract(timeStep * i), price: basePrice));
  }
  return dummyPoints;
}