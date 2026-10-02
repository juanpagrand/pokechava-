// Gráficos normales N22–N27: dispersión con PointMark.

import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

import 'graphic_chart_card.dart';
import 'graphic_data.dart';

/// N22: dispersión simple.
class GraphicNormal22 extends StatelessWidget {
  const GraphicNormal22({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphicChartCard(
      code: 'N22',
      title: 'Altura vs. peso',
      description: 'PointMark: dos variables numéricas, una por eje.',
      chart: Chart(
        data: kPokes,
        variables: {
          'height': pokeNum((p) => p.height, scale: LinearScale(min: 0)),
          'weight': pokeNum((p) => p.weight, scale: LinearScale(min: 0)),
        },
        marks: [
          PointMark(
            color: ColorEncode(value: Colors.indigo),
            size: SizeEncode(value: 7),
          ),
        ],
        axes: rectAxes(),
      ),
    );
  }
}

/// N23: burbujas.
class GraphicNormal23 extends StatelessWidget {
  const GraphicNormal23({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphicChartCard(
      code: 'N23',
      title: 'Ataque vs. defensa, tamaño = experiencia',
      description: 'SizeEncode convierte una tercera variable en radio.',
      chart: Chart(
        data: kPokes,
        variables: {
          'attack': pokeNum((p) => p.attack),
          'defense': pokeNum((p) => p.defense),
          'exp': pokeNum((p) => p.baseExp),
        },
        marks: [
          PointMark(
            // tamaño según la experiencia
            size: SizeEncode(variable: 'exp', values: const [4, 22]),
            color: ColorEncode(value: Colors.teal.withValues(alpha: 0.55)),
          ),
        ],
        axes: rectAxes(),
      ),
    );
  }
}

/// N24: dispersión con color por tipo.
class GraphicNormal24 extends StatelessWidget {
  const GraphicNormal24({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphicChartCard(
      code: 'N24',
      title: 'Velocidad vs. ataque especial, color por tipo',
      description: 'Una cuarta variable (el tipo) va al color.',
      chart: Chart(
        data: kPokes,
        variables: {
          'speed': pokeNum((p) => p.speed),
          'spAtk': pokeNum((p) => p.spAtk),
          // type de tercera para que no entre en el cruce
          'type': pokeType(),
        },
        marks: [
          PointMark(color: typeColorFixed(), size: SizeEncode(value: 10)),
        ],
        axes: rectAxes(),
      ),
    );
  }
}

/// N25: marcadores cuadrados huecos.
class GraphicNormal25 extends StatelessWidget {
  const GraphicNormal25({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphicChartCard(
      code: 'N25',
      title: 'HP vs. defensa especial',
      description: 'SquareShape(hollow: true) en lugar de círculos.',
      chart: Chart(
        data: kPokes,
        variables: {
          'hp': pokeNum((p) => p.hp),
          'spDef': pokeNum((p) => p.spDef),
        },
        marks: [
          PointMark(
            shape: ShapeEncode(
                value: SquareShape(hollow: true, strokeWidth: 2)),
            color: ColorEncode(value: Colors.deepOrange),
            size: SizeEncode(value: 10),
          ),
        ],
        axes: rectAxes(),
      ),
    );
  }
}

/// N26: diagrama de tiras (strip plot) con JitterModifier.
class GraphicNormal26 extends StatelessWidget {
  const GraphicNormal26({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphicChartCard(
      code: 'N26',
      title: 'Velocidad por tipo',
      description: 'Eje X categórico + JitterModifier para que no se encimen.',
      chart: Chart(
        data: kPokes,
        variables: {
          'type': pokeType(),
          'speed': pokeNum((p) => p.speed, scale: LinearScale(min: 0)),
        },
        marks: [
          PointMark(
            color: typeColorFixed(),
            size: SizeEncode(value: 9),
            // jitter para que los puntos no queden encimados
            modifiers: [JitterModifier(ratio: 0.5)],
          ),
        ],
        axes: rectAxes(xRotation: -0.5),
      ),
    );
  }
}

/// N27: dispersión con nombres.
class GraphicNormal27 extends StatelessWidget {
  const GraphicNormal27({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphicChartCard(
      code: 'N27',
      title: 'Ataque físico vs. especial, con nombre',
      description: 'LabelEncode pone el nombre junto a cada punto.',
      height: 300,
      chart: Chart(
        data: kPokes,
        variables: {
          'attack': pokeNum((p) => p.attack),
          'spAtk': pokeNum((p) => p.spAtk),
          'name': pokeName(),
        },
        marks: [
          PointMark(
            color: ColorEncode(value: Colors.blueGrey),
            size: SizeEncode(value: 6),
            label: LabelEncode(
              encoder: (t) => Label(
                t['name'] as String,
                LabelStyle(
                  textStyle:
                      const TextStyle(fontSize: 8, color: Color(0xFF757575)),
                  // 8 px arriba del punto
                  offset: const Offset(0, -8),
                ),
              ),
            ),
          ),
        ],
        axes: rectAxes(),
      ),
    );
  }
}
