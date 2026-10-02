// ===========================================================================
// charts_graphic.dart — ARCHIVO "BARRIL" (barrel file)
// ===========================================================================
// Qué es un barril: un archivo que no define nada propio; solo junta y
// reexporta otros archivos con `export`. Quien haga
//   import 'charts_graphic.dart';
// recibe de una vez todo lo que estos archivos declaran como público
// (las clases GraphicNormal01…40, GraphicAdvanced01…25, la tarjeta y los
// datos), sin escribir once imports distintos.
//
// Diferencia entre import y export:
//   - import  = "yo uso lo de ese archivo".
//   - export  = "quien me importe a mí, también recibe lo de ese archivo".
//
// Quién lo importa:
//   - graphic_charts_view.dart (la vista con filtros), porque necesita
//     construir los 65 widgets de gráfico de todas las categorías.
//   - test/graphic_charts_test.dart, para usar GraphicChartCard en las
//     pruebas.
//
// Mapa de la carpeta lib/presentation/widgets/charts_graphic/:
//   graphic_data.dart        → datos de Pokémon y atajos (variables, ejes)
//   graphic_chart_card.dart  → la tarjeta común que envuelve cada gráfico
//   graphic_normal_*.dart    → los 40 gráficos normales (N01–N40)
//   graphic_advanced_*.dart  → los 25 gráficos avanzados (A01–A25)
//   graphic_charts_view.dart → la pestaña que lista y filtra los 65
//   charts_graphic.dart      → este barril
//
// Cadena completa hasta la pantalla:
//   pubspec.yaml (graphic: ^2.7.0) → cada archivo hace
//   import 'package:graphic/graphic.dart' → widget GraphicNormalXX →
//   GraphicChartCard → GraphicChartsView → pestaña "graphic (40 + 25)" en
//   ChartsGalleryScreen → botón de gráficos en HomeScreen.
// ===========================================================================

// Exportación de los 65 gráficos hechos con la librería graphic
// (40 normales + 25 avanzados).

// Piezas compartidas: la tarjeta y los datos/atajos.
export 'graphic_chart_card.dart';
export 'graphic_data.dart';

// Normales
export 'graphic_normal_bar_charts.dart'; // N01–N08 barras y columnas
export 'graphic_normal_line_area_charts.dart'; // N09–N15 líneas, N16–N21 áreas
export 'graphic_normal_point_charts.dart'; // N22–N27 dispersión
export 'graphic_normal_polar_charts.dart'; // N28–N35 circulares, N36–N38 radar
export 'graphic_normal_other_charts.dart'; // N39 mapa de calor, N40 histograma

// Avanzados
export 'graphic_advanced_interaction_charts.dart'; // A01–A08 interacción
export 'graphic_advanced_dynamic_charts.dart'; // A09–A15 dinámicos
export 'graphic_advanced_special_charts.dart'; // A16–A25 formas y composición
