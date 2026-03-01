import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/stock_model.dart';
import '../../../core/network/api_client.dart';

final isSearchLoadingProvider = StateProvider.autoDispose<bool>((ref) => false);

class SearchNotifier extends StateNotifier<List<StockModel>> {
  final Ref ref;

  SearchNotifier(this.ref) : super([]);

  // Search API
  Future<void> searchStocks(String keyword) async {
    if (keyword.trim().isEmpty) {
      state = [];
      return;
    }

    ref.read(isSearchLoadingProvider.notifier).state = true;

    try {
      final dio = ref.read(dioProvider);

      final response = await dio.get(
        '',
        queryParameters: {
          'function': 'SYMBOL_SEARCH',
          'keywords': keyword,
        },
      );

      final data = response.data;

      if (data != null && data['bestMatches'] != null) {
        final List<dynamic> matches = data['bestMatches'];

        state = matches.map((item) {
          return StockModel(
            symbol: item['1. symbol'] ?? '',
            companyName: item['2. name'] ?? 'Unknown Company',
            price: 0.0,
            changePercent: '0%',
            volume: 0,
            description: '',
          );
        }).toList();
      } else {
        state = _getDummySearchResults(keyword);
      }

    } catch (e) {
      state = _getDummySearchResults(keyword);
    } finally {
      ref.read(isSearchLoadingProvider.notifier).state = false;
    }
  }

  void clear() => state = [];


  // Dummy
  List<StockModel> _getDummySearchResults(String keyword) {
    final allDummies = [
      StockModel(symbol: 'NFLX', companyName: 'Netflix Inc.', price: 605.20, volume: 8000000, changePercent: '-5.4%', description: ''),
      StockModel(symbol: 'AAPL', companyName: 'Apple Inc.', price: 189.12, volume: 120000000, changePercent: '+0.4%', description: ''),
      StockModel(symbol: 'TSLA', companyName: 'Tesla Inc.', price: 175.34, volume: 98000000, changePercent: '+3.8%', description: ''),
      StockModel(symbol: 'NVDA', companyName: 'NVIDIA Corporation', price: 822.79, volume: 45000000, changePercent: '+4.5%', description: ''),
      StockModel(symbol: 'AMZN', companyName: 'Amazon.com Inc.', price: 178.10, volume: 85000000, changePercent: '-0.1%', description: ''),
      StockModel(symbol: 'GOOGL', companyName: 'Alphabet Inc.', price: 152.30, volume: 55000000, changePercent: '+0.2%', description: ''),
      StockModel(symbol: 'MSFT', companyName: 'Microsoft Corp.', price: 415.50, volume: 22000000, changePercent: '+1.2%', description: ''),
    ];

    final lowerKeyword = keyword.toLowerCase();

    return allDummies.where((stock) {
      return stock.symbol.toLowerCase().contains(lowerKeyword) ||
          stock.companyName.toLowerCase().contains(lowerKeyword);
    }).toList();
  }
}

final searchProvider = StateNotifierProvider.autoDispose<SearchNotifier, List<StockModel>>((ref) {
  return SearchNotifier(ref);
});