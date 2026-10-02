// ===========================================================================
// charts_community.dart — ARCHIVO BARRIL de community_charts_flutter
// ===========================================================================
// No define nada: reexporta. Quien haga `import 'charts_community.dart';`
// recibe los 65 gráficos (CommunityNormal01…40, CommunityAdvanced01…25), la
// tarjeta y los datos. Es el mismo patrón que charts.dart (fl_chart),
// charts_syncfusion.dart (Syncfusion) y charts_graphic.dart (graphic).
//
// Mapa de la carpeta lib/presentation/widgets/charts_community/:
//   community_data.dart        → datos de Pokémon/generaciones y atajos
//   community_chart_card.dart  → la tarjeta común
//   community_normal_*.dart    → los 40 normales (N01–N40)
//   community_advanced_*.dart  → los 25 avanzados (A01–A25)
//   community_charts_view.dart → la pestaña que los lista y filtra
//   charts_community.dart      → este barril
//
// Cadena hasta la pantalla:
//   pubspec.yaml (community_charts_flutter: ^1.0.4) → cada archivo importa
//   'package:community_charts_flutter/community_charts_flutter.dart' as
//   charts → CommunityNormalXX → CommunityChartCard → CommunityChartsView →
//   pestaña "community_charts (40 + 25)" de ChartsGalleryScreen → botón de
//   gráficos del AppBar de HomeScreen.
// ===========================================================================

export 'community_chart_card.dart';
export 'community_data.dart';

// Normales
export 'community_normal_bar_charts.dart'; // N01–N10 barras
export 'community_normal_line_charts.dart'; // N11–N18 líneas y áreas
export 'community_normal_pie_scatter_charts.dart'; // N19–N24 tortas, N25–N29 dispersión
export 'community_normal_time_combo_charts.dart'; // N30–N34 tiempo, N35–N40 combos y ejes

// Avanzados
export 'community_advanced_interaction_charts.dart'; // A01–A08 interacción
export 'community_advanced_legend_annotation_charts.dart'; // A09–A18 leyendas y anotaciones
export 'community_advanced_data_charts.dart'; // A19–A25 porcentajes, datos vivos, renderers
