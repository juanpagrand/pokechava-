import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Gráfico de Barras 01: Estadísticas Base Básicas
class BarChartWidget01 extends StatelessWidget {
  const BarChartWidget01({super.key});

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
              const Text('Gráfico 1: Estadísticas Base Básicas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),
              Expanded(
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 100,
                    barTouchData: BarTouchData(enabled: true),
                    titlesData: FlTitlesData(
                      show: true,
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            const titles = ['HP', 'ATK', 'DEF', 'SPD'];
                            final index = value.toInt();
                            if (index >= 0 && index < titles.length) {
                              return Text(titles[index], style: const TextStyle(fontSize: 12));
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: [
                      BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 65, color: Colors.green, width: 18, borderRadius: BorderRadius.circular(4))]),
                      BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 80, color: Colors.red, width: 18, borderRadius: BorderRadius.circular(4))]),
                      BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 55, color: Colors.blue, width: 18, borderRadius: BorderRadius.circular(4))]),
                      BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 90, color: Colors.orange, width: 18, borderRadius: BorderRadius.circular(4))]),
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
