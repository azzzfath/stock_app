import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/detail_provider.dart';

class TimeFilterRow extends ConsumerWidget {
  const TimeFilterRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFilter = ref.watch(chartTimeFilterProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: ChartTimeFilter.values.map((filter) {
        final isSelected = selectedFilter == filter;
        final theme = Theme.of(context);

        return GestureDetector(
          onTap: () => ref.read(chartTimeFilterProvider.notifier).state = filter,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? theme.colorScheme.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              filter.label,
              style: TextStyle(
                color: isSelected ? theme.colorScheme.onPrimary : theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}