import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Gráfico de Barras 06: Efectividad de Pokeballs
class BarChartWidget06 extends StatelessWidget {
  const BarChartWidget06({super.key});

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
              const Text('Gráfico 6: Efectividad de Pokéballs (%)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),
              Expanded(
                child: BarChart(
                  BarChartData(
                    maxY: 100,
                    barGroups: [
                      BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 35, color: Colors.red, width: 16)]),
                      BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 60, color: Colors.blue, width: 16)]),
                      BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 85, color: Colors.black87, width: 16)]),
                      BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 100, color: Colors.purple, width: 16)]),
                    ],
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (v, _) {
                            const b = ['Poke', 'Super', 'Ultra', 'Master'];
                            final i = v.toInt();
                            return (i >= 0 && i < b.length) ? Text(b[i], style: const TextStyle(fontSize: 11)) : const SizedBox.shrink();
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
