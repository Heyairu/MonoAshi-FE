import 'package:flutter/services.dart';
import 'package:monogatari_assistant/features/inline_annotations/mosaic_clipboard.dart';

class MemoryMosaicClipboard implements MosaicClipboardBackend {
  MosaicClipboardData data = const MosaicClipboardData(text: '');

  @override
  Future<MosaicClipboardData> read() async => data;

  @override
  Future<void> write(MosaicClipboardData value) async {
    data = value;
    await Clipboard.setData(ClipboardData(text: value.text));
  }
}
