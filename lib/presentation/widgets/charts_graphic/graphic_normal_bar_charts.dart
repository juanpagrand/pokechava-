// ===========================================================================
// graphic_normal_bar_charts.dart — GRÁFICOS NORMALES N01–N08 (BARRAS)
// ===========================================================================
// Qué contiene: 8 widgets, uno por gráfico de barras/columnas:
//   N01 columnas simples          N05 columnas apiladas (StackModifier)
//   N02 barras horizontales       N06 barras horizontales apiladas
//   N03 columnas con etiqueta     N07 color por tipo (position explícito)
//   N04 agrupadas (DodgeModifier) N08 bordes redondeados + color condicional
// ESTE ARCHIVO ES EL PUNTO DE PARTIDA: N01 explica línea por línea cómo se
// arma un gráfico con graphic. Los demás archivos se apoyan en lo de aquí.
//
// La receta de graphic (Gramática de Gráficos), en orden:
//   data       → la lista de datos (aquí, Pokémon).
//   variables  → qué columnas se sacan de cada dato y con qué escala.
//   scale      → cómo un valor se convierte en posición (0 a 1).
//   marks      → la figura geométrica: barra, línea, punto, área…
//                con sus "encodes": color, tamaño, forma, etiqueta.
//   coord      → el sistema de coordenadas: rectangular o polar.
//   guides     → ejes (axes), tooltips, anotaciones.
//
// Imports:
//   - flutter/material.dart → StatelessWidget, Colors, BorderRadius…
//   - graphic/graphic.dart  → Chart, IntervalMark, ColorEncode, Varset,
//     LinearScale, RectCoord, modificadores… (paquete de pubspec.yaml).
//   - graphic_chart_card.dart → la tarjeta que envuelve cada gráfico.
//   - graphic_data.dart       → datos (kPokes, topBy…) y atajos
//     (pokeName, pokeNum, strVar, numVar, rectAxes…).
//
// Quién lo importa: el barril charts_graphic.dart lo reexporta y
// graphic_charts_view.dart lo usa en la categoría "Barras".
// ===========================================================================

import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

import 'graphic_chart_card.dart';
import 'graphic_data.dart';

// Gráficos normales N01–N08: barras y columnas con IntervalMark.

/// N01: columnas simples.
// Cada gráfico es un StatelessWidget: no cambia con el tiempo, solo dibuja.
class GraphicNormal01 extends StatelessWidget {
  // Constructor const: Flutter puede reutilizar la instancia.
  const GraphicNormal01({super.key});

  @override
  Widget build(BuildContext context) {
    // Todo gráfico se entrega dentro de la tarjeta común.
    return GraphicChartCard(
      code: 'N01',
      title: 'Top 10 por ataque base',
      description: 'Columnas: IntervalMark en coordenadas cartesianas.',
      // Chart es EL widget de graphic: recibe la especificación completa
      // y él se encarga de calcular y pintar.
      chart: Chart(
        // data: la lista de datos crudos. Aquí, los 10 Pokémon con más
        // ataque (lista de Poke). Puede ser una lista de cualquier tipo.
        data: topBy((p) => p.attack, 10),
        // variables: un mapa nombre → Variable. Cada Variable saca un valor
        // de cada Poke. Con estos valores graphic arma "tuplas" internas,
        // p. ej. {'name': 'Mewtwo', 'attack': 110}.
        variables: {
          // Variable de texto → escala ordinal (categorías): eje X.
          'name': pokeName(),
          // Variable numérica → eje Y. LinearScale(min: 0) obliga a que la
          // escala empiece en 0. Sin esto graphic usaría
          // (mínimo de los datos − 10 %) y la base de las barras quedaría
          // debajo del área visible: las barras se verían más distintas de
          // lo que son.
          'attack': pokeNum((p) => p.attack, scale: LinearScale(min: 0)),
        },
        // marks: la(s) figura(s) que se dibujan. IntervalMark = barra que
        // va desde el 0 de la escala hasta el valor. Como no se da
        // `position:`, graphic cruza las dos primeras variables:
        // name (X) × attack (Y).
        // ColorEncode(value: …) = el mismo color para todas las barras.
        marks: [IntervalMark(color: ColorEncode(value: Colors.redAccent))],
        // axes: las guías de los ejes X e Y (atajo de graphic_data.dart),
        // con las etiquetas del eje X giradas -0.6 rad para que quepan.
        // No se pasa `coord:`, así que se usa RectCoord (cartesiano).
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
      // Más alto que el normal (260) para que quepan 10 nombres en vertical.
      height: 300,
      chart: Chart(
        // `.reversed`: al transponer, el primer dato queda abajo; se invierte
        // para que el de más HP salga arriba.
        data: topBy((p) => p.hp, 10).reversed.toList(),
        // Igual que N01: una categoría y un número que empieza en 0.
        variables: {
          'name': pokeName(),
          'hp': pokeNum((p) => p.hp, scale: LinearScale(min: 0)),
        },
        marks: [IntervalMark(color: ColorEncode(value: Colors.green))],
        // Lo nuevo aquí: coord. RectCoord es el plano cartesiano;
        // transposed: true intercambia los ejes: las categorías van en
        // vertical y los valores en horizontal. Los datos y la marca no
        // cambian; solo el sistema de coordenadas.
        coord: RectCoord(transposed: true),
        // Los ejes siguen siendo Dim.x (nombres) y Dim.y (valores): graphic
        // los dibuja girados porque la coordenada está transpuesta.
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
          // max: 150 deja aire arriba de la barra más alta para la etiqueta.
          'speed': pokeNum((p) => p.speed, scale: LinearScale(min: 0, max: 150)),
        },
        marks: [
          IntervalMark(
            color: ColorEncode(value: Colors.pinkAccent),
            // Lo nuevo aquí: LabelEncode. `encoder` recibe la tupla `t` de
            // cada barra y devuelve el Label a escribir. Se lee por el
            // NOMBRE DE LA VARIABLE ('speed'), no por el campo del Poke.
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
    // Datos en formato largo: DOS filas por Pokémon (una de ataque y otra
    // de defensa) con una columna 'stat' que dice cuál es cuál.
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
        // Como data es List<Datum> (mapas), se usan strVar/numVar en vez de
        // pokeName/pokeNum.
        variables: {
          'name': strVar('name'),
          'stat': strVar('stat'),
          'value': numVar('value', scale: LinearScale(min: 0)),
        },
        marks: [
          IntervalMark(
            // Lo nuevo aquí: `position` con el álgebra de Varset.
            //   *  (cruce) → manda cada lado a una dimensión:
            //               name al eje X, value al eje Y.
            //   /  (anidar) → separa las filas en GRUPOS según 'stat':
            //               un grupo "Ataque" y otro "Defensa".
            // Sin el `/` las dos barras de un Pokémon caerían en el mismo
            // lugar, una encima de la otra.
            position: Varset('name') * Varset('value') / Varset('stat'),
            // Color según la variable 'stat': 1.er valor que aparece
            // (Ataque) → rojo, 2.º (Defensa) → azul.
            color: ColorEncode(
                variable: 'stat', values: const [Colors.red, Colors.blue]),
            // DodgeModifier ("esquivar"): mueve cada grupo un poco hacia un
            // lado para que queden lado a lado. ratio 0.12 = cuánto se
            // corre cada grupo, como fracción del ancho de cada categoría.
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
        // statsLong: 6 filas por Pokémon (una por estadística).
        data: statsLong(topBy((p) => p.total, 7)),
        variables: {
          'name': strVar('name'),
          'stat': strVar('stat'),
          // Por qué max: 700. graphic calcula la escala con los valores de
          // CADA FILA (una stat sola, máx. 160), pero el apilado suma las 6
          // stats (Mewtwo llega a 680). Sin un max que cubra la suma, las
          // columnas pasarían el borde superior y graphic las recortaría.
          'value': numVar('value', scale: LinearScale(min: 0, max: 700)),
        },
        marks: [
          IntervalMark(
            // Mismo álgebra que N04: nombre × valor, agrupado por 'stat'.
            position: Varset('name') * Varset('value') / Varset('stat'),
            // Un color por estadística (6 colores, uno por grupo).
            color: ColorEncode(variable: 'stat', values: kStatColors),
            // Lo nuevo aquí: StackModifier ("apilar"). En vez de ponerlos
            // lado a lado (Dodge), pone cada grupo ENCIMA del anterior:
            // HP abajo, luego Ataque, etc. La altura total = suma.
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
      // Combina dos ideas ya vistas: apilado (N05) + transpuesto (N02).
      chart: Chart(
        data: statsLong(pokesByName(['Venusaur', 'Charizard', 'Blastoise'])),
        variables: {
          'name': strVar('name'),
          'stat': strVar('stat'),
          // max: 600 porque los totales de estos tres rondan 525–534.
          'value': numVar('value', scale: LinearScale(min: 0, max: 600)),
        },
        marks: [
          IntervalMark(
            position: Varset('name') * Varset('value') / Varset('stat'),
            color: ColorEncode(variable: 'stat', values: kStatColors),
            modifiers: [StackModifier()],
            // Lo nuevo aquí: SizeEncode fija el grosor de la barra en
            // píxeles (por defecto IntervalMark usa 15).
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
        // topBy pide un int, por eso se redondea el peso (double).
        data: topBy((p) => p.weight.round(), 10),
        // Tres variables: 'type' solo se usa para el color.
        variables: {
          'name': pokeName(),
          'type': pokeType(),
          'weight': pokeNum((p) => p.weight, scale: LinearScale(min: 0)),
        },
        marks: [
          IntervalMark(
            // Lo nuevo aquí: por qué `position` es explícito. Si no se da,
            // graphic cruza las DOS PRIMERAS variables del mapa: aquí serían
            // name × type, y el tipo (un texto) terminaría en el eje Y por
            // error. Se le dice claramente: name en X, weight en Y.
            position: Varset('name') * Varset('weight'),
            // Color buscado por nombre de tipo (ver graphic_data.dart): el
            // agua siempre es azul, sin importar el orden de los datos.
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
        // Los primeros 12 de kPokes (orden de Pokédex).
        data: kPokes.take(12).toList(),
        variables: {
          'name': pokeName(),
          'defense': pokeNum((p) => p.defense, scale: LinearScale(min: 0)),
        },
        marks: [
          IntervalMark(
            // Lo nuevo aquí: ShapeEncode cambia la FORMA de la marca.
            // RectShape es la forma normal de una barra; aquí se le
            // redondean solo las esquinas de arriba.
            shape: ShapeEncode(
              value: RectShape(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(6))),
            ),
            // ColorEncode con `encoder`: una función decide el color de
            // cada barra mirando su tupla (rojo si defensa ≥ 100).
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
