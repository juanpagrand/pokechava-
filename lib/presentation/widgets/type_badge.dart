import 'package:flutter/material.dart';
import '../../core/constants/pokemon_types.dart';

class TypeBadge extends StatelessWidget {
  final String typeName;
  final double fontSize;
  final EdgeInsetsGeometry padding;

  const TypeBadge({
    super.key,
    required this.typeName,
    this.fontSize = 12,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  });

  @override
  Widget build(BuildContext context) {
    final color = PokemonTypeHelper.getTypeColor(typeName);
    final spanishName = PokemonTypeHelper.getSpanishName(typeName);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        spanishName,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
