// ===========================================================================
// graphic_chart_card.dart — LA TARJETA QUE ENVUELVE CADA GRÁFICO
// ===========================================================================
// Qué contiene: GraphicChartCard, un widget de Flutter puro (no usa
// graphic). Da a los 65 gráficos (N01–N40 y A01–A25) el mismo marco:
// código de color (N verde azulado, A morado), título, descripción,
// controles opcionales y una caja de altura fija donde va el gráfico.
//
// Import: solo flutter/material.dart (Card, Text, Row, Column, Colors…).
//
// Quién lo importa: cada graphic_normal_*.dart y graphic_advanced_*.dart
// (todos devuelven un GraphicChartCard en su build), y el barril
// charts_graphic.dart lo reexporta (lo usa el test con find.byType).
// ===========================================================================

import 'package:flutter/material.dart';

/// Tarjeta común para los 65 gráficos hechos con la librería graphic.
// StatelessWidget: no guarda estado propio; solo pinta lo que recibe.
class GraphicChartCard extends StatelessWidget {
  /// Código visible del gráfico: N01…N40 (normales) o A01…A25 (avanzados).
  final String code;
  final String title;
  final String description;
  // El gráfico en sí. Es un Widget cualquiera: normalmente un Chart, pero
  // A07 pasa una Column con dos Chart y A25 un GridView con nueve.
  final Widget chart;
  // Alto de la zona del gráfico (260 por defecto).
  final double height;

  /// Controles opcionales encima del gráfico (botones, selectores…).
  final Widget? controls;

  // `required` = obligatorio; height y controls son opcionales.
  // `super.key` pasa la key al padre (StatelessWidget).
  const GraphicChartCard({
    super.key,
    required this.code,
    required this.title,
    required this.description,
    required this.chart,
    this.height = 260,
    this.controls,
  });

  // Los avanzados empiezan con 'A' (A01…A25): cambia el color del código.
  bool get isAdvanced => code.startsWith('A');

  @override
  Widget build(BuildContext context) {
    // Colores del tema actual (claro u oscuro) para el texto secundario.
    final scheme = Theme.of(context).colorScheme;
    final badgeColor = isAdvanced ? Colors.deepPurple : Colors.teal;
    return Card(
      elevation: 2,
      // Recorta el contenido a las esquinas redondeadas de la tarjeta.
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fila de cabecera: "insignia" con el código + título.
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
                // Expanded: el título usa el ancho restante y hace salto
                // de línea en vez de desbordarse.
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
            // Descripción: qué técnica de graphic muestra este gráfico.
            Text(
              description,
              style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
            ),
            // "if de colección": estos dos widgets solo se agregan si hay
            // controles; `...[ ]` los inserta sueltos dentro de children.
            if (controls != null) ...[
              const SizedBox(height: 10),
              controls!,
            ],
            const SizedBox(height: 12),
            // Altura fija para el gráfico. Un Chart de graphic ocupa todo
            // el espacio que le dan; dentro de un ListView el alto no tiene
            // límite, así que sin este SizedBox no sabría cuánto medir.
            SizedBox(height: height, child: chart),
          ],
        ),
      ),
    );
  }
}
