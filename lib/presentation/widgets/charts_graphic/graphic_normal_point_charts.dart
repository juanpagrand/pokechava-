// ===========================================================================
// graphic_normal_point_charts.dart — NORMALES N22–N27 (DISPERSIÓN)
// ===========================================================================
// Qué contiene: 6 gráficos con PointMark (un punto por dato):
//   N22 dispersión simple · N23 burbujas (tamaño = variable) ·
//   N24 color por tipo · N25 cuadrados huecos ·
//   N26 tiras con JitterModifier · N27 puntos con nombre.
// Se asume lo de N01–N21; aquí solo se comenta lo nuevo.
//
// Imports:
//   - flutter/material.dart → widgets, Colors, TextStyle, Offset.
//   - graphic/graphic.dart  → Chart, PointMark, SizeEncode, SquareShape,
//     JitterModifier, LabelEncode, Label, LabelStyle…
//   - graphic_chart_card.dart / graphic_data.dart → tarjeta y datos/atajos.
//
// Quién lo importa: el barril charts_graphic.dart lo reexporta y
// graphic_charts_view.dart lo usa en la categoría "Dispersión".
// ===========================================================================

import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

import 'graphic_chart_card.dart';
import 'graphic_data.dart';

// Gráficos normales N22–N27: dispersión con PointMark.

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
        // Lo nuevo aquí: las DOS variables son números, así que los dos
        // ejes son LinearScale (no hay categorías). Sin `position`, la
        // primera (height) va a X y la segunda (weight) a Y.
        variables: {
          'height': pokeNum((p) => p.height, scale: LinearScale(min: 0)),
          'weight': pokeNum((p) => p.weight, scale: LinearScale(min: 0)),
        },
        marks: [
          // PointMark: un círculo en (height, weight) por cada Pokémon.
          // size = diámetro en píxeles.
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
        // Sin escala explícita: LinearScale automática (mín./máx. ±10 %).
        variables: {
          'attack': pokeNum((p) => p.attack),
          'defense': pokeNum((p) => p.defense),
          'exp': pokeNum((p) => p.baseExp),
        },
        marks: [
          PointMark(
            // Lo nuevo aquí: SizeEncode con `variable`. El tamaño depende
            // de 'exp': la menor experiencia → 4 px, la mayor → 22 px, y
            // los valores intermedios se interpolan.
            size: SizeEncode(variable: 'exp', values: const [4, 22]),
            // Semitransparente para ver burbujas que se tapan entre sí.
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
        // 'type' va de tercera: así no entra en el cruce por defecto de
        // las dos primeras (speed × spAtk). Comparar con N07.
        variables: {
          'speed': pokeNum((p) => p.speed),
          'spAtk': pokeNum((p) => p.spAtk),
          'type': pokeType(),
        },
        marks: [
          // Color fijo por tipo, igual que en N07.
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
            // Lo nuevo aquí: otra forma de punto. SquareShape = cuadrado;
            // hollow: true = solo el borde (sin relleno), de 2 px.
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
        // X es una categoría (el tipo), Y un número.
        variables: {
          'type': pokeType(),
          'speed': pokeNum((p) => p.speed, scale: LinearScale(min: 0)),
        },
        marks: [
          PointMark(
            color: typeColorFixed(),
            size: SizeEncode(value: 9),
            // Lo nuevo aquí: JitterModifier ("temblor"). Todos los puntos
            // de un tipo caerían en la misma columna, uno encima de otro;
            // este modificador los corre al azar hacia los lados, dentro
            // de la mitad (ratio 0.5) del ancho de esa categoría.
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
        // 'name' es tercera: solo se usa para la etiqueta.
        variables: {
          'attack': pokeNum((p) => p.attack),
          'spAtk': pokeNum((p) => p.spAtk),
          'name': pokeName(),
        },
        marks: [
          PointMark(
            color: ColorEncode(value: Colors.blueGrey),
            size: SizeEncode(value: 6),
            // Como N03, pero armando el Label a mano para controlar el
            // estilo: letra de 8 y offset (0, -8) = 8 px arriba del punto.
            label: LabelEncode(
              encoder: (t) => Label(
                t['name'] as String,
                LabelStyle(
                  textStyle:
                      const TextStyle(fontSize: 8, color: Color(0xFF757575)),
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
