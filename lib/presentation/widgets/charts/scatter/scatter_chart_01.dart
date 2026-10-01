import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Gráfico de Dispersión (Scatter) 01: Relación Peso vs Altura
class ScatterChartWidget01 extends StatelessWidget {
  const ScatterChartWidget01({super.key});

  @override
  Widget build(BuildContext context) {

    return AspectRatio(
      aspectRatio: 1.6,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Gráfico 36: Relación Peso vs Altura', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),
              Expanded(
                child: ScatterChart(
                  ScatterChartData(
                    scatterSpots: [
                      ScatterSpot(2, 3),
                      ScatterSpot(3, 4),
                      ScatterSpot(5, 7),
                      ScatterSpot(7, 6),
                      ScatterSpot(8, 9),
                      ScatterSpot(4, 5),
                    ],
                    minX: 0,
                    maxX: 10,
                    minY: 0,
                    maxY: 10,
                    titlesData: const FlTitlesData(
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }
}
