import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Gráfico de Líneas 03: Comparativa de Ataque vs Nivel
class LineChartWidget03 extends StatelessWidget {
  const LineChartWidget03({super.key});

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
              const Text('Gráfico 13: Comparativa de Ataque vs Nivel', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),
              Expanded(
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: true),
                    titlesData: const FlTitlesData(
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: const [
                          FlSpot(1, 30),
                          FlSpot(2, 45),
                          FlSpot(3, 60),
                          FlSpot(4, 85),
                        ],
                        isCurved: true,
                        color: Colors.redAccent,
                        barWidth: 3,
                      ),
                      LineChartBarData(
                        spots: const [
                          FlSpot(1, 20),
                          FlSpot(2, 40),
                          FlSpot(3, 50),
                          FlSpot(4, 70),
                        ],
                        isCurved: true,
                        color: Colors.blueAccent,
                        barWidth: 3,
                      ),
                    ],
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
