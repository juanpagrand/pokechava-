import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Gráfico de Radar 04: Estadísticas Pokémon Agua
class RadarChartWidget04 extends StatelessWidget {
  const RadarChartWidget04({super.key});

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
              const Text('Gráfico 34: Estadísticas Pokémon Agua', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              Expanded(
                child: RadarChart(
                  RadarChartData(
                    radarShape: RadarShape.polygon,
                    radarBorderData: const BorderSide(color: Colors.blueAccent, width: 1.5),
                    gridBorderData: const BorderSide(color: Colors.grey, width: 0.5),
                    tickBorderData: const BorderSide(color: Colors.transparent),
                    ticksTextStyle: const TextStyle(color: Colors.transparent),
                    getTitle: (index, angle) {
                      const titles = ['HP', 'Ataque', 'Defensa', 'Sp. Atk', 'Sp. Def', 'Velocidad'];
                      return RadarChartTitle(text: titles[index % titles.length]);
                    },
                    dataSets: [
                      RadarDataSet(
                        fillColor: Colors.cyan.withAlpha(80),
                        borderColor: Colors.blueAccent,
                        borderWidth: 2,
                        entryRadius: 3,
                        dataEntries: const [
                          RadarEntry(value: 79),
                          RadarEntry(value: 83),
                          RadarEntry(value: 100),
                          RadarEntry(value: 85),
                          RadarEntry(value: 105),
                          RadarEntry(value: 78),
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
