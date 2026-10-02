// ===========================================================================
// graphic_normal_line_area_charts.dart — NORMALES N09–N21 (LÍNEAS Y ÁREAS)
// ===========================================================================
// Qué contiene:
//   Líneas (LineMark):  N09 simple · N10 suave · N11 varias series ·
//     N12 línea + puntos · N13 escalonada · N14 punteada · N15 vertical.
//   Áreas (AreaMark):   N16 simple · N17 suave · N18 apiladas ·
//     N19 río (stream) · N20 área + contorno · N21 degradado.
// Se asume lo explicado en N01–N08 (data, variables, escala, marks, axes,
// position con *, /, StackModifier). Aquí solo se comenta lo nuevo.
//
// Imports:
//   - flutter/material.dart → widgets, Colors, LinearGradient, Alignment.
//   - graphic/graphic.dart  → Chart, LineMark, AreaMark, PointMark,
//     BasicLineShape, BasicAreaShape, GradientEncode, OrdinalScale…
//   - graphic_chart_card.dart / graphic_data.dart → tarjeta y datos/atajos.
//
// Quién lo importa: el barril charts_graphic.dart lo reexporta y
// graphic_charts_view.dart lo usa en las categorías "Líneas" y "Áreas".
// ===========================================================================

import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

import 'graphic_chart_card.dart';
import 'graphic_data.dart';

// Gráficos normales N09–N15 (líneas) y N16–N21 (áreas).

// Variable del eje X compartida por varias líneas: el número de Pokédex
// como TEXTO ('#25'). Si fuera número, la línea dejaría huecos entre #9 y
// #25 o entre #95 y #130; como texto (categoría) los 23 quedan igual de
// separados, en el orden de los datos.
// OrdinalScale(inflate: true): reparte los puntos de borde a borde del
// eje (en barras conviene dejar medio hueco a cada lado; en líneas no).
// tickCount: 8: muestra solo 8 etiquetas de las 23 para que no se encimen.
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
          // Una línea no necesita empezar en 0 (no es una barra): con
          // min: 200 la curva usa más alto y se ven mejor las diferencias.
          'total': pokeNum((p) => p.total, scale: LinearScale(min: 200)),
        },
        // Lo nuevo aquí: LineMark une los puntos (dex, total) en orden.
        // Sin `position`, cruza las dos primeras variables: dex × total.
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
            // Lo nuevo aquí: la forma BasicLineShape con smooth: true
            // dibuja curvas en vez de segmentos rectos.
            shape: ShapeEncode(value: BasicLineShape(smooth: true)),
            // En una línea, SizeEncode es el grosor del trazo.
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
        // Formato largo: una fila por (línea evolutiva, etapa).
        data: starterStages((p) => p.total),
        variables: {
          'stage': strVar('stage', scale: OrdinalScale(inflate: true)),
          'value': numVar('value', scale: LinearScale(min: 250)),
          'line': strVar('line'),
        },
        marks: [
          LineMark(
            // Lo nuevo aquí: `/ Varset('line')` en una línea separa los
            // puntos en 3 grupos → 3 líneas distintas. Sin él, graphic
            // uniría todos los puntos en una sola línea en zigzag.
            position: Varset('stage') * Varset('value') / Varset('line'),
            // Un color por línea (Planta, Fuego, Agua en ese orden).
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
        // Lo nuevo aquí: `marks` es una LISTA; se pueden superponer varias
        // marcas sobre los mismos datos. Se dibujan en orden: primero la
        // línea y encima los puntos.
        marks: [
          LineMark(color: ColorEncode(value: Colors.amber.shade700)),
          // PointMark dibuja un punto por dato; size = diámetro.
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
            // Lo nuevo aquí: stepped: true → escalones (horizontal y luego
            // vertical) en vez de diagonales.
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
    // Formato largo hecho a mano: dos filas por Pokémon, una por serie.
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
          // Igual que _byDex, pero leyendo de un Datum.
          'dex': strVar('dex', scale: OrdinalScale(inflate: true, tickCount: 8)),
          'value': numVar('value', scale: LinearScale(min: 0)),
          'serie': strVar('serie'),
        },
        marks: [
          LineMark(
            // Dos series, como en N11.
            position: Varset('dex') * Varset('value') / Varset('serie'),
            color: ColorEncode(
                variable: 'serie',
                values: const [Colors.deepPurple, Colors.green]),
            // Lo nuevo aquí: ShapeEncode con `encoder`: la forma se decide
            // por tupla. dash: [6, 4] = 6 px de trazo y 4 px de hueco.
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
        // Igual que N02, pero con una línea: la Pokédex corre en vertical.
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
          // min: 0 porque el área se rellena desde el 0 de la escala.
          'hp': pokeNum((p) => p.hp, scale: LinearScale(min: 0)),
        },
        marks: [
          // Lo nuevo aquí: AreaMark = una línea rellena hasta el cero.
          // Color semitransparente (alpha 0.45) para que no sea un bloque.
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
            // Las áreas tienen su propia forma: BasicAreaShape. Con
            // smooth: true el borde superior es una curva (como N10).
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
    // Formato largo con solo las 3 primeras stats (HP, Ataque, Defensa).
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
          // max: 400 cubre la suma de las tres (Snorlax suma 335), por la
          // misma razón que en N05.
          'value': numVar('value', scale: LinearScale(min: 0, max: 400)),
          'stat': strVar('stat'),
        },
        marks: [
          AreaMark(
            position: Varset('dex') * Varset('value') / Varset('stat'),
            color: ColorEncode(
                variable: 'stat', values: kStatColors.take(3).toList()),
            // El mismo StackModifier de N05, ahora con áreas: cada banda
            // empieza donde termina la de abajo.
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
        // statsLong da filas con 'name'; aquí se copia cada fila ({...r})
        // y se le agrega 'dex' (el número de Pokédex como texto).
        data: statsLong(kPokes)
            .map((r) => {...r, 'dex': '#${pokeByName(r['name']).id}'})
            .toList(),
        variables: {
          'dex': strVar('dex', scale: OrdinalScale(tickCount: 8)),
          // Escala SIMÉTRICA, igual que el embudo A18: SymmetricModifier
          // centra cada columna en el 0 de la escala, así que el 0 tiene que
          // quedar en medio. La pila más alta suma 680 (Mewtwo), así que va
          // de −350 a 350. Sin esto, el río se salía del gráfico y se
          // recortaba (se vio al revisar la imagen renderizada).
          'value': numVar('value', scale: LinearScale(min: -350, max: 350)),
          'stat': strVar('stat'),
        },
        marks: [
          AreaMark(
            position: Varset('dex') * Varset('value') / Varset('stat'),
            shape: ShapeEncode(value: BasicAreaShape(smooth: true)),
            color: ColorEncode(variable: 'stat', values: kStatColors),
            // Lo nuevo aquí: los modificadores se aplican EN ORDEN.
            // 1) StackModifier apila las 6 bandas.
            // 2) SymmetricModifier mueve cada columna apilada para que su
            //    centro quede en el 0 de la escala: el río queda simétrico
            //    arriba y abajo (de ahí la forma de "río").
            modifiers: [StackModifier(), SymmetricModifier()],
          ),
        ],
        // Solo eje X: en un río el eje Y no tiene una lectura útil.
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
          // max: 520 deja aire sobre Snorlax (460 kg) y su curva suave.
          'weight': pokeNum((p) => p.weight, scale: LinearScale(min: 0, max: 520)),
        },
        // Dos marcas (como N12): un área muy tenue y una línea suave del
        // mismo color encima, que hace de borde.
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
            // Lo nuevo aquí: GradientEncode rellena con un degradado de
            // Flutter (LinearGradient) en vez de un color plano: morado
            // fuerte arriba que se desvanece hacia abajo.
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
