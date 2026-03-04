import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/services/dashboard_service.dart';

class CategoryComparisonChart extends StatelessWidget {
  final Map<String, double> data;
  final double height;
  final String language;

  const CategoryComparisonChart({
    super.key,
    required this.data,
    this.height = 200,
    this.language = 'es',
  });

  Color _getScoreColor(double score) {
    if (score >= 90) return const Color(0xFF1B5E20);
    if (score >= 75) return const Color(0xFF4CAF50);
    if (score >= 50) return const Color(0xFFFFB300);
    if (score >= 25) return const Color(0xFFFF9800);
    return const Color(0xFFE53935);
  }

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return SizedBox(
        height: height,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.bar_chart, size: 48, color: Colors.grey.shade300),
              const SizedBox(height: 8),
              Text(
                'Sin datos de categorías',
                style: TextStyle(color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
      );
    }

    final sortedEntries = data.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return SizedBox(
      height: height,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 100,
          minY: 0,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (group) => Colors.grey.shade800,
              tooltipPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final entry = sortedEntries[group.x.toInt()];
                final name = DashboardService.getCategoryName(entry.key, language);
                return BarTooltipItem(
                  '$name\n',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  children: [
                    TextSpan(
                      text: '${entry.value.toStringAsFixed(1)}%',
                      style: TextStyle(
                        color: _getScoreColor(entry.value),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= sortedEntries.length) {
                    return const SizedBox.shrink();
                  }
                  final entry = sortedEntries[value.toInt()];
                  final name = DashboardService.getCategoryName(entry.key, language);
                  // Abreviar si es muy largo
                  final shortName = name.length > 8 ? '${name.substring(0, 6)}...' : name;
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      shortName,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                },
                reservedSize: 30,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 35,
                interval: 25,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}%',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 10,
                    ),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 25,
            getDrawingHorizontalLine: (value) {
              Color lineColor = Colors.grey.shade200;
              if (value == 75) lineColor = const Color(0xFF4CAF50).withOpacity(0.3);
              if (value == 50) lineColor = const Color(0xFFFFB300).withOpacity(0.3);
              
              return FlLine(
                color: lineColor,
                strokeWidth: 1,
                dashArray: value == 75 || value == 50 ? [5, 5] : null,
              );
            },
          ),
          borderData: FlBorderData(show: false),
          barGroups: sortedEntries.asMap().entries.map((entry) {
            final index = entry.key;
            final value = entry.value.value;
            final color = _getScoreColor(value);
            
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: value,
                  gradient: LinearGradient(
                    colors: [
                      color.withOpacity(0.7),
                      color,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  width: 28,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(6),
                    topRight: Radius.circular(6),
                  ),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: 100,
                    color: Colors.grey.shade100,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
        swapAnimationDuration: const Duration(milliseconds: 800),
        swapAnimationCurve: Curves.easeOutCubic,
      ),
    );
  }
}
