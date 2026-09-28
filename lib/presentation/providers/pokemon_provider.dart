import 'package:flutter/material.dart';
import '../../data/models/pokemon_detail.dart';
import '../../data/models/pokemon_species.dart';
import '../../data/models/pokemon_summary.dart';
import '../../data/repositories/pokemon_repository.dart';

enum SortOption { idAsc, idDesc, nameAsc, nameDesc }

class PokemonProvider extends ChangeNotifier {
  final PokemonRepository repository;

  List<PokemonSummary> _pokemonList = [];
  List<PokemonSummary> _filteredList = [];
  final Set<int> _favoriteIds = {};

  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _isSearching = false;
  String? _errorMessage;

  int _currentOffset = 0;
  final int _limit = 24;
  bool _hasMore = true;

  String _searchQuery = '';
  String _selectedType = 'all';
  SortOption _currentSort = SortOption.idAsc;

  PokemonDetail? _selectedDetail;
  PokemonSpecies? _selectedSpecies;
  bool _isLoadingDetail = false;

  PokemonProvider({PokemonRepository? repository})
      : repository = repository ?? PokemonRepository() {
    loadInitialPokemon();
  }

  // Getters
  List<PokemonSummary> get pokemonList => _filteredList;
  Set<int> get favoriteIds => _favoriteIds;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get isSearching => _isSearching;
  String? get errorMessage => _errorMessage;
  String get selectedType => _selectedType;
  SortOption get currentSort => _currentSort;

  PokemonDetail? get selectedDetail => _selectedDetail;
  PokemonSpecies? get selectedSpecies => _selectedSpecies;
  bool get isLoadingDetail => _isLoadingDetail;
  bool get hasMore => _hasMore && _selectedType == 'all' && _searchQuery.isEmpty;

  List<PokemonSummary> get favoritePokemonList {
    return _pokemonList.where((p) => _favoriteIds.contains(p.id)).toList();
  }

  bool isFavorite(int id) => _favoriteIds.contains(id);

  void toggleFavorite(int id) {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }
    notifyListeners();
  }

  /// Initial load
  Future<void> loadInitialPokemon() async {
    _isLoading = true;
    _errorMessage = null;
    _currentOffset = 0;
    notifyListeners();

    try {
      final list = await repository.getPokemonList(limit: _limit, offset: _currentOffset);
      _pokemonList = list;
      _currentOffset += _limit;
      _applyFilterAndSort();
    } catch (e) {
      _errorMessage = 'No se pudo conectar a PokeAPI. Por favor verifica tu conexión.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load more items for pagination
  Future<void> loadMorePokemon() async {
    if (_isLoadingMore || !_hasMore || _selectedType != 'all' || _searchQuery.isNotEmpty) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final newItems = await repository.getPokemonList(limit: _limit, offset: _currentOffset);
      if (newItems.isEmpty) {
        _hasMore = false;
      } else {
        _pokemonList.addAll(newItems);
        _currentOffset += _limit;
        _applyFilterAndSort();
      }
    } catch (e) {
      // Keep existing list on pagination fail
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  /// Search Pokémon by query (name or ID)
  Future<void> search(String query) async {
    _searchQuery = query.trim();

    if (_searchQuery.isEmpty) {
      _isSearching = false;
      _applyFilterAndSort();
      notifyListeners();
      return;
    }

    _isSearching = true;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // First try filtering local list
      final localMatches = _pokemonList.where((p) =>
          p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.id.toString() == _searchQuery).toList();

      if (localMatches.isNotEmpty) {
        _filteredList = localMatches;
      } else {
        // If not found locally, fetch directly from API
        final result = await repository.searchPokemon(_searchQuery);
        _filteredList = [result];
      }
    } catch (e) {
      _filteredList = [];
      _errorMessage = 'No se encontró ningún Pokémon con "$query".';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Filter list by type
  Future<void> filterByType(String type) async {
    _selectedType = type;
    _searchQuery = '';

    if (type == 'all') {
      _applyFilterAndSort();
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final list = await repository.getPokemonByType(type);
      _filteredList = list;
      _applySortOnly();
    } catch (e) {
      _errorMessage = 'Error al filtrar Pokémon por tipo.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Change Sort Order
  void changeSort(SortOption sort) {
    _currentSort = sort;
    _applySortOnly();
    notifyListeners();
  }

  void _applyFilterAndSort() {
    List<PokemonSummary> temp = List.from(_pokemonList);
    if (_selectedType != 'all') {
      temp = temp.where((p) => p.types.contains(_selectedType)).toList();
    }
    _filteredList = temp;
    _applySortOnly();
  }

  void _applySortOnly() {
    switch (_currentSort) {
      case SortOption.idAsc:
        _filteredList.sort((a, b) => a.id.compareTo(b.id));
        break;
      case SortOption.idDesc:
        _filteredList.sort((a, b) => b.id.compareTo(a.id));
        break;
      case SortOption.nameAsc:
        _filteredList.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortOption.nameDesc:
        _filteredList.sort((a, b) => b.name.compareTo(a.name));
        break;
    }
  }

  /// Load Pokemon Detail
  Future<void> loadPokemonDetail(dynamic idOrName) async {
    _selectedDetail = null;
    _selectedSpecies = null;
    _isLoadingDetail = true;
    notifyListeners();

    try {
      final detailFuture = repository.getPokemonDetail(idOrName);
      final speciesFuture = repository.getPokemonSpecies(idOrName);

      _selectedDetail = await detailFuture;
      _selectedSpecies = await speciesFuture;
    } catch (e) {
      _selectedDetail = null;
      _selectedSpecies = null;
    } finally {
      _isLoadingDetail = false;
      notifyListeners();
    }
  }
}
