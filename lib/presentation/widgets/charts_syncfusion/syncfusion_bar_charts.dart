import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'syncfusion_data_models.dart';

/// Gráfico 01: Gráfico de Columnas Básico (Estadísticas Iniciales)
class SfBarChartWidget01 extends StatelessWidget {
  const SfBarChartWidget01({super.key});

  @override
  Widget build(BuildContext context) {
    final List<CategoricalChartData> data = [
      const CategoricalChartData('Bulbasaur', 318, Colors.teal),
      const CategoricalChartData('Charmander', 309, Colors.deepOrange),
      const CategoricalChartData('Squirtle', 314, Colors.blue),
      const CategoricalChartData('Pikachu', 320, Colors.amber),
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
                'Gráfico 01: Columnas Básicas - Total Stats Iniciales',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SfCartesianChart(
                  primaryXAxis: const CategoryAxis(),
                  primaryYAxis: const NumericAxis(minimum: 250, maximum: 350),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CartesianSeries<CategoricalChartData, String>>[
                    ColumnSeries<CategoricalChartData, String>(
                      dataSource: data,
                      xValueMapper: (CategoricalChartData d, _) => d.x,
                      yValueMapper: (CategoricalChartData d, _) => d.y,
                      pointColorMapper: (CategoricalChartData d, _) => d.color,
                      dataLabelSettings: const DataLabelSettings(isVisible: true),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
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

/// Gráfico 02: Gráfico de Barras Horizontales (Top Ataque Físico)
class SfBarChartWidget02 extends StatelessWidget {
  const SfBarChartWidget02({super.key});

  @override
  Widget build(BuildContext context) {
    final List<CategoricalChartData> data = [
      const CategoricalChartData('Dragonite', 134, Colors.orange),
      const CategoricalChartData('Tyranitar', 134, Colors.green),
      const CategoricalChartData('Machamp', 130, Colors.blueGrey),
      const CategoricalChartData('Gengar', 130, Colors.purple),
      const CategoricalChartData('Snorlax', 110, Colors.indigo),
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
                'Gráfico 02: Barras Horizontales - Top Ataque Físico',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SfCartesianChart(
                  primaryXAxis: const CategoryAxis(),
                  primaryYAxis: const NumericAxis(maximum: 150),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CartesianSeries<CategoricalChartData, String>>[
                    BarSeries<CategoricalChartData, String>(
                      dataSource: data,
                      xValueMapper: (CategoricalChartData d, _) => d.x,
                      yValueMapper: (CategoricalChartData d, _) => d.y,
                      pointColorMapper: (CategoricalChartData d, _) => d.color,
                      dataLabelSettings: const DataLabelSettings(isVisible: true),
                      borderRadius: const BorderRadius.horizontal(right: Radius.circular(6)),
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

/// Gráfico 03: Columnas Agrupadas (Ataque vs Defensa por Generación)
class SfBarChartWidget03 extends StatelessWidget {
  const SfBarChartWidget03({super.key});

  @override
  Widget build(BuildContext context) {
    final List<MultiSeriesChartData> data = [
      const MultiSeriesChartData('Gen 1', 77, 71),
      const MultiSeriesChartData('Gen 2', 73, 73),
      const MultiSeriesChartData('Gen 3', 82, 75),
      const MultiSeriesChartData('Gen 4', 83, 78),
      const MultiSeriesChartData('Gen 5', 84, 76),
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
                'Gráfico 03: Columnas Agrupadas - Ataque vs Defensa Promedio',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SfCartesianChart(
                  legend: const Legend(isVisible: true, position: LegendPosition.top),
                  primaryXAxis: const CategoryAxis(),
                  primaryYAxis: const NumericAxis(minimum: 50, maximum: 100),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CartesianSeries<MultiSeriesChartData, String>>[
                    ColumnSeries<MultiSeriesChartData, String>(
                      name: 'Ataque',
                      dataSource: data,
                      xValueMapper: (MultiSeriesChartData d, _) => d.x,
                      yValueMapper: (MultiSeriesChartData d, _) => d.y1,
                      color: Colors.redAccent,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                    ),
                    ColumnSeries<MultiSeriesChartData, String>(
                      name: 'Defensa',
                      dataSource: data,
                      xValueMapper: (MultiSeriesChartData d, _) => d.x,
                      yValueMapper: (MultiSeriesChartData d, _) => d.y2,
                      color: Colors.blueAccent,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
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

/// Gráfico 04: Barras Apiladas (Distribución de Estadísticas en Legendarios)
class SfBarChartWidget04 extends StatelessWidget {
  const SfBarChartWidget04({super.key});

  @override
  Widget build(BuildContext context) {
    final List<MultiSeriesChartData> data = [
      const MultiSeriesChartData('Mewtwo', 110, 90, 154),
      const MultiSeriesChartData('Lugia', 90, 130, 90),
      const MultiSeriesChartData('Rayquaza', 150, 90, 150),
      const MultiSeriesChartData('Dialga', 120, 120, 150),
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
                'Gráfico 04: Barras Apiladas - Desglose de Stats Legendarios',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SfCartesianChart(
                  legend: const Legend(isVisible: true, position: LegendPosition.top),
                  primaryXAxis: const CategoryAxis(),
                  primaryYAxis: const NumericAxis(),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CartesianSeries<MultiSeriesChartData, String>>[
                    StackedBarSeries<MultiSeriesChartData, String>(
                      name: 'Ataque Físico',
                      dataSource: data,
                      xValueMapper: (MultiSeriesChartData d, _) => d.x,
                      yValueMapper: (MultiSeriesChartData d, _) => d.y1,
                      color: Colors.deepOrange,
                    ),
                    StackedBarSeries<MultiSeriesChartData, String>(
                      name: 'Defensa',
                      dataSource: data,
                      xValueMapper: (MultiSeriesChartData d, _) => d.x,
                      yValueMapper: (MultiSeriesChartData d, _) => d.y2,
                      color: Colors.lightBlue,
                    ),
                    StackedBarSeries<MultiSeriesChartData, String>(
                      name: 'Atq. Especial',
                      dataSource: data,
                      xValueMapper: (MultiSeriesChartData d, _) => d.x,
                      yValueMapper: (MultiSeriesChartData d, _) => d.y3 ?? 0,
                      color: Colors.purpleAccent,
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

/// Gráfico 05: Columnas 100% Apiladas (Proporción Físico vs Especial por Tipo)
class SfBarChartWidget05 extends StatelessWidget {
  const SfBarChartWidget05({super.key});

  @override
  Widget build(BuildContext context) {
    final List<MultiSeriesChartData> data = [
      const MultiSeriesChartData('Fuego', 55, 45),
      const MultiSeriesChartData('Agua', 48, 52),
      const MultiSeriesChartData('Planta', 50, 50),
      const MultiSeriesChartData('Eléctrico', 40, 60),
      const MultiSeriesChartData('Lucha', 80, 20),
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
                'Gráfico 05: Columnas 100% Apiladas - Daño Físico vs Especial',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SfCartesianChart(
                  legend: const Legend(isVisible: true, position: LegendPosition.top),
                  primaryXAxis: const CategoryAxis(),
                  primaryYAxis: const NumericAxis(),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CartesianSeries<MultiSeriesChartData, String>>[
                    StackedColumn100Series<MultiSeriesChartData, String>(
                      name: 'Físico %',
                      dataSource: data,
                      xValueMapper: (MultiSeriesChartData d, _) => d.x,
                      yValueMapper: (MultiSeriesChartData d, _) => d.y1,
                      color: Colors.amber[700],
                      dataLabelSettings: const DataLabelSettings(isVisible: true),
                    ),
                    StackedColumn100Series<MultiSeriesChartData, String>(
                      name: 'Especial %',
                      dataSource: data,
                      xValueMapper: (MultiSeriesChartData d, _) => d.x,
                      yValueMapper: (MultiSeriesChartData d, _) => d.y2,
                      color: Colors.cyan[700],
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
