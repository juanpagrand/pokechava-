// ===========================================================================
// graphic_advanced_dynamic_charts.dart — AVANZADOS A09–A15 (DINÁMICOS)
// ===========================================================================
// Qué contiene: gráficos cuyos datos o especificación cambian en vivo.
//   A09 reordenar con animación (tag + Transition + entrance) ·
//   A10 cambiar el sistema de coordenadas · A11 cambiar la marca ·
//   A12 radar con selector de Pokémon · A13 datos en tiempo real (Timer) ·
//   A14 filtrar por tipo con chips · A15 absoluto vs. 100 % (Proportion
//   con nest).
// Todos son StatefulWidget: guardan una elección del usuario (o un Timer)
// y llaman a setState; al reconstruirse, Chart compara la especificación
// nueva con la vieja y redibuja (con animación si hay `transition`).
// Se asume todo lo de N01–N40 y A01–A08.
//
// Imports:
//   - dart:async → Timer (A13).
//   - dart:math (como math) → Random con semilla (A13).
//   - flutter/material.dart → ChoiceChip, FilterChip, DropdownButton,
//     FilledButton, Curves, etc.
//   - graphic/graphic.dart  → Chart, Transition, MarkEntrance, Coord,
//     Mark, LineAnnotation, Proportion…
//   - graphic_chart_card.dart / graphic_data.dart → tarjeta y datos/atajos.
//
// Quién lo importa: el barril charts_graphic.dart lo reexporta y
// graphic_charts_view.dart lo usa en la categoría "Dinámicos".
// ===========================================================================

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

import 'graphic_chart_card.dart';
import 'graphic_data.dart';

// Gráficos avanzados A09–A15: datos y especificación que cambian en vivo.

/// Botones compactos tipo "chips" de selección única.
// Widget auxiliar privado y GENÉRICO (<T>): sirve para opciones String
// (A09, A10, A11) y bool (A15). Recibe las opciones, la elegida, cómo
// mostrar cada una (`label`) y qué hacer al elegir (`onSelected`).
class _Choice<T> extends StatelessWidget {
  final List<T> options;
  final T selected;
  final String Function(T) label;
  final ValueChanged<T> onSelected;

  const _Choice({
    required this.options,
    required this.selected,
    required this.label,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Wrap: si no caben en una fila, los chips bajan a la siguiente.
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final o in options)
          ChoiceChip(
            label: Text(label(o), style: const TextStyle(fontSize: 12)),
            selected: o == selected,
            visualDensity: VisualDensity.compact,
            onSelected: (_) => onSelected(o),
          ),
      ],
    );
  }
}

/// A09: ordenar/barajar con transición animada.
class GraphicAdvanced09 extends StatefulWidget {
  const GraphicAdvanced09({super.key});

  @override
  State<GraphicAdvanced09> createState() => _GraphicAdvanced09State();
}

class _GraphicAdvanced09State extends State<GraphicAdvanced09> {
  static const _orders = ['Pokédex', 'Mayor ataque', 'Menor ataque', 'Al azar'];
  // Estado: el orden elegido y la lista ya ordenada.
  String _order = _orders.first;
  List<Poke> _data = kPokes.take(10).toList();

  // Ordena una COPIA de la lista y la guarda con setState. Una lista nueva
  // (otra instancia) hace que Chart detecte el cambio de datos.
  void _sort(String order) {
    final next = [..._data];
    switch (order) {
      case 'Pokédex':
        next.sort((a, b) => a.id.compareTo(b.id));
      case 'Mayor ataque':
        next.sort((a, b) => b.attack.compareTo(a.attack));
      case 'Menor ataque':
        next.sort((a, b) => a.attack.compareTo(b.attack));
      default:
        next.shuffle();
    }
    setState(() {
      _order = order;
      _data = next;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GraphicChartCard(
      code: 'A09',
      title: 'Reordenar con animación',
      description: 'tag + Transition: cada barra viaja a su nueva posición.',
      // Los chips van en `controls` (encima del gráfico).
      controls: _Choice<String>(
        options: _orders,
        selected: _order,
        label: (o) => o,
        onSelected: _sort,
      ),
      chart: Chart(
        data: _data,
        variables: {
          'name': pokeName(),
          // Escala fija 0–140: el eje no depende de los datos y queda
          // quieto mientras las barras se mueven.
          'attack': pokeNum((p) => p.attack, scale: LinearScale(min: 0, max: 140)),
        },
        marks: [
          IntervalMark(
            color: ColorEncode(value: Colors.redAccent),
            // Lo nuevo aquí: Transition = animación entre el dibujo viejo y
            // el nuevo cuando cambian los datos (700 ms, suave al empezar
            // y al terminar).
            transition: Transition(
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeInOut),
            // entrance: cómo aparecen la PRIMERA vez. MarkEntrance.y →
            // empiezan con altura 0 y crecen hacia arriba.
            entrance: {MarkEntrance.y},
            // tag: una "identidad" por barra (el nombre). graphic anima
            // entre elementos con el MISMO tag; así la barra de Mewtwo viaja
            // a su nuevo lugar. Sin tag empareja por posición en la lista y
            // las barras solo cambiarían de altura en su sitio.
            tag: (t) => t['name'] as String,
          ),
        ],
        axes: rectAxes(xRotation: -0.6),
      ),
    );
  }
}

/// A10: mismo dato, otro sistema de coordenadas.
class GraphicAdvanced10 extends StatefulWidget {
  const GraphicAdvanced10({super.key});

  @override
  State<GraphicAdvanced10> createState() => _GraphicAdvanced10State();
}

class _GraphicAdvanced10State extends State<GraphicAdvanced10> {
  static const _modes = ['Columnas', 'Barras', 'Rosa', 'Radial'];
  String _mode = _modes.first;

  // Lo nuevo aquí: el `coord` se elige con un switch (expresión de Dart 3)
  // según el modo. Coord es la clase base de RectCoord y PolarCoord.
  // Cada caso ya se vio: N02 (barras), N31 (rosa), N32 (radial), N01.
  Coord get _coord => switch (_mode) {
        'Barras' => RectCoord(transposed: true),
        'Rosa' => PolarCoord(startRadius: 0.1),
        'Radial' => PolarCoord(transposed: true, startRadius: 0.15),
        _ => RectCoord(),
      };

  @override
  Widget build(BuildContext context) {
    // En polar no sirven los ejes X/Y rectangulares.
    final polar = _mode == 'Rosa' || _mode == 'Radial';
    return GraphicChartCard(
      code: 'A10',
      title: 'Cambia el sistema de coordenadas',
      description:
          'Gramática de gráficos: datos y marca fijos; solo cambia coord.',
      controls: _Choice<String>(
        options: _modes,
        selected: _mode,
        label: (o) => o,
        onSelected: (m) => setState(() => _mode = m),
      ),
      chart: Chart(
        data: kGen1Types,
        variables: {
          'type': strVar('type'),
          'count': numVar('count', scale: LinearScale(min: 0)),
        },
        marks: [
          IntervalMark(
            // Defaults.colors10: paleta de 10 colores que trae graphic.
            color: ColorEncode(variable: 'type', values: Defaults.colors10),
            transition: Transition(duration: const Duration(milliseconds: 500)),
          ),
        ],
        // Lo único que cambia entre modos. Es la idea central de la
        // Gramática de Gráficos: el mismo dato y la misma marca dan
        // columnas, barras, rosa o barras radiales según la coordenada.
        coord: _coord,
        axes: polar ? [Defaults.circularAxis] : rectAxes(xRotation: -0.4),
      ),
    );
  }
}

/// A11: mismo dato, otra marca.
class GraphicAdvanced11 extends StatefulWidget {
  const GraphicAdvanced11({super.key});

  @override
  State<GraphicAdvanced11> createState() => _GraphicAdvanced11State();
}

class _GraphicAdvanced11State extends State<GraphicAdvanced11> {
  static const _marks = ['IntervalMark', 'LineMark', 'AreaMark', 'PointMark'];
  String _mark = _marks.first;

  // Lo nuevo aquí: la MARCA se elige con un switch. Mark es la clase base
  // de IntervalMark, LineMark, AreaMark y PointMark.
  Mark get _current {
    final color = ColorEncode(value: Colors.indigo);
    return switch (_mark) {
      'LineMark' => LineMark(
          color: color, shape: ShapeEncode(value: BasicLineShape(smooth: true))),
      'AreaMark' => AreaMark(
          color: ColorEncode(value: Colors.indigo.withValues(alpha: 0.4)),
          shape: ShapeEncode(value: BasicAreaShape(smooth: true))),
      'PointMark' => PointMark(color: color, size: SizeEncode(value: 10)),
      _ => IntervalMark(color: color),
    };
  }

  @override
  Widget build(BuildContext context) {
    return GraphicChartCard(
      code: 'A11',
      title: 'Cambia la marca geométrica',
      description: 'Mismas variables y ejes; IntervalMark, LineMark, AreaMark o PointMark.',
      controls: _Choice<String>(
        options: _marks,
        selected: _mark,
        // En el chip se muestra 'Interval', 'Line'… (sin la palabra Mark).
        label: (o) => o.replaceAll('Mark', ''),
        onSelected: (m) => setState(() => _mark = m),
      ),
      chart: Chart(
        data: kPokes.take(12).toList(),
        variables: {
          'name': Variable<Poke, String>(
            accessor: (Poke p) => p.name,
            // inflate solo para línea/área/puntos (de borde a borde, como
            // _byDex en N09). Para barras no: necesitan medio hueco a cada
            // lado o la primera y la última quedarían cortadas por el borde.
            scale: OrdinalScale(inflate: _mark != 'IntervalMark'),
          ),
          'speed': pokeNum((p) => p.speed, scale: LinearScale(min: 0)),
        },
        // Una lista con la marca elegida.
        marks: [_current],
        axes: rectAxes(xRotation: -0.6),
      ),
    );
  }
}

/// A12: radar con selector de Pokémon.
class GraphicAdvanced12 extends StatefulWidget {
  const GraphicAdvanced12({super.key});

  @override
  State<GraphicAdvanced12> createState() => _GraphicAdvanced12State();
}

class _GraphicAdvanced12State extends State<GraphicAdvanced12> {
  // Los dos Pokémon elegidos.
  String _a = 'Pikachu';
  String _b = 'Snorlax';

  // Lista desplegable con los 23 nombres; la línea inferior lleva el color
  // de su radar para saber qué selector controla qué figura.
  Widget _picker(String value, Color color, ValueChanged<String> onChanged) {
    return DropdownButton<String>(
      value: value,
      isDense: true,
      underline: Container(height: 2, color: color),
      items: [
        for (final p in kPokes)
          DropdownMenuItem(value: p.name, child: Text(p.name)),
      ],
      onChanged: (v) => onChanged(v!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GraphicChartCard(
      code: 'A12',
      title: 'Compara dos Pokémon en el radar',
      description: 'Cambiar el dato redibuja el polígono con transición.',
      height: 280,
      controls: Wrap(
        spacing: 16,
        children: [
          _picker(_a, Colors.amber.shade700, (v) => setState(() => _a = v)),
          _picker(_b, Colors.indigo, (v) => setState(() => _b = v)),
        ],
      ),
      chart: Chart(
        // Lo nuevo aquí: a cada fila se le agrega 'slot' = 'A' o 'B' según
        // el selector. Se agrupa por slot y no por nombre para que el
        // color quede atado al selector (ámbar = A, índigo = B) y la
        // transición anime "la figura A" aunque cambie el Pokémon.
        data: statsLong(pokesByName([_a, _b]))
            .map((r) => {...r, 'slot': r['name'] == _a ? 'A' : 'B'})
            .toList(),
        variables: {
          'stat': strVar('stat'),
          'value': numVar('value', scale: LinearScale(min: 0, max: 160)),
          'slot': strVar('slot'),
        },
        // Radar de N36 (área + línea con loop), con dos grupos como N37.
        marks: [
          AreaMark(
            position: Varset('stat') * Varset('value') / Varset('slot'),
            shape: ShapeEncode(value: BasicAreaShape(loop: true)),
            color: ColorEncode(variable: 'slot', values: [
              Colors.amber.withValues(alpha: 0.35),
              Colors.indigo.withValues(alpha: 0.3),
            ]),
            // Al cambiar de Pokémon, el polígono se deforma animado.
            transition: Transition(duration: const Duration(milliseconds: 600)),
          ),
          LineMark(
            position: Varset('stat') * Varset('value') / Varset('slot'),
            shape: ShapeEncode(value: BasicLineShape(loop: true)),
            color: ColorEncode(
                variable: 'slot', values: [Colors.amber.shade700, Colors.indigo]),
            transition: Transition(duration: const Duration(milliseconds: 600)),
          ),
        ],
        coord: PolarCoord(),
        axes: [Defaults.circularAxis, Defaults.radialAxis],
      ),
    );
  }
}

/// A13: datos en tiempo real.
class GraphicAdvanced13 extends StatefulWidget {
  const GraphicAdvanced13({super.key});

  @override
  State<GraphicAdvanced13> createState() => _GraphicAdvanced13State();
}

class _GraphicAdvanced13State extends State<GraphicAdvanced13> {
  // Random con semilla fija (25): la "batalla" es siempre la misma.
  final _random = math.Random(25);
  // Puntos visibles (máximo 30, como una ventana que se desliza).
  final List<Datum> _points = [];
  // El temporizador; `?` porque puede no existir (pausado).
  Timer? _timer;
  int _tick = 0;
  int _hp = 160;

  // initState se ejecuta una sola vez al crear el estado: genera 20
  // puntos iniciales (para no arrancar con el gráfico vacío) y arranca.
  @override
  void initState() {
    super.initState();
    for (var i = 0; i < 20; i++) {
      _step();
    }
    _start();
  }

  // Un paso de la simulación: avanza el turno, baja HP al azar (0–17),
  // cura 45 cada 9 turnos, lo limita a 0..160 y si llega a 0 revive.
  void _step() {
    _tick++;
    // Snorlax pierde HP con cada golpe y se cura de vez en cuando.
    _hp = (_hp - _random.nextInt(18) + (_tick % 9 == 0 ? 45 : 0)).clamp(0, 160);
    if (_hp == 0) _hp = 160;
    _points.add({'t': _tick, 'hp': _hp});
    // Ventana deslizante: se borra el punto más viejo.
    if (_points.length > 30) _points.removeAt(0);
  }

  // Lo nuevo aquí: Timer.periodic ejecuta la función cada 800 ms.
  // `mounted` es true mientras el widget sigue en pantalla: así nunca se
  // llama setState sobre un widget que ya se quitó (sería un error).
  // setState(_step) = ejecuta _step y redibuja.
  void _start() {
    _timer = Timer.periodic(const Duration(milliseconds: 800), (_) {
      if (mounted) setState(_step);
    });
  }

  // Al salir de pantalla se CANCELA el Timer. Si no, seguiría corriendo
  // para siempre en segundo plano (fuga de memoria). El test también
  // depende de esto: desmonta el widget para que no queden timers vivos.
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ¿Está corriendo? (decide el ícono y texto del botón).
    final running = _timer?.isActive ?? false;
    return GraphicChartCard(
      code: 'A13',
      title: 'Batalla en vivo: HP de Snorlax',
      description: 'Timer + setState: entra un punto nuevo cada 0,8 s (simulado).',
      controls: Row(
        children: [
          // Botón Pausar/Reanudar: cancela el Timer o crea uno nuevo.
          FilledButton.tonalIcon(
            onPressed: () => setState(() {
              if (running) {
                _timer?.cancel();
              } else {
                _start();
              }
            }),
            icon: Icon(running ? Icons.pause : Icons.play_arrow),
            label: Text(running ? 'Pausar' : 'Reanudar'),
          ),
          const SizedBox(width: 12),
          Text('HP actual: $_hp / 160',
              style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
      chart: Chart(
        // Por qué [..._points] (una copia) y no _points: la lista se
        // modifica "en el lugar" (add/removeAt), así que sigue siendo la
        // misma instancia. Chart solo recalcula los datos cuando recibe
        // OTRA instancia; la copia nueva en cada build fuerza el redibujo.
        data: [..._points],
        variables: {
          't': numVar('t'),
          // Escala fija 0–160 para que el eje no salte con cada punto.
          'hp': numVar('hp', scale: LinearScale(min: 0, max: 160)),
        },
        // Área con degradado (N21) + línea encima (N20).
        marks: [
          AreaMark(
            gradient: GradientEncode(
              value: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.green.withValues(alpha: 0.5),
                  Colors.green.withValues(alpha: 0.02),
                ],
              ),
            ),
          ),
          LineMark(color: ColorEncode(value: Colors.green.shade700)),
        ],
        // Lo nuevo aquí: `annotations`. LineAnnotation dibuja una línea
        // fija en un valor de datos: aquí HP = 40 (zona de peligro), roja
        // y punteada. dim: Dim.y → línea horizontal a esa altura.
        annotations: [
          LineAnnotation(
            dim: Dim.y,
            variable: 'hp',
            value: 40,
            style: PaintStyle(strokeColor: Colors.red, dash: [5, 4]),
          ),
        ],
        // Solo eje Y: los números de turno no aportan.
        axes: [yAxis()],
      ),
    );
  }
}

/// A14: filtrar por tipo con chips.
class GraphicAdvanced14 extends StatefulWidget {
  const GraphicAdvanced14({super.key});

  @override
  State<GraphicAdvanced14> createState() => _GraphicAdvanced14State();
}

class _GraphicAdvanced14State extends State<GraphicAdvanced14> {
  // Tipos marcados (un Set: sin repetidos). Empieza con los iniciales.
  final Set<String> _types = {'Planta', 'Fuego', 'Agua'};

  @override
  Widget build(BuildContext context) {
    // Los datos se filtran en Dart antes de pasarlos al gráfico.
    final data = kPokes.where((p) => _types.contains(p.type)).toList();
    return GraphicChartCard(
      code: 'A14',
      title: 'Filtra por tipo',
      description: 'FilterChip cambia los datos; las barras entran y salen animadas.',
      height: 240,
      controls: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [
          // FilterChip (multiselección, a diferencia de ChoiceChip).
          for (final t in kTypeColors.keys)
            FilterChip(
              label: Text(t, style: const TextStyle(fontSize: 11)),
              selected: _types.contains(t),
              selectedColor: kTypeColors[t]!.withValues(alpha: 0.3),
              visualDensity: VisualDensity.compact,
              onSelected: (on) => setState(() {
                on ? _types.add(t) : _types.remove(t);
              }),
            ),
        ],
      ),
      // Si no queda ningún tipo, se muestra un texto en vez del Chart:
      // así no se le pasa a graphic una lista vacía (sin datos no hay
      // categorías para el eje X) y el usuario sabe qué hacer.
      chart: data.isEmpty
          ? const Center(child: Text('Elige al menos un tipo'))
          : Chart(
              data: data,
              variables: {
                'name': pokeName(),
                'total': pokeNum((p) => p.total, scale: LinearScale(min: 0, max: 700)),
                'type': pokeType(),
              },
              marks: [
                IntervalMark(
                  color: typeColorFixed(),
                  transition: Transition(duration: const Duration(milliseconds: 500)),
                  // Como A09, pero las barras nuevas además aparecen desde
                  // transparente (opacity) mientras crecen (y).
                  entrance: {MarkEntrance.y, MarkEntrance.opacity},
                  tag: (t) => t['name'] as String,
                ),
              ],
              axes: rectAxes(xRotation: -0.6),
            ),
    );
  }
}

/// A15: absoluto vs. normalizado al 100 %.
class GraphicAdvanced15 extends StatefulWidget {
  const GraphicAdvanced15({super.key});

  @override
  State<GraphicAdvanced15> createState() => _GraphicAdvanced15State();
}

class _GraphicAdvanced15State extends State<GraphicAdvanced15> {
  bool _percent = false;

  @override
  Widget build(BuildContext context) {
    // Nombre de la variable que irá al eje Y según el modo.
    final y = _percent ? 'percent' : 'value';
    return GraphicChartCard(
      code: 'A15',
      title: 'Composición: absoluto o 100 %',
      description: 'Proportion(nest: Varset(name)) transforma cada columna a 100 %.',
      height: 280,
      // _Choice con opciones bool: false = Absoluto, true = 100 %.
      controls: _Choice<bool>(
        options: const [false, true],
        selected: _percent,
        label: (p) => p ? '100 %' : 'Absoluto',
        onSelected: (p) => setState(() => _percent = p),
      ),
      // Base: el apilado de N05.
      chart: Chart(
        data: statsLong(topBy((p) => p.total, 7)),
        variables: {
          'name': strVar('name'),
          'stat': strVar('stat'),
          'value': numVar('value', scale: LinearScale(min: 0, max: 700)),
        },
        transforms: [
          // Lo nuevo aquí: Proportion con `nest`. En N28 el porcentaje era
          // sobre el total de TODAS las filas; con nest: Varset('name') se
          // calcula DENTRO de cada Pokémon: cada stat / total de ese
          // Pokémon. Así cada columna apilada suma exactamente 1 (100 %).
          Proportion(
            variable: 'value',
            nest: Varset('name'),
            as: 'percent',
            // Escala 0 a 1; `formatter` muestra 0.25 como "25%" en el eje.
            scale: LinearScale(
              min: 0,
              max: 1,
              formatter: (v) => '${(v * 100).round()}%',
            ),
          ),
        ],
        marks: [
          IntervalMark(
            // Las dos variables existen siempre; solo cambia cuál va al
            // eje Y (`y`). La transición anima el paso de una a otra.
            position: Varset('name') * Varset(y) / Varset('stat'),
            color: ColorEncode(variable: 'stat', values: kStatColors),
            modifiers: [StackModifier()],
            transition: Transition(duration: const Duration(milliseconds: 600)),
          ),
        ],
        axes: rectAxes(xRotation: -0.5),
      ),
    );
  }
}
