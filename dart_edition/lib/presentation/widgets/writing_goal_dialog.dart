import 'package:monogatari_assistant/l10n/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/writing_goal_data.dart';
import '../../ui_library/forms.dart';
import '../providers/editor_coordinator_provider.dart';
import '../providers/project_state_providers.dart';
import '../providers/writing_goal_providers.dart';

String writingGoalTitle(WritingGoalKind kind) => switch (kind) {
  WritingGoalKind.daily => '每日目標',
  WritingGoalKind.chapter => '每章字數目標',
  WritingGoalKind.total => '全文字數目標',
};

Future<void> showWritingGoalDialog(
  BuildContext context,
  WidgetRef ref,
  WritingGoalKind kind, {
  bool defaultsOnly = false,
}) async {
  try {
    final defaults = await ref.read(writingGoalDefaultsProvider.future);
    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _WritingGoalDialog(
        kind: kind,
        defaults: defaults,
        defaultsOnly: defaultsOnly,
      ),
    );
  } catch (error) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          context.l10n.uiCouldNotLoadWritingGoals((error).toString()),
        ),
      ),
    );
    ref.invalidate(writingGoalDefaultsProvider);
  }
}

class _WritingGoalDialog extends ConsumerStatefulWidget {
  final WritingGoalKind kind;
  final WritingGoalDefaults defaults;
  final bool defaultsOnly;
  const _WritingGoalDialog({
    required this.kind,
    required this.defaults,
    required this.defaultsOnly,
  });
  @override
  ConsumerState<_WritingGoalDialog> createState() => _WritingGoalDialogState();
}

class _WritingGoalDialogState extends ConsumerState<_WritingGoalDialog> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _default;
  late final TextEditingController _file;
  late final String _project;
  late final int _session;
  late bool _fileScope;
  bool _saving = false;
  String? _error;
  bool get _canUseFile =>
      !widget.defaultsOnly &&
      widget.kind != WritingGoalKind.daily &&
      ref.read(currentProjectFileProvider) != null;

  @override
  void initState() {
    super.initState();
    _project = ref.read(projectUuidProvider);
    _session = ref.read(projectWritingSessionProvider);
    final goals = ref.read(projectWritingGoalsProvider);
    _fileScope = _canUseFile && goals.overrideFor(widget.kind) != null;
    _default = TextEditingController(
      text: '${widget.defaults.valueFor(widget.kind)}',
    );
    _file = TextEditingController(
      text: '${goals.effective(widget.kind, widget.defaults)}',
    );
  }

  @override
  void dispose() {
    _default.dispose();
    _file.dispose();
    super.dispose();
  }

  Future<void> _apply({bool inherit = false}) async {
    if (!inherit && !_form.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      if (_fileScope) {
        if (!_canUseFile ||
            _project != ref.read(projectUuidProvider) ||
            _session != ref.read(projectWritingSessionProvider) ||
            ref.read(editorCoordinatorProvider).isLoading) {
          throw StateError('目前作品已變更，請重新開啟設定。');
        }
        ref
            .read(projectWritingGoalsProvider.notifier)
            .setGoal(
              widget.kind,
              inherit ? null : int.parse(_file.text.trim()),
            );
        ref.read(editorCoordinatorProvider.notifier).markAsModified();
      } else {
        await ref
            .read(writingGoalDefaultsProvider.notifier)
            .setGoal(widget.kind, int.parse(_default.text.trim()));
      }
      if (mounted) Navigator.of(context).pop();
    } catch (error) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = '$error';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final override = ref
        .watch(projectWritingGoalsProvider)
        .overrideFor(widget.kind);
    return PopScope(
      canPop: !_saving,
      child: AlertDialog(
        title: Text(context.l10n.legacyLabel(writingGoalTitle(widget.kind))),
        content: SingleChildScrollView(
          child: SizedBox(
            width: 380,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!widget.defaultsOnly &&
                    widget.kind != WritingGoalKind.daily) ...[
                  SegmentedButton<bool>(
                    segments: [
                      ButtonSegment(
                        value: false,
                        label: Text(context.l10n.uiDefault),
                      ),
                      ButtonSegment(
                        value: true,
                        label: Text(context.l10n.uiThisFileOnly),
                        enabled: _canUseFile,
                      ),
                    ],
                    selected: {_fileScope},
                    onSelectionChanged: _saving
                        ? null
                        : (values) =>
                              setState(() => _fileScope = values.single),
                  ),
                  const SizedBox(height: 16),
                ],
                Text(
                  widget.kind == WritingGoalKind.daily
                      ? context.l10n.uiDailyNetWordGainAcrossAllLocalWorks
                      : _fileScope
                      ? context.l10n.uiSavedWithTheCurrentWorkAndAppliedTo
                      : context.l10n.uiApplyToWorksWithoutAFileSpecificGoal,
                ),
                if (!_fileScope && override != null)
                  Text(
                    context.l10n.uiThisFileStillUsesItsOwnGoalOf(
                      context.formats.integer(override),
                    ),
                  ),
                const SizedBox(height: 16),
                Form(
                  key: _form,
                  child: AppTextField(
                    key: ValueKey(_fileScope),
                    controller: _fileScope ? _file : _default,
                    autofocus: true,
                    labelText: context.l10n.uiWordCountGoal,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) => validateWritingGoal(value) == null
                        ? null
                        : context.l10n.writingGoalInvalid,
                    onSubmitted: (_) {
                      if (!_saving) _apply();
                    },
                  ),
                ),
                if (_error != null)
                  Text(
                    _error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
              ],
            ),
          ),
        ),
        actions: [
          if (_fileScope && override != null)
            TextButton(
              onPressed: _saving ? null : () => _apply(inherit: true),
              child: Text(context.l10n.uiRestoreDefault),
            ),
          TextButton(
            onPressed: _saving ? null : () => Navigator.of(context).pop(),
            child: Text(context.l10n.commonCancel),
          ),
          FilledButton(
            onPressed: _saving ? null : _apply,
            child: Text(_saving ? context.l10n.uiSaving : context.l10n.uiApply),
          ),
        ],
      ),
    );
  }
}

class WritingGoalSettings extends ConsumerWidget {
  const WritingGoalSettings({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(writingGoalDefaultsProvider);
    return state.when(
      loading: () => const LinearProgressIndicator(),
      error: (error, stack) => TextButton(
        onPressed: () => ref.invalidate(writingGoalDefaultsProvider),
        child: Text(context.l10n.uiCouldNotReadWritingGoalsClickToRetry),
      ),
      data: (defaults) => Column(
        children: [
          for (final kind in WritingGoalKind.values)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(context.l10n.legacyLabel(writingGoalTitle(kind))),
              subtitle: Text(
                kind == WritingGoalKind.daily
                    ? context.l10n.uiAllLocalWorksCombined
                    : context.l10n.uiDefaultFileSpecificValuesCanBeSetFrom,
              ),
              trailing: Text(
                context.l10n.uiCharacters2(
                  context.formats.integer(defaults.valueFor(kind)),
                ),
              ),
              onTap: () =>
                  showWritingGoalDialog(context, ref, kind, defaultsOnly: true),
            ),
        ],
      ),
    );
  }
}
