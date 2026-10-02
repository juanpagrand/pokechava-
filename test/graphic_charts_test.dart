// ===========================================================================
// test/graphic_charts_test.dart — PRUEBAS DE LOS 65 GRÁFICOS DE graphic
// ===========================================================================
// Qué prueba (se corre con `flutter test`):
//   1. Que hay exactamente 40 gráficos normales y 25 avanzados.
//   2. Que están en orden N01…N40 y A01…A25, sin saltos ni repetidos.
//   3. Que CADA uno de los 65 se dibuja sin lanzar errores (una prueba de
//      widget por gráfico: 65 + 2 = 67 pruebas de este archivo).
//
// Imports:
//   - flutter/material.dart     → MaterialApp, Scaffold, Size…
//   - flutter_test              → test, testWidgets, expect, find…
//   - charts_graphic.dart       → el barril; aquí se usa GraphicChartCard.
//   - graphic_charts_view.dart  → graphicChartBuilders(), la lista de
//     funciones que crean los gráficos (la misma que usa la pantalla).
// Se importa con `package:pokemonapi/...` porque los tests viven fuera de
// lib/ y "pokemonapi" es el nombre del proyecto en pubspec.yaml.
// ===========================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokemonapi/presentation/widgets/charts_graphic/charts_graphic.dart';
import 'package:pokemonapi/presentation/widgets/charts_graphic/graphic_charts_view.dart';

void main() {
  // Prueba simple (sin dibujar): cuenta los constructores por nivel.
  test('hay 40 gráficos normales y 25 avanzados', () {
    expect(graphicChartBuilders(advanced: false), hasLength(40));
    expect(graphicChartBuilders(advanced: true), hasLength(25));
  });

  // Crea cada widget y mira el nombre de su clase (runtimeType). La lista
  // esperada se genera con padLeft(2, '0') → '01', '02'… Si alguien
  // olvida o repite un gráfico en graphic_charts_view.dart, esto falla.
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

  // Un testWidgets por gráfico, generado en un bucle; el nombre de la
  // prueba es el de la clase (p. ej. "GraphicNormal05 se dibuja…").
  final builders = graphicChartBuilders();
  for (var i = 0; i < builders.length; i++) {
    final name = builders[i]().runtimeType.toString();
    testWidgets('$name se dibuja sin errores', (tester) async {
      // Pantalla virtual de 900 × 1400 px para que el gráfico tenga
      // espacio; addTearDown la restaura al terminar la prueba.
      tester.view.physicalSize = const Size(900, 1400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      // Monta el gráfico dentro de una app mínima, igual que en la lista.
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

      // Ninguna excepción durante el dibujo y la tarjeta está en pantalla.
      expect(tester.takeException(), isNull);
      expect(find.byType(GraphicChartCard), findsOneWidget);

      // Desmonta para cancelar timers (el A13 simula datos en vivo).
      // Al quitar el widget se llama su dispose(), que cancela el Timer;
      // si quedara un Timer vivo, flutter_test haría fallar la prueba.
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
    });
  }
}
