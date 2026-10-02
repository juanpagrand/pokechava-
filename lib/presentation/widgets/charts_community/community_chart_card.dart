// Tarjeta común para los gráficos de community_charts.
// Alto fijo porque dentro de un ListView el gráfico no sabe cuánto medir.

import 'package:flutter/material.dart';

class CommunityChartCard extends StatelessWidget {
  /// N01…N40 (normales) o A01…A25 (avanzados).
  final String code;
  final String title;
  final String description;
  final Widget chart;
  final double height;

  /// Botones opcionales encima del gráfico.
  final Widget? controls;

  /// Texto opcional debajo del gráfico.
  final Widget? footer;

  const CommunityChartCard({
    super.key,
    required this.code,
    required this.title,
    required this.description,
    required this.chart,
    this.height = 260,
    this.controls,
    this.footer,
  });

  bool get isAdvanced => code.startsWith('A');

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    // naranja = normales, índigo = avanzados
    final badgeColor = isAdvanced ? Colors.indigo : Colors.deepOrange;
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: badgeColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    code,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                      color: badgeColor,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
            ),
            if (controls != null) ...[
              const SizedBox(height: 10),
              controls!,
            ],
            const SizedBox(height: 12),
            SizedBox(height: height, child: chart),
            if (footer != null) ...[
              const SizedBox(height: 8),
              footer!,
            ],
          ],
        ),
      ),
    );
  }
}
