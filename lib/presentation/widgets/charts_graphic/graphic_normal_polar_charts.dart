import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

import 'graphic_chart_card.dart';
import 'graphic_data.dart';

// Gráficos normales N28–N38: circulares, rosas y radares (PolarCoord).

const _typePalette = [
  Color(0xFF4F86E8),
  Color(0xFF9C9A6E),
  Color(0xFF9B59B6),
  Color(0xFF5FA845),
  Color(0xFFEE7F30),
  Color(0xFFA8B820),
  Color(0xFFE3BB1E),
  Color(0xFFBDBDBD),
];

Map<String, Variable<Datum, dynamic>> _typeVars() => {
      'type': strVar('type'),
      'count': numVar('count'),
    };

Label _whiteLabel(String text, {double size = 10}) => Label(
      text,
      LabelStyle(
        textStyle: TextStyle(
            fontSize: size, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );

String _pct(Tuple t) => '${((t['percent'] as num) * 100).toStringAsFixed(1)}%';

/// N28: torta.
class GraphicNormal28 extends StatelessWidget {
  const GraphicNormal28({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphicChartCard(
      code: 'N28',
      title: 'Tipos de Kanto (torta)',
      description:
          'Proportion + StackModifier + PolarCoord(transposed, dimCount: 1).',
      chart: Chart(
        data: kGen1Types,
        variables: _typeVars(),
        transforms: [Proportion(variable: 'count', as: 'percent')],
        marks: [
          IntervalMark(
            position: Varset('percent') / Varset('type'),
            color: ColorEncode(variable: 'type', values: _typePalette),
            label: LabelEncode(encoder: (t) => _whiteLabel(t['type'] as String, size: 9)),
            modifiers: [StackModifier()],
          ),
        ],
        coord: PolarCoord(transposed: true, dimCount: 1),
      ),
    );
  }
}

/// N29: dona.
class GraphicNormal29 extends StatelessWidget {
  const GraphicNormal29({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphicChartCard(
      code: 'N29',
      title: 'Tipos de Kanto (dona)',
      description: 'La N28 con startRadius: el centro queda hueco.',
      chart: Chart(
        data: kGen1Types,
        variables: _typeVars(),
        transforms: [Proportion(variable: 'count', as: 'percent')],
        marks: [
          IntervalMark(
            position: Varset('percent') / Varset('type'),
            color: ColorEncode(variable: 'type', values: _typePalette),
            label: LabelEncode(encoder: (t) => _whiteLabel(_pct(t), size: 9)),
            modifiers: [StackModifier()],
          ),
        ],
        coord: PolarCoord(transposed: true, dimCount: 1, startRadius: 0.45),
      ),
    );
  }
}

/// N30: media dona.
class GraphicNormal30 extends StatelessWidget {
  const GraphicNormal30({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphicChartCard(
      code: 'N30',
      title: 'Tipos de Kanto (media dona)',
      description: 'startAngle: -π y endAngle: 0 cortan el círculo a la mitad.',
      height: 200,
      chart: Chart(
        data: kGen1Types,
        variables: _typeVars(),
        transforms: [Proportion(variable: 'count', as: 'percent')],
        marks: [
          IntervalMark(
            position: Varset('percent') / Varset('type'),
            color: ColorEncode(variable: 'type', values: _typePalette),
            modifiers: [StackModifier()],
          ),
        ],
        coord: PolarCoord(
          transposed: true,
          dimCount: 1,
          startAngle: -math.pi,
          endAngle: 0,
          startRadius: 0.5,
        ),
      ),
    );
  }
}

/// N31: gráfico de rosa (Nightingale).
class GraphicNormal31 extends StatelessWidget {
  const GraphicNormal31({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphicChartCard(
      code: 'N31',
      title: 'Tipos de Kanto (rosa)',
      description: 'Barras en PolarCoord: el radio, no el ángulo, mide el valor.',
      chart: Chart(
        data: kGen1Types,
        variables: {
          'type': strVar('type'),
          'count': numVar('count', scale: LinearScale(min: 0)),
        },
        marks: [
          IntervalMark(
            color: ColorEncode(variable: 'type', values: _typePalette),
            shape: ShapeEncode(
                value: RectShape(
                    borderRadius: const BorderRadius.all(Radius.circular(6)))),
          ),
        ],
        coord: PolarCoord(startRadius: 0.12),
      ),
    );
  }
}

/// N32: barras radiales.
class GraphicNormal32 extends StatelessWidget {
  const GraphicNormal32({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphicChartCard(
      code: 'N32',
      title: 'Velocidad de los iniciales (barras radiales)',
      description: 'PolarCoord(transposed: true): cada barra es un anillo.',
      chart: Chart(
        data: pokesByName([
          'Bulbasaur', 'Charmander', 'Squirtle',
          'Venusaur', 'Charizard', 'Blastoise',
        ]),
        variables: {
          'name': pokeName(),
          'speed': pokeNum((p) => p.speed, scale: LinearScale(min: 0, max: 120)),
          'type': pokeType(),
        },
        marks: [
          IntervalMark(
            color: typeColorFixed(),
            shape: ShapeEncode(
                value: RectShape(
                    borderRadius: const BorderRadius.all(Radius.circular(8)))),
            size: SizeEncode(value: 10),
            label: LabelEncode(
                encoder: (t) => smallLabel('${t['name']} ${t['speed']}')),
          ),
        ],
        coord: PolarCoord(transposed: true, startRadius: 0.2, endAngle: math.pi),
      ),
    );
  }
}

/// N33: torta con etiquetas de cantidad.
class GraphicNormal33 extends StatelessWidget {
  const GraphicNormal33({super.key});

  @override
  Widget build(BuildContext context) {
    final data = <Datum>[
      for (final t in kTypeColors.keys)
        {'type': t, 'count': kPokes.where((p) => p.type == t).length},
    ];
    return GraphicChartCard(
      code: 'N33',
      title: 'Tipos en nuestra muestra de 23',
      description: 'Torta con etiqueta "tipo: cantidad" en cada sector.',
      chart: Chart(
        data: data,
        variables: _typeVars(),
        transforms: [Proportion(variable: 'count', as: 'percent')],
        marks: [
          IntervalMark(
            position: Varset('percent') / Varset('type'),
            color: typeColorFixed(),
            label: LabelEncode(
                encoder: (t) => _whiteLabel('${t['type']}: ${t['count']}', size: 8)),
            modifiers: [StackModifier()],
          ),
        ],
        coord: PolarCoord(transposed: true, dimCount: 1),
      ),
    );
  }
}

/// N34: anillo delgado.
class GraphicNormal34 extends StatelessWidget {
  const GraphicNormal34({super.key});

  @override
  Widget build(BuildContext context) {
    final p = pokeByName('Mewtwo');
    final data = <Datum>[
      for (var i = 0; i < kStatNames.length; i++)
        {'stat': kStatNames[i], 'value': p.stats[i]},
    ];
    return GraphicChartCard(
      code: 'N34',
      title: 'Mewtwo: reparto de sus 680 puntos',
      description: 'Anillo delgado: startRadius alto.',
      chart: Chart(
        data: data,
        variables: {'stat': strVar('stat'), 'value': numVar('value')},
        transforms: [Proportion(variable: 'value', as: 'percent')],
        marks: [
          IntervalMark(
            position: Varset('percent') / Varset('stat'),
            color: ColorEncode(variable: 'stat', values: kStatColors),
            label: LabelEncode(encoder: (t) => smallLabel(t['stat'] as String)),
            modifiers: [StackModifier()],
          ),
        ],
        coord: PolarCoord(transposed: true, dimCount: 1, startRadius: 0.7),
      ),
    );
  }
}

/// N35: rosa apilada.
class GraphicNormal35 extends StatelessWidget {
  const GraphicNormal35({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphicChartCard(
      code: 'N35',
      title: 'Iniciales: rosa apilada por estadística',
      description: 'La N05 llevada a PolarCoord.',
      height: 280,
      chart: Chart(
        data: statsLong(pokesByName([
          'Bulbasaur', 'Ivysaur', 'Venusaur', 'Charmander', 'Charmeleon',
          'Charizard', 'Squirtle', 'Wartortle', 'Blastoise',
        ])),
        variables: {
          'name': strVar('name'),
          'stat': strVar('stat'),
          'value': numVar('value', scale: LinearScale(min: 0, max: 700)),
        },
        marks: [
          IntervalMark(
            position: Varset('name') * Varset('value') / Varset('stat'),
            color: ColorEncode(variable: 'stat', values: kStatColors),
            modifiers: [StackModifier()],
          ),
        ],
        coord: PolarCoord(startRadius: 0.1),
        axes: [Defaults.circularAxis],
      ),
    );
  }
}

/// N36: radar de un Pokémon.
class GraphicNormal36 extends StatelessWidget {
  const GraphicNormal36({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphicChartCard(
      code: 'N36',
      title: 'Radar de Charizard',
      description: 'LineMark cerrada (loop) en PolarCoord.',
      chart: Chart(
        data: statsLong([pokeByName('Charizard')]),
        variables: {
          'stat': strVar('stat'),
          'value': numVar('value', scale: LinearScale(min: 0, max: 160)),
        },
        marks: [
          AreaMark(
            shape: ShapeEncode(value: BasicAreaShape(loop: true)),
            color: ColorEncode(value: Colors.deepOrange.withValues(alpha: 0.3)),
          ),
          LineMark(
            shape: ShapeEncode(value: BasicLineShape(loop: true)),
            color: ColorEncode(value: Colors.deepOrange),
          ),
        ],
        coord: PolarCoord(),
        axes: [Defaults.circularAxis, Defaults.radialAxis],
      ),
    );
  }
}

/// N37: radar comparativo.
class GraphicNormal37 extends StatelessWidget {
  const GraphicNormal37({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphicChartCard(
      code: 'N37',
      title: 'Charizard vs. Blastoise vs. Venusaur',
      description: 'Tres radares superpuestos: / Varset(name).',
      chart: Chart(
        data: statsLong(pokesByName(['Charizard', 'Blastoise', 'Venusaur'])),
        variables: {
          'stat': strVar('stat'),
          'value': numVar('value', scale: LinearScale(min: 0, max: 120)),
          'name': strVar('name'),
        },
        marks: [
          LineMark(
            position: Varset('stat') * Varset('value') / Varset('name'),
            shape: ShapeEncode(value: BasicLineShape(loop: true)),
            color: ColorEncode(variable: 'name', values: const [
              Color(0xFFEE7F30),
              Color(0xFF4F86E8),
              Color(0xFF5FA845),
            ]),
            size: SizeEncode(value: 2),
          ),
        ],
        coord: PolarCoord(),
        axes: [Defaults.circularAxis, Defaults.radialAxis],
      ),
    );
  }
}

/// N38: dispersión polar.
class GraphicNormal38 extends StatelessWidget {
  const GraphicNormal38({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphicChartCard(
      code: 'N38',
      title: 'Experiencia base alrededor del círculo',
      description: 'PointMark en PolarCoord: ángulo = Pokémon, radio = valor.',
      chart: Chart(
        data: kPokes,
        variables: {
          'name': pokeName(),
          'exp': pokeNum((p) => p.baseExp, scale: LinearScale(min: 0)),
          'type': pokeType(),
        },
        marks: [PointMark(color: typeColorFixed(), size: SizeEncode(value: 9))],
        coord: PolarCoord(),
        axes: [Defaults.radialAxis],
      ),
    );
  }
}
