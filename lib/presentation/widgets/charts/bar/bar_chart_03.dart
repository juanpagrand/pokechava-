import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Gráfico de Barras 03: Capturas por Día de la Semana
class BarChartWidget03 extends StatelessWidget {
  const BarChartWidget03({super.key});

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
              const Text('Gráfico 3: Capturas por Día de la Semana', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),
              Expanded(
                child: BarChart(
                  BarChartData(
                    maxY: 30,
                    barGroups: [
                      BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 12, color: Colors.teal, width: 14)]),
                      BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 18, color: Colors.teal, width: 14)]),
                      BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 15, color: Colors.teal, width: 14)]),
                      BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 22, color: Colors.teal, width: 14)]),
                      BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 28, color: Colors.tealAccent.shade700, width: 14)]),
                    ],
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (v, _) {
                            const d = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie'];
                            final i = v.toInt();
                            return (i >= 0 && i < d.length) ? Text(d[i], style: const TextStyle(fontSize: 11)) : const SizedBox.shrink();
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
