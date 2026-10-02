// Normales N11–N18: líneas y áreas.
// LineChart necesita dominio numérico (num), no nombres.

import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:flutter/material.dart';

import 'community_chart_card.dart';
import 'community_data.dart';

/// Serie por generación (x = número de generación).
charts.Series<CcGeneration, num> ccGenSeries(
  String id,
  num Function(CcGeneration g, int index) measure, {
  Color color = Colors.indigo,
}) {
  return charts.Series<CcGeneration, num>(
    id: id,
    data: kCcGenerations,
    domainFn: (CcGeneration g, _) => g.number,
    // el índice sirve para el acumulado
    measureFn: (CcGeneration g, int? i) => measure(g, i ?? 0),
    colorFn: (_, _) => ccColor(color),
  );
}

/// Una estadística de los 23 (x = posición en la lista).
charts.Series<CcPoke, num> ccIndexSeries(
    String id, int Function(CcPoke) measure, Color color) {
  return charts.Series<CcPoke, num>(
    id: id,
    data: kCcPokes,
    domainFn: (_, int? i) => i ?? 0,
    measureFn: (CcPoke p, _) => measure(p),
    colorFn: (_, _) => ccColor(color),
  );
}

/// N11: línea simple.
class CommunityNormal11 extends StatelessWidget {
  const CommunityNormal11({super.key});

  @override
  Widget build(BuildContext context) {
    return CommunityChartCard(
      code: 'N11',
      title: 'Pokémon nuevos por generación',
      description: 'charts.LineChart con una serie de dominio numérico.',
      chart: charts.LineChart(
        [ccGenSeries('Nuevos', (g, _) => g.newPokemon)],
        animate: true,
        domainAxis: ccNumericAxis(),
        primaryMeasureAxis: ccNumericAxis(),
      ),
    );
  }
}

/// N12: línea con puntos (Pokédex acumulada).
class CommunityNormal12 extends StatelessWidget {
  const CommunityNormal12({super.key});

  @override
  Widget build(BuildContext context) {
    final cumulative = kCcCumulative;
    final total = ccGenSeries('Total', (_, i) => cumulative[i],
        color: Colors.deepOrange);
    return CommunityChartCard(
      code: 'N12',
      title: 'La Pokédex crece: 151 → 1025',
      description: 'Línea + la misma serie dibujada con PointRendererConfig.',
      chart: charts.LineChart(
        [
          total,
          // puntos aparte, ver ccPointsOf
          ccPointsOf(total),
        ],
        animate: true,
        customSeriesRenderers: [ccPointRenderer<num>()],
        domainAxis: ccNumericAxis(),
        primaryMeasureAxis: ccNumericAxis(),
      ),
    );
  }
}

/// N13: líneas punteadas, una por línea evolutiva.
class CommunityNormal13 extends StatelessWidget {
  const CommunityNormal13({super.key});

  @override
  Widget build(BuildContext context) {
    charts.Series<CcPoke, num> line(String id, List<String> names, Color c,
            List<int>? dash) =>
        charts.Series<CcPoke, num>(
          id: id,
          data: ccByNames(names),
          domainFn: (_, int? i) => (i ?? 0) + 1,
          measureFn: (p, _) => p.total,
          colorFn: (_, _) => ccColor(c),
          // [trazo, hueco] en px
          dashPatternFn: dash == null ? null : (_, _) => dash,
        );
    return CommunityChartCard(
      code: 'N13',
      title: 'Total al evolucionar, con guiones',
      description: 'dashPatternFn en la serie: [8, 3] o [2, 2].',
      chart: charts.LineChart(
        [
          line('Bulbasaur', ['Bulbasaur', 'Ivysaur', 'Venusaur'],
              const Color(0xFF5FA845), null),
          line('Charmander', ['Charmander', 'Charmeleon', 'Charizard'],
              const Color(0xFFEE7F30), [8, 3]),
          line('Squirtle', ['Squirtle', 'Wartortle', 'Blastoise'],
              const Color(0xFF4F86E8), [2, 2]),
        ],
        animate: true,
        domainAxis: ccNumericAxis(desiredTickCount: 3),
        // zeroBound: false para que no arranque en 0
        primaryMeasureAxis: charts.NumericAxisSpec(
          tickProviderSpec:
              const charts.BasicNumericTickProviderSpec(zeroBound: false),
          renderSpec: charts.GridlineRendererSpec(
            labelStyle: ccLabelStyle(),
            lineStyle: charts.LineStyleSpec(color: ccGridGray),
          ),
        ),
      ),
    );
  }
}

/// N14: área.
class CommunityNormal14 extends StatelessWidget {
  const CommunityNormal14({super.key});

  @override
  Widget build(BuildContext context) {
    return CommunityChartCard(
      code: 'N14',
      title: 'HP a lo largo de la lista',
      description: 'LineRendererConfig(includeArea: true).',
      chart: charts.LineChart(
        [ccIndexSeries('HP', (p) => p.hp, Colors.green)],
        animate: true,
        defaultRenderer: charts.LineRendererConfig(includeArea: true),
        domainAxis: ccNumericAxis(),
        primaryMeasureAxis: ccNumericAxis(),
      ),
    );
  }
}

/// N15: áreas apiladas.
class CommunityNormal15 extends StatelessWidget {
  const CommunityNormal15({super.key});

  @override
  Widget build(BuildContext context) {
    return CommunityChartCard(
      code: 'N15',
      title: 'HP + Ataque + Defensa apilados',
      description: 'includeArea + stacked: cada serie se suma a la anterior.',
      chart: charts.LineChart(
        [
          ccIndexSeries('HP', (p) => p.hp, kCcStatColors[0]),
          ccIndexSeries('Ataque', (p) => p.attack, kCcStatColors[1]),
          ccIndexSeries('Defensa', (p) => p.defense, kCcStatColors[2]),
        ],
        animate: true,
        defaultRenderer:
            charts.LineRendererConfig(includeArea: true, stacked: true),
        domainAxis: ccNumericAxis(),
        primaryMeasureAxis: ccNumericAxis(),
      ),
    );
  }
}

/// N16: área con color propio, distinto de la línea.
class CommunityNormal16 extends StatelessWidget {
  const CommunityNormal16({super.key});

  @override
  Widget build(BuildContext context) {
    return CommunityChartCard(
      code: 'N16',
      title: 'Ataque especial con relleno claro',
      description: 'areaColorFn: el área no tiene que ser del color de la línea.',
      chart: charts.LineChart(
        [
          charts.Series<CcPoke, num>(
            id: 'At. Esp.',
            data: kCcPokes,
            domainFn: (_, int? i) => i ?? 0,
            measureFn: (p, _) => p.spAtk,
            colorFn: (_, _) => ccColor(Colors.deepPurple),
            areaColorFn: (_, _) =>
                charts.MaterialPalette.purple.shadeDefault.lighter,
          ),
        ],
        animate: true,
        defaultRenderer: charts.LineRendererConfig(includeArea: true),
        domainAxis: ccNumericAxis(),
        primaryMeasureAxis: ccNumericAxis(),
      ),
    );
  }
}

/// N17: un color por tramo de la línea.
class CommunityNormal17 extends StatelessWidget {
  const CommunityNormal17({super.key});

  @override
  Widget build(BuildContext context) {
    // color según la consola de cada generación
    Color console(int gen) => switch (gen) {
          <= 2 => Colors.green,
          3 => Colors.indigo,
          <= 5 => Colors.blueGrey,
          <= 7 => Colors.red,
          _ => Colors.orange,
        };
    final nuevos = charts.Series<CcGeneration, num>(
      id: 'Nuevos',
      data: kCcGenerations,
      domainFn: (g, _) => g.number,
      measureFn: (g, _) => g.newPokemon,
      colorFn: (g, _) => ccColor(console(g.number)),
    );
    return CommunityChartCard(
      code: 'N17',
      title: 'Nuevos por generación, color por consola',
      description:
          'colorFn por DATO: cada tramo toma el color del punto donde empieza.',
      chart: charts.LineChart(
        [nuevos, ccPointsOf(nuevos)],
        animate: true,
        customSeriesRenderers: [ccPointRenderer<num>()],
        domainAxis: ccNumericAxis(),
        primaryMeasureAxis: ccNumericAxis(),
      ),
    );
  }
}

/// N18: grosor de línea distinto por serie.
class CommunityNormal18 extends StatelessWidget {
  const CommunityNormal18({super.key});

  @override
  Widget build(BuildContext context) {
    charts.Series<CcPoke, num> s(
            String id, int Function(CcPoke) f, Color c, double width) =>
        charts.Series<CcPoke, num>(
          id: id,
          data: kCcPokes,
          domainFn: (_, int? i) => i ?? 0,
          measureFn: (p, _) => f(p),
          colorFn: (_, _) => ccColor(c),
          strokeWidthPxFn: (_, _) => width,
        );
    return CommunityChartCard(
      code: 'N18',
      title: 'Velocidad (gruesa) contra defensa (fina)',
      description: 'strokeWidthPxFn: el grosor también es un dato de la serie.',
      chart: charts.LineChart(
        [
          s('Velocidad', (p) => p.speed, Colors.teal, 4),
          s('Defensa', (p) => p.defense, Colors.blueGrey, 1),
        ],
        animate: true,
        domainAxis: ccNumericAxis(),
        primaryMeasureAxis: ccNumericAxis(),
      ),
    );
  }
}
