import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../core/network/api_client.dart';
import '../models/stock_model.dart';

final isLoadingProvider = StateProvider<bool>((ref) => false);

// Stock category
enum StockCategory { gainers, losers, active }
final selectedCategoryProvider = StateProvider<StockCategory>((ref) => StockCategory.gainers);

// API Stock List
class StockListNotifier extends StateNotifier<Map<StockCategory, List<StockModel>>> {
  final Dio dio;
  final Ref ref;

  StockListNotifier(this.dio, this.ref) : super({
    StockCategory.gainers: [],
    StockCategory.losers: [],
    StockCategory.active: [],
  }) {
    fetchMarketData();
  }

  Future<void> fetchMarketData() async {
    Future.microtask(() => ref.read(isLoadingProvider.notifier).state = true);

    try {
      final response = await dio.get('', queryParameters: {
        'function': 'TOP_GAINERS_LOSERS',
      });

      final data = response.data;

      if (data != null && data['top_gainers'] != null) {
        state = {
          StockCategory.gainers: _parseList(data['top_gainers']),
          StockCategory.losers: _parseList(data['top_losers']),
          StockCategory.active: _parseList(data['most_actively_traded']),
        };
      } else {
        _loadDummyData();
      }
    } catch (e) {
      _loadDummyData();
    } finally {
      Future.microtask(() => ref.read(isLoadingProvider.notifier).state = false);
    }
  }


  // Dummy for API Limit or error
  void _loadDummyData() {
    state = {
      StockCategory.gainers: [
        StockModel(symbol: 'NVDA', companyName: 'NVIDIA Corporation', price: 822.79, volume: 45000000, changePercent: '+4.5%'),
        StockModel(symbol: 'TSLA', companyName: 'Tesla Inc.', price: 175.34, volume: 98000000, changePercent: '+3.8%'),
        StockModel(symbol: 'AMD', companyName: 'Advanced Micro Devices', price: 190.22, volume: 32000000, changePercent: '+2.9%'),
        StockModel(symbol: 'META', companyName: 'Meta Platforms Inc.', price: 505.10, volume: 15000000, changePercent: '+1.7%'),
        StockModel(symbol: 'MSFT', companyName: 'Microsoft Corp.', price: 415.50, volume: 22000000, changePercent: '+1.2%'),
      ],
      StockCategory.losers: [
        StockModel(symbol: 'NFLX', companyName: 'Netflix Inc.', price: 605.20, volume: 8000000, changePercent: '-5.4%'),
        StockModel(symbol: 'PYPL', companyName: 'PayPal Holdings', price: 58.45, volume: 12000000, changePercent: '-3.2%'),
        StockModel(symbol: 'INTC', companyName: 'Intel Corporation', price: 42.10, volume: 28000000, changePercent: '-2.8%'),
        StockModel(symbol: 'BA', companyName: 'Boeing Co.', price: 180.50, volume: 9000000, changePercent: '-1.5%'),
      ],
      StockCategory.active: [
        StockModel(symbol: 'AAPL', companyName: 'Apple Inc.', price: 189.12, volume: 120000000, changePercent: '+0.4%'),
        StockModel(symbol: 'AMZN', companyName: 'Amazon.com Inc.', price: 178.10, volume: 85000000, changePercent: '-0.1%'),
        StockModel(symbol: 'GOOGL', companyName: 'Alphabet Inc.', price: 152.30, volume: 55000000, changePercent: '+0.2%'),
        StockModel(symbol: 'SQ', companyName: 'Block Inc.', price: 72.45, volume: 40000000, changePercent: '+6.5%'),
      ],
    };
  }

  // Json parse
  List<StockModel> _parseList(List<dynamic> list) {
    return list.map((item) {
      return StockModel(
        symbol: item['ticker'] ?? 'N/A',
        companyName: item['ticker'] ?? 'Unknown Company',
        price: double.tryParse(item['price']?.toString() ?? '0') ?? 0.0,
        volume: int.tryParse(item['volume']?.toString() ?? '0') ?? 0,
        changePercent: item['change_percentage']?.toString() ?? '0%',
      );
    }).toList();
  }
}

final stockListProvider = StateNotifierProvider<StockListNotifier, Map<StockCategory, List<StockModel>>>((ref) {
  final dio = ref.read(dioProvider);
  return StockListNotifier(dio, ref);
});