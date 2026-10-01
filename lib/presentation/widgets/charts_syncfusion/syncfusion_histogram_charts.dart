import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'syncfusion_data_models.dart';

/// Gráfico 16: Histograma de Distribución de Peso (kg)
class SfHistogramChartWidget01 extends StatelessWidget {
  const SfHistogramChartWidget01({super.key});

  @override
  Widget build(BuildContext context) {
    final List<HistogramChartData> data = [
      const HistogramChartData(5),
      const HistogramChartData(12),
      const HistogramChartData(18),
      const HistogramChartData(22),
      const HistogramChartData(25),
      const HistogramChartData(30),
      const HistogramChartData(35),
      const HistogramChartData(42),
      const HistogramChartData(45),
      const HistogramChartData(48),
      const HistogramChartData(55),
      const HistogramChartData(65),
      const HistogramChartData(70),
      const HistogramChartData(85),
      const HistogramChartData(90),
      const HistogramChartData(120),
      const HistogramChartData(150),
      const HistogramChartData(210),
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
                'Gráfico 16: Histograma - Frecuencia de Pesos (kg)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SfCartesianChart(
                  primaryXAxis: const NumericAxis(title: AxisTitle(text: 'Rango de Peso (kg)')),
                  primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Cantidad de Pokémon')),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CartesianSeries<HistogramChartData, num>>[
                    HistogramSeries<HistogramChartData, num>(
                      name: 'Pesos',
                      dataSource: data,
                      yValueMapper: (HistogramChartData d, _) => d.value,
                      binInterval: 30,
                      color: Colors.blueAccent,
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

/// Gráfico 17: Histograma de Alturas con Curva de Distribución Normal
class SfHistogramChartWidget02 extends StatelessWidget {
  const SfHistogramChartWidget02({super.key});

  @override
  Widget build(BuildContext context) {
    final List<HistogramChartData> data = [
      const HistogramChartData(0.3),
      const HistogramChartData(0.5),
      const HistogramChartData(0.6),
      const HistogramChartData(0.8),
      const HistogramChartData(1.0),
      const HistogramChartData(1.1),
      const HistogramChartData(1.2),
      const HistogramChartData(1.3),
      const HistogramChartData(1.5),
      const HistogramChartData(1.6),
      const HistogramChartData(1.7),
      const HistogramChartData(1.9),
      const HistogramChartData(2.1),
      const HistogramChartData(2.3),
      const HistogramChartData(2.8),
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
                'Gráfico 17: Histograma con Curva Normal - Alturas (m)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SfCartesianChart(
                  primaryXAxis: const NumericAxis(title: AxisTitle(text: 'Altura (metros)')),
                  primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Frecuencia')),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CartesianSeries<HistogramChartData, num>>[
                    HistogramSeries<HistogramChartData, num>(
                      name: 'Alturas',
                      dataSource: data,
                      yValueMapper: (HistogramChartData d, _) => d.value,
                      binInterval: 0.5,
                      showNormalDistributionCurve: true,
                      curveColor: Colors.deepOrange,
                      curveWidth: 2.5,
                      color: Colors.amber.withValues(alpha: 0.7),
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

/// Gráfico 18: Histograma de Puntos de Salud Base (HP)
class SfHistogramChartWidget03 extends StatelessWidget {
  const SfHistogramChartWidget03({super.key});

  @override
  Widget build(BuildContext context) {
    final List<HistogramChartData> data = [
      const HistogramChartData(35),
      const HistogramChartData(39),
      const HistogramChartData(40),
      const HistogramChartData(45),
      const HistogramChartData(50),
      const HistogramChartData(55),
      const HistogramChartData(60),
      const HistogramChartData(65),
      const HistogramChartData(70),
      const HistogramChartData(75),
      const HistogramChartData(80),
      const HistogramChartData(85),
      const HistogramChartData(90),
      const HistogramChartData(95),
      const HistogramChartData(105),
      const HistogramChartData(130),
      const HistogramChartData(160),
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
                'Gráfico 18: Histograma - Rangos de Puntos de Salud (HP)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SfCartesianChart(
                  primaryXAxis: const NumericAxis(title: AxisTitle(text: 'Rango de HP')),
                  primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Conteo')),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CartesianSeries<HistogramChartData, num>>[
                    HistogramSeries<HistogramChartData, num>(
                      name: 'HP Base',
                      dataSource: data,
                      yValueMapper: (HistogramChartData d, _) => d.value,
                      binInterval: 25,
                      color: Colors.green,
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

/// Gráfico 19: Histograma de Experiencia Base al Derrotar
class SfHistogramChartWidget04 extends StatelessWidget {
  const SfHistogramChartWidget04({super.key});

  @override
  Widget build(BuildContext context) {
    final List<HistogramChartData> data = [
      const HistogramChartData(40),
      const HistogramChartData(50),
      const HistogramChartData(64),
      const HistogramChartData(72),
      const HistogramChartData(110),
      const HistogramChartData(125),
      const HistogramChartData(138),
      const HistogramChartData(142),
      const HistogramChartData(175),
      const HistogramChartData(189),
      const HistogramChartData(220),
      const HistogramChartData(240),
      const HistogramChartData(270),
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
                'Gráfico 19: Histograma - Base EXP al Derrotar',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SfCartesianChart(
                  primaryXAxis: const NumericAxis(title: AxisTitle(text: 'Puntos Base EXP')),
                  primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Frecuencia')),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CartesianSeries<HistogramChartData, num>>[
                    HistogramSeries<HistogramChartData, num>(
                      name: 'EXP Base',
                      dataSource: data,
                      yValueMapper: (HistogramChartData d, _) => d.value,
                      binInterval: 50,
                      color: Colors.purple,
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

/// Gráfico 20: Histograma de Velocidad Base con Curva de Campana
class SfHistogramChartWidget05 extends StatelessWidget {
  const SfHistogramChartWidget05({super.key});

  @override
  Widget build(BuildContext context) {
    final List<HistogramChartData> data = [
      const HistogramChartData(20),
      const HistogramChartData(30),
      const HistogramChartData(45),
      const HistogramChartData(55),
      const HistogramChartData(60),
      const HistogramChartData(68),
      const HistogramChartData(70),
      const HistogramChartData(75),
      const HistogramChartData(80),
      const HistogramChartData(90),
      const HistogramChartData(95),
      const HistogramChartData(100),
      const HistogramChartData(115),
      const HistogramChartData(130),
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
                'Gráfico 20: Histograma con Curva - Distribución de Velocidad',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SfCartesianChart(
                  primaryXAxis: const NumericAxis(title: AxisTitle(text: 'Velocidad Base')),
                  primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Cantidad')),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CartesianSeries<HistogramChartData, num>>[
                    HistogramSeries<HistogramChartData, num>(
                      name: 'Velocidad',
                      dataSource: data,
                      yValueMapper: (HistogramChartData d, _) => d.value,
                      binInterval: 20,
                      showNormalDistributionCurve: true,
                      curveColor: Colors.tealAccent.shade700,
                      curveWidth: 2,
                      color: Colors.teal.withValues(alpha: 0.6),
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
