import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Gráfico de Barras 05: Distribución de HP por Región
class BarChartWidget05 extends StatelessWidget {
  const BarChartWidget05({super.key});

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
              const Text('Gráfico 5: Distribución de HP por Región', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),
              Expanded(
                child: BarChart(
                  BarChartData(
                    maxY: 150,
                    barGroups: [
                      BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 110, color: Colors.cyan, width: 20)]),
                      BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 130, color: Colors.cyan.shade600, width: 20)]),
                      BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 125, color: Colors.cyan.shade800, width: 20)]),
                    ],
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (v, _) {
                            const r = ['Kanto', 'Johto', 'Hoenn'];
                            final i = v.toInt();
                            return (i >= 0 && i < r.length) ? Text(r[i], style: const TextStyle(fontSize: 12)) : const SizedBox.shrink();
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
