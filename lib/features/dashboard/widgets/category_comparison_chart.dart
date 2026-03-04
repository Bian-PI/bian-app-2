import 'package:flutter/material.dart';
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

  String _getShortName(String categoryId) {
    // Nombres cortos para las categorías
    final shortNames = {
      'resources': 'Rec',
      'resource': 'Rec',
      'animal': 'Ani',
      'management': 'Ges',
      'health': 'San',
      'behavior': 'Com',
      'transport': 'Tra',
    };
    return shortNames[categoryId.toLowerCase()] ?? categoryId.substring(0, 3).toUpperCase();
  }

  String _getFullName(String categoryId) {
    final names = {
      'resources': 'Recursos',
      'resource': 'Recursos',
      'animal': 'Animal',
      'management': 'Gestión',
      'health': 'Sanidad',
      'behavior': 'Comportamiento',
      'transport': 'Transporte',
    };
    return names[categoryId.toLowerCase()] ?? categoryId;
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
              Icon(Icons.bar_chart, size: 40, color: Colors.grey.shade300),
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

    final sortedEntries = data.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Diseño de barras horizontales compacto
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: sortedEntries.take(5).map((entry) {
        final color = _getScoreColor(entry.value);
        final shortName = _getShortName(entry.key);
        final percentage = entry.value.clamp(0, 100);
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              // Label corto
              SizedBox(
                width: 28,
                child: Text(
                  shortName,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
              // Barra de progreso
              Expanded(
                child: Container(
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    children: [
                      // Barra llena
                      FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: percentage / 100,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                color.withOpacity(0.8),
                                color,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      // Porcentaje dentro de la barra
                      Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Align(
                            alignment: percentage > 50 
                                ? Alignment.centerLeft 
                                : Alignment.centerRight,
                            child: Text(
                              '${percentage.toStringAsFixed(0)}%',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: percentage > 50 
                                    ? Colors.white 
                                    : Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
