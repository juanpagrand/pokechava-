import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Gráfico de Barras 10: Puntos de Combate (CP) Promedio
class BarChartWidget10 extends StatelessWidget {
  const BarChartWidget10({super.key});

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
              const Text('Gráfico 10: Puntos de Combate (CP) Promedio', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),
              Expanded(
                child: BarChart(
                  BarChartData(
                    maxY: 3000,
                    barGroups: [
                      BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 1200, color: Colors.indigoAccent, width: 16)]),
                      BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 2100, color: Colors.deepPurpleAccent, width: 16)]),
                      BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 2800, color: Colors.redAccent, width: 16)]),
                    ],
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (v, _) {
                            const cat = ['Común', 'Raro', 'Legendario'];
                            final i = v.toInt();
                            return (i >= 0 && i < cat.length) ? Text(cat[i], style: const TextStyle(fontSize: 11)) : const SizedBox.shrink();
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
