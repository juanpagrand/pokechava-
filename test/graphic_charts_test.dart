import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokemonapi/presentation/widgets/charts_graphic/charts_graphic.dart';
import 'package:pokemonapi/presentation/widgets/charts_graphic/graphic_charts_view.dart';

void main() {
  test('hay 40 gráficos normales y 25 avanzados', () {
    expect(graphicChartBuilders(advanced: false), hasLength(40));
    expect(graphicChartBuilders(advanced: true), hasLength(25));
  });

  test('los códigos van de N01 a N40 y de A01 a A25, sin saltos', () {
    final codes = [
      for (final build in graphicChartBuilders())
        (build() as dynamic).runtimeType.toString(),
    ];
    expect(codes, [
      for (var i = 1; i <= 40; i++) 'GraphicNormal${i.toString().padLeft(2, '0')}',
      for (var i = 1; i <= 25; i++)
        'GraphicAdvanced${i.toString().padLeft(2, '0')}',
    ]);
  });

  final builders = graphicChartBuilders();
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
      // Deja correr animaciones de entrada y transiciones.
      await tester.pump(const Duration(seconds: 2));

      expect(tester.takeException(), isNull);
      expect(find.byType(GraphicChartCard), findsOneWidget);

      // Desmonta para cancelar timers (el A13 simula datos en vivo).
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
    });
  }
}
