import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/pokemon_types.dart';
import '../../core/utils/string_utils.dart';
import '../../data/models/pokemon_summary.dart';
import '../providers/pokemon_provider.dart';
import 'type_badge.dart';

class PokemonCard extends StatelessWidget {
  final PokemonSummary pokemon;
  final VoidCallback onTap;

  const PokemonCard({
    super.key,
    required this.pokemon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final mainType = pokemon.types.isNotEmpty ? pokemon.types.first : 'normal';
    final cardBgColor = PokemonTypeHelper.getTypeColor(mainType);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<PokemonProvider>(
      builder: (context, provider, child) {
        final isFav = provider.isFavorite(pokemon.id);

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(24),
            splashColor: cardBgColor.withValues(alpha: 0.3),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          cardBgColor.withValues(alpha: 0.4),
                          cardBgColor.withValues(alpha: 0.2),
                        ]
                      : [
                          cardBgColor.withValues(alpha: 0.85),
                          cardBgColor.withValues(alpha: 0.65),
                        ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: cardBgColor.withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Pokéball Background Decorative Pattern
                  Positioned(
                    right: -15,
                    bottom: -15,
                    child: Icon(
                      Icons.catching_pokemon,
                      size: 130,
                      color: Colors.white.withValues(alpha: 0.15),
                    ),
                  ),

                  // ID Badge Top Right
                  Positioned(
                    right: 12,
                    top: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        StringUtils.formatPokemonId(pokemon.id),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),

                  // Favorite Button Top Left
                  Positioned(
                    left: 6,
                    top: 6,
                    child: IconButton(
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.redAccent : Colors.white70,
                        size: 20,
                      ),
                      onPressed: () => provider.toggleFavorite(pokemon.id),
                    ),
                  ),

                  // Main Content Padding
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 40, 14, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Pokémon Name
                        Text(
                          StringUtils.capitalize(pokemon.name),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black38,
                                blurRadius: 4,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),

                        // Types and Image Row
                        Expanded(
                          child: Row(
                            children: [
                              // Types Column
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: pokemon.types
                                    .map((type) => Padding(
                                          padding: const EdgeInsets.only(bottom: 4.0),
                                          child: TypeBadge(
                                            typeName: type,
                                            fontSize: 10,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 3),
                                          ),
                                        ))
                                    .toList(),
                              ),

                              // Artwork Image
                              Expanded(
                                child: Hero(
                                  tag: 'pokemon_img_${pokemon.id}',
                                  child: Image.network(
                                    pokemon.imageUrl,
                                    fit: BoxFit.contain,
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const Center(
                                        child: SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                                          ),
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.catching_pokemon,
                                        size: 50,
                                        color: Colors.white54,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
