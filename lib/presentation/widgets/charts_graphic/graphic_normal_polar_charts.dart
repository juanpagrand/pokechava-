// ===========================================================================
// graphic_normal_polar_charts.dart — NORMALES N28–N38 (POLARES)
// ===========================================================================
// Qué contiene: gráficos en coordenadas POLARES (PolarCoord):
//   N28 torta · N29 dona · N30 media dona · N31 rosa (Nightingale) ·
//   N32 barras radiales · N33 torta con cantidades · N34 anillo delgado ·
//   N35 rosa apilada · N36 radar · N37 radar comparativo ·
//   N38 dispersión polar.
// Idea clave: en graphic una torta NO es un tipo de gráfico aparte. Es el
// mismo IntervalMark de las barras (N01) con otro sistema de coordenadas.
// Se asume lo de N01–N27; aquí solo se comenta lo nuevo.
//
// Imports:
//   - dart:math (como math) → math.pi para los ángulos.
//   - flutter/material.dart → widgets, Color, TextStyle, BorderRadius.
//   - graphic/graphic.dart  → Chart, PolarCoord, Proportion, Tuple,
//     Defaults (ejes polares ya hechos), marcas y encodes.
//   - graphic_chart_card.dart / graphic_data.dart → tarjeta y datos/atajos.
//
// Quién lo importa: el barril charts_graphic.dart lo reexporta y
// graphic_charts_view.dart lo usa en "Circulares" y "Radar y polar".
// ===========================================================================

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

import 'graphic_chart_card.dart';
import 'graphic_data.dart';

// Gráficos normales N28–N38: circulares, rosas y radares (PolarCoord).

// Paleta para los 8 tipos de kGen1Types, en el mismo orden de los datos
// (Agua, Normal, Veneno, Planta, Fuego, Bicho, Eléctrico, Otros).
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

// Las dos variables de las tortas (tipo y cantidad). Es una FUNCIÓN y no
// una constante para que cada Chart reciba sus propias Variable nuevas.
Map<String, Variable<Datum, dynamic>> _typeVars() => {
      'type': strVar('type'),
      'count': numVar('count'),
    };

// Etiqueta blanca en negrita, para escribir sobre los sectores de color.
Label _whiteLabel(String text, {double size = 10}) => Label(
      text,
      LabelStyle(
        textStyle: TextStyle(
            fontSize: size, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );

// Convierte la proporción de una tupla (0.186…) en texto ('18.6%').
// Tuple es el tipo de graphic para una fila ya procesada (un Map).
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
        // Lo nuevo aquí: `transforms`. Proportion calcula para cada fila
        // count / (suma de todos los count) y lo guarda en una variable
        // NUEVA llamada 'percent' (escala 0 a 1 por defecto). Así cada
        // sector mide su parte del total.
        transforms: [Proportion(variable: 'count', as: 'percent')],
        marks: [
          IntervalMark(
            // Solo UNA dimensión: 'percent' (no hay `*`). El `/ type`
            // separa un grupo por tipo, para poder apilarlos.
            position: Varset('percent') / Varset('type'),
            color: ColorEncode(variable: 'type', values: _typePalette),
            label: LabelEncode(encoder: (t) => _whiteLabel(t['type'] as String, size: 9)),
            // Apila los grupos: cada tipo empieza donde terminó el anterior,
            // y entre todos suman 1 (el 100 %).
            modifiers: [StackModifier()],
          ),
        ],
        // PolarCoord = coordenadas polares (ángulo y radio).
        //   dimCount: 1 → el plano tiene una sola dimensión (la medida,
        //     'percent'); no hay eje de categorías.
        //   transposed: true → esa medida va al ÁNGULO (no al radio).
        // Resultado: una barra apilada que se enrolla en un círculo = torta.
        // No se pasa `axes:`: una torta no lleva ejes.
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
            // Etiqueta con el porcentaje en vez del nombre.
            label: LabelEncode(encoder: (t) => _whiteLabel(_pct(t), size: 9)),
            modifiers: [StackModifier()],
          ),
        ],
        // Lo nuevo aquí: startRadius: 0.45 = el anillo empieza al 45 % del
        // radio; lo de adentro queda vacío.
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
          // Lo nuevo aquí: los ángulos (en radianes; 0 = a la derecha y
          // crecen en sentido horario). De -π (izquierda) a 0 (derecha)
          // pasando por arriba = media vuelta. El 100 % ocupa ese arco.
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
        // Sin Proportion: el valor es la cantidad, como en una barra.
        variables: {
          'type': strVar('type'),
          'count': numVar('count', scale: LinearScale(min: 0)),
        },
        marks: [
          IntervalMark(
            color: ColorEncode(variable: 'type', values: _typePalette),
            // En polar, RectShape dibuja sectores; borderRadius redondea
            // sus esquinas.
            shape: ShapeEncode(
                value: RectShape(
                    borderRadius: const BorderRadius.all(Radius.circular(6)))),
          ),
        ],
        // Lo nuevo aquí: PolarCoord SIN transponer y con 2 dimensiones:
        // la categoría (type) reparte el ÁNGULO en partes iguales y el
        // valor (count) es el RADIO. Es el gráfico N01 enrollado.
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
            // Grosor de cada anillo.
            size: SizeEncode(value: 10),
            label: LabelEncode(
                encoder: (t) => smallLabel('${t['name']} ${t['speed']}')),
          ),
        ],
        // Lo nuevo aquí: polar TRANSPUESTO con 2 dimensiones (al revés que
        // N31): el nombre elige el RADIO (un anillo por Pokémon) y la
        // velocidad es el ÁNGULO. El arco va del inicio por defecto
        // (-π/2, arriba) hasta π: tres cuartos de vuelta = velocidad 120.
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
    // Cuenta cuántos Pokémon de kPokes hay de cada tipo.
    final data = <Datum>[
      for (final t in kTypeColors.keys)
        {'type': t, 'count': kPokes.where((p) => p.type == t).length},
    ];
    return GraphicChartCard(
      code: 'N33',
      title: 'Tipos en nuestra muestra de 23',
      description: 'Torta con etiqueta "tipo: cantidad" en cada sector.',
      // Misma receta de torta que N28.
      chart: Chart(
        data: data,
        variables: _typeVars(),
        transforms: [Proportion(variable: 'count', as: 'percent')],
        marks: [
          IntervalMark(
            position: Varset('percent') / Varset('type'),
            // Aquí sí hay variable 'type', así que sirve el color fijo.
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
    // Una fila por estadística de Mewtwo.
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
        // Como N29, pero con startRadius: 0.7 el anillo queda delgado.
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
        // Exactamente las variables y la marca de N05 (max por el apilado).
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
        // Solo cambia coord: polar como N31 → cada columna apilada se
        // vuelve un "pétalo" apilado.
        coord: PolarCoord(startRadius: 0.1),
        // Lo nuevo aquí: Defaults.circularAxis, un eje ya armado por
        // graphic que escribe las categorías (nombres) alrededor del
        // círculo.
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
        // Un radar es un área + una línea (como N20), pero en polar: cada
        // estadística es un ángulo y su valor el radio.
        marks: [
          AreaMark(
            // Lo nuevo aquí: loop: true cierra la figura uniendo el último
            // punto (Velocidad) con el primero (HP).
            shape: ShapeEncode(value: BasicAreaShape(loop: true)),
            color: ColorEncode(value: Colors.deepOrange.withValues(alpha: 0.3)),
          ),
          LineMark(
            shape: ShapeEncode(value: BasicLineShape(loop: true)),
            color: ColorEncode(value: Colors.deepOrange),
          ),
        ],
        // Polar con valores por defecto: ángulo = stat, radio = value.
        coord: PolarCoord(),
        // Eje circular (nombres de stats alrededor) + eje radial (la
        // escala de 0 a 160 desde el centro, con sus anillos de guía).
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
            // Igual que las varias series de N11: `/ name` → un polígono
            // por Pokémon, cada uno cerrado con loop.
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
        // Los puntos de N24, ahora en polar: name → ángulo, exp → radio.
        marks: [PointMark(color: typeColorFixed(), size: SizeEncode(value: 9))],
        coord: PolarCoord(),
        // Solo el eje radial: 23 nombres alrededor no cabrían.
        axes: [Defaults.radialAxis],
      ),
    );
  }
}
