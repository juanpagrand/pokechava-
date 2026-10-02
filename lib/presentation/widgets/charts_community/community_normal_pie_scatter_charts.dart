// ===========================================================================
// community_normal_pie_scatter_charts.dart — NORMALES N19–N29
// ===========================================================================
//   N19–N24 tortas: charts.PieChart. Cada DATO es una tajada; el dominio es
//           su nombre y la medida su tamaño. La forma (dona, media torta,
//           medidor) se decide en ArcRendererConfig.
//   N25–N29 dispersión: charts.ScatterPlotChart. Dominio Y medida numéricos:
//           cada dato es un punto (x, y). radiusPxFn da el tamaño.
// ===========================================================================

import 'dart:math' as math;

import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:flutter/material.dart';

import 'community_chart_card.dart';
import 'community_data.dart';

/// La serie de los tipos de Kanto: una tajada por tipo.
charts.Series<CcSlice, String> ccTypeSlices({bool withLabels = false}) {
  return charts.Series<CcSlice, String>(
    id: 'Tipos de Kanto',
    data: kCcKantoTypes,
    domainFn: (CcSlice s, _) => s.label,
    measureFn: (CcSlice s, _) => s.value,
    colorFn: (CcSlice s, _) => ccColor(s.color),
    labelAccessorFn: withLabels ? (CcSlice s, _) => '${s.label}: ${s.value}' : null,
  );
}

/// N19: torta.
class CommunityNormal19 extends StatelessWidget {
  const CommunityNormal19({super.key});

  @override
  Widget build(BuildContext context) {
    return CommunityChartCard(
      code: 'N19',
      title: 'Tipos de Kanto (torta)',
      description: 'charts.PieChart: cada dato es una tajada.',
      // PieChart<String>: el tipo es el del dominio (el nombre del tipo).
      chart: charts.PieChart<String>([ccTypeSlices()], animate: true),
    );
  }
}

/// N20: dona.
class CommunityNormal20 extends StatelessWidget {
  const CommunityNormal20({super.key});

  @override
  Widget build(BuildContext context) {
    return CommunityChartCard(
      code: 'N20',
      title: 'Tipos de Kanto (dona)',
      description: 'ArcRendererConfig(arcWidth: 50): solo un anillo de 50 px.',
      chart: charts.PieChart<String>(
        [ccTypeSlices()],
        animate: true,
        defaultRenderer: charts.ArcRendererConfig(arcWidth: 50),
      ),
    );
  }
}

/// N21: dona con etiquetas automáticas.
class CommunityNormal21 extends StatelessWidget {
  const CommunityNormal21({super.key});

  @override
  Widget build(BuildContext context) {
    return CommunityChartCard(
      code: 'N21',
      title: 'Tipos con etiqueta dentro',
      description: 'ArcLabelDecorator escribe labelAccessorFn en cada tajada.',
      height: 280,
      chart: charts.PieChart<String>(
        [ccTypeSlices(withLabels: true)],
        animate: true,
        defaultRenderer: charts.ArcRendererConfig(
          arcWidth: 70,
          arcRendererDecorators: [
            charts.ArcLabelDecorator(
              insideLabelStyleSpec: const charts.TextStyleSpec(
                  fontSize: 9, color: charts.MaterialPalette.white),
              outsideLabelStyleSpec: ccLabelStyle(fontSize: 9),
            ),
          ],
        ),
      ),
    );
  }
}

/// N22: torta con etiquetas por fuera.
class CommunityNormal22 extends StatelessWidget {
  const CommunityNormal22({super.key});

  @override
  Widget build(BuildContext context) {
    return CommunityChartCard(
      code: 'N22',
      title: 'Tipos con etiqueta afuera',
      description: 'ArcLabelPosition.outside: la etiqueta sale con una línea guía.',
      height: 280,
      chart: charts.PieChart<String>(
        [ccTypeSlices(withLabels: true)],
        animate: true,
        defaultRenderer: charts.ArcRendererConfig(
          arcRendererDecorators: [
            charts.ArcLabelDecorator(
              labelPosition: charts.ArcLabelPosition.outside,
              outsideLabelStyleSpec: ccLabelStyle(fontSize: 9),
            ),
          ],
        ),
      ),
    );
  }
}

/// N23: torta parcial (tres cuartos).
class CommunityNormal23 extends StatelessWidget {
  const CommunityNormal23({super.key});

  @override
  Widget build(BuildContext context) {
    final p = ccByName('Mewtwo');
    return CommunityChartCard(
      code: 'N23',
      title: 'Mewtwo: sus 680 puntos en 3/4 de círculo',
      description: 'arcLength: 3/2·π. El círculo completo sería 2·π.',
      chart: charts.PieChart<String>(
        [
          charts.Series<int, String>(
            id: 'Mewtwo',
            // Los datos son los índices 0…5; con ellos se busca nombre y valor.
            data: List.generate(6, (i) => i),
            domainFn: (i, _) => kCcStatNames[i],
            measureFn: (i, _) => p.stats[i],
            colorFn: (i, _) => ccColor(kCcStatColors[i]),
          ),
        ],
        animate: true,
        defaultRenderer: charts.ArcRendererConfig(arcLength: 3 / 2 * math.pi),
      ),
    );
  }
}

/// N24: medidor (gauge).
class CommunityNormal24 extends StatelessWidget {
  const CommunityNormal24({super.key});

  @override
  Widget build(BuildContext context) {
    final p = ccByName('Alakazam');
    final parts = [
      CcSlice('Velocidad', p.speed, Colors.green),
      CcSlice('Hasta 160', 160 - p.speed, Colors.grey.withValues(alpha: 0.3)),
    ];
    return CommunityChartCard(
      code: 'N24',
      title: 'Velocímetro: Alakazam (${p.speed} de 160)',
      description: 'Arco de 7/5·π que empieza en 4/5·π: forma de medidor.',
      height: 200,
      chart: charts.PieChart<String>(
        [
          charts.Series<CcSlice, String>(
            id: 'Medidor',
            data: parts,
            domainFn: (s, _) => s.label,
            measureFn: (s, _) => s.value,
            colorFn: (s, _) => ccColor(s.color),
          ),
        ],
        animate: true,
        defaultRenderer: charts.ArcRendererConfig(
          arcWidth: 30,
          startAngle: 4 / 5 * math.pi,
          arcLength: 7 / 5 * math.pi,
        ),
      ),
    );
  }
}

/// Serie de dispersión con dos medidas numéricas de cada Pokémon.
charts.Series<CcPoke, num> ccScatter(
  String id,
  num Function(CcPoke) x,
  num Function(CcPoke) y, {
  List<CcPoke>? pokes,
  double Function(CcPoke)? radius,
  Color? color,
}) {
  return charts.Series<CcPoke, num>(
    id: id,
    data: pokes ?? kCcPokes,
    domainFn: (p, _) => x(p),
    measureFn: (p, _) => y(p),
    colorFn: (p, _) => color != null ? ccColor(color) : ccTypeColor(p.type),
    radiusPxFn: radius == null ? null : (p, _) => radius(p),
  );
}

/// N25: dispersión simple.
class CommunityNormal25 extends StatelessWidget {
  const CommunityNormal25({super.key});

  @override
  Widget build(BuildContext context) {
    return CommunityChartCard(
      code: 'N25',
      title: 'Altura vs. peso',
      description: 'charts.ScatterPlotChart: un punto por Pokémon.',
      chart: charts.ScatterPlotChart(
        [ccScatter('Pokémon', (p) => p.height, (p) => p.weight,
            color: Colors.indigo)],
        animate: true,
        domainAxis: ccNumericAxis(),
        primaryMeasureAxis: ccNumericAxis(),
      ),
    );
  }
}

/// N26: burbujas.
class CommunityNormal26 extends StatelessWidget {
  const CommunityNormal26({super.key});

  @override
  Widget build(BuildContext context) {
    return CommunityChartCard(
      code: 'N26',
      title: 'Ataque vs. defensa, radio = experiencia',
      description: 'radiusPxFn convierte una tercera variable en tamaño.',
      chart: charts.ScatterPlotChart(
        [
          ccScatter('Pokémon', (p) => p.attack, (p) => p.defense,
              // 340 de experiencia ≈ 12 px de radio.
              radius: (p) => 3 + p.baseExp / 40),
        ],
        animate: true,
        domainAxis: ccNumericAxis(),
        primaryMeasureAxis: ccNumericAxis(),
      ),
    );
  }
}

/// N27: puntos huecos.
class CommunityNormal27 extends StatelessWidget {
  const CommunityNormal27({super.key});

  @override
  Widget build(BuildContext context) {
    return CommunityChartCard(
      code: 'N27',
      title: 'HP vs. defensa especial (huecos)',
      description: 'fillColorFn transparente + strokeWidthPxFn: solo el borde.',
      chart: charts.ScatterPlotChart(
        [
          charts.Series<CcPoke, num>(
            id: 'Pokémon',
            data: kCcPokes,
            domainFn: (p, _) => p.hp,
            measureFn: (p, _) => p.spDef,
            colorFn: (_, _) => ccColor(Colors.deepOrange),
            fillColorFn: (_, _) => charts.MaterialPalette.transparent,
            strokeWidthPxFn: (_, _) => 2,
            radiusPxFn: (_, _) => 6,
          ),
        ],
        animate: true,
        domainAxis: ccNumericAxis(),
        primaryMeasureAxis: ccNumericAxis(),
      ),
    );
  }
}

/// N28: color por cuantil.
class CommunityNormal28 extends StatelessWidget {
  const CommunityNormal28({super.key});

  @override
  Widget build(BuildContext context) {
    return CommunityChartCard(
      code: 'N28',
      title: 'Velocidad vs. ataque especial, color por total',
      description: 'colorFn con lógica: verde < 400 ≤ ámbar < 500 ≤ rojo.',
      chart: charts.ScatterPlotChart(
        [
          charts.Series<CcPoke, num>(
            id: 'Pokémon',
            data: kCcPokes,
            domainFn: (p, _) => p.speed,
            measureFn: (p, _) => p.spAtk,
            colorFn: (p, _) => ccColor(p.total < 400
                ? Colors.green
                : p.total < 500
                    ? Colors.amber
                    : Colors.red),
            radiusPxFn: (_, _) => 6,
          ),
        ],
        animate: true,
        domainAxis: ccNumericAxis(),
        primaryMeasureAxis: ccNumericAxis(),
      ),
    );
  }
}

/// N29: dos series en la misma dispersión.
class CommunityNormal29 extends StatelessWidget {
  const CommunityNormal29({super.key});

  @override
  Widget build(BuildContext context) {
    final fisicos = kCcPokes.where((p) => p.attack >= p.spAtk).toList();
    final especiales = kCcPokes.where((p) => p.attack < p.spAtk).toList();
    return CommunityChartCard(
      code: 'N29',
      title: 'Atacantes físicos vs. especiales',
      description: 'Dos series = dos colores; la leyenda dice cuál es cuál.',
      chart: charts.ScatterPlotChart(
        [
          ccScatter('Físicos', (p) => p.attack, (p) => p.spAtk,
              pokes: fisicos, color: Colors.red),
          ccScatter('Especiales', (p) => p.attack, (p) => p.spAtk,
              pokes: especiales, color: Colors.blue),
        ],
        animate: true,
        behaviors: [
          charts.SeriesLegend(entryTextStyle: ccLegendStyle()),
        ],
        domainAxis: ccNumericAxis(),
        primaryMeasureAxis: ccNumericAxis(),
      ),
    );
  }
}
