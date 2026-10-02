// ===========================================================================
// graphic_data.dart — DATOS Y ATAJOS COMPARTIDOS POR LOS 65 GRÁFICOS
// ===========================================================================
// Qué contiene:
//   1. Los datos: la clase Poke, la lista kPokes (23 Pokémon con stats
//      reales de PokeAPI), los nombres de las 6 estadísticas, los colores
//      por tipo y por estadística, y la distribución de tipos de Kanto.
//   2. Funciones que transforman esos datos a la forma que necesita cada
//      gráfico (topBy, statsLong, starterStages…).
//   3. Atajos para la librería graphic: crear variables (strVar, numVar,
//      pokeName, pokeNum…), colores (typeColorFixed) y ejes (rectAxes…).
// No dibuja ningún gráfico: N01–N40 y A01–A25 usan lo que hay aquí.
//
// Imports:
//   - flutter/material.dart → Color, Colors, TextStyle, Offset.
//   - graphic/graphic.dart  → Variable, Scale, ColorEncode, AxisGuide,
//     PaintStyle, LabelStyle, Label, Dim. Es la librería de gráficos que se
//     declaró en pubspec.yaml como `graphic: ^2.7.0`.
//
// Quién lo importa: cada archivo graphic_normal_*.dart y
// graphic_advanced_*.dart, y el barril charts_graphic.dart lo reexporta.
// ===========================================================================

import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

/// Fila genérica para los gráficos que trabajan con datos "largos"
/// (una fila por combinación Pokémon/estadística, por ejemplo).
// Datum = "un dato": un mapa clave → valor, p. ej.
//   {'name': 'Pikachu', 'stat': 'HP', 'value': 35}.
// Se llama Datum y no Row porque Row ya es un widget de Flutter
// (material.dart); con el mismo nombre habría un choque de nombres.
// `dynamic` porque los valores pueden ser String o num según la clave.
typedef Datum = Map<String, dynamic>;

/// Estadísticas base reales de PokeAPI (altura en metros, peso en kg).
// Clase inmutable (todos los campos son final): un Pokémon con sus datos.
// graphic acepta cualquier tipo de dato en `data:`; luego cada Variable
// dice cómo sacar un valor de un Poke (ver pokeName/pokeNum más abajo).
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

  // Constructor `const`: permite crear los Poke en tiempo de compilación,
  // y así la lista kPokes de abajo puede ser `const`.
  const Poke(this.id, this.name, this.type, this.hp, this.attack, this.defense,
      this.spAtk, this.spDef, this.speed, this.height, this.weight, this.baseExp);

  // Getter calculado: suma de las 6 estadísticas (no se guarda, se calcula).
  int get total => hp + attack + defense + spAtk + spDef + speed;

  // Las 6 estadísticas en el MISMO orden que kStatNames, para poder
  // recorrerlas con un índice i (stats[i] ↔ kStatNames[i]).
  List<int> get stats => [hp, attack, defense, spAtk, spDef, speed];
}

// Los datos son `const`: se crean una sola vez al compilar, no se pueden
// modificar por accidente y no cuestan nada al reconstruir widgets.
// Además, Chart compara `data` por instancia: una lista const es siempre la
// misma instancia, así que el gráfico no recalcula sin necesidad.
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

// Nombres visibles de las 6 estadísticas, en el mismo orden que Poke.stats.
const List<String> kStatNames = [
  'HP',
  'Ataque',
  'Defensa',
  'At. Esp.',
  'Def. Esp.',
  'Velocidad',
];

// Color oficial aproximado de cada tipo. Es un mapa tipo → color para
// poder buscar el color por nombre (lo usa typeColorFixed).
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

// Un color por estadística (6), en el orden de kStatNames. Se pasa como
// `values` de ColorEncode cuando el color depende de la variable 'stat'.
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
// Ya viene en forma de filas Datum (tipo, cantidad): sirve tal cual para
// las tortas y donas (N28–N31) y para A10.
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

// Busca un Pokémon por nombre (lanza error si el nombre no existe).
Poke pokeByName(String name) => kPokes.firstWhere((p) => p.name == name);

// Varios nombres → lista de Poke, en el mismo orden pedido.
List<Poke> pokesByName(List<String> names) => names.map(pokeByName).toList();

// Los n mejores según el criterio `value` (p. ej. (p) => p.attack).
// Copia la lista con [...kPokes] porque kPokes es const y no se puede
// ordenar en su lugar; luego ordena de mayor a menor y toma n.
List<Poke> topBy(int Function(Poke) value, int n) {
  final sorted = [...kPokes]..sort((a, b) => value(b).compareTo(value(a)));
  return sorted.take(n).toList();
}

/// Una fila por (Pokémon, estadística).
// "Formato largo": en vez de una fila por Pokémon con 6 columnas
// (formato ancho), se crea UNA FILA POR CADA PAR Pokémon × estadística:
//   {'name': 'Pikachu', 'stat': 'HP',     'value': 35}
//   {'name': 'Pikachu', 'stat': 'Ataque', 'value': 55} …
// graphic lo necesita así porque agrupa con la operación `/` del álgebra
// (p. ej. `/ Varset('stat')`): solo puede separar series, apilar o
// colorear por 'stat' si 'stat' es una columna con un valor por fila.
List<Datum> statsLong(List<Poke> pokes) => [
      for (final p in pokes)
        for (var i = 0; i < kStatNames.length; i++)
          {'name': p.name, 'stat': kStatNames[i], 'value': p.stats[i]},
    ];

/// Filas de las líneas evolutivas iniciales: etapa 1, 2 y 3.
// También formato largo: una fila por (línea evolutiva, etapa). El valor a
// graficar se recibe como función, así sirve para total, ataque, etc.
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
// Qué es una Variable en graphic: le dice al Chart cómo sacar UN valor de
// cada elemento de `data` (el `accessor`) y con qué escala convertirlo a
// posición, color, etc. (la `scale`).
//
// Por qué se escriben los genéricos <Datum, String> / <Datum, num> a mano:
// graphic solo acepta variables de tipo String, num o DateTime (lo verifica
// con un assert sobre el tipo del accessor) y, si no se da escala, elige la
// escala por defecto según ese tipo: OrdinalScale para String (categorías)
// y LinearScale para num (números). Como Datum tiene valores `dynamic`,
// sin los genéricos explícitos Dart inferiría `dynamic` y graphic no
// sabría qué tipo de variable es.

// Variable de texto (categoría) leída de la clave `key` de un Datum.
// `scale` es opcional: si no se pasa, graphic usa OrdinalScale.
Variable<Datum, String> strVar(String key, {Scale<String, num>? scale}) =>
    Variable<Datum, String>(accessor: (Datum r) => r[key] as String, scale: scale);

// Variable numérica leída de la clave `key`. Sin escala → LinearScale
// automática (mínimo y máximo de los datos con un margen del 10 %).
Variable<Datum, num> numVar(String key, {Scale<num, num>? scale}) =>
    Variable<Datum, num>(accessor: (Datum r) => r[key] as num, scale: scale);

// Lo mismo pero cuando `data` es una lista de Poke (no de Datum):
// el nombre del Pokémon como categoría.
Variable<Poke, String> pokeName() =>
    Variable<Poke, String>(accessor: (Poke p) => p.name);

// El tipo del Pokémon como categoría (se usa para el color).
Variable<Poke, String> pokeType() =>
    Variable<Poke, String>(accessor: (Poke p) => p.type);

// Cualquier campo numérico de un Poke; `f` dice cuál (p. ej. (p) => p.hp).
Variable<Poke, num> pokeNum(num Function(Poke) f, {Scale<num, num>? scale}) =>
    Variable<Poke, num>(accessor: f, scale: scale);

// Color por tipo usando una lista de colores: graphic asigna el 1.er color
// a la 1.ª categoría que APARECE en los datos, el 2.º a la 2.ª, etc. Por
// eso el color depende del orden de los datos. Hoy ningún gráfico lo usa;
// se prefiere typeColorFixed (abajo).
ColorEncode typeColor() => ColorEncode(
      variable: 'type',
      values: kTypeColors.values.toList(),
    );

/// Color fijo por tipo (no depende del orden en que aparezcan los tipos).
// `encoder` recibe cada tupla (la fila ya convertida por las variables) y
// devuelve el color buscándolo por nombre en kTypeColors. Necesita que el
// Chart tenga una variable llamada 'type'; si falta o el tipo no está en
// el mapa, la marca sale gris.
ColorEncode typeColorFixed() => ColorEncode(
      encoder: (tuple) => kTypeColors[tuple['type']] ?? Colors.grey,
    );

/// Ejes con etiquetas legibles en tema claro y oscuro.
// Un AxisGuide es una "guía": dibuja la línea del eje, sus etiquetas y,
// si se pide, la cuadrícula. Si un Chart no recibe `axes:`, no dibuja ejes.
// Eje X (dim: Dim.x = la dimensión de las categorías / dominio).
AxisGuide xAxis({double rotation = 0}) => AxisGuide(
      dim: Dim.x,
      // Línea del eje: gris con transparencia (0x55 ≈ 33 % de opacidad),
      // se ve bien sobre fondo blanco y sobre fondo oscuro.
      line: PaintStyle(strokeColor: const Color(0x55888888)),
      label: LabelStyle(
        // Gris medio: legible en ambos temas.
        textStyle: const TextStyle(fontSize: 10, color: Color(0xFF8A8A8A)),
        // Separa la etiqueta de la línea; si va girada, un poco más.
        offset: Offset(0, rotation == 0 ? 7.5 : 12),
        // Giro en radianes (-0.6 ≈ -34°): evita que los nombres largos se
        // monten unos sobre otros.
        rotation: rotation,
      ),
    );

// Eje Y (dim: Dim.y = la dimensión de los valores / medida).
AxisGuide yAxis() => AxisGuide(
      dim: Dim.y,
      label: LabelStyle(
        textStyle: const TextStyle(fontSize: 10, color: Color(0xFF8A8A8A)),
        // Etiquetas a la izquierda del eje.
        offset: const Offset(-7.5, 0),
      ),
      // Cuadrícula suave: gris al 20 % (0x33). El gris claro por defecto de
      // graphic (Defaults.strokeColor, 0xFFE8E8E8) brilla demasiado en
      // modo oscuro; este se nota poco en los dos temas.
      grid: PaintStyle(strokeColor: const Color(0x33888888)),
    );

// Los dos ejes juntos para coordenadas rectangulares (RectCoord).
// Es lo que reciben casi todos los gráficos en `axes:`.
List<AxisGuide> rectAxes({double xRotation = 0}) =>
    [xAxis(rotation: xRotation), yAxis()];

// Etiqueta pequeña para escribir valores sobre las marcas (LabelEncode).
// Label = texto + estilo; graphic la dibuja junto a cada elemento.
Label smallLabel(String text, {Color color = const Color(0xFF616161)}) =>
    Label(text, LabelStyle(textStyle: TextStyle(fontSize: 9, color: color)));
