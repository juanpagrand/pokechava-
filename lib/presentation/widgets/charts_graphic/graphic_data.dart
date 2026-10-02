import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

/// Fila genérica para los gráficos que trabajan con datos "largos"
/// (una fila por combinación Pokémon/estadística, por ejemplo).
typedef Datum = Map<String, dynamic>;

/// Estadísticas base reales de PokeAPI (altura en metros, peso en kg).
class Poke {
  final int id;
  final String name;
  final String type;
  final int hp;
  final int attack;
  final int defense;
  final int spAtk;
  final int spDef;
  final int speed;
  final double height;
  final double weight;
  final int baseExp;

  const Poke(this.id, this.name, this.type, this.hp, this.attack, this.defense,
      this.spAtk, this.spDef, this.speed, this.height, this.weight, this.baseExp);

  int get total => hp + attack + defense + spAtk + spDef + speed;

  List<int> get stats => [hp, attack, defense, spAtk, spDef, speed];
}

const List<Poke> kPokes = [
  Poke(1, 'Bulbasaur', 'Planta', 45, 49, 49, 65, 65, 45, 0.7, 6.9, 64),
  Poke(2, 'Ivysaur', 'Planta', 60, 62, 63, 80, 80, 60, 1.0, 13.0, 142),
  Poke(3, 'Venusaur', 'Planta', 80, 82, 83, 100, 100, 80, 2.0, 100.0, 263),
  Poke(4, 'Charmander', 'Fuego', 39, 52, 43, 60, 50, 65, 0.6, 8.5, 62),
  Poke(5, 'Charmeleon', 'Fuego', 58, 64, 58, 80, 65, 80, 1.1, 19.0, 142),
  Poke(6, 'Charizard', 'Fuego', 78, 84, 78, 109, 85, 100, 1.7, 90.5, 267),
  Poke(7, 'Squirtle', 'Agua', 44, 48, 65, 50, 64, 43, 0.5, 9.0, 63),
  Poke(8, 'Wartortle', 'Agua', 59, 63, 80, 65, 80, 58, 1.0, 22.5, 142),
  Poke(9, 'Blastoise', 'Agua', 79, 83, 100, 85, 105, 78, 1.6, 85.5, 265),
  Poke(25, 'Pikachu', 'Eléctrico', 35, 55, 40, 50, 50, 90, 0.4, 6.0, 112),
  Poke(26, 'Raichu', 'Eléctrico', 60, 90, 55, 90, 80, 110, 0.8, 30.0, 243),
  Poke(39, 'Jigglypuff', 'Normal', 115, 45, 20, 45, 25, 20, 0.5, 5.5, 95),
  Poke(65, 'Alakazam', 'Psíquico', 55, 50, 45, 135, 95, 120, 1.5, 48.0, 250),
  Poke(68, 'Machamp', 'Lucha', 90, 130, 80, 65, 85, 55, 1.6, 130.0, 253),
  Poke(74, 'Geodude', 'Roca', 40, 80, 100, 30, 30, 20, 0.4, 20.0, 60),
  Poke(94, 'Gengar', 'Fantasma', 60, 65, 60, 130, 75, 110, 1.5, 40.5, 250),
  Poke(95, 'Onix', 'Roca', 35, 45, 160, 30, 45, 70, 8.8, 210.0, 77),
  Poke(130, 'Gyarados', 'Agua', 95, 125, 79, 60, 100, 81, 6.5, 235.0, 189),
  Poke(131, 'Lapras', 'Agua', 130, 85, 80, 85, 95, 60, 2.5, 220.0, 187),
  Poke(133, 'Eevee', 'Normal', 55, 55, 50, 45, 65, 55, 0.3, 6.5, 65),
  Poke(143, 'Snorlax', 'Normal', 160, 110, 65, 65, 110, 30, 2.1, 460.0, 189),
  Poke(149, 'Dragonite', 'Dragón', 91, 134, 95, 100, 100, 80, 2.2, 210.0, 300),
  Poke(150, 'Mewtwo', 'Psíquico', 106, 110, 90, 154, 90, 130, 2.0, 122.0, 340),
];

const List<String> kStatNames = [
  'HP',
  'Ataque',
  'Defensa',
  'At. Esp.',
  'Def. Esp.',
  'Velocidad',
];

const Map<String, Color> kTypeColors = {
  'Planta': Color(0xFF5FA845),
  'Fuego': Color(0xFFEE7F30),
  'Agua': Color(0xFF4F86E8),
  'Eléctrico': Color(0xFFE3BB1E),
  'Normal': Color(0xFF9C9A6E),
  'Psíquico': Color(0xFFE85584),
  'Lucha': Color(0xFFB8322A),
  'Roca': Color(0xFFAF9A45),
  'Fantasma': Color(0xFF6E5896),
  'Dragón': Color(0xFF6C3CF0),
};

const List<Color> kStatColors = [
  Color(0xFFE53935),
  Color(0xFFFB8C00),
  Color(0xFFFDD835),
  Color(0xFF1E88E5),
  Color(0xFF43A047),
  Color(0xFFD81B60),
];

/// Distribución por tipo primario de los 151 Pokémon de Kanto
/// (la misma que muestra el ejemplo del informe).
const List<Datum> kGen1Types = [
  {'type': 'Agua', 'count': 28},
  {'type': 'Normal', 'count': 22},
  {'type': 'Veneno', 'count': 14},
  {'type': 'Planta', 'count': 12},
  {'type': 'Fuego', 'count': 12},
  {'type': 'Bicho', 'count': 12},
  {'type': 'Eléctrico', 'count': 9},
  {'type': 'Otros', 'count': 42},
];

/// Las tres líneas evolutivas iniciales, etapa por etapa.
const Map<String, List<String>> kStarterLines = {
  'Bulbasaur': ['Bulbasaur', 'Ivysaur', 'Venusaur'],
  'Charmander': ['Charmander', 'Charmeleon', 'Charizard'],
  'Squirtle': ['Squirtle', 'Wartortle', 'Blastoise'],
};

Poke pokeByName(String name) => kPokes.firstWhere((p) => p.name == name);

List<Poke> pokesByName(List<String> names) => names.map(pokeByName).toList();

List<Poke> topBy(int Function(Poke) value, int n) {
  final sorted = [...kPokes]..sort((a, b) => value(b).compareTo(value(a)));
  return sorted.take(n).toList();
}

/// Una fila por (Pokémon, estadística).
List<Datum> statsLong(List<Poke> pokes) => [
      for (final p in pokes)
        for (var i = 0; i < kStatNames.length; i++)
          {'name': p.name, 'stat': kStatNames[i], 'value': p.stats[i]},
    ];

/// Filas de las líneas evolutivas iniciales: etapa 1, 2 y 3.
List<Datum> starterStages(num Function(Poke) value) => [
      for (final line in kStarterLines.entries)
        for (var i = 0; i < line.value.length; i++)
          {
            'line': line.key,
            'stage': 'Etapa ${i + 1}',
            'value': value(pokeByName(line.value[i])),
          },
    ];

// ---------------------------------------------------------------------------
// Atajos para declarar variables sin repetir los genéricos en cada gráfico.
// ---------------------------------------------------------------------------

Variable<Datum, String> strVar(String key, {Scale<String, num>? scale}) =>
    Variable<Datum, String>(accessor: (Datum r) => r[key] as String, scale: scale);

Variable<Datum, num> numVar(String key, {Scale<num, num>? scale}) =>
    Variable<Datum, num>(accessor: (Datum r) => r[key] as num, scale: scale);

Variable<Poke, String> pokeName() =>
    Variable<Poke, String>(accessor: (Poke p) => p.name);

Variable<Poke, String> pokeType() =>
    Variable<Poke, String>(accessor: (Poke p) => p.type);

Variable<Poke, num> pokeNum(num Function(Poke) f, {Scale<num, num>? scale}) =>
    Variable<Poke, num>(accessor: f, scale: scale);

ColorEncode typeColor() => ColorEncode(
      variable: 'type',
      values: kTypeColors.values.toList(),
    );

/// Color fijo por tipo (no depende del orden en que aparezcan los tipos).
ColorEncode typeColorFixed() => ColorEncode(
      encoder: (tuple) => kTypeColors[tuple['type']] ?? Colors.grey,
    );

/// Ejes con etiquetas legibles en tema claro y oscuro.
AxisGuide xAxis({double rotation = 0}) => AxisGuide(
      dim: Dim.x,
      line: PaintStyle(strokeColor: const Color(0x55888888)),
      label: LabelStyle(
        textStyle: const TextStyle(fontSize: 10, color: Color(0xFF8A8A8A)),
        offset: Offset(0, rotation == 0 ? 7.5 : 12),
        rotation: rotation,
      ),
    );

AxisGuide yAxis() => AxisGuide(
      dim: Dim.y,
      label: LabelStyle(
        textStyle: const TextStyle(fontSize: 10, color: Color(0xFF8A8A8A)),
        offset: const Offset(-7.5, 0),
      ),
      grid: PaintStyle(strokeColor: const Color(0x33888888)),
    );

List<AxisGuide> rectAxes({double xRotation = 0}) =>
    [xAxis(rotation: xRotation), yAxis()];

Label smallLabel(String text, {Color color = const Color(0xFF616161)}) =>
    Label(text, LabelStyle(textStyle: TextStyle(fontSize: 9, color: color)));
