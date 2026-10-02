// ===========================================================================
// community_advanced_data_charts.dart — AVANZADOS A19–A25
// ===========================================================================
//   A19 PercentInjector: cada columna se convierte a 100 %
//   A20 porcentaje por categoría (físico / especial)
//   A21 datos que cambian con botones (setState + animate)
//   A22 tiempo real con Timer
//   A23 leyenda con un ícono propio (CustomSymbolRenderer)
//   A24 etiquetas con estilo según el valor (dentro / fuera de la barra)
//   A25 dispersión + línea de tendencia calculada en Dart
// ===========================================================================

import 'dart:async';
import 'dart:math' as math;

import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:flutter/material.dart';

import 'community_chart_card.dart';
import 'community_data.dart';
import 'community_normal_bar_charts.dart' show ccPokeSeries, ccStatSeries;

/// A19: 100 % apilado.
class CommunityAdvanced19 extends StatelessWidget {
  const CommunityAdvanced19({super.key});

  @override
  Widget build(BuildContext context) {
    return CommunityChartCard(
      code: 'A19',
      title: 'Composición al 100 %',
      description:
          'PercentInjector(domain) recalcula cada barra a % + PercentAxisSpec.',
      height: 280,
      chart: charts.BarChart(
        ccStatSeries(ccTopBy((p) => p.total, 6)),
        animate: true,
        barGroupingType: charts.BarGroupingType.stacked,
        behaviors: [
          // domain = el 100 % es el total de cada Pokémon (cada columna).
          charts.PercentInjector(
              totalType: charts.PercentInjectorTotalType.domain),
        ],
        // Un eje que escribe 0 %…100 % en lugar de números.
        primaryMeasureAxis: charts.PercentAxisSpec(
          renderSpec: charts.GridlineRendererSpec(
            labelStyle: ccLabelStyle(),
            lineStyle: charts.LineStyleSpec(color: ccGridGray),
          ),
        ),
        domainAxis: ccOrdinalAxis(labelRotation: 45),
      ),
    );
  }
}

/// A20: porcentaje por categoría.
class CommunityAdvanced20 extends StatelessWidget {
  const CommunityAdvanced20({super.key});

  @override
  Widget build(BuildContext context) {
    final pokes = ccByNames(['Machamp', 'Alakazam', 'Onix', 'Gengar']);
    charts.Series<CcPoke, String> s(String id, int Function(CcPoke) f, Color c,
            String cat) =>
        charts.Series<CcPoke, String>(
          id: id,
          data: pokes,
          domainFn: (p, _) => p.name,
          measureFn: (p, _) => f(p),
          colorFn: (_, _) => ccColor(c),
          seriesCategory: cat,
        );
    return CommunityChartCard(
      code: 'A20',
      title: 'Ofensa vs. defensa, cada pila al 100 %',
      description:
          'groupedStacked + PercentInjector(domainBySeriesCategory).',
      chart: charts.BarChart(
        [
          s('Ataque', (p) => p.attack, Colors.red, 'Ofensa'),
          s('At. Esp.', (p) => p.spAtk, Colors.orange, 'Ofensa'),
          s('Defensa', (p) => p.defense, Colors.blue, 'Defensa'),
          s('Def. Esp.', (p) => p.spDef, Colors.lightBlue, 'Defensa'),
        ],
        animate: true,
        barGroupingType: charts.BarGroupingType.groupedStacked,
        behaviors: [
          charts.PercentInjector(
              totalType:
                  charts.PercentInjectorTotalType.domainBySeriesCategory),
          charts.SeriesLegend(entryTextStyle: ccLegendStyle()),
        ],
        primaryMeasureAxis: charts.PercentAxisSpec(
          renderSpec: charts.GridlineRendererSpec(labelStyle: ccLabelStyle()),
        ),
        domainAxis: ccOrdinalAxis(),
      ),
    );
  }
}

/// A21: datos que cambian con botones.
class CommunityAdvanced21 extends StatefulWidget {
  const CommunityAdvanced21({super.key});

  @override
  State<CommunityAdvanced21> createState() => _CommunityAdvanced21State();
}

class _CommunityAdvanced21State extends State<CommunityAdvanced21> {
  // Qué estadística se muestra: índice dentro de kCcStatNames.
  int _stat = 1;

  @override
  Widget build(BuildContext context) {
    final top = ccTopBy((p) => p.stats[_stat], 8);
    return CommunityChartCard(
      code: 'A21',
      title: 'Top 8 de la estadística que elijas',
      description:
          'setState cambia la serie; animate: true anima el paso de una a otra.',
      controls: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [
          for (var i = 0; i < kCcStatNames.length; i++)
            ChoiceChip(
              label: Text(kCcStatNames[i], style: const TextStyle(fontSize: 11)),
              selected: _stat == i,
              visualDensity: VisualDensity.compact,
              onSelected: (_) => setState(() => _stat = i),
            ),
        ],
      ),
      chart: charts.BarChart(
        [
          ccPokeSeries(kCcStatNames[_stat], top, (p) => p.stats[_stat],
              color: kCcStatColors[_stat]),
        ],
        animate: true,
        animationDuration: const Duration(milliseconds: 500),
        domainAxis: ccOrdinalAxis(labelRotation: 45),
        primaryMeasureAxis: ccNumericAxis(),
      ),
    );
  }
}

/// A22: tiempo real.
class CommunityAdvanced22 extends StatefulWidget {
  const CommunityAdvanced22({super.key});

  @override
  State<CommunityAdvanced22> createState() => _CommunityAdvanced22State();
}

class _CommunityAdvanced22State extends State<CommunityAdvanced22> {
  final _random = math.Random(7);
  final List<math.Point<int>> _points = [];
  Timer? _timer;
  int _tick = 0;
  int _hp = 115;

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < 20; i++) {
      _step();
    }
    _start();
  }

  // Jigglypuff recibe golpes y a veces se cura (datos simulados).
  void _step() {
    _tick++;
    _hp = (_hp - _random.nextInt(14) + (_tick % 8 == 0 ? 40 : 0)).clamp(0, 115);
    if (_hp == 0) _hp = 115;
    _points.add(math.Point(_tick, _hp));
    if (_points.length > 30) _points.removeAt(0);
  }

  void _start() {
    _timer = Timer.periodic(const Duration(milliseconds: 800), (_) {
      // mounted: si el widget ya no está en pantalla, no se llama setState.
      if (mounted) setState(_step);
    });
  }

  @override
  void dispose() {
    // Sin esto el Timer seguiría corriendo después de salir de la pantalla.
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final running = _timer?.isActive ?? false;
    return CommunityChartCard(
      code: 'A22',
      title: 'Batalla en vivo: HP de Jigglypuff',
      description: 'Timer.periodic + setState: un punto nuevo cada 0,8 s.',
      controls: Row(
        children: [
          FilledButton.tonalIcon(
            onPressed: () => setState(() {
              running ? _timer?.cancel() : _start();
            }),
            icon: Icon(running ? Icons.pause : Icons.play_arrow),
            label: Text(running ? 'Pausar' : 'Reanudar'),
          ),
          const SizedBox(width: 12),
          Text('HP: $_hp / 115',
              style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
      chart: charts.LineChart(
        [
          charts.Series<math.Point<int>, num>(
            id: 'HP',
            // Copia de la lista: el gráfico compara la instancia para
            // saber si cambió.
            data: List.of(_points),
            domainFn: (p, _) => p.x,
            measureFn: (p, _) => p.y,
            colorFn: (_, _) => ccColor(Colors.pink),
          ),
        ],
        // animate: false. Con un punto nuevo cada 0,8 s, animar cada cambio
        // hace que la línea "tiemble".
        animate: false,
        defaultRenderer: charts.LineRendererConfig(includeArea: true),
        domainAxis: charts.NumericAxisSpec(
          tickProviderSpec:
              const charts.BasicNumericTickProviderSpec(zeroBound: false),
          renderSpec: charts.SmallTickRendererSpec(labelStyle: ccLabelStyle()),
        ),
        primaryMeasureAxis: ccNumericAxis(),
      ),
    );
  }
}

/// Símbolo de leyenda propio: un ícono de Flutter en vez del cuadrito.
class _IconSymbol extends charts.CustomSymbolRenderer {
  final IconData icon;

  _IconSymbol(this.icon);

  @override
  Widget build(BuildContext context,
      {Size? size, Color? color, bool enabled = true}) {
    return SizedBox.fromSize(
      size: size,
      // Si la serie está oculta (enabled = false), el ícono se ve tenue.
      child: Icon(icon,
          size: 12,
          color: enabled ? color : color?.withValues(alpha: 0.3)),
    );
  }
}

/// A23: leyenda con ícono propio.
class CommunityAdvanced23 extends StatelessWidget {
  const CommunityAdvanced23({super.key});

  @override
  Widget build(BuildContext context) {
    final pokes = ccByNames(['Charizard', 'Blastoise', 'Venusaur']);
    return CommunityChartCard(
      code: 'A23',
      title: 'Leyenda con íconos',
      description:
          'CustomSymbolRenderer: un widget de Flutter como símbolo de la serie.',
      chart: charts.BarChart(
        [
          ccPokeSeries('Ataque', pokes, (p) => p.attack, color: Colors.red),
          ccPokeSeries('Defensa', pokes, (p) => p.defense, color: Colors.blue),
        ],
        animate: true,
        barGroupingType: charts.BarGroupingType.grouped,
        defaultRenderer: charts.BarRendererConfig(
          groupingType: charts.BarGroupingType.grouped,
          symbolRenderer: _IconSymbol(Icons.catching_pokemon),
        ),
        behaviors: [charts.SeriesLegend(entryTextStyle: ccLegendStyle())],
        domainAxis: ccOrdinalAxis(),
        primaryMeasureAxis: ccNumericAxis(),
      ),
    );
  }
}

/// A24: etiquetas con estilo según el valor.
class CommunityAdvanced24 extends StatelessWidget {
  const CommunityAdvanced24({super.key});

  @override
  Widget build(BuildContext context) {
    final pokes = ccTopBy((p) => p.defense, 8);
    return CommunityChartCard(
      code: 'A24',
      title: 'Defensa con etiqueta: roja si pasa de 100',
      description:
          'insideLabelStyleAccessorFn / outsideLabelStyleAccessorFn por dato.',
      height: 300,
      chart: charts.BarChart(
        [
          charts.Series<CcPoke, String>(
            id: 'Defensa',
            data: pokes,
            domainFn: (p, _) => p.name,
            measureFn: (p, _) => p.defense,
            colorFn: (p, _) => ccTypeColor(p.type),
            labelAccessorFn: (p, _) => '${p.name}: ${p.defense}',
            // Estilo cuando la etiqueta cabe DENTRO de la barra…
            insideLabelStyleAccessorFn: (p, _) => charts.TextStyleSpec(
              fontSize: 10,
              color: p.defense >= 100
                  ? ccColor(Colors.red.shade900)
                  : charts.MaterialPalette.white,
            ),
            // …y cuando tiene que ir afuera.
            outsideLabelStyleAccessorFn: (p, _) => charts.TextStyleSpec(
              fontSize: 10,
              color: p.defense >= 100 ? ccColor(Colors.red) : ccAxisGray,
            ),
          ),
        ],
        animate: true,
        vertical: false,
        barRendererDecorator: charts.BarLabelDecorator<String>(),
        // Los nombres ya van en la etiqueta: se oculta el eje de nombres.
        domainAxis:
            const charts.OrdinalAxisSpec(renderSpec: charts.NoneRenderSpec()),
        primaryMeasureAxis: ccNumericAxis(),
      ),
    );
  }
}

/// A25: dispersión + línea de tendencia.
class CommunityAdvanced25 extends StatelessWidget {
  const CommunityAdvanced25({super.key});

  @override
  Widget build(BuildContext context) {
    // Recta de mínimos cuadrados: peso ≈ a + b · altura.
    final xs = kCcPokes.map((p) => p.height).toList();
    final ys = kCcPokes.map((p) => p.weight).toList();
    final n = xs.length;
    final mx = xs.reduce((a, b) => a + b) / n;
    final my = ys.reduce((a, b) => a + b) / n;
    var sxy = 0.0, sxx = 0.0;
    for (var i = 0; i < n; i++) {
      sxy += (xs[i] - mx) * (ys[i] - my);
      sxx += (xs[i] - mx) * (xs[i] - mx);
    }
    final b = sxy / sxx;
    final a = my - b * mx;
    final maxX = xs.reduce(math.max);
    final trend = [math.Point(0.0, a), math.Point(maxX, a + b * maxX)];

    return CommunityChartCard(
      code: 'A25',
      title: '¿Más alto, más pesado? Línea de tendencia',
      description:
          'ScatterPlotChart + un LineRendererConfig propio con la recta calculada.',
      footer: Text(
        'peso ≈ ${a.toStringAsFixed(1)} + ${b.toStringAsFixed(1)} × altura',
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      chart: charts.ScatterPlotChart(
        [
          charts.Series<CcPoke, num>(
            id: 'Pokémon',
            data: kCcPokes,
            domainFn: (p, _) => p.height,
            measureFn: (p, _) => p.weight,
            colorFn: (p, _) => ccTypeColor(p.type),
            radiusPxFn: (_, _) => 5,
          ),
          charts.Series<math.Point<double>, num>(
            id: 'Tendencia',
            data: trend,
            domainFn: (p, _) => p.x,
            measureFn: (p, _) => p.y,
            colorFn: (_, _) => ccColor(Colors.red),
          )..setAttribute(charts.rendererIdKey, 'tendencia'),
        ],
        animate: true,
        customSeriesRenderers: [
          charts.LineRendererConfig(
            customRendererId: 'tendencia',
            // Se pinta después de los puntos, encima de ellos.
            layoutPaintOrder: charts.LayoutViewPaintOrder.point + 1,
          ),
        ],
        domainAxis: ccNumericAxis(),
        primaryMeasureAxis: ccNumericAxis(),
      ),
    );
  }
}
