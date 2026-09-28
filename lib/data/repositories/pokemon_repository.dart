import '../models/pokemon_detail.dart';
import '../models/pokemon_species.dart';
import '../models/pokemon_summary.dart';
import '../services/poke_api_service.dart';

class PokemonRepository {
  final PokeApiService apiService;

  // In-memory cache to prevent duplicate requests
  final Map<int, PokemonDetail> _detailCache = {};
  final Map<int, PokemonSpecies> _speciesCache = {};
  final List<PokemonSummary> _masterList = [];

  PokemonRepository({PokeApiService? apiService})
      : apiService = apiService ?? PokeApiService();

  Future<List<PokemonSummary>> getPokemonList({
    int limit = 24,
    int offset = 0,
  }) async {
    final list = await apiService.fetchPokemonList(limit: limit, offset: offset);
    for (var p in list) {
      if (!_masterList.any((existing) => existing.id == p.id)) {
        _masterList.add(p);
      }
    }
    return list;
  }

  Future<PokemonDetail> getPokemonDetail(dynamic idOrName) async {
    if (idOrName is int && _detailCache.containsKey(idOrName)) {
      return _detailCache[idOrName]!;
    }

    final detail = await apiService.fetchPokemonDetail(idOrName);
    _detailCache[detail.id] = detail;
    return detail;
  }

  Future<PokemonSpecies> getPokemonSpecies(dynamic idOrName) async {
    if (idOrName is int && _speciesCache.containsKey(idOrName)) {
      return _speciesCache[idOrName]!;
    }

    final species = await apiService.fetchPokemonSpecies(idOrName);
    _speciesCache[species.id] = species;
    return species;
  }

  Future<List<PokemonSummary>> getPokemonByType(String typeName) async {
    return await apiService.fetchPokemonByType(typeName);
  }

  Future<PokemonSummary> searchPokemon(String query) async {
    final q = query.toLowerCase().trim();

    // Check if query is an ID number or name
    final detail = await getPokemonDetail(q);
    return PokemonSummary(
      id: detail.id,
      name: detail.name,
      types: detail.types,
      imageUrl: detail.officialArtwork,
      animatedUrl: detail.animatedSprite,
    );
  }
}
