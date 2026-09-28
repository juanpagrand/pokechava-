import 'package:flutter_test/flutter_test.dart';
import 'package:pokemonapi/data/models/pokemon_summary.dart';

void main() {
  group('PokemonSummary Model Tests', () {
    test('PokemonSummary.fromJson parses correctly', () {
      final json = {
        'id': 25,
        'name': 'pikachu',
        'types': [
          {
            'type': {'name': 'electric'}
          }
        ],
        'sprites': {
          'other': {
            'official-artwork': {
              'front_default': 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/25.png'
            }
          }
        }
      };

      final summary = PokemonSummary.fromJson(json);

      expect(summary.id, 25);
      expect(summary.name, 'pikachu');
      expect(summary.types, ['electric']);
      expect(summary.imageUrl, contains('25.png'));
    });
  });
}
