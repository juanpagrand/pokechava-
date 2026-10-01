import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'syncfusion_data_models.dart';

/// Gráfico 31: Caja y Bigotes Básica (Distribución de Stats en Tipos)
class SfBoxChartWidget01 extends StatelessWidget {
  const SfBoxChartWidget01({super.key});

  @override
  Widget build(BuildContext context) {
    final List<BoxPlotChartData> data = [
      const BoxPlotChartData('Agua', [44, 48, 55, 65, 75, 85, 95, 110, 130]),
      const BoxPlotChartData('Fuego', [39, 52, 60, 78, 84, 90, 105, 120, 134]),
      const BoxPlotChartData('Planta', [45, 49, 62, 70, 78, 85, 100, 115, 125]),
      const BoxPlotChartData('Eléctrico', [35, 40, 50, 65, 80, 95, 110, 125, 140]),
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
                'Gráfico 31: Caja y Bigotes - Dispersión de Stats por Tipo',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SfCartesianChart(
                  primaryXAxis: const CategoryAxis(),
                  primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Puntos de Estadística')),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CartesianSeries<BoxPlotChartData, String>>[
                    BoxAndWhiskerSeries<BoxPlotChartData, String>(
                      name: 'Stats',
                      dataSource: data,
                      xValueMapper: (BoxPlotChartData d, _) => d.x,
                      yValueMapper: (BoxPlotChartData d, _) => d.values,
                      color: Colors.blueAccent.withOpacity(0.7),
                      showMean: true,
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

/// Gráfico 32: Caja y Bigotes de Velocidad por Generación
class SfBoxChartWidget02 extends StatelessWidget {
  const SfBoxChartWidget02({super.key});

  @override
  Widget build(BuildContext context) {
    final List<BoxPlotChartData> data = [
      const BoxPlotChartData('Gen 1', [30, 45, 55, 65, 75, 90, 105, 120, 140]),
      const BoxPlotChartData('Gen 2', [20, 40, 50, 60, 70, 85, 95, 115, 130]),
      const BoxPlotChartData('Gen 3', [25, 45, 58, 70, 80, 95, 110, 125, 160]),
      const BoxPlotChartData('Gen 4', [30, 42, 55, 68, 80, 92, 108, 120, 135]),
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
                'Gráfico 32: Caja y Bigotes - Velocidad por Generación',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SfCartesianChart(
                  primaryXAxis: const CategoryAxis(),
                  primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Velocidad Base')),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CartesianSeries<BoxPlotChartData, String>>[
                    BoxAndWhiskerSeries<BoxPlotChartData, String>(
                      name: 'Velocidad',
                      dataSource: data,
                      xValueMapper: (BoxPlotChartData d, _) => d.x,
                      yValueMapper: (BoxPlotChartData d, _) => d.values,
                      color: Colors.teal.withOpacity(0.7),
                      boxPlotMode: BoxPlotMode.normal,
                      showMean: true,
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

/// Gráfico 33: Caja y Bigotes por Etapa Evolutiva (Ataque Base)
class SfBoxChartWidget03 extends StatelessWidget {
  const SfBoxChartWidget03({super.key});

  @override
  Widget build(BuildContext context) {
    final List<BoxPlotChartData> data = [
      const BoxPlotChartData('Fase Inicial', [30, 40, 48, 52, 58, 65, 75, 85]),
      const BoxPlotChartData('Fase Intermedia', [50, 62, 70, 75, 82, 90, 98, 110]),
      const BoxPlotChartData('Fase Final', [80, 95, 105, 115, 125, 134, 145, 160]),
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
                'Gráfico 33: Caja y Bigotes - Potencia de Ataque por Evolución',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SfCartesianChart(
                  primaryXAxis: const CategoryAxis(),
                  primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Ataque')),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CartesianSeries<BoxPlotChartData, String>>[
                    BoxAndWhiskerSeries<BoxPlotChartData, String>(
                      name: 'Ataque',
                      dataSource: data,
                      xValueMapper: (BoxPlotChartData d, _) => d.x,
                      yValueMapper: (BoxPlotChartData d, _) => d.values,
                      color: Colors.deepOrange.withOpacity(0.7),
                      showMean: true,
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

/// Gráfico 34: Caja y Bigotes Comparativo (Legendarios vs No Legendarios)
class SfBoxChartWidget04 extends StatelessWidget {
  const SfBoxChartWidget04({super.key});

  @override
  Widget build(BuildContext context) {
    final List<BoxPlotChartData> data = [
      const BoxPlotChartData('Comunes', [35, 45, 55, 65, 75, 85, 95, 110, 130]),
      const BoxPlotChartData('Legendarios', [80, 90, 100, 115, 125, 135, 150, 160, 180]),
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
                'Gráfico 34: Caja y Bigotes - Stats en Legendarios vs Comunes',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SfCartesianChart(
                  primaryXAxis: const CategoryAxis(),
                  primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Puntos de Stat')),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CartesianSeries<BoxPlotChartData, String>>[
                    BoxAndWhiskerSeries<BoxPlotChartData, String>(
                      name: 'Rango Stats',
                      dataSource: data,
                      xValueMapper: (BoxPlotChartData d, _) => d.x,
                      yValueMapper: (BoxPlotChartData d, _) => d.values,
                      color: Colors.amber.withOpacity(0.7),
                      showMean: true,
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

/// Gráfico 35: Caja y Bigotes de Defensa Especial según Hábitat
class SfBoxChartWidget05 extends StatelessWidget {
  const SfBoxChartWidget05({super.key});

  @override
  Widget build(BuildContext context) {
    final List<BoxPlotChartData> data = [
      const BoxPlotChartData('Pradera', [35, 45, 50, 60, 70, 80, 90]),
      const BoxPlotChartData('Marino', [50, 65, 75, 85, 100, 115, 130]),
      const BoxPlotChartData('Cueva', [40, 55, 65, 75, 85, 95, 110]),
      const BoxPlotChartData('Urbano', [45, 50, 60, 70, 80, 90, 105]),
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
                'Gráfico 35: Caja y Bigotes - Defensa Especial según Hábitat',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SfCartesianChart(
                  primaryXAxis: const CategoryAxis(),
                  primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Sp. Def')),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CartesianSeries<BoxPlotChartData, String>>[
                    BoxAndWhiskerSeries<BoxPlotChartData, String>(
                      name: 'Sp. Def',
                      dataSource: data,
                      xValueMapper: (BoxPlotChartData d, _) => d.x,
                      yValueMapper: (BoxPlotChartData d, _) => d.values,
                      color: Colors.purple.withOpacity(0.7),
                      boxPlotMode: BoxPlotMode.inclusive,
                      showMean: true,
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
