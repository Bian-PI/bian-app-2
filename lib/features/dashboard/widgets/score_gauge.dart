import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;

class ScoreGauge extends StatefulWidget {
  final double score;
  final double size;
  final bool animate;

  const ScoreGauge({
    super.key,
    required this.score,
    this.size = 160,
    this.animate = true,
  });

  @override
  State<ScoreGauge> createState() => _ScoreGaugeState();
}

class _ScoreGaugeState extends State<ScoreGauge> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: widget.score).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    if (widget.animate) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(ScoreGauge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.score != widget.score) {
      _animation = Tween<double>(begin: _animation.value, end: widget.score).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
      );
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getScoreColor(double score) {
    if (score >= 90) return const Color(0xFF1B5E20);
    if (score >= 75) return const Color(0xFF4CAF50);
    if (score >= 50) return const Color(0xFFFFB300);
    if (score >= 25) return const Color(0xFFFF9800);
    return const Color(0xFFE53935);
  }

  String _getScoreLabel(double score) {
    if (score >= 90) return 'Excelente';
    if (score >= 75) return 'Bueno';
    if (score >= 50) return 'Aceptable';
    if (score >= 25) return 'Deficiente';
    return 'Crítico';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final currentScore = widget.animate ? _animation.value : widget.score;
        final color = _getScoreColor(currentScore);
        
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Gráfica circular
              PieChart(
                PieChartData(
                  startDegreeOffset: 135,
                  sectionsSpace: 0,
                  centerSpaceRadius: widget.size * 0.32,
                  sections: [
                    // Parte llena (score)
                    PieChartSectionData(
                      value: currentScore * 2.7 / 100, // 270 grados máximo
                      color: color,
                      radius: widget.size * 0.15,
                      showTitle: false,
                    ),
                    // Parte vacía
                    PieChartSectionData(
                      value: 2.7 - (currentScore * 2.7 / 100),
                      color: Colors.grey.shade200,
                      radius: widget.size * 0.12,
                      showTitle: false,
                    ),
                    // Espacio inferior (90 grados)
                    PieChartSectionData(
                      value: 1,
                      color: Colors.transparent,
                      radius: 0,
                      showTitle: false,
                    ),
                  ],
                ),
                swapAnimationDuration: Duration.zero,
              ),
              // Texto central
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${currentScore.toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: widget.size * 0.22,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  Text(
                    _getScoreLabel(currentScore),
                    style: TextStyle(
                      fontSize: widget.size * 0.09,
                      fontWeight: FontWeight.w600,
                      color: color.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
