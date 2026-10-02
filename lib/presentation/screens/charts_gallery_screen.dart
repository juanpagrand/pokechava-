import 'package:flutter/material.dart';
import '../widgets/charts/fl_charts_view.dart';
import '../widgets/charts_syncfusion/syncfusion_charts_view.dart';
import '../widgets/charts_graphic/graphic_charts_view.dart';
import '../widgets/charts_community/community_charts_view.dart';

class ChartsGalleryScreen extends StatelessWidget {
  const ChartsGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Galería de Gráficos'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(
                icon: Icon(Icons.auto_graph_rounded),
                text: 'syncfusion (40 + 25)',
              ),
              Tab(
                icon: Icon(Icons.bar_chart_rounded),
                text: 'fl_chart (40 + 25)',
              ),
              Tab(
                icon: Icon(Icons.hub_outlined),
                text: 'graphic (40 + 25)',
              ),
              Tab(
                icon: Icon(Icons.stacked_bar_chart),
                text: 'community_charts (40 + 25)',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            // Pestaña 1: 65 Gráficas hechas con Syncfusion (40 normales + 25 avanzadas)
            SyncfusionChartsView(),

            // Pestaña 2: 65 Gráficas hechas con fl_chart (40 normales + 25 avanzadas)
            FlChartsView(),

            // Pestaña 3: 65 Gráficas hechas con graphic (40 normales + 25 avanzadas)
            GraphicChartsView(),

            // Pestaña 4: 65 Gráficas hechas con community_charts (40 normales + 25 avanzadas)
            CommunityChartsView(),
          ],
        ),
      ),
    );
  }
}
