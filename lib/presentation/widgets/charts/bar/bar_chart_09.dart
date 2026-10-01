import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Gráfico de Barras 09: Pokémons Avistados por Mes
class BarChartWidget09 extends StatelessWidget {
  const BarChartWidget09({super.key});

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
              const Text('Gráfico 9: Pokémons Avistados por Mes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),
              Expanded(
                child: BarChart(
                  BarChartData(
                    maxY: 60,
                    barGroups: [
                      BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 25, color: Colors.pinkAccent, width: 14)]),
                      BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 40, color: Colors.pinkAccent, width: 14)]),
                      BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 55, color: Colors.pinkAccent, width: 14)]),
                    ],
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (v, _) {
                            const m = ['Ene', 'Feb', 'Mar'];
                            final i = v.toInt();
                            return (i >= 0 && i < m.length) ? Text(m[i], style: const TextStyle(fontSize: 12)) : const SizedBox.shrink();
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
