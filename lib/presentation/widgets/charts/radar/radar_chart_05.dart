import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Gráfico de Radar 05: Comparativa de Rendimiento en Batalla
class RadarChartWidget05 extends StatelessWidget {
  const RadarChartWidget05({super.key});

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
              const Text('Gráfico 35: Comparativa de Rendimiento en Batalla', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              Expanded(
                child: RadarChart(
                  RadarChartData(
                    radarShape: RadarShape.polygon,
                    radarBorderData: const BorderSide(color: Colors.grey, width: 1.5),
                    gridBorderData: const BorderSide(color: Colors.grey, width: 0.5),
                    tickBorderData: const BorderSide(color: Colors.transparent),
                    ticksTextStyle: const TextStyle(color: Colors.transparent),
                    getTitle: (index, angle) {
                      const titles = ['HP', 'ATK', 'DEF', 'SPA', 'SPD', 'SPE'];
                      return RadarChartTitle(text: titles[index % titles.length]);
                    },
                    dataSets: [
                      RadarDataSet(
                        fillColor: Colors.redAccent.withAlpha(60),
                        borderColor: Colors.redAccent,
                        borderWidth: 2,
                        dataEntries: const [
                          RadarEntry(value: 70),
                          RadarEntry(value: 90),
                          RadarEntry(value: 65),
                          RadarEntry(value: 85),
                          RadarEntry(value: 65),
                          RadarEntry(value: 80),
                        ],
                      ),
                      RadarDataSet(
                        fillColor: Colors.teal.withAlpha(60),
                        borderColor: Colors.teal,
                        borderWidth: 2,
                        dataEntries: const [
                          RadarEntry(value: 80),
                          RadarEntry(value: 70),
                          RadarEntry(value: 85),
                          RadarEntry(value: 75),
                          RadarEntry(value: 90),
                          RadarEntry(value: 60),
                        ],
                      ),
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
