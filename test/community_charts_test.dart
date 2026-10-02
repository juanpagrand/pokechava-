// Test de los 65 gráficos: cuántos son, el orden y que dibujen sin errores.

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
      // deja terminar la animación
      await tester.pump(const Duration(seconds: 2));

      expect(tester.takeException(), isNull);
      expect(find.byType(CommunityChartCard), findsOneWidget);

      // desmontar para cancelar el Timer del A22
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
    });
  }
}
