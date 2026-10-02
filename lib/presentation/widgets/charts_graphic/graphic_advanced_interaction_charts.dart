import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

import 'graphic_chart_card.dart';
import 'graphic_data.dart';

// Gráficos avanzados A01–A08: interacción (selecciones, tooltips, zoom,
// gráficos enlazados).

/// A01: tooltip + crosshair al tocar.
class GraphicAdvanced01 extends StatelessWidget {
  const GraphicAdvanced01({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphicChartCard(
      code: 'A01',
      title: 'Toca una columna: tooltip y crosshair',
      description: 'PointSelection + TooltipGuide + CrosshairGuide.',
      chart: Chart(
        data: topBy((p) => p.spAtk, 10),
        variables: {
          'name': pokeName(),
          'spAtk': pokeNum((p) => p.spAtk, scale: LinearScale(min: 0)),
        },
        marks: [IntervalMark(color: ColorEncode(value: Colors.deepPurple))],
        axes: rectAxes(xRotation: -0.6),
        selections: {'tap': PointSelection(dim: Dim.x)},
        tooltip: TooltipGuide(),
        crosshair: CrosshairGuide(),
      ),
    );
  }
}

/// A02: resaltar lo seleccionado y atenuar el resto.
class GraphicAdvanced02 extends StatelessWidget {
  const GraphicAdvanced02({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphicChartCard(
      code: 'A02',
      title: 'Selección con resaltado',
      description:
          'updaters: lo no seleccionado baja su opacidad. Doble toque limpia.',
      chart: Chart(
        data: topBy((p) => p.total, 10),
        variables: {
          'name': pokeName(),
          'total': pokeNum((p) => p.total, scale: LinearScale(min: 0)),
          'type': pokeType(),
        },
        marks: [
          IntervalMark(
            color: ColorEncode(
              encoder: (t) => kTypeColors[t['type']] ?? Colors.grey,
              updaters: {
                'tap': {false: (c) => c.withValues(alpha: 0.25)},
              },
            ),
            elevation: ElevationEncode(value: 0, updaters: {
              'tap': {true: (_) => 6},
            }),
          ),
        ],
        axes: rectAxes(xRotation: -0.6),
        selections: {'tap': PointSelection(toggle: true)},
      ),
    );
  }
}

/// A03: resaltar una serie completa + tooltip con varias series.
class GraphicAdvanced03 extends StatelessWidget {
  const GraphicAdvanced03({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphicChartCard(
      code: 'A03',
      title: 'Tres perfiles opuestos: toca para aislar uno',
      description:
          'Selección por variable (toda la serie) + tooltip multiTuples al mantener o arrastrar.',
      chart: Chart(
        data: statsLong(pokesByName(['Snorlax', 'Alakazam', 'Onix'])),
        variables: {
          'stat': strVar('stat', scale: OrdinalScale(inflate: true)),
          'value': numVar('value', scale: LinearScale(min: 0, max: 170)),
          'name': strVar('name'),
        },
        marks: [
          LineMark(
            position: Varset('stat') * Varset('value') / Varset('name'),
            color: ColorEncode(
              variable: 'name',
              values: const [
                Color(0xFF9C9A6E),
                Color(0xFFE85584),
                Color(0xFFAF9A45),
              ],
              updaters: {
                'serie': {false: (c) => c.withValues(alpha: 0.15)},
              },
            ),
            size: SizeEncode(value: 3),
          ),
        ],
        axes: rectAxes(),
        selections: {
          'serie': PointSelection(variable: 'name'),
          'touch': PointSelection(
            on: {GestureType.scaleUpdate, GestureType.longPress},
            clear: {GestureType.scaleEnd},
            dim: Dim.x,
          ),
        },
        tooltip: TooltipGuide(selections: {'touch'}, multiTuples: true),
        crosshair: CrosshairGuide(selections: {'touch'}),
      ),
    );
  }
}

/// Serie simulada de 120 turnos de combate (determinista).
final List<Datum> _battleTurns = [
  for (var i = 1; i <= 120; i++)
    {
      'turn': i,
      'damage': (40 +
              28 * math.sin(i / 6) +
              14 * math.cos(i / 2.3) +
              (i % 17 == 0 ? 35 : 0))
          .round(),
    },
];

/// A04: zoom y desplazamiento.
class GraphicAdvanced04 extends StatelessWidget {
  const GraphicAdvanced04({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphicChartCard(
      code: 'A04',
      title: 'Zoom y desplazamiento (120 turnos simulados)',
      description:
          'horizontalRangeUpdater: pellizca para zoom, arrastra para moverte.',
      chart: Chart(
        data: _battleTurns,
        variables: {
          'turn': numVar('turn', scale: LinearScale(min: 1, max: 120)),
          'damage': numVar('damage', scale: LinearScale(min: 0)),
        },
        marks: [LineMark(color: ColorEncode(value: Colors.redAccent))],
        coord: RectCoord(
          horizontalRangeUpdater: Defaults.horizontalRangeEvent,
        ),
        axes: rectAxes(),
      ),
    );
  }
}

/// A05: selección por intervalo (brush).
class GraphicAdvanced05 extends StatelessWidget {
  const GraphicAdvanced05({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphicChartCard(
      code: 'A05',
      title: 'Arrastra para encerrar un grupo de puntos',
      description: 'IntervalSelection: lo que queda fuera del recuadro se apaga.',
      chart: Chart(
        data: kPokes,
        variables: {
          'attack': pokeNum((p) => p.attack),
          'defense': pokeNum((p) => p.defense),
          'type': pokeType(),
        },
        marks: [
          PointMark(
            size: SizeEncode(value: 10),
            color: ColorEncode(
              encoder: (t) => kTypeColors[t['type']] ?? Colors.grey,
              updaters: {
                'brush': {false: (c) => c.withValues(alpha: 0.12)},
              },
            ),
          ),
        ],
        axes: rectAxes(),
        selections: {
          'brush': IntervalSelection(color: Colors.blue.withValues(alpha: 0.1)),
        },
      ),
    );
  }
}

/// A06: tooltip dibujado a medida.
class GraphicAdvanced06 extends StatelessWidget {
  const GraphicAdvanced06({super.key});

  static List<MarkElement> _renderer(
      Size size, Offset anchor, Map<int, Tuple> selected) {
    final t = selected.values.first;
    final p = pokeByName(t['name'] as String);
    final color = kTypeColors[p.type] ?? Colors.grey;
    final box = Rect.fromCenter(
      center: anchor.translate(0, -52),
      width: 150,
      height: 64,
    );
    return [
      RectElement(
        rect: box,
        borderRadius: BorderRadius.circular(10),
        style: PaintStyle(fillColor: const Color(0xEE212121), elevation: 4),
      ),
      RectElement(
        rect: Rect.fromLTWH(box.left, box.top, 6, box.height),
        borderRadius: const BorderRadius.horizontal(left: Radius.circular(10)),
        style: PaintStyle(fillColor: color),
      ),
      LabelElement(
        text: '#${p.id} ${p.name}',
        anchor: box.topLeft.translate(14, 8),
        defaultAlign: Alignment.bottomRight,
        style: LabelStyle(
          textStyle: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ),
      LabelElement(
        text: '${p.type} · Total ${p.total}\n'
            'Atq ${p.attack}  Def ${p.defense}  Vel ${p.speed}',
        anchor: box.topLeft.translate(14, 28),
        defaultAlign: Alignment.bottomRight,
        style: LabelStyle(
          textStyle: const TextStyle(color: Colors.white70, fontSize: 10),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return GraphicChartCard(
      code: 'A06',
      title: 'Tooltip personalizado tipo ficha',
      description: 'TooltipGuide(renderer: …) dibuja la ficha con RectElement y LabelElement.',
      chart: Chart(
        data: kPokes,
        variables: {
          'height': pokeNum((p) => p.height),
          'exp': pokeNum((p) => p.baseExp),
          'name': pokeName(),
          'type': pokeType(),
        },
        marks: [PointMark(color: typeColorFixed(), size: SizeEncode(value: 11))],
        axes: rectAxes(),
        selections: {'tap': PointSelection()},
        tooltip: TooltipGuide(renderer: _renderer),
      ),
    );
  }
}

/// A07: dos gráficos enlazados por el mismo flujo de gestos.
class GraphicAdvanced07 extends StatefulWidget {
  const GraphicAdvanced07({super.key});

  @override
  State<GraphicAdvanced07> createState() => _GraphicAdvanced07State();
}

class _GraphicAdvanced07State extends State<GraphicAdvanced07> {
  final _gestures = StreamController<GestureEvent>.broadcast();

  @override
  void dispose() {
    _gestures.close();
    super.dispose();
  }

  Chart<Poke> _chart(String field, num Function(Poke) f, Color color) {
    return Chart(
      data: kPokes.take(12).toList(),
      variables: {
        'name': pokeName(),
        field: pokeNum(f, scale: LinearScale(min: 0)),
      },
      marks: [
        IntervalMark(
          color: ColorEncode(value: color, updaters: {
            'tap': {false: (c) => c.withValues(alpha: 0.25)},
          }),
        ),
      ],
      axes: [yAxis()],
      selections: {'tap': PointSelection(dim: Dim.x)},
      tooltip: TooltipGuide(),
      gestureStream: _gestures,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GraphicChartCard(
      code: 'A07',
      title: 'Gráficos enlazados: ataque arriba, defensa abajo',
      description:
          'Comparten gestureStream: tocar uno selecciona el mismo Pokémon en el otro.',
      height: 300,
      chart: Column(
        children: [
          Expanded(child: _chart('attack', (p) => p.attack, Colors.red)),
          const SizedBox(height: 8),
          Expanded(child: _chart('defense', (p) => p.defense, Colors.blue)),
        ],
      ),
    );
  }
}

/// A08: mapa de calor interactivo.
class GraphicAdvanced08 extends StatelessWidget {
  const GraphicAdvanced08({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphicChartCard(
      code: 'A08',
      title: 'Mapa de calor que responde al toque',
      description: 'PolygonMark + selección + tooltip con nombre, estadística y valor.',
      height: 320,
      chart: Chart(
        data: statsLong(kPokes.take(12).toList()),
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
                Color(0xFFE3F2FD),
                Color(0xFF42A5F5),
                Color(0xFF0D47A1),
              ],
              updaters: {
                'tap': {false: (c) => c.withValues(alpha: 0.35)},
              },
            ),
          ),
        ],
        axes: rectAxes(xRotation: -0.5),
        selections: {'tap': PointSelection()},
        tooltip: TooltipGuide(variables: ['name', 'stat', 'value']),
      ),
    );
  }
}
