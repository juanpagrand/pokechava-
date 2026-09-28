import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../models/pokemon_detail.dart';
import '../models/pokemon_species.dart';
import '../models/pokemon_summary.dart';

class PokeApiService {
  final http.Client client;

  PokeApiService({http.Client? client}) : client = client ?? http.Client();

  /// Fetch list of Pokémon with pagination
  Future<List<PokemonSummary>> fetchPokemonList({
    int limit = ApiConstants.defaultLimit,
    int offset = 0,
  }) async {
    final url = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.pokemonEndpoint}?limit=$limit&offset=$offset');

    final response = await client.get(url);

    if (response.statusCode != 200) {
      throw Exception('Error al cargar la lista de Pokémon: ${response.statusCode}');
    }

    final data = json.decode(response.body);
    final results = data['results'] as List;

    // Fetch individual Pokémon details in parallel to get their types and sprites
    final futures = results.map((item) async {
      final nameOrUrl = item['name'] as String;
      return fetchPokemonDetail(nameOrUrl).then(
        (detail) => PokemonSummary(
          id: detail.id,
          name: detail.name,
          types: detail.types,
          imageUrl: detail.officialArtwork,
          animatedUrl: detail.animatedSprite,
        ),
      );
    }).toList();

    return await Future.wait(futures);
  }

  /// Fetch single Pokémon detail by ID or name
  Future<PokemonDetail> fetchPokemonDetail(dynamic idOrName) async {
    final url = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.pokemonEndpoint}/$idOrName');

    final response = await client.get(url);

    if (response.statusCode != 200) {
      throw Exception('Pokémon "$idOrName" no encontrado');
    }

    final data = json.decode(response.body);
    return PokemonDetail.fromJson(data);
  }

  /// Fetch Pokémon Species info by ID or name
  Future<PokemonSpecies> fetchPokemonSpecies(dynamic idOrName) async {
    final url = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.pokemonSpeciesEndpoint}/$idOrName');

    final response = await client.get(url);

    if (response.statusCode != 200) {
      return PokemonSpecies(
        id: idOrName is int ? idOrName : 0,
        description: 'Información de especie no disponible.',
        genus: 'Pokémon',
        isLegendary: false,
        isMythical: false,
        habitat: 'Desconocido',
      );
    }

    final data = json.decode(response.body);
    return PokemonSpecies.fromJson(data);
  }

  /// Fetch Pokémon list by Type (e.g. 'fire', 'water')
  Future<List<PokemonSummary>> fetchPokemonByType(String typeName) async {
    final url = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.typeEndpoint}/${typeName.toLowerCase()}');

    final response = await client.get(url);

    if (response.statusCode != 200) {
      throw Exception('Error al obtener Pokémon por tipo: $typeName');
    }

    final data = json.decode(response.body);
    final pokemonEntries = data['pokemon'] as List;

    // Limit to top 30 for performance when filtering by type
    final entriesToFetch = pokemonEntries.take(30).toList();

    final futures = entriesToFetch.map((entry) async {
      final pName = entry['pokemon']['name'] as String;
      return fetchPokemonDetail(pName).then(
        (detail) => PokemonSummary(
          id: detail.id,
          name: detail.name,
          types: detail.types,
          imageUrl: detail.officialArtwork,
          animatedUrl: detail.animatedSprite,
        ),
      );
    }).toList();

    return await Future.wait(futures);
  }
}
