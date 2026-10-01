import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Gráfico Circular (Pie) 04: Estados Alterados en Batalla
class PieChartWidget04 extends StatelessWidget {
  const PieChartWidget04({super.key});

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
              const Text('Gráfico 24: Estados Alterados en Batalla', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),
              Expanded(
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 4,
                    centerSpaceRadius: 35,
                    sections: [
                      PieChartSectionData(color: Colors.amber, value: 35, title: 'Parálisis', radius: 50, titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black87)),
                      PieChartSectionData(color: Colors.deepOrange, value: 25, title: 'Quemadura', radius: 50, titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                      PieChartSectionData(color: Colors.deepPurple, value: 25, title: 'Veneno', radius: 50, titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                      PieChartSectionData(color: Colors.cyan, value: 15, title: 'Sueño', radius: 50, titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
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
