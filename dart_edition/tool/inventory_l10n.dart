// Inventory tooling reuses the analyzer already locked by build_runner.
// It does not add a runtime dependency or change application behavior.
// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:crypto/crypto.dart';

/// Run from dart_edition:
/// dart --packages=.dart_tool/package_config.json tool/inventory_l10n.dart
/// Rows are candidates, not approved ARB keys. Classification is heuristic.
void main(List<String> arguments) {
  if (arguments.contains('--self-test')) {
    selfTest();
    return;
  }
  selfTest();
  if (!Directory('lib').existsSync()) {
    throw StateError('Run this tool from dart_edition/.');
  }
  final rows = <Map<String, Object?>>[];
  final files = <Map<String, Object?>>[];
  for (final root in ['lib', 'packages/material_ribbon/lib']) {
    final sources =
        Directory(root)
            .listSync(recursive: true, followLinks: false)
            .whereType<File>()
            .where((f) => f.path.endsWith('.dart'))
            .where((f) => !f.path.endsWith('.g.dart'))
            .where((f) => !f.path.endsWith('.freezed.dart'))
            .toList()
          ..sort((a, b) => a.path.compareTo(b.path));
    for (final file in sources) {
      final source = file.readAsStringSync();
      final scan = scanDart(source, file.path);
      if ((scan['parseErrors'] as List).isNotEmpty) {
        throw StateError(
          'Parse errors in ${file.path}: ${scan['parseErrors']}',
        );
      }
      rows.addAll((scan['rows'] as List).cast<Map<String, Object?>>());
      files.add({
        'path': file.path,
        'sourceSha256': sha256.convert(utf8.encode(source)).toString(),
        'literals': scan['literals'],
        'candidates': (scan['rows'] as List).length,
        'excluded': scan['excluded'],
      });
    }
  }
  final assets = <Map<String, Object?>>[];
  for (final root in ['assets/help', 'assets/jsons']) {
    final sources =
        Directory(root)
            .listSync(recursive: true, followLinks: false)
            .whereType<File>()
            .where((f) => f.path.endsWith('.json'))
            .toList()
          ..sort((a, b) => a.path.compareTo(b.path));
    for (final file in sources) {
      final values = <Map<String, Object?>>[];
      void visit(Object? value, String pointer) {
        if (value is Map) {
          for (final key in value.keys) {
            final escaped = '$key'.replaceAll('~', '~0').replaceAll('/', '~1');
            visit(value[key], '$pointer/$escaped');
          }
        } else if (value is List) {
          for (var i = 0; i < value.length; i++) {
            visit(value[i], '$pointer/$i');
          }
        } else if (value is String && value.trim().isNotEmpty) {
          final technical = RegExp(
            r'/(id|relatedIds/\d+|entryIds/\d+|color|hex|version)$',
          ).hasMatch(pointer);
          values.add({
            'pointer': pointer,
            'text': value,
            'category': technical
                ? 'stable_id'
                : file.path.startsWith('assets/help/')
                ? 'help_content'
                : 'authored_content',
          });
        }
      }

      final data = jsonDecode(file.readAsStringSync());
      visit(data, '');
      assets.add({
        'path': file.path,
        'strings': values,
        if (data is Map && data['topics'] is List)
          'topics': [
            for (final topic in data['topics'] as List)
              {
                'id': topic['id'],
                'title': topic['title'],
                'category': topic['category'],
                'sections': (topic['sections'] as List).length,
              },
          ],
      });
    }
  }
  final output = Directory('../docs/i18n')..createSync(recursive: true);
  File(
    '${output.path}/copy_inventory.jsonl',
  ).writeAsStringSync('${rows.map(jsonEncode).join('\n')}\n');
  File('${output.path}/asset_inventory.json').writeAsStringSync(
    '${const JsonEncoder.withIndent('  ').convert(assets)}\n',
  );
  final categories = <String, int>{};
  final modules = <String, Map<String, int>>{};
  for (final row in rows) {
    final category = row['category'] as String;
    categories.update(category, (n) => n + 1, ifAbsent: () => 1);
    final module = modules.putIfAbsent(row['module'] as String, () => {});
    module.update(category, (n) => n + 1, ifAbsent: () => 1);
  }
  final summary = {
    'schemaVersion': 1,
    'command':
        'dart --packages=.dart_tool/package_config.json tool/inventory_l10n.dart',
    'scope': ['lib/**/*.dart', 'packages/material_ribbon/lib/**/*.dart'],
    'excludedScope': ['generated Dart', 'test', 'tool', 'Rust', 'pub cache'],
    'classification': 'heuristic; requires human review before extraction',
    'candidateOccurrences': rows.length,
    'uniqueCandidateTexts': rows.map((row) => row['text']).toSet().length,
    'categories': categories,
    'modules': modules,
    'files': files,
  };
  File('${output.path}/summary.json').writeAsStringSync(
    '${const JsonEncoder.withIndent('  ').convert(summary)}\n',
  );
  stdout.writeln(
    'Scanned ${files.length} Dart files; ${rows.length} candidates.',
  );
  stdout.writeln(jsonEncode(categories));
}

Map<String, Object?> scanDart(String source, String path) {
  final parsed = parseString(content: source, throwIfDiagnostics: false);
  final visitor = _InventoryVisitor(path, parsed.lineInfo.getLocation);
  parsed.unit.accept(visitor);
  return {
    'rows': visitor.rows,
    'literals': visitor.literals,
    'excluded': visitor.excluded,
    'parseErrors': parsed.errors.map((e) => e.toString()).toList(),
  };
}

String moduleFor(String path) {
  if (path.startsWith('packages/')) return 'ribbon_package';
  if (path.startsWith('lib/features/')) return path.split('/')[2];
  if (path.startsWith('lib/modules/')) {
    return path.split('/').last.replaceAll('.dart', '');
  }
  if (path.startsWith('lib/presentation/widgets/project_export/') ||
      path.startsWith('lib/application/project_export/')) {
    return 'project_export';
  }
  if (path.startsWith('lib/data/p2p/') || path.contains('/p2p_')) return 'p2p';
  if (path.contains('writing_goal')) return 'writing_goals';
  if (path.startsWith('lib/bin/')) return 'shell_${path.split('/').last}';
  if (path.startsWith('lib/ui_library/')) return 'ui_library';
  if (path.contains('/copilot/')) return 'copilot';
  return path.split('/').take(2).join('/');
}

class _InventoryVisitor extends RecursiveAstVisitor<void> {
  _InventoryVisitor(this.path, this.locationForOffset);
  final String path;
  final dynamic Function(int) locationForOffset;
  final rows = <Map<String, Object?>>[];
  final excluded = <String, int>{};
  int literals = 0;

  @override
  void visitSimpleStringLiteral(SimpleStringLiteral node) => record(node);

  @override
  void visitStringInterpolation(StringInterpolation node) {
    record(node);
    // Strings inside an interpolation expression can be separate UI branches.
    for (final element in node.elements.whereType<InterpolationExpression>()) {
      element.expression.accept(this);
    }
  }

  @override
  void visitAdjacentStrings(AdjacentStrings node) {
    record(node);
    for (final string in node.strings.whereType<StringInterpolation>()) {
      for (final element
          in string.elements.whereType<InterpolationExpression>()) {
        element.expression.accept(this);
      }
    }
  }

  void record(StringLiteral node) {
    literals++;
    final ancestors = <AstNode>[];
    for (var parent = node.parent; parent != null; parent = parent.parent) {
      ancestors.add(parent);
    }
    final calls = <String>[];
    String? argument;
    var directArgument = false;
    String? symbol;
    for (final ancestor in ancestors) {
      if (ancestor is NamedExpression) {
        if (argument == null) {
          argument = ancestor.name.label.name;
          directArgument = calls.isEmpty;
        }
      } else if (ancestor is InstanceCreationExpression) {
        calls.add(ancestor.constructorName.toSource());
      } else if (ancestor is MethodInvocation) {
        calls.add(ancestor.methodName.name);
      } else if (ancestor is Annotation) {
        calls.add('@${ancestor.name.toSource()}');
      }
      if (symbol == null) {
        if (ancestor is DefaultFormalParameter) {
          symbol = ancestor.parameter.name?.lexeme;
          if (argument == null) {
            argument = symbol;
            directArgument = calls.isEmpty;
          }
        }
        if (ancestor is VariableDeclaration) symbol = ancestor.name.lexeme;
        if (ancestor is MethodDeclaration) symbol = ancestor.name.lexeme;
        if (ancestor is FunctionDeclaration) symbol = ancestor.name.lexeme;
      }
    }
    final placeholders = <String>[];
    String textFor(StringLiteral literal) {
      if (literal is SimpleStringLiteral) return literal.value;
      if (literal is AdjacentStrings) {
        return literal.strings.map(textFor).join();
      }
      if (literal is StringInterpolation) {
        return literal.elements.map((element) {
          if (element is InterpolationString) return element.value;
          final expression = (element as InterpolationExpression).expression;
          final name = 'p${placeholders.length + 1}';
          placeholders.add(expression.toSource());
          return '{$name}';
        }).join();
      }
      throw StateError('Unhandled string ${literal.runtimeType}');
    }

    final text = textFor(node);
    String? skip;
    String category = 'review';
    String reason = 'natural_language_without_confirmed_display_sink';
    final hasCjk = RegExp(
      r'[\u3400-\u9fff\u3040-\u30ff\uac00-\ud7af]',
    ).hasMatch(text);
    final humanEnglish = RegExp(
      r'[A-Za-z]{2,}[ ,:;!?\n]+[A-Za-z]{2,}',
    ).hasMatch(text);
    final readable = hasCjk || humanEnglish;
    final closestCall = calls.isEmpty ? '' : calls.first;
    final isMapKey =
        node.parent is MapLiteralEntry &&
        identical((node.parent as MapLiteralEntry).key, node);
    final isIndexKey =
        node.parent is IndexExpression &&
        identical((node.parent as IndexExpression).index, node);
    final visibleArgument =
        directArgument &&
        argument != null &&
        RegExp(
          r'^(title|label|labelText|hintText|helperText|errorText|tooltip|message|'
          r'description|subtitle|semanticLabel|semanticsLabel|barrierLabel|'
          r'cancelLabel|confirmLabel|dialogTitle|buttonText|text|disabledReason|'
          r'emptyLabel|placeholder|unitLabel|suffixText|prefixText)$',
        ).hasMatch(argument);
    final visibleCall = RegExp(
      r'^(Text(\.rich)?|TextSpan|Tooltip|AppModule|RibbonLocalizations|'
      r'_buildTextField|_buildPlaceholderSetting|_note|command|'
      r'AppDialog\.(show|confirm|prompt)|AppFeedback\..*)$',
    ).hasMatch(closestCall);
    final greeting = path == 'lib/utils/welcome_greeting.dart';
    final ribbonDefault =
        path.startsWith('packages/material_ribbon/') &&
        ancestors.any((a) => a is DefaultFormalParameter) &&
        ancestors.whereType<ConstructorDeclaration>().any(
          (a) => a.returnType.name == 'RibbonLocalizations',
        );
    final copyWithoutPlaceholders = text.replaceAll(RegExp(r'\{p\d+\}'), '');
    if (text.trim().isEmpty) {
      skip = 'empty_or_whitespace';
    } else if (!RegExp(
      r'[A-Za-z\u3400-\u9fff\u3040-\u30ff\uac00-\ud7af]',
    ).hasMatch(copyWithoutPlaceholders)) {
      skip = 'symbol_or_interpolation_without_copy';
    } else if (ancestors.any((a) => a is Directive)) {
      skip = 'directive';
    } else if (RegExp(
          r'^(dart:|package:|https?://|assets/|image/|text/|application/)',
        ).hasMatch(text) &&
        !hasCjk) {
      skip = 'uri_path_or_mime';
    } else if (calls.any((call) => call == 'RegExp')) {
      skip = 'regular_expression';
    } else if (isMapKey || isIndexKey) {
      if (!readable) {
        skip = 'map_key';
      } else {
        category = 'data_contract';
        reason = 'natural_language_map_key_requires_usage_review';
      }
    } else if (argument == 'debugLabel' ||
        ancestors.any((a) => a is Assertion || a is AssertInitializer) ||
        calls.any(
          (call) => RegExp(
            r'^(print|debugPrint|Logger|log|info|warning|severe|fine|finer|finest)$',
          ).hasMatch(call),
        )) {
      if (!readable) {
        skip = 'diagnostic_identifier';
      } else {
        category = 'diagnostic';
        reason = 'log_assert_or_debug_context';
      }
    } else if (calls.any(
          (call) => RegExp(r'(Exception|Error)(\.|$)').hasMatch(call),
        ) ||
        ancestors.any((a) => a is ThrowExpression)) {
      if (!readable) {
        skip = 'error_identifier';
      } else {
        category = 'error';
        reason = 'typed_error_or_throw_requires_presentation_mapping';
      }
    } else if (path.contains('/features/mcp/') ||
        path.contains('/features/story_read/') ||
        path.contains('/features/copilot/')) {
      if (!readable && !visibleArgument && !visibleCall) {
        skip = 'machine_token';
      } else {
        category = 'external_contract';
        reason = 'tool_prompt_schema_or_ui_requires_boundary_review';
      }
    } else if (path.startsWith('lib/application/project_export/') && readable) {
      category = 'export_content';
      reason = 'exported_heading_filename_or_error_requires_review';
    } else if (path.startsWith('lib/models/') && readable) {
      category = 'data_contract';
      reason = 'model_default_option_or_validation_requires_usage_review';
    } else if ((visibleArgument || visibleCall || greeting || ribbonDefault) &&
        (readable || RegExp(r'[A-Za-z\u3400-\u9fff]').hasMatch(text))) {
      category = 'ui';
      reason = visibleArgument ? 'visible_named_argument' : 'visible_call';
    } else if (!readable) {
      skip = 'machine_token_or_short_fragment';
    }
    if (skip != null) {
      excluded.update(skip, (n) => n + 1, ifAbsent: () => 1);
      return;
    }
    final location = locationForOffset(node.offset);
    final module = moduleFor(path);
    rows.add({
      'id': '$path:${node.offset}',
      'path': path,
      'line': location.lineNumber,
      'column': location.columnNumber,
      'offset': node.offset,
      'length': node.length,
      'module': module,
      'category': category,
      'reason': reason,
      'status': 'needs_review',
      'phase': module == 'oobe' || path.endsWith('/settingview.dart')
          ? 'P1'
          : path.startsWith('lib/bin/') ||
                module == 'navigation' ||
                module == 'ribbon_package' ||
                module == 'ui_library' ||
                module == 'project_export' ||
                path == 'lib/main.dart'
          ? 'P2'
          : module == 'help'
          ? 'P4'
          : 'P3',
      'symbol': symbol,
      'argument': argument,
      'calls': calls.take(4).toList(),
      'text': text,
      'placeholders': placeholders,
      'risks': [
        if (placeholders.isNotEmpty) 'dynamic_message',
        if (text.contains('\n')) 'embedded_line_break',
        if (text.contains('{label}')) 'ribbon_pattern_token',
        if (text.contains(RegExp(r'\d'))) 'number_or_format_in_copy',
        if (ancestors.any((a) => a is DefaultFormalParameter))
          'default_parameter_needs_runtime_resolution',
        if (category == 'data_contract') 'do_not_replace_persisted_values',
        if (category == 'external_contract') 'preserve_external_contract',
      ],
    });
  }
}

void selfTest() {
  const fixture = r'''
// Text('Comment must not be included');
import 'package:flutter/material.dart';
final schema = {'中文欄位': 'value'};
final quoted = r"Raw \\ value";
void demo(int count) {
  Text('Save');
  Widget(title: read('title'));
  Widget(description: json['description']);
  Text('Total: $count');
  Text('first ' 'second');
  Text('${count == 1 ? "One item" : "Many items"}');
  debugPrint('Diagnostic message');
  throw StateError('Unable to save');
}
''';
  final scan = scanDart(fixture, 'lib/fixture.dart');
  if ((scan['parseErrors'] as List).isNotEmpty) {
    throw StateError('Invalid self-test fixture: ${scan['parseErrors']}');
  }
  final rows = (scan['rows'] as List).cast<Map<String, Object?>>();
  Map<String, Object?> find(String text) => rows.singleWhere(
    (row) => row['text'] == text,
    orElse: () => throw StateError('Missing fixture row: $text'),
  );
  if (find('Save')['category'] != 'ui' ||
      find('Diagnostic message')['category'] != 'diagnostic' ||
      find('Unable to save')['category'] != 'error' ||
      find('中文欄位')['category'] != 'data_contract' ||
      find('Total: {p1}')['placeholders'].toString() != '[count]' ||
      rows.where((row) => row['text'] == 'first second').length != 1 ||
      find('One item')['category'] != 'ui' ||
      find('Many items')['category'] != 'ui' ||
      rows.any((row) => row['text'] == 'title' && row['category'] == 'ui') ||
      rows.any(
        (row) => row['text'] == 'description' && row['category'] == 'ui',
      ) ||
      rows.any((row) => '${row['text']}'.contains('Comment must'))) {
    throw StateError('Inventory self-test failed.');
  }
  stdout.writeln('Inventory self-test passed.');
}
