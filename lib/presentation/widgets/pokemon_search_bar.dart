import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pokemon_provider.dart';

class PokemonSearchBar extends StatefulWidget {
  const PokemonSearchBar({super.key});

  @override
  State<PokemonSearchBar> createState() => _PokemonSearchBarState();
}

class _PokemonSearchBarState extends State<PokemonSearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showSortDialog(BuildContext context, PokemonProvider provider) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ordenar por',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.tag),
                title: const Text('Número (Menor a Mayor)'),
                trailing: provider.currentSort == SortOption.idAsc
                    ? const Icon(Icons.check, color: Colors.redAccent)
                    : null,
                onTap: () {
                  provider.changeSort(SortOption.idAsc);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.tag),
                title: const Text('Número (Mayor a Menor)'),
                trailing: provider.currentSort == SortOption.idDesc
                    ? const Icon(Icons.check, color: Colors.redAccent)
                    : null,
                onTap: () {
                  provider.changeSort(SortOption.idDesc);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.sort_by_alpha),
                title: const Text('Nombre (A - Z)'),
                trailing: provider.currentSort == SortOption.nameAsc
                    ? const Icon(Icons.check, color: Colors.redAccent)
                    : null,
                onTap: () {
                  provider.changeSort(SortOption.nameAsc);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.sort_by_alpha),
                title: const Text('Nombre (Z - A)'),
                trailing: provider.currentSort == SortOption.nameDesc
                    ? const Icon(Icons.check, color: Colors.redAccent)
                    : null,
                onTap: () {
                  provider.changeSort(SortOption.nameDesc);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PokemonProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _controller,
                onSubmitted: (value) => provider.search(value),
                onChanged: (value) {
                  if (value.isEmpty) {
                    provider.search('');
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Buscar por nombre o número...',
                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                  prefixIcon: const Icon(Icons.search, color: Colors.redAccent),
                  suffixIcon: _controller.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 20),
                          onPressed: () {
                            _controller.clear();
                            provider.search('');
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Sort Button
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.tune, color: Colors.redAccent),
              onPressed: () => _showSortDialog(context, provider),
            ),
          ),
        ],
      ),
    );
  }
}
