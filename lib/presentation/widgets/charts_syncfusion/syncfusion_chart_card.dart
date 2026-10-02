import 'package:flutter/material.dart';

/// Tarjeta para los gráficos realizados con Syncfusion Flutter Charts
class SyncfusionChartCard extends StatelessWidget {
  /// Código del gráfico: N01…N40 (normales) o A01…A25 (avanzados).
  final String code;
  final String title;
  final String description;
  final Widget chart;
  final double height;

  /// Controles opcionales sobre el gráfico (filtros, botones, switches).
  final Widget? controls;

  const SyncfusionChartCard({
    super.key,
    required this.code,
    required this.title,
    required this.description,
    required this.chart,
    this.height = 290,
    this.controls,
  });

  bool get isAdvanced => code.startsWith('A');

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final badgeColor = isAdvanced ? Colors.deepOrange : Colors.indigo;

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
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
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
          ],
        ),
      ),
    );
  }
}
