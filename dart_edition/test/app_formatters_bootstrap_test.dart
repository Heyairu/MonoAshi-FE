import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monogatari_assistant/l10n/app_formatters.dart';

void main() {
  // Each test has a separate FakeAsync Zone. Initialization must complete in
  // each host, even after the first host and its event queue are disposed.
  for (var session = 1; session <= 2; session++) {
    testWidgets('offline date bootstrap completes in host session $session', (
      tester,
    ) async {
      await AppFormatters.initialize();
      final format = AppFormatters(const Locale('ja'));
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Text(format.date(DateTime(2026, 11, 2))),
        ),
      );
      expect(find.text('2026/11/2'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    });
  }
}
