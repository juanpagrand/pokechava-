// Normales N01–N10: barras.

import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:flutter/material.dart';

import 'community_chart_card.dart';
import 'community_data.dart';

/// Serie de barras con una medida por Pokémon.
charts.Series<CcPoke, String> ccPokeSeries(
  String id,
  List<CcPoke> pokes,
  num Function(CcPoke) measure, {
  Color? color,
  String Function(CcPoke)? label,
}) {
  return charts.Series<CcPoke, String>(
    id: id,
    data: pokes,
    domainFn: (CcPoke p, _) => p.name,
    measureFn: (CcPoke p, _) => measure(p),
    // sin color fijo usa el color del tipo
    colorFn: (CcPoke p, _) => color != null ? ccColor(color) : ccTypeColor(p.type),
    labelAccessorFn: label == null ? null : (CcPoke p, _) => label(p),
  );
}

/// N01: columnas simples.
class CommunityNormal01 extends StatelessWidget {
  const CommunityNormal01({super.key});

  @override
  Widget build(BuildContext context) {
    return CommunityChartCard(
      code: 'N01',
      title: 'Top 10 por ataque base',
      description: 'charts.BarChart con una sola serie: lo mínimo.',
      chart: charts.BarChart(
        [ccPokeSeries('Ataque', ccTopBy((p) => p.attack, 10), (p) => p.attack,
            color: Colors.redAccent)],
        animate: true,
        domainAxis: ccOrdinalAxis(labelRotation: 45),
        primaryMeasureAxis: ccNumericAxis(),
      ),
    );
  }
}

/// N02: barras horizontales.
class CommunityNormal02 extends StatelessWidget {
  const CommunityNormal02({super.key});

  @override
  Widget build(BuildContext context) {
    return CommunityChartCard(
      code: 'N02',
      title: 'Top 10 por HP (horizontal)',
      description: 'vertical: false acuesta las barras.',
      height: 300,
      chart: charts.BarChart(
        [ccPokeSeries('HP', ccTopBy((p) => p.hp, 10), (p) => p.hp,
            color: Colors.green)],
        animate: true,
        // vertical: false = horizontal
        vertical: false,
        domainAxis: ccOrdinalAxis(),
        primaryMeasureAxis: ccNumericAxis(),
      ),
    );
  }
}

/// N03: columnas con su valor escrito.
class CommunityNormal03 extends StatelessWidget {
  const CommunityNormal03({super.key});

  @override
  Widget build(BuildContext context) {
    return CommunityChartCard(
      code: 'N03',
      title: 'Los 8 más rápidos, con etiqueta',
      description: 'BarLabelDecorator + labelAccessorFn en la serie.',
      chart: charts.BarChart(
        [
          ccPokeSeries('Velocidad', ccTopBy((p) => p.speed, 8), (p) => p.speed,
              color: Colors.pinkAccent, label: (p) => '${p.speed}'),
        ],
        animate: true,
        // escribe lo que devuelve labelAccessorFn
        barRendererDecorator: charts.BarLabelDecorator<String>(
          insideLabelStyleSpec: const charts.TextStyleSpec(
              fontSize: 10, color: charts.MaterialPalette.white),
          outsideLabelStyleSpec: ccLabelStyle(),
        ),
        domainAxis: ccOrdinalAxis(labelRotation: 45),
        primaryMeasureAxis: ccNumericAxis(),
      ),
    );
  }
}

/// N04: columnas agrupadas.
class CommunityNormal04 extends StatelessWidget {
  const CommunityNormal04({super.key});

  @override
  Widget build(BuildContext context) {
    final pokes = ccByNames(
        ['Charizard', 'Blastoise', 'Venusaur', 'Machamp', 'Onix', 'Snorlax']);
    return CommunityChartCard(
      code: 'N04',
      title: 'Ataque vs. defensa',
      description: 'Dos series + BarGroupingType.grouped.',
      chart: charts.BarChart(
        [
          ccPokeSeries('Ataque', pokes, (p) => p.attack, color: Colors.red),
          ccPokeSeries('Defensa', pokes, (p) => p.defense, color: Colors.blue),
        ],
        animate: true,
        barGroupingType: charts.BarGroupingType.grouped,
        domainAxis: ccOrdinalAxis(labelRotation: 45),
        primaryMeasureAxis: ccNumericAxis(),
      ),
    );
  }
}

/// Una serie por estadística.
List<charts.Series<CcPoke, String>> ccStatSeries(List<CcPoke> pokes) => [
      for (var i = 0; i < kCcStatNames.length; i++)
        ccPokeSeries(kCcStatNames[i], pokes, (p) => p.stats[i],
            color: kCcStatColors[i]),
    ];

/// N05: columnas apiladas.
class CommunityNormal05 extends StatelessWidget {
  const CommunityNormal05({super.key});

  @override
  Widget build(BuildContext context) {
    return CommunityChartCard(
      code: 'N05',
      title: 'Total de estadísticas, apilado',
      description: 'Seis series + BarGroupingType.stacked.',
      height: 290,
      chart: charts.BarChart(
        ccStatSeries(ccTopBy((p) => p.total, 7)),
        animate: true,
        barGroupingType: charts.BarGroupingType.stacked,
        domainAxis: ccOrdinalAxis(labelRotation: 45),
        primaryMeasureAxis: ccNumericAxis(),
      ),
    );
  }
}

/// N06: apiladas horizontales.
class CommunityNormal06 extends StatelessWidget {
  const CommunityNormal06({super.key});

  @override
  Widget build(BuildContext context) {
    return CommunityChartCard(
      code: 'N06',
      title: 'Iniciales finales: composición horizontal',
      description: 'El N05 con vertical: false.',
      height: 200,
      chart: charts.BarChart(
        ccStatSeries(ccByNames(['Venusaur', 'Charizard', 'Blastoise'])),
        animate: true,
        barGroupingType: charts.BarGroupingType.stacked,
        vertical: false,
        domainAxis: ccOrdinalAxis(),
        primaryMeasureAxis: ccNumericAxis(),
      ),
    );
  }
}

/// N07: agrupadas y apiladas a la vez.
class CommunityNormal07 extends StatelessWidget {
  const CommunityNormal07({super.key});

  @override
  Widget build(BuildContext context) {
    final pokes = ccByNames(['Charizard', 'Blastoise', 'Venusaur', 'Gengar']);
    // seriesCategory separa las pilas (físico / especial)
    charts.Series<CcPoke, String> s(String id, num Function(CcPoke) f,
            Color c, String category) =>
        charts.Series<CcPoke, String>(
          id: id,
          data: pokes,
          domainFn: (p, _) => p.name,
          measureFn: (p, _) => f(p),
          colorFn: (_, _) => ccColor(c),
          seriesCategory: category,
        );
    return CommunityChartCard(
      code: 'N07',
      title: 'Físico vs. especial (agrupado y apilado)',
      description: 'seriesCategory + BarGroupingType.groupedStacked.',
      chart: charts.BarChart(
        [
          s('Ataque', (p) => p.attack, Colors.red, 'Físico'),
          s('Defensa', (p) => p.defense, Colors.orange, 'Físico'),
          s('At. Esp.', (p) => p.spAtk, Colors.blue, 'Especial'),
          s('Def. Esp.', (p) => p.spDef, Colors.lightBlue, 'Especial'),
        ],
        animate: true,
        barGroupingType: charts.BarGroupingType.groupedStacked,
        domainAxis: ccOrdinalAxis(),
        primaryMeasureAxis: ccNumericAxis(),
      ),
    );
  }
}

/// N08: esquinas redondeadas.
class CommunityNormal08 extends StatelessWidget {
  const CommunityNormal08({super.key});

  @override
  Widget build(BuildContext context) {
    return CommunityChartCard(
      code: 'N08',
      title: 'Los más pesados, color por tipo',
      description:
          'defaultRenderer: BarRendererConfig con ConstCornerStrategy.',
      chart: charts.BarChart(
        [ccPokeSeries('Peso', ccTopBy((p) => p.weight, 10), (p) => p.weight)],
        animate: true,
        defaultRenderer: charts.BarRendererConfig(
          cornerStrategy: const charts.ConstCornerStrategy(8),
        ),
        domainAxis: ccOrdinalAxis(labelRotation: 45),
        primaryMeasureAxis: ccNumericAxis(),
      ),
    );
  }
}

/// N09: solo el borde (barras huecas).
class CommunityNormal09 extends StatelessWidget {
  const CommunityNormal09({super.key});

  @override
  Widget build(BuildContext context) {
    final pokes = ccByNames(
        ['Bulbasaur', 'Charmander', 'Squirtle', 'Pikachu', 'Eevee']);
    return CommunityChartCard(
      code: 'N09',
      title: 'Iniciales: defensa hueca vs. ataque lleno',
      description: 'fillColorFn transparente + strokeWidthPx en el renderer.',
      chart: charts.BarChart(
        [
          ccPokeSeries('Ataque', pokes, (p) => p.attack, color: Colors.red),
          charts.Series<CcPoke, String>(
            id: 'Defensa',
            data: pokes,
            domainFn: (p, _) => p.name,
            measureFn: (p, _) => p.defense,
            // colorFn = borde, fillColorFn = relleno
            colorFn: (_, _) => ccColor(Colors.blue),
            fillColorFn: (_, _) => charts.MaterialPalette.transparent,
          ),
        ],
        animate: true,
        defaultRenderer: charts.BarRendererConfig(
          groupingType: charts.BarGroupingType.grouped,
          strokeWidthPx: 2.0,
        ),
        domainAxis: ccOrdinalAxis(),
        primaryMeasureAxis: ccNumericAxis(),
      ),
    );
  }
}

/// N10: patrón rayado.
class CommunityNormal10 extends StatelessWidget {
  const CommunityNormal10({super.key});

  @override
  Widget build(BuildContext context) {
    final pokes = ccByNames(['Alakazam', 'Gengar', 'Mewtwo', 'Raichu']);
    return CommunityChartCard(
      code: 'N10',
      title: 'Ataque especial rayado',
      description: 'fillPatternFn: FillPatternType.forwardHatch.',
      chart: charts.BarChart(
        [
          ccPokeSeries('Ataque', pokes, (p) => p.attack, color: Colors.red),
          charts.Series<CcPoke, String>(
            id: 'At. Esp.',
            data: pokes,
            domainFn: (p, _) => p.name,
            measureFn: (p, _) => p.spAtk,
            colorFn: (_, _) => ccColor(Colors.deepPurple),
            fillPatternFn: (_, _) => charts.FillPatternType.forwardHatch,
          ),
        ],
        animate: true,
        barGroupingType: charts.BarGroupingType.grouped,
        domainAxis: ccOrdinalAxis(),
        primaryMeasureAxis: ccNumericAxis(),
      ),
    );
  }
}
