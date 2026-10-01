import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Gráfico Circular (Pie) 06: Rareza en el Equipo
class PieChartWidget06 extends StatelessWidget {
  const PieChartWidget06({super.key});

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
              const Text('Gráfico 26: Rareza en el Equipo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),
              Expanded(
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 0,
                    sections: [
                      PieChartSectionData(color: Colors.grey.shade400, value: 60, title: 'Común', radius: 70, titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
                      PieChartSectionData(color: Colors.amber, value: 30, title: 'Raro', radius: 70, titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
                      PieChartSectionData(color: Colors.deepPurpleAccent, value: 10, title: 'Mítico', radius: 70, titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
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
