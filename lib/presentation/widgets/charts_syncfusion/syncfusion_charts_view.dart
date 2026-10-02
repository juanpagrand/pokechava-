import 'package:flutter/material.dart';
import 'charts_syncfusion.dart';

class _Category {
  final String name;
  final bool advanced;
  final List<Widget Function()> charts;

  const _Category(this.name, this.advanced, this.charts);
}

final List<_Category> _categories = [
  // Normales (40)
  _Category('Barras', false, [
    () => const SfBarChartWidget01(),
    () => const SfBarChartWidget02(),
    () => const SfBarChartWidget03(),
    () => const SfBarChartWidget04(),
    () => const SfBarChartWidget05(),
  ]),
  _Category('Líneas', false, [
    () => const SfLineChartWidget01(),
    () => const SfLineChartWidget02(),
    () => const SfLineChartWidget03(),
    () => const SfLineChartWidget04(),
    () => const SfLineChartWidget05(),
  ]),
  _Category('Pastel y Dona', false, [
    () => const SfPieChartWidget01(),
    () => const SfPieChartWidget02(),
    () => const SfPieChartWidget03(),
    () => const SfPieChartWidget04(),
    () => const SfPieChartWidget05(),
  ]),
  _Category('Histogramas', false, [
    () => const SfHistogramChartWidget01(),
    () => const SfHistogramChartWidget02(),
    () => const SfHistogramChartWidget03(),
    () => const SfHistogramChartWidget04(),
    () => const SfHistogramChartWidget05(),
  ]),
  _Category('Dispersión', false, [
    () => const SfScatterChartWidget01(),
    () => const SfScatterChartWidget02(),
    () => const SfScatterChartWidget03(),
    () => const SfScatterChartWidget04(),
    () => const SfScatterChartWidget05(),
  ]),
  _Category('Áreas', false, [
    () => const SfAreaChartWidget01(),
    () => const SfAreaChartWidget02(),
    () => const SfAreaChartWidget03(),
    () => const SfAreaChartWidget04(),
    () => const SfAreaChartWidget05(),
  ]),
  _Category('Caja y Bigotes', false, [
    () => const SfBoxChartWidget01(),
    () => const SfBoxChartWidget02(),
    () => const SfBoxChartWidget03(),
    () => const SfBoxChartWidget04(),
    () => const SfBoxChartWidget05(),
  ]),
  _Category('Combinadas', false, [
    () => const SfComboChartWidget01(),
    () => const SfComboChartWidget02(),
    () => const SfComboChartWidget03(),
    () => const SfComboChartWidget04(),
    () => const SfComboChartWidget05(),
  ]),

  // Avanzados (25)
  _Category('Interacción y Zoom', true, [
    () => const SyncfusionAdvanced01(),
    () => const SyncfusionAdvanced02(),
    () => const SyncfusionAdvanced03(),
    () => const SyncfusionAdvanced04(),
    () => const SyncfusionAdvanced05(),
  ]),
  _Category('Curvas y Formas', true, [
    () => const SyncfusionAdvanced06(),
    () => const SyncfusionAdvanced07(),
    () => const SyncfusionAdvanced08(),
    () => const SyncfusionAdvanced09(),
    () => const SyncfusionAdvanced10(),
    () => const SyncfusionAdvanced11(),
    () => const SyncfusionAdvanced12(),
  ]),
  _Category('Composición y Rango', true, [
    () => const SyncfusionAdvanced13(),
    () => const SyncfusionAdvanced14(),
    () => const SyncfusionAdvanced15(),
    () => const SyncfusionAdvanced16(),
    () => const SyncfusionAdvanced17(),
    () => const SyncfusionAdvanced18(),
  ]),
  _Category('Estadística y Tiers', true, [
    () => const SyncfusionAdvanced19(),
    () => const SyncfusionAdvanced20(),
    () => const SyncfusionAdvanced21(),
    () => const SyncfusionAdvanced22(),
    () => const SyncfusionAdvanced23(),
    () => const SyncfusionAdvanced24(),
    () => const SyncfusionAdvanced25(),
  ]),
];

/// Todos los gráficos en orden para pruebas y conteos
List<Widget Function()> syncfusionChartBuilders({bool? advanced}) => [
      for (final c in _categories)
        if (advanced == null || c.advanced == advanced) ...c.charts,
    ];

/// Cantidad total de gráficos por nivel
int syncfusionChartCount({required bool advanced}) => _categories
    .where((c) => c.advanced == advanced)
    .fold(0, (sum, c) => sum + c.charts.length);

/// Vista completa de los 65 gráficos de Syncfusion (40 normales + 25 avanzados)
class SyncfusionChartsView extends StatefulWidget {
  const SyncfusionChartsView({super.key});

  @override
  State<SyncfusionChartsView> createState() => _SyncfusionChartsViewState();
}

class _SyncfusionChartsViewState extends State<SyncfusionChartsView> {
  bool _advanced = false;
  String? _category;

  @override
  Widget build(BuildContext context) {
    final level = _categories.where((c) => c.advanced == _advanced).toList();
    final shown = level.where((c) => _category == null || c.name == _category);
    final charts = [for (final c in shown) ...c.charts];
    final normals = syncfusionChartCount(advanced: false);
    final advanceds = syncfusionChartCount(advanced: true);

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
            key: PageStorageKey('syncfusion-$_advanced-$_category'),
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
