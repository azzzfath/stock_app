import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../../providers/detail_provider.dart';

class StockChart extends ConsumerWidget {
  final String symbol;
  const StockChart({Key? key, required this.symbol}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final chartAsyncValue = ref.watch(stockChartProvider(symbol));

    return Container(
      height: 300,
      width: double.infinity,
      padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 16),

      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
      ),

      child: chartAsyncValue.when(

        loading: () => const Center(child: CircularProgressIndicator()),

        error: (error, stack) => Center(child: Text('Gagal memuat grafik:\n$error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 12))),

        data: (points) {

          if (points.isEmpty) return const Center(child: Text('Data grafik kosong'));

          final spots = points.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.price)).toList();
          final minY = points.map((p) => p.price).reduce((a, b) => a < b ? a : b);
          final maxY = points.map((p) => p.price).reduce((a, b) => a > b ? a : b);

          return LineChart(

            LineChartData(

              gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(color: theme.dividerColor.withOpacity(0.1), strokeWidth: 1)
              ),

              titlesData: FlTitlesData(
                show: true,
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),

                leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {

                          if (value <= minY) {
                            return const SizedBox.shrink();
                          }

                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Text(
                              '\$${value.toInt()}',
                              style: TextStyle(color: theme.textTheme.bodySmall?.color, fontSize: 10),
                            ),
                          );
                        },
                    )
                ),

                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,

                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= 0 && value.toInt() < points.length) {
                        if (value.toInt() == 0 || value.toInt() == points.length - 1 || value.toInt() == points.length ~/ 2) {
                          return Text(DateFormat('MMM d').format(points[value.toInt()].date), style: TextStyle(color: theme.textTheme.bodySmall?.color, fontSize: 10));
                        }
                      }

                      return const SizedBox.shrink();

                    },
                  ),
                ),
              ),

              borderData: FlBorderData(show: false),
              minX: 0, maxX: (points.length - 1).toDouble(),
              minY: minY - (minY * 0.01), maxY: maxY + (maxY * 0.01),

              lineBarsData: [

                LineChartBarData(
                  spots: spots, isCurved: false, color: theme.colorScheme.primary, barWidth: 2, isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(show: true, color: theme.colorScheme.primary.withOpacity(0.1)),
                ),

              ],

              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(

                  getTooltipColor: (touchedSpot) => theme.colorScheme.primaryContainer,
                  getTooltipItems: (List<LineBarSpot> touchedSpots) {
                    return touchedSpots.map((spot) {
                      final formattedPrice = spot.y.toStringAsFixed(2);

                      return LineTooltipItem(
                        '\$ $formattedPrice',
                        TextStyle(
                          color: theme.colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      );

                    }).toList();
                  },

                ),

                handleBuiltInTouches: true,

              ),



            ),
          );
        },
      ),
    );
  }
}