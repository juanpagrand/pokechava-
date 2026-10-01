import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'syncfusion_data_models.dart';

/// Gráfico 06: Gráfico de Línea Simple (Curva de Experiencia por Nivel)
class SfLineChartWidget01 extends StatelessWidget {
  const SfLineChartWidget01({super.key});

  @override
  Widget build(BuildContext context) {
    final List<NumericChartPoint> data = [
      const NumericChartPoint(1, 0),
      const NumericChartPoint(10, 1000),
      const NumericChartPoint(20, 8000),
      const NumericChartPoint(30, 27000),
      const NumericChartPoint(40, 64000),
      const NumericChartPoint(50, 125000),
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
                'Gráfico 06: Línea Simple - Crecimiento de Experiencia',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SfCartesianChart(
                  primaryXAxis: const NumericAxis(title: AxisTitle(text: 'Nivel')),
                  primaryYAxis: const NumericAxis(title: AxisTitle(text: 'EXP Requerida')),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CartesianSeries<NumericChartPoint, num>>[
                    LineSeries<NumericChartPoint, num>(
                      name: 'EXP',
                      dataSource: data,
                      xValueMapper: (NumericChartPoint p, _) => p.x,
                      yValueMapper: (NumericChartPoint p, _) => p.y,
                      color: Colors.indigo,
                      width: 3,
                      markerSettings: const MarkerSettings(isVisible: true),
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

/// Gráfico 07: Gráfico de Líneas Múltiples (Curva de HP entre Pokémon)
class SfLineChartWidget02 extends StatelessWidget {
  const SfLineChartWidget02({super.key});

  @override
  Widget build(BuildContext context) {
    final List<NumericChartPoint> blisseyData = [
      const NumericChartPoint(10, 80),
      const NumericChartPoint(25, 200),
      const NumericChartPoint(50, 400),
      const NumericChartPoint(75, 600),
      const NumericChartPoint(100, 714),
    ];

    final List<NumericChartPoint> charizardData = [
      const NumericChartPoint(10, 35),
      const NumericChartPoint(25, 90),
      const NumericChartPoint(50, 180),
      const NumericChartPoint(75, 270),
      const NumericChartPoint(100, 360),
    ];

    final List<NumericChartPoint> gengarData = [
      const NumericChartPoint(10, 30),
      const NumericChartPoint(25, 75),
      const NumericChartPoint(50, 150),
      const NumericChartPoint(75, 230),
      const NumericChartPoint(100, 324),
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
                'Gráfico 07: Líneas Múltiples - Progresión de HP por Nivel',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SfCartesianChart(
                  legend: const Legend(isVisible: true, position: LegendPosition.top),
                  primaryXAxis: const NumericAxis(title: AxisTitle(text: 'Nivel')),
                  primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Puntos de Salud')),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CartesianSeries<NumericChartPoint, num>>[
                    LineSeries<NumericChartPoint, num>(
                      name: 'Blissey',
                      dataSource: blisseyData,
                      xValueMapper: (NumericChartPoint p, _) => p.x,
                      yValueMapper: (NumericChartPoint p, _) => p.y,
                      color: Colors.pinkAccent,
                      width: 2.5,
                      markerSettings: const MarkerSettings(isVisible: true),
                    ),
                    LineSeries<NumericChartPoint, num>(
                      name: 'Charizard',
                      dataSource: charizardData,
                      xValueMapper: (NumericChartPoint p, _) => p.x,
                      yValueMapper: (NumericChartPoint p, _) => p.y,
                      color: Colors.orange,
                      width: 2.5,
                      markerSettings: const MarkerSettings(isVisible: true),
                    ),
                    LineSeries<NumericChartPoint, num>(
                      name: 'Gengar',
                      dataSource: gengarData,
                      xValueMapper: (NumericChartPoint p, _) => p.x,
                      yValueMapper: (NumericChartPoint p, _) => p.y,
                      color: Colors.purple,
                      width: 2.5,
                      markerSettings: const MarkerSettings(isVisible: true),
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

/// Gráfico 08: Línea Suave / Spline (Evolución de Velocidad Media por Gen)
class SfLineChartWidget03 extends StatelessWidget {
  const SfLineChartWidget03({super.key});

  @override
  Widget build(BuildContext context) {
    final List<CategoricalChartData> data = [
      const CategoricalChartData('Gen 1', 72),
      const CategoricalChartData('Gen 2', 65),
      const CategoricalChartData('Gen 3', 75),
      const CategoricalChartData('Gen 4', 70),
      const CategoricalChartData('Gen 5', 78),
      const CategoricalChartData('Gen 6', 82),
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
                'Gráfico 08: Línea Suave (Spline) - Velocidad Media por Gen',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SfCartesianChart(
                  primaryXAxis: const CategoryAxis(),
                  primaryYAxis: const NumericAxis(minimum: 55, maximum: 90),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CartesianSeries<CategoricalChartData, String>>[
                    SplineSeries<CategoricalChartData, String>(
                      name: 'Velocidad Media',
                      dataSource: data,
                      xValueMapper: (CategoricalChartData d, _) => d.x,
                      yValueMapper: (CategoricalChartData d, _) => d.y,
                      color: Colors.teal,
                      width: 3.5,
                      markerSettings: const MarkerSettings(
                        isVisible: true,
                        shape: DataMarkerType.diamond,
                        color: Colors.tealAccent,
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

/// Gráfico 09: Línea Escalonada (Step Line - Movimientos aprendidos por Nivel)
class SfLineChartWidget04 extends StatelessWidget {
  const SfLineChartWidget04({super.key});

  @override
  Widget build(BuildContext context) {
    final List<NumericChartPoint> data = [
      const NumericChartPoint(1, 2),
      const NumericChartPoint(7, 3),
      const NumericChartPoint(15, 5),
      const NumericChartPoint(24, 7),
      const NumericChartPoint(36, 10),
      const NumericChartPoint(50, 14),
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
                'Gráfico 09: Línea Escalonada - Movimientos Aprendidos',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SfCartesianChart(
                  primaryXAxis: const NumericAxis(title: AxisTitle(text: 'Nivel Requerido')),
                  primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Total Movimientos')),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CartesianSeries<NumericChartPoint, num>>[
                    StepLineSeries<NumericChartPoint, num>(
                      name: 'Movimientos',
                      dataSource: data,
                      xValueMapper: (NumericChartPoint p, _) => p.x,
                      yValueMapper: (NumericChartPoint p, _) => p.y,
                      color: Colors.deepPurpleAccent,
                      width: 3,
                      markerSettings: const MarkerSettings(isVisible: true),
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

/// Gráfico 10: Línea con Marcadores y Etiquetas de Datos (Tasa de Captura)
class SfLineChartWidget05 extends StatelessWidget {
  const SfLineChartWidget05({super.key});

  @override
  Widget build(BuildContext context) {
    final List<NumericChartPoint> data = [
      const NumericChartPoint(100, 12),
      const NumericChartPoint(75, 25),
      const NumericChartPoint(50, 45),
      const NumericChartPoint(25, 70),
      const NumericChartPoint(10, 92),
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
                'Gráfico 10: Línea con Etiquetas - Probabilidad de Captura vs % HP',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SfCartesianChart(
                  primaryXAxis: const NumericAxis(
                    isInversed: true,
                    title: AxisTitle(text: '% HP del Pokémon'),
                  ),
                  primaryYAxis: const NumericAxis(
                    title: AxisTitle(text: '% Éxito de Captura'),
                  ),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CartesianSeries<NumericChartPoint, num>>[
                    LineSeries<NumericChartPoint, num>(
                      name: 'Éxito %',
                      dataSource: data,
                      xValueMapper: (NumericChartPoint p, _) => p.x,
                      yValueMapper: (NumericChartPoint p, _) => p.y,
                      color: Colors.red,
                      width: 3,
                      markerSettings: const MarkerSettings(
                        isVisible: true,
                        shape: DataMarkerType.circle,
                        color: Colors.white,
                        borderColor: Colors.red,
                        borderWidth: 2,
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
