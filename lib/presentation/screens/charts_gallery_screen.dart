import 'package:flutter/material.dart';
import '../widgets/charts/charts.dart';
import '../widgets/charts_syncfusion/syncfusion_charts_view.dart';
// graphic: se importa solo la vista (GraphicChartsView). Esa vista ya trae
// por dentro el barril charts_graphic.dart con los 65 gráficos, así que
// esta pantalla no necesita conocer cada gráfico por separado.
import '../widgets/charts_graphic/graphic_charts_view.dart';
import '../widgets/charts_community/community_charts_view.dart';

class ChartsGalleryScreen extends StatelessWidget {
  const ChartsGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 8,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Galería de Gráficos'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(icon: Icon(Icons.auto_graph_rounded), text: 'graficas hechas con synfusion'),
              // Pestaña 2: los gráficos de la librería graphic (40 normales
              // + 25 avanzados). El orden de estas pestañas debe coincidir
              // con el orden de los hijos de TabBarView más abajo.
              Tab(icon: Icon(Icons.hub_outlined), text: 'graphic (40 + 25)'),
              Tab(icon: Icon(Icons.stacked_bar_chart), text: 'community_charts (40 + 25)'),
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
            // Tab 2: 65 gráficas hechas con graphic (Juan)
            // GraphicChartsView (charts_graphic/graphic_charts_view.dart)
            // trae su propio selector Normales/Avanzados, los chips de
            // categoría y la lista de tarjetas. Puede ser `const` porque no
            // recibe parámetros.
            GraphicChartsView(),
            // Pestaña 3: 65 gráficas hechas con community_charts_flutter (Carlos)
            CommunityChartsView(),
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
