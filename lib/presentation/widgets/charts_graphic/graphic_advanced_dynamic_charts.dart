// Gráficos avanzados A09–A15: cambian en vivo (setState, Timer, animación).

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

import 'graphic_chart_card.dart';
import 'graphic_data.dart';

/// Botones compactos tipo "chips" de selección única.
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
  String _order = _orders.first;
  List<Poke> _data = kPokes.take(10).toList();

  void _sort(String order) {
    // copia nueva para que el Chart note el cambio
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
          // escala fija para que el eje no se mueva
          'attack': pokeNum((p) => p.attack, scale: LinearScale(min: 0, max: 140)),
        },
        marks: [
          IntervalMark(
            color: ColorEncode(value: Colors.redAccent),
            // animación al cambiar los datos
            transition: Transition(
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeInOut),
            entrance: {MarkEntrance.y},
            // tag para que cada barra viaje a su nuevo lugar
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

  Coord get _coord => switch (_mode) {
        'Barras' => RectCoord(transposed: true),
        'Rosa' => PolarCoord(startRadius: 0.1),
        'Radial' => PolarCoord(transposed: true, startRadius: 0.15),
        _ => RectCoord(),
      };

  @override
  Widget build(BuildContext context) {
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
            color: ColorEncode(variable: 'type', values: Defaults.colors10),
            transition: Transition(duration: const Duration(milliseconds: 500)),
          ),
        ],
        // solo cambia coord
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
        label: (o) => o.replaceAll('Mark', ''),
        onSelected: (m) => setState(() => _mark = m),
      ),
      chart: Chart(
        data: kPokes.take(12).toList(),
        variables: {
          'name': Variable<Poke, String>(
            accessor: (Poke p) => p.name,
            // inflate solo si no son barras
            scale: OrdinalScale(inflate: _mark != 'IntervalMark'),
          ),
          'speed': pokeNum((p) => p.speed, scale: LinearScale(min: 0)),
        },
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
  String _a = 'Pikachu';
  String _b = 'Snorlax';

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
        // slot A/B para que el color siga al selector
        data: statsLong(pokesByName([_a, _b]))
            .map((r) => {...r, 'slot': r['name'] == _a ? 'A' : 'B'})
            .toList(),
        variables: {
          'stat': strVar('stat'),
          'value': numVar('value', scale: LinearScale(min: 0, max: 160)),
          'slot': strVar('slot'),
        },
        marks: [
          AreaMark(
            position: Varset('stat') * Varset('value') / Varset('slot'),
            shape: ShapeEncode(value: BasicAreaShape(loop: true)),
            color: ColorEncode(variable: 'slot', values: [
              Colors.amber.withValues(alpha: 0.35),
              Colors.indigo.withValues(alpha: 0.3),
            ]),
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
  // semilla fija
  final _random = math.Random(25);
  final List<Datum> _points = [];
  Timer? _timer;
  int _tick = 0;
  int _hp = 160;

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < 20; i++) {
      _step();
    }
    _start();
  }

  void _step() {
    _tick++;
    _hp = (_hp - _random.nextInt(18) + (_tick % 9 == 0 ? 45 : 0)).clamp(0, 160);
    if (_hp == 0) _hp = 160;
    _points.add({'t': _tick, 'hp': _hp});
    if (_points.length > 30) _points.removeAt(0);
  }

  void _start() {
    // mounted para no hacer setState si ya se quitó
    _timer = Timer.periodic(const Duration(milliseconds: 800), (_) {
      if (mounted) setState(_step);
    });
  }

  // cancelar el timer al salir, si no sigue corriendo
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final running = _timer?.isActive ?? false;
    return GraphicChartCard(
      code: 'A13',
      title: 'Batalla en vivo: HP de Snorlax',
      description: 'Timer + setState: entra un punto nuevo cada 0,8 s (simulado).',
      controls: Row(
        children: [
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
        // copia: la lista se modifica en el lugar
        data: [..._points],
        variables: {
          't': numVar('t'),
          'hp': numVar('hp', scale: LinearScale(min: 0, max: 160)),
        },
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
        // línea de peligro en HP 40
        annotations: [
          LineAnnotation(
            dim: Dim.y,
            variable: 'hp',
            value: 40,
            style: PaintStyle(strokeColor: Colors.red, dash: [5, 4]),
          ),
        ],
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
  final Set<String> _types = {'Planta', 'Fuego', 'Agua'};

  @override
  Widget build(BuildContext context) {
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
      // sin datos se muestra un texto en vez del Chart
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
    final y = _percent ? 'percent' : 'value';
    return GraphicChartCard(
      code: 'A15',
      title: 'Composición: absoluto o 100 %',
      description: 'Proportion(nest: Varset(name)) transforma cada columna a 100 %.',
      height: 280,
      controls: _Choice<bool>(
        options: const [false, true],
        selected: _percent,
        label: (p) => p ? '100 %' : 'Absoluto',
        onSelected: (p) => setState(() => _percent = p),
      ),
      chart: Chart(
        data: statsLong(topBy((p) => p.total, 7)),
        variables: {
          'name': strVar('name'),
          'stat': strVar('stat'),
          'value': numVar('value', scale: LinearScale(min: 0, max: 700)),
        },
        transforms: [
          // nest: el 100 % es por cada Pokémon
          Proportion(
            variable: 'value',
            nest: Varset('name'),
            as: 'percent',
            scale: LinearScale(
              min: 0,
              max: 1,
              formatter: (v) => '${(v * 100).round()}%',
            ),
          ),
        ],
        marks: [
          IntervalMark(
            // solo cambia la variable del eje Y
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
