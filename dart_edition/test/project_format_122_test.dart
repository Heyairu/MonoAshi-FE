import 'package:flutter_test/flutter_test.dart';
import 'package:monogatari_assistant/domain/collaboration/collaboration_operation.dart';
import 'package:monogatari_assistant/domain/collaboration/collaboration_protocol.dart';
import 'package:monogatari_assistant/application/collaboration/project_record_codec.dart';
import 'package:monogatari_assistant/bin/file.dart';
import 'package:monogatari_assistant/models/character_data.dart';
import 'package:monogatari_assistant/models/project_migrator.dart';
import 'package:monogatari_assistant/models/writing_goal_data.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const roles = {
    '主角': 'protagonist',
    '重要配角': 'majorSupporting',
    '次要配角': 'minorSupporting',
    '主要反派': 'majorAntagonist',
    '次要反派': 'minorAntagonist',
    '其他': 'other',
  };

  test(
    '1.22 uses stable English role identifiers and preserves custom values',
    () {
      expect(characterTypeOptions, roles.values.toList());
      for (final entry in roles.entries) {
        expect(normalizeCharacterType(entry.key), entry.value);
        expect(normalizeCharacterType(entry.value), entry.value);
        expect(normalizeCharacterType(' ${entry.key} '), entry.value);
      }
      expect(normalizeCharacterType(null), defaultCharacterType);
      expect(normalizeCharacterType(''), defaultCharacterType);
      expect(normalizeCharacterType(' 自訂／Custom 役 '), ' 自訂／Custom 役 ');
    },
  );

  for (final version in ['1.20', '1.21', '1.22']) {
    test(
      '$version XML upgrades roles without rewriting authored text or IDs',
      () {
        final source = ProjectData.empty();
        for (final role in {...roles, ' 自訂類型 ': ' 自訂類型 '}.entries) {
          final character = CharacterEntryData.withName(
            '主角という名前',
          ).copyWith(characterType: role.value, notes: '主角、次要配角與其他都是本文，保持原文。');
          source.characterData = {
            ...source.characterData,
            character.characterId: character,
          };
        }
        var oldXml = FileService.generateProjectXMLWithoutLatestSaveUpdate(
          source,
        ).replaceFirst('<ver>1.22</ver>', '<ver>$version</ver>');
        for (final entry in roles.entries) {
          oldXml = oldXml.replaceAll(
            '<CharacterType>${entry.value}</CharacterType>',
            '<CharacterType>${entry.key}</CharacterType>',
          );
        }
        final parsed = FileService.parseProjectXMLWithMetadata(oldXml);
        expect(parsed.data.projectUUID, source.projectUUID);
        expect(parsed.data.characterData.keys, source.characterData.keys);
        expect(parsed.data.characterData.values.map((c) => c.characterType), [
          ...roles.values,
          ' 自訂類型 ',
        ]);
        for (final character in parsed.data.characterData.values) {
          expect(character.displayName, '主角という名前');
          expect(character.notes, '主角、次要配角與其他都是本文，保持原文。');
        }
        final saved = FileService.generateProjectXMLWithoutLatestSaveUpdate(
          parsed.data,
        );
        expect(saved, contains('<ver>1.22</ver>'));
        final reopened = FileService.parseProjectXMLWithMetadata(saved);
        expect(reopened.wasMigrated, isFalse);
        expect(reopened.data.characterData, parsed.data.characterData);
        expect(oldXml, contains('<CharacterType>主角</CharacterType>'));
      },
    );
  }

  test(
    'migration copies changed records and preserves all unrelated project fields',
    () {
      final character = CharacterEntryData.withName(
        'Hero',
      ).copyWith(characterType: '主角');
      final source = ProjectData.empty()
        ..characterData = {character.characterId: character}
        ..writingGoals = const ProjectWritingGoals(totalWordGoal: 12345)
        ..contentText = '主角の未保存原稿'
        ..isDirty = true
        ..revisionTrackingJson = '{"source":"主角"}'
        ..phrasesRecoveryPayload = '<Unrecognized>主角</Unrecognized>';
      final upgraded = ProjectMigrator.migrate(
        sourceVersion: '1.21',
        parsedData: source,
      );
      expect(upgraded.wasMigrated, isTrue);
      expect(source.characterData[character.characterId]!.characterType, '主角');
      expect(
        upgraded.data.characterData[character.characterId]!.characterType,
        'protagonist',
      );
      expect(upgraded.data.writingGoals, source.writingGoals);
      expect(upgraded.data.contentText, source.contentText);
      expect(upgraded.data.isDirty, source.isDirty);
      expect(upgraded.data.revisionTrackingJson, source.revisionTrackingJson);
      expect(
        upgraded.data.phrasesRecoveryPayload,
        source.phrasesRecoveryPayload,
      );
      expect(upgraded.data.segmentsData, source.segmentsData);
      expect(upgraded.data.outlineData, source.outlineData);
      expect(upgraded.data.timelineDocument, source.timelineDocument);
    },
  );

  test('legacy-map and collaboration boundaries canonicalize role values', () {
    final character = CharacterEntryData.withName(
      'Hero',
    ).copyWith(characterType: '主角');
    expect(character.toLegacyMap()['characterType'], 'protagonist');
    final source = ProjectData.empty()
      ..characterData = {character.characterId: character};
    final records = ProjectRecordCodec.snapshot(source);
    final decoded = ProjectRecordCodec.decodeCharacters(records);
    expect(decoded[character.characterId]!.characterType, 'protagonist');
    expect(decoded[character.characterId]!.displayName, 'Hero');
  });
  test('schema 8 rejects peers using the previous role-value contract', () {
    expect(CollaborationSchema.currentVersion, 8);
    expect(
      () => CollaborationSyncBatch(
        schemaVersion: 7,
        projectUuid: '11111111-1111-4111-8111-111111111111',
        senderReplicaId: 'old-peer',
      ),
      throwsFormatException,
    );
  });
}
