// ===========================================================================
// graphic_charts_view.dart — LA PESTAÑA "graphic (40 + 25)"
// ===========================================================================
// Qué contiene:
//   - _categories: los 65 gráficos agrupados en 10 categorías (7 de
//     normales N01–N40 y 3 de avanzados A01–A25).
//   - graphicChartBuilders / graphicChartCount: funciones públicas para el
//     test y para mostrar cantidades.
//   - GraphicChartsView: el widget con estado que muestra un selector
//     Normales/Avanzados (SegmentedButton), chips de categoría (ChoiceChip)
//     y la lista de tarjetas.
//
// Imports:
//   - flutter/material.dart → widgets de la interfaz.
//   - charts_graphic.dart   → el barril: trae de una vez las 65 clases
//     GraphicNormalXX / GraphicAdvancedXX que se listan abajo.
//
// Quién lo importa:
//   - lib/presentation/screens/charts_gallery_screen.dart, que pone
//     GraphicChartsView() como contenido de la 2.ª pestaña.
//   - test/graphic_charts_test.dart, que usa graphicChartBuilders().
// ===========================================================================

import 'package:flutter/material.dart';

import 'charts_graphic.dart';

// Una categoría del filtro (p. ej. "Barras"). El guion bajo la hace
// privada a este archivo.
class _Category {
  // Nombre que se ve en el chip.
  final String name;
  // true = pertenece a "Avanzados"; false = "Normales".
  final bool advanced;
  // Se guardan FUNCIONES que crean el widget (`Widget Function()`), no los
  // widgets ya creados. Así el gráfico solo se construye cuando la lista lo
  // va a mostrar (creación perezosa): ListView.separated llama a
  // itemBuilder solo para lo que está en pantalla, y los gráficos con
  // Timer (A13) no arrancan hasta que se ven.
  final List<Widget Function()> charts;

  const _Category(this.name, this.advanced, this.charts);
}

// La lista maestra. El orden aquí es el orden en pantalla y el que revisa
// el test (N01…N40, A01…A25 sin saltos). `() => const GraphicNormal01()`
// es una función sin parámetros que devuelve el widget.
final List<_Category> _categories = [
  _Category('Barras', false, [
    () => const GraphicNormal01(),
    () => const GraphicNormal02(),
    () => const GraphicNormal03(),
    () => const GraphicNormal04(),
    () => const GraphicNormal05(),
    () => const GraphicNormal06(),
    () => const GraphicNormal07(),
    () => const GraphicNormal08(),
  ]),
  _Category('Líneas', false, [
    () => const GraphicNormal09(),
    () => const GraphicNormal10(),
    () => const GraphicNormal11(),
    () => const GraphicNormal12(),
    () => const GraphicNormal13(),
    () => const GraphicNormal14(),
    () => const GraphicNormal15(),
  ]),
  _Category('Áreas', false, [
    () => const GraphicNormal16(),
    () => const GraphicNormal17(),
    () => const GraphicNormal18(),
    () => const GraphicNormal19(),
    () => const GraphicNormal20(),
    () => const GraphicNormal21(),
  ]),
  _Category('Dispersión', false, [
    () => const GraphicNormal22(),
    () => const GraphicNormal23(),
    () => const GraphicNormal24(),
    () => const GraphicNormal25(),
    () => const GraphicNormal26(),
    () => const GraphicNormal27(),
  ]),
  _Category('Circulares', false, [
    () => const GraphicNormal28(),
    () => const GraphicNormal29(),
    () => const GraphicNormal30(),
    () => const GraphicNormal31(),
    () => const GraphicNormal32(),
    () => const GraphicNormal33(),
    () => const GraphicNormal34(),
    () => const GraphicNormal35(),
  ]),
  _Category('Radar y polar', false, [
    () => const GraphicNormal36(),
    () => const GraphicNormal37(),
    () => const GraphicNormal38(),
  ]),
  _Category('Calor e histograma', false, [
    () => const GraphicNormal39(),
    () => const GraphicNormal40(),
  ]),
  _Category('Interacción', true, [
    () => const GraphicAdvanced01(),
    () => const GraphicAdvanced02(),
    () => const GraphicAdvanced03(),
    () => const GraphicAdvanced04(),
    () => const GraphicAdvanced05(),
    () => const GraphicAdvanced06(),
    () => const GraphicAdvanced07(),
    () => const GraphicAdvanced08(),
  ]),
  _Category('Dinámicos', true, [
    () => const GraphicAdvanced09(),
    () => const GraphicAdvanced10(),
    () => const GraphicAdvanced11(),
    () => const GraphicAdvanced12(),
    () => const GraphicAdvanced13(),
    () => const GraphicAdvanced14(),
    () => const GraphicAdvanced15(),
  ]),
  _Category('Formas y composición', true, [
    () => const GraphicAdvanced16(),
    () => const GraphicAdvanced17(),
    () => const GraphicAdvanced18(),
    () => const GraphicAdvanced19(),
    () => const GraphicAdvanced20(),
    () => const GraphicAdvanced21(),
    () => const GraphicAdvanced22(),
    () => const GraphicAdvanced23(),
    () => const GraphicAdvanced24(),
    () => const GraphicAdvanced25(),
  ]),
];

/// Todos los gráficos en orden (N01…N40, A01…A25), para pruebas y conteos.
// Público (sin guion bajo) porque lo usa test/graphic_charts_test.dart:
// sin parámetro devuelve los 65; con advanced: false/true, solo un nivel.
// Usa un "for de colección" con `if` y `...` para aplanar las categorías.
List<Widget Function()> graphicChartBuilders({bool? advanced}) => [
      for (final c in _categories)
        if (advanced == null || c.advanced == advanced) ...c.charts,
    ];

/// Cantidad total de gráficos por nivel, calculada desde las categorías.
// Se calcula (no se escribe "40" a mano): si se agrega un gráfico a una
// categoría, el número del botón se actualiza solo. `fold` suma los
// tamaños de las listas empezando en 0.
int graphicChartCount({required bool advanced}) => _categories
    .where((c) => c.advanced == advanced)
    .fold(0, (sum, c) => sum + c.charts.length);

/// Vista de los 65 gráficos de graphic, filtrable por nivel y categoría.
// StatefulWidget porque recuerda qué nivel y qué categoría eligió el
// usuario; el estado vive en _GraphicChartsViewState.
class GraphicChartsView extends StatefulWidget {
  const GraphicChartsView({super.key});

  @override
  State<GraphicChartsView> createState() => _GraphicChartsViewState();
}

class _GraphicChartsViewState extends State<GraphicChartsView> {
  // Nivel elegido: false = Normales (por defecto), true = Avanzados.
  bool _advanced = false;
  // Categoría elegida; null significa "Todos".
  String? _category;

  @override
  Widget build(BuildContext context) {
    // Categorías del nivel actual (para dibujar los chips).
    final level = _categories.where((c) => c.advanced == _advanced).toList();
    // Categorías que se muestran: todas o solo la elegida.
    final shown = level.where((c) => _category == null || c.name == _category);
    // Lista plana de constructores de gráficos a mostrar.
    final charts = [for (final c in shown) ...c.charts];
    // Totales para las etiquetas "Normales (40)" y "Avanzados (25)".
    final normals = graphicChartCount(advanced: false);
    final advanceds = graphicChartCount(advanced: true);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          // Selector de dos segmentos de Material 3. <bool> porque cada
          // segmento tiene un valor booleano (false/true).
          child: SegmentedButton<bool>(
            segments: [
              ButtonSegment(
                value: false,
                icon: const Icon(Icons.insert_chart_outlined),
                label: Text('Normales ($normals)'),
              ),
              ButtonSegment(
                value: true,
                icon: const Icon(Icons.auto_awesome),
                label: Text('Avanzados ($advanceds)'),
              ),
            ],
            // SegmentedButton trabaja con un Set (admite multiselección);
            // aquí siempre hay un solo valor elegido.
            selected: {_advanced},
            // Al cambiar de nivel se guarda el nuevo valor y se vuelve a
            // "Todos", porque las categorías del otro nivel son distintas.
            // setState hace que build se ejecute de nuevo.
            onSelectionChanged: (s) => setState(() {
              _advanced = s.first;
              _category = null;
            }),
          ),
        ),
        // Fila horizontal desplazable de chips de categoría.
        SizedBox(
          height: 48,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            children: [
              // Chip "Todos" (valor null) con la suma de todo el nivel.
              _chip('Todos', null,
                  level.fold(0, (sum, c) => sum + c.charts.length)),
              // Un chip por categoría, con su cantidad.
              for (final c in level) _chip(c.name, c.name, c.charts.length),
            ],
          ),
        ),
        // Expanded: la lista ocupa todo el alto que queda en la pestaña.
        Expanded(
          child: ListView.separated(
            // PageStorageKey guarda la posición de scroll de cada
            // combinación nivel/categoría: al cambiar de filtro o de
            // pestaña y volver, la lista vuelve a donde estaba.
            key: PageStorageKey('graphic-$_advanced-$_category'),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            itemCount: charts.length,
            separatorBuilder: (_, _) => const SizedBox(height: 14),
            // Aquí se llama a la función guardada: recién ahora se crea el
            // widget del gráfico (solo para los ítems visibles).
            itemBuilder: (_, i) => charts[i](),
          ),
        ),
      ],
    );
  }

  // Crea un ChoiceChip (chip de selección única). `value` es la categoría
  // que representa (null = Todos); se ve marcado si coincide con la actual.
  Widget _chip(String label, String? value, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text('$label ($count)'),
        selected: _category == value,
        onSelected: (_) => setState(() => _category = value),
      ),
    );
  }
}
