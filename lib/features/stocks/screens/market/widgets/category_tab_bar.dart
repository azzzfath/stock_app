import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/market_provider.dart';

class CategoryTabBar extends ConsumerWidget {
  const CategoryTabBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final selectedCategory = ref.watch(selectedCategoryProvider);
    final theme = Theme.of(context);

    return Container(

      color: theme.scaffoldBackgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),

      child: Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
        ),

        child: Row(
          children: [
            _buildTabButton(context, ref, 'Gainers', StockCategory.gainers, selectedCategory),
            const SizedBox(width: 24,),
            _buildTabButton(context, ref, 'Losers', StockCategory.losers, selectedCategory),
            const SizedBox(width: 24,),
            _buildTabButton(context, ref, 'Active', StockCategory.active, selectedCategory),
          ],
        ),
      ),

    );
  }

  Widget _buildTabButton(BuildContext context, WidgetRef ref, String title, StockCategory category, StockCategory selectedCategory) {

    final theme = Theme.of(context);
    final isSelected = selectedCategory == category;
    final isDark = theme.brightness == Brightness.dark;

    return Expanded(
      child: GestureDetector(

        onTap: () => ref.read(selectedCategoryProvider.notifier).state = category,

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),

          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: isSelected ? theme.colorScheme.primary : Colors.transparent , width: 1),
            boxShadow: isSelected && !isDark
                ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))]
                : [],
          ),

          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? Colors.white
                    : theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
              ),
            ),
          ),
        ),
      ),
    );
  }
}