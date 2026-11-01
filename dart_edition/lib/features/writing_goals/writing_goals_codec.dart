import 'dart:convert';
import 'package:xml/xml.dart';
import '../../models/writing_goal_data.dart';

abstract final class WritingGoalsCodec {
  static ProjectWritingGoals decode(Iterable<XmlElement> types) {
    final goals = types
        .where((e) => e.getElement('Name')?.innerText == 'WritingGoals')
        .toList();
    final recovery = <String>[];
    for (final type in types.where(
      (e) => e.getElement('Name')?.innerText == 'WritingGoalsRecovery',
    )) {
      // Keep an unreadable envelope itself, so saving cannot silently erase it.
      try {
        recovery.add(
          utf8.decode(base64.decode(type.getElement('Data')!.innerText)),
        );
      } catch (_) {
        recovery.add(type.toXmlString());
      }
    }
    if (goals.isEmpty) {
      return ProjectWritingGoals(recoveryXml: List.unmodifiable(recovery));
    }
    try {
      if (goals.length != 1) throw const FormatException('重複目標區塊');
      final element = goals.single;
      if (element.getAttribute('Version') != '1') {
        throw const FormatException('不支援的目標版本');
      }
      if (element.childElements.any(
        (e) => !{
          'Name',
          'ChapterWordGoal',
          'TotalWordGoal',
        }.contains(e.name.local),
      )) {
        throw const FormatException('未知目標欄位');
      }
      int? read(String name) {
        final nodes = element.findElements(name).toList();
        if (nodes.isEmpty) return null;
        final value = int.tryParse(nodes.single.innerText.trim());
        if (value == null || !isValidWritingGoal(value)) {
          throw FormatException('$name 無效');
        }
        return value;
      }

      return ProjectWritingGoals(
        chapterWordGoal: read('ChapterWordGoal'),
        totalWordGoal: read('TotalWordGoal'),
        recoveryXml: List.unmodifiable(recovery),
      );
    } catch (_) {
      return ProjectWritingGoals(
        recoveryXml: List.unmodifiable([
          ...recovery,
          ...goals.map((e) => e.toXmlString()),
        ]),
      );
    }
  }

  static String encode(ProjectWritingGoals goals) {
    final builder = XmlBuilder();
    if (goals.chapterWordGoal != null || goals.totalWordGoal != null) {
      builder.element(
        'Type',
        attributes: {'Version': '1'},
        nest: () {
          builder.element('Name', nest: 'WritingGoals');
          if (goals.chapterWordGoal case final value?) {
            if (!isValidWritingGoal(value)) throw ArgumentError.value(value);
            builder.element('ChapterWordGoal', nest: value);
          }
          if (goals.totalWordGoal case final value?) {
            if (!isValidWritingGoal(value)) throw ArgumentError.value(value);
            builder.element('TotalWordGoal', nest: value);
          }
        },
      );
    }
    for (final raw in goals.recoveryXml) {
      builder.element(
        'Type',
        nest: () {
          builder.element('Name', nest: 'WritingGoalsRecovery');
          builder.element('Data', nest: base64.encode(utf8.encode(raw)));
        },
      );
    }
    return builder
        .buildFragment()
        .children
        .map((node) => node.toXmlString())
        .join('\n');
  }
}
