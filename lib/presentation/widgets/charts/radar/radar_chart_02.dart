import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Gráfico de Radar 02: Estadísticas Pokémon Eléctrico
class RadarChartWidget02 extends StatelessWidget {
  const RadarChartWidget02({super.key});

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
              const Text('Gráfico 32: Estadísticas Pokémon Eléctrico', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              Expanded(
                child: RadarChart(
                  RadarChartData(
                    radarShape: RadarShape.circle,
                    radarBorderData: const BorderSide(color: Colors.amber, width: 1.5),
                    gridBorderData: BorderSide(color: Colors.amber.shade200, width: 0.5),
                    tickBorderData: const BorderSide(color: Colors.transparent),
                    ticksTextStyle: const TextStyle(color: Colors.transparent),
                    getTitle: (index, angle) {
                      const titles = ['PS', 'Fuerza', 'Blindaje', 'Energía', 'Agilidad'];
                      return RadarChartTitle(text: titles[index % titles.length]);
                    },
                    dataSets: [
                      RadarDataSet(
                        fillColor: Colors.amber.withAlpha(90),
                        borderColor: Colors.orange,
                        borderWidth: 2,
                        entryRadius: 3,
                        dataEntries: const [
                          RadarEntry(value: 50),
                          RadarEntry(value: 60),
                          RadarEntry(value: 40),
                          RadarEntry(value: 85),
                          RadarEntry(value: 100),
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
