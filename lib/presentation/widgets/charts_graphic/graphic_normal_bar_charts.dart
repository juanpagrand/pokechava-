// Gráficos normales N01–N08: barras y columnas.

import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

import 'graphic_chart_card.dart';
import 'graphic_data.dart';

/// N01: columnas simples.
class GraphicNormal01 extends StatelessWidget {
  const GraphicNormal01({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphicChartCard(
      code: 'N01',
      title: 'Top 10 por ataque base',
      description: 'Columnas: IntervalMark en coordenadas cartesianas.',
      chart: Chart(
        // datos
        data: topBy((p) => p.attack, 10),
        // qué va en cada eje
        variables: {
          'name': pokeName(),
          // min: 0 para que las barras arranquen en 0
          'attack': pokeNum((p) => p.attack, scale: LinearScale(min: 0)),
        },
        // tipo de figura
        marks: [IntervalMark(color: ColorEncode(value: Colors.redAccent))],
        axes: rectAxes(xRotation: -0.6),
      ),
    );
  }
}

/// N02: barras horizontales (el mismo IntervalMark, transpuesto).
class GraphicNormal02 extends StatelessWidget {
  const GraphicNormal02({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphicChartCard(
      code: 'N02',
      title: 'Top 10 por HP (barras horizontales)',
      description: 'RectCoord(transposed: true) gira las columnas.',
      height: 300,
      chart: Chart(
        // reversed para que el mayor quede arriba
        data: topBy((p) => p.hp, 10).reversed.toList(),
        variables: {
          'name': pokeName(),
          'hp': pokeNum((p) => p.hp, scale: LinearScale(min: 0)),
        },
        marks: [IntervalMark(color: ColorEncode(value: Colors.green))],
        // transposed = barras horizontales
        coord: RectCoord(transposed: true),
        axes: rectAxes(),
      ),
    );
  }
}

/// N03: columnas con etiqueta de valor.
class GraphicNormal03 extends StatelessWidget {
  const GraphicNormal03({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphicChartCard(
      code: 'N03',
      title: 'Los 8 más rápidos',
      description: 'LabelEncode escribe el valor encima de cada columna.',
      chart: Chart(
        data: topBy((p) => p.speed, 8),
        variables: {
          'name': pokeName(),
          // max 150 para que quepa la etiqueta
          'speed': pokeNum((p) => p.speed, scale: LinearScale(min: 0, max: 150)),
        },
        marks: [
          IntervalMark(
            color: ColorEncode(value: Colors.pinkAccent),
            label: LabelEncode(
                encoder: (t) => smallLabel(t['speed'].toString())),
          ),
        ],
        axes: rectAxes(xRotation: -0.6),
      ),
    );
  }
}

/// N04: columnas agrupadas (DodgeModifier).
class GraphicNormal04 extends StatelessWidget {
  const GraphicNormal04({super.key});

  @override
  Widget build(BuildContext context) {
    final names = ['Charizard', 'Blastoise', 'Venusaur', 'Machamp', 'Onix', 'Snorlax'];
    final data = <Datum>[
      for (final p in pokesByName(names)) ...[
        {'name': p.name, 'stat': 'Ataque', 'value': p.attack},
        {'name': p.name, 'stat': 'Defensa', 'value': p.defense},
      ],
    ];
    return GraphicChartCard(
      code: 'N04',
      title: 'Ataque vs. defensa',
      description: 'Barras agrupadas: Varset / Varset(stat) + DodgeModifier.',
      chart: Chart(
        data: data,
        variables: {
          'name': strVar('name'),
          'stat': strVar('stat'),
          'value': numVar('value', scale: LinearScale(min: 0)),
        },
        marks: [
          IntervalMark(
            // / Varset('stat') separa ataque y defensa
            position: Varset('name') * Varset('value') / Varset('stat'),
            color: ColorEncode(
                variable: 'stat', values: const [Colors.red, Colors.blue]),
            // dodge = una al lado de la otra
            modifiers: [DodgeModifier(ratio: 0.12)],
          ),
        ],
        axes: rectAxes(xRotation: -0.5),
      ),
    );
  }
}

/// N05: columnas apiladas (StackModifier).
class GraphicNormal05 extends StatelessWidget {
  const GraphicNormal05({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphicChartCard(
      code: 'N05',
      title: 'Total de estadísticas, apilado',
      description: 'Cada segmento es una estadística: StackModifier.',
      height: 290,
      chart: Chart(
        data: statsLong(topBy((p) => p.total, 7)),
        variables: {
          'name': strVar('name'),
          'stat': strVar('stat'),
          // max: la pila llega a ~680, si no se recorta
          'value': numVar('value', scale: LinearScale(min: 0, max: 700)),
        },
        marks: [
          IntervalMark(
            position: Varset('name') * Varset('value') / Varset('stat'),
            color: ColorEncode(variable: 'stat', values: kStatColors),
            modifiers: [StackModifier()],
          ),
        ],
        axes: rectAxes(xRotation: -0.5),
      ),
    );
  }
}

/// N06: barras horizontales apiladas.
class GraphicNormal06 extends StatelessWidget {
  const GraphicNormal06({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphicChartCard(
      code: 'N06',
      title: 'Iniciales finales: composición horizontal',
      description: 'El N05 transpuesto, con solo tres Pokémon.',
      height: 200,
      chart: Chart(
        data: statsLong(pokesByName(['Venusaur', 'Charizard', 'Blastoise'])),
        variables: {
          'name': strVar('name'),
          'stat': strVar('stat'),
          'value': numVar('value', scale: LinearScale(min: 0, max: 600)),
        },
        marks: [
          IntervalMark(
            position: Varset('name') * Varset('value') / Varset('stat'),
            color: ColorEncode(variable: 'stat', values: kStatColors),
            modifiers: [StackModifier()],
            // grosor de la barra
            size: SizeEncode(value: 26),
          ),
        ],
        coord: RectCoord(transposed: true),
        axes: rectAxes(),
      ),
    );
  }
}

/// N07: columnas coloreadas por tipo.
class GraphicNormal07 extends StatelessWidget {
  const GraphicNormal07({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphicChartCard(
      code: 'N07',
      title: 'Los más pesados, color por tipo',
      description: 'ColorEncode con una función que busca el color del tipo.',
      chart: Chart(
        data: topBy((p) => p.weight.round(), 10),
        variables: {
          'name': pokeName(),
          'type': pokeType(),
          'weight': pokeNum((p) => p.weight, scale: LinearScale(min: 0)),
        },
        marks: [
          IntervalMark(
            // position explícito, sin él cruza name x type
            position: Varset('name') * Varset('weight'),
            color: typeColorFixed(),
          ),
        ],
        axes: rectAxes(xRotation: -0.6),
      ),
    );
  }
}

/// N08: columnas redondeadas con color condicional.
class GraphicNormal08 extends StatelessWidget {
  const GraphicNormal08({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphicChartCard(
      code: 'N08',
      title: 'Defensa: ¿quién pasa de 100?',
      description: 'RectShape con bordes redondeados; rojo si defensa ≥ 100.',
      chart: Chart(
        data: kPokes.take(12).toList(),
        variables: {
          'name': pokeName(),
          'defense': pokeNum((p) => p.defense, scale: LinearScale(min: 0)),
        },
        marks: [
          IntervalMark(
            // solo las esquinas de arriba redondeadas
            shape: ShapeEncode(
              value: RectShape(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(6))),
            ),
            color: ColorEncode(
              encoder: (t) => (t['defense'] as num) >= 100
                  ? Colors.redAccent
                  : Colors.blueGrey,
            ),
          ),
        ],
        axes: rectAxes(xRotation: -0.6),
      ),
    );
  }
}
