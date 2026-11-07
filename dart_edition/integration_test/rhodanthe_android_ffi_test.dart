import "dart:io";

import "package:flutter_test/flutter_test.dart";
import "package:integration_test/integration_test.dart";
import "package:monogatari_assistant/infrastructure/rhodanthe/rhodanthe_native_client.dart";
import "package:monogatari_assistant/infrastructure/rhodanthe/rhodanthe_protocol.dart";
import "package:monogatari_assistant/infrastructure/rhodanthe/rhodanthe_worker_executor.dart";

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    "Android loads the packaged bridge and analyzes UTF-16 in a worker",
    (tester) async {
      // No explicit development path: this must resolve the library from the APK.
      final client = RhodantheNativeClient.open();
      expect(client.abiVersion, rhodantheAbiVersion);
      client.dispose();

      await tester.runAsync(() async {
        final worker = await RhodantheWorkerExecutor.start();
        try {
          final handshake = await worker.execute(
            RhodantheRequest.handshake(requestId: 1),
          );
          expect(handshake.ok, isTrue);
          expect(handshake.requireResult()["abiVersion"], rhodantheAbiVersion);
          final opened = await worker.execute(
            RhodantheRequest.openDocument(
              requestId: 2,
              documentId: "android-ffi",
              revision: 1,
              fullText: "😀你好 你好",
            ),
          );
          expect(opened.ok, isTrue);
          final response = await worker.execute(
            RhodantheRequest.analyze(
              requestId: 3,
              documentId: "android-ffi",
              revision: 1,
              search: const RhodantheSearchRequest(
                query: "你好",
                queryRevision: 1,
                activeMatchIndex: 1,
              ),
            ),
          );
          final analysis = RhodantheAnalysisResult.fromResponse(response);
          expect(analysis.renderPlan.plan.textLenUtf16, 7);
          expect(analysis.renderPlan.plan.runs.first.range.start, 2);
          expect(analysis.search?["activeMatchId"], "search:1:1");
          final closed = await worker.execute(
            RhodantheRequest.closeDocument(
              requestId: 4,
              documentId: "android-ffi",
            ),
          );
          expect(closed.ok, isTrue);
        } finally {
          await worker.dispose();
        }
      });
    },
    skip: !Platform.isAndroid,
  );
}
