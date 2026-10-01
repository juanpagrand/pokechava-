import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Gráfico de Dispersión (Scatter) 04: Rango de Ataque vs Velocidad
class ScatterChartWidget04 extends StatelessWidget {
  const ScatterChartWidget04({super.key});

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
              const Text('Gráfico 39: Rango de Ataque vs Velocidad', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),
              Expanded(
                child: ScatterChart(
                  ScatterChartData(
                    scatterSpots: [
                      ScatterSpot(45, 60),
                      ScatterSpot(70, 85),
                      ScatterSpot(90, 75),
                      ScatterSpot(110, 105),
                      ScatterSpot(60, 45),
                      ScatterSpot(80, 95),
                    ],
                    minX: 30,
                    maxX: 120,
                    minY: 30,
                    maxY: 120,
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
