// Avanzados A01–A08: interacción (behaviors).

import 'dart:math' as math;

import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'community_chart_card.dart';
import 'community_data.dart';
import 'community_normal_bar_charts.dart' show ccPokeSeries;
import 'community_normal_line_charts.dart' show ccIndexSeries;
import 'community_normal_time_combo_charts.dart' show ccTimeSeries;

/// A01: regla que sigue el dedo.
class CommunityAdvanced01 extends StatelessWidget {
  const CommunityAdvanced01({super.key});

  @override
  Widget build(BuildContext context) {
    return CommunityChartCard(
      code: 'A01',
      title: 'Arrastra el dedo: la regla sigue al punto más cercano',
      description: 'SelectNearest(tapAndDrag) + LinePointHighlighter.',
      chart: charts.LineChart(
        [
          ccIndexSeries('Velocidad', (p) => p.speed, Colors.teal),
          ccIndexSeries('Ataque', (p) => p.attack, Colors.red),
        ],
        animate: true,
        behaviors: [
          charts.LinePointHighlighter(
            showHorizontalFollowLine:
                charts.LinePointHighlighterFollowLineType.none,
            showVerticalFollowLine:
                charts.LinePointHighlighterFollowLineType.nearest,
          ),
          // tapAndDrag: también al arrastrar
          charts.SelectNearest(
              eventTrigger: charts.SelectionTrigger.tapAndDrag),
        ],
        domainAxis: ccNumericAxis(),
        primaryMeasureAxis: ccNumericAxis(),
      ),
    );
  }
}

/// A02: selección inicial.
class CommunityAdvanced02 extends StatelessWidget {
  const CommunityAdvanced02({super.key});

  @override
  Widget build(BuildContext context) {
    return CommunityChartCard(
      code: 'A02',
      title: 'Mewtwo ya viene resaltado (toca otro)',
      description:
          'InitialSelection: SeriesDatumConfig(serie, dominio) al abrir.',
      chart: charts.BarChart(
        [
          ccPokeSeries('Total', ccTopBy((p) => p.total, 8), (p) => p.total,
              color: Colors.indigo),
        ],
        animate: true,
        defaultInteractions: true,
        behaviors: [
          charts.InitialSelection(selectedDataConfig: [
            // (serie, dominio)
            charts.SeriesDatumConfig<String>('Total', 'Mewtwo'),
          ]),
        ],
        domainAxis: ccOrdinalAxis(labelRotation: 45),
        primaryMeasureAxis: ccNumericAxis(),
      ),
    );
  }
}

/// A03: escuchar la selección desde Flutter.
class CommunityAdvanced03 extends StatefulWidget {
  const CommunityAdvanced03({super.key});

  @override
  State<CommunityAdvanced03> createState() => _CommunityAdvanced03State();
}

class _CommunityAdvanced03State extends State<CommunityAdvanced03> {
  String _detalle = 'Toca un punto de la línea.';

  // se llama cada vez que cambia la selección
  void _onSelectionChanged(charts.SelectionModel<DateTime> model) {
    final selected = model.selectedDatum;
    if (selected.isEmpty) return;
    final g = selected.first.datum as CcGeneration;
    setState(() {
      _detalle = 'Generación ${g.number} · ${g.games} · '
          '${g.release.year} · ${g.newPokemon} Pokémon nuevos';
    });
  }

  @override
  Widget build(BuildContext context) {
    final nuevos =
        ccTimeSeries('Nuevos', (g, _) => g.newPokemon, color: Colors.purple);
    return CommunityChartCard(
      code: 'A03',
      title: 'Toca una generación y te cuenta cuál es',
      description:
          'selectionModels + changedListener: el gráfico le avisa a Flutter.',
      footer: Text(_detalle, style: const TextStyle(fontWeight: FontWeight.w600)),
      chart: charts.TimeSeriesChart(
        [nuevos, ccPointsOf(nuevos)],
        animate: true,
        customSeriesRenderers: [ccPointRenderer<DateTime>()],
        selectionModels: [
          charts.SelectionModelConfig(
            type: charts.SelectionModelType.info,
            changedListener: _onSelectionChanged,
          ),
        ],
        domainAxis: ccDateAxis(),
        primaryMeasureAxis: ccNumericAxis(),
      ),
    );
  }
}

/// Turnos inventados para probar el zoom.
final List<Point<int>> _turns = [
  for (var i = 1; i <= 120; i++)
    math.Point(
      i,
      (40 + 28 * math.sin(i / 6) + 14 * math.cos(i / 2.3) +
              (i % 17 == 0 ? 35 : 0))
          .round(),
    ),
];

// para no escribir math.Point
typedef Point<T extends num> = math.Point<T>;

/// A04: zoom y desplazamiento.
class CommunityAdvanced04 extends StatelessWidget {
  const CommunityAdvanced04({super.key});

  @override
  Widget build(BuildContext context) {
    return CommunityChartCard(
      code: 'A04',
      title: 'Zoom: 120 turnos de combate (simulados)',
      description: 'PanAndZoomBehavior: pellizca para acercar, arrastra para moverte.',
      chart: charts.LineChart(
        [
          charts.Series<Point<int>, num>(
            id: 'Daño',
            data: _turns,
            domainFn: (p, _) => p.x,
            measureFn: (p, _) => p.y,
            colorFn: (_, _) => ccColor(Colors.redAccent),
          ),
        ],
        animate: false,
        behaviors: [charts.PanAndZoomBehavior()],
        domainAxis: ccNumericAxis(),
        primaryMeasureAxis: ccNumericAxis(),
      ),
    );
  }
}

/// A05: ver una parte y desplazarse.
class CommunityAdvanced05 extends StatelessWidget {
  const CommunityAdvanced05({super.key});

  @override
  Widget build(BuildContext context) {
    return CommunityChartCard(
      code: 'A05',
      title: 'Los 23 Pokémon, de 6 en 6 (arrastra)',
      description: 'OrdinalViewport(inicio, cuántos) + PanAndZoomBehavior.',
      chart: charts.BarChart(
        [ccPokeSeries('Total', kCcPokes, (p) => p.total)],
        animate: true,
        behaviors: [charts.PanAndZoomBehavior()],
        domainAxis: charts.OrdinalAxisSpec(
          // arranca mostrando 6 barras
          viewport: charts.OrdinalViewport('Bulbasaur', 6),
          renderSpec: charts.SmallTickRendererSpec(labelStyle: ccLabelStyle()),
        ),
        primaryMeasureAxis: ccNumericAxis(),
      ),
    );
  }
}

/// A06: la vista se desliza hacia lo tocado.
class CommunityAdvanced06 extends StatelessWidget {
  const CommunityAdvanced06({super.key});

  @override
  Widget build(BuildContext context) {
    return CommunityChartCard(
      code: 'A06',
      title: 'Toca una barra del borde: la vista se centra en ella',
      description: 'SlidingViewport mueve la ventana a la barra seleccionada.',
      chart: charts.BarChart(
        [ccPokeSeries('Ataque', kCcPokes, (p) => p.attack)],
        animate: true,
        behaviors: [charts.SlidingViewport(), charts.PanAndZoomBehavior()],
        domainAxis: charts.OrdinalAxisSpec(
          viewport: charts.OrdinalViewport('Charmander', 5),
          renderSpec: charts.SmallTickRendererSpec(labelStyle: ccLabelStyle()),
        ),
        primaryMeasureAxis: ccNumericAxis(),
      ),
    );
  }
}

/// A07: un deslizador dentro del gráfico.
class CommunityAdvanced07 extends StatefulWidget {
  const CommunityAdvanced07({super.key});

  @override
  State<CommunityAdvanced07> createState() => _CommunityAdvanced07State();
}

class _CommunityAdvanced07State extends State<CommunityAdvanced07> {
  num _gen = 1;

  void _onSlider(math.Point<int> point, dynamic domain, String roleId,
      charts.SliderListenerDragState dragState) {
    // llega mientras se dibuja: setState después del frame
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _gen = (domain as num).round());
    });
  }

  @override
  Widget build(BuildContext context) {
    final g = kCcGenerations[(_gen.clamp(1, 9) as int) - 1];
    return CommunityChartCard(
      code: 'A07',
      title: 'Desliza la barra vertical por las generaciones',
      description: 'charts.Slider + onChangeCallback + addPostFrameCallback.',
      footer: Text('Gen ${g.number}: ${g.games}, ${g.newPokemon} nuevos',
          style: const TextStyle(fontWeight: FontWeight.w600)),
      chart: charts.LineChart(
        [
          charts.Series<CcGeneration, num>(
            id: 'Nuevos',
            data: kCcGenerations,
            domainFn: (g, _) => g.number,
            measureFn: (g, _) => g.newPokemon,
            colorFn: (_, _) => ccColor(Colors.indigo),
          ),
        ],
        animate: true,
        behaviors: [
          charts.Slider(initialDomainValue: 1.0, onChangeCallback: _onSlider),
        ],
        domainAxis: ccNumericAxis(),
        primaryMeasureAxis: ccNumericAxis(),
      ),
    );
  }
}

/// A08: resaltar el dominio seleccionado.
class CommunityAdvanced08 extends StatelessWidget {
  const CommunityAdvanced08({super.key});

  @override
  Widget build(BuildContext context) {
    return CommunityChartCard(
      code: 'A08',
      title: 'Toca un lanzamiento: se resalta su barra',
      description: 'SelectNearest + DomainHighlighter, sin las interacciones por defecto.',
      chart: charts.TimeSeriesChart(
        [ccTimeSeries('Nuevos', (g, _) => g.newPokemon, color: Colors.teal)],
        animate: true,
        defaultRenderer: charts.BarRendererConfig<DateTime>(),
        defaultInteractions: false,
        behaviors: [charts.SelectNearest(), charts.DomainHighlighter()],
        domainAxis: ccDateAxis(),
        primaryMeasureAxis: ccNumericAxis(),
      ),
    );
  }
}
