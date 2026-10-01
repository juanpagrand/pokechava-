import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Gráfico de Dispersión (Scatter) 02: Distribución de Puntos CP vs HP
class ScatterChartWidget02 extends StatelessWidget {
  const ScatterChartWidget02({super.key});

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
              const Text('Gráfico 37: Distribución de CP vs HP', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),
              Expanded(
                child: ScatterChart(
                  ScatterChartData(
                    scatterSpots: [
                      ScatterSpot(100, 45),
                      ScatterSpot(250, 70),
                      ScatterSpot(400, 95),
                      ScatterSpot(550, 110),
                      ScatterSpot(700, 140),
                      ScatterSpot(300, 80),
                    ],
                    minX: 0,
                    maxX: 800,
                    minY: 0,
                    maxY: 160,
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
