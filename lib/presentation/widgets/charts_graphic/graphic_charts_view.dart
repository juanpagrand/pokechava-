import 'package:flutter/material.dart';

import 'charts_graphic.dart';

class _Category {
  final String name;
  final bool advanced;
  final List<Widget Function()> charts;

  const _Category(this.name, this.advanced, this.charts);
}

final List<_Category> _categories = [
  _Category('Barras', false, [
    () => const GraphicNormal01(),
    () => const GraphicNormal02(),
    () => const GraphicNormal03(),
    () => const GraphicNormal04(),
    () => const GraphicNormal05(),
    () => const GraphicNormal06(),
    () => const GraphicNormal07(),
    () => const GraphicNormal08(),
  ]),
  _Category('Líneas', false, [
    () => const GraphicNormal09(),
    () => const GraphicNormal10(),
    () => const GraphicNormal11(),
    () => const GraphicNormal12(),
    () => const GraphicNormal13(),
    () => const GraphicNormal14(),
    () => const GraphicNormal15(),
  ]),
  _Category('Áreas', false, [
    () => const GraphicNormal16(),
    () => const GraphicNormal17(),
    () => const GraphicNormal18(),
    () => const GraphicNormal19(),
    () => const GraphicNormal20(),
    () => const GraphicNormal21(),
  ]),
  _Category('Dispersión', false, [
    () => const GraphicNormal22(),
    () => const GraphicNormal23(),
    () => const GraphicNormal24(),
    () => const GraphicNormal25(),
    () => const GraphicNormal26(),
    () => const GraphicNormal27(),
  ]),
  _Category('Circulares', false, [
    () => const GraphicNormal28(),
    () => const GraphicNormal29(),
    () => const GraphicNormal30(),
    () => const GraphicNormal31(),
    () => const GraphicNormal32(),
    () => const GraphicNormal33(),
    () => const GraphicNormal34(),
    () => const GraphicNormal35(),
  ]),
  _Category('Radar y polar', false, [
    () => const GraphicNormal36(),
    () => const GraphicNormal37(),
    () => const GraphicNormal38(),
  ]),
  _Category('Calor e histograma', false, [
    () => const GraphicNormal39(),
    () => const GraphicNormal40(),
  ]),
  _Category('Interacción', true, [
    () => const GraphicAdvanced01(),
    () => const GraphicAdvanced02(),
    () => const GraphicAdvanced03(),
    () => const GraphicAdvanced04(),
    () => const GraphicAdvanced05(),
    () => const GraphicAdvanced06(),
    () => const GraphicAdvanced07(),
    () => const GraphicAdvanced08(),
  ]),
  _Category('Dinámicos', true, [
    () => const GraphicAdvanced09(),
    () => const GraphicAdvanced10(),
    () => const GraphicAdvanced11(),
    () => const GraphicAdvanced12(),
    () => const GraphicAdvanced13(),
    () => const GraphicAdvanced14(),
    () => const GraphicAdvanced15(),
  ]),
  _Category('Formas y composición', true, [
    () => const GraphicAdvanced16(),
    () => const GraphicAdvanced17(),
    () => const GraphicAdvanced18(),
    () => const GraphicAdvanced19(),
    () => const GraphicAdvanced20(),
    () => const GraphicAdvanced21(),
    () => const GraphicAdvanced22(),
    () => const GraphicAdvanced23(),
    () => const GraphicAdvanced24(),
    () => const GraphicAdvanced25(),
  ]),
];

/// Todos los gráficos en orden (N01…N40, A01…A25), para pruebas y conteos.
List<Widget Function()> graphicChartBuilders({bool? advanced}) => [
      for (final c in _categories)
        if (advanced == null || c.advanced == advanced) ...c.charts,
    ];

/// Cantidad total de gráficos por nivel, calculada desde las categorías.
int graphicChartCount({required bool advanced}) => _categories
    .where((c) => c.advanced == advanced)
    .fold(0, (sum, c) => sum + c.charts.length);

/// Vista de los 65 gráficos de graphic, filtrable por nivel y categoría.
class GraphicChartsView extends StatefulWidget {
  const GraphicChartsView({super.key});

  @override
  State<GraphicChartsView> createState() => _GraphicChartsViewState();
}

class _GraphicChartsViewState extends State<GraphicChartsView> {
  bool _advanced = false;
  String? _category;

  @override
  Widget build(BuildContext context) {
    final level = _categories.where((c) => c.advanced == _advanced).toList();
    final shown = level.where((c) => _category == null || c.name == _category);
    final charts = [for (final c in shown) ...c.charts];
    final normals = graphicChartCount(advanced: false);
    final advanceds = graphicChartCount(advanced: true);

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
            key: PageStorageKey('graphic-$_advanced-$_category'),
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
