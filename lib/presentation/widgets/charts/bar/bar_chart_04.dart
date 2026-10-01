import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Gráfico de Barras 04: Nivel de Poder por Tipo
class BarChartWidget04 extends StatelessWidget {
  const BarChartWidget04({super.key});

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
              const Text('Gráfico 4: Nivel de Poder por Tipo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),
              Expanded(
                child: BarChart(
                  BarChartData(
                    maxY: 100,
                    barGroups: [
                      BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 75, color: Colors.purple, width: 16, borderRadius: BorderRadius.circular(8))]),
                      BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 88, color: Colors.deepOrange, width: 16, borderRadius: BorderRadius.circular(8))]),
                      BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 62, color: Colors.lightGreen, width: 16, borderRadius: BorderRadius.circular(8))]),
                      BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 95, color: Colors.indigo, width: 16, borderRadius: BorderRadius.circular(8))]),
                    ],
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (v, _) {
                            const t = ['Psíquico', 'Fuego', 'Planta', 'Dragón'];
                            final i = v.toInt();
                            return (i >= 0 && i < t.length) ? Text(t[i], style: const TextStyle(fontSize: 11)) : const SizedBox.shrink();
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
