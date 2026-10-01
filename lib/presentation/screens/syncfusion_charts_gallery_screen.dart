import 'package:flutter/material.dart';
import '../widgets/charts_syncfusion/syncfusion_charts_view.dart';

class SyncfusionChartsGalleryScreen extends StatelessWidget {
  const SyncfusionChartsGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gráficas hechas con Syncfusion (40)'),
        elevation: 1,
      ),
      body: const SyncfusionChartsView(),
    );
  }
}
