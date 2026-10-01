import 'package:flutter/material.dart';

/// Modelo para datos categóricos simples (X: texto, Y: valor numérico)
class CategoricalChartData {
  final String x;
  final double y;
  final Color? color;

  const CategoricalChartData(this.x, this.y, [this.color]);
}

/// Modelo para datos de series múltiples (X: texto, Y1, Y2, Y3)
class MultiSeriesChartData {
  final String x;
  final double y1;
  final double y2;
  final double? y3;

  const MultiSeriesChartData(this.x, this.y1, this.y2, [this.y3]);
}

/// Modelo para datos numéricos cartesianos (X: número, Y: número)
class NumericChartPoint {
  final double x;
  final double y;
  final String? label;

  const NumericChartPoint(this.x, this.y, [this.label]);
}

/// Modelo para gráficos de rangos (X: número, Mínimo: low, Máximo: high)
class RangeChartData {
  final double x;
  final double low;
  final double high;

  const RangeChartData(this.x, this.low, this.high);
}

/// Modelo para gráficos de Caja y Bigotes (X: categoría, Y: lista de valores)
class BoxPlotChartData {
  final String x;
  final List<double> values;

  const BoxPlotChartData(this.x, this.values);
}

/// Modelo para datos de histograma
class HistogramChartData {
  final double value;

  const HistogramChartData(this.value);
}
