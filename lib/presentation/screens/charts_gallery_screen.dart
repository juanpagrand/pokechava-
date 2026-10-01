import 'package:flutter/material.dart';
import '../widgets/charts/charts.dart';
import '../widgets/charts_syncfusion/syncfusion_charts_view.dart';

class ChartsGalleryScreen extends StatelessWidget {
  const ChartsGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Galería de Gráficos'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(icon: Icon(Icons.auto_graph_rounded), text: 'graficas hechas con synfusion'),
              Tab(icon: Icon(Icons.bar_chart), text: 'Barras fl_chart (10)'),
              Tab(icon: Icon(Icons.show_chart), text: 'Líneas fl_chart (10)'),
              Tab(icon: Icon(Icons.pie_chart), text: 'Pastel fl_chart (10)'),
              Tab(icon: Icon(Icons.radar), text: 'Radar fl_chart (5)'),
              Tab(icon: Icon(Icons.scatter_plot), text: 'Dispersión fl_chart (5)'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            // Tab 1: 40 Gráficas hechas con Syncfusion
            SyncfusionChartsView(),
            _ChartsListView(
              charts: [
                BarChartWidget01(),
                BarChartWidget02(),
                BarChartWidget03(),
                BarChartWidget04(),
                BarChartWidget05(),
                BarChartWidget06(),
                BarChartWidget07(),
                BarChartWidget08(),
                BarChartWidget09(),
                BarChartWidget10(),
              ],
            ),
            // Tab 2: Líneas (11 a 20)
            _ChartsListView(
              charts: [
                LineChartWidget01(),
                LineChartWidget02(),
                LineChartWidget03(),
                LineChartWidget04(),
                LineChartWidget05(),
                LineChartWidget06(),
                LineChartWidget07(),
                LineChartWidget08(),
                LineChartWidget09(),
                LineChartWidget10(),
              ],
            ),
            // Tab 3: Pie (21 a 30)
            _ChartsListView(
              charts: [
                PieChartWidget01(),
                PieChartWidget02(),
                PieChartWidget03(),
                PieChartWidget04(),
                PieChartWidget05(),
                PieChartWidget06(),
                PieChartWidget07(),
                PieChartWidget08(),
                PieChartWidget09(),
                PieChartWidget10(),
              ],
            ),
            // Tab 4: Radar (31 a 35)
            _ChartsListView(
              charts: [
                RadarChartWidget01(),
                RadarChartWidget02(),
                RadarChartWidget03(),
                RadarChartWidget04(),
                RadarChartWidget05(),
              ],
            ),
            // Tab 5: Scatter (36 a 40)
            _ChartsListView(
              charts: [
                ScatterChartWidget01(),
                ScatterChartWidget02(),
                ScatterChartWidget03(),
                ScatterChartWidget04(),
                ScatterChartWidget05(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartsListView extends StatelessWidget {
  final List<Widget> charts;

  const _ChartsListView({required this.charts});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: charts.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) => charts[index],
    );
  }
}
