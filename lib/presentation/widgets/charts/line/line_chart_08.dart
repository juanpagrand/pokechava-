import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Gráfico de Líneas 08: Puntos de Combate al Entrenar
class LineChartWidget08 extends StatelessWidget {
  const LineChartWidget08({super.key});

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
              const Text('Gráfico 18: Puntos de Combate al Entrenar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),
              Expanded(
                child: LineChart(
                  LineChartData(
                    lineBarsData: [
                      LineChartBarData(
                        spots: const [
                          FlSpot(1, 500),
                          FlSpot(2, 750),
                          FlSpot(3, 1100),
                          FlSpot(4, 1450),
                          FlSpot(5, 1800),
                        ],
                        isCurved: true,
                        color: Colors.indigo,
                        barWidth: 3,
                        belowBarData: BarAreaData(show: true, color: Colors.indigo.withAlpha(40)),
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
