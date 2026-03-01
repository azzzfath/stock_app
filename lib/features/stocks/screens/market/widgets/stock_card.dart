import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../models/stock_model.dart';
import '../../detail/detail_screen.dart';

class StockCard extends StatelessWidget {
  final StockModel stock;

  const StockCard({Key? key, required this.stock}) : super(key: key);

  String formatVolume(int volume) {
    if (volume >= 1000000) return '${(volume / 1000000).toStringAsFixed(1)}M';
    if (volume >= 1000) return '${(volume / 1000).toStringAsFixed(1)}K';
    return volume.toString();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isPositive = !stock.changePercent.startsWith('-');
    final color = isPositive ? AppColors.greenAccent : AppColors.redAccent;
    final arrow = isPositive ? '↗' : '↘';

    final initialLetter = stock.symbol.isNotEmpty ? stock.symbol[0].toUpperCase() : '?';

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StockDetailScreen(stock: stock),
          ),
        );
      },

      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),

        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(
            color: theme.dividerColor.withOpacity(0.1),
            width: 1,
          ), ),
          color: Colors.transparent,
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                  child: Text(
                    initialLetter,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stock.symbol,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Vol: ${formatVolume(stock.volume)}',
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${stock.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$arrow ${stock.changePercent}',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}