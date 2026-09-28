import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/pokemon_types.dart';
import '../providers/pokemon_provider.dart';

class PokemonTypeFilter extends StatelessWidget {
  const PokemonTypeFilter({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PokemonProvider>(context);
    final selectedType = provider.selectedType;
    final allTypes = ['all', ...PokemonTypeHelper.getAllTypes()];

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: allTypes.length,
        itemBuilder: (context, index) {
          final type = allTypes[index];
          final isSelected = selectedType == type;

          String displayName;
          Color chipColor;

          if (type == 'all') {
            displayName = 'Todos';
            chipColor = Colors.redAccent;
          } else {
            displayName = PokemonTypeHelper.getSpanishName(type);
            chipColor = PokemonTypeHelper.getTypeColor(type);
          }

          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(
                displayName,
                style: TextStyle(
                  color: isSelected ? Colors.white : (Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black87),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 12,
                ),
              ),
              selected: isSelected,
              selectedColor: chipColor,
              backgroundColor: Theme.of(context).cardColor,
              elevation: isSelected ? 3 : 0,
              showCheckmark: false,
              side: BorderSide(
                color: isSelected ? chipColor : Colors.transparent,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              onSelected: (selected) {
                if (selected) {
                  provider.filterByType(type);
                }
              },
            ),
          );
        },
      ),
    );
  }
}
