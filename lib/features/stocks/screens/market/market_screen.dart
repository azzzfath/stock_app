import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart'; // Pastikan sudah install iconsax
import '../../providers/market_provider.dart';
import '../search/search_screen.dart'; // Sesuaikan path search screen kamu
import 'widgets/category_tab_bar.dart';
import 'widgets/stock_card.dart';

class MarketScreen extends ConsumerWidget {
  const MarketScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marketData = ref.watch(stockListProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final isLoading = ref.watch(isLoadingProvider);
    final currentList = marketData[selectedCategory] ?? [];
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [

          // AppBar
          SliverAppBar(
            centerTitle: false,
            floating: true,
            snap: true,
            toolbarHeight: 80,
            titleSpacing: 24,
            title: const Text(
              "Market",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),


            actions: [

              // Search Icon
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SearchScreen()),
                  );
                },

                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(

                    color: theme.colorScheme.surfaceVariant,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.dividerColor.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Iconsax.search_normal_1,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 24),
            ],


            bottom: isLoading
                ? const PreferredSize(
              preferredSize: Size.fromHeight(2),
              child: LinearProgressIndicator(),
            )
                : null,
          ),

          // Category Tab
          SliverToBoxAdapter(
            child: Column(
              children: [
                const CategoryTabBar(),
                const SizedBox(height: 4),
              ],
            ),
          ),

          // Stock List
          currentList.isEmpty && !isLoading
              ? const SliverFillRemaining(
            child: Center(child: Text('Data tidak ditemukan')),
          )
              : SliverPadding(
            padding: const EdgeInsets.only(bottom: 24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return StockCard(stock: currentList[index]);
                },
                childCount: currentList.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}