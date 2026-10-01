import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'syncfusion_data_models.dart';

/// Gráfico 11: Gráfico Circular / Pastel Básico (Distribución por Tipo Primario)
class SfPieChartWidget01 extends StatelessWidget {
  const SfPieChartWidget01({super.key});

  @override
  Widget build(BuildContext context) {
    final List<CategoricalChartData> data = [
      const CategoricalChartData('Agua', 28, Colors.blue),
      const CategoricalChartData('Fuego', 18, Colors.redAccent),
      const CategoricalChartData('Planta', 20, Colors.green),
      const CategoricalChartData('Eléctrico', 14, Colors.amber),
      const CategoricalChartData('Normal', 20, Colors.brown),
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
                'Gráfico 11: Pastel Básico - Distribución por Tipo Primario',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SfCircularChart(
                  legend: const Legend(isVisible: true, position: LegendPosition.right),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CircularSeries<CategoricalChartData, String>>[
                    PieSeries<CategoricalChartData, String>(
                      dataSource: data,
                      xValueMapper: (CategoricalChartData d, _) => d.x,
                      yValueMapper: (CategoricalChartData d, _) => d.y,
                      pointColorMapper: (CategoricalChartData d, _) => d.color,
                      dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                        labelPosition: ChartDataLabelPosition.inside,
                      ),
                      enableTooltip: true,
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

/// Gráfico 12: Gráfico de Dona (Comunes, Legendarios y Míticos)
class SfPieChartWidget02 extends StatelessWidget {
  const SfPieChartWidget02({super.key});

  @override
  Widget build(BuildContext context) {
    final List<CategoricalChartData> data = [
      const CategoricalChartData('Comunes', 88, Colors.blueGrey),
      const CategoricalChartData('Legendarios', 8, Colors.amber),
      const CategoricalChartData('Míticos', 4, Colors.purpleAccent),
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
                'Gráfico 12: Gráfico de Dona - Rareza de Especies',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SfCircularChart(
                  legend: const Legend(isVisible: true, position: LegendPosition.bottom),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CircularSeries<CategoricalChartData, String>>[
                    DoughnutSeries<CategoricalChartData, String>(
                      dataSource: data,
                      xValueMapper: (CategoricalChartData d, _) => d.x,
                      yValueMapper: (CategoricalChartData d, _) => d.y,
                      pointColorMapper: (CategoricalChartData d, _) => d.color,
                      innerRadius: '60%',
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

/// Gráfico 13: Gráfico de Dona con Texto Central (Distribución por Hábitat)
class SfPieChartWidget03 extends StatelessWidget {
  const SfPieChartWidget03({super.key});

  @override
  Widget build(BuildContext context) {
    final List<CategoricalChartData> data = [
      const CategoricalChartData('Bosque', 35, Colors.green),
      const CategoricalChartData('Mar', 25, Colors.blue),
      const CategoricalChartData('Montaña', 20, Colors.deepOrange),
      const CategoricalChartData('Ciudad', 20, Colors.grey),
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
                'Gráfico 13: Dona con Centro - Hábitat Principal',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SfCircularChart(
                  legend: const Legend(isVisible: true, position: LegendPosition.right),
                  annotations: const <CircularChartAnnotation>[
                    CircularChartAnnotation(
                      widget: Text(
                        '100%\nRegión',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                  ],
                  series: <CircularSeries<CategoricalChartData, String>>[
                    DoughnutSeries<CategoricalChartData, String>(
                      dataSource: data,
                      xValueMapper: (CategoricalChartData d, _) => d.x,
                      yValueMapper: (CategoricalChartData d, _) => d.y,
                      pointColorMapper: (CategoricalChartData d, _) => d.color,
                      innerRadius: '65%',
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

/// Gráfico 14: Gráfico de Barras Radiales (Radial Bar - Valores de IVs)
class SfPieChartWidget04 extends StatelessWidget {
  const SfPieChartWidget04({super.key});

  @override
  Widget build(BuildContext context) {
    final List<CategoricalChartData> data = [
      const CategoricalChartData('HP', 95, Colors.green),
      const CategoricalChartData('Ataque', 85, Colors.red),
      const CategoricalChartData('Defensa', 70, Colors.blue),
      const CategoricalChartData('Velocidad', 90, Colors.orange),
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
                'Gráfico 14: Barras Radiales - Calidad de IVs (% Perfección)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SfCircularChart(
                  legend: const Legend(isVisible: true, position: LegendPosition.right),
                  series: <CircularSeries<CategoricalChartData, String>>[
                    RadialBarSeries<CategoricalChartData, String>(
                      dataSource: data,
                      xValueMapper: (CategoricalChartData d, _) => d.x,
                      yValueMapper: (CategoricalChartData d, _) => d.y,
                      pointColorMapper: (CategoricalChartData d, _) => d.color,
                      maximumValue: 100,
                      gap: '10%',
                      radius: '90%',
                      innerRadius: '30%',
                      dataLabelSettings: const DataLabelSettings(isVisible: true),
                      cornerStyle: CornerStyle.bothCurve,
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

/// Gráfico 15: Gráfico Circular con Sección Resaltada (Pokébolas Efectivas)
class SfPieChartWidget05 extends StatelessWidget {
  const SfPieChartWidget05({super.key});

  @override
  Widget build(BuildContext context) {
    final List<CategoricalChartData> data = [
      const CategoricalChartData('Ultra Ball', 45, Colors.amber),
      const CategoricalChartData('Great Ball', 30, Colors.blue),
      const CategoricalChartData('Poké Ball', 15, Colors.redAccent),
      const CategoricalChartData('Master Ball', 10, Colors.purple),
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
                'Gráfico 15: Pastel con Sección Resaltada - Uso de Pokéballs',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SfCircularChart(
                  legend: const Legend(isVisible: true, position: LegendPosition.bottom),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CircularSeries<CategoricalChartData, String>>[
                    PieSeries<CategoricalChartData, String>(
                      dataSource: data,
                      xValueMapper: (CategoricalChartData d, _) => d.x,
                      yValueMapper: (CategoricalChartData d, _) => d.y,
                      pointColorMapper: (CategoricalChartData d, _) => d.color,
                      explode: true,
                      explodeIndex: 0,
                      explodeOffset: '12%',
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
