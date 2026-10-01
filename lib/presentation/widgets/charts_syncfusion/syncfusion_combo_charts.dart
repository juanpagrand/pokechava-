import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'syncfusion_data_models.dart';

/// Gráfico 36: Combo Columnas + Línea (Stats Base + Línea de Promedio)
class SfComboChartWidget01 extends StatelessWidget {
  const SfComboChartWidget01({super.key});

  @override
  Widget build(BuildContext context) {
    final List<MultiSeriesChartData> data = [
      const MultiSeriesChartData('HP', 78, 68),
      const MultiSeriesChartData('Ataque', 84, 75),
      const MultiSeriesChartData('Defensa', 78, 70),
      const MultiSeriesChartData('Atq. Sp', 109, 72),
      const MultiSeriesChartData('Def. Sp', 85, 71),
      const MultiSeriesChartData('Velocidad', 100, 68),
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
                'Gráfico 36: Combinado - Columnas + Línea (Charizard vs Promedio)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SfCartesianChart(
                  legend: const Legend(isVisible: true, position: LegendPosition.top),
                  primaryXAxis: const CategoryAxis(),
                  primaryYAxis: const NumericAxis(maximum: 130),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CartesianSeries<MultiSeriesChartData, String>>[
                    ColumnSeries<MultiSeriesChartData, String>(
                      name: 'Charizard',
                      dataSource: data,
                      xValueMapper: (MultiSeriesChartData d, _) => d.x,
                      yValueMapper: (MultiSeriesChartData d, _) => d.y1,
                      color: Colors.deepOrange,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                    ),
                    LineSeries<MultiSeriesChartData, String>(
                      name: 'Promedio General',
                      dataSource: data,
                      xValueMapper: (MultiSeriesChartData d, _) => d.x,
                      yValueMapper: (MultiSeriesChartData d, _) => d.y2,
                      color: Colors.blueGrey,
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

/// Gráfico 37: Combo Área + Línea (Energía Residual + Potencia de Ataque)
class SfComboChartWidget02 extends StatelessWidget {
  const SfComboChartWidget02({super.key});

  @override
  Widget build(BuildContext context) {
    final List<MultiSeriesChartData> data = [
      const MultiSeriesChartData('Turno 1', 100, 30),
      const MultiSeriesChartData('Turno 2', 85, 45),
      const MultiSeriesChartData('Turno 3', 70, 70),
      const MultiSeriesChartData('Turno 4', 50, 95),
      const MultiSeriesChartData('Turno 5', 25, 120),
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
                'Gráfico 37: Combinado - Área + Línea (Energía vs Potencia)',
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
                    AreaSeries<MultiSeriesChartData, String>(
                      name: 'Energía Restante',
                      dataSource: data,
                      xValueMapper: (MultiSeriesChartData d, _) => d.x,
                      yValueMapper: (MultiSeriesChartData d, _) => d.y1,
                      color: Colors.blue.withOpacity(0.35),
                      borderColor: Colors.blue,
                      borderWidth: 2,
                    ),
                    LineSeries<MultiSeriesChartData, String>(
                      name: 'Potencia Infligida',
                      dataSource: data,
                      xValueMapper: (MultiSeriesChartData d, _) => d.x,
                      yValueMapper: (MultiSeriesChartData d, _) => d.y2,
                      color: Colors.red,
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

/// Gráfico 38: Combo Columnas + Dispersión (Promedio vs Casos Destacados)
class SfComboChartWidget03 extends StatelessWidget {
  const SfComboChartWidget03({super.key});

  @override
  Widget build(BuildContext context) {
    final List<CategoricalChartData> barData = [
      const CategoricalChartData('Fuego', 75),
      const CategoricalChartData('Agua', 71),
      const CategoricalChartData('Planta', 69),
      const CategoricalChartData('Eléctrico', 76),
    ];

    final List<CategoricalChartData> scatterData = [
      const CategoricalChartData('Fuego', 134), // Dragonite / Ho-oh
      const CategoricalChartData('Agua', 130),  // Gyarados
      const CategoricalChartData('Planta', 100), // Venusaur
      const CategoricalChartData('Eléctrico', 125), // Electivire
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
                'Gráfico 38: Combinado - Columnas + Puntos Dispersos (Media vs Picos)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SfCartesianChart(
                  legend: const Legend(isVisible: true, position: LegendPosition.top),
                  primaryXAxis: const CategoryAxis(),
                  primaryYAxis: const NumericAxis(maximum: 150),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CartesianSeries<CategoricalChartData, String>>[
                    ColumnSeries<CategoricalChartData, String>(
                      name: 'Media de Ataque',
                      dataSource: barData,
                      xValueMapper: (CategoricalChartData d, _) => d.x,
                      yValueMapper: (CategoricalChartData d, _) => d.y,
                      color: Colors.amber.withOpacity(0.7),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                    ),
                    ScatterSeries<CategoricalChartData, String>(
                      name: 'Máximo Registrado',
                      dataSource: scatterData,
                      xValueMapper: (CategoricalChartData d, _) => d.x,
                      yValueMapper: (CategoricalChartData d, _) => d.y,
                      color: Colors.red,
                      markerSettings: const MarkerSettings(
                        isVisible: true,
                        width: 12,
                        height: 12,
                        shape: DataMarkerType.diamond,
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

/// Gráfico 39: Combo Línea Suave + Columnas (Progresión de Nivel y Estadísticas)
class SfComboChartWidget04 extends StatelessWidget {
  const SfComboChartWidget04({super.key});

  @override
  Widget build(BuildContext context) {
    final List<MultiSeriesChartData> data = [
      const MultiSeriesChartData('Nv. 10', 20, 25),
      const MultiSeriesChartData('Nv. 20', 45, 52),
      const MultiSeriesChartData('Nv. 30', 70, 80),
      const MultiSeriesChartData('Nv. 40', 105, 115),
      const MultiSeriesChartData('Nv. 50', 140, 155),
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
                'Gráfico 39: Combinado - Columnas + Spline Suave (Ataque y Velocidad)',
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
                    ColumnSeries<MultiSeriesChartData, String>(
                      name: 'Ataque',
                      dataSource: data,
                      xValueMapper: (MultiSeriesChartData d, _) => d.x,
                      yValueMapper: (MultiSeriesChartData d, _) => d.y1,
                      color: Colors.teal.withOpacity(0.8),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                    ),
                    SplineSeries<MultiSeriesChartData, String>(
                      name: 'Velocidad Curva',
                      dataSource: data,
                      xValueMapper: (MultiSeriesChartData d, _) => d.x,
                      yValueMapper: (MultiSeriesChartData d, _) => d.y2,
                      color: Colors.purpleAccent,
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

/// Gráfico 40: Combo Columnas Apiladas + Línea (Daño Mixto + Velocidad Base)
class SfComboChartWidget05 extends StatelessWidget {
  const SfComboChartWidget05({super.key});

  @override
  Widget build(BuildContext context) {
    final List<MultiSeriesChartData> data = [
      const MultiSeriesChartData('Lucario', 110, 115, 90),
      const MultiSeriesChartData('Greninja', 95, 103, 122),
      const CharData40('Gengar', 65, 130, 110),
      const CharData40('Blaziken', 120, 110, 80),
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
                'Gráfico 40: Combinado - Columnas Apiladas + Línea (Atq + Sp.Atk + Speed)',
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
                    StackedColumnSeries<MultiSeriesChartData, String>(
                      name: 'Ataque Físico',
                      dataSource: data,
                      xValueMapper: (MultiSeriesChartData d, _) => d.x,
                      yValueMapper: (MultiSeriesChartData d, _) => d.y1,
                      color: Colors.deepOrange,
                    ),
                    StackedColumnSeries<MultiSeriesChartData, String>(
                      name: 'Ataque Especial',
                      dataSource: data,
                      xValueMapper: (MultiSeriesChartData d, _) => d.x,
                      yValueMapper: (MultiSeriesChartData d, _) => d.y2,
                      color: Colors.cyan,
                    ),
                    LineSeries<MultiSeriesChartData, String>(
                      name: 'Velocidad',
                      dataSource: data,
                      xValueMapper: (MultiSeriesChartData d, _) => d.x,
                      yValueMapper: (MultiSeriesChartData d, _) => d.y3 ?? 0,
                      color: Colors.amber[800],
                      width: 3.5,
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

class CharData40 extends MultiSeriesChartData {
  const CharData40(super.x, super.y1, super.y2, super.y3);
}
