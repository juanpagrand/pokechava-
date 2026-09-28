import '../../core/constants/api_constants.dart';

class PokemonSummary {
  final int id;
  final String name;
  final List<String> types;
  final String imageUrl;
  final String animatedUrl;

  PokemonSummary({
    required this.id,
    required this.name,
    required this.types,
    required this.imageUrl,
    required this.animatedUrl,
  });

  factory PokemonSummary.fromJson(Map<String, dynamic> json) {
    final int id = json['id'] as int;
    final String name = json['name'] as String;

    List<String> typesList = [];
    if (json['types'] != null) {
      final typesJson = json['types'] as List;
      typesList = typesJson
          .map((t) => t['type']['name'].toString())
          .toList();
    }

    String img = ApiConstants.getOfficialArtworkUrl(id);
    String anim = ApiConstants.getAnimatedSpriteUrl(id);

    if (json['sprites'] != null) {
      final other = json['sprites']['other'];
      if (other != null && other['official-artwork'] != null && other['official-artwork']['front_default'] != null) {
        img = other['official-artwork']['front_default'];
      }
    }

    return PokemonSummary(
      id: id,
      name: name,
      types: typesList,
      imageUrl: img,
      animatedUrl: anim,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'types': types,
      'imageUrl': imageUrl,
      'animatedUrl': animatedUrl,
    };
  }
}
