/************************************************************
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

import 'package:monogatari_assistant/l10n/app_localization.dart';
import "dart:async";
import "dart:convert";
import "dart:math";

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter/services.dart";
import "package:url_launcher/url_launcher.dart";
import "../bin/ui_library.dart";
import "../bin/settings_manager.dart";
import "../data/p2p/p2p_secure_channel.dart";
import "../data/p2p/p2p_snapshot_quarantine.dart";
import "../domain/models/p2p_sync_models.dart";
import "../domain/models/p2p_pairing_models.dart";
import "../domain/models/p2p_revision_models.dart";
import "../domain/models/p2p_snapshot_models.dart";
import "../presentation/providers/global_state_providers.dart";
import "../presentation/providers/p2p_sync_providers.dart";
import "../presentation/widgets/welcome_greeting.dart";

class WelcomeView extends ConsumerStatefulWidget {
  const WelcomeView({
    super.key,
    this.onNewProject,
    this.onOpenProject,
    this.recentProjects,
    this.onOpenRecentProject,
    this.onDeleteRecentProject,
    this.localP2pProject,
    this.onSaveProject,
    this.onSaveProjectAs,
    this.onChooseSyncProject,
    this.onApplyVerifiedP2pSnapshot,
    this.onCompareVerifiedP2pSnapshot,
    this.onResolveConcurrentP2pSnapshot,
  });

  final Future<void> Function()? onNewProject;
  final Future<void> Function()? onOpenProject;
  final List<RecentProjectEntry>? recentProjects;
  final Future<void> Function(RecentProjectEntry entry)? onOpenRecentProject;
  final Future<void> Function(RecentProjectEntry entry)? onDeleteRecentProject;
  final P2pProjectStatus? localP2pProject;
  final Future<void> Function()? onSaveProject;
  final Future<void> Function()? onSaveProjectAs;
  final Future<void> Function()? onChooseSyncProject;
  final Future<bool> Function(P2pVerifiedSnapshot snapshot)?
  onApplyVerifiedP2pSnapshot;
  final Future<bool> Function(P2pVerifiedSnapshot snapshot)?
  onCompareVerifiedP2pSnapshot;
  final Future<bool> Function(P2pVerifiedSnapshot snapshot)?
  onResolveConcurrentP2pSnapshot;

  @override
  ConsumerState<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends ConsumerState<WelcomeView> {
  static const String _didYouKnowAssetPath = "assets/jsons/didyouknow.json";
  static const String _eastAsiaNameAssetPath =
      "assets/jsons/name_eastAsia.json";
  static const _DidYouKnowData _fallbackDidYouKnowData = _DidYouKnowData(
    content: "中國最偉大、最永久的藝術，就是男人扮女人",
    source: "—— 魯迅（1881-1936）",
  );
  static final Uri _projectRepoUri = Uri.parse(
    "https://github.com/heyairu/Monogatari-Assistant-FE",
  );
  static final Uri _KadoURL = Uri.parse(
    "https://www.kadokado.com.tw/user/167702",
  );
  static final Uri _KoFiURL = Uri.parse("https://ko-fi.com/heyairu");
  static final Uri _GFormsURL = Uri.parse(
    "https://forms.gle/ETkWCe7VUd6yF6Mo8",
  );
  static final Uri _GitHubIssueURL = Uri.parse(
    "https://github.com/heyairu/Monogatari-Assistant-FE/issues",
  );

  static final Random _random = Random();

  late Future<_DidYouKnowData> _didYouKnowFuture;
  Map<String, dynamic>? _eastAsiaNameData;
  bool _isGeneratingNames = false;
  String _selectedLanguage = "JP";
  String _selectedGender = "female";
  int _generateCount = 5;
  List<String> _generatedNames = const [];
  final TextEditingController _localPortController = TextEditingController(
    text: "$defaultP2pPort",
  );
  final TextEditingController _peerIpController = TextEditingController();
  final TextEditingController _peerPortController = TextEditingController(
    text: "$defaultP2pPort",
  );
  String? _localPortError;
  String? _peerIpError;
  String? _peerPortError;
  int _lastHandledNegotiationGeneration = 0;
  int _lastHandledSnapshotSyncRequestGeneration = 0;
  Future<void>? _immediateP2pSyncOperation;
  bool _negotiationDialogVisible = false;
  BuildContext? _negotiationDialogContext;

  @override
  void initState() {
    super.initState();
    _didYouKnowFuture = _loadDidYouKnowData();
    _scheduleLocalProjectOfferUpdate();
  }

  @override
  void didUpdateWidget(covariant WelcomeView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _scheduleLocalProjectOfferUpdate();
  }

  @override
  void dispose() {
    _localPortController.dispose();
    _peerIpController.dispose();
    _peerPortController.dispose();
    super.dispose();
  }

  void _reloadDidYouKnow() {
    setState(() {
      _didYouKnowFuture = _loadDidYouKnowData();
    });
  }

  void _scheduleLocalProjectOfferUpdate() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref
          .read(p2pSyncProvider.notifier)
          .updateLocalProjectStatus(widget.localP2pProject);
    });
  }

  Future<_DidYouKnowData> _loadDidYouKnowData() async {
    try {
      final String rawJson = await rootBundle.loadString(_didYouKnowAssetPath);
      if (rawJson.trim().isEmpty) {
        return _fallbackDidYouKnowData;
      }

      final dynamic decoded = jsonDecode(rawJson);
      final List<_DidYouKnowData> candidates = [];

      void collectFromList(List<dynamic> list) {
        for (final dynamic item in list) {
          if (item is Map<String, dynamic>) {
            final _DidYouKnowData? parsed = _parseDidYouKnowMap(item);
            if (parsed != null) {
              candidates.add(parsed);
            }
          }
        }
      }

      if (decoded is Map<String, dynamic>) {
        final _DidYouKnowData? fromDirectMap = _parseDidYouKnowMap(decoded);
        if (fromDirectMap != null) {
          candidates.add(fromDirectMap);
        }

        final dynamic items = decoded["items"];
        if (items is List) {
          collectFromList(items);
        }
      }

      if (decoded is List) {
        collectFromList(decoded);
      }

      if (candidates.isNotEmpty) {
        final int randomIndex = _random.nextInt(candidates.length);
        return candidates[randomIndex];
      }
    } catch (error) {
      debugPrint("Failed to load Did You Know JSON: $error");
    }

    return _fallbackDidYouKnowData;
  }

  _DidYouKnowData? _parseDidYouKnowMap(Map<String, dynamic> map) {
    final dynamic content = map["content"];
    final dynamic source = map["source"];
    if (content is String &&
        content.trim().isNotEmpty &&
        source is String &&
        source.trim().isNotEmpty) {
      return _DidYouKnowData(content: content, source: source);
    }
    return null;
  }

  Future<void> _ensureEastAsiaNameDataLoaded() async {
    if (_eastAsiaNameData != null) {
      return;
    }

    final String rawJson = await rootBundle.loadString(_eastAsiaNameAssetPath);
    final dynamic decoded = jsonDecode(rawJson);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException("Invalid East Asia name JSON format");
    }
    _eastAsiaNameData = decoded;
  }

  List<String> _extractSurnamePool(String languageCode) {
    if (_eastAsiaNameData == null) {
      return const [];
    }

    if (languageCode == "ZH" || languageCode == "KR") {
      final String key = languageCode == "ZH" ? "Surname_ZH" : "Surname_KR";
      final dynamic raw = _eastAsiaNameData![key];
      if (raw is List) {
        return raw.whereType<String>().where((s) => s.isNotEmpty).toList();
      }
      return const [];
    }

    if (languageCode == "JP") {
      final dynamic raw = _eastAsiaNameData!["Surname_JP"];
      if (raw is! List || raw.isEmpty || raw.first is! Map<String, dynamic>) {
        return const [];
      }

      final Map<String, dynamic> grouped = raw.first as Map<String, dynamic>;
      final List<String> flattened = [];
      for (final dynamic value in grouped.values) {
        if (value is List) {
          flattened.addAll(
            value.whereType<String>().where((s) => s.isNotEmpty).toList(),
          );
        }
      }
      return flattened;
    }

    return const [];
  }

  List<String> _extractGivenNamePool(String languageCode, String genderCode) {
    if (_eastAsiaNameData == null) {
      return const [];
    }

    List<String> collectPoolByRootKey(String rootKey) {
      final dynamic raw = _eastAsiaNameData![rootKey];
      if (raw is! List || raw.isEmpty || raw.first is! Map<String, dynamic>) {
        return const [];
      }

      final Map<String, dynamic> grouped = raw.first as Map<String, dynamic>;
      final List<String> pool = [];

      for (final dynamic value in grouped.values) {
        if (value is! List ||
            value.isEmpty ||
            value.first is! Map<String, dynamic>) {
          continue;
        }

        final Map<String, dynamic> namesByLanguage =
            value.first as Map<String, dynamic>;
        for (final MapEntry<String, dynamic> entry in namesByLanguage.entries) {
          final dynamic languages = entry.value;
          if (languages is List &&
              languages.whereType<String>().contains(languageCode)) {
            pool.add(entry.key);
          }
        }
      }

      return pool;
    }

    if (genderCode == "male") {
      return collectPoolByRootKey("Name_Man");
    }

    if (genderCode == "all" || genderCode == "neutral") {
      return <String>{
        ...collectPoolByRootKey("Name_Lady"),
        ...collectPoolByRootKey("Name_Man"),
      }.toList();
    }

    return collectPoolByRootKey("Name_Lady");
  }

  Future<void> _generateNames() async {
    setState(() {
      _isGeneratingNames = true;
    });

    try {
      await _ensureEastAsiaNameDataLoaded();

      final List<String> surnamePool = _extractSurnamePool(_selectedLanguage);
      final List<String> givenNamePool = _extractGivenNamePool(
        _selectedLanguage,
        _selectedGender,
      );
      if (surnamePool.isEmpty || givenNamePool.isEmpty) {
        throw const FormatException("Name data pool is empty");
      }

      final List<String> results = List<String>.generate(_generateCount, (_) {
        final String surname = surnamePool[_random.nextInt(surnamePool.length)];
        final String given =
            givenNamePool[_random.nextInt(givenNamePool.length)];
        return "$surname$given";
      });

      if (!mounted) {
        return;
      }

      setState(() {
        _generatedNames = results;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      AppFeedback.error(
        context,
        context.l10n.uiCouldNotLoadTheNameDataTryAgain,
      );
    } finally {
      if (!mounted) {
        return;
      }
      setState(() {
        _isGeneratingNames = false;
      });
    }
  }

  Future<void> _copyGeneratedNames() async {
    if (_generatedNames.isEmpty) {
      return;
    }

    await Clipboard.setData(ClipboardData(text: _generatedNames.join("\n")));
    if (!mounted) {
      return;
    }
    AppFeedback.success(context, context.l10n.uiNameResultsCopied);
  }

  Future<void> _handleNewProject() async {
    final onNewProject = widget.onNewProject;
    if (onNewProject == null) {
      _showMessage(context.l10n.uiCreatingAProjectIsNotConnectedYet);
      return;
    }

    await onNewProject();
  }

  Future<void> _handleOpenProject() async {
    final onOpenProject = widget.onOpenProject;
    if (onOpenProject == null) {
      _showMessage(context.l10n.uiOpeningFilesIsNotConnectedYet);
      return;
    }

    await onOpenProject();
  }

  Future<void> _handleOpenRecentProject(RecentProjectEntry entry) async {
    final onOpenRecentProject = widget.onOpenRecentProject;
    if (onOpenRecentProject == null) {
      _showMessage(context.l10n.uiRecentProjectsAreNotConnectedYet);
      return;
    }

    await onOpenRecentProject(entry);
  }

  Future<void> _handleDeleteRecentProject(RecentProjectEntry entry) async {
    final onDeleteRecentProject = widget.onDeleteRecentProject;
    if (onDeleteRecentProject == null) {
      _showMessage(context.l10n.uiRemovingRecentProjectsIsNotConnectedYet);
      return;
    }

    await onDeleteRecentProject(entry);
  }

  Future<void> _handleToggleP2pService() async {
    final notifier = ref.read(p2pSyncProvider.notifier);
    final state = ref.read(p2pSyncProvider);
    if (state.isListening) {
      await notifier.stopService();
      return;
    }

    final port = P2pEndpoint.parsePort(_localPortController.text);
    setState(() {
      _localPortError = port == null
          ? context.l10n.uiPortMustBeAnIntegerFromTo
          : null;
    });
    if (port == null) return;
    notifier.updateLocalProjectStatus(widget.localP2pProject);
    await notifier.startService(port);
  }

  Future<void> _handleP2pConnect() async {
    final host = _peerIpController.text.trim();
    final port = P2pEndpoint.parsePort(_peerPortController.text);
    final endpoint = P2pEndpoint.tryParse(
      host: host,
      port: _peerPortController.text,
    );
    setState(() {
      _peerIpError = P2pEndpoint.isPrivateIpv4(host)
          ? null
          : context.l10n.uiEnterAValidLocalNetworkIPv4Address;
      _peerPortError = port == null
          ? context.l10n.uiPortMustBeAnIntegerFromTo
          : null;
    });
    if (endpoint == null) return;

    await ref
        .read(p2pSyncProvider.notifier)
        .connectAndNegotiate(endpoint, widget.localP2pProject);
  }

  Future<void> _showP2pNegotiationDialog(P2pSyncState state) async {
    if (_negotiationDialogVisible || !mounted) return;
    final negotiation = state.projectNegotiation;
    final remote = state.remoteProjectOffer;
    if (negotiation == null || remote == null || !negotiation.requiresDialog) {
      return;
    }

    _negotiationDialogVisible = true;
    try {
      final local = state.localProjectOffer;
      final bothMissing =
          negotiation.selectionReason == P2pProjectSelectionReason.bothMissing;
      final action = await showDialog<_P2pSelectionAction>(
        context: context,
        builder: (dialogContext) {
          _negotiationDialogContext = dialogContext;
          return AlertDialog(
            title: Text(
              bothMissing
                  ? dialogContext.l10n.uiNeitherDeviceHasASyncProject
                  : dialogContext.l10n.uiDifferentSyncProjects,
            ),
            content: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bothMissing
                        ? dialogContext
                              .l10n
                              .uiNeitherDeviceHasTheTargetProjectInMemory
                        : dialogContext
                              .l10n
                              .uiTheDevicesHaveDifferentProjectUUIDsChooseWhich,
                  ),
                  if (!bothMissing) ...[
                    const SizedBox(height: 16),
                    _buildP2pOfferPreview(
                      dialogContext.l10n.uiThisDevice,
                      local,
                    ),
                    const SizedBox(height: 8),
                    _buildP2pOfferPreview(dialogContext.l10n.uiPeer, remote),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(dialogContext.l10n.commonCancel),
              ),
              if (bothMissing)
                FilledButton(
                  onPressed: () => Navigator.of(
                    dialogContext,
                  ).pop(_P2pSelectionAction.prepareLocal),
                  child: Text(dialogContext.l10n.uiCreateLocalProject),
                )
              else ...[
                if (widget.onChooseSyncProject != null ||
                    widget.onOpenProject != null)
                  TextButton(
                    onPressed: () => Navigator.of(
                      dialogContext,
                    ).pop(_P2pSelectionAction.chooseOther),
                    child: Text(dialogContext.l10n.uiOpenAnotherFile),
                  ),
                OutlinedButton(
                  onPressed: () => Navigator.of(
                    dialogContext,
                  ).pop(_P2pSelectionAction.remote),
                  child: Text(dialogContext.l10n.uiUsePeerSFile),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(
                    dialogContext,
                  ).pop(_P2pSelectionAction.local),
                  child: Text(dialogContext.l10n.uiUseLocalFile),
                ),
              ],
            ],
          );
        },
      );
      if (!mounted || action == null) return;
      switch (action) {
        case _P2pSelectionAction.local:
          ref
              .read(p2pSyncProvider.notifier)
              .selectProjectSource(P2pProjectSource.local);
          break;
        case _P2pSelectionAction.remote:
          ref
              .read(p2pSyncProvider.notifier)
              .selectProjectSource(P2pProjectSource.remote);
          break;
        case _P2pSelectionAction.prepareLocal:
          await _handlePrepareP2pProject();
          break;
        case _P2pSelectionAction.chooseOther:
          final callback = widget.onChooseSyncProject ?? widget.onOpenProject;
          await callback?.call();
          break;
      }
    } finally {
      _negotiationDialogContext = null;
      _negotiationDialogVisible = false;
    }
  }

  void _dismissP2pNegotiationDialog() {
    final dialogContext = _negotiationDialogContext;
    if (!_negotiationDialogVisible ||
        dialogContext == null ||
        !dialogContext.mounted) {
      return;
    }
    final navigator = Navigator.of(dialogContext);
    if (navigator.canPop()) navigator.pop();
  }

  Widget _buildP2pOfferPreview(String label, P2pProjectOffer offer) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: AppSurfaceShape.borderRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 4),
          Text(offer.fileName ?? context.l10n.uiNoProjectToSync),
          Text(
            "UUID：${offer.shortUuid}",
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Future<void> _handlePrepareP2pProject() async {
    final localPreflight = P2pProjectPreflight.evaluate(
      local: widget.localP2pProject,
      requireRemote: false,
    );
    if (localPreflight.canCollaborate) {
      if (!localPreflight.canSync) {
        _showMessage(context.l10n.uiTheInMemoryProjectIsReadyForLive);
        return;
      }
      final onChooseSyncProject = widget.onChooseSyncProject;
      if (onChooseSyncProject != null) {
        await onChooseSyncProject();
      } else {
        _showMessage(context.l10n.uiTheProjectIsSavedWithAValidUUID);
      }
      return;
    }
    await _showP2pProjectPreparationDialog(localPreflight);
  }

  Future<void> _showP2pProjectPreparationDialog(
    P2pProjectPreflightResult preflight,
  ) async {
    final issues = _describeP2pPreflightIssues(preflight);
    final action = await showDialog<_P2pPreparationAction>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(dialogContext.l10n.uiPrepareProjectForSync),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dialogContext
                      .l10n
                      .uiLiveCollaborationRequiresAValidProjectUUIDIn,
                ),
                const SizedBox(height: 12),
                ...issues.map(
                  (issue) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.warning_amber_outlined, size: 18),
                        const SizedBox(width: 8),
                        Expanded(child: Text(issue)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(dialogContext.l10n.commonCancel),
            ),
            if (preflight.issues.contains(
                  P2pProjectPreflightIssue.noLocalProject,
                ) &&
                widget.onNewProject != null)
              FilledButton(
                onPressed: () => Navigator.of(
                  dialogContext,
                ).pop(_P2pPreparationAction.createNew),
                child: Text(dialogContext.l10n.uiCreateInMemoryProject),
              ),
            if (widget.onChooseSyncProject != null ||
                widget.onOpenProject != null)
              TextButton(
                onPressed: () => Navigator.of(
                  dialogContext,
                ).pop(_P2pPreparationAction.chooseProject),
                child: Text(dialogContext.l10n.uiOpenSavedFile),
              ),
            if (widget.onSaveProjectAs != null)
              TextButton(
                onPressed: () => Navigator.of(
                  dialogContext,
                ).pop(_P2pPreparationAction.saveAs),
                child: Text(dialogContext.l10n.uiSaveAsNewWork),
              ),
            if (widget.onSaveProject != null)
              FilledButton(
                onPressed: () =>
                    Navigator.of(dialogContext).pop(_P2pPreparationAction.save),
                child: Text(dialogContext.l10n.commonSave),
              ),
          ],
        );
      },
    );
    if (!mounted || action == null) return;
    switch (action) {
      case _P2pPreparationAction.save:
        await widget.onSaveProject?.call();
        break;
      case _P2pPreparationAction.saveAs:
        await widget.onSaveProjectAs?.call();
        break;
      case _P2pPreparationAction.chooseProject:
        final callback = widget.onChooseSyncProject ?? widget.onOpenProject;
        await callback?.call();
        break;
      case _P2pPreparationAction.createNew:
        await widget.onNewProject?.call();
        break;
    }
  }

  List<String> _describeP2pPreflightIssues(
    P2pProjectPreflightResult preflight,
  ) {
    final messages = <String>[];
    final issues = preflight.issues;
    if (issues.contains(P2pProjectPreflightIssue.noLocalProject)) {
      messages.add(context.l10n.uiNoProjectIsOpen);
    }
    if (issues.contains(P2pProjectPreflightIssue.localProjectNotPersisted)) {
      messages.add(context.l10n.uiTheCurrentProjectHasNotBeenSavedTo);
    }
    if (issues.contains(P2pProjectPreflightIssue.localProjectDirty)) {
      messages.add(context.l10n.uiTheCurrentProjectHasUnsavedChanges);
    }
    if (issues.contains(P2pProjectPreflightIssue.localProjectUuidInvalid)) {
      messages.add(context.l10n.uiTheCurrentProjectHasNoValidProjectUUID);
    }
    if (issues.contains(
      P2pProjectPreflightIssue.localProjectFormatUnsupported,
    )) {
      messages.add(context.l10n.uiThisProjectFormatDoesNotSupportP2PSync);
    }
    if (issues.contains(P2pProjectPreflightIssue.localProjectHasConflict)) {
      messages.add(context.l10n.uiTheCurrentProjectHasUnresolvedSyncConflicts);
    }
    return messages;
  }

  String _p2pServiceStatusText(P2pSyncState state) {
    return switch (state.serviceStatus) {
      P2pServiceStatus.stopped => context.l10n.uiServiceOff,
      P2pServiceStatus.starting => context.l10n.uiStartingService,
      P2pServiceStatus.listening => context.l10n.uiServiceRunning,
      P2pServiceStatus.stopping => context.l10n.uiStoppingService,
      P2pServiceStatus.error => context.l10n.uiServiceError,
    };
  }

  bool _isReceivingRemoteProject(P2pSyncState state) {
    return state.projectNegotiation?.kind ==
            P2pProjectNegotiationKind.remoteProvides &&
        state.selectedProjectSource == P2pProjectSource.remote &&
        state.sessionProjectUuid != null;
  }

  String _p2pProjectStatusText(
    P2pProjectPreflightResult preflight,
    P2pSyncState state,
  ) {
    if (_isReceivingRemoteProject(state)) {
      return context.l10n.uiThePeerWillProvideAnInMemoryProject;
    }
    if (preflight.canCollaborate && !preflight.canSync) {
      return context.l10n.uiInMemoryProjectReadyForLiveSyncNo;
    }
    if (preflight.requiresSave) return context.l10n.uiCreateOrOpenAProjectFirst;
    if (preflight.issues.contains(
      P2pProjectPreflightIssue.localProjectHasConflict,
    )) {
      return context.l10n.uiUnresolvedSyncConflicts;
    }
    if (preflight.canSync) {
      return switch (state.revisionSummaryRelation) {
        P2pRevisionSummaryRelation.equal =>
          context.l10n.uiSavedRevisionsSynchronized,
        P2pRevisionSummaryRelation.localAhead =>
          context.l10n.uiSavedReadyToNotifyThePeer,
        P2pRevisionSummaryRelation.remoteAhead =>
          context.l10n.uiSavedReadyToDownloadAndApplyThePeer,
        P2pRevisionSummaryRelation.concurrent =>
          context.l10n.uiSavedFieldLevelConflictMergingAvailable,
        null when state.hasAuthenticatedTransport =>
          context.l10n.uiSavedWaitingForRevisionNegotiation,
        null =>
          context.l10n.uiSavedWaitingForConnectionNegotiationAndSecurePairing,
      };
    }
    return context.l10n.uiSyncProjectIsNotReady;
  }

  String _p2pPairingStatusText(P2pPairingStatus status) {
    return switch (status) {
      P2pPairingStatus.idle => context.l10n.uiNotPaired,
      P2pPairingStatus.waitingForPeer =>
        context.l10n.uiWaitingForThePeerSPairingChallenge,
      P2pPairingStatus.comparisonRequired =>
        context.l10n.uiWaitingForManualPairingCodeComparison,
      P2pPairingStatus.trustedLocally =>
        context.l10n.uiAddedToThisDeviceSTrustList,
      P2pPairingStatus.waitingForPeerConfirmation =>
        context.l10n.uiConfirmedLocallyWaitingForThePeerSSignature,
      P2pPairingStatus.mutuallyConfirmed =>
        context.l10n.uiBothDevicesConfirmedTheSamePairingTranscript,
      P2pPairingStatus.error => context.l10n.uiPairingError,
    };
  }

  String? _p2pPersistentVerificationText(P2pSyncState state) {
    if (!state.isPersistentVerificationNegotiated) return null;
    final untilSeconds =
        state.trustedPeer?.persistentVerificationUntilEpochSeconds;
    if (untilSeconds == null) {
      return context.l10n.uiPersistentVerificationEnabledOnBothDevicesValidFor;
    }
    final until = DateTime.fromMillisecondsSinceEpoch(
      untilSeconds * 1000,
      isUtc: true,
    ).toLocal();
    final formatted = context.formats.dateTime(until, seconds: false);
    return state.trustedPeer!.hasPersistentVerificationAt(DateTime.now())
        ? context.l10n
              .uiPersistentVerificationExpiresEachSuccessfulConnectionRenewsIt(
                (formatted).toString(),
              )
        : context
              .l10n
              .uiPersistentVerificationExpiredConfirmThePairingCodeAgain;
  }

  String _p2pRevisionStatusText(P2pSyncState state) {
    if (state.isRevisionMetadataLoading)
      return context.l10n.uiLocalRevisionLoading;
    if (state.revisionMetadataErrorFor(context.l10n) != null) {
      return context.l10n.uiLocalRevisionMetadataError;
    }
    final graph = state.localRevisionGraph;
    if (graph == null || graph.revisions.isEmpty) {
      return context.l10n.uiLocalRevisionNotCreatedYetCreatedAfterA;
    }
    if (graph.hasConflict) {
      return context.l10n.uiLocalRevisionConcurrentHeads(
        context.formats.integer(graph.headIds.length),
      );
    }
    final head = graph.singleHead!;
    return context.l10n.uiLocalRevision(
      (head.shortRevisionId).toString(),
      (head.clock.displayLabel).toString(),
    );
  }

  String _p2pSecureTransportStatusText(P2pSyncState state) {
    final transport = switch (state.secureTransportStatus) {
      P2pSecureTransportStatus.inactive =>
        context.l10n.uiEncryptedChannelNotEstablished,
      P2pSecureTransportStatus.establishing =>
        context.l10n.uiEncryptedChannelVerifyingIdentityAndDerivingASession,
      P2pSecureTransportStatus.authenticated =>
        context.l10n.uiEncryptedChannelAuthenticatedAndEncrypted,
      P2pSecureTransportStatus.error =>
        context.l10n.uiEncryptedChannelConnectionFailed,
    };
    final relation = switch (state.revisionSummaryRelation) {
      P2pRevisionSummaryRelation.equal => context.l10n.uiRevisionHeadsMatch,
      P2pRevisionSummaryRelation.localAhead =>
        context.l10n.uiLocalRevisionIsNewer,
      P2pRevisionSummaryRelation.remoteAhead =>
        context.l10n.uiPeerRevisionIsNewer,
      P2pRevisionSummaryRelation.concurrent =>
        context.l10n.uiConcurrentRevisionsDetected,
      null => "",
    };
    final content = state.hasSnapshotContentTransfer
        ? context.l10n.uiSnapshotChunkValidationEnabled
        : "";
    return "$transport$relation$content";
  }

  String _p2pSnapshotManifestStatusText(P2pSyncState state) {
    final local = state.localSnapshotManifest;
    final localText = local == null
        ? context.l10n.uiLocalManifestNotCreated
        : context.l10n.uiLocalManifestBytesChunks(
            context.formats.integer(local.contentLength),
            context.formats.integer(local.chunkCount),
          );
    final remoteText = switch (state.snapshotManifestStatus) {
      P2pSnapshotManifestStatus.inactive =>
        context.l10n.uiPeerManifestNotNegotiated,
      P2pSnapshotManifestStatus.requesting =>
        context.l10n.uiPeerManifestRequesting,
      P2pSnapshotManifestStatus.available =>
        context.l10n.uiPeerManifestVerifiedBytes(
          context.formats.integer(
            state.remoteSnapshotManifest?.contentLength ?? 0,
          ),
        ),
      P2pSnapshotManifestStatus.unavailable =>
        context.l10n.uiPeerManifestCurrentlyUnavailable,
      P2pSnapshotManifestStatus.error =>
        context.l10n.uiPeerManifestVerificationFailed,
    };
    return "$localText；$remoteText";
  }

  String _p2pRevisionDagStatusText(P2pSyncState state) {
    if (state.isRevisionGraphLoading)
      return context.l10n.uiRevisionDAGExchangingGraphPages;
    if (state.revisionGraphErrorFor(context.l10n) != null) {
      return "Revision DAG：${state.revisionGraphErrorFor(context.l10n)}";
    }
    final remote = state.remoteRevisionGraph;
    if (remote == null)
      return context.l10n.uiRevisionDAGFullHistoryNotYetExchanged;
    final ancestors = state.commonAncestorRevisionIds.length;
    final ack = state.remoteResolutionAck;
    return ack == null
        ? context.l10n
              .uiRevisionDAGRemoteRevisionsMaximalCommonAncestorsWaiting(
                context.formats.integer(remote.revisions.length),
                context.formats.integer(ancestors),
              )
        : context.l10n.uiRevisionDAGPeerAcknowledgedResolution(
            (ack.resolutionRevisionId.substring(0, 8)).toString(),
          );
  }

  Future<void> _openExternalLink(Uri uri) async {
    try {
      final bool didLaunch = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!didLaunch) {
        throw const FormatException("Unable to launch external link");
      }
    } catch (_) {
      await Clipboard.setData(ClipboardData(text: uri.toString()));
      if (!mounted) {
        return;
      }
      _showMessage(context.l10n.uiCouldNotOpenTheLinkItHasBeen);
    }
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }
    AppFeedback.info(context, message);
  }

  Future<void> _handleImmediateP2pSync() async {
    final activeOperation = _immediateP2pSyncOperation;
    if (activeOperation != null) {
      return activeOperation;
    }
    late final Future<void> operation;
    operation = _performImmediateP2pSync().whenComplete(() {
      if (identical(_immediateP2pSyncOperation, operation)) {
        _immediateP2pSyncOperation = null;
      }
    });
    _immediateP2pSyncOperation = operation;
    return operation;
  }

  Future<void> _performImmediateP2pSync() async {
    var syncState = ref.read(p2pSyncProvider);
    if (syncState.revisionSummaryRelation ==
        P2pRevisionSummaryRelation.localAhead) {
      await ref.read(p2pSyncProvider.notifier).requestImmediateSync();
      return;
    }
    if (syncState.revisionSummaryRelation ==
            P2pRevisionSummaryRelation.concurrent &&
        syncState.remoteRevisionGraph == null) {
      await ref.read(p2pSyncProvider.notifier).refreshRevisionGraph();
      if (!mounted) return;
      syncState = ref.read(p2pSyncProvider);
    }
    final notifier = ref.read(p2pSnapshotTransferProvider.notifier);
    var transfer = ref.read(p2pSnapshotTransferProvider);
    if (!transfer.hasVerifiedSnapshot) {
      final downloaded = await notifier.downloadRemoteSnapshot();
      if (!downloaded || !mounted) return;
      transfer = ref.read(p2pSnapshotTransferProvider);
    }
    syncState = ref.read(p2pSyncProvider);
    final apply = widget.onApplyVerifiedP2pSnapshot;
    final verified = transfer.verifiedSnapshot;
    if (verified == null) return;
    if (syncState.revisionSummaryRelation ==
        P2pRevisionSummaryRelation.concurrent) {
      final resolve = widget.onResolveConcurrentP2pSnapshot;
      if (resolve != null && await resolve(verified)) {
        notifier.completeConcurrentResolution(verified);
      }
      return;
    }
    if (apply == null) return;
    await notifier.applyVerifiedSnapshot(apply);
  }

  Future<void> _handleCompareRemoteSnapshot() async {
    final compare = widget.onCompareVerifiedP2pSnapshot;
    if (compare == null) return;
    final notifier = ref.read(p2pSnapshotTransferProvider.notifier);
    var transfer = ref.read(p2pSnapshotTransferProvider);
    if (!transfer.hasVerifiedSnapshot) {
      final downloaded = await notifier.downloadRemoteSnapshot();
      if (!downloaded || !mounted) return;
      transfer = ref.read(p2pSnapshotTransferProvider);
    }
    final verified = transfer.verifiedSnapshot;
    if (verified != null) await compare(verified);
  }

  // MARK: - UI 介面建構
  @override
  Widget build(BuildContext context) {
    final p2pState = ref.watch(p2pSyncProvider);
    final p2pTransferState = ref.watch(p2pSnapshotTransferProvider);
    ref.listen<int>(
      p2pSyncProvider.select((state) => state.negotiationGeneration),
      (previous, next) {
        if (next <= _lastHandledNegotiationGeneration) return;
        _lastHandledNegotiationGeneration = next;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          final latest = ref.read(p2pSyncProvider);
          if (latest.negotiationGeneration == next) {
            if (latest.projectNegotiation?.requiresDialog ?? false) {
              unawaited(_showP2pNegotiationDialog(latest));
            } else {
              _dismissP2pNegotiationDialog();
            }
          }
        });
      },
    );
    ref.listen<int>(
      p2pSyncProvider.select(
        (state) => state.incomingSnapshotSyncRequestGeneration,
      ),
      (previous, next) {
        if (next <= _lastHandledSnapshotSyncRequestGeneration) return;
        _lastHandledSnapshotSyncRequestGeneration = next;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          final latest = ref.read(p2pSyncProvider);
          if (latest.incomingSnapshotSyncRequestGeneration == next &&
              (latest.revisionSummaryRelation ==
                      P2pRevisionSummaryRelation.remoteAhead ||
                  latest.revisionSummaryRelation ==
                      P2pRevisionSummaryRelation.concurrent) &&
              latest.snapshotManifestStatus ==
                  P2pSnapshotManifestStatus.available) {
            unawaited(_handleImmediateP2pSync());
          }
        });
      },
    );
    final localP2pPreflight = P2pProjectPreflight.evaluate(
      local: widget.localP2pProject,
      requireRemote: false,
    );
    final List<RecentProjectEntry> recentProjects =
        widget.recentProjects ??
        ref.watch(
          settingsStateProvider.select(
            (state) =>
                state.valueOrNull?.recentProjects ??
                const <RecentProjectEntry>[],
          ),
        );

    final Set<String> supportedGenderValues = <String>{
      "all",
      "male",
      "neutral",
      "female",
    };
    final String effectiveGenderValue =
        supportedGenderValues.contains(_selectedGender)
        ? _selectedGender
        : "female";

    final ButtonStyle TextButtonStyle =
        (Theme.of(context).textButtonTheme.style ?? const ButtonStyle())
            .copyWith(
              textStyle: WidgetStatePropertyAll<TextStyle?>(
                Theme.of(context).textTheme.labelSmall,
              ),
            );
    final TextStyle? dropdownTextStyle = Theme.of(context).textTheme.bodyMedium;

    return Scaffold(
      body: AppPageScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const WelcomeGreeting(),
            const SizedBox(height: 32),
            // Start
            AppSectionCard(
              margin: const EdgeInsets.all(4),
              padding: EdgeInsets.zero,
              useSectionLayout: false,
              elevation: 0,
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SmallTitle(
                      icon: Icons.format_list_bulleted,
                      text: "Start",
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      style: TextButtonStyle,
                      onPressed: _handleNewProject,
                      child: Row(
                        children: [
                          Icon(Icons.create_outlined, size: 18),
                          SizedBox(width: 4),
                          Text(context.l10n.uiNewProject),
                        ],
                      ),
                    ),
                    TextButton(
                      style: TextButtonStyle,
                      onPressed: _handleOpenProject,
                      child: Row(
                        children: [
                          Icon(Icons.folder_open, size: 18),
                          SizedBox(width: 4),
                          Text(context.l10n.uiOpenFile2),
                        ],
                      ),
                    ),
                    TextButton(
                      style: TextButtonStyle,
                      onPressed: () => _openExternalLink(_projectRepoUri),
                      child: Row(
                        children: [
                          Icon(Icons.code, size: 18),
                          SizedBox(width: 4),
                          Flexible(
                            child: Text(context.l10n.uiOpenThisProjectOnGitHub),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      style: TextButtonStyle,
                      onPressed: () => _openExternalLink(_KadoURL),
                      child: Row(
                        children: [
                          Icon(Icons.person_pin, size: 18),
                          SizedBox(width: 4),
                          Flexible(
                            child: Text(context.l10n.uiHeyairuSKadoKadoProfile),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      style: TextButtonStyle,
                      onPressed: () => _openExternalLink(_KoFiURL),
                      child: Row(
                        children: const [
                          Icon(Icons.coffee, size: 18),
                          SizedBox(width: 4),
                          Flexible(child: Text("Heyairu's Ko-fi")),
                        ],
                      ),
                    ),
                    Divider(height: 24, thickness: 1),
                    TextButton(
                      style: TextButtonStyle,
                      onPressed: () => _openExternalLink(_GFormsURL),
                      child: Row(
                        children: [
                          Icon(Icons.feedback_rounded, size: 18),
                          SizedBox(width: 4),
                          Flexible(
                            child: Text(context.l10n.uiSendFeedbackGoogleForms),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      style: TextButtonStyle,
                      onPressed: () => _openExternalLink(_GitHubIssueURL),
                      child: Row(
                        children: [
                          Icon(Icons.feedback_rounded, size: 18),
                          SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              context.l10n.uiSendFeedbackGitHubIssues,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Did you know?
            AppSectionCard(
              margin: const EdgeInsets.all(4),
              padding: EdgeInsets.zero,
              useSectionLayout: false,
              elevation: 0,
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              child: InkWell(
                borderRadius: AppSurfaceShape.borderRadius,
                onTap: _reloadDidYouKnow,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SmallTitle(
                        icon: Icons.info_outline,
                        text: "Did you know?",
                      ),
                      const SizedBox(height: 12),
                      FutureBuilder<_DidYouKnowData>(
                        future: _didYouKnowFuture,
                        builder: (context, snapshot) {
                          final _DidYouKnowData didYouKnowData =
                              snapshot.data ?? _fallbackDidYouKnowData;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                didYouKnowData.content, //Content
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              Text(
                                "——" + didYouKnowData.source, //Source
                                style: Theme.of(context).textTheme.labelMedium
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Recent Files
            AppSectionCard(
              margin: const EdgeInsets.all(4),
              padding: EdgeInsets.zero,
              useSectionLayout: false,
              elevation: 0,
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SmallTitle(icon: Icons.folder, text: "Recent"),
                    const SizedBox(height: 12),
                    if (recentProjects.isEmpty)
                      AppEmptyState(
                        title: context.l10n.uiNoRecentFiles,
                        description:
                            context.l10n.uiProjectsYouOpenWillAppearHere,
                        icon: Icons.history_outlined,
                        compact: true,
                        padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                      )
                    else
                      ...recentProjects.take(5).map((entry) {
                        final subtitle =
                            entry.filePath ??
                            entry.uri ??
                            context.l10n.uiNoUsablePath;
                        return Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                style: TextButtonStyle,
                                onPressed: () =>
                                    _handleOpenRecentProject(entry),
                                child: Row(
                                  children: [
                                    const Icon(Icons.history, size: 18),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            entry.fileName,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            subtitle,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall
                                                ?.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurfaceVariant,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            IconButton(
                              tooltip: context.l10n.uiRemoveFromRecentProjects,
                              onPressed: () =>
                                  _handleDeleteRecentProject(entry),
                              icon: const Icon(Icons.close),
                            ),
                          ],
                        );
                      }),
                  ],
                ),
              ),
            ),
            // Features
            AppSectionCard(
              margin: const EdgeInsets.all(4),
              padding: EdgeInsets.zero,
              useSectionLayout: false,
              elevation: 0,
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SmallTitle(
                      icon: Icons.person_outline,
                      text: context.l10n.uiNameGenerator,
                    ),
                    const SizedBox(height: 16),
                    // Col 1: language, gender, count, generate button.
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.l10n.uiLanguage,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            const SizedBox(height: 6),
                            AppDropdownField<String>(
                              value: _selectedLanguage,
                              textStyle: dropdownTextStyle,
                              options: [
                                DropdownOption<String>(
                                  value: "JP",
                                  label: context.l10n.uiJapanese,
                                ),
                                DropdownOption<String>(
                                  value: "ZH",
                                  label: context.l10n.uiChinese,
                                ),
                                DropdownOption<String>(
                                  value: "KR",
                                  label: context.l10n.uiKorean,
                                ),
                              ],
                              onChanged: (String? value) {
                                if (value == null) {
                                  return;
                                }
                                setState(() {
                                  _selectedLanguage = value;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.l10n.uiGender,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            const SizedBox(height: 6),
                            AppDropdownField<String>(
                              value: effectiveGenderValue,
                              textStyle: dropdownTextStyle,
                              options: [
                                DropdownOption<String>(
                                  value: "all",
                                  enabled: false,
                                  label: context.l10n.uiAllUnavailable,
                                ),
                                DropdownOption<String>(
                                  value: "male",
                                  label: context.l10n.uiMale,
                                ),
                                DropdownOption<String>(
                                  value: "neutral",
                                  enabled: false,
                                  label: context.l10n.uiNeutralUnavailable,
                                ),
                                DropdownOption<String>(
                                  value: "female",
                                  label: context.l10n.uiFemale,
                                ),
                              ],
                              onChanged: (String? value) {
                                if (value == null ||
                                    value == "all" ||
                                    value == "neutral") {
                                  return;
                                }
                                setState(() {
                                  _selectedGender = value;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.l10n.uiNumberToGenerate,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            const SizedBox(height: 6),
                            AppDropdownField<int>(
                              value: _generateCount,
                              textStyle: dropdownTextStyle,
                              options: const [1, 3, 5, 10, 20]
                                  .map(
                                    (int value) => DropdownOption<int>(
                                      value: value,
                                      label: "$value",
                                    ),
                                  )
                                  .toList(),
                              onChanged: (int? value) {
                                if (value == null) {
                                  return;
                                }
                                setState(() {
                                  _generateCount = value;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          style: TextButtonStyle,
                          onPressed: _isGeneratingNames ? null : _generateNames,
                          child: Row(
                            children: [
                              MediumTitle(
                                icon: Icons.east,
                                text: context.l10n.uiGenerate,
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Col 2: selectable and copyable generated results.
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  context.l10n.uiResults,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.labelMedium,
                                ),
                                IconButton(
                                  tooltip: context.l10n.uiCopyResults,
                                  onPressed: _generatedNames.isEmpty
                                      ? null
                                      : _copyGeneratedNames,
                                  icon: const Icon(Icons.copy_all_outlined),
                                ),
                              ],
                            ),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(AppSpacing.md),
                              constraints: const BoxConstraints(minHeight: 120),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: AppSurfaceShape.borderRadius,
                                border: Border.all(
                                  color: Theme.of(context).dividerColor,
                                ),
                              ),
                              child: SelectionArea(
                                child: Text(
                                  _generatedNames.isEmpty
                                      ? context
                                            .l10n
                                            .uiSelectGenerateToCreateNames
                                      : _generatedNames.join("\n"),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Sync
            AppSectionCard(
              margin: const EdgeInsets.all(4),
              padding: EdgeInsets.zero,
              useSectionLayout: false,
              elevation: 0,
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: SmallTitle(
                            icon: Icons.sync_alt_outlined,
                            text: context.l10n.uiContentSync,
                          ),
                        ),
                        Chip(
                          key: const Key("p2p-service-status"),
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.xs,
                          ),
                          labelPadding: EdgeInsets.zero,
                          side: BorderSide.none,
                          backgroundColor: p2pState.isListening
                              ? Theme.of(context).colorScheme.primaryContainer
                              : Theme.of(
                                  context,
                                ).colorScheme.surfaceContainerHighest,
                          label: Text(
                            _p2pServiceStatusText(p2pState),
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context
                          .l10n
                          .uiAfterSignedPairingAndAnAuthenticatedConnectionDevices,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      context.l10n.uiLocalService,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        if (p2pState.localAddresses.isEmpty)
                          AppControlChip(
                            avatar: Icon(Icons.lan_outlined, size: 16),
                            label: context.l10n.uiNoUsableLANIPv4AddressFound,
                          )
                        else
                          ...p2pState.localAddresses.map(
                            (address) => AppControlChip(
                              avatar: const Icon(Icons.lan_outlined, size: 16),
                              label: address,
                            ),
                          ),
                        if (p2pState.listeningPort != null)
                          AppControlChip(
                            avatar: const Icon(
                              Icons.settings_ethernet,
                              size: 16,
                            ),
                            label: "Port ${p2pState.listeningPort}",
                          ),
                        IconButton(
                          key: const Key("p2p-refresh-local-addresses-button"),
                          tooltip: context.l10n.uiDetectLocalIPAgain,
                          constraints: BoxConstraints.tightFor(
                            width: AppControlSize.heightForContext(context),
                            height: AppControlSize.heightForContext(context),
                          ),
                          onPressed: () => ref
                              .read(p2pSyncProvider.notifier)
                              .refreshLocalAddresses(),
                          icon: const Icon(Icons.refresh),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final portField = AppTextField(
                          key: const Key("p2p-local-port-field"),
                          controller: _localPortController,
                          enabled:
                              !p2pState.isListening && !p2pState.isServiceBusy,
                          labelText: context.l10n.uiLocalPort,
                          errorText: _localPortError,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        );
                        final serviceButton = FilledButton.tonalIcon(
                          key: const Key("p2p-toggle-service-button"),
                          onPressed:
                              p2pState.isServiceBusy || p2pState.isConnecting
                              ? null
                              : _handleToggleP2pService,
                          icon: Icon(
                            p2pState.isListening
                                ? Icons.stop_circle_outlined
                                : Icons.play_circle_outline,
                          ),
                          label: Text(
                            p2pState.isListening
                                ? context.l10n.uiStopService
                                : context.l10n.uiStartService,
                          ),
                        );
                        if (constraints.maxWidth >= 280 &&
                            constraints.maxWidth < 350) {
                          return Row(
                            crossAxisAlignment: _localPortError == null
                                ? CrossAxisAlignment.center
                                : CrossAxisAlignment.start,
                            children: [
                              Expanded(child: portField),
                              const SizedBox(width: 12),
                              serviceButton,
                            ],
                          );
                        }
                        return Wrap(
                          crossAxisAlignment: _localPortError == null
                              ? WrapCrossAlignment.center
                              : WrapCrossAlignment.start,
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            SizedBox(width: 180, child: portField),
                            serviceButton,
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Text(
                      context.l10n.uiConnectToDevice,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      crossAxisAlignment:
                          _peerIpError == null && _peerPortError == null
                          ? WrapCrossAlignment.center
                          : WrapCrossAlignment.start,
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        SizedBox(
                          width: 250,
                          child: AppTextField(
                            key: const Key("p2p-peer-ip-field"),
                            controller: _peerIpController,
                            labelText: context.l10n.uiPeerIP,
                            hintText: context.l10n.uiForExample,
                            errorText: _peerIpError,
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        SizedBox(
                          width: 160,
                          child: AppTextField(
                            key: const Key("p2p-peer-port-field"),
                            controller: _peerPortController,
                            labelText: context.l10n.uiPeerPort,
                            errorText: _peerPortError,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onSubmitted: (_) => _handleP2pConnect(),
                          ),
                        ),
                        FilledButton.icon(
                          key: const Key("p2p-connect-button"),
                          onPressed:
                              p2pState.isConnecting ||
                                  p2pState.isServiceBusy ||
                                  p2pState.connectionStatus ==
                                      P2pConnectionStatus.reachableUnpaired
                              ? null
                              : _handleP2pConnect,
                          icon: Icon(
                            p2pState.connectionStatus ==
                                    P2pConnectionStatus.reachableUnpaired
                                ? Icons.link_outlined
                                : Icons.link,
                          ),
                          label: Text(
                            p2pState.connectionStatus ==
                                    P2pConnectionStatus.reachableUnpaired
                                ? context.l10n.uiEndpointVerified
                                : p2pState.isConnecting
                                ? context.l10n.uiConnecting
                                : context.l10n.uiConnect,
                          ),
                        ),
                        if (p2pState.hasReachablePeer)
                          OutlinedButton.icon(
                            key: const Key("p2p-disconnect-peer-button"),
                            onPressed: p2pState.isServiceBusy
                                ? null
                                : () => ref
                                      .read(p2pSyncProvider.notifier)
                                      .disconnectPeer(),
                            icon: const Icon(Icons.link_off),
                            label: Text(context.l10n.uiDisconnect),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      key: const Key("p2p-pairing-panel"),
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                        ),
                        borderRadius: AppSurfaceShape.borderRadius,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.uiDeviceIdentityAndPairing,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            context.l10n.uiLocalFingerprint(
                              (p2pState.localIdentity?.shortFingerprint ??
                                      context.l10n.uiInitializing)
                                  .toString(),
                            ),
                            key: const Key("p2p-local-fingerprint"),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            _p2pPairingStatusText(p2pState.pairingStatus),
                            key: const Key("p2p-pairing-status"),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          if (p2pState.localPairingChallenge != null &&
                              p2pState.remotePairingChallenge != null)
                            Text(
                              p2pState.isSingleDeviceConfirmationNegotiated
                                  ? context
                                        .l10n
                                        .uiConfirmationOneDeviceEnabledOnBothDevices
                                  : context
                                        .l10n
                                        .uiConfirmationBothDevicesOneOrBothDisabledSingle,
                              key: const Key("p2p-pairing-confirmation-mode"),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          if (_p2pPersistentVerificationText(p2pState)
                              case final persistentText?)
                            Text(
                              persistentText,
                              key: const Key(
                                "p2p-persistent-verification-status",
                              ),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          Text(
                            _p2pRevisionStatusText(p2pState),
                            key: const Key("p2p-revision-status"),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            _p2pSecureTransportStatusText(p2pState),
                            key: const Key("p2p-secure-transport-status"),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            _p2pSnapshotManifestStatusText(p2pState),
                            key: const Key("p2p-snapshot-manifest-status"),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            _p2pRevisionDagStatusText(p2pState),
                            key: const Key("p2p-revision-dag-status"),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          if (p2pState.revisionMetadataErrorFor(context.l10n) !=
                              null)
                            Text(
                              p2pState.revisionMetadataErrorFor(context.l10n)!,
                              key: const Key("p2p-revision-error"),
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                            ),
                          if (p2pState.secureTransportErrorFor(context.l10n) !=
                              null)
                            Text(
                              p2pState.secureTransportErrorFor(context.l10n)!,
                              key: const Key("p2p-secure-transport-error"),
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                            ),
                          if (p2pState.snapshotManifestErrorFor(context.l10n) !=
                              null)
                            Text(
                              p2pState.snapshotManifestErrorFor(context.l10n)!,
                              key: const Key("p2p-snapshot-manifest-error"),
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                            ),
                          if (p2pState.pairingCode != null) ...[
                            const SizedBox(height: 12),
                            Text(
                              context
                                  .l10n
                                  .uiConfirmBothDevicesDisplayExactlyTheSamePairing,
                            ),
                            const SizedBox(height: 6),
                            SelectableText(
                              p2pState.pairingCode!,
                              key: const Key("p2p-pairing-code"),
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(
                                    letterSpacing: 6,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              p2pState.isSingleDeviceConfirmationNegotiated
                                  ? context
                                        .l10n
                                        .uiCancelIfTheCodesDifferAfterEitherDevice
                                  : context
                                        .l10n
                                        .uiCancelIfTheCodesDifferBothDevicesMust,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                            ),
                          ],
                          if (p2pState.hasReachablePeer) ...[
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                if (p2pState.pairingStatus ==
                                        P2pPairingStatus.idle ||
                                    (p2pState.pairingStatus ==
                                            P2pPairingStatus.waitingForPeer &&
                                        p2pState.localPairingChallenge ==
                                            null) ||
                                    p2pState.pairingStatus ==
                                        P2pPairingStatus.error)
                                  FilledButton.tonalIcon(
                                    key: const Key("p2p-begin-pairing-button"),
                                    onPressed: p2pState.localIdentity == null
                                        ? null
                                        : () {
                                            final settings = ref
                                                .read(settingsStateProvider)
                                                .valueOrNull;
                                            unawaited(
                                              ref
                                                  .read(
                                                    p2pSyncProvider.notifier,
                                                  )
                                                  .beginPairing(
                                                    allowSingleDeviceConfirmation:
                                                        settings
                                                            ?.allowSingleDevicePairingConfirmation ??
                                                        true,
                                                    allowPersistentVerification:
                                                        settings
                                                            ?.allowPersistentP2pVerification ??
                                                        false,
                                                  ),
                                            );
                                          },
                                    icon: const Icon(Icons.key_outlined),
                                    label: Text(
                                      context.l10n.uiStartSecurePairing,
                                    ),
                                  ),
                                if (p2pState.pairingStatus ==
                                    P2pPairingStatus.comparisonRequired)
                                  FilledButton.icon(
                                    key: const Key(
                                      "p2p-confirm-pairing-button",
                                    ),
                                    onPressed: () => ref
                                        .read(p2pSyncProvider.notifier)
                                        .confirmPairingCode(),
                                    icon: const Icon(
                                      Icons.verified_user_outlined,
                                    ),
                                    label: Text(
                                      context.l10n.uiConfirmCodesMatch,
                                    ),
                                  ),
                                if (p2pState.pairingStatus ==
                                        P2pPairingStatus.waitingForPeer ||
                                    p2pState.pairingStatus ==
                                        P2pPairingStatus.comparisonRequired ||
                                    p2pState.pairingStatus ==
                                        P2pPairingStatus
                                            .waitingForPeerConfirmation)
                                  TextButton(
                                    key: const Key("p2p-cancel-pairing-button"),
                                    onPressed: () => ref
                                        .read(p2pSyncProvider.notifier)
                                        .cancelPairing(),
                                    child: Text(context.l10n.uiCancelPairing),
                                  ),
                              ],
                            ),
                          ],
                          if (p2pState.pairingStatus ==
                              P2pPairingStatus.mutuallyConfirmed) ...[
                            const SizedBox(height: 10),
                            Text(
                              p2pState.hasAuthenticatedTransport
                                  ? context
                                        .l10n
                                        .uiBothIdentitiesAndTemporaryECDHKeysAreBound
                                  : context
                                        .l10n
                                        .uiBothDevicesSignedTheSameChallengeEstablishingAuthenticated,
                              key: const Key("p2p-mutually-confirmed-notice"),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        borderRadius: AppSurfaceShape.borderRadius,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.uiSyncProject,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            widget.localP2pProject?.fileName ??
                                context.l10n.uiNoProjectOpen,
                            key: const Key("p2p-project-file-name"),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "UUID：${widget.localP2pProject?.shortUuid ?? '—'}",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          if (p2pState.remoteProjectOffer != null) ...[
                            const SizedBox(height: 6),
                            Text(
                              context.l10n.uiPeerFile(
                                (p2pState.remoteProjectOffer!.fileName ??
                                        context.l10n.uiNoProjectToSync)
                                    .toString(),
                              ),
                              key: const Key("p2p-remote-project-file-name"),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              context.l10n.uiPeerUUID(
                                (p2pState.remoteProjectOffer!.shortUuid)
                                    .toString(),
                              ),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                          const SizedBox(height: 2),
                          Text(
                            _p2pProjectStatusText(localP2pPreflight, p2pState),
                            key: const Key("p2p-project-status"),
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color:
                                      localP2pPreflight.canSync ||
                                          localP2pPreflight.canCollaborate ||
                                          _isReceivingRemoteProject(p2pState)
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.error,
                                ),
                          ),
                          if (p2pTransferState.messageFor(context.l10n) !=
                                  null ||
                              p2pTransferState.errorMessageFor(context.l10n) !=
                                  null) ...[
                            const SizedBox(height: 6),
                            Text(
                              p2pTransferState.errorMessageFor(context.l10n) ??
                                  p2pTransferState.messageFor(context.l10n)!,
                              key: const Key("p2p-snapshot-transfer-status"),
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color:
                                        p2pTransferState.errorMessageFor(
                                              context.l10n,
                                            ) ==
                                            null
                                        ? Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant
                                        : Theme.of(context).colorScheme.error,
                                  ),
                            ),
                          ],
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              OutlinedButton.icon(
                                key: const Key("p2p-prepare-project-button"),
                                onPressed: _handlePrepareP2pProject,
                                icon: const Icon(Icons.description_outlined),
                                label: Text(
                                  localP2pPreflight.canCollaborate ||
                                          _isReceivingRemoteProject(p2pState)
                                      ? context.l10n.uiChangeSyncProject
                                      : context.l10n.uiPrepareSyncProject,
                                ),
                              ),
                              Tooltip(
                                message:
                                    p2pState.revisionSummaryRelation ==
                                        P2pRevisionSummaryRelation.concurrent
                                    ? context
                                          .l10n
                                          .uiRevisionsDivergedResolveFieldLevelConflictsFirst
                                    : p2pState.revisionSummaryRelation ==
                                          P2pRevisionSummaryRelation.localAhead
                                    ? context
                                          .l10n
                                          .uiAskTheReceiverToDownloadTheCurrentSnapshot
                                    : context
                                          .l10n
                                          .uiOnlyAcceptARemoteSnapshotThatExactlyMatches,
                                child: FilledButton.icon(
                                  key: const Key("p2p-immediate-sync-button"),
                                  onPressed:
                                      !p2pTransferState.isBusy &&
                                          (localP2pPreflight.canSync ||
                                              _isReceivingRemoteProject(
                                                p2pState,
                                              )) &&
                                          ((p2pState.canDownloadRemoteSnapshot &&
                                                  (p2pState.revisionSummaryRelation ==
                                                          P2pRevisionSummaryRelation
                                                              .concurrent
                                                      ? widget.onResolveConcurrentP2pSnapshot !=
                                                            null
                                                      : widget.onApplyVerifiedP2pSnapshot !=
                                                            null)) ||
                                              p2pState
                                                  .canRequestPeerSnapshotSync)
                                      ? _handleImmediateP2pSync
                                      : null,
                                  icon: p2pTransferState.isBusy
                                      ? const SizedBox.square(
                                          dimension: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Icon(Icons.sync),
                                  label: Text(
                                    p2pTransferState.status ==
                                            P2pSnapshotTransferStatus.applying
                                        ? context.l10n.uiApplying
                                        : p2pTransferState.status ==
                                              P2pSnapshotTransferStatus
                                                  .downloading
                                        ? context.l10n.uiDownloading
                                        : context.l10n.uiSyncNow,
                                  ),
                                ),
                              ),
                              if (widget.onCompareVerifiedP2pSnapshot != null &&
                                  (p2pTransferState.hasVerifiedSnapshot ||
                                      p2pState.canDownloadRemoteSnapshot))
                                OutlinedButton.icon(
                                  key: const Key(
                                    'p2p-compare-verified-snapshot-button',
                                  ),
                                  onPressed:
                                      !p2pTransferState.isBusy &&
                                          widget.localP2pProject != null &&
                                          p2pState.sessionProjectUuid != null &&
                                          widget.localP2pProject?.projectUuid
                                                  ?.trim()
                                                  .toLowerCase() ==
                                              p2pState.sessionProjectUuid
                                                  ?.trim()
                                                  .toLowerCase()
                                      ? _handleCompareRemoteSnapshot
                                      : null,
                                  icon: const Icon(Icons.difference_outlined),
                                  label: Text(
                                    context.l10n.uiCompareRemoteRevision,
                                  ),
                                ),
                              if (p2pTransferState.isBusy)
                                TextButton(
                                  key: const Key(
                                    "p2p-cancel-snapshot-transfer-button",
                                  ),
                                  onPressed: () => ref
                                      .read(
                                        p2pSnapshotTransferProvider.notifier,
                                      )
                                      .cancel(),
                                  child: Text(context.l10n.uiCancelTransfer),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (p2pState.messageFor(context.l10n) != null ||
                        p2pState.errorMessageFor(context.l10n) != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        p2pState.errorMessageFor(context.l10n) ??
                            p2pState.messageFor(context.l10n)!,
                        key: const Key("p2p-operation-message"),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: p2pState.errorMessageFor(context.l10n) == null
                              ? Theme.of(context).colorScheme.onSurfaceVariant
                              : Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DidYouKnowData {
  const _DidYouKnowData({required this.content, required this.source});

  final String content;
  final String source;
}

enum _P2pPreparationAction { save, saveAs, chooseProject, createNew }

enum _P2pSelectionAction { local, remote, prepareLocal, chooseOther }
