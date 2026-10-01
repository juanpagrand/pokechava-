import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Gráfico de Líneas 07: Registro de Victorias Semanales
class LineChartWidget07 extends StatelessWidget {
  const LineChartWidget07({super.key});

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
              const Text('Gráfico 17: Registro de Victorias Semanales', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),
              Expanded(
                child: LineChart(
                  LineChartData(
                    lineBarsData: [
                      LineChartBarData(
                        spots: const [
                          FlSpot(1, 2),
                          FlSpot(2, 5),
                          FlSpot(3, 3),
                          FlSpot(4, 7),
                          FlSpot(5, 9),
                        ],
                        isCurved: true,
                        color: Colors.teal,
                        barWidth: 3,
                        dotData: const FlDotData(show: true),
                      ),
                    ],
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
