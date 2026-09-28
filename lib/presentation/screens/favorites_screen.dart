import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pokemon_provider.dart';
import '../widgets/pokemon_card.dart';
import 'pokemon_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = 2;
    if (mediaWidth > 1200) {
      crossAxisCount = 5;
    } else if (mediaWidth > 900) {
      crossAxisCount = 4;
    } else if (mediaWidth > 600) {
      crossAxisCount = 3;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos ❤️'),
        centerTitle: true,
      ),
      body: Consumer<PokemonProvider>(
        builder: (context, provider, child) {
          final favList = provider.favoritePokemonList;

          if (favList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.favorite_border, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No tienes Pokémon favoritos guardados.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Toca el corazón en la tarjeta de cualquier Pokémon para guardarlo.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 1.25,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: favList.length,
            itemBuilder: (context, index) {
              final pokemon = favList[index];
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
          );
        },
      ),
    );
  }
}
