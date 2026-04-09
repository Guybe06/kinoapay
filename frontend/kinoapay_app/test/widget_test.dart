import "package:flutter_test/flutter_test.dart";
import "package:kinoapay_app/main.dart";

/// Vérifie que le point d'entrée de l'application s'initialise correctement.
void main() {
  testWidgets("Test de démarrage de l'application", (WidgetTester tester) async {
    await tester.pumpWidget(const KinoaPayApp());
    expect(find.byType(KinoaPayApp), findsOneWidget);
  });
}
