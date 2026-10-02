// ===========================================================================
// graphic_normal_other_charts.dart — NORMALES N39–N40
// ===========================================================================
// Qué contiene:
//   N39 mapa de calor (PolygonMark: una celda por Pokémon × estadística).
//   N40 histograma (IntervalMark con barras pegadas).
// Se asume lo de N01–N38; aquí solo se comenta lo nuevo.
//
// Imports:
//   - flutter/material.dart → widgets, Color, Colors.
//   - graphic/graphic.dart  → Chart, PolygonMark, IntervalMark, RectShape,
//     ColorEncode, LabelEncode, LinearScale.
//   - graphic_chart_card.dart / graphic_data.dart → tarjeta y datos/atajos.
//
// Quién lo importa: el barril charts_graphic.dart lo reexporta y
// graphic_charts_view.dart lo usa en "Calor e histograma".
// ===========================================================================

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
        // Formato largo: 10 Pokémon × 6 stats = 60 filas = 60 celdas.
        data: statsLong(topBy((p) => p.total, 10)),
        // Aquí SÍ conviene el cruce por defecto de las dos primeras
        // variables: name (X) × stat (Y), dos categorías → una cuadrícula.
        // 'value' queda tercera y solo se usa para el color.
        variables: {
          'name': strVar('name'),
          'stat': strVar('stat'),
          'value': numVar('value'),
        },
        marks: [
          // Lo nuevo aquí: PolygonMark rellena el rectángulo de cada par
          // (name, stat): eso es una celda del mapa de calor.
          PolygonMark(
            // ColorEncode con variable NUMÉRICA: el color se interpola de
            // forma continua. Valor más bajo → crema, medio → naranja,
            // más alto → naranja oscuro.
            color: ColorEncode(
              variable: 'value',
              values: const [
                Color(0xFFFFF3E0),
                Color(0xFFFFB74D),
                Color(0xFFE65100),
              ],
            ),
            // El número escrito dentro de cada celda, en marrón oscuro.
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
    // Se calcula en Dart antes de graficar: 5 intervalos (200–299 …
    // 600–699) y cuántos Pokémon caen en cada uno.
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
          // tickCount: 5 → se piden unas 5 marcas en el eje Y (graphic las
          // ajusta a números redondos, así que pueden ser una más o menos).
          'count': numVar('count', scale: LinearScale(min: 0, tickCount: 5)),
        },
        marks: [
          IntervalMark(
            // Lo nuevo aquí: histogram: true hace que cada barra ocupe todo
            // el ancho de su categoría, sin hueco entre barras (los
            // intervalos son continuos, por eso van pegados).
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
