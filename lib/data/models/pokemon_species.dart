import '../../core/utils/string_utils.dart';

class PokemonSpecies {
  final int id;
  final String description;
  final String genus;
  final bool isLegendary;
  final bool isMythical;
  final String habitat;

  PokemonSpecies({
    required this.id,
    required this.description,
    required this.genus,
    required this.isLegendary,
    required this.isMythical,
    required this.habitat,
  });

  factory PokemonSpecies.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as int;

    // Preference: Spanish entry, fallback: English entry
    String flavorText = '';
    if (json['flavor_text_entries'] != null) {
      final entries = json['flavor_text_entries'] as List;
      final spanishEntry = entries.firstWhere(
        (e) => e['language']['name'] == 'es',
        orElse: () => entries.firstWhere(
          (e) => e['language']['name'] == 'en',
          orElse: () => null,
        ),
      );
      if (spanishEntry != null) {
        flavorText = StringUtils.cleanFlavorText(spanishEntry['flavor_text']);
      }
    }

    String genusText = '';
    if (json['genera'] != null) {
      final generaList = json['genera'] as List;
      final spanishGenus = generaList.firstWhere(
        (g) => g['language']['name'] == 'es',
        orElse: () => generaList.firstWhere(
          (g) => g['language']['name'] == 'en',
          orElse: () => null,
        ),
      );
      if (spanishGenus != null) {
        genusText = spanishGenus['genus'];
      }
    }

    String habitatName = 'Desconocido';
    if (json['habitat'] != null && json['habitat']['name'] != null) {
      habitatName = StringUtils.capitalize(json['habitat']['name']);
    }

    return PokemonSpecies(
      id: id,
      description: flavorText.isNotEmpty ? flavorText : 'Sin descripción disponible.',
      genus: genusText.isNotEmpty ? genusText : 'Pokémon',
      isLegendary: json['is_legendary'] == true,
      isMythical: json['is_mythical'] == true,
      habitat: habitatName,
    );
  }
}
