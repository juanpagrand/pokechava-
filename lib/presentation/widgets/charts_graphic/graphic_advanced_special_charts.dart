import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

import 'graphic_chart_card.dart';
import 'graphic_data.dart';

// Gráficos avanzados A16–A25: formas especiales, anotaciones y composición.

/// Precio de cierre de una carta de Charizard (datos de ejemplo, 20 días).
final List<Datum> _cardPrices = () {
  final rst = <Datum>[];
  var close = 320.0;
  for (var day = 1; day <= 20; day++) {
    final open = close;
    close = open + 18 * math.sin(day * 1.3) + (day.isEven ? 6 : -4);
    final high = math.max(open, close) + 6 + (day % 3) * 3;
    final low = math.min(open, close) - 5 - (day % 4) * 2;
    rst.add({
      'day': 'D$day',
      'open': open.roundToDouble(),
      'close': close.roundToDouble(),
      'high': high.roundToDouble(),
      'low': low.roundToDouble(),
    });
  }
  return rst;
}();

/// A16: velas japonesas.
class GraphicAdvanced16 extends StatelessWidget {
  const GraphicAdvanced16({super.key});

  @override
  Widget build(BuildContext context) {
    LinearScale price() => LinearScale(min: 260, max: 380);
    return GraphicChartCard(
      code: 'A16',
      title: 'Velas: precio de una carta de Charizard (ejemplo)',
      description:
          'CustomMark + CandlestickShape con [apertura, cierre, máximo, mínimo].',
      chart: Chart(
        data: _cardPrices,
        variables: {
          'day': strVar('day', scale: OrdinalScale(tickCount: 5)),
          'open': numVar('open', scale: price()),
          'close': numVar('close', scale: price()),
          'high': numVar('high', scale: price()),
          'low': numVar('low', scale: price()),
        },
        marks: [
          CustomMark(
            shape: ShapeEncode(value: CandlestickShape(hollow: false)),
            position: Varset('day') *
                (Varset('open') + Varset('close') + Varset('high') + Varset('low')),
            color: ColorEncode(
              encoder: (t) => (t['close'] as num) >= (t['open'] as num)
                  ? Colors.green
                  : Colors.red,
            ),
          ),
        ],
        axes: rectAxes(),
      ),
    );
  }
}

/// A17: barras flotantes de rango (mínimo–máximo).
class GraphicAdvanced17 extends StatelessWidget {
  const GraphicAdvanced17({super.key});

  @override
  Widget build(BuildContext context) {
    final data = <Datum>[
      for (final p in topBy((p) => p.total, 10))
        {
          'name': p.name,
          'min': p.stats.reduce(math.min),
          'max': p.stats.reduce(math.max),
        },
    ];
    LinearScale scale() => LinearScale(min: 0, max: 170);
    return GraphicChartCard(
      code: 'A17',
      title: 'Rango de estadísticas: de la peor a la mejor',
      description: 'Varset(name) * (Varset(min) + Varset(max)): barras que flotan.',
      chart: Chart(
        data: data,
        variables: {
          'name': strVar('name'),
          'min': numVar('min', scale: scale()),
          'max': numVar('max', scale: scale()),
        },
        marks: [
          IntervalMark(
            position: Varset('name') * (Varset('min') + Varset('max')),
            shape: ShapeEncode(
                value: RectShape(
                    borderRadius: const BorderRadius.all(Radius.circular(8)))),
            color: ColorEncode(value: Colors.teal.shade400),
            size: SizeEncode(value: 14),
          ),
        ],
        coord: RectCoord(transposed: true),
        axes: rectAxes(),
      ),
    );
  }
}

const List<Datum> _trainerFunnel = [
  {'stage': 'Vieron un Pokémon', 'value': 1000},
  {'stage': 'Lanzaron Poké Ball', 'value': 720},
  {'stage': 'Lo atraparon', 'value': 430},
  {'stage': 'Lo evolucionaron', 'value': 190},
  {'stage': 'Llegaron a nivel 100', 'value': 45},
];

Chart<Datum> _funnel({required bool pyramid}) => Chart(
      data: _trainerFunnel,
      variables: {
        'stage': strVar('stage'),
        // SymmetricModifier centra en el cero: la escala debe ser simétrica.
        'value': numVar('value', scale: LinearScale(min: -1000, max: 1000)),
      },
      marks: [
        IntervalMark(
          shape: ShapeEncode(value: FunnelShape(pyramid: pyramid)),
          color: ColorEncode(variable: 'stage', values: const [
            Color(0xFF1565C0),
            Color(0xFF1E88E5),
            Color(0xFF42A5F5),
            Color(0xFF90CAF9),
            Color(0xFFBBDEFB),
          ]),
          label: LabelEncode(
            encoder: (t) => Label(
              '${t['stage']}: ${t['value']}',
              LabelStyle(
                textStyle: const TextStyle(fontSize: 10, color: Color(0xFF0D2440)),
              ),
            ),
          ),
          modifiers: [SymmetricModifier()],
        ),
      ],
      coord: RectCoord(transposed: true, verticalRange: const [1, 0]),
    );

/// A18: embudo.
class GraphicAdvanced18 extends StatelessWidget {
  const GraphicAdvanced18({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphicChartCard(
      code: 'A18',
      title: 'Embudo del entrenador (ejemplo)',
      description: 'FunnelShape + SymmetricModifier, transpuesto y de arriba abajo.',
      chart: _funnel(pyramid: false),
    );
  }
}

/// A19: pirámide.
class GraphicAdvanced19 extends StatelessWidget {
  const GraphicAdvanced19({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphicChartCard(
      code: 'A19',
      title: 'El mismo embudo como pirámide',
      description: 'FunnelShape(pyramid: true): el último tramo termina en punta.',
      chart: _funnel(pyramid: true),
    );
  }
}

/// A20: anotaciones (promedio, zona y etiqueta).
class GraphicAdvanced20 extends StatelessWidget {
  const GraphicAdvanced20({super.key});

  @override
  Widget build(BuildContext context) {
    final top = topBy((p) => p.attack, 10);
    final avg = top.map((p) => p.attack).reduce((a, b) => a + b) / top.length;
    return GraphicChartCard(
      code: 'A20',
      title: 'Ataque con promedio, zona élite y récord',
      description: 'LineAnnotation, RegionAnnotation y TagAnnotation sobre las columnas.',
      chart: Chart(
        data: top,
        variables: {
          'name': pokeName(),
          'attack': pokeNum((p) => p.attack, scale: LinearScale(min: 0, max: 150)),
        },
        marks: [IntervalMark(color: ColorEncode(value: Colors.blueGrey.shade300))],
        annotations: [
          RegionAnnotation(
            dim: Dim.y,
            variable: 'attack',
            values: const [120, 150],
            color: Colors.amber.withValues(alpha: 0.18),
          ),
          LineAnnotation(
            dim: Dim.y,
            variable: 'attack',
            value: avg,
            style: PaintStyle(strokeColor: Colors.red, strokeWidth: 1.5, dash: [6, 4]),
          ),
          TagAnnotation(
            label: Label(
              'Promedio ${avg.toStringAsFixed(1)}',
              LabelStyle(
                textStyle: const TextStyle(fontSize: 10, color: Colors.red),
                align: Alignment.topRight,
              ),
            ),
            variables: ['name', 'attack'],
            values: [top.last.name, avg],
          ),
          TagAnnotation(
            label: Label(
              'Récord: ${top.first.name}',
              LabelStyle(
                textStyle: const TextStyle(
                    fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black87),
                align: Alignment.topCenter,
                offset: const Offset(0, -4),
              ),
            ),
            variables: ['name', 'attack'],
            values: [top.first.name, top.first.attack],
          ),
        ],
        axes: rectAxes(xRotation: -0.6),
      ),
    );
  }
}

/// A21: doble eje (peso en barras, altura en línea).
class GraphicAdvanced21 extends StatelessWidget {
  const GraphicAdvanced21({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphicChartCard(
      code: 'A21',
      title: 'Peso (barras) y altura (línea), dos ejes',
      description: 'Dos marcas con variables distintas y un segundo AxisGuide a la derecha.',
      chart: Chart(
        data: topBy((p) => p.weight.round(), 9),
        variables: {
          'name': pokeName(),
          'weight': pokeNum((p) => p.weight, scale: LinearScale(min: 0, max: 500)),
          'height': pokeNum((p) => p.height, scale: LinearScale(min: 0, max: 10)),
        },
        marks: [
          IntervalMark(
            position: Varset('name') * Varset('weight'),
            color: ColorEncode(value: Colors.blueGrey.shade300),
          ),
          LineMark(
            position: Varset('name') * Varset('height'),
            color: ColorEncode(value: Colors.deepOrange),
            size: SizeEncode(value: 2.5),
          ),
          PointMark(
            position: Varset('name') * Varset('height'),
            color: ColorEncode(value: Colors.deepOrange),
          ),
        ],
        axes: [
          xAxis(rotation: -0.6),
          AxisGuide(
            dim: Dim.y,
            variable: 'weight',
            label: LabelStyle(
              textStyle: const TextStyle(fontSize: 10, color: Color(0xFF607D8B)),
              offset: const Offset(-7.5, 0),
            ),
            grid: Defaults.strokeStyle,
          ),
          AxisGuide(
            dim: Dim.y,
            variable: 'height',
            position: 1,
            flip: true,
            label: LabelStyle(
              textStyle: const TextStyle(fontSize: 10, color: Colors.deepOrange),
              offset: const Offset(7.5, 0),
            ),
          ),
        ],
      ),
    );
  }
}

/// Forma propia: piruleta (línea + círculo en la punta).
class LollipopShape extends IntervalShape {
  LollipopShape({this.radius = 7});

  final double radius;

  @override
  List<MarkElement> drawGroupPrimitives(
      List<Attributes> group, CoordConv coord, Offset origin) {
    final rst = <MarkElement>[];
    for (final item in group) {
      if (item.position.any((p) => !p.dy.isFinite)) continue;
      final style = getPaintStyle(item, false, 0, null, null);
      final base = coord.convert(item.position[0]);
      final tip = coord.convert(item.position[1]);
      rst.add(GroupElement(
        elements: [
          PolylineElement(
            points: [base, tip],
            style: PaintStyle(strokeColor: style.fillColor, strokeWidth: 2.5),
          ),
          CircleElement(center: tip, radius: radius, style: style),
        ],
        tag: item.tag,
      ));
    }
    return rst;
  }

  @override
  List<MarkElement> drawGroupLabels(
      List<Attributes> group, CoordConv coord, Offset origin) {
    return [
      for (final item in group)
        if (item.label != null && item.position.every((p) => p.dy.isFinite))
          LabelElement(
            text: item.label!.text!,
            anchor: coord.convert(item.position[1]).translate(0, -radius - 2),
            defaultAlign: Alignment.topCenter,
            style: item.label!.style,
            tag: item.tag,
          ),
    ];
  }

  @override
  bool equalTo(Object other) => other is LollipopShape && radius == other.radius;
}

/// A22: forma personalizada (piruleta).
class GraphicAdvanced22 extends StatelessWidget {
  const GraphicAdvanced22({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphicChartCard(
      code: 'A22',
      title: 'Gráfico de piruletas (forma propia)',
      description: 'LollipopShape extiende IntervalShape y dibuja línea + círculo.',
      chart: Chart(
        data: topBy((p) => p.speed, 10),
        variables: {
          'name': pokeName(),
          'speed': pokeNum((p) => p.speed, scale: LinearScale(min: 0, max: 150)),
          'type': pokeType(),
        },
        marks: [
          IntervalMark(
            shape: ShapeEncode(value: LollipopShape()),
            color: typeColorFixed(),
            label: LabelEncode(encoder: (t) => smallLabel(t['speed'].toString())),
          ),
        ],
        axes: rectAxes(xRotation: -0.6),
      ),
    );
  }
}

/// A23: medidor (gauge) con selector.
class GraphicAdvanced23 extends StatefulWidget {
  const GraphicAdvanced23({super.key});

  @override
  State<GraphicAdvanced23> createState() => _GraphicAdvanced23State();
}

class _GraphicAdvanced23State extends State<GraphicAdvanced23> {
  String _name = 'Alakazam';

  @override
  Widget build(BuildContext context) {
    final p = pokeByName(_name);
    const max = 160;
    final data = <Datum>[
      {'part': 'Velocidad', 'value': p.speed},
      {'part': 'Resto', 'value': max - p.speed},
    ];
    return GraphicChartCard(
      code: 'A23',
      title: 'Velocímetro de velocidad base (máx. 160)',
      description: 'Media dona de dos sectores + TagAnnotation con el valor al centro.',
      height: 200,
      controls: DropdownButton<String>(
        value: _name,
        isDense: true,
        items: [
          for (final q in kPokes)
            DropdownMenuItem(value: q.name, child: Text(q.name)),
        ],
        onChanged: (v) => setState(() => _name = v!),
      ),
      chart: Chart(
        data: data,
        variables: {'part': strVar('part'), 'value': numVar('value')},
        transforms: [Proportion(variable: 'value', as: 'percent')],
        marks: [
          IntervalMark(
            position: Varset('percent') / Varset('part'),
            color: ColorEncode(
              encoder: (t) => t['part'] == 'Resto'
                  ? Colors.grey.withValues(alpha: 0.2)
                  : (p.speed >= 100 ? Colors.green : Colors.orange),
            ),
            modifiers: [StackModifier()],
            transition: Transition(duration: const Duration(milliseconds: 700)),
          ),
        ],
        coord: PolarCoord(
          transposed: true,
          dimCount: 1,
          startAngle: -math.pi,
          endAngle: 0,
          startRadius: 0.62,
        ),
        annotations: [
          TagAnnotation(
            label: Label(
              '${p.speed}',
              LabelStyle(
                textStyle: const TextStyle(
                    fontSize: 30, fontWeight: FontWeight.w800, color: Colors.grey),
                align: Alignment.topCenter,
              ),
            ),
            anchor: (size) => Offset(size.width / 2, size.height / 2 - 6),
          ),
        ],
      ),
    );
  }
}

/// A24: barras divergentes (ataque − defensa).
class GraphicAdvanced24 extends StatelessWidget {
  const GraphicAdvanced24({super.key});

  @override
  Widget build(BuildContext context) {
    final data = <Datum>[
      for (final p in [...kPokes]
        ..sort((a, b) => (a.attack - a.defense).compareTo(b.attack - b.defense)))
        {'name': p.name, 'diff': p.attack - p.defense},
    ];
    return GraphicChartCard(
      code: 'A24',
      title: '¿Ofensivo o defensivo? (ataque − defensa)',
      description: 'Barras divergentes desde cero; color según el signo.',
      height: 380,
      chart: Chart(
        data: data,
        variables: {
          'name': strVar('name'),
          'diff': numVar('diff', scale: LinearScale(min: -120, max: 60)),
        },
        marks: [
          IntervalMark(
            color: ColorEncode(
              encoder: (t) =>
                  (t['diff'] as num) >= 0 ? Colors.redAccent : Colors.blueAccent,
            ),
          ),
        ],
        coord: RectCoord(transposed: true),
        annotations: [
          LineAnnotation(
            dim: Dim.y,
            variable: 'diff',
            value: 0,
            style: PaintStyle(strokeColor: Colors.grey, strokeWidth: 1),
          ),
        ],
        axes: rectAxes(),
      ),
    );
  }
}

/// A25: pequeños múltiplos (un minigráfico por Pokémon).
class GraphicAdvanced25 extends StatelessWidget {
  const GraphicAdvanced25({super.key});

  Widget _mini(Poke p) {
    final color = kTypeColors[p.type] ?? Colors.grey;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${p.name} · ${p.total}',
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
        Expanded(
          child: Chart(
            data: statsLong([p]),
            variables: {
              'stat': strVar('stat', scale: OrdinalScale(inflate: true)),
              'value': numVar('value', scale: LinearScale(min: 0, max: 160)),
            },
            marks: [
              AreaMark(color: ColorEncode(value: color.withValues(alpha: 0.3))),
              LineMark(color: ColorEncode(value: color)),
            ],
            padding: (_) => const EdgeInsets.fromLTRB(2, 4, 2, 2),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final picks = pokesByName([
      'Venusaur', 'Charizard', 'Blastoise', 'Pikachu', 'Gengar', 'Machamp',
      'Snorlax', 'Dragonite', 'Mewtwo',
    ]);
    return GraphicChartCard(
      code: 'A25',
      title: 'Pequeños múltiplos: perfil de 9 Pokémon',
      description: 'Nueve Chart sin ejes con la misma escala: se comparan de un vistazo.',
      height: 380,
      chart: GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.25,
        physics: const NeverScrollableScrollPhysics(),
        children: [for (final p in picks) _mini(p)],
      ),
    );
  }
}
