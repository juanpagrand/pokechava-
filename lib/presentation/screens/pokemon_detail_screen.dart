import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/pokemon_types.dart';
import '../../core/utils/string_utils.dart';
import '../../data/models/pokemon_detail.dart';
import '../../data/models/pokemon_species.dart';
import '../../data/models/pokemon_summary.dart';
import '../providers/pokemon_provider.dart';
import '../widgets/stat_bar.dart';
import '../widgets/type_badge.dart';

class PokemonDetailScreen extends StatefulWidget {
  final PokemonSummary pokemonSummary;

  const PokemonDetailScreen({
    super.key,
    required this.pokemonSummary,
  });

  @override
  State<PokemonDetailScreen> createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mainType = widget.pokemonSummary.types.isNotEmpty
        ? widget.pokemonSummary.types.first
        : 'normal';
    final typeColor = PokemonTypeHelper.getTypeColor(mainType);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: typeColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Consumer<PokemonProvider>(
            builder: (context, provider, child) {
              final isFav = provider.isFavorite(widget.pokemonSummary.id);
              return IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.redAccent : Colors.white,
                  size: 28,
                ),
                onPressed: () => provider.toggleFavorite(widget.pokemonSummary.id),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Consumer<PokemonProvider>(
        builder: (context, provider, child) {
          final detail = provider.selectedDetail;
          final species = provider.selectedSpecies;
          final isLoading = provider.isLoadingDetail;

          return Stack(
            children: [
              // Header Section (Name, ID, Types, Watermark)
              Positioned(
                top: 0,
                left: 20,
                right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            StringUtils.capitalize(widget.pokemonSummary.name),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          StringUtils.formatPokemonId(widget.pokemonSummary.id),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: widget.pokemonSummary.types
                          .map((type) => Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: TypeBadge(
                                  typeName: type,
                                  fontSize: 12,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 6),
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),

              // Pokéball Background Watermark
              Positioned(
                right: -20,
                top: 60,
                child: Icon(
                  Icons.catching_pokemon,
                  size: 240,
                  color: Colors.white.withValues(alpha: 0.12),
                ),
              ),

              // Bottom White / Dark Card Sheet
              Positioned.fill(
                top: 240,
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E24) : Colors.white,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 15,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 50, 20, 16),
                    child: Column(
                      children: [
                        // Tab Bar Navigation
                        TabBar(
                          controller: _tabController,
                          labelColor: typeColor,
                          unselectedLabelColor: Colors.grey,
                          indicatorColor: typeColor,
                          indicatorWeight: 3,
                          tabs: const [
                            Tab(text: 'Acerca de'),
                            Tab(text: 'Estadísticas'),
                            Tab(text: 'Habilidades'),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Tab Content View
                        Expanded(
                          child: isLoading || detail == null
                              ? const Center(
                                  child: CircularProgressIndicator(color: Colors.redAccent),
                                )
                              : TabBarView(
                                  controller: _tabController,
                                  children: [
                                    // 1. About Tab
                                    _buildAboutTab(detail, species),

                                    // 2. Stats Tab
                                    _buildStatsTab(detail),

                                    // 3. Abilities Tab
                                    _buildAbilitiesTab(detail),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Hero Artwork Overlay Centered
              Positioned(
                top: 90,
                left: 0,
                right: 0,
                child: Center(
                  child: Hero(
                    tag: 'pokemon_img_${widget.pokemonSummary.id}',
                    child: SizedBox(
                      height: 190,
                      width: 190,
                      child: Image.network(
                        detail?.officialArtwork ?? widget.pokemonSummary.imageUrl,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAboutTab(PokemonDetail detail, PokemonSpecies? species) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Flavor text description
          if (species != null)
            Text(
              species.description,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87,
              ),
            ),
          const SizedBox(height: 20),

          // Height & Weight Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.grey.withValues(alpha: 0.15),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Icon(Icons.fitness_center, color: Colors.grey, size: 20),
                    const SizedBox(height: 6),
                    Text(
                      StringUtils.formatWeight(detail.weight),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 2),
                    const Text('Peso', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                Container(height: 30, width: 1, color: Colors.grey.withValues(alpha: 0.3)),
                Column(
                  children: [
                    const Icon(Icons.height, color: Colors.grey, size: 20),
                    const SizedBox(height: 6),
                    Text(
                      StringUtils.formatHeight(detail.height),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 2),
                    const Text('Altura', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Species Details Table
          if (species != null) ...[
            _buildDetailRow('Categoría', species.genus),
            _buildDetailRow('Hábitat', species.habitat),
            if (species.isLegendary)
              _buildDetailRow('Especial', 'Pokémon Legendario ⭐'),
            if (species.isMythical)
              _buildDetailRow('Especial', 'Pokémon Mítico ✨'),
          ],
        ],
      ),
    );
  }

  Widget _buildStatsTab(PokemonDetail detail) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ...detail.stats.map((stat) => StatBar(
                statName: stat.name,
                statValue: stat.baseStat,
              )),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Base',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${detail.totalStats}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAbilitiesTab(PokemonDetail detail) {
    return ListView.builder(
      itemCount: detail.abilities.length,
      itemBuilder: (context, index) {
        final ability = detail.abilities[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            leading: const Icon(Icons.auto_awesome, color: Colors.amber),
            title: Text(
              StringUtils.capitalize(ability),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('Habilidad #${index + 1}'),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
