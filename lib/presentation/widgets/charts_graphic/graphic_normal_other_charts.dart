import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

import 'graphic_chart_card.dart';
import 'graphic_data.dart';

// Gráficos normales N39–N40: mapa de calor e histograma.

/// N39: mapa de calor (PolygonMark).
class GraphicNormal39 extends StatelessWidget {
  const GraphicNormal39({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphicChartCard(
      code: 'N39',
      title: 'Mapa de calor de estadísticas',
      description: 'PolygonMark: cada celda es una estadística de un Pokémon.',
      height: 300,
      chart: Chart(
        data: statsLong(topBy((p) => p.total, 10)),
        variables: {
          'name': strVar('name'),
          'stat': strVar('stat'),
          'value': numVar('value'),
        },
        marks: [
          PolygonMark(
            color: ColorEncode(
              variable: 'value',
              values: const [
                Color(0xFFFFF3E0),
                Color(0xFFFFB74D),
                Color(0xFFE65100),
              ],
            ),
            label: LabelEncode(
                encoder: (t) => smallLabel(t['value'].toString(),
                    color: const Color(0xFF3E2723))),
          ),
        ],
        axes: rectAxes(xRotation: -0.5),
      ),
    );
  }
}

/// N40: histograma.
class GraphicNormal40 extends StatelessWidget {
  const GraphicNormal40({super.key});

  @override
  Widget build(BuildContext context) {
    // Agrupa el total de estadísticas en intervalos de 100 puntos.
    final bins = <Datum>[
      for (var start = 200; start < 700; start += 100)
        {
          'bin': '$start–${start + 99}',
          'count': kPokes
              .where((p) => p.total >= start && p.total < start + 100)
              .length,
        },
    ];
    return GraphicChartCard(
      code: 'N40',
      title: 'Histograma del total de estadísticas',
      description: 'RectShape(histogram: true): barras pegadas, sin hueco.',
      chart: Chart(
        data: bins,
        variables: {
          'bin': strVar('bin'),
          'count': numVar('count', scale: LinearScale(min: 0, tickCount: 5)),
        },
        marks: [
          IntervalMark(
            shape: ShapeEncode(value: RectShape(histogram: true)),
            color: ColorEncode(value: Colors.cyan.shade600),
            label: LabelEncode(encoder: (t) => smallLabel(t['count'].toString())),
          ),
        ],
        axes: rectAxes(),
      ),
    );
  }
}
