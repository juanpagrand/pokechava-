import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

import 'graphic_chart_card.dart';
import 'graphic_data.dart';

// Gráficos normales N09–N15 (líneas) y N16–N21 (áreas).

Variable<Poke, String> _byDex() => Variable<Poke, String>(
      accessor: (Poke p) => '#${p.id}',
      scale: OrdinalScale(inflate: true, tickCount: 8),
    );

/// N09: línea simple.
class GraphicNormal09 extends StatelessWidget {
  const GraphicNormal09({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphicChartCard(
      code: 'N09',
      title: 'Total de estadísticas por número de Pokédex',
      description: 'LineMark recto sobre una secuencia ordenada.',
      chart: Chart(
        data: kPokes,
        variables: {
          'dex': _byDex(),
          'total': pokeNum((p) => p.total, scale: LinearScale(min: 200)),
        },
        marks: [LineMark(color: ColorEncode(value: Colors.indigo))],
        axes: rectAxes(),
      ),
    );
  }
}

/// N10: la misma línea, suavizada.
class GraphicNormal10 extends StatelessWidget {
  const GraphicNormal10({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphicChartCard(
      code: 'N10',
      title: 'Experiencia base (línea suave)',
      description: 'BasicLineShape(smooth: true).',
      chart: Chart(
        data: kPokes,
        variables: {
          'dex': _byDex(),
          'exp': pokeNum((p) => p.baseExp, scale: LinearScale(min: 0)),
        },
        marks: [
          LineMark(
            shape: ShapeEncode(value: BasicLineShape(smooth: true)),
            size: SizeEncode(value: 2.5),
            color: ColorEncode(value: Colors.deepOrange),
          ),
        ],
        axes: rectAxes(),
      ),
    );
  }
}

/// N11: varias series (una por línea evolutiva).
class GraphicNormal11 extends StatelessWidget {
  const GraphicNormal11({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphicChartCard(
      code: 'N11',
      title: 'Cómo crece el total al evolucionar',
      description:
          'Multi-serie con / Varset(line). Casi se tocan: las tres líneas están balanceadas.',
      chart: Chart(
        data: starterStages((p) => p.total),
        variables: {
          'stage': strVar('stage', scale: OrdinalScale(inflate: true)),
          'value': numVar('value', scale: LinearScale(min: 250)),
          'line': strVar('line'),
        },
        marks: [
          LineMark(
            position: Varset('stage') * Varset('value') / Varset('line'),
            color: ColorEncode(variable: 'line', values: const [
              Color(0xFF5FA845),
              Color(0xFFEE7F30),
              Color(0xFF4F86E8),
            ]),
          ),
        ],
        axes: rectAxes(),
      ),
    );
  }
}

/// N12: línea con puntos (dos marcas sobre los mismos datos).
class GraphicNormal12 extends StatelessWidget {
  const GraphicNormal12({super.key});

  @override
  Widget build(BuildContext context) {
    final data = statsLong([pokeByName('Pikachu')]);
    return GraphicChartCard(
      code: 'N12',
      title: 'Pikachu: estadística por estadística',
      description: 'LineMark + PointMark: dos marcas, mismos datos.',
      chart: Chart(
        data: data,
        variables: {
          'stat': strVar('stat', scale: OrdinalScale(inflate: true)),
          'value': numVar('value', scale: LinearScale(min: 0, max: 100)),
        },
        marks: [
          LineMark(color: ColorEncode(value: Colors.amber.shade700)),
          PointMark(
            color: ColorEncode(value: Colors.amber.shade700),
            size: SizeEncode(value: 9),
          ),
        ],
        axes: rectAxes(),
      ),
    );
  }
}

/// N13: línea escalonada.
class GraphicNormal13 extends StatelessWidget {
  const GraphicNormal13({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphicChartCard(
      code: 'N13',
      title: 'Velocidad en escalones',
      description: 'BasicLineShape(stepped: true).',
      chart: Chart(
        data: kPokes,
        variables: {
          'dex': _byDex(),
          'speed': pokeNum((p) => p.speed, scale: LinearScale(min: 0)),
        },
        marks: [
          LineMark(
            shape: ShapeEncode(value: BasicLineShape(stepped: true)),
            color: ColorEncode(value: Colors.teal),
          ),
        ],
        axes: rectAxes(),
      ),
    );
  }
}

/// N14: dos líneas, una punteada.
class GraphicNormal14 extends StatelessWidget {
  const GraphicNormal14({super.key});

  @override
  Widget build(BuildContext context) {
    final data = <Datum>[
      for (final p in kPokes) ...[
        {'dex': '#${p.id}', 'serie': 'At. Esp.', 'value': p.spAtk},
        {'dex': '#${p.id}', 'serie': 'Def. Esp.', 'value': p.spDef},
      ],
    ];
    return GraphicChartCard(
      code: 'N14',
      title: 'Ataque especial vs. defensa especial',
      description: 'Una serie continua y otra punteada (dash).',
      chart: Chart(
        data: data,
        variables: {
          'dex': strVar('dex', scale: OrdinalScale(inflate: true, tickCount: 8)),
          'value': numVar('value', scale: LinearScale(min: 0)),
          'serie': strVar('serie'),
        },
        marks: [
          LineMark(
            position: Varset('dex') * Varset('value') / Varset('serie'),
            color: ColorEncode(
                variable: 'serie',
                values: const [Colors.deepPurple, Colors.green]),
            shape: ShapeEncode(
              encoder: (t) => t['serie'] == 'Def. Esp.'
                  ? BasicLineShape(dash: [6, 4])
                  : BasicLineShape(),
            ),
          ),
        ],
        axes: rectAxes(),
      ),
    );
  }
}

/// N15: línea vertical (transpuesta).
class GraphicNormal15 extends StatelessWidget {
  const GraphicNormal15({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphicChartCard(
      code: 'N15',
      title: 'Altura a lo largo de la Pokédex (vertical)',
      description: 'La N09 girada: RectCoord(transposed: true).',
      height: 320,
      chart: Chart(
        data: kPokes,
        variables: {
          'dex': _byDex(),
          'height': pokeNum((p) => p.height, scale: LinearScale(min: 0)),
        },
        marks: [
          LineMark(
            color: ColorEncode(value: Colors.brown),
          ),
        ],
        coord: RectCoord(transposed: true),
        axes: rectAxes(),
      ),
    );
  }
}

/// N16: área simple.
class GraphicNormal16 extends StatelessWidget {
  const GraphicNormal16({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphicChartCard(
      code: 'N16',
      title: 'HP a lo largo de la Pokédex',
      description: 'AreaMark: la línea rellena hasta la base.',
      chart: Chart(
        data: kPokes,
        variables: {
          'dex': _byDex(),
          'hp': pokeNum((p) => p.hp, scale: LinearScale(min: 0)),
        },
        marks: [
          AreaMark(color: ColorEncode(value: Colors.green.withValues(alpha: 0.45))),
        ],
        axes: rectAxes(),
      ),
    );
  }
}

/// N17: área suave.
class GraphicNormal17 extends StatelessWidget {
  const GraphicNormal17({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphicChartCard(
      code: 'N17',
      title: 'Ataque (área suave)',
      description: 'BasicAreaShape(smooth: true).',
      chart: Chart(
        data: kPokes,
        variables: {
          'dex': _byDex(),
          'attack': pokeNum((p) => p.attack, scale: LinearScale(min: 0)),
        },
        marks: [
          AreaMark(
            shape: ShapeEncode(value: BasicAreaShape(smooth: true)),
            color: ColorEncode(value: Colors.red.withValues(alpha: 0.4)),
          ),
        ],
        axes: rectAxes(),
      ),
    );
  }
}

/// N18: áreas apiladas.
class GraphicNormal18 extends StatelessWidget {
  const GraphicNormal18({super.key});

  @override
  Widget build(BuildContext context) {
    final data = <Datum>[
      for (final p in kPokes)
        for (var i = 0; i < 3; i++)
          {'dex': '#${p.id}', 'stat': kStatNames[i], 'value': p.stats[i]},
    ];
    return GraphicChartCard(
      code: 'N18',
      title: 'HP + Ataque + Defensa apilados',
      description: 'AreaMark con StackModifier.',
      chart: Chart(
        data: data,
        variables: {
          'dex': strVar('dex', scale: OrdinalScale(inflate: true, tickCount: 8)),
          'value': numVar('value', scale: LinearScale(min: 0, max: 400)),
          'stat': strVar('stat'),
        },
        marks: [
          AreaMark(
            position: Varset('dex') * Varset('value') / Varset('stat'),
            color: ColorEncode(
                variable: 'stat', values: kStatColors.take(3).toList()),
            modifiers: [StackModifier()],
          ),
        ],
        axes: rectAxes(),
      ),
    );
  }
}

/// N19: stream graph.
class GraphicNormal19 extends StatelessWidget {
  const GraphicNormal19({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphicChartCard(
      code: 'N19',
      title: 'Río de estadísticas (stream graph)',
      description: 'StackModifier + SymmetricModifier centran el apilado.',
      chart: Chart(
        data: statsLong(kPokes)
            .map((r) => {...r, 'dex': '#${pokeByName(r['name']).id}'})
            .toList(),
        variables: {
          'dex': strVar('dex', scale: OrdinalScale(tickCount: 8)),
          'value': numVar('value'),
          'stat': strVar('stat'),
        },
        marks: [
          AreaMark(
            position: Varset('dex') * Varset('value') / Varset('stat'),
            shape: ShapeEncode(value: BasicAreaShape(smooth: true)),
            color: ColorEncode(variable: 'stat', values: kStatColors),
            modifiers: [StackModifier(), SymmetricModifier()],
          ),
        ],
        axes: [xAxis()],
      ),
    );
  }
}

/// N20: área + línea de contorno.
class GraphicNormal20 extends StatelessWidget {
  const GraphicNormal20({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphicChartCard(
      code: 'N20',
      title: 'Peso: área con contorno',
      description: 'AreaMark tenue + LineMark encima.',
      chart: Chart(
        data: kPokes,
        variables: {
          'dex': _byDex(),
          'weight': pokeNum((p) => p.weight, scale: LinearScale(min: 0, max: 520)),
        },
        marks: [
          AreaMark(
            shape: ShapeEncode(value: BasicAreaShape(smooth: true)),
            color: ColorEncode(value: Colors.blueGrey.withValues(alpha: 0.25)),
          ),
          LineMark(
            shape: ShapeEncode(value: BasicLineShape(smooth: true)),
            color: ColorEncode(value: Colors.blueGrey),
          ),
        ],
        axes: rectAxes(),
      ),
    );
  }
}

/// N21: área con degradado.
class GraphicNormal21 extends StatelessWidget {
  const GraphicNormal21({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphicChartCard(
      code: 'N21',
      title: 'Ataque especial con degradado',
      description: 'GradientEncode en lugar de un color plano.',
      chart: Chart(
        data: kPokes,
        variables: {
          'dex': _byDex(),
          'spAtk': pokeNum((p) => p.spAtk, scale: LinearScale(min: 0)),
        },
        marks: [
          AreaMark(
            shape: ShapeEncode(value: BasicAreaShape(smooth: true)),
            gradient: GradientEncode(
              value: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.purple.withValues(alpha: 0.8),
                  Colors.purple.withValues(alpha: 0.05),
                ],
              ),
            ),
          ),
        ],
        axes: rectAxes(),
      ),
    );
  }
}
