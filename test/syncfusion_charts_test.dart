// Test de los 65 gráficos de Syncfusion: conteo, nivel y renderizado sin errores.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokemonapi/presentation/widgets/charts_syncfusion/syncfusion_charts_view.dart';


void main() {
  test('Syncfusion: hay 40 gráficos normales y 25 avanzados', () {
    expect(syncfusionChartBuilders(advanced: false), hasLength(40));
    expect(syncfusionChartBuilders(advanced: true), hasLength(25));
  });

  final builders = syncfusionChartBuilders();
  for (var i = 0; i < builders.length; i++) {
    final name = builders[i]().runtimeType.toString();
    testWidgets('Syncfusion: $name se dibuja sin errores', (tester) async {
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

      // Espera para animaciones iniciales
      await tester.pump(const Duration(milliseconds: 500));

      expect(tester.takeException(), isNull);

      // Desmontar widget para cancelar Timers de gráficos dinámicos (A04)
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 200));
    });
  }
}
