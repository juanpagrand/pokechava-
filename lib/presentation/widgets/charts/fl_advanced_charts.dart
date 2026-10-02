import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'fl_chart_card.dart';

// ============================================================================
// A01: BarChart con Touch Interactivo y Tooltip Enriquecido
// ============================================================================
class FlChartAdvanced01 extends StatefulWidget {
  const FlChartAdvanced01({super.key});

  @override
  State<FlChartAdvanced01> createState() => _FlChartAdvanced01State();
}

class _FlChartAdvanced01State extends State<FlChartAdvanced01> {
  int? _touchedIndex;

  static const List<String> _names = ['Bulba', 'Chari', 'Squirt', 'Pika', 'Gengar', 'Dragon'];
  static const List<double> _bst = [318, 534, 314, 320, 500, 600];
  static const List<Color> _colors = [Colors.green, Colors.deepOrange, Colors.blue, Colors.amber, Colors.purple, Colors.indigo];

  @override
  Widget build(BuildContext context) {
    return FlChartCard(
      code: 'A01',
      title: 'Barras con Tooltip Interactivo',
      description: 'Toca cualquier columna para inspeccionar el Total de Stats con respuesta háptica y visual.',
      chart: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 650,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => Colors.blueGrey.shade900,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '${_names[group.x.toInt()]}\n',
                  const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                  children: [
                    TextSpan(
                      text: '${rod.toY.toInt()} BST',
                      style: const TextStyle(color: Colors.amberAccent, fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                  ],
                );
              },
            ),
            touchCallback: (event, response) {
              setState(() {
                if (event.isInterestedForInteractions && response != null && response.spot != null) {
                  _touchedIndex = response.spot!.touchedBarGroupIndex;
                } else {
                  _touchedIndex = null;
                }
              });
            },
          ),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  final idx = value.toInt();
                  if (idx >= 0 && idx < _names.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(_names[idx], style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(_names.length, (i) {
            final isTouched = i == _touchedIndex;
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: _bst[i],
                  color: isTouched ? Colors.pinkAccent : _colors[i],
                  width: isTouched ? 24 : 18,
                  borderRadius: BorderRadius.circular(6),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

// ============================================================================
// A02: Barras Apiladas (Stacked Rods) de Stats
// ============================================================================
class FlChartAdvanced02 extends StatelessWidget {
  const FlChartAdvanced02({super.key});

  static const List<String> _names = ['Charizard', 'Blastoise', 'Venusaur', 'Dragonite'];

  @override
  Widget build(BuildContext context) {
    // HP, Atk, Def apilados
    final List<List<double>> stats = [
      [78, 84, 78],    // Charizard
      [79, 83, 100],   // Blastoise
      [80, 82, 83],    // Venusaur
      [91, 134, 95],   // Dragonite
    ];

    return FlChartCard(
      code: 'A02',
      title: 'Barras Apiladas (HP + Ataque + Defensa)',
      description: 'Cada barra subdivide la contribución de HP (verde), Ataque (rojo) y Defensa (azul).',
      chart: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 360,
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  final idx = value.toInt();
                  if (idx >= 0 && idx < _names.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(_names[idx], style: const TextStyle(fontSize: 11)),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(_names.length, (i) {
            final hp = stats[i][0];
            final atk = stats[i][1];
            final def = stats[i][2];

            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: hp + atk + def,
                  width: 22,
                  borderRadius: BorderRadius.circular(6),
                  rodStackItems: [
                    BarChartRodStackItem(0, hp, Colors.green),
                    BarChartRodStackItem(hp, hp + atk, Colors.redAccent),
                    BarChartRodStackItem(hp + atk, hp + atk + def, Colors.blueAccent),
                  ],
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

// ============================================================================
// A03: Barras Animadas con Ordenamiento Dinámico
// ============================================================================
class FlChartAdvanced03 extends StatefulWidget {
  const FlChartAdvanced03({super.key});

  @override
  State<FlChartAdvanced03> createState() => _FlChartAdvanced03State();
}

class _FlChartAdvanced03State extends State<FlChartAdvanced03> {
  String _selectedMetric = 'Ataque';

  static final Map<String, List<Map<String, dynamic>>> _data = {
    'Ataque': [
      {'name': 'Dragonite', 'val': 134.0, 'color': Colors.redAccent},
      {'name': 'Machamp', 'val': 130.0, 'color': Colors.redAccent},
      {'name': 'Gyarados', 'val': 125.0, 'color': Colors.redAccent},
      {'name': 'Snorlax', 'val': 110.0, 'color': Colors.redAccent},
      {'name': 'Charizard', 'val': 84.0, 'color': Colors.redAccent},
    ],
    'Defensa': [
      {'name': 'Onix', 'val': 160.0, 'color': Colors.brown},
      {'name': 'Cloyster', 'val': 180.0, 'color': Colors.brown},
      {'name': 'Golem', 'val': 130.0, 'color': Colors.brown},
      {'name': 'Blastoise', 'val': 100.0, 'color': Colors.brown},
      {'name': 'Venusaur', 'val': 83.0, 'color': Colors.brown},
    ],
    'Velocidad': [
      {'name': 'Electrode', 'val': 150.0, 'color': Colors.amber},
      {'name': 'Aerodactyl', 'val': 130.0, 'color': Colors.amber},
      {'name': 'Jolteon', 'val': 130.0, 'color': Colors.amber},
      {'name': 'Alakazam', 'val': 120.0, 'color': Colors.amber},
      {'name': 'Gengar', 'val': 110.0, 'color': Colors.amber},
    ],
  };

  @override
  Widget build(BuildContext context) {
    final current = _data[_selectedMetric]!;

    return FlChartCard(
      code: 'A03',
      title: 'Barras Animadas con Ordenamiento Dinámico',
      description: 'Reorganiza el gráfico según Ataque, Defensa o Velocidad con animación fluida.',
      controls: Wrap(
        spacing: 8,
        children: ['Ataque', 'Defensa', 'Velocidad'].map((m) {
          final isSelected = _selectedMetric == m;
          return ChoiceChip(
            label: Text(m),
            selected: isSelected,
            onSelected: (_) => setState(() => _selectedMetric = m),
          );
        }).toList(),
      ),
      chart: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 200,
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  final idx = value.toInt();
                  if (idx >= 0 && idx < current.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(current[idx]['name'] as String, style: const TextStyle(fontSize: 10)),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(current.length, (i) {
            final val = current[i]['val'] as double;
            final color = current[i]['color'] as Color;
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: val,
                  color: color,
                  width: 20,
                  borderRadius: BorderRadius.circular(6),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

// ============================================================================
// A04: Barras con Gradientes Vivos y Borde Redondeado
// ============================================================================
class FlChartAdvanced04 extends StatelessWidget {
  const FlChartAdvanced04({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {'name': 'Charizard', 'stat': 109.0, 'c1': Colors.deepOrange, 'c2': Colors.orangeAccent},
      {'name': 'Blastoise', 'stat': 85.0, 'c1': Colors.blue.shade900, 'c2': Colors.cyanAccent},
      {'name': 'Venusaur', 'stat': 100.0, 'c1': Colors.green.shade800, 'c2': Colors.lightGreenAccent},
      {'name': 'Pikachu', 'stat': 50.0, 'c1': Colors.amber.shade900, 'c2': Colors.yellowAccent},
      {'name': 'Gengar', 'stat': 130.0, 'c1': Colors.purple.shade900, 'c2': Colors.purpleAccent},
    ];

    return FlChartCard(
      code: 'A04',
      title: 'Barras Estilizadas con Doble Gradiente',
      description: 'At. Especial con degradado vertical adaptativo y esquinas redondeadas.',
      chart: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 150,
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  final idx = value.toInt();
                  if (idx >= 0 && idx < items.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(items[idx]['name'] as String, style: const TextStyle(fontSize: 11)),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(items.length, (i) {
            final c1 = items[i]['c1'] as Color;
            final c2 = items[i]['c2'] as Color;
            final val = items[i]['stat'] as double;

            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: val,
                  width: 22,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                  gradient: LinearGradient(
                    colors: [c1, c2],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

// ============================================================================
// A05: Barras Agrupadas Comparativas (Base vs Evolución)
// ============================================================================
class FlChartAdvanced05 extends StatelessWidget {
  const FlChartAdvanced05({super.key});

  @override
  Widget build(BuildContext context) {
    // [Inicial, Final]
    final pairs = [
      {'name': 'Fuego', 'base': 309.0, 'evo': 534.0}, // Charmander vs Charizard
      {'name': 'Agua', 'base': 314.0, 'evo': 530.0},  // Squirtle vs Blastoise
      {'name': 'Planta', 'base': 318.0, 'evo': 525.0},// Bulbasaur vs Venusaur
      {'name': 'Eléctrico', 'base': 320.0, 'evo': 485.0}, // Pikachu vs Raichu
    ];

    return FlChartCard(
      code: 'A05',
      title: 'Barras Agrupadas: Base vs Evolución Final',
      description: 'Comparación directa de poder (BST) entre la forma inicial y su etapa final.',
      chart: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 600,
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  final idx = value.toInt();
                  if (idx >= 0 && idx < pairs.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(pairs[idx]['name'] as String, style: const TextStyle(fontSize: 11)),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(pairs.length, (i) {
            final base = pairs[i]['base'] as double;
            final evo = pairs[i]['evo'] as double;

            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(toY: base, color: Colors.blueGrey, width: 14, borderRadius: BorderRadius.circular(4)),
                BarChartRodData(toY: evo, color: Colors.teal, width: 14, borderRadius: BorderRadius.circular(4)),
              ],
            );
          }),
        ),
      ),
    );
  }
}

// ============================================================================
// A06: Curva Lineal Suave con Área Sombreada Gradual (Area Glow)
// ============================================================================
class FlChartAdvanced06 extends StatelessWidget {
  const FlChartAdvanced06({super.key});

  @override
  Widget build(BuildContext context) {
    return FlChartCard(
      code: 'A06',
      title: 'Curva Suave con Área Sombreada (Glow)',
      description: 'LineChartBarData con isCurved y belowBarData degradado mostrando crecimiento de nivel.',
      chart: LineChart(
        LineChartData(
          minX: 1,
          maxX: 100,
          minY: 0,
          maxY: 1200,
          gridData: const FlGridData(show: true, drawVerticalLine: false),
          titlesData: const FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              curveSmoothness: 0.35,
              color: Colors.deepPurpleAccent,
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    Colors.deepPurpleAccent.withValues(alpha: 0.45),
                    Colors.deepPurpleAccent.withValues(alpha: 0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              spots: const [
                FlSpot(1, 10),
                FlSpot(16, 120),
                FlSpot(36, 380),
                FlSpot(55, 620),
                FlSpot(75, 870),
                FlSpot(100, 1150),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// A07: Líneas Multi-Serie con Indicador Vertical Guía (Crosshair)
// ============================================================================
class FlChartAdvanced07 extends StatelessWidget {
  const FlChartAdvanced07({super.key});

  @override
  Widget build(BuildContext context) {
    return FlChartCard(
      code: 'A07',
      title: 'Líneas Multi-Serie con Indicador Guía',
      description: 'Toca la pantalla para activar el cursor vertical que cruza las 3 series de velocidad.',
      chart: LineChart(
        LineChartData(
          minX: 1,
          maxX: 50,
          minY: 40,
          maxY: 160,
          lineTouchData: LineTouchData(
            enabled: true,
            getTouchedSpotIndicator: (barData, spotIndexes) {
              return spotIndexes.map((spotIndex) {
                return TouchedSpotIndicatorData(
                  FlLine(color: Colors.white70, strokeWidth: 2, dashArray: [4, 4]),
                  FlDotData(
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 6,
                        color: barData.color ?? Colors.teal,
                        strokeWidth: 2,
                        strokeColor: Colors.white,
                      );
                    },
                  ),
                );
              }).toList();
            },
          ),
          titlesData: const FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              color: Colors.yellowAccent.shade700,
              barWidth: 3,
              spots: const [
                FlSpot(1, 60),
                FlSpot(10, 80),
                FlSpot(25, 110),
                FlSpot(35, 130),
                FlSpot(50, 150),
              ],
            ),
            LineChartBarData(
              isCurved: true,
              color: Colors.purpleAccent,
              barWidth: 3,
              spots: const [
                FlSpot(1, 55),
                FlSpot(10, 75),
                FlSpot(25, 95),
                FlSpot(35, 115),
                FlSpot(50, 130),
              ],
            ),
            LineChartBarData(
              isCurved: true,
              color: Colors.lightBlueAccent,
              barWidth: 3,
              spots: const [
                FlSpot(1, 45),
                FlSpot(10, 65),
                FlSpot(25, 80),
                FlSpot(35, 95),
                FlSpot(50, 110),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// A08: Stream de Batalla en Tiempo Real
// ============================================================================
class FlChartAdvanced08 extends StatefulWidget {
  const FlChartAdvanced08({super.key});

  @override
  State<FlChartAdvanced08> createState() => _FlChartAdvanced08State();
}

class _FlChartAdvanced08State extends State<FlChartAdvanced08> {
  Timer? _timer;
  double _time = 5.0;
  final List<FlSpot> _spots = [
    const FlSpot(0, 100),
    const FlSpot(1, 88),
    const FlSpot(2, 76),
    const FlSpot(3, 76),
    const FlSpot(4, 55),
    const FlSpot(5, 42),
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 1400), (_) {
      if (!mounted) return;
      setState(() {
        _time += 1.0;
        final randDmg = (math.Random().nextInt(15) + 3).toDouble();
        final last = _spots.last.y;
        final next = (last - randDmg).clamp(10.0, 100.0);
        _spots.add(FlSpot(_time, next));
        if (_spots.length > 10) {
          _spots.removeAt(0);
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
    return FlChartCard(
      code: 'A08',
      title: 'Dinámica en Tiempo Real de Combate',
      description: 'Gráfica viva que proyecta el daño recibido por turno en batalla Pokémon.',
      chart: LineChart(
        LineChartData(
          minY: 0,
          maxY: 110,
          titlesData: const FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              color: Colors.redAccent,
              barWidth: 3,
              belowBarData: BarAreaData(
                show: true,
                color: Colors.redAccent.withValues(alpha: 0.2),
              ),
              spots: _spots,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// A09: Área Entre Dos Líneas (BetweenBarsData)
// ============================================================================
class FlChartAdvanced09 extends StatelessWidget {
  const FlChartAdvanced09({super.key});

  @override
  Widget build(BuildContext context) {
    return FlChartCard(
      code: 'A09',
      title: 'Banda de Daño Entre Líneas (BetweenBarsData)',
      description: 'Intervalo sombreado entre el daño mínimo (línea azul) y el daño crítico (línea naranja).',
      chart: LineChart(
        LineChartData(
          minX: 1,
          maxX: 6,
          minY: 20,
          maxY: 160,
          betweenBarsData: [
            BetweenBarsData(
              fromIndex: 0,
              toIndex: 1,
              color: Colors.deepOrangeAccent.withValues(alpha: 0.3),
            ),
          ],
          titlesData: const FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            // Línea 0: Daño Mínimo
            LineChartBarData(
              isCurved: true,
              color: Colors.blueAccent,
              barWidth: 2,
              spots: const [
                FlSpot(1, 30),
                FlSpot(2, 45),
                FlSpot(3, 62),
                FlSpot(4, 78),
                FlSpot(5, 95),
                FlSpot(6, 110),
              ],
            ),
            // Línea 1: Daño Máximo
            LineChartBarData(
              isCurved: true,
              color: Colors.deepOrangeAccent,
              barWidth: 2,
              spots: const [
                FlSpot(1, 45),
                FlSpot(2, 65),
                FlSpot(3, 88),
                FlSpot(4, 112),
                FlSpot(5, 134),
                FlSpot(6, 155),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// A10: Línea con Marcadores Personalizados (FlDotCirclePainter)
// ============================================================================
class FlChartAdvanced10 extends StatelessWidget {
  const FlChartAdvanced10({super.key});

  @override
  Widget build(BuildContext context) {
    return FlChartCard(
      code: 'A10',
      title: 'Hitos Evolutivos con Marcadores Personalizados',
      description: 'Línea de progresión donde los puntos de evolución tienen anillos luminosos dobles.',
      chart: LineChart(
        LineChartData(
          minX: 1,
          maxX: 100,
          minY: 40,
          maxY: 120,
          titlesData: const FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              color: Colors.indigoAccent,
              barWidth: 3,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  final isEvo = spot.x == 16 || spot.x == 36;
                  return FlDotCirclePainter(
                    radius: isEvo ? 8 : 4,
                    color: isEvo ? Colors.amberAccent : Colors.indigoAccent,
                    strokeWidth: isEvo ? 3 : 1,
                    strokeColor: Colors.white,
                  );
                },
              ),
              spots: const [
                FlSpot(1, 45),
                FlSpot(16, 65),
                FlSpot(25, 75),
                FlSpot(36, 95),
                FlSpot(50, 105),
                FlSpot(70, 112),
                FlSpot(100, 118),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// A11: Línea con Anotaciones de Rango (RangeAnnotations)
// ============================================================================
class FlChartAdvanced11 extends StatelessWidget {
  const FlChartAdvanced11({super.key});

  @override
  Widget build(BuildContext context) {
    return FlChartCard(
      code: 'A11',
      title: 'Anotaciones de Rango y Tiers (RangeAnnotations)',
      description: 'Franjas de fondo que marcan el umbral Normal (<50), Competitivo (50-100) y Legendario (>100).',
      chart: LineChart(
        LineChartData(
          minX: 1,
          maxX: 6,
          minY: 20,
          maxY: 150,
          rangeAnnotations: RangeAnnotations(
            horizontalRangeAnnotations: [
              HorizontalRangeAnnotation(
                y1: 20,
                y2: 50,
                color: Colors.red.withValues(alpha: 0.12),
              ),
              HorizontalRangeAnnotation(
                y1: 50,
                y2: 100,
                color: Colors.amber.withValues(alpha: 0.12),
              ),
              HorizontalRangeAnnotation(
                y1: 100,
                y2: 150,
                color: Colors.green.withValues(alpha: 0.12),
              ),
            ],
          ),
          titlesData: const FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              color: Colors.deepPurple,
              barWidth: 3,
              spots: const [
                FlSpot(1, 35),
                FlSpot(2, 60),
                FlSpot(3, 85),
                FlSpot(4, 95),
                FlSpot(5, 120),
                FlSpot(6, 145),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// A12: PieChart con Expansión Dinámica de Sección al Tocar
// ============================================================================
class FlChartAdvanced12 extends StatefulWidget {
  const FlChartAdvanced12({super.key});

  @override
  State<FlChartAdvanced12> createState() => _FlChartAdvanced12State();
}

class _FlChartAdvanced12State extends State<FlChartAdvanced12> {
  int _touchedIndex = 0;

  final List<Map<String, dynamic>> _sections = [
    {'name': 'Agua', 'val': 28.0, 'color': Color(0xFF4F86E8)},
    {'name': 'Fuego', 'val': 12.0, 'color': Color(0xFFEE7F30)},
    {'name': 'Planta', 'val': 14.0, 'color': Color(0xFF5FA845)},
    {'name': 'Eléctrico', 'val': 9.0, 'color': Color(0xFFE3BB1E)},
    {'name': 'Otros', 'val': 88.0, 'color': Color(0xFF9E9E9E)},
  ];

  @override
  Widget build(BuildContext context) {
    return FlChartCard(
      code: 'A12',
      title: 'PieChart Interactivo con Expansión al Toque',
      description: 'Toca una rebanada para agrandar su radio y ver el detalle porcentual destacado.',
      chart: PieChart(
        PieChartData(
          pieTouchData: PieTouchData(
            touchCallback: (event, response) {
              setState(() {
                if (!event.isInterestedForInteractions || response == null || response.touchedSection == null) {
                  return;
                }
                _touchedIndex = response.touchedSection!.touchedSectionIndex;
              });
            },
          ),
          borderData: FlBorderData(show: false),
          sectionsSpace: 3,
          centerSpaceRadius: 40,
          sections: List.generate(_sections.length, (i) {
            final isTouched = i == _touchedIndex;
            final radius = isTouched ? 65.0 : 50.0;
            final item = _sections[i];

            return PieChartSectionData(
              color: item['color'] as Color,
              value: item['val'] as double,
              title: isTouched ? '${item['name']}\n${(item['val'] as double).toInt()}' : item['name'] as String,
              radius: radius,
              titleStyle: TextStyle(
                fontSize: isTouched ? 14 : 11,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            );
          }),
        ),
      ),
    );
  }
}

// ============================================================================
// A13: Gráfico de Dona con Badges de Tipos
// ============================================================================
class FlChartAdvanced13 extends StatelessWidget {
  const FlChartAdvanced13({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> types = [
      {'name': 'Agua', 'val': 30.0, 'color': Colors.blue, 'icon': Icons.water_drop},
      {'name': 'Fuego', 'val': 20.0, 'color': Colors.orange, 'icon': Icons.local_fire_department},
      {'name': 'Planta', 'val': 25.0, 'color': Colors.green, 'icon': Icons.eco},
      {'name': 'Eléctrico', 'val': 25.0, 'color': Colors.amber, 'icon': Icons.bolt},
    ];

    return FlChartCard(
      code: 'A13',
      title: 'Dona con Badges de Iconos Elementales',
      description: 'PieChartSectionData con badgeWidget que coloca iconos personalizados en cada sector.',
      chart: PieChart(
        PieChartData(
          centerSpaceRadius: 48,
          sectionsSpace: 4,
          sections: types.map((t) {
            return PieChartSectionData(
              color: t['color'] as Color,
              value: t['val'] as double,
              title: '${(t['val'] as double).toInt()}%',
              radius: 54,
              badgeWidget: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: Icon(t['icon'] as IconData, size: 16, color: t['color'] as Color),
              ),
              badgePositionPercentageOffset: 0.98,
              titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ============================================================================
// A14: Dona con Centro Hueco y Tarjeta de Métrica Central
// ============================================================================
class FlChartAdvanced14 extends StatelessWidget {
  const FlChartAdvanced14({super.key});

  @override
  Widget build(BuildContext context) {
    return FlChartCard(
      code: 'A14',
      title: 'Dona con Conteo Central de Pokédex',
      description: 'Dona con amplio centerSpaceRadius de 60 y recuento estadístico centralizado.',
      chart: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              centerSpaceRadius: 65,
              sectionsSpace: 3,
              sections: [
                PieChartSectionData(value: 28, color: Colors.blue, radius: 45, showTitle: false),
                PieChartSectionData(value: 22, color: Colors.brown, radius: 45, showTitle: false),
                PieChartSectionData(value: 14, color: Colors.purple, radius: 45, showTitle: false),
                PieChartSectionData(value: 14, color: Colors.green, radius: 45, showTitle: false),
                PieChartSectionData(value: 12, color: Colors.deepOrange, radius: 45, showTitle: false),
                PieChartSectionData(value: 61, color: Colors.blueGrey, radius: 45, showTitle: false),
              ],
            ),
          ),
          const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('151', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
              Text('Kanto Gen 1', style: TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// A15: Tacómetro / Semicírculo Gauge de Poder BST
// ============================================================================
class FlChartAdvanced15 extends StatelessWidget {
  const FlChartAdvanced15({super.key});

  @override
  Widget build(BuildContext context) {
    return FlChartCard(
      code: 'A15',
      title: 'Tacómetro / Gauge Semicircular de Poder',
      description: 'PieChart en semi-arco (startDegreeOffset: 180) que funciona como velocímetro de poder competitivo.',
      chart: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              startDegreeOffset: 180,
              centerSpaceRadius: 65,
              sectionsSpace: 3,
              sections: [
                PieChartSectionData(value: 85, color: Colors.indigoAccent, radius: 38, showTitle: false),
                PieChartSectionData(value: 15, color: Colors.black12, radius: 38, showTitle: false),
                // Parte inferior vacía para formar el semicírculo
                PieChartSectionData(value: 100, color: Colors.transparent, radius: 38, showTitle: false),
              ],
            ),
          ),
          const Positioned(
            bottom: 60,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('85%', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26, color: Colors.indigoAccent)),
                Text('Percentil Élite', style: TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// A16: Radar Multi-Dataset Comparativo
// ============================================================================
class FlChartAdvanced16 extends StatelessWidget {
  const FlChartAdvanced16({super.key});

  @override
  Widget build(BuildContext context) {
    const titles = ['HP', 'ATK', 'DEF', 'SPA', 'SPD', 'SPE'];

    return FlChartCard(
      code: 'A16',
      title: 'Radar Multi-Dataset: Mewtwo vs Dragonite',
      description: 'Superposición de hexágonos de stats base para contrastar perfiles de combate.',
      chart: RadarChart(
        RadarChartData(
          radarShape: RadarShape.polygon,
          tickCount: 4,
          ticksTextStyle: const TextStyle(fontSize: 9, color: Colors.grey),
          radarBorderData: const BorderSide(color: Colors.grey, width: 1),
          titlePositionPercentageOffset: 0.2,
          titleTextStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          getTitle: (index, _) => RadarChartTitle(text: titles[index % titles.length]),
          dataSets: [
            RadarDataSet(
              fillColor: Colors.purple.withValues(alpha: 0.35),
              borderColor: Colors.purple,
              borderWidth: 2,
              entryRadius: 3,
              // Mewtwo: [106, 110, 90, 154, 90, 130]
              dataEntries: const [
                RadarEntry(value: 106),
                RadarEntry(value: 110),
                RadarEntry(value: 90),
                RadarEntry(value: 154),
                RadarEntry(value: 90),
                RadarEntry(value: 130),
              ],
            ),
            RadarDataSet(
              fillColor: Colors.deepOrange.withValues(alpha: 0.35),
              borderColor: Colors.deepOrange,
              borderWidth: 2,
              entryRadius: 3,
              // Dragonite: [91, 134, 95, 100, 100, 80]
              dataEntries: const [
                RadarEntry(value: 91),
                RadarEntry(value: 134),
                RadarEntry(value: 95),
                RadarEntry(value: 100),
                RadarEntry(value: 100),
                RadarEntry(value: 80),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// A17: Radar Dinámico con Selector de Pokémon
// ============================================================================
class FlChartAdvanced17 extends StatefulWidget {
  const FlChartAdvanced17({super.key});

  @override
  State<FlChartAdvanced17> createState() => _FlChartAdvanced17State();
}

class _FlChartAdvanced17State extends State<FlChartAdvanced17> {
  String _selectedPoke = 'Charizard';

  static final Map<String, List<double>> _pokeStats = {
    'Charizard': [78, 84, 78, 109, 85, 100],
    'Blastoise': [79, 83, 100, 85, 105, 78],
    'Venusaur': [80, 82, 83, 100, 100, 80],
    'Pikachu': [35, 55, 40, 50, 50, 90],
  };

  static final Map<String, Color> _pokeColors = {
    'Charizard': Colors.deepOrange,
    'Blastoise': Colors.blue,
    'Venusaur': Colors.green,
    'Pikachu': Colors.amber,
  };

  @override
  Widget build(BuildContext context) {
    const titles = ['HP', 'ATK', 'DEF', 'SPA', 'SPD', 'SPE'];
    final stats = _pokeStats[_selectedPoke]!;
    final color = _pokeColors[_selectedPoke]!;

    return FlChartCard(
      code: 'A17',
      title: 'Radar Dinámico con Selector de Pokémon',
      description: 'Elige un Pokémon con los chips para actualizar su hexágono de combate.',
      controls: Wrap(
        spacing: 8,
        children: ['Charizard', 'Blastoise', 'Venusaur', 'Pikachu'].map((p) {
          final isSelected = _selectedPoke == p;
          return ChoiceChip(
            label: Text(p),
            selected: isSelected,
            onSelected: (_) => setState(() => _selectedPoke = p),
          );
        }).toList(),
      ),
      chart: RadarChart(
        RadarChartData(
          radarShape: RadarShape.polygon,
          tickCount: 4,
          titleTextStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          getTitle: (index, _) => RadarChartTitle(text: titles[index % titles.length]),
          dataSets: [
            RadarDataSet(
              fillColor: color.withValues(alpha: 0.4),
              borderColor: color,
              borderWidth: 3,
              entryRadius: 3,
              dataEntries: stats.map((s) => RadarEntry(value: s)).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// A18: Radar con Marcas de Referencia y Fronteras
// ============================================================================
class FlChartAdvanced18 extends StatelessWidget {
  const FlChartAdvanced18({super.key});

  @override
  Widget build(BuildContext context) {
    const titles = ['HP', 'ATK', 'DEF', 'SPA', 'SPD', 'SPE'];

    return FlChartCard(
      code: 'A18',
      title: 'Radar Avanzado con Ejes y Escala Concéntrica',
      description: 'Líneas guía concéntricas para evaluar roles competitivos (Snorlax Muralla Especial).',
      chart: RadarChart(
        RadarChartData(
          radarShape: RadarShape.circle,
          tickCount: 5,
          ticksTextStyle: const TextStyle(fontSize: 8, color: Colors.grey),
          radarBorderData: const BorderSide(color: Colors.blueGrey, width: 1.5),
          gridBorderData: const BorderSide(color: Colors.black12, width: 1),
          titleTextStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          getTitle: (index, _) => RadarChartTitle(text: titles[index % titles.length]),
          dataSets: [
            RadarDataSet(
              fillColor: Colors.teal.withValues(alpha: 0.35),
              borderColor: Colors.teal,
              borderWidth: 2.5,
              entryRadius: 4,
              // Snorlax: [160, 110, 65, 65, 110, 30]
              dataEntries: const [
                RadarEntry(value: 160),
                RadarEntry(value: 110),
                RadarEntry(value: 65),
                RadarEntry(value: 65),
                RadarEntry(value: 110),
                RadarEntry(value: 30),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// A19: ScatterChart Interactivo con Tooltip al Tocar
// ============================================================================
class FlChartAdvanced19 extends StatefulWidget {
  const FlChartAdvanced19({super.key});

  @override
  State<FlChartAdvanced19> createState() => _FlChartAdvanced19State();
}

class _FlChartAdvanced19State extends State<FlChartAdvanced19> {
  int? _touchedIndex;

  // [Altura(m), Peso(kg)]
  static const List<List<double>> _points = [
    [0.7, 6.9],   // Bulba
    [2.0, 100.0], // Venu
    [0.6, 8.5],   // Char
    [1.7, 90.5],  // Chari
    [0.5, 9.0],   // Squir
    [1.6, 85.5],  // Blast
    [0.4, 6.0],   // Pika
    [2.1, 460.0], // Snorlax
    [2.2, 210.0], // Dragonite
  ];

  @override
  Widget build(BuildContext context) {
    return FlChartCard(
      code: 'A19',
      title: 'Dispersión con Detección Táctil de Coordenadas',
      description: 'Toca un punto para resaltarlo y ver su relación Altura (m) vs Peso (kg).',
      chart: ScatterChart(
        ScatterChartData(
          minX: 0,
          maxX: 3.0,
          minY: 0,
          maxY: 500,
          scatterTouchData: ScatterTouchData(
            enabled: true,
            touchCallback: (event, response) {
              setState(() {
                if (event.isInterestedForInteractions && response != null && response.touchedSpot != null) {
                  _touchedIndex = response.touchedSpot!.spotIndex;
                } else {
                  _touchedIndex = null;
                }
              });
            },
          ),
          titlesData: const FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          scatterSpots: List.generate(_points.length, (i) {
            final isTouched = i == _touchedIndex;
            return ScatterSpot(
              _points[i][0],
              _points[i][1],
              dotPainter: FlDotCirclePainter(
                radius: isTouched ? 12 : 7,
                color: isTouched ? Colors.pinkAccent : Colors.indigoAccent,
                strokeColor: Colors.white,
                strokeWidth: 2,
              ),
            );
          }),
        ),
      ),
    );
  }
}

// ============================================================================
// A20: Scatter con Tamaños Dinámicos (Efecto Burbuja BST)
// ============================================================================
class FlChartAdvanced20 extends StatelessWidget {
  const FlChartAdvanced20({super.key});

  @override
  Widget build(BuildContext context) {
    // [Atk, Spe, BST]
    final specimens = [
      [49.0, 45.0, 318.0, Colors.green],     // Bulbasaur
      [52.0, 65.0, 309.0, Colors.deepOrange],// Charmander
      [48.0, 43.0, 314.0, Colors.blue],      // Squirtle
      [55.0, 90.0, 320.0, Colors.amber],     // Pikachu
      [65.0, 110.0, 500.0, Colors.purple],   // Gengar
      [134.0, 80.0, 600.0, Colors.indigo],   // Dragonite
      [110.0, 130.0, 680.0, Colors.purpleAccent], // Mewtwo
      [110.0, 30.0, 540.0, Colors.blueGrey], // Snorlax
    ];

    return FlChartCard(
      code: 'A20',
      title: 'Dispersión con Radios Proporcionales a BST',
      description: 'Eje X: Ataque, Eje Y: Velocidad. El tamaño del punto refleja el Total de Stats.',
      chart: ScatterChart(
        ScatterChartData(
          minX: 30,
          maxX: 150,
          minY: 20,
          maxY: 150,
          titlesData: const FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          scatterSpots: specimens.map((s) {
            final x = s[0] as double;
            final y = s[1] as double;
            final bst = s[2] as double;
            final color = s[3] as Color;
            // Radio proporcional
            final radius = (bst / 50.0).clamp(5.0, 15.0);

            return ScatterSpot(
              x,
              y,
              dotPainter: FlDotCirclePainter(
                radius: radius,
                color: color.withValues(alpha: 0.7),
                strokeColor: color,
                strokeWidth: 2,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ============================================================================
// A21: Scatter Multi-Cluster por Tipo Elemental
// ============================================================================
class FlChartAdvanced21 extends StatelessWidget {
  const FlChartAdvanced21({super.key});

  @override
  Widget build(BuildContext context) {
    // Puntos agrupados por tipo [HP, Atk]
    final waterCluster = [
      ScatterSpot(44, 48), ScatterSpot(59, 63), ScatterSpot(79, 83), ScatterSpot(95, 125), ScatterSpot(130, 85),
    ];
    final fireCluster = [
      ScatterSpot(39, 52), ScatterSpot(58, 64), ScatterSpot(78, 84), ScatterSpot(90, 110), ScatterSpot(65, 100),
    ];
    final grassCluster = [
      ScatterSpot(45, 49), ScatterSpot(60, 62), ScatterSpot(80, 82), ScatterSpot(75, 100), ScatterSpot(65, 90),
    ];


    return FlChartCard(
      code: 'A21',
      title: 'Dispersión Multi-Cluster por Tipo',
      description: 'Nubes de dispersión diferenciando Agua (azul), Fuego (naranja) y Planta (verde).',
      chart: ScatterChart(
        ScatterChartData(
          minX: 30,
          maxX: 140,
          minY: 40,
          maxY: 135,
          titlesData: const FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          scatterSpots: [
            ...waterCluster.map((s) => ScatterSpot(
                  s.x,
                  s.y,
                  dotPainter: FlDotCirclePainter(radius: 6, color: Colors.blueAccent),
                )),
            ...fireCluster.map((s) => ScatterSpot(
                  s.x,
                  s.y,
                  dotPainter: FlDotCirclePainter(radius: 6, color: Colors.deepOrangeAccent),
                )),
            ...grassCluster.map((s) => ScatterSpot(
                  s.x,
                  s.y,
                  dotPainter: FlDotCirclePainter(radius: 6, color: Colors.green),
                )),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// A22: Barras con Barra de Fondo (ShowBackground)
// ============================================================================
class FlChartAdvanced22 extends StatelessWidget {
  const FlChartAdvanced22({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = [
      {'name': 'HP', 'val': 106.0},
      {'name': 'ATK', 'val': 110.0},
      {'name': 'DEF', 'val': 90.0},
      {'name': 'SPA', 'val': 154.0},
      {'name': 'SPD', 'val': 90.0},
      {'name': 'SPE', 'val': 130.0},
    ];

    return FlChartCard(
      code: 'A22',
      title: 'Barras con Barra de Fondo (Capacidad Máxima 200)',
      description: 'Mewtwo con barra de fondo gris que ilustra la proximidad a la cota teórica máxima.',
      chart: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 200,
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  final idx = value.toInt();
                  if (idx >= 0 && idx < stats.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(stats[idx]['name'] as String, style: const TextStyle(fontSize: 11)),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(stats.length, (i) {
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: stats[i]['val'] as double,
                  color: Colors.purpleAccent,
                  width: 18,
                  borderRadius: BorderRadius.circular(6),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: 200,
                    color: Colors.black12,
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

// ============================================================================
// A23: Barras Bipolares (Desviación respecto a la Media de 80)
// ============================================================================
class FlChartAdvanced23 extends StatelessWidget {
  const FlChartAdvanced23({super.key});

  @override
  Widget build(BuildContext context) {
    // Desviaciones respecto a 80 de Charizard: HP: 78(-2), Atk: 84(+4), Def: 78(-2), SpA: 109(+29), SpD: 85(+5), Spe: 100(+20)
    final diffs = [
      {'stat': 'HP', 'diff': -2.0},
      {'stat': 'ATK', 'diff': 4.0},
      {'stat': 'DEF', 'diff': -2.0},
      {'stat': 'SPA', 'diff': 29.0},
      {'stat': 'SPD', 'diff': 5.0},
      {'stat': 'SPE', 'diff': 20.0},
    ];

    return FlChartCard(
      code: 'A23',
      title: 'Barras Divergentes (+/- respecto a Media 80)',
      description: 'Muestra si cada estadística de Charizard se sitúa por encima (verde) o debajo (rojo) del estándar.',
      chart: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          minY: -15,
          maxY: 35,
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  final idx = value.toInt();
                  if (idx >= 0 && idx < diffs.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(diffs[idx]['stat'] as String, style: const TextStyle(fontSize: 11)),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(diffs.length, (i) {
            final d = diffs[i]['diff'] as double;
            final isPositive = d >= 0;
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: d,
                  color: isPositive ? Colors.green : Colors.redAccent,
                  width: 18,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

// ============================================================================
// A24: Línea Escalonada (Step Line) de Movimientos por Nivel
// ============================================================================
class FlChartAdvanced24 extends StatelessWidget {
  const FlChartAdvanced24({super.key});

  @override
  Widget build(BuildContext context) {
    return FlChartCard(
      code: 'A24',
      title: 'Línea Escalonada (Step Line) de Aprendizaje',
      description: 'Saltos cuantitativos de movimientos aprendidos por subida de nivel con isStepLine.',
      chart: LineChart(
        LineChartData(
          minX: 1,
          maxX: 60,
          minY: 0,
          maxY: 16,
          titlesData: const FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              isCurved: false,
              color: Colors.deepOrange,
              barWidth: 3,
              spots: const [
                FlSpot(1, 2),
                FlSpot(7, 2),
                FlSpot(7, 4),
                FlSpot(13, 4),
                FlSpot(13, 6),
                FlSpot(20, 6),
                FlSpot(20, 8),
                FlSpot(32, 8),
                FlSpot(32, 11),
                FlSpot(46, 11),
                FlSpot(46, 14),
                FlSpot(60, 14),
                FlSpot(60, 16),
              ],
            ),
          ],
        ),
      ),
    );

  }
}

// ============================================================================
// A25: Dashboard Sincronizado (Barra + Radar)
// ============================================================================
class FlChartAdvanced25 extends StatefulWidget {
  const FlChartAdvanced25({super.key});

  @override
  State<FlChartAdvanced25> createState() => _FlChartAdvanced25State();
}

class _FlChartAdvanced25State extends State<FlChartAdvanced25> {
  int _selectedIndex = 0;

  static const List<String> _names = ['Charizard', 'Blastoise', 'Venusaur'];
  static const List<Color> _colors = [Colors.deepOrange, Colors.blue, Colors.green];
  static const List<List<double>> _stats = [
    [78, 84, 78, 109, 85, 100], // Charizard
    [79, 83, 100, 85, 105, 78], // Blastoise
    [80, 82, 83, 100, 100, 80], // Venusaur
  ];

  @override
  Widget build(BuildContext context) {
    const titles = ['HP', 'ATK', 'DEF', 'SPA', 'SPD', 'SPE'];
    final activeStats = _stats[_selectedIndex];
    final activeColor = _colors[_selectedIndex];
    final activeName = _names[_selectedIndex];

    return FlChartCard(
      code: 'A25',
      title: 'Panel Sincronizado: Selección y Radar de Detalle',
      description: 'Toca una barra arriba para inspeccionar instantáneamente el perfil radar del Pokémon.',
      height: 380,
      chart: Column(
        children: [
          // Barra de selección
          SizedBox(
            height: 140,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 600,
                barTouchData: BarTouchData(
                  touchCallback: (event, response) {
                    if (event.isInterestedForInteractions && response != null && response.spot != null) {
                      setState(() {
                        _selectedIndex = response.spot!.touchedBarGroupIndex;
                      });
                    }
                  },
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, _) {
                        final idx = value.toInt();
                        if (idx >= 0 && idx < _names.length) {
                          return Text(_names[idx], style: const TextStyle(fontSize: 10));
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(_names.length, (i) {
                  final isSelected = i == _selectedIndex;
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: [534.0, 530.0, 525.0][i],
                        color: isSelected ? _colors[i] : _colors[i].withValues(alpha: 0.35),
                        width: 22,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Perfil Hexagonal de $activeName',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: activeColor),
          ),
          // Radar inferior
          Expanded(
            child: RadarChart(
              RadarChartData(
                radarShape: RadarShape.polygon,
                tickCount: 3,
                titleTextStyle: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600),
                getTitle: (index, _) => RadarChartTitle(text: titles[index % titles.length]),
                dataSets: [
                  RadarDataSet(
                    fillColor: activeColor.withValues(alpha: 0.35),
                    borderColor: activeColor,
                    borderWidth: 2.5,
                    entryRadius: 3,
                    dataEntries: activeStats.map((s) => RadarEntry(value: s)).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
