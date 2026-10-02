// Pestaña con los 65 gráficos, filtro por nivel y categoría.

import 'package:flutter/material.dart';

import 'charts_community.dart';

class _Category {
  final String name;
  final bool advanced;
  final List<Widget Function()> charts;

  const _Category(this.name, this.advanced, this.charts);
}

// Funciones y no widgets: solo se construye lo que se ve.
final List<_Category> _categories = [
  _Category('Barras', false, [
    () => const CommunityNormal01(),
    () => const CommunityNormal02(),
    () => const CommunityNormal03(),
    () => const CommunityNormal04(),
    () => const CommunityNormal05(),
    () => const CommunityNormal06(),
    () => const CommunityNormal07(),
    () => const CommunityNormal08(),
    () => const CommunityNormal09(),
    () => const CommunityNormal10(),
  ]),
  _Category('Líneas y áreas', false, [
    () => const CommunityNormal11(),
    () => const CommunityNormal12(),
    () => const CommunityNormal13(),
    () => const CommunityNormal14(),
    () => const CommunityNormal15(),
    () => const CommunityNormal16(),
    () => const CommunityNormal17(),
    () => const CommunityNormal18(),
  ]),
  _Category('Tortas', false, [
    () => const CommunityNormal19(),
    () => const CommunityNormal20(),
    () => const CommunityNormal21(),
    () => const CommunityNormal22(),
    () => const CommunityNormal23(),
    () => const CommunityNormal24(),
  ]),
  _Category('Dispersión', false, [
    () => const CommunityNormal25(),
    () => const CommunityNormal26(),
    () => const CommunityNormal27(),
    () => const CommunityNormal28(),
    () => const CommunityNormal29(),
  ]),
  _Category('Series de tiempo', false, [
    () => const CommunityNormal30(),
    () => const CommunityNormal31(),
    () => const CommunityNormal32(),
    () => const CommunityNormal33(),
    () => const CommunityNormal34(),
  ]),
  _Category('Combinados y ejes', false, [
    () => const CommunityNormal35(),
    () => const CommunityNormal36(),
    () => const CommunityNormal37(),
    () => const CommunityNormal38(),
    () => const CommunityNormal39(),
    () => const CommunityNormal40(),
  ]),
  _Category('Interacción', true, [
    () => const CommunityAdvanced01(),
    () => const CommunityAdvanced02(),
    () => const CommunityAdvanced03(),
    () => const CommunityAdvanced04(),
    () => const CommunityAdvanced05(),
    () => const CommunityAdvanced06(),
    () => const CommunityAdvanced07(),
    () => const CommunityAdvanced08(),
  ]),
  _Category('Leyendas y anotaciones', true, [
    () => const CommunityAdvanced09(),
    () => const CommunityAdvanced10(),
    () => const CommunityAdvanced11(),
    () => const CommunityAdvanced12(),
    () => const CommunityAdvanced13(),
    () => const CommunityAdvanced14(),
    () => const CommunityAdvanced15(),
    () => const CommunityAdvanced16(),
    () => const CommunityAdvanced17(),
    () => const CommunityAdvanced18(),
  ]),
  _Category('Datos y renderers', true, [
    () => const CommunityAdvanced19(),
    () => const CommunityAdvanced20(),
    () => const CommunityAdvanced21(),
    () => const CommunityAdvanced22(),
    () => const CommunityAdvanced23(),
    () => const CommunityAdvanced24(),
    () => const CommunityAdvanced25(),
  ]),
];

/// Todos en orden (N01…A25). Lo usa el test.
List<Widget Function()> communityChartBuilders({bool? advanced}) => [
      for (final c in _categories)
        if (advanced == null || c.advanced == advanced) ...c.charts,
    ];

/// Pestaña de community_charts.
class CommunityChartsView extends StatefulWidget {
  const CommunityChartsView({super.key});

  @override
  State<CommunityChartsView> createState() => _CommunityChartsViewState();
}

class _CommunityChartsViewState extends State<CommunityChartsView> {
  bool _advanced = false;
  String? _category;

  @override
  Widget build(BuildContext context) {
    final level = _categories.where((c) => c.advanced == _advanced).toList();
    final shown = level.where((c) => _category == null || c.name == _category);
    final charts = [for (final c in shown) ...c.charts];
    final normals = communityChartBuilders(advanced: false).length;
    final advanceds = communityChartBuilders(advanced: true).length;

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
            key: PageStorageKey('community-$_advanced-$_category'),
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
