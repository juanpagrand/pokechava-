import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Gráfico Circular (Pie) 10: Resultados de Combate
class PieChartWidget10 extends StatelessWidget {
  const PieChartWidget10({super.key});

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
            children: [
              const Text('Gráfico 30: Resultados de Combate', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),
              Expanded(
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 25,
                    sections: [
                      PieChartSectionData(color: Colors.green.shade600, value: 70, title: '70% Victorias', radius: 55, titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                      PieChartSectionData(color: Colors.redAccent, value: 25, title: '25% Derrotas', radius: 55, titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                      PieChartSectionData(color: Colors.orangeAccent, value: 5, title: '5% Empate', radius: 55, titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
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
