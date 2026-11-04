import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:super_clipboard/super_clipboard.dart' as native;

class MosaicClipboardData {
  const MosaicClipboardData({required this.text, this.rawText});
  final String text;
  final String? rawText;
}

abstract class MosaicClipboardBackend {
  Future<void> write(MosaicClipboardData data);
  Future<MosaicClipboardData> read();
}

/// Public text excludes implicit mentions. The private representation preserves
/// the complete Mosaic source for pasting between MonoAshi windows/processes.
abstract final class MosaicClipboard {
  static MosaicClipboardBackend backend = SystemMosaicClipboard();

  static Future<void> write({required String text, required String rawText}) =>
      backend.write(MosaicClipboardData(text: text, rawText: rawText));

  static Future<MosaicClipboardData> read() => backend.read();
}

class SystemMosaicClipboard implements MosaicClipboardBackend {
  static const format = native.CustomValueFormat<Uint8List>(
    applicationId: 'com.heyairu.monoashi.mosaic',
  );

  @override
  Future<void> write(MosaicClipboardData data) async {
    final clipboard = native.SystemClipboard.instance;
    if (clipboard == null) {
      await Clipboard.setData(ClipboardData(text: data.text));
      return;
    }
    final item = native.DataWriterItem();
    item.add(native.Formats.plainText(data.text));
    if (data.rawText case final raw?) {
      item.add(
        format(
          Uint8List.fromList(
            utf8.encode(
              jsonEncode({'version': 1, 'rawText': raw, 'text': data.text}),
            ),
          ),
        ),
      );
    }
    await clipboard.write([item]);
  }

  @override
  Future<MosaicClipboardData> read() async {
    final clipboard = native.SystemClipboard.instance;
    if (clipboard == null) {
      return MosaicClipboardData(
        text: (await Clipboard.getData(Clipboard.kTextPlain))?.text ?? '',
      );
    }
    final reader = await clipboard.read();
    final text = await reader.readValue(native.Formats.plainText) ?? '';
    String? rawText;
    if (reader.canProvide(format)) {
      final bytes = await reader.readValue(format);
      if (bytes != null) {
        try {
          final value = jsonDecode(utf8.decode(bytes));
          if (value is Map &&
              value['version'] == 1 &&
              value['text'] == text &&
              value['rawText'] is String) {
            rawText = value['rawText'] as String;
          }
        } on FormatException {
          // A foreign/malformed private payload falls back to public text.
        }
      }
    }
    return MosaicClipboardData(text: text, rawText: rawText);
  }
}
