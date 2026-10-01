import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pokemon_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/pokemon_card.dart';
import '../widgets/pokemon_search_bar.dart';
import '../widgets/pokemon_type_filter.dart';
import '../widgets/skeleton_loader.dart';
import 'favorites_screen.dart';
import 'pokemon_detail_screen.dart';
import 'charts_gallery_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final provider = Provider.of<PokemonProvider>(context, listen: false);
      if (provider.hasMore) {
        provider.loadMorePokemon();
      }
    }
  }

  int _calculateCrossAxisCount(double width) {
    if (width > 1200) return 5;
    if (width > 900) return 4;
    if (width > 600) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final mediaWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = _calculateCrossAxisCount(mediaWidth);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.catching_pokemon, color: Colors.redAccent, size: 28),
            SizedBox(width: 8),
            Text(
              'Pokédex',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 24),
            ),
          ],
        ),
        actions: [
          // Favorites Button
          Consumer<PokemonProvider>(
            builder: (context, provider, child) {
              final favCount = provider.favoriteIds.length;
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.redAccent),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FavoritesScreen(),
                        ),
                      );
                    },
                  ),
                  if (favCount > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.amber,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '$favCount',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),

          // Charts Gallery Button
          IconButton(
            tooltip: 'Ver 40 Gráficos',
            icon: const Icon(Icons.bar_chart_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChartsGalleryScreen(),
                ),
              );
            },
          ),

          // Theme Toggle
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () => themeProvider.toggleTheme(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const PokemonSearchBar(),
            const SizedBox(height: 4),
            const PokemonTypeFilter(),
            const SizedBox(height: 10),

            // Content Grid / States
            Expanded(
              child: Consumer<PokemonProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: 1.3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: 12,
                      itemBuilder: (context, index) => const SkeletonLoader(),
                    );
                  }

                  if (provider.errorMessage != null && provider.pokemonList.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.search_off, size: 80, color: Colors.grey),
                            const SizedBox(height: 16),
                            Text(
                              provider.errorMessage!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () => provider.loadInitialPokemon(),
                              icon: const Icon(Icons.refresh),
                              label: const Text('Reintentar'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (provider.pokemonList.isEmpty) {
                    return const Center(
                      child: Text(
                        'No se encontraron Pokémon',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () => provider.loadInitialPokemon(),
                    color: Colors.redAccent,
                    child: GridView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: 1.25,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: provider.pokemonList.length + (provider.isLoadingMore ? crossAxisCount : 0),
                      itemBuilder: (context, index) {
                        if (index >= provider.pokemonList.length) {
                          return const SkeletonLoader();
                        }
                        final pokemon = provider.pokemonList[index];
                        return PokemonCard(
                          pokemon: pokemon,
                          onTap: () {
                            provider.loadPokemonDetail(pokemon.id);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PokemonDetailScreen(
                                  pokemonSummary: pokemon,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
