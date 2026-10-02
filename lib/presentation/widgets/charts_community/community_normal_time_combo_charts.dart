// Normales N30–N34 (tiempo), N35–N36 (combinados) y N37–N40 (ejes).

import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:flutter/material.dart';

import 'community_chart_card.dart';
import 'community_data.dart';
import 'community_normal_bar_charts.dart' show ccPokeSeries;

/// Serie de tiempo con la fecha de cada generación.
charts.Series<CcGeneration, DateTime> ccTimeSeries(
  String id,
  num Function(CcGeneration g, int index) measure, {
  Color color = Colors.indigo,
}) {
  return charts.Series<CcGeneration, DateTime>(
    id: id,
    data: kCcGenerations,
    domainFn: (g, _) => g.release,
    measureFn: (g, int? i) => measure(g, i ?? 0),
    colorFn: (_, _) => ccColor(color),
  );
}

/// N30: serie de tiempo simple.
class CommunityNormal30 extends StatelessWidget {
  const CommunityNormal30({super.key});

  @override
  Widget build(BuildContext context) {
    final cumulative = kCcCumulative;
    return CommunityChartCard(
      code: 'N30',
      title: 'Pokédex acumulada en el tiempo (1996–2022)',
      description: 'charts.TimeSeriesChart: dominio DateTime.',
      chart: charts.TimeSeriesChart(
        [ccTimeSeries('Total', (_, i) => cumulative[i])],
        animate: true,
        dateTimeFactory: const charts.LocalDateTimeFactory(),
        domainAxis: ccDateAxis(),
        primaryMeasureAxis: ccNumericAxis(),
      ),
    );
  }
}

/// N31: serie de tiempo con barras.
class CommunityNormal31 extends StatelessWidget {
  const CommunityNormal31({super.key});

  @override
  Widget build(BuildContext context) {
    return CommunityChartCard(
      code: 'N31',
      title: 'Nuevos por lanzamiento (barras en el tiempo)',
      description: 'defaultRenderer: BarRendererConfig<DateTime>.',
      chart: charts.TimeSeriesChart(
        [ccTimeSeries('Nuevos', (g, _) => g.newPokemon, color: Colors.teal)],
        animate: true,
        defaultRenderer: charts.BarRendererConfig<DateTime>(),
        domainAxis: ccDateAxis(),
        primaryMeasureAxis: ccNumericAxis(),
      ),
    );
  }
}

/// N32: eje de fechas solo con los extremos.
class CommunityNormal32 extends StatelessWidget {
  const CommunityNormal32({super.key});

  @override
  Widget build(BuildContext context) {
    final cumulative = kCcCumulative;
    return CommunityChartCard(
      code: 'N32',
      title: 'De 1996 a 2022, sin fechas intermedias',
      description: 'EndPointsTimeAxisSpec: solo la primera y la última fecha.',
      chart: charts.TimeSeriesChart(
        [ccTimeSeries('Total', (_, i) => cumulative[i], color: Colors.brown)],
        animate: true,
        domainAxis: charts.EndPointsTimeAxisSpec(
          renderSpec: charts.SmallTickRendererSpec(labelStyle: ccLabelStyle()),
        ),
        primaryMeasureAxis: ccNumericAxis(),
      ),
    );
  }
}

/// N33: serie de tiempo con puntos y área.
class CommunityNormal33 extends StatelessWidget {
  const CommunityNormal33({super.key});

  @override
  Widget build(BuildContext context) {
    final nuevos =
        ccTimeSeries('Nuevos', (g, _) => g.newPokemon, color: Colors.purple);
    return CommunityChartCard(
      code: 'N33',
      title: 'Nuevos por lanzamiento (área con puntos)',
      description: 'Área en el tiempo + puntos con PointRendererConfig<DateTime>.',
      chart: charts.TimeSeriesChart(
        [nuevos, ccPointsOf(nuevos)],
        animate: true,
        defaultRenderer: charts.LineRendererConfig(includeArea: true),
        customSeriesRenderers: [ccPointRenderer<DateTime>()],
        domainAxis: ccDateAxis(),
        primaryMeasureAxis: ccNumericAxis(),
      ),
    );
  }
}

/// N34: dos series de tiempo.
class CommunityNormal34 extends StatelessWidget {
  const CommunityNormal34({super.key});

  @override
  Widget build(BuildContext context) {
    final cumulative = kCcCumulative;
    return CommunityChartCard(
      code: 'N34',
      title: 'Nuevos vs. acumulado (en cientos)',
      description: 'Dos series en el mismo TimeSeriesChart + leyenda.',
      chart: charts.TimeSeriesChart(
        [
          ccTimeSeries('Nuevos', (g, _) => g.newPokemon, color: Colors.teal),
          ccTimeSeries('Acumulado ÷ 10', (_, i) => cumulative[i] / 10,
              color: Colors.deepOrange),
        ],
        animate: true,
        behaviors: [charts.SeriesLegend(entryTextStyle: ccLegendStyle())],
        domainAxis: ccDateAxis(),
        primaryMeasureAxis: ccNumericAxis(),
      ),
    );
  }
}

/// N35: barras + línea (combo ordinal).
class CommunityNormal35 extends StatelessWidget {
  const CommunityNormal35({super.key});

  @override
  Widget build(BuildContext context) {
    final pokes = ccTopBy((p) => p.total, 8);
    return CommunityChartCard(
      code: 'N35',
      title: 'Ataque en barras, defensa en línea',
      description:
          'OrdinalComboChart: la serie de defensa usa el renderer "linea".',
      chart: charts.OrdinalComboChart(
        [
          ccPokeSeries('Ataque', pokes, (p) => p.attack, color: Colors.red),
          // la serie usa el renderer de línea
          ccPokeSeries('Defensa', pokes, (p) => p.defense, color: Colors.blue)
            ..setAttribute(charts.rendererIdKey, 'linea'),
        ],
        animate: true,
        defaultRenderer: charts.BarRendererConfig(),
        customSeriesRenderers: [
          charts.LineRendererConfig(customRendererId: 'linea'),
        ],
        domainAxis: ccOrdinalAxis(labelRotation: 45),
        primaryMeasureAxis: ccNumericAxis(),
      ),
    );
  }
}

/// N36: línea + puntos (combo numérico).
class CommunityNormal36 extends StatelessWidget {
  const CommunityNormal36({super.key});

  @override
  Widget build(BuildContext context) {
    final cumulative = kCcCumulative;
    charts.Series<CcGeneration, num> gen(
            String id, num Function(CcGeneration, int) f, Color c) =>
        charts.Series<CcGeneration, num>(
          id: id,
          data: kCcGenerations,
          domainFn: (g, _) => g.number,
          measureFn: (g, int? i) => f(g, i ?? 0),
          colorFn: (_, _) => ccColor(c),
        );
    return CommunityChartCard(
      code: 'N36',
      title: 'Nuevos (puntos) y acumulado ÷ 10 (línea)',
      description: 'NumericComboChart con un PointRendererConfig propio.',
      chart: charts.NumericComboChart(
        [
          gen('Acumulado ÷ 10', (_, i) => cumulative[i] / 10, Colors.indigo),
          // esta va con el renderer de puntos
          gen('Nuevos', (g, _) => g.newPokemon, Colors.pink)
            ..setAttribute(charts.rendererIdKey, 'puntos'),
        ],
        animate: true,
        defaultRenderer: charts.LineRendererConfig(),
        customSeriesRenderers: [
          charts.PointRendererConfig(customRendererId: 'puntos'),
        ],
        domainAxis: ccNumericAxis(),
        primaryMeasureAxis: ccNumericAxis(),
      ),
    );
  }
}

/// N37: eje secundario.
class CommunityNormal37 extends StatelessWidget {
  const CommunityNormal37({super.key});

  @override
  Widget build(BuildContext context) {
    final pokes = ccTopBy((p) => p.weight, 6);
    return CommunityChartCard(
      code: 'N37',
      title: 'Peso (eje izquierdo) y altura (eje derecho)',
      description: 'measureAxisIdKey manda una serie al eje secundario.',
      chart: charts.BarChart(
        [
          ccPokeSeries('Peso (kg)', pokes, (p) => p.weight,
              color: Colors.blueGrey),
          ccPokeSeries('Altura (m)', pokes, (p) => p.height,
              color: Colors.deepOrange)
            // eje derecho
            ..setAttribute(charts.measureAxisIdKey, 'secondaryMeasureAxisId'),
        ],
        animate: true,
        barGroupingType: charts.BarGroupingType.grouped,
        behaviors: [charts.SeriesLegend(entryTextStyle: ccLegendStyle())],
        domainAxis: ccOrdinalAxis(labelRotation: 45),
        primaryMeasureAxis: ccNumericAxis(desiredTickCount: 5),
        secondaryMeasureAxis: ccNumericAxis(desiredTickCount: 5),
      ),
    );
  }
}

/// N38: eje con unidad y cuadrícula punteada.
// con flipVerticalAxis salía vacío en esta versión, por eso se cambió
class CommunityNormal38 extends StatelessWidget {
  const CommunityNormal38({super.key});

  @override
  Widget build(BuildContext context) {
    return CommunityChartCard(
      code: 'N38',
      title: 'Peso con unidad en el eje y cuadrícula punteada',
      description:
          'BasicNumericTickFormatterSpec escribe "kg"; dashPattern punta la grilla.',
      chart: charts.BarChart(
        [
          ccPokeSeries('Peso', ccTopBy((p) => p.weight, 8), (p) => p.weight,
              color: Colors.blueGrey),
        ],
        animate: true,
        domainAxis: ccOrdinalAxis(labelRotation: 45),
        primaryMeasureAxis: charts.NumericAxisSpec(
          tickFormatterSpec: charts.BasicNumericTickFormatterSpec(
              (num? v) => v == null ? '' : '${v.round()} kg'),
          renderSpec: charts.GridlineRendererSpec(
            labelStyle: ccLabelStyle(),
            lineStyle: charts.LineStyleSpec(color: ccGridGray, dashPattern: [4, 4]),
          ),
        ),
      ),
    );
  }
}

/// N39: marcas del eje escritas a mano.
class CommunityNormal39 extends StatelessWidget {
  const CommunityNormal39({super.key});

  @override
  Widget build(BuildContext context) {
    final pokes = ccByNames(['Bulbasaur', 'Charmander', 'Squirtle', 'Pikachu']);
    // marcas a mano, Pikachu resaltado
    final ticks = <charts.TickSpec<String>>[
      for (final p in pokes)
        charts.TickSpec(
          p.name,
          label: p.name == 'Pikachu' ? '★ Pikachu' : p.name,
          style: charts.TextStyleSpec(
            fontSize: p.name == 'Pikachu' ? 12 : 10,
            color: p.name == 'Pikachu'
                ? ccColor(Colors.amber.shade800)
                : ccAxisGray,
          ),
        ),
    ];
    return CommunityChartCard(
      code: 'N39',
      title: 'Total de los iniciales, con Pikachu destacado',
      description: 'StaticOrdinalTickProviderSpec: tú decides cada marca.',
      chart: charts.BarChart(
        [ccPokeSeries('Total', pokes, (p) => p.total)],
        animate: true,
        domainAxis: charts.OrdinalAxisSpec(
          tickProviderSpec: charts.StaticOrdinalTickProviderSpec(ticks),
        ),
        primaryMeasureAxis: ccNumericAxis(),
      ),
    );
  }
}

/// N40: sparkbar (sin ejes ni márgenes).
class CommunityNormal40 extends StatelessWidget {
  const CommunityNormal40({super.key});

  @override
  Widget build(BuildContext context) {
    return CommunityChartCard(
      code: 'N40',
      title: 'Sparkbar: HP de los 23 de un vistazo',
      description:
          'NoneRenderSpec oculta los ejes y LayoutConfig quita los márgenes.',
      height: 90,
      chart: charts.BarChart(
        [ccPokeSeries('HP', kCcPokes, (p) => p.hp, color: Colors.green)],
        animate: true,
        primaryMeasureAxis:
            const charts.NumericAxisSpec(renderSpec: charts.NoneRenderSpec()),
        domainAxis: const charts.OrdinalAxisSpec(
          showAxisLine: true,
          renderSpec: charts.NoneRenderSpec(),
        ),
        layoutConfig: charts.LayoutConfig(
          leftMarginSpec: charts.MarginSpec.fixedPixel(0),
          topMarginSpec: charts.MarginSpec.fixedPixel(0),
          rightMarginSpec: charts.MarginSpec.fixedPixel(0),
          bottomMarginSpec: charts.MarginSpec.fixedPixel(0),
        ),
      ),
    );
  }
}
