import '../../core/constants/api_constants.dart';

class StatItem {
  final String name;
  final int baseStat;

  StatItem({required this.name, required this.baseStat});

  factory StatItem.fromJson(Map<String, dynamic> json) {
    return StatItem(
      name: json['stat']['name'] as String,
      baseStat: json['base_stat'] as int,
    );
  }
}

class PokemonDetail {
  final int id;
  final String name;
  final int height;
  final int weight;
  final List<String> types;
  final List<StatItem> stats;
  final List<String> abilities;
  final String officialArtwork;
  final String animatedSprite;
  final String normalSprite;
  final String? cryAudioUrl;

  PokemonDetail({
    required this.id,
    required this.name,
    required this.height,
    required this.weight,
    required this.types,
    required this.stats,
    required this.abilities,
    required this.officialArtwork,
    required this.animatedSprite,
    required this.normalSprite,
    this.cryAudioUrl,
  });

  int get totalStats => stats.fold(0, (sum, item) => sum + item.baseStat);

  String get mainType => types.isNotEmpty ? types.first : 'normal';

  factory PokemonDetail.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as int;
    final name = json['name'] as String;
    final height = json['height'] as int;
    final weight = json['weight'] as int;

    final typesList = (json['types'] as List)
        .map((t) => t['type']['name'].toString())
        .toList();

    final statsList = (json['stats'] as List)
        .map((s) => StatItem.fromJson(s as Map<String, dynamic>))
        .toList();

    final abilitiesList = (json['abilities'] as List)
        .map((a) => a['ability']['name'].toString())
        .toList();

    String officialArt = ApiConstants.getOfficialArtworkUrl(id);
    String animSprite = ApiConstants.getAnimatedSpriteUrl(id);
    String normSprite = ApiConstants.getNormalSpriteUrl(id);

    if (json['sprites'] != null) {
      final sprites = json['sprites'];
      if (sprites['front_default'] != null) {
        normSprite = sprites['front_default'];
      }
      if (sprites['other'] != null) {
        final other = sprites['other'];
        if (other['official-artwork'] != null && other['official-artwork']['front_default'] != null) {
          officialArt = other['official-artwork']['front_default'];
        }
        if (other['showdown'] != null && other['showdown']['front_default'] != null) {
          animSprite = other['showdown']['front_default'];
        }
      }
    }

    String? cry;
    if (json['cries'] != null && json['cries']['latest'] != null) {
      cry = json['cries']['latest'];
    }

    return PokemonDetail(
      id: id,
      name: name,
      height: height,
      weight: weight,
      types: typesList,
      stats: statsList,
      abilities: abilitiesList,
      officialArtwork: officialArt,
      animatedSprite: animSprite,
      normalSprite: normSprite,
      cryAudioUrl: cry,
    );
  }
}
