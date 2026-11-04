import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_test/flutter_test.dart";
import "package:monogatari_assistant/data/repositories/palette_repository.dart";
import "package:monogatari_assistant/bin/ui_library.dart";
import "package:monogatari_assistant/modules/palettesview.dart";
import "package:monogatari_assistant/presentation/providers/palette_state_provider.dart";

class _WidgetPaletteRepository implements PaletteRepository {
  String? userData;
  int writeCount = 0;

  @override
  Future<String?> readUserData() async => userData;

  @override
  Future<String> readSeedData() async {
    return '{"version":1,"slotEntryIds":{},"entries":{}}';
  }

  @override
  Future<void> writeUserData(String content) async {
    userData = content;
    writeCount++;
  }
}

void main() {
  testWidgets("adds and searches a palette chip", (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final _WidgetPaletteRepository repository = _WidgetPaletteRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [paletteRepositoryProvider.overrideWithValue(repository)],
        child: const MaterialApp(home: Scaffold(body: PalettesView())),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text("文字色票"), findsOneWidget);
    expect(find.byType(AppTextField), findsNWidgets(2));
    expect(
      find.byKey(const ValueKey<String>("palette-import-export-menu")),
      findsOneWidget,
    );
    final Rect titleBounds = tester.getRect(find.text("文字色票"));
    final Rect searchBounds = tester.getRect(
      find.byKey(const ValueKey<String>("palette-search-field")),
    );
    final Rect importExportBounds = tester.getRect(
      find.byKey(const ValueKey<String>("palette-import-export-menu")),
    );
    expect(searchBounds.top, greaterThan(titleBounds.bottom));
    expect(importExportBounds.left, greaterThan(searchBounds.left));
    expect(importExportBounds.center.dy, closeTo(searchBounds.center.dy, 1));
    expect(find.byKey(const ValueKey('palette-color-wheel')), findsOneWidget);
    expect(find.byKey(const ValueKey('palette-radius-0.1')), findsOneWidget);
    expect(find.text('適中'), findsOneWidget);
    expect(find.textContaining('0.10'), findsNothing);
    expect(find.textContaining('Δ'), findsNothing);
    expect(find.textContaining('預設'), findsNothing);
    await tester.enterText(
      find.byKey(const ValueKey('palette-new-entry')),
      '焦灼',
    );
    await tester.tap(find.byKey(const ValueKey('palette-add-selected')));
    await tester.pumpAndSettle();

    expect(find.text("焦灼"), findsOneWidget);
    await tester.enterText(
      find.byKey(const ValueKey<String>("palette-search-field")),
      "焦",
    );
    await tester.pump();
    expect(find.text("焦灼"), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) => widget is Text && widget.data == '#FF0000',
      ),
      findsOneWidget,
    );
    expect(find.textContaining('Δ'), findsNothing);
    expect(repository.userData, contains('rgb-FF0000'));
    // Moving the picker changes the query, but never the saved association.
    final before = repository.userData;
    final wheel = tester.getRect(
      find.byKey(const ValueKey('palette-color-wheel')),
    );
    await tester.tapAt(Offset(wheel.center.dx, wheel.top + wheel.height * .93));
    await tester.pumpAndSettle();
    expect(repository.userData, before);
    expect(find.text('最近的詞條（超出範圍）'), findsOneWidget);
  });

  testWidgets('new entry keeps its draft and uses the color at submission', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final repository = _WidgetPaletteRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [paletteRepositoryProvider.overrideWithValue(repository)],
        child: const MaterialApp(home: Scaffold(body: PalettesView())),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('palette-add-selected')));
    await tester.pump();
    expect(find.text('詞條不可為空白'), findsOneWidget);
    await tester.enterText(
      find.byKey(const ValueKey('palette-new-entry')),
      '海霧',
    );
    await tester.enterText(
      find.byKey(const ValueKey('palette-hex-rgb-FF0000')),
      '#3A82BE',
    );
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<AppTextField>(find.byKey(const ValueKey('palette-new-entry')))
          .controller!
          .text,
      '海霧',
    );
    await tester.tap(find.byKey(const ValueKey('palette-new-entry')));
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(repository.userData, contains('rgb-3A82BE'));
    expect(repository.userData, isNot(contains('rgb-FF0000')));
    expect(find.text('海霧'), findsOneWidget);
  });

  testWidgets('range choices filter gray entries at narrow width', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final repository = _WidgetPaletteRepository()
      ..userData =
          '{"version":2,"slotEntryIds":{"rgb-888888":["near"],"rgb-A0A0A0":["far"]},"entries":{"near":{"text":"近灰"},"far":{"text":"遠灰"}}}';
    await tester.pumpWidget(
      ProviderScope(
        overrides: [paletteRepositoryProvider.overrideWithValue(repository)],
        child: const MaterialApp(home: Scaffold(body: PalettesView())),
      ),
    );
    await tester.pumpAndSettle();
    final hex = find.byKey(const ValueKey('palette-hex-rgb-FF0000'));
    await tester.enterText(hex, '#808080');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(find.text('近灰'), findsOneWidget);
    expect(find.text('遠灰'), findsNothing);
    final broad = find.byKey(const ValueKey('palette-radius-0.2'));
    await tester.ensureVisible(broad);
    await tester.tap(broad);
    await tester.pumpAndSettle();
    expect(find.text('遠灰'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets("does not overwrite a corrupt user file", (
    WidgetTester tester,
  ) async {
    final _WidgetPaletteRepository repository = _WidgetPaletteRepository()
      ..userData = "not-json";

    await tester.pumpWidget(
      ProviderScope(
        overrides: [paletteRepositoryProvider.overrideWithValue(repository)],
        child: const MaterialApp(home: Scaffold(body: PalettesView())),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text("調色盤載入失敗"), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    expect(repository.userData, "not-json");
    expect(repository.writeCount, 0);
  });
}
