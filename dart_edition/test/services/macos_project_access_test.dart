import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monogatari_assistant/bin/file.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('com.heyairu.monogatari_assistant/file');

  test(
    'restores bookmarks before path checks and keeps refreshed write tokens',
    () async {
      final calls = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            calls.add(call);
            if (call.method == 'openProjectFromSecurityScopedBookmark') {
              expect((call.arguments as Map)['bookmark'], 'old-token');
              return {
                'name': 'moved.mnproj',
                'path': '/missing/moved.mnproj',
                'uri': 'read-token',
                'content': '<Project />',
              };
            }
            if (call.method == 'writeProjectFromSecurityScopedBookmark') {
              return {'path': '/missing/moved.mnproj', 'uri': 'written-token'};
            }
            fail('Unexpected call: ${call.method}');
          });
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, null),
      );

      final project = await FileService.openProjectFromPath(
        '/missing/old.mnproj',
        accessToken: 'old-token',
      );
      expect(project.uri, 'read-token');
      project.content = 'edited';
      await FileService.saveProject(project);
      expect(project.uri, 'written-token');
      expect((calls.last.arguments as Map)['bookmark'], 'read-token');
      expect((calls.last.arguments as Map)['content'], 'edited');
      project.content = 'edited again';
      await FileService.saveProjectToKnownLocation(project);
      expect((calls.last.arguments as Map)['bookmark'], 'written-token');
      expect((calls.last.arguments as Map)['content'], 'edited again');
      expect(calls.map((c) => c.method), [
        'openProjectFromSecurityScopedBookmark',
        'writeProjectFromSecurityScopedBookmark',
        'writeProjectFromSecurityScopedBookmark',
      ]);
    },
    skip: !Platform.isMacOS,
  );
}
