import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/stock_model.dart';
import '../../../providers/search_history_provider.dart';
import '../../detail/detail_screen.dart';
import 'search_item_card.dart';

class SearchResultList extends ConsumerWidget {
  final List<StockModel> results;

  const SearchResultList({Key? key, required this.results}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final stock = results[index];

        // Card
        return SearchItemCard(
          stock: stock,
          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          onTap: () {
            ref.read(searchHistoryProvider.notifier).addHistory(stock);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StockDetailScreen(stock: stock)),
            );
          },
        );

      },
    );
  }
}