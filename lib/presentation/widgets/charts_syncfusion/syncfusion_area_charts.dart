import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'syncfusion_data_models.dart';

/// Gráfico 26: Gráfico de Área Básico (Daño Acumulado en Batalla)
class SfAreaChartWidget01 extends StatelessWidget {
  const SfAreaChartWidget01({super.key});

  @override
  Widget build(BuildContext context) {
    final List<NumericChartPoint> data = [
      const NumericChartPoint(1, 45),
      const NumericChartPoint(2, 90),
      const NumericChartPoint(3, 140),
      const NumericChartPoint(4, 210),
      const NumericChartPoint(5, 290),
      const NumericChartPoint(6, 380),
      const NumericChartPoint(7, 490),
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
                'Gráfico 26: Área Básica - Daño Acumulado por Turno',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SfCartesianChart(
                  primaryXAxis: const NumericAxis(title: AxisTitle(text: 'Turno de Batalla')),
                  primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Daño Total')),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CartesianSeries<NumericChartPoint, num>>[
                    AreaSeries<NumericChartPoint, num>(
                      name: 'Daño Infligido',
                      dataSource: data,
                      xValueMapper: (NumericChartPoint p, _) => p.x,
                      yValueMapper: (NumericChartPoint p, _) => p.y,
                      color: Colors.redAccent.withOpacity(0.5),
                      borderColor: Colors.red,
                      borderWidth: 2,
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

/// Gráfico 27: Área Suave / Spline Area (Amistad acumulada con el Entrenador)
class SfAreaChartWidget02 extends StatelessWidget {
  const SfAreaChartWidget02({super.key});

  @override
  Widget build(BuildContext context) {
    final List<NumericChartPoint> data = [
      const NumericChartPoint(0, 0),
      const NumericChartPoint(5, 40),
      const NumericChartPoint(10, 90),
      const NumericChartPoint(15, 150),
      const NumericChartPoint(20, 210),
      const NumericChartPoint(25, 255),
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
                'Gráfico 27: Spline Area - Crecimiento de Amistad y Vínculo',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SfCartesianChart(
                  primaryXAxis: const NumericAxis(title: AxisTitle(text: 'Días de Entrenamiento')),
                  primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Puntos de Felicidad (Máx 255)')),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CartesianSeries<NumericChartPoint, num>>[
                    SplineAreaSeries<NumericChartPoint, num>(
                      name: 'Felicidad',
                      dataSource: data,
                      xValueMapper: (NumericChartPoint p, _) => p.x,
                      yValueMapper: (NumericChartPoint p, _) => p.y,
                      color: Colors.pinkAccent.withOpacity(0.4),
                      borderColor: Colors.pink,
                      borderWidth: 2.5,
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

/// Gráfico 28: Área Escalonada (Step Area - Consumo de Puntos de Poder [PP])
class SfAreaChartWidget03 extends StatelessWidget {
  const SfAreaChartWidget03({super.key});

  @override
  Widget build(BuildContext context) {
    final List<NumericChartPoint> data = [
      const NumericChartPoint(1, 40),
      const NumericChartPoint(3, 35),
      const NumericChartPoint(6, 25),
      const NumericChartPoint(9, 15),
      const NumericChartPoint(12, 5),
      const NumericChartPoint(15, 0),
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
                'Gráfico 28: Step Area - Puntos de Poder (PP) Restantes',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SfCartesianChart(
                  primaryXAxis: const NumericAxis(title: AxisTitle(text: 'Combates Consecutivos')),
                  primaryYAxis: const NumericAxis(title: AxisTitle(text: 'PP Disponibles')),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CartesianSeries<NumericChartPoint, num>>[
                    StepAreaSeries<NumericChartPoint, num>(
                      name: 'PP Restantes',
                      dataSource: data,
                      xValueMapper: (NumericChartPoint p, _) => p.x,
                      yValueMapper: (NumericChartPoint p, _) => p.y,
                      color: Colors.amber.withOpacity(0.5),
                      borderColor: Colors.deepOrange,
                      borderWidth: 2,
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

/// Gráfico 29: Rango de Áreas (Range Area - Daño Mínimo y Máximo de Ataque)
class SfAreaChartWidget04 extends StatelessWidget {
  const SfAreaChartWidget04({super.key});

  @override
  Widget build(BuildContext context) {
    final List<RangeChartData> data = [
      const RangeChartData(10, 20, 35),
      const RangeChartData(20, 42, 68),
      const RangeChartData(30, 75, 115),
      const RangeChartData(40, 110, 165),
      const RangeChartData(50, 150, 230),
      const RangeChartData(60, 195, 290),
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
                'Gráfico 29: Rango de Áreas - Margen de Daño (Mínimo vs Máximo)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SfCartesianChart(
                  primaryXAxis: const NumericAxis(title: AxisTitle(text: 'Nivel del Pokémon')),
                  primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Rango de Daño')),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CartesianSeries<RangeChartData, num>>[
                    RangeAreaSeries<RangeChartData, num>(
                      name: 'Margen de Daño',
                      dataSource: data,
                      xValueMapper: (RangeChartData r, _) => r.x,
                      highValueMapper: (RangeChartData r, _) => r.high,
                      lowValueMapper: (RangeChartData r, _) => r.low,
                      color: Colors.deepPurple.withOpacity(0.4),
                      borderColor: Colors.deepPurple,
                      borderWidth: 2,
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

/// Gráfico 30: Áreas Apiladas (Stacked Area - Daño Elemental Recibido)
class SfAreaChartWidget05 extends StatelessWidget {
  const SfAreaChartWidget05({super.key});

  @override
  Widget build(BuildContext context) {
    final List<MultiSeriesChartData> data = [
      const MultiSeriesChartData('Ronda 1', 20, 15),
      const MultiSeriesChartData('Ronda 2', 35, 25),
      const MultiSeriesChartData('Ronda 3', 50, 40),
      const MultiSeriesChartData('Ronda 4', 70, 60),
      const MultiSeriesChartData('Ronda 5', 95, 80),
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
                'Gráfico 30: Áreas Apiladas - Daño Físico y Especial Recibido',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SfCartesianChart(
                  legend: const Legend(isVisible: true, position: LegendPosition.top),
                  primaryXAxis: const CategoryAxis(),
                  primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Daño Acumulado')),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CartesianSeries<MultiSeriesChartData, String>>[
                    StackedAreaSeries<MultiSeriesChartData, String>(
                      name: 'Daño Físico',
                      dataSource: data,
                      xValueMapper: (MultiSeriesChartData d, _) => d.x,
                      yValueMapper: (MultiSeriesChartData d, _) => d.y1,
                      color: Colors.orange.withOpacity(0.7),
                    ),
                    StackedAreaSeries<MultiSeriesChartData, String>(
                      name: 'Daño Especial',
                      dataSource: data,
                      xValueMapper: (MultiSeriesChartData d, _) => d.x,
                      yValueMapper: (MultiSeriesChartData d, _) => d.y2,
                      color: Colors.cyan.withOpacity(0.7),
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
