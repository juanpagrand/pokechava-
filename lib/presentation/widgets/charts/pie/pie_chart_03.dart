import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Gráfico Circular (Pie) 03: Composición de la Mochila
class PieChartWidget03 extends StatelessWidget {
  const PieChartWidget03({super.key});

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
              const Text('Gráfico 23: Composición de la Mochila', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),
              Expanded(
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 20,
                    sections: [
                      PieChartSectionData(color: Colors.orange, value: 30, title: 'Pociones', radius: 55, titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                      PieChartSectionData(color: Colors.purple, value: 40, title: 'Pokéballs', radius: 55, titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                      PieChartSectionData(color: Colors.teal, value: 20, title: 'Bayas', radius: 55, titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                      PieChartSectionData(color: Colors.grey, value: 10, title: 'Otros', radius: 55, titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
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
