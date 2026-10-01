import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'syncfusion_data_models.dart';

/// Gráfico 21: Dispersión Básica (Peso vs Altura en Pokémon Roca / Acero)
class SfScatterChartWidget01 extends StatelessWidget {
  const SfScatterChartWidget01({super.key});

  @override
  Widget build(BuildContext context) {
    final List<NumericChartPoint> data = [
      const NumericChartPoint(20, 0.4, 'Geodude'),
      const NumericChartPoint(105, 1.0, 'Graveler'),
      const NumericChartPoint(300, 1.4, 'Golem'),
      const NumericChartPoint(210, 8.8, 'Onix'),
      const NumericChartPoint(400, 9.2, 'Steelix'),
      const NumericChartPoint(220, 2.1, 'Rhydon'),
      const NumericChartPoint(280, 2.4, 'Rhyperior'),
    ];

    return SizedBox(
      height: 320,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Gráfico 21: Dispersión - Peso vs Altura (Roca / Acero)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SfCartesianChart(
                  primaryXAxis: const NumericAxis(title: AxisTitle(text: 'Peso (kg)')),
                  primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Altura (m)')),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CartesianSeries<NumericChartPoint, num>>[
                    ScatterSeries<NumericChartPoint, num>(
                      name: 'Especies',
                      dataSource: data,
                      xValueMapper: (NumericChartPoint p, _) => p.x,
                      yValueMapper: (NumericChartPoint p, _) => p.y,
                      color: Colors.brown,
                      markerSettings: const MarkerSettings(
                        isVisible: true,
                        width: 10,
                        height: 10,
                        shape: DataMarkerType.circle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Gráfico 22: Dispersión con Marcadores Distintos (Ataque vs Velocidad)
class SfScatterChartWidget02 extends StatelessWidget {
  const SfScatterChartWidget02({super.key});

  @override
  Widget build(BuildContext context) {
    // Tipo Lucha: Alto Ataque, Media/Baja Velocidad
    final List<NumericChartPoint> fightingData = [
      const NumericChartPoint(80, 55),
      const NumericChartPoint(100, 45),
      const NumericChartPoint(130, 55),
      const NumericChartPoint(120, 85),
      const NumericChartPoint(125, 45),
    ];

    // Tipo Fantasma: Ataque variable, Alta Velocidad
    final List<NumericChartPoint> ghostData = [
      const NumericChartPoint(50, 95),
      const NumericChartPoint(65, 110),
      const NumericChartPoint(65, 130),
      const NumericChartPoint(100, 105),
      const NumericChartPoint(110, 80),
    ];

    return SizedBox(
      height: 330,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Gráfico 22: Dispersión Múltiple - Ataque vs Velocidad (Lucha vs Fantasma)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SfCartesianChart(
                  legend: const Legend(isVisible: true, position: LegendPosition.top),
                  primaryXAxis: const NumericAxis(title: AxisTitle(text: 'Ataque')),
                  primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Velocidad')),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CartesianSeries<NumericChartPoint, num>>[
                    ScatterSeries<NumericChartPoint, num>(
                      name: 'Tipo Lucha',
                      dataSource: fightingData,
                      xValueMapper: (NumericChartPoint p, _) => p.x,
                      yValueMapper: (NumericChartPoint p, _) => p.y,
                      color: Colors.deepOrange,
                      markerSettings: const MarkerSettings(
                        isVisible: true,
                        width: 11,
                        height: 11,
                        shape: DataMarkerType.diamond,
                      ),
                    ),
                    ScatterSeries<NumericChartPoint, num>(
                      name: 'Tipo Fantasma',
                      dataSource: ghostData,
                      xValueMapper: (NumericChartPoint p, _) => p.x,
                      yValueMapper: (NumericChartPoint p, _) => p.y,
                      color: Colors.purple,
                      markerSettings: const MarkerSettings(
                        isVisible: true,
                        width: 10,
                        height: 10,
                        shape: DataMarkerType.circle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Gráfico 23: Dispersión HP vs Defensa (Identificación de Tanques Defensivos)
class SfScatterChartWidget03 extends StatelessWidget {
  const SfScatterChartWidget03({super.key});

  @override
  Widget build(BuildContext context) {
    final List<NumericChartPoint> data = [
      const NumericChartPoint(255, 10, 'Blissey'),
      const NumericChartPoint(250, 5, 'Chansey'),
      const NumericChartPoint(160, 110, 'Snorlax'),
      const NumericChartPoint(50, 230, 'Shuckle'),
      const NumericChartPoint(80, 100, 'Venusaur'),
      const NumericChartPoint(90, 85, 'Lapras'),
      const NumericChartPoint(100, 120, 'Slowbro'),
    ];

    return SizedBox(
      height: 320,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Gráfico 23: Dispersión - HP vs Defensa (Identificación de Tanques)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SfCartesianChart(
                  primaryXAxis: const NumericAxis(title: AxisTitle(text: 'Puntos de Salud (HP)')),
                  primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Defensa Base')),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CartesianSeries<NumericChartPoint, num>>[
                    ScatterSeries<NumericChartPoint, num>(
                      name: 'Pokémon',
                      dataSource: data,
                      xValueMapper: (NumericChartPoint p, _) => p.x,
                      yValueMapper: (NumericChartPoint p, _) => p.y,
                      color: Colors.blueAccent,
                      markerSettings: const MarkerSettings(
                        isVisible: true,
                        width: 12,
                        height: 12,
                        shape: DataMarkerType.triangle,
                      ),
                      dataLabelSettings: const DataLabelSettings(isVisible: true),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Gráfico 24: Dispersión Stats Totales vs Nivel de Evolución
class SfScatterChartWidget04 extends StatelessWidget {
  const SfScatterChartWidget04({super.key});

  @override
  Widget build(BuildContext context) {
    final List<NumericChartPoint> data = [
      const NumericChartPoint(1, 300),
      const NumericChartPoint(1, 318),
      const NumericChartPoint(1, 309),
      const NumericChartPoint(1, 314),
      const NumericChartPoint(2, 405),
      const NumericChartPoint(2, 420),
      const NumericChartPoint(2, 405),
      const NumericChartPoint(3, 525),
      const NumericChartPoint(3, 534),
      const NumericChartPoint(3, 530),
      const NumericChartPoint(3, 600),
    ];

    return SizedBox(
      height: 320,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Gráfico 24: Dispersión - Total Stats vs Etapa Evolutiva (1, 2, 3)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SfCartesianChart(
                  primaryXAxis: const NumericAxis(
                    title: AxisTitle(text: 'Etapa Evolutiva'),
                    interval: 1,
                    minimum: 0.5,
                    maximum: 3.5,
                  ),
                  primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Base Stat Total')),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CartesianSeries<NumericChartPoint, num>>[
                    ScatterSeries<NumericChartPoint, num>(
                      name: 'Stats',
                      dataSource: data,
                      xValueMapper: (NumericChartPoint p, _) => p.x,
                      yValueMapper: (NumericChartPoint p, _) => p.y,
                      color: Colors.greenAccent[700],
                      markerSettings: const MarkerSettings(
                        isVisible: true,
                        width: 10,
                        height: 10,
                        shape: DataMarkerType.circle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Gráfico 25: Dispersión Especial (Atq Especial vs Def Especial en Tipo Psíquico)
class SfScatterChartWidget05 extends StatelessWidget {
  const SfScatterChartWidget05({super.key});

  @override
  Widget build(BuildContext context) {
    final List<NumericChartPoint> data = [
      const NumericChartPoint(135, 95, 'Alakazam'),
      const NumericChartPoint(154, 90, 'Mewtwo'),
      const NumericChartPoint(100, 100, 'Mew'),
      const NumericChartPoint(105, 120, 'Gardevoir'),
      const NumericChartPoint(125, 115, 'Espeon'),
      const NumericChartPoint(90, 110, 'Hypno'),
    ];

    return SizedBox(
      height: 320,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Gráfico 25: Dispersión Especial - Sp. Atk vs Sp. Def (Psíquicos)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SfCartesianChart(
                  primaryXAxis: const NumericAxis(title: AxisTitle(text: 'Ataque Especial')),
                  primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Defensa Especial')),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CartesianSeries<NumericChartPoint, num>>[
                    ScatterSeries<NumericChartPoint, num>(
                      name: 'Psíquicos',
                      dataSource: data,
                      xValueMapper: (NumericChartPoint p, _) => p.x,
                      yValueMapper: (NumericChartPoint p, _) => p.y,
                      color: Colors.pink,
                      markerSettings: const MarkerSettings(
                        isVisible: true,
                        width: 11,
                        height: 11,
                        shape: DataMarkerType.pentagon,
                      ),
                      dataLabelSettings: const DataLabelSettings(isVisible: true),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
