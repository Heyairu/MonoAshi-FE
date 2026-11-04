/*
 * 
 * Copyright 2025-2026 Heyairu（部屋伊琉）
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * 
 ************************************************************/

import "../ui_library/mobile_editor_insets.dart";
import 'package:monogatari_assistant/l10n/app_localization.dart';
import "dart:async";
import "dart:convert";
import "dart:io";
import "../features/palettes/palette_color_picker.dart";

import "package:file_picker/file_picker.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../bin/ui_library.dart";
import "../models/palette_data.dart";
import "../presentation/providers/palette_state_provider.dart";

class PalettesView extends ConsumerStatefulWidget {
  const PalettesView({super.key});

  @override
  ConsumerState<PalettesView> createState() => _PalettesViewState();
}

class _PalettesViewState extends ConsumerState<PalettesView> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _newEntryController = TextEditingController();
  String? _newEntryError;
  TextEditingController? _entryEditorController;
  FocusNode? _entryEditorFocusNode;

  bool _isLoading = true;
  bool _hasLoaded = false;
  String? _loadError;
  String? _loadWarning;
  HSVColor _selectedColor = const HSVColor.fromAHSV(1, 0, 1, 1);
  double _radius = 0.10;
  String? _editingEntryId;
  late final PaletteStateNotifier _notifier;

  @override
  void initState() {
    super.initState();
    _notifier = ref.read(paletteStateProvider.notifier);
    _searchController.addListener(_handleSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        unawaited(_load());
      }
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_handleSearchChanged);
    _searchController.dispose();
    _newEntryController.dispose();
    if (_hasLoaded) {
      _commitActiveEditor(updateUi: false, showFeedback: false);
    }
    _disposeEntryEditor();
    if (_hasLoaded) {
      unawaited(_notifier.flushPalettePersistence().catchError((Object _) {}));
    }
    super.dispose();
  }

  void _handleSearchChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _hasLoaded = false;
      _loadError = null;
      _loadWarning = null;
    });
    try {
      final PaletteLoadResult result = await _notifier.loadFromRepository();
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
        _hasLoaded = true;
        _loadWarning = result.warnings.isEmpty
            ? null
            : context.l10n.uiSkippedOrRepairedPaletteDataIssues(
                context.formats.integer(result.warnings.length),
              );
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
        _hasLoaded = false;
        _loadError = context.l10n.uiCouldNotReadPaletteData((error).toString());
      });
    }
  }

  void _disposeEntryEditor() {
    _entryEditorController?.dispose();
    _entryEditorFocusNode?.dispose();
    _entryEditorController = null;
    _entryEditorFocusNode = null;
  }

  void _finishEntryEditor() {
    final TextEditingController? controller = _entryEditorController;
    final FocusNode? focusNode = _entryEditorFocusNode;
    setState(() {
      _editingEntryId = null;
      _entryEditorController = null;
      _entryEditorFocusNode = null;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller?.dispose();
      focusNode?.dispose();
    });
  }

  bool _prepareForAnotherEditor() {
    if (_editingEntryId == null) {
      return true;
    }
    return _commitActiveEditor();
  }

  void _addSelectedEntry() {
    final result = _notifier.addEntry(
      slotId: paletteExactColorId(_selectedColor.toColor()),
      text: _newEntryController.text,
    );
    if (!result.changed) {
      setState(() => _newEntryError = result.error);
      return;
    }
    _newEntryController.clear();
    setState(() => _newEntryError = null);
  }

  void _beginEdit(PaletteEntry entry) {
    if (!_prepareForAnotherEditor()) {
      return;
    }
    _disposeEntryEditor();
    setState(() {
      _editingEntryId = entry.id;
      _entryEditorController = TextEditingController(text: entry.text)
        ..selection = TextSelection.collapsed(offset: entry.text.length);
      _entryEditorFocusNode = FocusNode();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _entryEditorFocusNode?.requestFocus();
    });
  }

  bool _commitActiveEditor({bool updateUi = true, bool showFeedback = true}) {
    final TextEditingController? controller = _entryEditorController;
    if (controller == null) {
      return true;
    }

    if (_editingEntryId == null) return true;
    final result = _notifier.renameEntry(
      entryId: _editingEntryId!,
      text: controller.text,
    );

    if (!result.changed) {
      if (showFeedback && mounted) {
        AppFeedback.warning(context, result.error ?? "無法儲存詞條");
      }
      return false;
    }

    if (updateUi && mounted) {
      _finishEntryEditor();
    }
    return true;
  }

  void _cancelActiveEditor() {
    _finishEntryEditor();
  }

  void _removeEntry(PaletteEntry entry) {
    if (_editingEntryId == entry.id) {
      _cancelActiveEditor();
    }
    final PaletteEntryRemovalRecord? record = _notifier.removeEntry(entry.id);
    if (record == null) {
      return;
    }
    AppFeedback.show(
      context,
      message: context.l10n.uiDeleted((entry.text).toString()),
      tone: AppFeedbackTone.warning,
      actionLabel: context.l10n.editorUndo,
      onAction: () {
        _notifier.restoreEntry(record);
      },
    );
  }

  Future<void> _exportPalette() async {
    if (!_commitActiveEditor()) {
      return;
    }
    final String? savedPath = await FilePicker.platform.saveFile(
      dialogTitle: context.l10n.uiExportTextPalette,
      fileName: "Palettes.yaml",
      type: FileType.custom,
      allowedExtensions: const <String>["yaml", "yml"],
    );
    if (!mounted || savedPath == null) {
      return;
    }

    final String resolvedPath =
        savedPath.toLowerCase().endsWith(".yaml") ||
            savedPath.toLowerCase().endsWith(".yml")
        ? savedPath
        : "$savedPath.yaml";
    try {
      final String content = PaletteYamlCodec.encode(
        ref.read(paletteStateProvider),
      );
      await File(resolvedPath).writeAsString(content, flush: true);
      if (!mounted) {
        return;
      }
      final String fileName = resolvedPath
          .replaceAll("\\", "/")
          .split("/")
          .last;
      AppFeedback.success(
        context,
        context.l10n.uiPaletteExported((fileName).toString()),
        duration: const Duration(seconds: 2),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      AppFeedback.error(
        context,
        context.l10n.uiPaletteExportFailed((error).toString()),
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<void> _importPalette() async {
    if (!_commitActiveEditor()) {
      return;
    }
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      dialogTitle: context.l10n.uiImportTextPalette,
      type: FileType.custom,
      allowedExtensions: const <String>["yaml", "yml"],
      withData: true,
    );
    if (result == null || result.files.isEmpty) {
      return;
    }

    try {
      final PlatformFile picked = result.files.first;
      String? raw;
      if (picked.bytes != null) {
        raw = utf8.decode(picked.bytes!);
      } else if (picked.path != null) {
        raw = await File(picked.path!).readAsString();
      }
      if (raw == null || raw.trim().isEmpty) {
        throw const FormatException("檔案沒有內容");
      }

      final PaletteDecodeResult decoded = PaletteYamlCodec.decode(raw);
      final PaletteImportMergeResult merged = _notifier.mergeImportedData(
        decoded.data,
      );
      if (merged.changed) {
        await _notifier.flushPalettePersistence();
      }
      if (!mounted) {
        return;
      }

      final String warningText = decoded.warnings.isEmpty
          ? ""
          : context.l10n.uiWithFormatIssuesSkipped(
              context.formats.integer(decoded.warnings.length),
            );
      if (merged.changed) {
        AppFeedback.success(
          context,
          context.l10n.uiImportedPaletteEntriesSkippedDuplicates(
            (merged.addedPlacements).toString(),
            (merged.skippedDuplicates).toString(),
            (warningText).toString(),
          ),
          duration: const Duration(seconds: 3),
        );
      } else {
        AppFeedback.info(
          context,
          "沒有新增色票；已略過 ${merged.skippedDuplicates} 個重複詞條$warningText",
          duration: const Duration(seconds: 2),
        );
      }
    } catch (_) {
      if (!mounted) {
        return;
      }
      AppFeedback.error(
        context,
        context.l10n.uiPaletteImportFailedInvalidFormatOrUnreadableFile,
        duration: const Duration(seconds: 2),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final PaletteStateData state = ref.watch(paletteStateProvider);
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_loadError != null) {
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: AppNoticeBanner(
              title: context.l10n.uiCouldNotLoadPalettes,
              message: _loadError!,
              tone: AppFeedbackTone.error,
              action: FilledButton.tonal(
                onPressed: _load,
                child: Text(context.l10n.commonRetry),
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.space20,
        AppSpacing.space20,
        AppSpacing.space20,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildHeader(context),
          if (_loadWarning != null) ...<Widget>[
            const SizedBox(height: 12),
            AppNoticeBanner(
              message: _loadWarning!,
              tone: AppFeedbackTone.warning,
              compact: true,
              onDismiss: () => setState(() => _loadWarning = null),
            ),
          ],
          if (state.persistenceError != null) ...<Widget>[
            const SizedBox(height: 12),
            AppNoticeBanner(
              title: context.l10n.uiNotSavedToDiskYet,
              message: state.persistenceError!,
              tone: AppFeedbackTone.error,
              compact: true,
              action: TextButton(
                onPressed: () async {
                  try {
                    await _notifier.flushPalettePersistence();
                  } catch (_) {}
                },
                child: Text(context.l10n.commonRetry),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Expanded(child: _buildPaletteContent(state)),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final menuIconColor = Theme.of(context).colorScheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        LargeTitle(
          icon: Icons.palette_outlined,
          text: context.l10n.uiTextPalettes,
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: AppTextField(
                key: const ValueKey<String>("palette-search-field"),
                controller: _searchController,
                hintText: context.l10n.uiSearchEntries,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: context.l10n.uiClearSearch,
                        onPressed: _searchController.clear,
                        icon: const Icon(Icons.clear),
                      ),
              ),
            ),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              key: const ValueKey<String>("palette-import-export-menu"),
              tooltip: context.l10n.uiImportOrExportPalettes,
              iconColor: menuIconColor,
              onSelected: (String value) {
                switch (value) {
                  case "import":
                    unawaited(_importPalette());
                    break;
                  case "export":
                    unawaited(_exportPalette());
                    break;
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: "import",
                  child: ListTile(
                    leading: Icon(Icons.file_open_outlined),
                    title: Text(context.l10n.uiImportPalette),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                PopupMenuItem<String>(
                  value: "export",
                  child: ListTile(
                    leading: Icon(Icons.save_alt_outlined),
                    title: Text(context.l10n.uiExportPalette),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
              icon: Icon(Icons.import_export_outlined, color: menuIconColor),
            ),
          ],
        ),
      ],
    );
  }

  void _changeColor(HSVColor color) {
    setState(() => _selectedColor = color);
  }

  Widget _buildPaletteContent(PaletteStateData state) {
    final color = _selectedColor.toColor();
    final slotId = paletteExactColorId(color);
    final matches = paletteColorMatches(
      state,
      color,
      query: _searchController.text,
    );
    final inRange = matches
        .where((hit) => hit.distance <= _radius + 1e-9)
        .toList();
    final fallback = inRange.isEmpty
        ? matches.take(5).toList()
        : <PaletteColorMatch>[];
    final picker = Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PaletteColorPicker(value: _selectedColor, onChanged: _changeColor),
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    key: ValueKey('palette-hex-$slotId'),
                    initialValue: '#${slotId.substring(4)}',
                    decoration: const InputDecoration(labelText: 'HEX'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (text) =>
                        RegExp(
                          r'^#?[0-9a-fA-F]{6}$',
                        ).hasMatch(text?.trim() ?? '')
                        ? null
                        : context.l10n.paletteInvalidHex,
                    onFieldSubmitted: (text) {
                      final hex = text.trim().replaceFirst('#', '');
                      if (!RegExp(r'^[0-9a-fA-F]{6}$').hasMatch(hex)) return;
                      final hsv = HSVColor.fromColor(
                        Color(0xff000000 | int.parse(hex, radix: 16)),
                      );
                      _changeColor(
                        hsv.saturation == 0 || hsv.value == 0
                            ? hsv.withHue(_selectedColor.hue)
                            : hsv,
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AppTextField(
                    key: const ValueKey('palette-new-entry'),
                    controller: _newEntryController,
                    hintText: context.l10n.uiEnterATerm,
                    maxLength: paletteTermMaxLength,
                    decoration: InputDecoration(
                      counterText: '',
                      errorText: _newEntryError,
                    ),
                    onChanged: (_) {
                      if (_newEntryError != null) {
                        setState(() => _newEntryError = null);
                      }
                    },
                    onSubmitted: (_) => _addSelectedEntry(),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  key: const ValueKey('palette-add-selected'),
                  onPressed: _addSelectedEntry,
                  child: Text(context.l10n.commonAdd),
                ),
              ],
            ),
            if (_editingEntryId != null) ...[
              const SizedBox(height: 12),
              _buildInlineEditor(key: 'edit-$_editingEntryId'),
            ],
          ],
        ),
      ),
    );
    final results = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.l10n.paletteSearchRange,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final option in [
              (0.05, context.l10n.paletteRangePrecise),
              (0.10, context.l10n.paletteRangeDefault),
              (0.20, context.l10n.paletteRangeBroad),
            ])
              ChoiceChip(
                key: ValueKey('palette-radius-${option.$1}'),
                label: Text(option.$2),
                selected: _radius == option.$1,
                onSelected: (_) => setState(() => _radius = option.$1),
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (inRange.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(context.l10n.paletteNoNearbyEntries),
          ),
        for (final hit in inRange) _buildMatch(hit),
        if (fallback.isNotEmpty) ...[
          const Divider(),
          Text(
            context.l10n.paletteOutsideRange,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          for (final hit in fallback) _buildMatch(hit),
        ],
      ],
    );
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: 24 + MobileModuleInsets.bottomOf(context),
        ),
        child: constraints.maxWidth >= 820
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 400, child: picker),
                  const SizedBox(width: 24),
                  Expanded(child: results),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [picker, const SizedBox(height: 16), results],
              ),
      ),
    );
  }

  Widget _buildMatch(PaletteColorMatch hit) => Card(
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: hit.slot.color,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(hit.entry.text, softWrap: true)),
              IconButton(
                tooltip: context.l10n.uiEdit2(hit.entry.text),
                onPressed: () => _beginEdit(hit.entry),
                icon: const Icon(Icons.edit_outlined),
              ),
              IconButton(
                tooltip: context.l10n.commonDelete,
                onPressed: () => _removeEntry(hit.entry),
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),
          Text(
            '#${paletteExactColorId(hit.slot.color).substring(4)}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    ),
  );

  Widget _buildInlineEditor({required String key}) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 180, maxWidth: 250),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            child: AppTextField(
              key: ValueKey<String>("palette-editor-$key"),
              controller: _entryEditorController,
              focusNode: _entryEditorFocusNode,
              maxLength: paletteTermMaxLength,
              hintText: context.l10n.uiEnterATerm,
              decoration: const InputDecoration(counterText: ""),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _commitActiveEditor(),
            ),
          ),
          IconButton(
            tooltip: context.l10n.commonSave,
            visualDensity: VisualDensity.compact,
            onPressed: _commitActiveEditor,
            icon: const Icon(Icons.check),
          ),
          IconButton(
            tooltip: context.l10n.commonCancel,
            visualDensity: VisualDensity.compact,
            onPressed: _cancelActiveEditor,
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}
