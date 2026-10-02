// Datos de Pokémon y atajos que usan todos los gráficos.
// Prefijo Cc para no chocar con nombres de las otras librerías.

// alias charts: la librería choca con nombres de Flutter (Color, BarChart...)
import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:flutter/material.dart';

/// Un Pokémon con sus estadísticas base (altura en m, peso en kg).
class CcPoke {
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

  const CcPoke(this.id, this.name, this.type, this.hp, this.attack,
      this.defense, this.spAtk, this.spDef, this.speed, this.height,
      this.weight, this.baseExp);

  int get total => hp + attack + defense + spAtk + spDef + speed;

  List<int> get stats => [hp, attack, defense, spAtk, spDef, speed];
}

const List<CcPoke> kCcPokes = [
  CcPoke(1, 'Bulbasaur', 'Planta', 45, 49, 49, 65, 65, 45, 0.7, 6.9, 64),
  CcPoke(2, 'Ivysaur', 'Planta', 60, 62, 63, 80, 80, 60, 1.0, 13.0, 142),
  CcPoke(3, 'Venusaur', 'Planta', 80, 82, 83, 100, 100, 80, 2.0, 100.0, 263),
  CcPoke(4, 'Charmander', 'Fuego', 39, 52, 43, 60, 50, 65, 0.6, 8.5, 62),
  CcPoke(5, 'Charmeleon', 'Fuego', 58, 64, 58, 80, 65, 80, 1.1, 19.0, 142),
  CcPoke(6, 'Charizard', 'Fuego', 78, 84, 78, 109, 85, 100, 1.7, 90.5, 267),
  CcPoke(7, 'Squirtle', 'Agua', 44, 48, 65, 50, 64, 43, 0.5, 9.0, 63),
  CcPoke(8, 'Wartortle', 'Agua', 59, 63, 80, 65, 80, 58, 1.0, 22.5, 142),
  CcPoke(9, 'Blastoise', 'Agua', 79, 83, 100, 85, 105, 78, 1.6, 85.5, 265),
  CcPoke(25, 'Pikachu', 'Eléctrico', 35, 55, 40, 50, 50, 90, 0.4, 6.0, 112),
  CcPoke(26, 'Raichu', 'Eléctrico', 60, 90, 55, 90, 80, 110, 0.8, 30.0, 243),
  CcPoke(39, 'Jigglypuff', 'Normal', 115, 45, 20, 45, 25, 20, 0.5, 5.5, 95),
  CcPoke(65, 'Alakazam', 'Psíquico', 55, 50, 45, 135, 95, 120, 1.5, 48.0, 250),
  CcPoke(68, 'Machamp', 'Lucha', 90, 130, 80, 65, 85, 55, 1.6, 130.0, 253),
  CcPoke(74, 'Geodude', 'Roca', 40, 80, 100, 30, 30, 20, 0.4, 20.0, 60),
  CcPoke(94, 'Gengar', 'Fantasma', 60, 65, 60, 130, 75, 110, 1.5, 40.5, 250),
  CcPoke(95, 'Onix', 'Roca', 35, 45, 160, 30, 45, 70, 8.8, 210.0, 77),
  CcPoke(130, 'Gyarados', 'Agua', 95, 125, 79, 60, 100, 81, 6.5, 235.0, 189),
  CcPoke(131, 'Lapras', 'Agua', 130, 85, 80, 85, 95, 60, 2.5, 220.0, 187),
  CcPoke(133, 'Eevee', 'Normal', 55, 55, 50, 45, 65, 55, 0.3, 6.5, 65),
  CcPoke(143, 'Snorlax', 'Normal', 160, 110, 65, 65, 110, 30, 2.1, 460.0, 189),
  CcPoke(149, 'Dragonite', 'Dragón', 91, 134, 95, 100, 100, 80, 2.2, 210.0, 300),
  CcPoke(150, 'Mewtwo', 'Psíquico', 106, 110, 90, 154, 90, 130, 2.0, 122.0, 340),
];

const List<String> kCcStatNames = [
  'HP',
  'Ataque',
  'Defensa',
  'At. Esp.',
  'Def. Esp.',
  'Velocidad',
];

/// Generación: Pokémon nuevos y fecha del primer juego.
class CcGeneration {
  final int number;
  final String games;
  final DateTime release;
  final int newPokemon;

  const CcGeneration(this.number, this.games, this.release, this.newPokemon);
}

// no es const por los DateTime
final List<CcGeneration> kCcGenerations = [
  CcGeneration(1, 'Rojo/Verde', DateTime(1996, 2, 27), 151),
  CcGeneration(2, 'Oro/Plata', DateTime(1999, 11, 21), 100),
  CcGeneration(3, 'Rubí/Zafiro', DateTime(2002, 11, 21), 135),
  CcGeneration(4, 'Diamante/Perla', DateTime(2006, 9, 28), 107),
  CcGeneration(5, 'Negro/Blanco', DateTime(2010, 9, 18), 156),
  CcGeneration(6, 'X/Y', DateTime(2013, 10, 12), 72),
  CcGeneration(7, 'Sol/Luna', DateTime(2016, 11, 18), 88),
  CcGeneration(8, 'Espada/Escudo', DateTime(2019, 11, 15), 96),
  CcGeneration(9, 'Escarlata/Púrpura', DateTime(2022, 11, 18), 120),
];

/// Pokédex acumulada por generación (151 … 1025).
List<int> get kCcCumulative {
  var sum = 0;
  return [for (final g in kCcGenerations) sum += g.newPokemon];
}

/// Una categoría y su cantidad (para tortas).
class CcSlice {
  final String label;
  final int value;
  final Color color;

  const CcSlice(this.label, this.value, this.color);
}

const List<CcSlice> kCcKantoTypes = [
  CcSlice('Agua', 28, Color(0xFF4F86E8)),
  CcSlice('Normal', 22, Color(0xFF9C9A6E)),
  CcSlice('Veneno', 14, Color(0xFF9B59B6)),
  CcSlice('Planta', 12, Color(0xFF5FA845)),
  CcSlice('Fuego', 12, Color(0xFFEE7F30)),
  CcSlice('Bicho', 12, Color(0xFFA8B820)),
  CcSlice('Eléctrico', 9, Color(0xFFE3BB1E)),
  CcSlice('Otros', 42, Color(0xFFBDBDBD)),
];

const Map<String, Color> kCcTypeColors = {
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

const List<Color> kCcStatColors = [
  Color(0xFFE53935),
  Color(0xFFFB8C00),
  Color(0xFFFDD835),
  Color(0xFF1E88E5),
  Color(0xFF43A047),
  Color(0xFFD81B60),
];

CcPoke ccByName(String name) => kCcPokes.firstWhere((p) => p.name == name);

List<CcPoke> ccByNames(List<String> names) => names.map(ccByName).toList();

List<CcPoke> ccTopBy(num Function(CcPoke) value, int n) {
  final sorted = [...kCcPokes]..sort((a, b) => value(b).compareTo(value(a)));
  return sorted.take(n).toList();
}

// la librería usa su propio Color, hay que convertir el de Flutter
charts.Color ccColor(Color c) => charts.ColorUtil.fromDartColor(c);

charts.Color ccTypeColor(String type) =>
    ccColor(kCcTypeColors[type] ?? Colors.grey);

// gris para que los ejes se vean también en modo oscuro
final charts.Color ccAxisGray = ccColor(const Color(0xFF8A8A8A));
final charts.Color ccGridGray = ccColor(const Color(0x33888888));

charts.TextStyleSpec ccLabelStyle({int fontSize = 10}) =>
    charts.TextStyleSpec(fontSize: fontSize, color: ccAxisGray);

/// Eje de categorías.
charts.OrdinalAxisSpec ccOrdinalAxis({int labelRotation = 0}) =>
    charts.OrdinalAxisSpec(
      renderSpec: charts.SmallTickRendererSpec(
        labelStyle: ccLabelStyle(),
        labelRotation: labelRotation,
        lineStyle: charts.LineStyleSpec(color: ccAxisGray),
      ),
    );

/// Eje numérico con cuadrícula suave.
charts.NumericAxisSpec ccNumericAxis({
  int? desiredTickCount,
  charts.NumericExtents? viewport,
}) =>
    charts.NumericAxisSpec(
      viewport: viewport,
      tickProviderSpec: desiredTickCount == null
          ? null
          : charts.BasicNumericTickProviderSpec(
              desiredTickCount: desiredTickCount),
      renderSpec: charts.GridlineRendererSpec(
        labelStyle: ccLabelStyle(),
        lineStyle: charts.LineStyleSpec(color: ccGridGray),
      ),
    );

/// Eje de fechas.
charts.DateTimeAxisSpec ccDateAxis() => charts.DateTimeAxisSpec(
      renderSpec: charts.SmallTickRendererSpec(
        labelStyle: ccLabelStyle(),
        lineStyle: charts.LineStyleSpec(color: ccAxisGray),
      ),
    );

/// Texto de las leyendas.
charts.TextStyleSpec ccLegendStyle() =>
    charts.TextStyleSpec(fontSize: 11, color: ccAxisGray);

// includePoints dibuja mal los puntos en esta versión, por eso va como serie aparte
const String ccPointsRendererId = 'puntos';

/// Copia de la serie para dibujarla como puntos.
charts.Series<T, D> ccPointsOf<T, D>(charts.Series<T, D> s) {
  return charts.Series<T, D>(
    id: '${s.id} · puntos',
    data: s.data,
    // aquí las funciones solo reciben el índice
    domainFn: (_, int? i) => s.domainFn(i),
    measureFn: (_, int? i) => s.measureFn(i),
    colorFn: s.colorFn == null ? null : (_, int? i) => s.colorFn!(i),
  )..setAttribute(charts.rendererIdKey, ccPointsRendererId);
}

/// Renderer para las series de ccPointsOf.
charts.PointRendererConfig<D> ccPointRenderer<D>() =>
    charts.PointRendererConfig<D>(customRendererId: ccPointsRendererId);
