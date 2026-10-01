import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Gráfico de Barras 02: Comparativa Ataque vs Defensa
class BarChartWidget02 extends StatelessWidget {
  const BarChartWidget02({super.key});

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
              const Text('Gráfico 2: Comparativa Ataque vs Defensa', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),
              Expanded(
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 120,
                    barGroups: [
                      BarChartGroupData(x: 0, barRods: [
                        BarChartRodData(toY: 85, color: Colors.redAccent, width: 12),
                        BarChartRodData(toY: 70, color: Colors.blueAccent, width: 12),
                      ]),
                      BarChartGroupData(x: 1, barRods: [
                        BarChartRodData(toY: 100, color: Colors.redAccent, width: 12),
                        BarChartRodData(toY: 95, color: Colors.blueAccent, width: 12),
                      ]),
                      BarChartGroupData(x: 2, barRods: [
                        BarChartRodData(toY: 60, color: Colors.redAccent, width: 12),
                        BarChartRodData(toY: 110, color: Colors.blueAccent, width: 12),
                      ]),
                    ],
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (val, _) {
                            final names = ['Pikachu', 'Charizard', 'Blastoise'];
                            final i = val.toInt();
                            return (i >= 0 && i < names.length) ? Text(names[i], style: const TextStyle(fontSize: 11)) : const SizedBox.shrink();
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
