import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/stock_model.dart';
import '../../../providers/search_history_provider.dart';
import '../../detail/detail_screen.dart';
import 'search_item_card.dart';

class SearchHistoryList extends ConsumerWidget {
  final List<StockModel> history;

  const SearchHistoryList({Key? key, required this.history}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    if (history.isEmpty) {
      return Center(
        child: Text(
          'Ready to explore? Find a stock...',
          style: TextStyle(color: theme.textTheme.bodyMedium?.color),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Terakhir Dilihat',
                style: TextStyle(color: theme.textTheme.bodyLarge?.color, fontWeight: FontWeight.bold),
              ),

              // Empty search history
              GestureDetector(
                onTap: () => ref.read(searchHistoryProvider.notifier).clearAll(),
                child: Text(
                  'Hapus Semua',
                  style: TextStyle(color: theme.colorScheme.primary, fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),

            ],
          ),
        ),

        Expanded(
          child: ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              final stock = history[index];

              // Card
              return SearchItemCard(
                stock: stock,
                trailing: IconButton(
                  icon: Icon(Icons.close, size: 20, color: theme.textTheme.bodyMedium?.color),
                  onPressed: () => ref.read(searchHistoryProvider.notifier).removeHistory(stock.symbol),
                ),
                onTap: () {

                  // Save history and go to detail
                  ref.read(searchHistoryProvider.notifier).addHistory(stock);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StockDetailScreen(stock: stock)),
                  );

                },
              );
            },
          ),
        ),
      ],
    );
  }
}