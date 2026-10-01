import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Gráfico de Dispersión (Scatter) 05: Nivel de Entrenador vs Pokémons Capturados
class ScatterChartWidget05 extends StatelessWidget {
  const ScatterChartWidget05({super.key});

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
              const Text('Gráfico 40: Nivel Entrenador vs Pokémons Capturados', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),
              Expanded(
                child: ScatterChart(
                  ScatterChartData(
                    scatterSpots: [
                      ScatterSpot(5, 20),
                      ScatterSpot(10, 45),
                      ScatterSpot(15, 80),
                      ScatterSpot(20, 130),
                      ScatterSpot(25, 210),
                      ScatterSpot(30, 320),
                    ],
                    minX: 0,
                    maxX: 35,
                    minY: 0,
                    maxY: 350,
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
