import 'package:flutter/material.dart';
import '../../../models/stock_model.dart';

class CompanyHeader extends StatelessWidget {
  final StockModel stock;
  const CompanyHeader({Key? key, required this.stock}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPositive = !stock.changePercent.startsWith('-');
    final changeColor = isPositive ? Colors.green : Colors.red;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        Text(stock.companyName, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),

        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [

            Text('\$${stock.price > 0 ? stock.price.toStringAsFixed(2) : '---'}',
                style: theme.textTheme.displaySmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
            const SizedBox(width: 12),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: changeColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: Text(stock.changePercent, style: TextStyle(color: changeColor, fontWeight: FontWeight.bold)),
            ),

          ],
        ),

      ],
    );
  }
}