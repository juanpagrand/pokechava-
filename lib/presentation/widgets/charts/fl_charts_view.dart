import 'package:flutter/material.dart';
import 'charts.dart';

class _Category {
  final String name;
  final bool advanced;
  final List<Widget Function()> charts;

  const _Category(this.name, this.advanced, this.charts);
}

final List<_Category> _categories = [
  // Normales (40)
  _Category('Barras', false, [
    () => const BarChartWidget01(),
    () => const BarChartWidget02(),
    () => const BarChartWidget03(),
    () => const BarChartWidget04(),
    () => const BarChartWidget05(),
    () => const BarChartWidget06(),
    () => const BarChartWidget07(),
    () => const BarChartWidget08(),
    () => const BarChartWidget09(),
    () => const BarChartWidget10(),
  ]),
  _Category('Líneas', false, [
    () => const LineChartWidget01(),
    () => const LineChartWidget02(),
    () => const LineChartWidget03(),
    () => const LineChartWidget04(),
    () => const LineChartWidget05(),
    () => const LineChartWidget06(),
    () => const LineChartWidget07(),
    () => const LineChartWidget08(),
    () => const LineChartWidget09(),
    () => const LineChartWidget10(),
  ]),
  _Category('Pastel', false, [
    () => const PieChartWidget01(),
    () => const PieChartWidget02(),
    () => const PieChartWidget03(),
    () => const PieChartWidget04(),
    () => const PieChartWidget05(),
    () => const PieChartWidget06(),
    () => const PieChartWidget07(),
    () => const PieChartWidget08(),
    () => const PieChartWidget09(),
    () => const PieChartWidget10(),
  ]),
  _Category('Radar', false, [
    () => const RadarChartWidget01(),
    () => const RadarChartWidget02(),
    () => const RadarChartWidget03(),
    () => const RadarChartWidget04(),
    () => const RadarChartWidget05(),
  ]),
  _Category('Dispersión', false, [
    () => const ScatterChartWidget01(),
    () => const ScatterChartWidget02(),
    () => const ScatterChartWidget03(),
    () => const ScatterChartWidget04(),
    () => const ScatterChartWidget05(),
  ]),

  // Avanzados (25)
  _Category('Barras Interactivas', true, [
    () => const FlChartAdvanced01(),
    () => const FlChartAdvanced02(),
    () => const FlChartAdvanced03(),
    () => const FlChartAdvanced04(),
    () => const FlChartAdvanced05(),
  ]),
  _Category('Líneas y Curvas Avanzadas', true, [
    () => const FlChartAdvanced06(),
    () => const FlChartAdvanced07(),
    () => const FlChartAdvanced08(),
    () => const FlChartAdvanced09(),
    () => const FlChartAdvanced10(),
    () => const FlChartAdvanced11(),
  ]),
  _Category('Circulares y Donas', true, [
    () => const FlChartAdvanced12(),
    () => const FlChartAdvanced13(),
    () => const FlChartAdvanced14(),
    () => const FlChartAdvanced15(),
  ]),
  _Category('Radar Multidimensional', true, [
    () => const FlChartAdvanced16(),
    () => const FlChartAdvanced17(),
    () => const FlChartAdvanced18(),
  ]),
  _Category('Dispersión y Clusters', true, [
    () => const FlChartAdvanced19(),
    () => const FlChartAdvanced20(),
    () => const FlChartAdvanced21(),
  ]),
  _Category('Composición Especial', true, [
    () => const FlChartAdvanced22(),
    () => const FlChartAdvanced23(),
    () => const FlChartAdvanced24(),
    () => const FlChartAdvanced25(),
  ]),
];

/// Todos los gráficos en orden (N01…N40, A01…A25) para pruebas y conteos
List<Widget Function()> flChartBuilders({bool? advanced}) => [
      for (final c in _categories)
        if (advanced == null || c.advanced == advanced) ...c.charts,
    ];

/// Cantidad total de gráficos por nivel
int flChartCount({required bool advanced}) => _categories
    .where((c) => c.advanced == advanced)
    .fold(0, (sum, c) => sum + c.charts.length);

/// Vista completa de los 65 gráficos de fl_chart (40 normales + 25 avanzados)
class FlChartsView extends StatefulWidget {
  const FlChartsView({super.key});

  @override
  State<FlChartsView> createState() => _FlChartsViewState();
}

class _FlChartsViewState extends State<FlChartsView> {
  bool _advanced = false;
  String? _category;

  @override
  Widget build(BuildContext context) {
    final level = _categories.where((c) => c.advanced == _advanced).toList();
    final shown = level.where((c) => _category == null || c.name == _category);
    final charts = [for (final c in shown) ...c.charts];
    final normals = flChartCount(advanced: false);
    final advanceds = flChartCount(advanced: true);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: SegmentedButton<bool>(
            segments: [
              ButtonSegment(
                value: false,
                icon: const Icon(Icons.insert_chart_outlined),
                label: Text('Normales ($normals)'),
              ),
              ButtonSegment(
                value: true,
                icon: const Icon(Icons.auto_awesome),
                label: Text('Avanzados ($advanceds)'),
              ),
            ],
            selected: {_advanced},
            onSelectionChanged: (s) => setState(() {
              _advanced = s.first;
              _category = null;
            }),
          ),
        ),
        SizedBox(
          height: 48,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            children: [
              _chip('Todos', null,
                  level.fold(0, (sum, c) => sum + c.charts.length)),
              for (final c in level) _chip(c.name, c.name, c.charts.length),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            key: PageStorageKey('flchart-$_advanced-$_category'),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            itemCount: charts.length,
            separatorBuilder: (_, _) => const SizedBox(height: 14),
            itemBuilder: (_, i) => charts[i](),
          ),
        ),
      ],
    );
  }

  Widget _chip(String label, String? value, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text('$label ($count)'),
        selected: _category == value,
        onSelected: (_) => setState(() => _category = value),
      ),
    );
  }
}
