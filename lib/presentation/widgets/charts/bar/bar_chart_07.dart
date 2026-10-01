import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Gráfico de Barras 07: Entrenamiento Semanal
class BarChartWidget07 extends StatelessWidget {
  const BarChartWidget07({super.key});

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
              const Text('Gráfico 7: Entrenamiento Semanal (Horas)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),
              Expanded(
                child: BarChart(
                  BarChartData(
                    maxY: 10,
                    gridData: const FlGridData(show: true, drawVerticalLine: false),
                    barGroups: [
                      BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 3, color: Colors.amber, width: 14)]),
                      BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 5, color: Colors.amber, width: 14)]),
                      BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 7, color: Colors.amber, width: 14)]),
                      BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 4, color: Colors.amber, width: 14)]),
                    ],
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (v, _) {
                            const sem = ['Sem 1', 'Sem 2', 'Sem 3', 'Sem 4'];
                            final i = v.toInt();
                            return (i >= 0 && i < sem.length) ? Text(sem[i], style: const TextStyle(fontSize: 11)) : const SizedBox.shrink();
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
