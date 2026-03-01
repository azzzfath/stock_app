import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/stock_model.dart';
import '../../providers/detail_provider.dart';
import 'widgets/company_header.dart';
import 'widgets/time_filter_row.dart';
import 'widgets/stock_chart.dart';
import 'widgets/stock_stats.dart';

class StockDetailScreen extends ConsumerWidget {

  final StockModel stock;

  const StockDetailScreen({Key? key, required this.stock}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final detailAsyncValue = ref.watch(stockDetailProvider(stock));
    final theme = Theme.of(context);

    return Scaffold(

      appBar: AppBar(
        title: Text(stock.symbol, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),

      body: detailAsyncValue.when(

        loading: () => const Center(child: CircularProgressIndicator()),

        error: (error, stack) => Center(child: Text('Terjadi kesalahan:\n$error', textAlign: TextAlign.center)),

        data: (realTimeStock) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                CompanyHeader(stock: realTimeStock),
                const SizedBox(height: 24),

                const TimeFilterRow(),
                const SizedBox(height: 16),

                StockChart(symbol: realTimeStock.symbol),
                const SizedBox(height: 24),

                StockStats(stock: realTimeStock),
                const SizedBox(height: 16),

                Text(
                  'About Company',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                Text(
                  realTimeStock.description.isNotEmpty
                      ? realTimeStock.description
                      : 'Company description is not available at the moment.',
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                ),
                const SizedBox(height: 32),

              ],
            ),
          );
        },
      ),
    );
  }
}