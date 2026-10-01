import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Gráfico Circular (Pie) 09: Hábitats de Captura
class PieChartWidget09 extends StatelessWidget {
  const PieChartWidget09({super.key});

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
              const Text('Gráfico 29: Hábitats de Captura', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),
              Expanded(
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 3,
                    centerSpaceRadius: 35,
                    sections: [
                      PieChartSectionData(color: Colors.green, value: 45, title: 'Bosque', radius: 50, titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                      PieChartSectionData(color: Colors.blue, value: 35, title: 'Agua', radius: 50, titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                      PieChartSectionData(color: Colors.grey, value: 20, title: 'Cueva', radius: 50, titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
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
