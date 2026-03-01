import 'package:flutter/material.dart';
import '../../../models/stock_model.dart';

class SearchItemCard extends StatelessWidget {
  final StockModel stock;
  final Widget trailing;
  final VoidCallback onTap;

  const SearchItemCard({
    Key? key,
    required this.stock,
    required this.trailing,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),

      decoration: BoxDecoration(
        border: Border.symmetric(horizontal: BorderSide(
          color: theme.dividerColor.withOpacity(0.05),
          width: 0.5,
        )),
        color: Colors.transparent,
      ),


      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),

        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
          child: Text(
            stock.symbol.isNotEmpty ? stock.symbol[0].toUpperCase() : '?',
            style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
          ),
        ),

        title: Text(
          stock.symbol,
          style: TextStyle(color: theme.textTheme.bodyLarge?.color, fontWeight: FontWeight.bold),
        ),

        subtitle: Text(
          stock.companyName,
          style: TextStyle(color: theme.textTheme.bodyMedium?.color),
        ),

        trailing: trailing,

        onTap: onTap,
      ),
    );
  }
}