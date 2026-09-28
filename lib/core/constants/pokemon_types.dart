import 'package:flutter/material.dart';

class PokemonTypeHelper {
  static const Map<String, Color> _typeColors = {
    'normal': Color(0xFFA8A878),
    'fire': Color(0xFFF08030),
    'water': Color(0xFF6890F0),
    'grass': Color(0xFF78C850),
    'electric': Color(0xFFF8D030),
    'ice': Color(0xFF98D8D8),
    'fighting': Color(0xFFC03028),
    'poison': Color(0xFFA040A0),
    'ground': Color(0xE0E0C068),
    'flying': Color(0xFFA890F0),
    'psychic': Color(0xFFF85888),
    'bug': Color(0xFFA8B820),
    'rock': Color(0xFFB8A038),
    'ghost': Color(0xFF705898),
    'dragon': Color(0xFF7038F8),
    'steel': Color(0xFFB8B8D0),
    'fairy': Color(0xFFEE99AC),
    'dark': Color(0xFF705848),
  };

  static const Map<String, String> _spanishNames = {
    'normal': 'Normal',
    'fire': 'Fuego',
    'water': 'Agua',
    'grass': 'Planta',
    'electric': 'Eléctrico',
    'ice': 'Hielo',
    'fighting': 'Lucha',
    'poison': 'Veneno',
    'ground': 'Tierra',
    'flying': 'Volador',
    'psychic': 'Psíquico',
    'bug': 'Bicho',
    'rock': 'Roca',
    'ghost': 'Fantasma',
    'dragon': 'Dragón',
    'steel': 'Acero',
    'fairy': 'Hada',
    'dark': 'Siniestro',
  };

  static Color getTypeColor(String typeName) {
    final key = typeName.toLowerCase().trim();
    return _typeColors[key] ?? const Color(0xFF68A090);
  }

  static Color getLightTypeColor(String typeName) {
    final color = getTypeColor(typeName);
    return Color.alphaBlend(color.withValues(alpha: 0.35), Colors.white);
  }

  static String getSpanishName(String typeName) {
    final key = typeName.toLowerCase().trim();
    return _spanishNames[key] ?? typeName;
  }

  static List<String> getAllTypes() {
    return _typeColors.keys.toList();
  }
}
