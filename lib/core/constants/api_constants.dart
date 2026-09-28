class ApiConstants {
  static const String baseUrl = 'https://pokeapi.co/api/v2';
  static const String pokemonEndpoint = '/pokemon';
  static const String pokemonSpeciesEndpoint = '/pokemon-species';
  static const String typeEndpoint = '/type';

  static const int defaultLimit = 24;

  static String getOfficialArtworkUrl(int id) {
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
  }

  static String getAnimatedSpriteUrl(int id) {
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/showdown/$id.png';
  }

  static String getNormalSpriteUrl(int id) {
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';
  }
}
