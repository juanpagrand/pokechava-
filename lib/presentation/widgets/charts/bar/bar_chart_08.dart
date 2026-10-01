import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Gráfico de Barras 08: Comparación de Velocidad
class BarChartWidget08 extends StatelessWidget {
  const BarChartWidget08({super.key});

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
              const Text('Gráfico 8: Comparación de Velocidad', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),
              Expanded(
                child: BarChart(
                  BarChartData(
                    maxY: 140,
                    barGroups: [
                      BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 45, color: Colors.brown, width: 16)]),
                      BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 90, color: Colors.amber, width: 16)]),
                      BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 130, color: Colors.lightBlue, width: 16)]),
                    ],
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (v, _) {
                            const p = ['Snorlax', 'Pikachu', 'Jolteon'];
                            final i = v.toInt();
                            return (i >= 0 && i < p.length) ? Text(p[i], style: const TextStyle(fontSize: 11)) : const SizedBox.shrink();
                          },
                        ),
                      ),
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
