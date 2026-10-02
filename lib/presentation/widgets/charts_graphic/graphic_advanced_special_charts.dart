// ===========================================================================
// graphic_advanced_special_charts.dart — AVANZADOS A16–A25 (FORMAS Y
// COMPOSICIÓN)
// ===========================================================================
// Qué contiene:
//   A16 velas japonesas (CustomMark + CandlestickShape) ·
//   A17 barras flotantes de rango (blend `+`) · A18 embudo · A19 pirámide ·
//   A20 anotaciones (línea, zona y etiquetas) · A21 doble eje Y ·
//   A22 forma propia: LollipopShape (piruleta) · A23 medidor (gauge) ·
//   A24 barras divergentes · A25 pequeños múltiplos (9 Chart en grilla).
// Se asume todo lo de N01–N40 y A01–A15.
//
// Imports:
//   - dart:math (como math) → sin, max, min y pi.
//   - flutter/material.dart → widgets, Colors, GridView, Alignment…
//   - graphic/graphic.dart  → Chart, CustomMark, CandlestickShape,
//     FunnelShape, SymmetricModifier, annotations, IntervalShape (para la
//     forma propia), elementos de dibujo (GroupElement, PolylineElement,
//     CircleElement, LabelElement), Attributes, CoordConv…
//   - graphic_chart_card.dart / graphic_data.dart → tarjeta y datos/atajos.
//
// Quién lo importa: el barril charts_graphic.dart lo reexporta y
// graphic_charts_view.dart lo usa en "Formas y composición".
// ===========================================================================

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

import 'graphic_chart_card.dart';
import 'graphic_data.dart';

// Gráficos avanzados A16–A25: formas especiales, anotaciones y composición.

/// Precio de cierre de una carta de Charizard (datos de ejemplo, 20 días).
// Se arma con una función que se ejecuta de inmediato: `() { … }()`.
// Cada día abre donde cerró el anterior; el cierre sube o baja con un
// seno (determinista, sin azar); máximo y mínimo quedan un poco por
// encima/debajo de apertura y cierre, como en una vela real.
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
    // Las 4 variables de precio comparten el MISMO eje Y, así que deben
    // tener la misma escala (260–380). Si cada una calculara la suya,
    // un mismo precio quedaría a alturas distintas. Se usa una función
    // para crear una escala con esa configuración para cada variable.
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
          // Lo nuevo aquí: CustomMark, una marca "sin reglas" que no
          // completa ni revisa los puntos: dibuja lo que diga su forma.
          CustomMark(
            // CandlestickShape: forma de vela que trae graphic. Espera 4
            // valores en Y en este orden: [inicio, fin, máximo, mínimo].
            // hollow: false → cuerpo relleno.
            shape: ShapeEncode(value: CandlestickShape(hollow: false)),
            // Lo nuevo aquí: el operador `+` (blend, "mezcla") pone varias
            // variables en la MISMA dimensión. Se lee: día en X; en Y, los
            // 4 valores open, close, high, low (el orden que pide la vela).
            position: Varset('day') *
                (Varset('open') + Varset('close') + Varset('high') + Varset('low')),
            // Verde si cerró arriba de la apertura (subió), rojo si bajó.
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
    // Para cada uno de los 10 con más total: su peor y su mejor stat.
    // reduce(math.min) recorre la lista quedándose con el menor.
    final data = <Datum>[
      for (final p in topBy((p) => p.total, 10))
        {
          'name': p.name,
          'min': p.stats.reduce(math.min),
          'max': p.stats.reduce(math.max),
        },
    ];
    // Misma escala para min y max (comparten eje), como en A16.
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
            // Blend (`+`, visto en A16) con dos valores: un IntervalMark
            // con [inicio, fin] ya no arranca en 0, sino que va de 'min'
            // a 'max'. Por eso la barra "flota".
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

// Datos de ejemplo para el embudo: ya vienen ordenados de mayor a menor
// (FunnelShape no ordena; si no lo estuvieran, el embudo saldría raro).
const List<Datum> _trainerFunnel = [
  {'stage': 'Vieron un Pokémon', 'value': 1000},
  {'stage': 'Lanzaron Poké Ball', 'value': 720},
  {'stage': 'Lo atraparon', 'value': 430},
  {'stage': 'Lo evolucionaron', 'value': 190},
  {'stage': 'Llegaron a nivel 100', 'value': 45},
];

// Función que arma el Chart del embudo; A18 y A19 la usan y solo cambian
// `pyramid`. Así no se repite el código.
Chart<Datum> _funnel({required bool pyramid}) => Chart(
      data: _trainerFunnel,
      variables: {
        'stage': strVar('stage'),
        // SymmetricModifier centra en el cero: la escala debe ser simétrica.
        // Explicación: SymmetricModifier mueve cada barra para que su
        // centro quede donde está el 0 de la escala. Con -1000..1000 el 0
        // queda justo en el medio del ancho, y el embudo sale centrado.
        // Con 0..1000 el 0 estaría en el borde y medio embudo quedaría
        // fuera del área (recortado).
        'value': numVar('value', scale: LinearScale(min: -1000, max: 1000)),
      },
      marks: [
        IntervalMark(
          // FunnelShape: une cada barra con la siguiente como un embudo.
          // pyramid: true → la última termina en punta.
          shape: ShapeEncode(value: FunnelShape(pyramid: pyramid)),
          // Del azul más oscuro (arriba) al más claro (abajo).
          color: ColorEncode(variable: 'stage', values: const [
            Color(0xFF1565C0),
            Color(0xFF1E88E5),
            Color(0xFF42A5F5),
            Color(0xFF90CAF9),
            Color(0xFFBBDEFB),
          ]),
          // Etiqueta "etapa: valor" en cada tramo.
          label: LabelEncode(
            encoder: (t) => Label(
              '${t['stage']}: ${t['value']}',
              LabelStyle(
                textStyle: const TextStyle(fontSize: 10, color: Color(0xFF0D2440)),
              ),
            ),
          ),
          // Lo nuevo aquí (ya asomó en N19): centra cada barra en el 0.
          modifiers: [SymmetricModifier()],
        ),
      ],
      // transposed: true → las etapas van en vertical y el valor es el
      // ANCHO. verticalRange: [1, 0] invierte el eje vertical (que por
      // defecto crece de abajo hacia arriba) para que la 1.ª etapa quede
      // ARRIBA y el embudo se lea de arriba abajo. Sin ejes: no aportan.
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
      // Mismo Chart que A18, cambiando solo la forma.
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
    // Promedio de ataque de esos 10, calculado en Dart.
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
        // Lo nuevo aquí: tres tipos de anotación, todas ubicadas con
        // VALORES DE DATOS (no con píxeles), así se mueven con la escala.
        annotations: [
          // Franja de fondo entre ataque 120 y 150: la "zona élite".
          RegionAnnotation(
            dim: Dim.y,
            variable: 'attack',
            values: const [120, 150],
            color: Colors.amber.withValues(alpha: 0.18),
          ),
          // Línea horizontal punteada en el promedio (como en A13).
          LineAnnotation(
            dim: Dim.y,
            variable: 'attack',
            value: avg,
            style: PaintStyle(strokeColor: Colors.red, strokeWidth: 1.5, dash: [6, 4]),
          ),
          // TagAnnotation: un texto puesto en un punto de datos.
          // Aquí (último Pokémon, promedio): el texto queda al final de la
          // línea roja. align: topRight → arriba y a la derecha del punto.
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
          // Otro texto sobre la barra más alta (el récord), centrado
          // arriba y 4 px más alto con offset.
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
        // Dos variables numéricas con escalas MUY distintas (kg y metros),
        // cada una con su propia escala.
        variables: {
          'name': pokeName(),
          'weight': pokeNum((p) => p.weight, scale: LinearScale(min: 0, max: 500)),
          'height': pokeNum((p) => p.height, scale: LinearScale(min: 0, max: 10)),
        },
        // Lo nuevo aquí: cada marca usa su propio `position` con una
        // variable Y diferente: barras de peso, línea y puntos de altura.
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
          // Eje Y izquierdo, atado a 'weight' (con cuadrícula).
          AxisGuide(
            dim: Dim.y,
            variable: 'weight',
            label: LabelStyle(
              textStyle: const TextStyle(fontSize: 10, color: Color(0xFF607D8B)),
              offset: const Offset(-7.5, 0),
            ),
            grid: Defaults.strokeStyle,
          ),
          // Eje Y derecho, atado a 'height'. position: 1 → la línea del
          // eje va en el borde derecho (0 = izquierdo). flip: true → las
          // etiquetas pasan al otro lado (afuera, a la derecha). Color
          // naranja para que se asocie con la línea.
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
// Lo nuevo aquí: crear una FORMA propia. Se extiende IntervalShape (la
// familia de formas de IntervalMark), así que se puede usar dentro de un
// IntervalMark normal y graphic le entrega cada barra ya calculada.
class LollipopShape extends IntervalShape {
  LollipopShape({this.radius = 7});

  // Radio del círculo de la punta, en píxeles.
  final double radius;

  // Método 1: drawGroupPrimitives → dibuja las figuras de un grupo de
  // barras. Recibe:
  //   group  → los "Attributes" de cada barra (posición, color, tag…).
  //   coord  → convierte posiciones abstractas (0 a 1) a píxeles.
  //   origin → posición del origen (no se usa aquí).
  // Devuelve la lista de elementos a pintar.
  @override
  List<MarkElement> drawGroupPrimitives(
      List<Attributes> group, CoordConv coord, Offset origin) {
    final rst = <MarkElement>[];
    for (final item in group) {
      // Si algún punto no es un número válido (NaN/infinito), se salta.
      if (item.position.any((p) => !p.dy.isFinite)) continue;
      // Estilo (color, sombra…) que graphic calculó para esta barra con
      // los encodes del IntervalMark (aquí, typeColorFixed).
      final style = getPaintStyle(item, false, 0, null, null);
      // En un IntervalMark cada barra trae 2 puntos: [base, punta].
      final base = coord.convert(item.position[0]);
      final tip = coord.convert(item.position[1]);
      // GroupElement junta la línea y el círculo como UNA pieza; el `tag`
      // permite que se animen juntos.
      rst.add(GroupElement(
        elements: [
          // El "palito": línea de la base a la punta, del color de la barra.
          PolylineElement(
            points: [base, tip],
            style: PaintStyle(strokeColor: style.fillColor, strokeWidth: 2.5),
          ),
          // El "dulce": círculo relleno en la punta.
          CircleElement(center: tip, radius: radius, style: style),
        ],
        tag: item.tag,
      ));
    }
    return rst;
  }

  // Método 2: drawGroupLabels → dibuja las etiquetas (LabelEncode).
  // Se sobrescribe para poner el texto ENCIMA del círculo (radio + 2 px
  // más arriba de la punta) y no tapado por él.
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

  // Método 3: equalTo → cuándo dos formas son "iguales". graphic compara
  // la especificación vieja con la nueva para decidir si redibuja; dos
  // piruletas son iguales si tienen el mismo radio.
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
          // Un IntervalMark normal (como N03), solo que con la forma propia.
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
    // Truco del medidor: dos sectores, la velocidad y "lo que falta"
    // hasta 160. Juntos forman la media dona completa.
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
      // La media dona de N30 con dos sectores.
      chart: Chart(
        data: data,
        variables: {'part': strVar('part'), 'value': numVar('value')},
        transforms: [Proportion(variable: 'value', as: 'percent')],
        marks: [
          IntervalMark(
            position: Varset('percent') / Varset('part'),
            // "Resto" en gris tenue; la velocidad en verde si ≥ 100, si no
            // naranja.
            color: ColorEncode(
              encoder: (t) => t['part'] == 'Resto'
                  ? Colors.grey.withValues(alpha: 0.2)
                  : (p.speed >= 100 ? Colors.green : Colors.orange),
            ),
            modifiers: [StackModifier()],
            // Al cambiar de Pokémon, el sector de color crece o se achica
            // animado.
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
          // TagAnnotation con `anchor`: aquí la posición se da en PÍXELES
          // con una función del tamaño del gráfico (no con datos como en
          // A20): el número grande va en el centro, 6 px arriba.
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
    // Diferencia ataque − defensa de los 23, ordenada de menor a mayor.
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
          // Lo nuevo aquí: la escala incluye negativos (-120 a 60). Como
          // IntervalMark nace en el 0 de la escala, las barras negativas
          // van hacia un lado y las positivas hacia el otro.
          'diff': numVar('diff', scale: LinearScale(min: -120, max: 60)),
        },
        marks: [
          IntervalMark(
            // Rojo = más ataque (ofensivo); azul = más defensa.
            color: ColorEncode(
              encoder: (t) =>
                  (t['diff'] as num) >= 0 ? Colors.redAccent : Colors.blueAccent,
            ),
          ),
        ],
        // Horizontal (N02) para que quepan los 23 nombres.
        coord: RectCoord(transposed: true),
        // Línea gris en el cero para marcar dónde cambia el signo.
        // Dim.y es la dimensión del valor (se ve vertical por la
        // transposición).
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

  // Un minigráfico: nombre y total arriba, y debajo un Chart sin ejes con
  // el perfil de stats (área + línea del color de su tipo).
  Widget _mini(Poke p) {
    final color = kTypeColors[p.type] ?? Colors.grey;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${p.name} · ${p.total}',
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
        // El Chart toma el alto que sobra en la celda.
        Expanded(
          child: Chart(
            data: statsLong([p]),
            variables: {
              'stat': strVar('stat', scale: OrdinalScale(inflate: true)),
              // La MISMA escala (0–160) en los nueve: así las alturas se
              // pueden comparar entre minigráficos.
              'value': numVar('value', scale: LinearScale(min: 0, max: 160)),
            },
            marks: [
              AreaMark(color: ColorEncode(value: color.withValues(alpha: 0.3))),
              LineMark(color: ColorEncode(value: color)),
            ],
            // Lo nuevo aquí: `padding` (espacio entre el borde del widget
            // y el área de dibujo). El de por defecto deja lugar para ejes;
            // como aquí no hay ejes, se achica a casi nada.
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
      // Grilla de 3 columnas con un minigráfico en cada celda.
      chart: GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.25,
        // La grilla no se desplaza sola: la tarjeta ya está dentro del
        // ListView de la vista, y dos scrolls anidados chocarían.
        physics: const NeverScrollableScrollPhysics(),
        children: [for (final p in picks) _mini(p)],
      ),
    );
  }
}
