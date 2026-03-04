import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SpeciesPieChart extends StatefulWidget {
  final Map<String, int> data;
  final double size;

  const SpeciesPieChart({
    super.key,
    required this.data,
    this.size = 150,
  });

  @override
  State<SpeciesPieChart> createState() => _SpeciesPieChartState();
}

class _SpeciesPieChartState extends State<SpeciesPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final total = widget.data.values.fold(0, (sum, v) => sum + v);
    
    if (total == 0) {
      return SizedBox(
        width: widget.size,
        height: widget.size,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.pie_chart_outline, size: 48, color: Colors.grey.shade300),
              const SizedBox(height: 8),
              Text(
                'Sin datos',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
            ],
          ),
        ),
      );
    }

    final birds = widget.data['birds'] ?? 0;
    final pigs = widget.data['pigs'] ?? 0;
    final double birdsPercent = total > 0 ? (birds / total * 100).toDouble() : 0.0;
    final double pigsPercent = total > 0 ? (pigs / total * 100).toDouble() : 0.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: widget.size,
          height: widget.size,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              sectionsSpace: 3,
              centerSpaceRadius: widget.size * 0.25,
              sections: [
                // Aves
                PieChartSectionData(
                  value: birds.toDouble(),
                  title: touchedIndex == 0 ? '${birdsPercent.toStringAsFixed(0)}%' : '',
                  color: const Color(0xFF2196F3),
                  radius: touchedIndex == 0 ? widget.size * 0.28 : widget.size * 0.25,
                  titleStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  badgeWidget: touchedIndex == 0 ? null : null,
                ),
                // Cerdos
                PieChartSectionData(
                  value: pigs.toDouble(),
                  title: touchedIndex == 1 ? '${pigsPercent.toStringAsFixed(0)}%' : '',
                  color: const Color(0xFFE91E63),
                  radius: touchedIndex == 1 ? widget.size * 0.28 : widget.size * 0.25,
                  titleStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            swapAnimationDuration: const Duration(milliseconds: 500),
            swapAnimationCurve: Curves.easeOutCubic,
          ),
        ),
        const SizedBox(height: 16),
        // Leyenda
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem(
              color: const Color(0xFF2196F3),
              label: 'Aves',
              value: birds,
              percent: birdsPercent,
            ),
            const SizedBox(width: 24),
            _buildLegendItem(
              color: const Color(0xFFE91E63),
              label: 'Cerdos',
              value: pigs,
              percent: pigsPercent,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required String label,
    required int value,
    required double percent,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '$value (${percent.toStringAsFixed(0)}%)',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
