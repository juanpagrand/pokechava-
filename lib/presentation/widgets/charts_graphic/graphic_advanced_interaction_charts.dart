// ===========================================================================
// graphic_advanced_interaction_charts.dart — AVANZADOS A01–A08 (INTERACCIÓN)
// ===========================================================================
// Qué contiene: gráficos que responden a gestos del usuario.
//   A01 tooltip + crosshair al tocar · A02 resaltar lo seleccionado ·
//   A03 aislar una serie + tooltip de varias series · A04 zoom y arrastre ·
//   A05 selección por recuadro (brush) · A06 tooltip dibujado a mano ·
//   A07 dos gráficos enlazados · A08 mapa de calor que responde al toque.
// Conceptos nuevos de este archivo:
//   - selections: "consultas" que se disparan con gestos (tocar, arrastrar)
//     y marcan tuplas como seleccionadas o no.
//   - updaters: cambian un encode (color, elevación…) según ese estado.
//   - guides interactivas: TooltipGuide y CrosshairGuide.
// Se asume todo lo de N01–N40.
//
// Imports:
//   - dart:async → StreamController (A07 comparte gestos entre gráficos).
//   - dart:math (como math) → sin/cos para simular datos en A04.
//   - flutter/material.dart → widgets, Colors, Rect, Offset, Size…
//   - graphic/graphic.dart  → Chart, PointSelection, IntervalSelection,
//     TooltipGuide, CrosshairGuide, GestureType, GestureEvent, Defaults,
//     y los elementos de dibujo (RectElement, LabelElement, MarkElement).
//   - graphic_chart_card.dart / graphic_data.dart → tarjeta y datos/atajos.
//
// Quién lo importa: el barril charts_graphic.dart lo reexporta y
// graphic_charts_view.dart lo usa en la categoría "Interacción".
// ===========================================================================

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

import 'graphic_chart_card.dart';
import 'graphic_data.dart';

// Gráficos avanzados A01–A08: interacción (selecciones, tooltips, zoom,
// gráficos enlazados).

/// A01: tooltip + crosshair al tocar.
class GraphicAdvanced01 extends StatelessWidget {
  const GraphicAdvanced01({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphicChartCard(
      code: 'A01',
      title: 'Toca una columna: tooltip y crosshair',
      description: 'PointSelection + TooltipGuide + CrosshairGuide.',
      // El gráfico base es igual a N01.
      chart: Chart(
        data: topBy((p) => p.spAtk, 10),
        variables: {
          'name': pokeName(),
          'spAtk': pokeNum((p) => p.spAtk, scale: LinearScale(min: 0)),
        },
        marks: [IntervalMark(color: ColorEncode(value: Colors.deepPurple))],
        axes: rectAxes(xRotation: -0.6),
        // Lo nuevo aquí: `selections` es un mapa nombre → selección.
        // PointSelection selecciona el dato más cercano al toque (por
        // defecto se activa con un toque y se borra con doble toque).
        // dim: Dim.x → solo compara la posición horizontal: basta tocar
        // en la columna, aunque sea arriba de la barra.
        selections: {'tap': PointSelection(dim: Dim.x)},
        // TooltipGuide: cuadro con los valores del dato seleccionado.
        tooltip: TooltipGuide(),
        // CrosshairGuide: líneas guía que cruzan el dato seleccionado.
        crosshair: CrosshairGuide(),
      ),
    );
  }
}

/// A02: resaltar lo seleccionado y atenuar el resto.
class GraphicAdvanced02 extends StatelessWidget {
  const GraphicAdvanced02({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphicChartCard(
      code: 'A02',
      title: 'Selección con resaltado',
      description:
          'updaters: lo no seleccionado baja su opacidad. Doble toque limpia.',
      chart: Chart(
        data: topBy((p) => p.total, 10),
        variables: {
          'name': pokeName(),
          'total': pokeNum((p) => p.total, scale: LinearScale(min: 0)),
          'type': pokeType(),
        },
        marks: [
          IntervalMark(
            color: ColorEncode(
              // Color por tipo (lo mismo que typeColorFixed, escrito aquí).
              encoder: (t) => kTypeColors[t['type']] ?? Colors.grey,
              // Lo nuevo aquí: `updaters`. Se lee así: "para la selección
              // 'tap', a las barras NO seleccionadas (false) cámbiales el
              // color a uno con 25 % de opacidad". Solo actúa mientras hay
              // una selección; sin selección todas se ven normales.
              updaters: {
                'tap': {false: (c) => c.withValues(alpha: 0.25)},
              },
            ),
            // ElevationEncode = sombra. Normalmente 0; las seleccionadas
            // (true) suben a 6 y "flotan".
            elevation: ElevationEncode(value: 0, updaters: {
              'tap': {true: (_) => 6},
            }),
          ),
        ],
        axes: rectAxes(xRotation: -0.6),
        // toggle: true → cada toque agrega o quita esa barra de la
        // selección (se pueden marcar varias). Doble toque borra todo.
        selections: {'tap': PointSelection(toggle: true)},
      ),
    );
  }
}

/// A03: resaltar una serie completa + tooltip con varias series.
class GraphicAdvanced03 extends StatelessWidget {
  const GraphicAdvanced03({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphicChartCard(
      code: 'A03',
      title: 'Tres perfiles opuestos: toca para aislar uno',
      description:
          'Selección por variable (toda la serie) + tooltip multiTuples al mantener o arrastrar.',
      chart: Chart(
        data: statsLong(pokesByName(['Snorlax', 'Alakazam', 'Onix'])),
        variables: {
          'stat': strVar('stat', scale: OrdinalScale(inflate: true)),
          'value': numVar('value', scale: LinearScale(min: 0, max: 170)),
          'name': strVar('name'),
        },
        marks: [
          // Tres líneas, como N11.
          LineMark(
            position: Varset('stat') * Varset('value') / Varset('name'),
            color: ColorEncode(
              variable: 'name',
              values: const [
                Color(0xFF9C9A6E),
                Color(0xFFE85584),
                Color(0xFFAF9A45),
              ],
              // Las líneas NO seleccionadas por 'serie' casi desaparecen.
              updaters: {
                'serie': {false: (c) => c.withValues(alpha: 0.15)},
              },
            ),
            size: SizeEncode(value: 3),
          ),
        ],
        axes: rectAxes(),
        // Lo nuevo aquí: DOS selecciones con gestos distintos.
        selections: {
          // variable: 'name' → al tocar un punto se seleccionan TODAS las
          // tuplas con el mismo nombre: la línea completa.
          'serie': PointSelection(variable: 'name'),
          // `on` elige los gestos que la activan (arrastrar o mantener
          // presionado) y `clear` el que la borra (soltar el dedo).
          'touch': PointSelection(
            on: {GestureType.scaleUpdate, GestureType.longPress},
            clear: {GestureType.scaleEnd},
            dim: Dim.x,
          ),
        },
        // El tooltip y el crosshair solo reaccionan a 'touch'.
        // multiTuples: true → muestra los 3 Pokémon de esa estadística
        // a la vez, una fila por tupla.
        tooltip: TooltipGuide(selections: {'touch'}, multiTuples: true),
        crosshair: CrosshairGuide(selections: {'touch'}),
      ),
    );
  }
}

/// Serie simulada de 120 turnos de combate (determinista).
// Determinista: usa sin/cos en vez de números al azar, así siempre da la
// misma curva. `.round()` deja el daño como entero. Cada 17 turnos hay un
// golpe crítico (+35).
final List<Datum> _battleTurns = [
  for (var i = 1; i <= 120; i++)
    {
      'turn': i,
      'damage': (40 +
              28 * math.sin(i / 6) +
              14 * math.cos(i / 2.3) +
              (i % 17 == 0 ? 35 : 0))
          .round(),
    },
];

/// A04: zoom y desplazamiento.
class GraphicAdvanced04 extends StatelessWidget {
  const GraphicAdvanced04({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphicChartCard(
      code: 'A04',
      title: 'Zoom y desplazamiento (120 turnos simulados)',
      description:
          'horizontalRangeUpdater: pellizca para zoom, arrastra para moverte.',
      chart: Chart(
        data: _battleTurns,
        variables: {
          // Aquí el eje X es numérico (turno 1 a 120), no una categoría.
          'turn': numVar('turn', scale: LinearScale(min: 1, max: 120)),
          'damage': numVar('damage', scale: LinearScale(min: 0)),
        },
        marks: [LineMark(color: ColorEncode(value: Colors.redAccent))],
        coord: RectCoord(
          // Lo nuevo aquí: horizontalRangeUpdater. Es una función que
          // cambia el rango horizontal visible según los gestos.
          // Defaults.horizontalRangeEvent ya viene hecha en graphic:
          //   - pellizcar con dos dedos (o la rueda del mouse) → zoom.
          //   - arrastrar con un dedo → desplaza.
          //   - doble toque → vuelve a la vista inicial.
          horizontalRangeUpdater: Defaults.horizontalRangeEvent,
        ),
        axes: rectAxes(),
      ),
    );
  }
}

/// A05: selección por intervalo (brush).
class GraphicAdvanced05 extends StatelessWidget {
  const GraphicAdvanced05({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphicChartCard(
      code: 'A05',
      title: 'Arrastra para encerrar un grupo de puntos',
      description: 'IntervalSelection: lo que queda fuera del recuadro se apaga.',
      chart: Chart(
        data: kPokes,
        variables: {
          'attack': pokeNum((p) => p.attack),
          'defense': pokeNum((p) => p.defense),
          'type': pokeType(),
        },
        marks: [
          PointMark(
            size: SizeEncode(value: 10),
            color: ColorEncode(
              encoder: (t) => kTypeColors[t['type']] ?? Colors.grey,
              // Los puntos fuera del recuadro quedan casi invisibles.
              updaters: {
                'brush': {false: (c) => c.withValues(alpha: 0.12)},
              },
            ),
          ),
        ],
        axes: rectAxes(),
        // Lo nuevo aquí: IntervalSelection. Al arrastrar se dibuja un
        // recuadro (color azul al 10 %) y se seleccionan los puntos que
        // quedan dentro. Doble toque lo borra.
        selections: {
          'brush': IntervalSelection(color: Colors.blue.withValues(alpha: 0.1)),
        },
      ),
    );
  }
}

/// A06: tooltip dibujado a medida.
class GraphicAdvanced06 extends StatelessWidget {
  const GraphicAdvanced06({super.key});

  // Lo nuevo aquí: un "renderer" propio para el tooltip. graphic lo llama
  // cada vez que hay una selección y dibuja lo que devuelve.
  //   size     → tamaño del gráfico.
  //   anchor   → punto en pantalla del dato seleccionado.
  //   selected → las tuplas seleccionadas (clave = índice del dato).
  // Devuelve una lista de MarkElement: figuras básicas de graphic.
  // `static` porque no usa nada de la instancia del widget.
  static List<MarkElement> _renderer(
      Size size, Offset anchor, Map<int, Tuple> selected) {
    // Toma la primera tupla seleccionada y busca el Poke completo por su
    // nombre, para mostrar datos que no son variables del gráfico.
    final t = selected.values.first;
    final p = pokeByName(t['name'] as String);
    final color = kTypeColors[p.type] ?? Colors.grey;
    // Rectángulo de la ficha: 150 × 64, centrado 52 px arriba del punto.
    final box = Rect.fromCenter(
      center: anchor.translate(0, -52),
      width: 150,
      height: 64,
    );
    return [
      // 1) Fondo oscuro redondeado con sombra (elevation).
      RectElement(
        rect: box,
        borderRadius: BorderRadius.circular(10),
        style: PaintStyle(fillColor: const Color(0xEE212121), elevation: 4),
      ),
      // 2) Franja de 6 px a la izquierda con el color del tipo.
      RectElement(
        rect: Rect.fromLTWH(box.left, box.top, 6, box.height),
        borderRadius: const BorderRadius.horizontal(left: Radius.circular(10)),
        style: PaintStyle(fillColor: color),
      ),
      // 3) Título: número y nombre. defaultAlign: bottomRight → el texto
      //    crece hacia abajo y a la derecha del ancla (el ancla es su
      //    esquina superior izquierda).
      LabelElement(
        text: '#${p.id} ${p.name}',
        anchor: box.topLeft.translate(14, 8),
        defaultAlign: Alignment.bottomRight,
        style: LabelStyle(
          textStyle: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ),
      // 4) Dos líneas de detalle (tipo, total y tres stats).
      LabelElement(
        text: '${p.type} · Total ${p.total}\n'
            'Atq ${p.attack}  Def ${p.defense}  Vel ${p.speed}',
        anchor: box.topLeft.translate(14, 28),
        defaultAlign: Alignment.bottomRight,
        style: LabelStyle(
          textStyle: const TextStyle(color: Colors.white70, fontSize: 10),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return GraphicChartCard(
      code: 'A06',
      title: 'Tooltip personalizado tipo ficha',
      description: 'TooltipGuide(renderer: …) dibuja la ficha con RectElement y LabelElement.',
      chart: Chart(
        data: kPokes,
        // 'name' y 'type' no van a los ejes: se necesitan en la tupla para
        // el renderer (nombre) y para el color (tipo).
        variables: {
          'height': pokeNum((p) => p.height),
          'exp': pokeNum((p) => p.baseExp),
          'name': pokeName(),
          'type': pokeType(),
        },
        marks: [PointMark(color: typeColorFixed(), size: SizeEncode(value: 11))],
        axes: rectAxes(),
        selections: {'tap': PointSelection()},
        // Se le pasa la función; graphic ignora entonces el estilo por
        // defecto del tooltip y usa lo que dibuja _renderer.
        tooltip: TooltipGuide(renderer: _renderer),
      ),
    );
  }
}

/// A07: dos gráficos enlazados por el mismo flujo de gestos.
// StatefulWidget porque tiene que crear y luego cerrar un recurso
// (el StreamController) durante la vida del widget.
class GraphicAdvanced07 extends StatefulWidget {
  const GraphicAdvanced07({super.key});

  @override
  State<GraphicAdvanced07> createState() => _GraphicAdvanced07State();
}

class _GraphicAdvanced07State extends State<GraphicAdvanced07> {
  // Lo nuevo aquí: un StreamController de GestureEvent compartido.
  // Cada Chart publica sus gestos en este stream y también escucha los del
  // otro: tocar uno equivale a tocar el otro en el mismo lugar.
  // `.broadcast()` es obligatorio: un stream normal admite UN solo oyente
  // y aquí hay dos gráficos escuchando.
  final _gestures = StreamController<GestureEvent>.broadcast();

  // dispose se llama cuando el widget sale de pantalla para siempre.
  // Se cierra el stream para liberarlo y que no queden oyentes colgados
  // (fuga de memoria).
  @override
  void dispose() {
    _gestures.close();
    super.dispose();
  }

  // Fábrica de un gráfico de barras: mismo esquema para ataque y defensa,
  // cambian el campo, la función que lo lee y el color.
  Chart<Poke> _chart(String field, num Function(Poke) f, Color color) {
    return Chart(
      // Mismos 12 Pokémon en el mismo orden en los dos gráficos, para que
      // el mismo toque caiga sobre el mismo Pokémon.
      data: kPokes.take(12).toList(),
      variables: {
        'name': pokeName(),
        field: pokeNum(f, scale: LinearScale(min: 0)),
      },
      marks: [
        IntervalMark(
          // Como A02: lo no seleccionado se atenúa.
          color: ColorEncode(value: color, updaters: {
            'tap': {false: (c) => c.withValues(alpha: 0.25)},
          }),
        ),
      ],
      // Solo eje Y para ahorrar espacio (son dos gráficos apilados).
      axes: [yAxis()],
      selections: {'tap': PointSelection(dim: Dim.x)},
      tooltip: TooltipGuide(),
      // Aquí se conecta el stream compartido.
      gestureStream: _gestures,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GraphicChartCard(
      code: 'A07',
      title: 'Gráficos enlazados: ataque arriba, defensa abajo',
      description:
          'Comparten gestureStream: tocar uno selecciona el mismo Pokémon en el otro.',
      height: 300,
      // El "chart" de la tarjeta es una Column con dos Chart; Expanded
      // reparte el alto en partes iguales.
      chart: Column(
        children: [
          Expanded(child: _chart('attack', (p) => p.attack, Colors.red)),
          const SizedBox(height: 8),
          Expanded(child: _chart('defense', (p) => p.defense, Colors.blue)),
        ],
      ),
    );
  }
}

/// A08: mapa de calor interactivo.
class GraphicAdvanced08 extends StatelessWidget {
  const GraphicAdvanced08({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphicChartCard(
      code: 'A08',
      title: 'Mapa de calor que responde al toque',
      description: 'PolygonMark + selección + tooltip con nombre, estadística y valor.',
      height: 320,
      // Mapa de calor como N39 (azul en vez de naranja) + interacción.
      chart: Chart(
        data: statsLong(kPokes.take(12).toList()),
        variables: {
          'name': strVar('name'),
          'stat': strVar('stat'),
          'value': numVar('value'),
        },
        marks: [
          PolygonMark(
            color: ColorEncode(
              variable: 'value',
              values: const [
                Color(0xFFE3F2FD),
                Color(0xFF42A5F5),
                Color(0xFF0D47A1),
              ],
              // Al tocar una celda, las demás se aclaran (35 %).
              updaters: {
                'tap': {false: (c) => c.withValues(alpha: 0.35)},
              },
            ),
          ),
        ],
        axes: rectAxes(xRotation: -0.5),
        selections: {'tap': PointSelection()},
        // Lo nuevo aquí: `variables` elige qué variables muestra el
        // tooltip y en qué orden.
        tooltip: TooltipGuide(variables: ['name', 'stat', 'value']),
      ),
    );
  }
}
