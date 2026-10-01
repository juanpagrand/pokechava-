import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Gráfico de Radar 01: Atributos de Combate Básicos
class RadarChartWidget01 extends StatelessWidget {
  const RadarChartWidget01({super.key});

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
              const Text('Gráfico 31: Atributos de Combate Básicos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              Expanded(
                child: RadarChart(
                  RadarChartData(
                    radarShape: RadarShape.polygon,
                    radarBorderData: const BorderSide(color: Colors.blueGrey, width: 1.5),
                    gridBorderData: const BorderSide(color: Colors.grey, width: 0.5),
                    tickBorderData: const BorderSide(color: Colors.transparent),
                    ticksTextStyle: const TextStyle(color: Colors.transparent),
                    getTitle: (index, angle) {
                      const titles = ['HP', 'Ataque', 'Defensa', 'Sp. Atk', 'Sp. Def', 'Velocidad'];
                      return RadarChartTitle(text: titles[index % titles.length]);
                    },
                    dataSets: [
                      RadarDataSet(
                        fillColor: Colors.blue.withAlpha(80),
                        borderColor: Colors.blue,
                        borderWidth: 2,
                        entryRadius: 3,
                        dataEntries: const [
                          RadarEntry(value: 65),
                          RadarEntry(value: 75),
                          RadarEntry(value: 60),
                          RadarEntry(value: 85),
                          RadarEntry(value: 70),
                          RadarEntry(value: 90),
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
