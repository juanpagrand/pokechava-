import 'package:flutter/material.dart';
import 'charts_syncfusion.dart';

/// Vista completa interactiva de las 40 gráficas de Syncfusion
class SyncfusionChartsView extends StatefulWidget {
  const SyncfusionChartsView({super.key});

  @override
  State<SyncfusionChartsView> createState() => _SyncfusionChartsViewState();
}

class _SyncfusionChartsViewState extends State<SyncfusionChartsView> {
  int _selectedCategoryIndex = 0;

  final List<String> _categories = [
    'Todos (40)',
    'Barras (5)',
    'Líneas (5)',
    'Pastel (5)',
    'Histograma (5)',
    'Dispersión (5)',
    'Áreas (5)',
    'Caja y Bigotes (5)',
    'Combinadas (5)',
  ];

  static const List<Widget> _barCharts = [
    SfBarChartWidget01(),
    SfBarChartWidget02(),
    SfBarChartWidget03(),
    SfBarChartWidget04(),
    SfBarChartWidget05(),
  ];

  static const List<Widget> _lineCharts = [
    SfLineChartWidget01(),
    SfLineChartWidget02(),
    SfLineChartWidget03(),
    SfLineChartWidget04(),
    SfLineChartWidget05(),
  ];

  static const List<Widget> _pieCharts = [
    SfPieChartWidget01(),
    SfPieChartWidget02(),
    SfPieChartWidget03(),
    SfPieChartWidget04(),
    SfPieChartWidget05(),
  ];

  static const List<Widget> _histogramCharts = [
    SfHistogramChartWidget01(),
    SfHistogramChartWidget02(),
    SfHistogramChartWidget03(),
    SfHistogramChartWidget04(),
    SfHistogramChartWidget05(),
  ];

  static const List<Widget> _scatterCharts = [
    SfScatterChartWidget01(),
    SfScatterChartWidget02(),
    SfScatterChartWidget03(),
    SfScatterChartWidget04(),
    SfScatterChartWidget05(),
  ];

  static const List<Widget> _areaCharts = [
    SfAreaChartWidget01(),
    SfAreaChartWidget02(),
    SfAreaChartWidget03(),
    SfAreaChartWidget04(),
    SfAreaChartWidget05(),
  ];

  static const List<Widget> _boxCharts = [
    SfBoxChartWidget01(),
    SfBoxChartWidget02(),
    SfBoxChartWidget03(),
    SfBoxChartWidget04(),
    SfBoxChartWidget05(),
  ];

  static const List<Widget> _comboCharts = [
    SfComboChartWidget01(),
    SfComboChartWidget02(),
    SfComboChartWidget03(),
    SfComboChartWidget04(),
    SfComboChartWidget05(),
  ];

  List<Widget> _getFilteredCharts() {
    switch (_selectedCategoryIndex) {
      case 1:
        return _barCharts;
      case 2:
        return _lineCharts;
      case 3:
        return _pieCharts;
      case 4:
        return _histogramCharts;
      case 5:
        return _scatterCharts;
      case 6:
        return _areaCharts;
      case 7:
        return _boxCharts;
      case 8:
        return _comboCharts;
      case 0:
      default:
        return [
          _buildCategoryHeader('📊 1. Gráficos de Barras y Columnas (01 - 05)', Colors.blue),
          ..._barCharts,
          _buildCategoryHeader('📈 2. Gráficos de Líneas y Spline (06 - 10)', Colors.indigo),
          ..._lineCharts,
          _buildCategoryHeader('🥧 3. Gráficos Circulares y Dona (11 - 15)', Colors.orange),
          ..._pieCharts,
          _buildCategoryHeader('📶 4. Histogramas de Distribución (16 - 20)', Colors.teal),
          ..._histogramCharts,
          _buildCategoryHeader('⚬ 5. Gráficos de Dispersión / Scatter (21 - 25)', Colors.purple),
          ..._scatterCharts,
          _buildCategoryHeader('🏔️ 6. Gráficos de Áreas (26 - 30)', Colors.redAccent),
          ..._areaCharts,
          _buildCategoryHeader('📦 7. Gráficos de Caja y Bigotes / BoxPlot (31 - 35)', Colors.amber[800]!),
          ..._boxCharts,
          _buildCategoryHeader('✨ 8. Gráficos Combinados (36 - 40)', Colors.deepPurple),
          ..._comboCharts,
        ];
    }
  }

  Widget _buildCategoryHeader(String title, Color color) {
    return Container(
      margin: const EdgeInsets.only(top: 16, bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Icon(Icons.insights, size: 20, color: color),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final charts = _getFilteredCharts();

    return Column(
      children: [
        // Selector horizontal de categoría
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final isSelected = _selectedCategoryIndex == index;
              return ChoiceChip(
                label: Text(_categories[index]),
                selected: isSelected,
                selectedColor: Colors.redAccent,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : null,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 13,
                ),
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _selectedCategoryIndex = index;
                    });
                  }
                },
              );
            },
          ),
        ),
        const Divider(height: 1),

        // Lista de gráficos renderizados
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: charts.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) => charts[index],
          ),
        ),
      ],
    );
  }
}
