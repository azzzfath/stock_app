import 'dart:convert';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hive/hive.dart';
import '../models/stock_model.dart';

class SearchHistoryNotifier extends StateNotifier<List<StockModel>> {
  final Box<String> _box = Hive.box<String>('search_history');

  SearchHistoryNotifier() : super([]) {
    _loadHistory();
  }

  void _loadHistory() {
    final List<StockModel> history = [];

    for (var value in _box.values) {
      try {
        final map = jsonDecode(value);
        history.add(StockModel(
          symbol: map['symbol'] ?? '',
          companyName: map['companyName'] ?? '',
          price: map['price'] ?? 0.0,
          volume: map['volume'] ?? 0,
          changePercent: map['changePercent'] ?? '0%',
          description: map['description'] ?? '',
        ));
      } catch (e) {

      }
    }

    state = history.reversed.toList();
  }

  void addHistory(StockModel stock) {
    final existingKey = _box.keys.firstWhere(
          (k) {
        final value = _box.get(k);
        if (value == null) return false;
        try {
          final map = jsonDecode(value);
          return map['symbol'] == stock.symbol;
        } catch (e) {
          return false;
        }
      },
      orElse: () => null,
    );

    if (existingKey != null) {
      _box.delete(existingKey);
    }

    final stockJson = jsonEncode({
      'symbol': stock.symbol,
      'companyName': stock.companyName,
      'price': stock.price,
      'volume': stock.volume,
      'changePercent': stock.changePercent,
      'description': stock.description,
    });

    _box.add(stockJson);

    if (_box.length > 10) {
      _box.deleteAt(0);
    }

    _loadHistory();
  }

  void removeHistory(String symbol) {
    final existingKey = _box.keys.firstWhere(
          (k) {
        final value = _box.get(k);
        if (value == null) return false;
        try {
          final map = jsonDecode(value);
          return map['symbol'] == symbol;
        } catch (e) {
          return false;
        }
      },
      orElse: () => null,
    );

    if (existingKey != null) {
      _box.delete(existingKey);
      _loadHistory();
    }
  }

  void clearAll() {
    _box.clear();
    state = [];
  }
}

// Dont uses autoDispose
final searchHistoryProvider = StateNotifierProvider<SearchHistoryNotifier, List<StockModel>>((ref) {
  return SearchHistoryNotifier();
});