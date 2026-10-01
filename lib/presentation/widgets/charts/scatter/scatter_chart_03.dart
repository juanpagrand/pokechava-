import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Gráfico de Dispersión (Scatter) 03: Coordenadas de Aparición en el Mapa
class ScatterChartWidget03 extends StatelessWidget {
  const ScatterChartWidget03({super.key});

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
              const Text('Gráfico 38: Coordenadas de Aparición en el Mapa', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),
              Expanded(
                child: ScatterChart(
                  ScatterChartData(
                    scatterSpots: [
                      ScatterSpot(12, 18),
                      ScatterSpot(15, 24),
                      ScatterSpot(20, 15),
                      ScatterSpot(28, 30),
                      ScatterSpot(25, 22),
                      ScatterSpot(32, 19),
                    ],
                    minX: 10,
                    maxX: 35,
                    minY: 10,
                    maxY: 35,
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
