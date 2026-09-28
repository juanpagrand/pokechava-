class StringUtils {
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  static String formatPokemonId(int id) {
    return '#${id.toString().padLeft(3, '0')}';
  }

  static String formatHeight(int heightInDecimeters) {
    final meters = heightInDecimeters / 10.0;
    return '${meters.toStringAsFixed(1)} m';
  }

  static String formatWeight(int weightInHectograms) {
    final kg = weightInHectograms / 10.0;
    return '${kg.toStringAsFixed(1)} kg';
  }

  static String translateStatName(String statName) {
    switch (statName.toLowerCase()) {
      case 'hp':
        return 'PS';
      case 'attack':
        return 'Ataque';
      case 'defense':
        return 'Defensa';
      case 'special-attack':
        return 'At. Esp.';
      case 'special-defense':
        return 'Def. Esp.';
      case 'speed':
        return 'Velocidad';
      default:
        return capitalize(statName);
    }
  }

  static String cleanFlavorText(String text) {
    return text.replaceAll('\n', ' ').replaceAll('\f', ' ').replaceAll('\r', ' ').trim();
  }
}
