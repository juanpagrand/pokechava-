// Prueba de los 65 gráficos de community_charts_flutter (rama Carlos).
// Comprueba que hay 40 + 25, numerados sin saltos, y que cada uno se dibuja
// sin lanzar errores. No juzga el diseño: eso se revisa mirándolos.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokemonapi/presentation/widgets/charts_community/charts_community.dart';
import 'package:pokemonapi/presentation/widgets/charts_community/community_charts_view.dart';

void main() {
  test('hay 40 gráficos normales y 25 avanzados', () {
    expect(communityChartBuilders(advanced: false), hasLength(40));
    expect(communityChartBuilders(advanced: true), hasLength(25));
  });

  test('los códigos van de N01 a N40 y de A01 a A25, sin saltos', () {
    final names = [
      for (final build in communityChartBuilders()) build().runtimeType.toString(),
    ];
    expect(names, [
      for (var i = 1; i <= 40; i++)
        'CommunityNormal${i.toString().padLeft(2, '0')}',
      for (var i = 1; i <= 25; i++)
        'CommunityAdvanced${i.toString().padLeft(2, '0')}',
    ]);
  });

  final builders = communityChartBuilders();
  for (var i = 0; i < builders.length; i++) {
    final name = builders[i]().runtimeType.toString();
    testWidgets('$name se dibuja sin errores', (tester) async {
      tester.view.physicalSize = const Size(900, 1400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: builders[i](),
            ),
          ),
        ),
      ));
      // Deja correr la animación de entrada.
      await tester.pump(const Duration(seconds: 2));

      expect(tester.takeException(), isNull);
      expect(find.byType(CommunityChartCard), findsOneWidget);

      // Desmonta para cancelar timers (el A22 simula datos en vivo).
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
    });
  }
}
