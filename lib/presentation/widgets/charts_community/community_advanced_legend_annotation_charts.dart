// ===========================================================================
// community_advanced_legend_annotation_charts.dart — AVANZADOS A09–A18
// ===========================================================================
// Leyendas, títulos y anotaciones también son BEHAVIORS:
//   A09 SeriesLegend: tocar una entrada oculta/muestra esa serie
//   A10 leyenda a la derecha, en dos filas
//   A11 leyenda que muestra el valor seleccionado (showMeasures)
//   A12 DatumLegend: leyenda de una torta (una entrada por tajada)
//   A13 una serie oculta desde el inicio (defaultHiddenSeries)
//   A14 ChartTitle en los cuatro lados
//   A15 RangeAnnotation: franjas de rango sobre el gráfico
//   A16 LineAnnotationSegment: línea de promedio con etiqueta
//   A17 anotaciones en un eje de fechas
//   A18 BarTargetLineRenderer: una "meta" dibujada sobre cada barra
// ===========================================================================

import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:flutter/material.dart';

import 'community_chart_card.dart';
import 'community_data.dart';
import 'community_normal_bar_charts.dart' show ccPokeSeries, ccStatSeries;
import 'community_normal_line_charts.dart' show ccIndexSeries;
import 'community_normal_pie_scatter_charts.dart' show ccTypeSlices;
import 'community_normal_time_combo_charts.dart' show ccTimeSeries;

List<charts.Series<CcPoke, String>> _ataqueDefensa(List<CcPoke> pokes) => [
      ccPokeSeries('Ataque', pokes, (p) => p.attack, color: Colors.red),
      ccPokeSeries('Defensa', pokes, (p) => p.defense, color: Colors.blue),
      ccPokeSeries('Velocidad', pokes, (p) => p.speed, color: Colors.teal),
    ];

final _iniciales = ccByNames(['Venusaur', 'Charizard', 'Blastoise']);

/// A09: leyenda interactiva.
class CommunityAdvanced09 extends StatelessWidget {
  const CommunityAdvanced09({super.key});

  @override
  Widget build(BuildContext context) {
    return CommunityChartCard(
      code: 'A09',
      title: 'Toca la leyenda para ocultar una serie',
      description: 'SeriesLegend: cada entrada es un interruptor de su serie.',
      chart: charts.BarChart(
        _ataqueDefensa(_iniciales),
        animate: true,
        barGroupingType: charts.BarGroupingType.grouped,
        behaviors: [charts.SeriesLegend(entryTextStyle: ccLegendStyle())],
        domainAxis: ccOrdinalAxis(),
        primaryMeasureAxis: ccNumericAxis(),
      ),
    );
  }
}

/// A10: opciones de leyenda.
class CommunityAdvanced10 extends StatelessWidget {
  const CommunityAdvanced10({super.key});

  @override
  Widget build(BuildContext context) {
    return CommunityChartCard(
      code: 'A10',
      title: 'Composición con leyenda al lado',
      description:
          'SeriesLegend(position: end, horizontalFirst: false, desiredMaxRows).',
      height: 280,
      chart: charts.BarChart(
        ccStatSeries(ccTopBy((p) => p.total, 5)),
        animate: true,
        barGroupingType: charts.BarGroupingType.stacked,
        behaviors: [
          charts.SeriesLegend(
            // end = a la derecha (en idiomas que se leen de izquierda a
            // derecha).
            position: charts.BehaviorPosition.end,
            // Llena primero hacia abajo, en columnas.
            horizontalFirst: false,
            cellPadding: const EdgeInsets.only(right: 4, bottom: 4),
            entryTextStyle: ccLegendStyle(),
          ),
        ],
        domainAxis: ccOrdinalAxis(labelRotation: 45),
        primaryMeasureAxis: ccNumericAxis(),
      ),
    );
  }
}

/// A11: la leyenda muestra el valor de lo seleccionado.
class CommunityAdvanced11 extends StatelessWidget {
  const CommunityAdvanced11({super.key});

  @override
  Widget build(BuildContext context) {
    return CommunityChartCard(
      code: 'A11',
      title: 'Toca un Pokémon: la leyenda dice sus valores',
      description: 'SeriesLegend(showMeasures: true) + InitialSelection.',
      height: 280,
      chart: charts.BarChart(
        _ataqueDefensa(_iniciales),
        animate: true,
        barGroupingType: charts.BarGroupingType.grouped,
        behaviors: [
          charts.InitialSelection(selectedDataConfig: [
            charts.SeriesDatumConfig<String>('Ataque', 'Charizard'),
            charts.SeriesDatumConfig<String>('Defensa', 'Charizard'),
            charts.SeriesDatumConfig<String>('Velocidad', 'Charizard'),
          ]),
          charts.SeriesLegend(
            position: charts.BehaviorPosition.end,
            horizontalFirst: false,
            showMeasures: true,
            // Cómo escribir el número; null cuando no hay selección.
            measureFormatter: (num? v) => v == null ? '–' : '$v',
            entryTextStyle: ccLegendStyle(),
          ),
        ],
        domainAxis: ccOrdinalAxis(),
        primaryMeasureAxis: ccNumericAxis(),
      ),
    );
  }
}

/// A12: leyenda de una torta.
class CommunityAdvanced12 extends StatelessWidget {
  const CommunityAdvanced12({super.key});

  @override
  Widget build(BuildContext context) {
    return CommunityChartCard(
      code: 'A12',
      title: 'Tipos de Kanto con leyenda y cantidades',
      description: 'DatumLegend: una entrada por DATO (tajada), no por serie.',
      height: 280,
      chart: charts.PieChart<String>(
        [ccTypeSlices()],
        animate: true,
        defaultRenderer: charts.ArcRendererConfig(arcWidth: 45),
        behaviors: [
          charts.DatumLegend(
            position: charts.BehaviorPosition.end,
            horizontalFirst: false,
            showMeasures: true,
            // Sin selección, muestra el valor de cada tajada.
            legendDefaultMeasure: charts.LegendDefaultMeasure.firstValue,
            measureFormatter: (num? v) => v == null ? '–' : '$v',
            entryTextStyle: ccLegendStyle(),
          ),
        ],
      ),
    );
  }
}

/// A13: una serie oculta de entrada.
class CommunityAdvanced13 extends StatelessWidget {
  const CommunityAdvanced13({super.key});

  @override
  Widget build(BuildContext context) {
    return CommunityChartCard(
      code: 'A13',
      title: 'Velocidad empieza oculta (tócala en la leyenda)',
      description: 'SeriesLegend(defaultHiddenSeries: [...]).',
      chart: charts.BarChart(
        _ataqueDefensa(ccByNames(['Pikachu', 'Raichu', 'Gengar', 'Alakazam'])),
        animate: true,
        barGroupingType: charts.BarGroupingType.grouped,
        behaviors: [
          charts.SeriesLegend(
            defaultHiddenSeries: const ['Velocidad'],
            entryTextStyle: ccLegendStyle(),
          ),
        ],
        domainAxis: ccOrdinalAxis(),
        primaryMeasureAxis: ccNumericAxis(),
      ),
    );
  }
}

/// A14: títulos en los cuatro lados.
class CommunityAdvanced14 extends StatelessWidget {
  const CommunityAdvanced14({super.key});

  @override
  Widget build(BuildContext context) {
    charts.ChartTitle<num> title(String text, charts.BehaviorPosition pos,
            {String? sub}) =>
        charts.ChartTitle<num>(
          text,
          subTitle: sub,
          behaviorPosition: pos,
          titleOutsideJustification: charts.OutsideJustification.middleDrawArea,
          titleStyleSpec: charts.TextStyleSpec(fontSize: 13, color: ccAxisGray),
          subTitleStyleSpec: ccLabelStyle(),
        );
    return CommunityChartCard(
      code: 'A14',
      title: 'Títulos de eje con ChartTitle',
      description: 'Un ChartTitle por lado: top, bottom, start y end.',
      height: 300,
      chart: charts.LineChart(
        [ccIndexSeries('Experiencia', (p) => p.baseExp, Colors.deepOrange)],
        animate: true,
        behaviors: [
          title('Experiencia base', charts.BehaviorPosition.top,
              sub: '23 Pokémon de Kanto'),
          title('Posición en la lista', charts.BehaviorPosition.bottom),
          title('Puntos', charts.BehaviorPosition.start),
          title('PokeAPI', charts.BehaviorPosition.end),
        ],
        domainAxis: ccNumericAxis(),
        primaryMeasureAxis: ccNumericAxis(),
      ),
    );
  }
}

/// A15: franjas de rango.
class CommunityAdvanced15 extends StatelessWidget {
  const CommunityAdvanced15({super.key});

  @override
  Widget build(BuildContext context) {
    return CommunityChartCard(
      code: 'A15',
      title: 'Ataque con zona élite y zona baja',
      description: 'RangeAnnotation con dos RangeAnnotationSegment de medida.',
      chart: charts.LineChart(
        [ccIndexSeries('Ataque', (p) => p.attack, Colors.red)],
        animate: true,
        behaviors: [
          charts.RangeAnnotation([
            // (inicio, fin, eje) + etiquetas y color de la franja.
            charts.RangeAnnotationSegment(
              120, 140, charts.RangeAnnotationAxisType.measure,
              startLabel: 'Élite ≥ 120',
              color: ccColor(Colors.amber.withValues(alpha: 0.3)),
            ),
            charts.RangeAnnotationSegment(
              0, 50, charts.RangeAnnotationAxisType.measure,
              startLabel: 'Bajo < 50',
              color: ccColor(Colors.blueGrey.withValues(alpha: 0.2)),
            ),
          ]),
        ],
        domainAxis: ccNumericAxis(),
        primaryMeasureAxis: ccNumericAxis(),
      ),
    );
  }
}

/// A16: línea de promedio.
class CommunityAdvanced16 extends StatelessWidget {
  const CommunityAdvanced16({super.key});

  @override
  Widget build(BuildContext context) {
    final avg =
        kCcPokes.map((p) => p.speed).reduce((a, b) => a + b) / kCcPokes.length;
    return CommunityChartCard(
      code: 'A16',
      title: 'Velocidad y su promedio',
      description: 'LineAnnotationSegment: una línea en un valor del eje.',
      chart: charts.LineChart(
        [ccIndexSeries('Velocidad', (p) => p.speed, Colors.teal)],
        animate: true,
        behaviors: [
          charts.RangeAnnotation([
            charts.LineAnnotationSegment(
              avg, charts.RangeAnnotationAxisType.measure,
              endLabel: 'Promedio ${avg.toStringAsFixed(1)}',
              color: ccColor(Colors.red),
            ),
          ]),
        ],
        domainAxis: ccNumericAxis(),
        primaryMeasureAxis: ccNumericAxis(),
      ),
    );
  }
}

/// A17: anotaciones sobre fechas.
class CommunityAdvanced17 extends StatelessWidget {
  const CommunityAdvanced17({super.key});

  @override
  Widget build(BuildContext context) {
    final cumulative = kCcCumulative;
    return CommunityChartCard(
      code: 'A17',
      title: 'La Pokédex y la era Switch',
      description:
          'En TimeSeriesChart las anotaciones de dominio usan DateTime.',
      chart: charts.TimeSeriesChart(
        [ccTimeSeries('Total', (_, i) => cumulative[i])],
        animate: true,
        behaviors: [
          charts.RangeAnnotation([
            charts.RangeAnnotationSegment(
              DateTime(2019, 11, 15), DateTime(2022, 11, 18),
              charts.RangeAnnotationAxisType.domain,
              startLabel: 'Switch',
              color: ccColor(Colors.red.withValues(alpha: 0.15)),
            ),
            charts.LineAnnotationSegment(
              DateTime(2006, 9, 28), charts.RangeAnnotationAxisType.domain,
              startLabel: 'Llega el DS',
              color: ccColor(Colors.blueGrey),
            ),
          ]),
        ],
        domainAxis: ccDateAxis(),
        primaryMeasureAxis: ccNumericAxis(),
      ),
    );
  }
}

/// A18: línea objetivo sobre cada barra.
class CommunityAdvanced18 extends StatelessWidget {
  const CommunityAdvanced18({super.key});

  @override
  Widget build(BuildContext context) {
    final pokes = ccByNames(['Charizard', 'Gengar', 'Machamp', 'Snorlax', 'Onix']);
    return CommunityChartCard(
      code: 'A18',
      title: 'Ataque (barra) frente a su at. especial (marca)',
      description:
          'BarTargetLineRendererConfig: la segunda serie se dibuja como una raya.',
      chart: charts.BarChart(
        [
          ccPokeSeries('Ataque', pokes, (p) => p.attack, color: Colors.red),
          ccPokeSeries('At. Esp. (meta)', pokes, (p) => p.spAtk,
              color: Colors.amber)
            ..setAttribute(charts.rendererIdKey, 'meta'),
        ],
        animate: true,
        customSeriesRenderers: [
          charts.BarTargetLineRendererConfig<String>(
            customRendererId: 'meta',
            groupingType: charts.BarGroupingType.grouped,
          ),
        ],
        behaviors: [charts.SeriesLegend(entryTextStyle: ccLegendStyle())],
        domainAxis: ccOrdinalAxis(),
        primaryMeasureAxis: ccNumericAxis(),
      ),
    );
  }
}
