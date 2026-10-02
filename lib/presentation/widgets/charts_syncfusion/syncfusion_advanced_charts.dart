import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'syncfusion_chart_card.dart';
import 'syncfusion_data_models.dart';

// ============================================================================
// A01: Zoom & Pan Cartesiano en Total de Stats
// ============================================================================
class SyncfusionAdvanced01 extends StatelessWidget {
  const SyncfusionAdvanced01({super.key});

  @override
  Widget build(BuildContext context) {
    final List<CategoricalChartData> data = [
      const CategoricalChartData('Bulbasaur', 318, Colors.green),
      const CategoricalChartData('Ivysaur', 405, Colors.green),
      const CategoricalChartData('Venusaur', 525, Colors.teal),
      const CategoricalChartData('Charmander', 309, Colors.orange),
      const CategoricalChartData('Charmeleon', 405, Colors.orange),
      const CategoricalChartData('Charizard', 534, Colors.deepOrange),
      const CategoricalChartData('Squirtle', 314, Colors.blue),
      const CategoricalChartData('Wartortle', 405, Colors.blue),
      const CategoricalChartData('Blastoise', 530, Colors.indigo),
      const CategoricalChartData('Pikachu', 320, Colors.amber),
      const CategoricalChartData('Raichu', 485, Colors.amber),
      const CategoricalChartData('Alakazam', 500, Colors.purple),
      const CategoricalChartData('Machamp', 505, Colors.brown),
      const CategoricalChartData('Gengar', 500, Colors.deepPurple),
      const CategoricalChartData('Gyarados', 540, Colors.cyan),
      const CategoricalChartData('Lapras', 535, Colors.blueGrey),
      const CategoricalChartData('Snorlax', 540, Colors.blueGrey),
      const CategoricalChartData('Dragonite', 600, Colors.indigo),
      const CategoricalChartData('Mewtwo', 680, Colors.purpleAccent),
      const CategoricalChartData('Mew', 600, Colors.pinkAccent),
    ];

    return SyncfusionChartCard(
      code: 'A01',
      title: 'Pellizco y Desplazamiento (Zoom & Pan)',
      description: 'Arrastra horizontalmente o pellizca para explorar el BST de los 20 Pokémon.',
      chart: SfCartesianChart(
        primaryXAxis: const CategoryAxis(
          labelRotation: -45,
          labelIntersectAction: AxisLabelIntersectAction.none,
        ),
        primaryYAxis: const NumericAxis(minimum: 200, maximum: 720),
        zoomPanBehavior: ZoomPanBehavior(
          enablePinching: true,
          enablePanning: true,
          zoomMode: ZoomMode.x,
        ),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <CartesianSeries<CategoricalChartData, String>>[
          ColumnSeries<CategoricalChartData, String>(
            dataSource: data,
            xValueMapper: (CategoricalChartData d, _) => d.x,
            yValueMapper: (CategoricalChartData d, _) => d.y,
            pointColorMapper: (CategoricalChartData d, _) => d.color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// A02: Trackball Sincronizado para Ataque Físico vs Ataque Especial
// ============================================================================
class SyncfusionAdvanced02 extends StatelessWidget {
  const SyncfusionAdvanced02({super.key});

  @override
  Widget build(BuildContext context) {
    final List<MultiSeriesChartData> data = [
      const MultiSeriesChartData('Charizard', 84, 109),
      const MultiSeriesChartData('Gengar', 65, 130),
      const MultiSeriesChartData('Alakazam', 50, 135),
      const MultiSeriesChartData('Machamp', 130, 65),
      const MultiSeriesChartData('Dragonite', 134, 100),
      const MultiSeriesChartData('Mewtwo', 110, 154),
      const MultiSeriesChartData('Snorlax', 110, 65),
      const MultiSeriesChartData('Gyarados', 125, 60),
    ];

    return SyncfusionChartCard(
      code: 'A02',
      title: 'Trackball Interactivo Físico vs Especial',
      description: 'Toca sobre la gráfica para comparar ambos valores simultáneamente con línea guía.',
      chart: SfCartesianChart(
        primaryXAxis: const CategoryAxis(),
        primaryYAxis: const NumericAxis(minimum: 40, maximum: 170),
        trackballBehavior: TrackballBehavior(
          enable: true,
          activationMode: ActivationMode.singleTap,
          tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
        ),
        legend: const Legend(isVisible: true, position: LegendPosition.top),
        series: <CartesianSeries<MultiSeriesChartData, String>>[
          SplineSeries<MultiSeriesChartData, String>(
            name: 'Ataque Físico',
            dataSource: data,
            xValueMapper: (MultiSeriesChartData d, _) => d.x,
            yValueMapper: (MultiSeriesChartData d, _) => d.y1,
            color: Colors.redAccent,
            width: 3,
            markerSettings: const MarkerSettings(isVisible: true),
          ),
          SplineSeries<MultiSeriesChartData, String>(
            name: 'Ataque Especial',
            dataSource: data,
            xValueMapper: (MultiSeriesChartData d, _) => d.x,
            yValueMapper: (MultiSeriesChartData d, _) => d.y2,
            color: Colors.deepPurpleAccent,
            width: 3,
            markerSettings: const MarkerSettings(isVisible: true),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// A03: Selección de Puntos con Resaltado y Atenuado
// ============================================================================
class SyncfusionAdvanced03 extends StatelessWidget {
  const SyncfusionAdvanced03({super.key});

  @override
  Widget build(BuildContext context) {
    final List<CategoricalChartData> data = [
      const CategoricalChartData('Pikachu', 90, Colors.amber),
      const CategoricalChartData('Gengar', 110, Colors.purple),
      const CategoricalChartData('Aerodactyl', 130, Colors.blueGrey),
      const CategoricalChartData('Alakazam', 120, Colors.orange),
      const CategoricalChartData('Jolteon', 130, Colors.yellow),
      const CategoricalChartData('Electrode', 150, Colors.red),
      const CategoricalChartData('Mewtwo', 130, Colors.deepPurple),
    ];

    return SyncfusionChartCard(
      code: 'A03',
      title: 'Selección con Enfoque de Velocidad',
      description: 'Toca una columna para destacarla en azul; las no seleccionadas reducen su opacidad.',
      chart: SfCartesianChart(
        primaryXAxis: const CategoryAxis(),
        primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Velocidad Base')),
        selectionGesture: ActivationMode.singleTap,
        series: <CartesianSeries<CategoricalChartData, String>>[
          ColumnSeries<CategoricalChartData, String>(
            dataSource: data,
            xValueMapper: (CategoricalChartData d, _) => d.x,
            yValueMapper: (CategoricalChartData d, _) => d.y,
            pointColorMapper: (CategoricalChartData d, _) => d.color,
            selectionBehavior: SelectionBehavior(
              enable: true,
              selectedColor: Colors.blueAccent,
              unselectedOpacity: 0.35,
            ),
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// A04: Batalla en Tiempo Real Dinámica (Buffer Deslizante)
// ============================================================================
class SyncfusionAdvanced04 extends StatefulWidget {
  const SyncfusionAdvanced04({super.key});

  @override
  State<SyncfusionAdvanced04> createState() => _SyncfusionAdvanced04State();
}

class _SyncfusionAdvanced04State extends State<SyncfusionAdvanced04> {
  Timer? _timer;
  int _turn = 6;
  final List<NumericChartPoint> _charizardHp = [
    const NumericChartPoint(1, 100),
    const NumericChartPoint(2, 88),
    const NumericChartPoint(3, 75),
    const NumericChartPoint(4, 75),
    const NumericChartPoint(5, 52),
    const NumericChartPoint(6, 40),
  ];
  final List<NumericChartPoint> _blastoiseHp = [
    const NumericChartPoint(1, 100),
    const NumericChartPoint(2, 92),
    const NumericChartPoint(3, 85),
    const NumericChartPoint(4, 70),
    const NumericChartPoint(5, 64),
    const NumericChartPoint(6, 58),
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 1400), (_) {
      if (!mounted) return;
      setState(() {
        _turn++;
        final rand1 = (math.Random().nextInt(16) + 4).toDouble();
        final rand2 = (math.Random().nextInt(14) + 3).toDouble();
        final last1 = _charizardHp.last.y;
        final last2 = _blastoiseHp.last.y;

        final new1 = (last1 - rand1).clamp(10.0, 100.0);
        final new2 = (last2 - rand2).clamp(12.0, 100.0);

        _charizardHp.add(NumericChartPoint(_turn.toDouble(), new1));
        _blastoiseHp.add(NumericChartPoint(_turn.toDouble(), new2));

        if (_charizardHp.length > 12) {
          _charizardHp.removeAt(0);
          _blastoiseHp.removeAt(0);
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SyncfusionChartCard(
      code: 'A04',
      title: 'Simulación de Batalla en Tiempo Real',
      description: 'Stream animado que proyecta los puntos de salud de Charizard vs Blastoise en cada turno.',
      chart: SfCartesianChart(
        primaryXAxis: const NumericAxis(title: AxisTitle(text: 'Turno de Combate')),
        primaryYAxis: const NumericAxis(minimum: 0, maximum: 105, title: AxisTitle(text: '% PS Restante')),
        legend: const Legend(isVisible: true, position: LegendPosition.top),
        series: <CartesianSeries<NumericChartPoint, num>>[
          SplineSeries<NumericChartPoint, num>(
            name: 'Charizard PS',
            dataSource: _charizardHp,
            xValueMapper: (NumericChartPoint p, _) => p.x,
            yValueMapper: (NumericChartPoint p, _) => p.y,
            color: Colors.deepOrange,
            width: 3,
            markerSettings: const MarkerSettings(isVisible: true),
          ),
          SplineSeries<NumericChartPoint, num>(
            name: 'Blastoise PS',
            dataSource: _blastoiseHp,
            xValueMapper: (NumericChartPoint p, _) => p.x,
            yValueMapper: (NumericChartPoint p, _) => p.y,
            color: Colors.blue,
            width: 3,
            markerSettings: const MarkerSettings(isVisible: true),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// A05: Ordenamiento Animado con Filtro por Estadísticas
// ============================================================================
class SyncfusionAdvanced05 extends StatefulWidget {
  const SyncfusionAdvanced05({super.key});

  @override
  State<SyncfusionAdvanced05> createState() => _SyncfusionAdvanced05State();
}

class _SyncfusionAdvanced05State extends State<SyncfusionAdvanced05> {
  String _selectedStat = 'Ataque';

  static final Map<String, List<CategoricalChartData>> _statData = {
    'Ataque': [
      const CategoricalChartData('Dragonite', 134, Colors.redAccent),
      const CategoricalChartData('Machamp', 130, Colors.redAccent),
      const CategoricalChartData('Gyarados', 125, Colors.redAccent),
      const CategoricalChartData('Snorlax', 110, Colors.redAccent),
      const CategoricalChartData('Charizard', 84, Colors.redAccent),
    ],
    'Defensa': [
      const CategoricalChartData('Onix', 160, Colors.brown),
      const CategoricalChartData('Cloyster', 180, Colors.brown),
      const CategoricalChartData('Golem', 130, Colors.brown),
      const CategoricalChartData('Blastoise', 100, Colors.brown),
      const CategoricalChartData('Dragonite', 95, Colors.brown),
    ],
    'Velocidad': [
      const CategoricalChartData('Electrode', 150, Colors.amber),
      const CategoricalChartData('Aerodactyl', 130, Colors.amber),
      const CategoricalChartData('Jolteon', 130, Colors.amber),
      const CategoricalChartData('Alakazam', 120, Colors.amber),
      const CategoricalChartData('Gengar', 110, Colors.amber),
    ],
    'Total': [
      const CategoricalChartData('Mewtwo', 680, Colors.deepPurple),
      const CategoricalChartData('Dragonite', 600, Colors.deepPurple),
      const CategoricalChartData('Gyarados', 540, Colors.deepPurple),
      const CategoricalChartData('Snorlax', 540, Colors.deepPurple),
      const CategoricalChartData('Charizard', 534, Colors.deepPurple),
    ],
  };

  @override
  Widget build(BuildContext context) {
    final data = _statData[_selectedStat]!;

    return SyncfusionChartCard(
      code: 'A05',
      title: 'Ordenamiento Animado de Pokémon',
      description: 'Elige la estadística deseada para reordenar dinámicamente las posiciones del ranking.',
      controls: Wrap(
        spacing: 8,
        children: ['Ataque', 'Defensa', 'Velocidad', 'Total'].map((s) {
          final isSelected = _selectedStat == s;
          return ChoiceChip(
            label: Text(s),
            selected: isSelected,
            onSelected: (_) => setState(() => _selectedStat = s),
          );
        }).toList(),
      ),
      chart: SfCartesianChart(
        primaryXAxis: const CategoryAxis(),
        primaryYAxis: const NumericAxis(),
        series: <CartesianSeries<CategoricalChartData, String>>[
          BarSeries<CategoricalChartData, String>(
            key: ValueKey(_selectedStat),
            dataSource: data,
            xValueMapper: (CategoricalChartData d, _) => d.x,
            yValueMapper: (CategoricalChartData d, _) => d.y,
            pointColorMapper: (CategoricalChartData d, _) => d.color,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
            borderRadius: const BorderRadius.horizontal(right: Radius.circular(6)),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// A06: Curva Spline con Gradiente Sombreado (Curvas de EXP)
// ============================================================================
class SyncfusionAdvanced06 extends StatelessWidget {
  const SyncfusionAdvanced06({super.key});

  @override
  Widget build(BuildContext context) {
    final List<NumericChartPoint> fastExp = [
      const NumericChartPoint(10, 800),
      const NumericChartPoint(25, 12500),
      const NumericChartPoint(50, 100000),
      const NumericChartPoint(75, 337500),
      const NumericChartPoint(100, 800000),
    ];

    final List<NumericChartPoint> slowExp = [
      const NumericChartPoint(10, 1250),
      const NumericChartPoint(25, 19530),
      const NumericChartPoint(50, 156250),
      const NumericChartPoint(75, 527340),
      const NumericChartPoint(100, 1250000),
    ];

    return SyncfusionChartCard(
      code: 'A06',
      title: 'Curvas de Experiencia con Sombreado Gradual',
      description: 'SplineAreaSeries comparando el ritmo de subida de nivel Rápido vs Lento.',
      chart: SfCartesianChart(
        primaryXAxis: const NumericAxis(title: AxisTitle(text: 'Nivel')),
        primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Puntos de Experiencia')),
        legend: const Legend(isVisible: true, position: LegendPosition.top),
        series: <CartesianSeries<NumericChartPoint, num>>[
          SplineAreaSeries<NumericChartPoint, num>(
            name: 'Grupo Lento (Dragonite)',
            dataSource: slowExp,
            xValueMapper: (NumericChartPoint p, _) => p.x,
            yValueMapper: (NumericChartPoint p, _) => p.y,
            gradient: LinearGradient(
              colors: [Colors.purple.withValues(alpha: 0.6), Colors.purple.withValues(alpha: 0.1)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderColor: Colors.purple,
            borderWidth: 2,
          ),
          SplineAreaSeries<NumericChartPoint, num>(
            name: 'Grupo Rápido (Clefable)',
            dataSource: fastExp,
            xValueMapper: (NumericChartPoint p, _) => p.x,
            yValueMapper: (NumericChartPoint p, _) => p.y,
            gradient: LinearGradient(
              colors: [Colors.teal.withValues(alpha: 0.6), Colors.teal.withValues(alpha: 0.1)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderColor: Colors.teal,
            borderWidth: 2,
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// A07: Evolución Escalonada (Step Line) de Poder de Starters
// ============================================================================
class SyncfusionAdvanced07 extends StatelessWidget {
  const SyncfusionAdvanced07({super.key});

  @override
  Widget build(BuildContext context) {
    final List<NumericChartPoint> charPoints = [
      const NumericChartPoint(1, 309),
      const NumericChartPoint(15, 309),
      const NumericChartPoint(16, 405),
      const NumericChartPoint(35, 405),
      const NumericChartPoint(36, 534),
      const NumericChartPoint(100, 534),
    ];

    final List<NumericChartPoint> blastPoints = [
      const NumericChartPoint(1, 314),
      const NumericChartPoint(15, 314),
      const NumericChartPoint(16, 405),
      const NumericChartPoint(35, 405),
      const NumericChartPoint(36, 530),
      const NumericChartPoint(100, 530),
    ];

    return SyncfusionChartCard(
      code: 'A07',
      title: 'Saltos de Nivel de Evolución (Step Line)',
      description: 'El escalonamiento resalta el incremento sustancial de stats en los niveles 16 y 36.',
      chart: SfCartesianChart(
        primaryXAxis: const NumericAxis(title: AxisTitle(text: 'Nivel')),
        primaryYAxis: const NumericAxis(minimum: 280, maximum: 580, title: AxisTitle(text: 'BST')),
        legend: const Legend(isVisible: true, position: LegendPosition.top),
        series: <CartesianSeries<NumericChartPoint, num>>[
          StepLineSeries<NumericChartPoint, num>(
            name: 'Línea Charmander',
            dataSource: charPoints,
            xValueMapper: (NumericChartPoint p, _) => p.x,
            yValueMapper: (NumericChartPoint p, _) => p.y,
            color: Colors.deepOrange,
            width: 3,
          ),
          StepLineSeries<NumericChartPoint, num>(
            name: 'Línea Squirtle',
            dataSource: blastPoints,
            xValueMapper: (NumericChartPoint p, _) => p.x,
            yValueMapper: (NumericChartPoint p, _) => p.y,
            color: Colors.blueAccent,
            width: 3,
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// A08: Gráfico de Burbujas Tridimensional (BubbleSeries)
// ============================================================================
class SyncfusionAdvanced08 extends StatelessWidget {
  const SyncfusionAdvanced08({super.key});

  @override
  Widget build(BuildContext context) {
    final List<BubbleChartData> data = [
      const BubbleChartData(0.7, 6.9, 318, 'Bulbasaur', Colors.green),
      const BubbleChartData(2.0, 100.0, 525, 'Venusaur', Colors.green),
      const BubbleChartData(0.6, 8.5, 309, 'Charmander', Colors.deepOrange),
      const BubbleChartData(1.7, 90.5, 534, 'Charizard', Colors.deepOrange),
      const BubbleChartData(0.5, 9.0, 314, 'Squirtle', Colors.blue),
      const BubbleChartData(1.6, 85.5, 530, 'Blastoise', Colors.blue),
      const BubbleChartData(0.4, 6.0, 320, 'Pikachu', Colors.amber),
      const BubbleChartData(1.5, 40.5, 500, 'Gengar', Colors.purple),
      const BubbleChartData(6.5, 235.0, 540, 'Gyarados', Colors.cyan),
      const BubbleChartData(2.1, 460.0, 540, 'Snorlax', Colors.blueGrey),
      const BubbleChartData(2.2, 210.0, 600, 'Dragonite', Colors.indigo),
      const BubbleChartData(2.0, 122.0, 680, 'Mewtwo', Colors.purpleAccent),
    ];

    return SyncfusionChartCard(
      code: 'A08',
      title: 'Burbujas: Altura vs Peso vs Total Stats',
      description: 'Eje X: Altura (m), Eje Y: Peso (kg). El tamaño de la burbuja refleja el Total de Estadísticas (BST).',
      chart: SfCartesianChart(
        primaryXAxis: const NumericAxis(title: AxisTitle(text: 'Altura (metros)')),
        primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Peso (kilogramos)')),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <CartesianSeries<BubbleChartData, num>>[
          BubbleSeries<BubbleChartData, num>(
            dataSource: data,
            xValueMapper: (BubbleChartData d, _) => d.x,
            yValueMapper: (BubbleChartData d, _) => d.y,
            sizeValueMapper: (BubbleChartData d, _) => d.size,
            pointColorMapper: (BubbleChartData d, _) => d.color.withValues(alpha: 0.7),
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelAlignment: ChartDataLabelAlignment.top,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// A09: Pirámide de Tiers Competitivos (SfPyramidChart)
// ============================================================================
class SyncfusionAdvanced09 extends StatelessWidget {
  const SyncfusionAdvanced09({super.key});

  @override
  Widget build(BuildContext context) {
    final List<FunnelChartData> data = [
      const FunnelChartData('Ubers (Legendarios)', 15, Colors.purple),
      const FunnelChartData('OverUsed (OU)', 45, Colors.indigo),
      const FunnelChartData('UnderUsed (UU)', 80, Colors.teal),
      const FunnelChartData('RarelyUsed (RU)', 120, Colors.amber),
      const FunnelChartData('NeverUsed (NU)', 190, Colors.deepOrange),
      const FunnelChartData('Little Cup (LC)', 350, Colors.grey),
    ];

    return SyncfusionChartCard(
      code: 'A09',
      title: 'Pirámide de Jerarquía Competitiva',
      description: 'Distribución porcentual de los Pokémon según sus Tiers en batallas competitivas.',
      chart: SfPyramidChart(
        tooltipBehavior: TooltipBehavior(enable: true),
        series: PyramidSeries<FunnelChartData, String>(
          dataSource: data,
          xValueMapper: (FunnelChartData d, _) => d.stage,
          yValueMapper: (FunnelChartData d, _) => d.value,
          pointColorMapper: (FunnelChartData d, _) => d.color,
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            labelPosition: ChartDataLabelPosition.inside,
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// A10: Embudo de Probabilidad de Captura (SfFunnelChart)
// ============================================================================
class SyncfusionAdvanced10 extends StatelessWidget {
  const SyncfusionAdvanced10({super.key});

  @override
  Widget build(BuildContext context) {
    final List<FunnelChartData> data = [
      const FunnelChartData('Encuentro Salvaje', 100, Colors.blue),
      const FunnelChartData('Daño Reducido (<20%)', 78, Colors.teal),
      const FunnelChartData('Estado Alterado (Sueño/Parálisis)', 60, Colors.amber),
      const FunnelChartData('Lanzamiento Ultra Ball', 48, Colors.orange),
      const FunnelChartData('Captura Exitosa (3 Vueltas)', 32, Colors.green),
    ];

    return SyncfusionChartCard(
      code: 'A10',
      title: 'Embudo de Efectividad de Captura',
      description: 'Fases secuenciales de captura en combate salvaje y tasa de retención final.',
      chart: SfFunnelChart(
        tooltipBehavior: TooltipBehavior(enable: true),
        series: FunnelSeries<FunnelChartData, String>(
          dataSource: data,
          xValueMapper: (FunnelChartData d, _) => d.stage,
          yValueMapper: (FunnelChartData d, _) => d.value,
          pointColorMapper: (FunnelChartData d, _) => d.color,
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            labelPosition: ChartDataLabelPosition.inside,
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// A11: Radial Bar Gauge de Roles del Equipo
// ============================================================================
class SyncfusionAdvanced11 extends StatelessWidget {
  const SyncfusionAdvanced11({super.key});

  @override
  Widget build(BuildContext context) {
    final List<RadialGaugeData> data = [
      const RadialGaugeData('Atacante Físico', 92, '92%', Colors.redAccent),
      const RadialGaugeData('Atacante Especial', 88, '88%', Colors.deepPurpleAccent),
      const RadialGaugeData('Muralla Defensiva', 74, '74%', Colors.teal),
      const RadialGaugeData('Soporte y Control', 65, '65%', Colors.amber),
    ];

    return SyncfusionChartCard(
      code: 'A11',
      title: 'Radial Bar Gauge de Roles de Equipo',
      description: 'Medidor circular que evalúa la cobertura y sinergia de cada rol táctico.',
      chart: SfCircularChart(
        legend: const Legend(isVisible: true, position: LegendPosition.bottom),
        series: <CircularSeries<RadialGaugeData, String>>[
          RadialBarSeries<RadialGaugeData, String>(
            dataSource: data,
            xValueMapper: (RadialGaugeData d, _) => d.category,
            yValueMapper: (RadialGaugeData d, _) => d.value,
            pointColorMapper: (RadialGaugeData d, _) => d.color,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
            trackColor: Colors.black12,
            maximumValue: 100,
            cornerStyle: CornerStyle.bothCurve,
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// A12: Dona con Explosión y Métrica Central
// ============================================================================
class SyncfusionAdvanced12 extends StatefulWidget {
  const SyncfusionAdvanced12({super.key});

  @override
  State<SyncfusionAdvanced12> createState() => _SyncfusionAdvanced12State();
}

class _SyncfusionAdvanced12State extends State<SyncfusionAdvanced12> {
  int _explodedIndex = 1;

  final List<CategoricalChartData> data = [
    const CategoricalChartData('Agua', 28, Color(0xFF4F86E8)),
    const CategoricalChartData('Fuego', 12, Color(0xFFEE7F30)),
    const CategoricalChartData('Planta', 14, Color(0xFF5FA845)),
    const CategoricalChartData('Eléctrico', 9, Color(0xFFE3BB1E)),
    const CategoricalChartData('Normal', 22, Color(0xFF9C9A6E)),
    const CategoricalChartData('Otros', 66, Color(0xFF8A8A8A)),
  ];

  @override
  Widget build(BuildContext context) {
    return SyncfusionChartCard(
      code: 'A12',
      title: 'Dona Interactiva con Conteo Central',
      description: 'Toca una rebanada para destacarla fuera de la circunferencia con animación.',
      chart: SfCircularChart(
        annotations: <CircularChartAnnotation>[
          CircularChartAnnotation(
            widget: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('151', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                Text('Kanto', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ],
        series: <CircularSeries<CategoricalChartData, String>>[
          DoughnutSeries<CategoricalChartData, String>(
            dataSource: data,
            xValueMapper: (CategoricalChartData d, _) => d.x,
            yValueMapper: (CategoricalChartData d, _) => d.y,
            pointColorMapper: (CategoricalChartData d, _) => d.color,
            innerRadius: '65%',
            explode: true,
            explodeIndex: _explodedIndex,
            explodeGesture: ActivationMode.singleTap,
            onPointTap: (details) {
              if (details.pointIndex != null) {
                setState(() => _explodedIndex = details.pointIndex!);
              }
            },
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelPosition: ChartDataLabelPosition.outside,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// A13: Barras Apiladas al 100% Proporcionales (StackedBar100)
// ============================================================================
class SyncfusionAdvanced13 extends StatelessWidget {
  const SyncfusionAdvanced13({super.key});

  @override
  Widget build(BuildContext context) {
    // [Poke, HP, Atk, Def, SpA, SpD, Spe]
    final List<MultiSeriesChartData> hpAndAtk = [
      const MultiSeriesChartData('Charizard', 78, 84, 78),
      const MultiSeriesChartData('Blastoise', 79, 83, 100),
      const MultiSeriesChartData('Venusaur', 80, 82, 83),
      const MultiSeriesChartData('Dragonite', 91, 134, 95),
      const MultiSeriesChartData('Mewtwo', 106, 110, 90),
    ];

    return SyncfusionChartCard(
      code: 'A13',
      title: 'Barras Apiladas 100%: Proporción de Stats',
      description: 'Muestra el porcentaje relativo que representa HP, Ataque y Defensa en cada Pokémon.',
      chart: SfCartesianChart(
        primaryXAxis: const CategoryAxis(),
        primaryYAxis: const NumericAxis(),
        legend: const Legend(isVisible: true, position: LegendPosition.top),
        series: <CartesianSeries<MultiSeriesChartData, String>>[
          StackedBar100Series<MultiSeriesChartData, String>(
            name: 'Puntos de Salud (HP)',
            dataSource: hpAndAtk,
            xValueMapper: (MultiSeriesChartData d, _) => d.x,
            yValueMapper: (MultiSeriesChartData d, _) => d.y1,
            color: Colors.green,
          ),
          StackedBar100Series<MultiSeriesChartData, String>(
            name: 'Ataque Físico',
            dataSource: hpAndAtk,
            xValueMapper: (MultiSeriesChartData d, _) => d.x,
            yValueMapper: (MultiSeriesChartData d, _) => d.y2,
            color: Colors.redAccent,
          ),
          StackedBar100Series<MultiSeriesChartData, String>(
            name: 'Defensa Física',
            dataSource: hpAndAtk,
            xValueMapper: (MultiSeriesChartData d, _) => d.x,
            yValueMapper: (MultiSeriesChartData d, _) => d.y3 ?? 0,
            color: Colors.blueAccent,
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// A14: Áreas Apiladas Acumulativas por Generación
// ============================================================================
class SyncfusionAdvanced14 extends StatelessWidget {
  const SyncfusionAdvanced14({super.key});

  @override
  Widget build(BuildContext context) {
    final List<MultiSeriesChartData> genData = [
      const MultiSeriesChartData('Gen 1', 146, 5),
      const MultiSeriesChartData('Gen 2', 94, 6),
      const MultiSeriesChartData('Gen 3', 125, 10),
      const MultiSeriesChartData('Gen 4', 93, 14),
      const MultiSeriesChartData('Gen 5', 143, 13),
      const MultiSeriesChartData('Gen 6', 66, 6),
      const MultiSeriesChartData('Gen 7', 77, 11),
      const MultiSeriesChartData('Gen 8', 85, 11),
      const MultiSeriesChartData('Gen 9', 112, 8),
    ];

    return SyncfusionChartCard(
      code: 'A14',
      title: 'Evolución de Especies: Normales vs Legendarios',
      description: 'Área apilada que muestra las adiciones acumuladas en cada una de las 9 generaciones.',
      chart: SfCartesianChart(
        primaryXAxis: const CategoryAxis(),
        primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Nuevos Pokémon')),
        legend: const Legend(isVisible: true, position: LegendPosition.top),
        series: <CartesianSeries<MultiSeriesChartData, String>>[
          StackedAreaSeries<MultiSeriesChartData, String>(
            name: 'Especies Regulares',
            dataSource: genData,
            xValueMapper: (MultiSeriesChartData d, _) => d.x,
            yValueMapper: (MultiSeriesChartData d, _) => d.y1,
            color: Colors.blueAccent.withValues(alpha: 0.7),
          ),
          StackedAreaSeries<MultiSeriesChartData, String>(
            name: 'Legendarios y Míticos',
            dataSource: genData,
            xValueMapper: (MultiSeriesChartData d, _) => d.x,
            yValueMapper: (MultiSeriesChartData d, _) => d.y2,
            color: Colors.amber.withValues(alpha: 0.8),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// A15: Columnas de Rango Flotante (RangeColumnSeries)
// ============================================================================
class SyncfusionAdvanced15 extends StatelessWidget {
  const SyncfusionAdvanced15({super.key});

  @override
  Widget build(BuildContext context) {
    // [Lv 50 min sin EVs vs Lv 100 max con 31 IVs y 252 EVs]
    final List<RangeChartData> data = [
      const RangeChartData(1, 140, 360), // HP
      const RangeChartData(2, 100, 330), // Ataque
      const RangeChartData(3, 90, 310),  // Defensa
      const RangeChartData(4, 120, 390), // At. Esp.
      const RangeChartData(5, 110, 340), // Def. Esp.
      const RangeChartData(6, 130, 400), // Velocidad
    ];

    const stats = ['HP', 'Atk', 'Def', 'SpA', 'SpD', 'Spe'];

    return SyncfusionChartCard(
      code: 'A15',
      title: 'Columnas de Rango: Mínimo vs Máximo Potencial',
      description: 'Intervalo alcanzable para Mewtwo entre Lv 50 base y Lv 100 competitivo.',
      chart: SfCartesianChart(
        primaryXAxis: NumericAxis(
          interval: 1,
          labelIntersectAction: AxisLabelIntersectAction.none,
          axisLabelFormatter: (details) {
            final idx = details.value.toInt() - 1;
            if (idx >= 0 && idx < stats.length) {
              return ChartAxisLabel(stats[idx], const TextStyle(fontSize: 12));
            }
            return ChartAxisLabel('', const TextStyle());
          },
        ),
        primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Puntos de Stat')),
        series: <CartesianSeries<RangeChartData, num>>[
          RangeColumnSeries<RangeChartData, num>(
            dataSource: data,
            xValueMapper: (RangeChartData d, _) => d.x,
            lowValueMapper: (RangeChartData d, _) => d.low,
            highValueMapper: (RangeChartData d, _) => d.high,
            color: Colors.deepPurpleAccent,
            borderRadius: BorderRadius.circular(4),
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// A16: Área de Rango con Intervalo de Confianza (RangeAreaSeries)
// ============================================================================
class SyncfusionAdvanced16 extends StatelessWidget {
  const SyncfusionAdvanced16({super.key});

  @override
  Widget build(BuildContext context) {
    // Daño calculado con factor de aleatoriedad 85% a 100%
    final List<RangeChartData> damageRange = [
      const RangeChartData(10, 42, 50),
      const RangeChartData(20, 85, 100),
      const RangeChartData(30, 128, 150),
      const RangeChartData(40, 170, 200),
      const RangeChartData(50, 212, 250),
      const RangeChartData(60, 255, 300),
    ];

    return SyncfusionChartCard(
      code: 'A16',
      title: 'Intervalo de Daño Esperado (RangeArea)',
      description: 'Banda de daño según factor de daño mínimo (85%) y daño crítico máximo (100%).',
      chart: SfCartesianChart(
        primaryXAxis: const NumericAxis(title: AxisTitle(text: 'Poder Base de Movimiento')),
        primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Daño Estimado')),
        series: <CartesianSeries<RangeChartData, num>>[
          RangeAreaSeries<RangeChartData, num>(
            dataSource: damageRange,
            xValueMapper: (RangeChartData d, _) => d.x,
            lowValueMapper: (RangeChartData d, _) => d.low,
            highValueMapper: (RangeChartData d, _) => d.high,
            color: Colors.redAccent.withValues(alpha: 0.4),
            borderColor: Colors.redAccent,
            borderWidth: 2,
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// A17: Gráfico Multieje (Dual Y-Axis)
// ============================================================================
class SyncfusionAdvanced17 extends StatelessWidget {
  const SyncfusionAdvanced17({super.key});

  @override
  Widget build(BuildContext context) {
    final List<DualAxisChartData> data = [
      const DualAxisChartData('Onix', 45, 210.0),
      const DualAxisChartData('Snorlax', 110, 460.0),
      const DualAxisChartData('Machamp', 130, 130.0),
      const DualAxisChartData('Dragonite', 134, 210.0),
      const DualAxisChartData('Gyarados', 125, 235.0),
      const DualAxisChartData('Alakazam', 50, 48.0),
    ];

    return SyncfusionChartCard(
      code: 'A17',
      title: 'Multieje: Ataque Físico vs Peso Corporal',
      description: 'Eje izquierdo: Ataque Físico (barras rojas). Eje derecho: Peso en kg (línea azul).',
      chart: SfCartesianChart(
        primaryXAxis: const CategoryAxis(),
        primaryYAxis: const NumericAxis(
          name: 'ataqueAxis',
          title: AxisTitle(text: 'Ataque Físico'),
        ),
        axes: const <ChartAxis>[
          NumericAxis(
            name: 'pesoAxis',
            opposedPosition: true,
            title: AxisTitle(text: 'Peso (kg)'),
          ),
        ],
        legend: const Legend(isVisible: true, position: LegendPosition.top),
        series: <CartesianSeries<DualAxisChartData, String>>[
          ColumnSeries<DualAxisChartData, String>(
            name: 'Ataque',
            yAxisName: 'ataqueAxis',
            dataSource: data,
            xValueMapper: (DualAxisChartData d, _) => d.x,
            yValueMapper: (DualAxisChartData d, _) => d.primary,
            color: Colors.deepOrangeAccent,
          ),
          LineSeries<DualAxisChartData, String>(
            name: 'Peso (kg)',
            yAxisName: 'pesoAxis',
            dataSource: data,
            xValueMapper: (DualAxisChartData d, _) => d.x,
            yValueMapper: (DualAxisChartData d, _) => d.secondary,
            color: Colors.blueAccent,
            width: 3,
            markerSettings: const MarkerSettings(isVisible: true),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// A18: Desviación respecto al Promedio Base (450 BST)
// ============================================================================
class SyncfusionAdvanced18 extends StatelessWidget {
  const SyncfusionAdvanced18({super.key});

  @override
  Widget build(BuildContext context) {
    // BST - 450
    final List<CategoricalChartData> deviations = [
      const CategoricalChartData('Pikachu', -130, Colors.red),
      const CategoricalChartData('Bulbasaur', -132, Colors.red),
      const CategoricalChartData('Gengar', 50, Colors.green),
      const CategoricalChartData('Charizard', 84, Colors.green),
      const CategoricalChartData('Blastoise', 80, Colors.green),
      const CategoricalChartData('Snorlax', 90, Colors.green),
      const CategoricalChartData('Dragonite', 150, Colors.green),
      const CategoricalChartData('Mewtwo', 230, Colors.teal),
    ];

    return SyncfusionChartCard(
      code: 'A18',
      title: 'Desviación Relativa a la Media (450 BST)',
      description: 'Barras divergentes: valores positivos superan el estándar, negativos indican déficit.',
      chart: SfCartesianChart(
        primaryXAxis: const CategoryAxis(),
        primaryYAxis: const NumericAxis(
          title: AxisTitle(text: 'Diferencia (+ / -) respecto a 450'),
        ),
        series: <CartesianSeries<CategoricalChartData, String>>[
          ColumnSeries<CategoricalChartData, String>(
            dataSource: deviations,
            xValueMapper: (CategoricalChartData d, _) => d.x,
            yValueMapper: (CategoricalChartData d, _) => d.y,
            pointColorMapper: (CategoricalChartData d, _) => d.color,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// A19: Diagrama de Pareto 80/20 de Tipos Elementales
// ============================================================================
class SyncfusionAdvanced19 extends StatelessWidget {
  const SyncfusionAdvanced19({super.key});

  @override
  Widget build(BuildContext context) {
    final List<DualAxisChartData> paretoData = [
      const DualAxisChartData('Agua', 32, 21.2),
      const DualAxisChartData('Normal', 22, 35.8),
      const DualAxisChartData('Planta', 14, 45.1),
      const DualAxisChartData('Fuego', 12, 53.0),
      const DualAxisChartData('Bicho', 12, 61.0),
      const DualAxisChartData('Veneno', 14, 70.2),
      const DualAxisChartData('Otros', 45, 100.0),
    ];

    return SyncfusionChartCard(
      code: 'A19',
      title: 'Curva de Pareto 80/20 de Población de Tipos',
      description: 'Columnas con cantidad de ejemplares y línea de porcentaje acumulado hasta el 100%.',
      chart: SfCartesianChart(
        primaryXAxis: const CategoryAxis(),
        primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Cantidad de Pokémon')),
        axes: const <ChartAxis>[
          NumericAxis(
            name: 'porcentajeAxis',
            opposedPosition: true,
            minimum: 0,
            maximum: 100,
            interval: 20,
            title: AxisTitle(text: '% Acumulado'),
          ),
        ],
        legend: const Legend(isVisible: true, position: LegendPosition.top),
        series: <CartesianSeries<DualAxisChartData, String>>[
          ColumnSeries<DualAxisChartData, String>(
            name: 'Frecuencia',
            dataSource: paretoData,
            xValueMapper: (DualAxisChartData d, _) => d.x,
            yValueMapper: (DualAxisChartData d, _) => d.primary,
            color: Colors.indigo,
          ),
          LineSeries<DualAxisChartData, String>(
            name: '% Acumulado',
            yAxisName: 'porcentajeAxis',
            dataSource: paretoData,
            xValueMapper: (DualAxisChartData d, _) => d.x,
            yValueMapper: (DualAxisChartData d, _) => d.secondary,
            color: Colors.amber,
            width: 3,
            markerSettings: const MarkerSettings(isVisible: true),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// A20: Box Plot con Media y Dispersión Extrema
// ============================================================================
class SyncfusionAdvanced20 extends StatelessWidget {
  const SyncfusionAdvanced20({super.key});

  @override
  Widget build(BuildContext context) {
    final List<BoxPlotChartData> data = [
      const BoxPlotChartData('Agua', [44, 55, 65, 78, 85, 95, 110, 130]),
      const BoxPlotChartData('Fuego', [39, 52, 60, 78, 84, 90, 110, 134]),
      const BoxPlotChartData('Planta', [45, 49, 62, 75, 82, 90, 100, 125]),
      const BoxPlotChartData('Dragón', [65, 80, 95, 100, 120, 134, 150, 180]),
      const BoxPlotChartData('Psíquico', [50, 65, 80, 95, 110, 135, 154, 180]),
    ];

    return SyncfusionChartCard(
      code: 'A20',
      title: 'BoxPlot Avanzado: Cuartiles y Medias por Tipo',
      description: 'Caja y bigotes con punto indicador de media aritmética (cruz) y outliers.',
      chart: SfCartesianChart(
        primaryXAxis: const CategoryAxis(),
        primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Puntos Base de Estadística')),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <CartesianSeries<BoxPlotChartData, String>>[
          BoxAndWhiskerSeries<BoxPlotChartData, String>(
            name: 'Dispersión',
            dataSource: data,
            xValueMapper: (BoxPlotChartData d, _) => d.x,
            yValueMapper: (BoxPlotChartData d, _) => d.values,
            color: Colors.teal.withValues(alpha: 0.7),
            showMean: true,
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// A21: Tendencia Lineal (Trendline) sobre la Pokédex
// ============================================================================
class SyncfusionAdvanced21 extends StatelessWidget {
  const SyncfusionAdvanced21({super.key});

  @override
  Widget build(BuildContext context) {
    final List<NumericChartPoint> data = [
      const NumericChartPoint(1, 318),  // Bulbasaur
      const NumericChartPoint(3, 525),  // Venusaur
      const NumericChartPoint(4, 309),  // Charmander
      const NumericChartPoint(6, 534),  // Charizard
      const NumericChartPoint(7, 314),  // Squirtle
      const NumericChartPoint(9, 530),  // Blastoise
      const NumericChartPoint(25, 320), // Pikachu
      const NumericChartPoint(94, 500), // Gengar
      const NumericChartPoint(130, 540),// Gyarados
      const NumericChartPoint(143, 540),// Snorlax
      const NumericChartPoint(149, 600),// Dragonite
      const NumericChartPoint(150, 680),// Mewtwo
    ];

    return SyncfusionChartCard(
      code: 'A21',
      title: 'Línea de Tendencia (Trendline) de Poder',
      description: 'Línea de regresión lineal proyectando el incremento de BST según el ID en la Pokédex.',
      chart: SfCartesianChart(
        primaryXAxis: const NumericAxis(title: AxisTitle(text: 'Número de Pokédex')),
        primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Total de Estadísticas (BST)')),
        series: <CartesianSeries<NumericChartPoint, num>>[
          LineSeries<NumericChartPoint, num>(
            name: 'Especímenes',
            dataSource: data,
            xValueMapper: (NumericChartPoint p, _) => p.x,
            yValueMapper: (NumericChartPoint p, _) => p.y,
            color: Colors.blueAccent,
            markerSettings: const MarkerSettings(isVisible: true),
            trendlines: <Trendline>[
              Trendline(
                type: TrendlineType.linear,
                color: Colors.amber,
                width: 3,
                dashArray: const <double>[6, 3],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// A22: Franjas y Bandas de Nivel Competitivo (PlotBands)
// ============================================================================
class SyncfusionAdvanced22 extends StatelessWidget {
  const SyncfusionAdvanced22({super.key});

  @override
  Widget build(BuildContext context) {
    final List<CategoricalChartData> data = [
      const CategoricalChartData('Caterpie', 195, Colors.green),
      const CategoricalChartData('Pikachu', 320, Colors.amber),
      const CategoricalChartData('Ivysaur', 405, Colors.teal),
      const CategoricalChartData('Charizard', 534, Colors.deepOrange),
      const CategoricalChartData('Dragonite', 600, Colors.indigo),
      const CategoricalChartData('Mewtwo', 680, Colors.purple),
    ];

    return SyncfusionChartCard(
      code: 'A22',
      title: 'Franjas de Nivel Competitivo (PlotBands)',
      description: 'Zonas sombreadas: Nivel Inicial (<350), Nivel Medio (350-500) y Tier Élite (>500).',
      chart: SfCartesianChart(
        primaryXAxis: const CategoryAxis(),
        primaryYAxis: NumericAxis(
          minimum: 150,
          maximum: 720,
          plotBands: <PlotBand>[
            PlotBand(
              start: 150,
              end: 350,
              color: Colors.red.withValues(alpha: 0.1),
              text: 'Tier Inicial',
              textStyle: const TextStyle(color: Colors.red, fontSize: 11),
            ),
            PlotBand(
              start: 350,
              end: 500,
              color: Colors.amber.withValues(alpha: 0.1),
              text: 'Tier Medio',
              textStyle: const TextStyle(color: Colors.amber, fontSize: 11),
            ),
            PlotBand(
              start: 500,
              end: 720,
              color: Colors.green.withValues(alpha: 0.1),
              text: 'Tier Élite / Competitivo',
              textStyle: const TextStyle(color: Colors.green, fontSize: 11),
            ),
          ],
        ),
        series: <CartesianSeries<CategoricalChartData, String>>[
          ColumnSeries<CategoricalChartData, String>(
            dataSource: data,
            xValueMapper: (CategoricalChartData d, _) => d.x,
            yValueMapper: (CategoricalChartData d, _) => d.y,
            pointColorMapper: (CategoricalChartData d, _) => d.color,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// A23: Marcadores Diamante y Anotaciones de Hito
// ============================================================================
class SyncfusionAdvanced23 extends StatelessWidget {
  const SyncfusionAdvanced23({super.key});

  @override
  Widget build(BuildContext context) {
    final List<NumericChartPoint> speedRun = [
      const NumericChartPoint(5, 55),
      const NumericChartPoint(16, 80),
      const NumericChartPoint(25, 90),
      const NumericChartPoint(36, 100),
      const NumericChartPoint(50, 115),
      const NumericChartPoint(70, 130),
      const NumericChartPoint(100, 150),
    ];

    return SyncfusionChartCard(
      code: 'A23',
      title: 'Marcadores Personalizados de Hito',
      description: 'Línea de velocidad con marcadores en forma de diamante e indicador visual de pico.',
      chart: SfCartesianChart(
        primaryXAxis: const NumericAxis(title: AxisTitle(text: 'Nivel del Pokémon')),
        primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Velocidad Efectiva')),
        series: <CartesianSeries<NumericChartPoint, num>>[
          LineSeries<NumericChartPoint, num>(
            dataSource: speedRun,
            xValueMapper: (NumericChartPoint p, _) => p.x,
            yValueMapper: (NumericChartPoint p, _) => p.y,
            color: Colors.deepPurple,
            width: 3,
            markerSettings: const MarkerSettings(
              isVisible: true,
              shape: DataMarkerType.diamond,
              width: 12,
              height: 12,
              color: Colors.amber,
              borderColor: Colors.deepPurple,
              borderWidth: 2,
            ),
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// A24: Gráfico Polar de Estadísticas de Starters
// ============================================================================
class SyncfusionAdvanced24 extends StatelessWidget {
  const SyncfusionAdvanced24({super.key});

  @override
  Widget build(BuildContext context) {
    final List<PolarStatData> venusaur = [
      const PolarStatData('HP', 80),
      const PolarStatData('Ataque', 82),
      const PolarStatData('Defensa', 83),
      const PolarStatData('At. Esp.', 100),
      const PolarStatData('Def. Esp.', 100),
      const PolarStatData('Velocidad', 80),
    ];

    final List<PolarStatData> charizard = [
      const PolarStatData('HP', 78),
      const PolarStatData('Ataque', 84),
      const PolarStatData('Defensa', 78),
      const PolarStatData('At. Esp.', 109),
      const PolarStatData('Def. Esp.', 85),
      const PolarStatData('Velocidad', 100),
    ];

    final List<PolarStatData> blastoise = [
      const PolarStatData('HP', 79),
      const PolarStatData('Ataque', 83),
      const PolarStatData('Defensa', 100),
      const PolarStatData('At. Esp.', 85),
      const PolarStatData('Def. Esp.', 105),
      const PolarStatData('Velocidad', 78),
    ];

    return SyncfusionChartCard(
      code: 'A24',
      title: 'Polígono de Estadísticas de Starters de Kanto',
      description: 'Comparativa de las 6 estadísticas base de Venusaur, Charizard y Blastoise.',
      chart: SfCartesianChart(
        primaryXAxis: const CategoryAxis(),
        primaryYAxis: const NumericAxis(minimum: 50, maximum: 120),
        legend: const Legend(isVisible: true, position: LegendPosition.bottom),
        series: <CartesianSeries<PolarStatData, String>>[
          SplineAreaSeries<PolarStatData, String>(
            name: 'Venusaur',
            dataSource: venusaur,
            xValueMapper: (PolarStatData d, _) => d.stat,
            yValueMapper: (PolarStatData d, _) => d.value,
            color: Colors.green.withValues(alpha: 0.35),
            borderColor: Colors.green,
            borderWidth: 2,
            markerSettings: const MarkerSettings(isVisible: true),
          ),
          SplineAreaSeries<PolarStatData, String>(
            name: 'Charizard',
            dataSource: charizard,
            xValueMapper: (PolarStatData d, _) => d.stat,
            yValueMapper: (PolarStatData d, _) => d.value,
            color: Colors.deepOrange.withValues(alpha: 0.35),
            borderColor: Colors.deepOrange,
            borderWidth: 2,
            markerSettings: const MarkerSettings(isVisible: true),
          ),
          SplineAreaSeries<PolarStatData, String>(
            name: 'Blastoise',
            dataSource: blastoise,
            xValueMapper: (PolarStatData d, _) => d.stat,
            yValueMapper: (PolarStatData d, _) => d.value,
            color: Colors.blue.withValues(alpha: 0.35),
            borderColor: Colors.blue,
            borderWidth: 2,
            markerSettings: const MarkerSettings(isVisible: true),
          ),
        ],
      ),
    );

  }
}

// ============================================================================
// A25: Vista Drill-Down Interactiva de Tipos a Especies
// ============================================================================
class SyncfusionAdvanced25 extends StatefulWidget {
  const SyncfusionAdvanced25({super.key});

  @override
  State<SyncfusionAdvanced25> createState() => _SyncfusionAdvanced25State();
}

class _SyncfusionAdvanced25State extends State<SyncfusionAdvanced25> {
  String _selectedType = 'Fuego';

  static final Map<String, List<CategoricalChartData>> _drillDownData = {
    'Fuego': [
      const CategoricalChartData('Charmander', 309, Colors.deepOrange),
      const CategoricalChartData('Charmeleon', 405, Colors.deepOrange),
      const CategoricalChartData('Charizard', 534, Colors.deepOrange),
      const CategoricalChartData('Vulpix', 299, Colors.orange),
      const CategoricalChartData('Ninetales', 505, Colors.orange),
      const CategoricalChartData('Arcanine', 555, Colors.redAccent),
    ],
    'Agua': [
      const CategoricalChartData('Squirtle', 314, Colors.blue),
      const CategoricalChartData('Wartortle', 405, Colors.blue),
      const CategoricalChartData('Blastoise', 530, Colors.blue),
      const CategoricalChartData('Psyduck', 320, Colors.lightBlue),
      const CategoricalChartData('Golduck', 500, Colors.lightBlue),
      const CategoricalChartData('Gyarados', 540, Colors.indigo),
    ],
    'Planta': [
      const CategoricalChartData('Bulbasaur', 318, Colors.green),
      const CategoricalChartData('Ivysaur', 405, Colors.green),
      const CategoricalChartData('Venusaur', 525, Colors.green),
      const CategoricalChartData('Oddish', 320, Colors.teal),
      const CategoricalChartData('Vileplume', 490, Colors.teal),
      const CategoricalChartData('Exeggutor', 530, Colors.lightGreen),
    ],
    'Eléctrico': [
      const CategoricalChartData('Pikachu', 320, Colors.amber),
      const CategoricalChartData('Raichu', 485, Colors.amber),
      const CategoricalChartData('Magnemite', 325, Colors.blueGrey),
      const CategoricalChartData('Magnezone', 535, Colors.blueGrey),
      const CategoricalChartData('Electabuzz', 490, Colors.yellow),
      const CategoricalChartData('Zapdos', 580, Colors.orangeAccent),
    ],
  };

  @override
  Widget build(BuildContext context) {
    final list = _drillDownData[_selectedType]!;

    return SyncfusionChartCard(
      code: 'A25',
      title: 'Drill-Down de Tipo a Especies Representativas',
      description: 'Toca un chip de tipo para profundizar en el ranking de BST de sus mejores exponentes.',
      controls: Wrap(
        spacing: 8,
        children: ['Fuego', 'Agua', 'Planta', 'Eléctrico'].map((t) {
          final isSelected = _selectedType == t;
          return ChoiceChip(
            label: Text(t),
            selected: isSelected,
            onSelected: (_) => setState(() => _selectedType = t),
          );
        }).toList(),
      ),
      chart: SfCartesianChart(
        primaryXAxis: const CategoryAxis(labelRotation: -25),
        primaryYAxis: const NumericAxis(minimum: 250, maximum: 600),
        series: <CartesianSeries<CategoricalChartData, String>>[
          ColumnSeries<CategoricalChartData, String>(
            key: ValueKey(_selectedType),
            dataSource: list,
            xValueMapper: (CategoricalChartData d, _) => d.x,
            yValueMapper: (CategoricalChartData d, _) => d.y,
            pointColorMapper: (CategoricalChartData d, _) => d.color,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          ),
        ],
      ),
    );
  }
}
