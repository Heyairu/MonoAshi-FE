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

import 'package:monogatari_assistant/l10n/app_localization.dart';
import "dart:async";
import "dart:convert";

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter/services.dart";
import "package:http/http.dart" as http;

import "../bin/file.dart";
import "../bin/ui_library.dart";
import "../features/copilot/application/copilot_conversation_buffer.dart";
import "../features/copilot/application/copilot_conversation_controller.dart";
import "../features/copilot/application/copilot_project_context_builder.dart";
import "../features/copilot/application/copilot_request_coordinator.dart";
import "../features/copilot/data/copilot_http_transport.dart";
import "../features/copilot/data/copilot_provider_adapter.dart";
import "../features/copilot/data/copilot_settings_store.dart";
import "../features/copilot/domain/copilot_errors.dart";
import "../features/copilot/domain/copilot_models.dart";
import "../models/chapter_selection_data.dart" as chapter_model;
import "../presentation/providers/project_state_providers.dart";

class _ProviderPreset {
  final String name;
  final String apiUrl;
  final List<String> fallbackModels;
  final CopilotProviderProtocol protocol;

  const _ProviderPreset({
    required this.name,
    required this.apiUrl,
    required this.fallbackModels,
    required this.protocol,
  });
}

class _CopilotSettingsSnapshot {
  final String provider;
  final String apiUrl;
  final String model;
  final String apiKey;

  const _CopilotSettingsSnapshot({
    required this.provider,
    required this.apiUrl,
    required this.model,
    required this.apiKey,
  });

  @override
  bool operator ==(Object other) {
    return other is _CopilotSettingsSnapshot &&
        other.provider == provider &&
        other.apiUrl == apiUrl &&
        other.model == model &&
        other.apiKey == apiKey;
  }

  @override
  int get hashCode => Object.hash(provider, apiUrl, model, apiKey);
}

class _SendCopilotMessageIntent extends Intent {
  const _SendCopilotMessageIntent();
}

class CopilotView extends ConsumerStatefulWidget {
  final ValueChanged<String>? onOpenChapter;
  final void Function(String resourceType, String resourceId)? onOpenResource;
  final CopilotSettingsStore settingsStore;
  final CopilotHttpTransport? transport;
  final CopilotConversationBuffer? conversationBuffer;
  final List<CopilotSelectableResource>? selectableResources;

  const CopilotView({
    super.key,
    this.onOpenChapter,
    this.onOpenResource,
    this.settingsStore = const CopilotSettingsStore(),
    this.transport,
    this.conversationBuffer,
    this.selectableResources,
  });

  @override
  ConsumerState<CopilotView> createState() => _CopilotViewState();
}

class _CopilotViewState extends ConsumerState<CopilotView> {
  static const int _maxUiMessages = 200;
  static const int _maxUiHistoryBytes = 1024 * 1024;
  static const int _maxContextMessages = 24;
  static const int _maxContextBytes = 128 * 1024;
  static const int _maxRequestBytes = 256 * 1024;
  static const int _maxModelResponseBytes = 1024 * 1024;
  static const int _maxChatResponseBytes = 2 * 1024 * 1024;
  static const int _maxOutputTokens = 4096;
  static const Duration _settingsDebounce = Duration(milliseconds: 350);

  static const List<_ProviderPreset> _providerPresets = [
    _ProviderPreset(
      name: "OpenAI",
      apiUrl: "https://api.openai.com/v1",
      fallbackModels: [""],
      protocol: CopilotProviderProtocol.openAiCompatible,
    ),
    _ProviderPreset(
      name: "Gemini",
      apiUrl: "https://generativelanguage.googleapis.com",
      fallbackModels: [""],
      protocol: CopilotProviderProtocol.gemini,
    ),
    _ProviderPreset(
      name: "Anthropic",
      apiUrl: "https://api.anthropic.com/v1",
      fallbackModels: [""],
      protocol: CopilotProviderProtocol.anthropic,
    ),
    _ProviderPreset(
      name: "Grok",
      apiUrl: "https://api.x.ai/v1",
      fallbackModels: [""],
      protocol: CopilotProviderProtocol.openAiCompatible,
    ),
    _ProviderPreset(
      name: "OpenRouter",
      apiUrl: "https://openrouter.ai/api/v1",
      fallbackModels: [""],
      protocol: CopilotProviderProtocol.openAiCompatible,
    ),
    _ProviderPreset(
      name: "Ollama",
      apiUrl: "http://localhost:11434/v1",
      fallbackModels: [""],
      protocol: CopilotProviderProtocol.ollama,
    ),
    _ProviderPreset(
      name: "自訂",
      apiUrl: "",
      fallbackModels: [],
      protocol: CopilotProviderProtocol.openAiCompatible,
    ),
  ];

  final TextEditingController _providerController = TextEditingController();
  final TextEditingController _apiUrlController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _apiKeyController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _modelFocusNode = FocusNode();
  final ScrollController _conversationScrollController = ScrollController();
  late final CopilotSettingsStore _settingsStore;
  late final CopilotHttpTransport _transport;
  final CopilotRequestCoordinator<_CopilotSettingsSnapshot>
  _requestCoordinator = CopilotRequestCoordinator<_CopilotSettingsSnapshot>();

  late final CopilotConversationBuffer _conversation;
  late final CopilotConversationController<_CopilotSettingsSnapshot>
  _conversationController;
  Future<String>? _mnprojStructureReference;

  List<CopilotConversationMessage> get _messages => _conversation.messages;
  bool get _isSending => _conversationController.isSending;
  List<String> _availableModels = [];
  CopilotMode _selectedMode = CopilotMode.chat;
  CopilotContextScope _selectedContextScope =
      CopilotContextScope.currentChapter;
  Set<String> _selectedResourceKeys = <String>{};
  bool _modelPanelExpanded = true;
  bool _isLoadingModels = false;
  bool _showApiKey = false;
  String? _statusMessage;
  String? _errorMessage;
  Timer? _settingsSaveTimer;
  Future<void> _settingsWrite = Future<void>.value();
  String? _confirmedContextHost;
  String? _confirmedCredentialHost;

  @override
  void initState() {
    super.initState();
    _settingsStore = widget.settingsStore;
    _transport =
        widget.transport ??
        CopilotHttpTransport(maxRequestBytes: _maxRequestBytes);
    _conversation =
        widget.conversationBuffer ??
        CopilotConversationBuffer(
          maxUiMessages: _maxUiMessages,
          maxUiHistoryBytes: _maxUiHistoryBytes,
          maxContextMessages: _maxContextMessages,
          maxContextBytes: _maxContextBytes,
        );
    _conversationController =
        CopilotConversationController<_CopilotSettingsSnapshot>(
          buffer: _conversation,
          requestCoordinator: _requestCoordinator,
        );
    _loadSettings();
  }

  Future<String> _getMnprojStructureReference() {
    return _mnprojStructureReference ??= _loadMnprojStructureReference();
  }

  Future<String> _loadMnprojStructureReference() async {
    final reference = await rootBundle.loadString(
      CopilotPromptPolicy.mnprojStructureAsset,
    );
    if (reference.trim().isEmpty) {
      throw const FormatException(".mnproj 結構參考檔是空白的。");
    }
    if (utf8.encode(reference).length >
        CopilotPromptPolicy.maxMnprojStructureBytes) {
      throw const FormatException(".mnproj 結構參考檔超過 64 KiB 上限。");
    }
    return reference.trim();
  }

  @override
  void dispose() {
    _requestCoordinator.cancelAll();
    _settingsSaveTimer?.cancel();
    final _CopilotSettingsSnapshot settingsSnapshot = _settingsSnapshot();
    unawaited(_enqueueSettingsWrite(settingsSnapshot));
    _transport.dispose();
    _providerController.dispose();
    _apiUrlController.dispose();
    _modelController.dispose();
    _apiKeyController.dispose();
    _messageController.dispose();
    _modelFocusNode.dispose();
    _conversationScrollController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final _ProviderPreset defaultPreset = _providerPresets.first;
    try {
      final settings = await _settingsStore.load();
      if (!mounted) return;
      final selectedPreset = _providerPresets.firstWhere(
        (preset) => preset.name == settings.provider,
        orElse: () => defaultPreset,
      );
      setState(() {
        _providerController.text = settings.provider ?? selectedPreset.name;
        _apiUrlController.text = settings.apiUrl ?? selectedPreset.apiUrl;
        _modelController.text =
            settings.model ??
            (selectedPreset.fallbackModels.isEmpty
                ? ""
                : selectedPreset.fallbackModels.first);
        _apiKeyController.text = settings.apiKey;
        _availableModels = selectedPreset.fallbackModels;
      });
    } catch (error, stackTrace) {
      debugPrint("Copilot secure settings load failed: $error\n$stackTrace");
      if (!mounted) return;
      setState(() {
        _providerController.text = defaultPreset.name;
        _apiUrlController.text = defaultPreset.apiUrl;
        _modelController.text = defaultPreset.fallbackModels.first;
        _availableModels = defaultPreset.fallbackModels;
        _errorMessage = context.l10n.uiCouldNotLoadSecureCopilotSettingsTheAPI;
      });
    }
  }

  _CopilotSettingsSnapshot _settingsSnapshot() {
    return _CopilotSettingsSnapshot(
      provider: _providerController.text.trim(),
      apiUrl: _apiUrlController.text.trim(),
      model: _modelController.text.trim(),
      apiKey: _apiKeyController.text,
    );
  }

  void _scheduleSettingsSave() {
    final snapshot = _settingsSnapshot();
    _settingsSaveTimer?.cancel();
    _settingsSaveTimer = Timer(
      _settingsDebounce,
      () => unawaited(_enqueueSettingsWrite(snapshot)),
    );
  }

  Future<void> _persistSettingsNow() {
    _settingsSaveTimer?.cancel();
    _settingsSaveTimer = null;
    return _enqueueSettingsWrite(_settingsSnapshot());
  }

  Future<void> _enqueueSettingsWrite(_CopilotSettingsSnapshot snapshot) {
    final operation = _settingsWrite
        .catchError((Object error, StackTrace stackTrace) {
          debugPrint("Copilot settings write failed: $error\n$stackTrace");
        })
        .then((_) async {
          await _settingsStore.save(
            provider: snapshot.provider,
            apiUrl: snapshot.apiUrl,
            model: snapshot.model,
            apiKey: snapshot.apiKey,
          );
        });
    _settingsWrite = operation.catchError((
      Object error,
      StackTrace stackTrace,
    ) {
      debugPrint("Copilot settings write failed: $error\n$stackTrace");
    });
    return operation;
  }

  void _selectProvider(String providerName) {
    final _ProviderPreset preset = _providerPresets.firstWhere(
      (preset) => preset.name == providerName,
      orElse: () => _providerPresets.last,
    );

    setState(() {
      _providerController.text = preset.name;
      if (preset.apiUrl.isNotEmpty) {
        _apiUrlController.text = preset.apiUrl;
      }
      _availableModels = preset.fallbackModels;
      if (preset.fallbackModels.isNotEmpty) {
        _modelController.text = preset.fallbackModels.first;
      }
      _statusMessage = null;
      _errorMessage = null;
    });
    _scheduleSettingsSave();
  }

  String _normalizeApiUrl(String apiUrl) {
    final String trimmed = apiUrl.trim();
    if (trimmed.endsWith("/")) {
      return trimmed.substring(0, trimmed.length - 1);
    }
    return trimmed;
  }

  Uri _buildEndpointUri(String path) {
    final String baseUrl = _normalizeApiUrl(_apiUrlController.text);
    if (baseUrl.isEmpty) {
      throw const FormatException("請先輸入 API URL。");
    }
    final baseUri = Uri.parse(baseUrl);
    if (!baseUri.hasScheme ||
        baseUri.host.isEmpty ||
        baseUri.userInfo.isNotEmpty) {
      throw const FormatException("API URL 格式無效。");
    }
    if (baseUri.scheme != "https" &&
        !(baseUri.scheme == "http" && _isLoopbackHost(baseUri.host))) {
      throw const FormatException("雲端 API URL 必須使用 HTTPS；HTTP 僅允許本機 Ollama。");
    }
    return Uri.parse("$baseUrl$path");
  }

  bool _isLoopbackHost(String host) {
    final normalized = host.toLowerCase();
    return normalized == "localhost" ||
        normalized == "127.0.0.1" ||
        normalized == "::1";
  }

  Uri _buildProviderEndpointUri(String path, {Map<String, String>? query}) {
    final Uri uri = _buildEndpointUri(path);
    if (query == null || query.isEmpty) {
      return uri;
    }
    return uri.replace(queryParameters: {...uri.queryParameters, ...query});
  }

  _ProviderPreset _selectedProviderPreset() {
    return _providerPresets.firstWhere(
      (preset) => preset.name == _providerController.text,
      orElse: () => _providerPresets.last,
    );
  }

  bool get _isOllamaV1Url {
    final String apiUrl = _normalizeApiUrl(_apiUrlController.text);
    return apiUrl.endsWith("/v1");
  }

  List<CopilotProviderMessage> _providerMessages() {
    return _conversation
        .modelContext(_selectedMode)
        .where((message) => message.role != CopilotConversationRole.system)
        .map(
          (message) => CopilotProviderMessage(
            role: message.role == CopilotConversationRole.user
                ? CopilotProviderMessageRole.user
                : CopilotProviderMessageRole.assistant,
            content: message.modelContent ?? message.content,
          ),
        )
        .toList(growable: false);
  }

  Future<http.Response> _sendBoundedJsonRequest(
    String method,
    Uri uri, {
    required Map<String, String> headers,
    Object? jsonBody,
    required Duration timeout,
    required int maxResponseBytes,
  }) async {
    return _transport.sendJson(
      method,
      uri,
      headers: headers,
      jsonBody: jsonBody,
      timeout: timeout,
      maxResponseBytes: maxResponseBytes,
    );
  }

  Future<http.Response> _readModelsResponse() {
    final _ProviderPreset preset = _selectedProviderPreset();
    final String apiKey = _apiKeyController.text.trim();
    final request = CopilotProviderAdapter.modelsRequest(
      protocol: preset.protocol,
      apiKey: apiKey,
      ollamaUsesOpenAiApi: _isOllamaV1Url,
    );
    return _sendBoundedJsonRequest(
      request.method,
      _buildProviderEndpointUri(
        request.path,
        query: request.query.isEmpty ? null : request.query,
      ),
      headers: request.headers,
      jsonBody: request.body,
      timeout: const Duration(seconds: 30),
      maxResponseBytes: _maxModelResponseBytes,
    );
  }

  Future<void> _fetchModels() async {
    if (_isLoadingModels) return;

    setState(() {
      _isLoadingModels = true;
      _statusMessage = null;
      _errorMessage = null;
    });

    final ticket = _requestCoordinator.beginModelRequest(_settingsSnapshot());
    try {
      if (!await _confirmCredentialTransmission()) return;
      await _persistSettingsNow();
      if (!mounted ||
          !_requestCoordinator.canPublishModelRequest(
            ticket,
            currentConfiguration: _settingsSnapshot(),
          )) {
        return;
      }
      final _ProviderPreset preset = _selectedProviderPreset();
      final http.Response response = await _readModelsResponse();
      if (!mounted ||
          !_requestCoordinator.canPublishModelRequest(
            ticket,
            currentConfiguration: _settingsSnapshot(),
          )) {
        return;
      }

      CopilotErrorPolicy.ensureSuccessfulStatus(
        response.statusCode,
        operation: CopilotOperation.listModels,
      );

      final Object? decoded = jsonDecode(response.body);
      final List<String> models = CopilotProviderAdapter.extractModelIds(
        decoded,
        preset.protocol,
      );
      if (models.isEmpty) {
        throw const CopilotFailure(
          code: CopilotFailureCode.invalidResponse,
          userMessage: "回應中沒有可用模型。",
        );
      }

      setState(() {
        _availableModels = models;
        if (!_availableModels.contains(_modelController.text.trim())) {
          _modelController.text = _availableModels.first;
        }
        _statusMessage = context.l10n.uiModelsRetrieved(
          context.formats.integer(_availableModels.length),
        );
      });
      await _persistSettingsNow();
    } catch (e) {
      if (mounted &&
          _requestCoordinator.canPublishModelRequest(
            ticket,
            currentConfiguration: _settingsSnapshot(),
          )) {
        setState(() => _errorMessage = _describeCopilotError(e));
      }
    } finally {
      if (mounted && _requestCoordinator.ownsModelRequest(ticket)) {
        setState(() => _isLoadingModels = false);
      }
    }
  }

  Future<http.Response> _readChatResponse(
    String model, {
    required CopilotMode requestMode,
    String mnprojStructureReference = "",
  }) {
    final _ProviderPreset preset = _selectedProviderPreset();
    final String apiKey = _apiKeyController.text.trim();
    final request = CopilotProviderAdapter.chatRequest(
      protocol: preset.protocol,
      apiKey: apiKey,
      model: model,
      systemInstruction: CopilotPromptPolicy.systemInstruction(
        requestMode,
        mnprojStructureReference: mnprojStructureReference,
      ),
      messages: _providerMessages(),
      ollamaUsesOpenAiApi: _isOllamaV1Url,
      maxOutputTokens: _maxOutputTokens,
    );
    return _sendBoundedJsonRequest(
      request.method,
      _buildProviderEndpointUri(
        request.path,
        query: request.query.isEmpty ? null : request.query,
      ),
      headers: request.headers,
      jsonBody: request.body,
      timeout: const Duration(seconds: 60),
      maxResponseBytes: _maxChatResponseBytes,
    );
  }

  CopilotContextSnapshot _captureCurrentChapterContext({
    CopilotContextScope scope = CopilotContextScope.currentChapter,
  }) {
    final selection = ref.read(editorSelectionProvider);
    final chapterId = selection.selectedChapID;
    if (chapterId == null) {
      throw const FormatException("請先選擇章節，再使用 Ask／Plan 模式。");
    }
    final location = chapter_model.ChapterTree.findChapter(
      ref.read(segmentsDataProvider),
      folderId: selection.selectedSegID,
      chapterId: chapterId,
    );
    if (location == null) {
      throw const FormatException("找不到目前章節，請重新選擇章節。");
    }
    final supplementalResources = switch (scope) {
      CopilotContextScope.currentChapter => const <CopilotContextResource>[],
      CopilotContextScope.currentChapterWithProjectOverview =>
        <CopilotContextResource>[
          CopilotProjectContextBuilder.buildOverview(
            ref.read(projectDataProvider),
          ),
        ],
      CopilotContextScope.currentChapterWithSelectedResources =>
        CopilotProjectContextBuilder.buildSelectedResources(
          ref.read(projectDataProvider),
          selectionKeys: _selectedResourceKeys,
          glossaryEntries: ref.read(glossaryStateProvider).entryIndex,
        ),
    };
    if (scope == CopilotContextScope.currentChapterWithSelectedResources &&
        supplementalResources.isEmpty) {
      throw const FormatException("請至少選擇一個仍存在的補充資源。");
    }
    return CopilotContextSnapshot.currentChapter(
      chapterId: chapterId,
      title: location.chapter.chapterName,
      content: ref.read(selectedChapterStoredContentProvider) ?? "",
      supplementalResources: supplementalResources,
    );
  }

  Future<bool> _confirmContextTransmission(
    CopilotContextSnapshot context,
  ) async {
    final uri = _buildEndpointUri("");
    final destination = "${uri.scheme}://${uri.authority}";
    if (_confirmedContextHost == destination) return true;
    final supplementalDescription = context.supplementalResources.isEmpty
        ? ""
        : this.context.l10n.uiAlongWith(
            (context.supplementalResources
                    .map((resource) => resource.title)
                    .join("、"))
                .toString(),
          );
    final approved = await showDialog<bool>(
      context: this.context,
      builder: (dialogContext) => AlertDialog(
        title: Text(dialogContext.l10n.uiSendYourWorkSContent),
        content: Text(
          dialogContext.l10n.uiThisModeSendsTheCurrentChapterToData(
            (context.title).toString(),
            (supplementalDescription).toString(),
            (destination).toString(),
            (_apiKeyController.text.trim().isEmpty
                    ? ""
                    : dialogContext.l10n.uiYourConfiguredAPIKeyWillAlsoBeSent)
                .toString(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(dialogContext.l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(dialogContext.l10n.uiAllowThisConnection),
          ),
        ],
      ),
    );
    if (approved == true) {
      _confirmedContextHost = destination;
      if (_apiKeyController.text.trim().isNotEmpty) {
        _confirmedCredentialHost = destination;
      }
      return true;
    }
    return false;
  }

  Future<bool> _confirmCredentialTransmission() async {
    if (_apiKeyController.text.trim().isEmpty) return true;
    final uri = _buildEndpointUri("");
    final destination = "${uri.scheme}://${uri.authority}";
    if (_confirmedCredentialHost == destination) return true;
    final approved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(dialogContext.l10n.uiSendAPIKey),
        content: Text(
          dialogContext.l10n.uiTheAPIKeyWillBeSentDirectlyTo(
            (destination).toString(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(dialogContext.l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(dialogContext.l10n.uiAllowThisConnection),
          ),
        ],
      ),
    );
    if (approved == true) {
      _confirmedCredentialHost = destination;
      return true;
    }
    return false;
  }

  void _cancelActiveRequest() {
    if (!_isSending) return;
    _transport.cancel();
    setState(() {
      final restoredPrompt = _conversationController.cancel();
      if (restoredPrompt != null) {
        _messageController.text = restoredPrompt;
      }
      _statusMessage = context.l10n.uiRequestCancelled;
      _errorMessage = null;
    });
  }

  Future<void> _sendMessage() async {
    if (_isSending || _selectedMode == CopilotMode.agent) return;

    final String prompt = _messageController.text.trim();
    final String model = _modelController.text.trim();
    if (prompt.isEmpty) return;

    if (model.isEmpty) {
      setState(() => _errorMessage = context.l10n.uiSelectOrEnterAModelFirst);
      return;
    }

    final requestMode = _selectedMode;
    CopilotContextSnapshot? requestContext;
    String mnprojStructureReference = "";
    String modelContent;
    try {
      if (requestMode == CopilotMode.ask || requestMode == CopilotMode.plan) {
        mnprojStructureReference = await _getMnprojStructureReference();
        requestContext = _captureCurrentChapterContext(
          scope: requestMode == CopilotMode.ask
              ? _selectedContextScope
              : CopilotContextScope.currentChapter,
        );
        if (!await _confirmContextTransmission(requestContext)) return;
      }
      if (!await _confirmCredentialTransmission()) return;
      modelContent = CopilotPromptPolicy.buildUserContent(
        mode: requestMode,
        prompt: prompt,
        context: requestContext,
      );
    } catch (error) {
      if (mounted) {
        setState(() => _errorMessage = _describeCopilotError(error));
      }
      return;
    }

    late final CopilotConversationOperation<_CopilotSettingsSnapshot> operation;
    setState(() {
      operation = _conversationController.begin(
        configuration: _settingsSnapshot(),
        mode: requestMode,
        prompt: prompt,
        modelContent: modelContent,
        createdAt: DateTime.now(),
        contextSnapshot: requestContext,
      );
      _messageController.clear();
      _statusMessage = null;
      _errorMessage = null;
    });
    _scrollConversationToBottom();

    try {
      await _persistSettingsNow();
      if (!mounted) return;
      if (!_conversationController.canPublish(
        operation,
        currentConfiguration: _settingsSnapshot(),
        currentMode: _selectedMode,
      )) {
        if (_conversationController.owns(operation)) {
          setState(() {
            final restoredPrompt = _conversationController.rollbackIfStale(
              operation,
              currentConfiguration: _settingsSnapshot(),
              currentMode: _selectedMode,
            );
            if (restoredPrompt != null) {
              _messageController.text = restoredPrompt;
              _statusMessage =
                  context.l10n.uiSettingsChangedThePreviousRequestWasCancelled;
            }
          });
        }
        return;
      }
      final _ProviderPreset preset = _selectedProviderPreset();
      final http.Response response = await _readChatResponse(
        model,
        requestMode: requestMode,
        mnprojStructureReference: mnprojStructureReference,
      );
      if (!mounted ||
          !_conversationController.canPublish(
            operation,
            currentConfiguration: _settingsSnapshot(),
            currentMode: _selectedMode,
          )) {
        if (mounted && _conversationController.owns(operation)) {
          setState(() {
            final restoredPrompt = _conversationController.rollbackIfStale(
              operation,
              currentConfiguration: _settingsSnapshot(),
              currentMode: _selectedMode,
            );
            if (restoredPrompt != null) {
              _messageController.text = restoredPrompt;
              _statusMessage = context
                  .l10n
                  .uiSettingsChangedThePreviousRequestResultWasDiscarded;
            }
          });
        }
        return;
      }

      CopilotErrorPolicy.ensureSuccessfulStatus(
        response.statusCode,
        operation: CopilotOperation.conversation,
      );

      final String reply = CopilotProviderAdapter.extractAssistantReply(
        jsonDecode(response.body),
        preset.protocol,
        ollamaUsesOpenAiApi: _isOllamaV1Url,
      );
      if (utf8.encode(reply).length > _maxUiHistoryBytes) {
        throw const FormatException("模型回覆超過 UI history 的 1 MiB 上限。");
      }
      final askResponse = requestMode == CopilotMode.ask
          ? CopilotAskResponse.tryParse(reply, context: requestContext!)
          : null;
      CopilotPlan? plan;
      String? planValidationError;
      if (requestMode == CopilotMode.plan) {
        try {
          plan = CopilotPlan.parse(reply, context: requestContext!);
        } on FormatException catch (error) {
          planValidationError = error.message;
        }
      }
      final assistantMessage = CopilotConversationMessage(
        role: CopilotConversationRole.assistant,
        content: askResponse?.answer ?? plan?.summary ?? reply,
        modelContent: reply,
        createdAt: DateTime.now(),
        mode: requestMode,
        contextSnapshot: requestContext,
        askResponse: askResponse,
        plan: plan,
        planValidationError: planValidationError,
      );
      setState(() {
        _conversationController.publish(
          operation,
          assistantMessage,
          currentConfiguration: _settingsSnapshot(),
          currentMode: _selectedMode,
        );
      });
      _scrollConversationToBottom();
    } catch (e) {
      if (mounted && _conversationController.owns(operation)) {
        setState(() {
          final failure = _conversationController.fail(
            operation,
            currentConfiguration: _settingsSnapshot(),
            currentMode: _selectedMode,
          );
          if (failure == null) return;
          _messageController.text = failure.restoredPrompt;
          if (failure.canReportError) {
            _errorMessage = _describeCopilotError(e);
          } else {
            _statusMessage = context
                .l10n
                .uiSettingsChangedThePreviousRequestResultWasDiscarded;
          }
        });
      }
    } finally {
      if (mounted && _conversationController.owns(operation)) {
        setState(() => _conversationController.complete(operation));
      }
    }
  }

  String _describeCopilotError(Object error) =>
      context.l10n.copilotError(error);

  void _clearConversation() {
    setState(() {
      _conversation.clear();
      _statusMessage = null;
      _errorMessage = null;
    });
  }

  Future<void> _clearStoredApiKey() async {
    if (_apiKeyController.text.isEmpty) {
      setState(() {
        _statusMessage = context.l10n.uiNoAPIKeyIsSaved;
        _errorMessage = null;
      });
      return;
    }
    final approved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(dialogContext.l10n.uiClearAPIKey),
        content: Text(dialogContext.l10n.uiThisRemovesTheAPIKeyFromThisDevice),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(dialogContext.l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(dialogContext.l10n.uiClearKey),
          ),
        ],
      ),
    );
    if (approved != true || !mounted) return;
    setState(() {
      _apiKeyController.clear();
      _confirmedCredentialHost = null;
      _statusMessage = null;
      _errorMessage = null;
    });
    try {
      await _persistSettingsNow();
      if (!mounted) return;
      setState(
        () => _statusMessage = context.l10n.uiAPIKeyRemovedFromThisDevice,
      );
    } catch (error, stackTrace) {
      debugPrint("Copilot API key removal failed: $error\n$stackTrace");
      if (!mounted) return;
      setState(
        () => _errorMessage = context.l10n.uiCouldNotRemoveTheAPIKeyTryAgain,
      );
    }
  }

  void _scrollConversationToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_conversationScrollController.hasClients) return;
      _conversationScrollController.animateTo(
        _conversationScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  Widget _buildWarningCard() {
    return AppNoticeBanner(
      message: context.l10n.uiAskPlanBetaAreControlledByFeatureFlags,
      tone: AppFeedbackTone.warning,
    );
  }

  Widget _buildModelPanel() {
    return AppSectionCard(
      padding: EdgeInsets.zero,
      useSectionLayout: false,
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      child: ExpansionTile(
        initiallyExpanded: _modelPanelExpanded,
        onExpansionChanged: (expanded) =>
            setState(() => _modelPanelExpanded = expanded),
        leading: const Icon(Icons.tune),
        title: Text(
          context.l10n.uiModelSelection,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        childrenPadding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          0,
          AppSpacing.xl,
          AppSpacing.xl,
        ),
        children: [
          Column(
            children: [
              const SizedBox(height: 16),
              ResponsiveSplitView(
                primary: _buildProviderField(),
                secondary: _buildApiUrlField(),
              ),
              const SizedBox(height: 16),
              ResponsiveSplitView(
                primary: _buildModelField(),
                secondary: _buildApiKeyField(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProviderField() {
    final String selectedProvider =
        _providerPresets.any(
          (preset) => preset.name == _providerController.text,
        )
        ? _providerController.text
        : _providerPresets.last.name;

    return AppDropdownField<String>(
      value: selectedProvider,
      labelText: context.l10n.uiProvider,
      options: _providerPresets
          .map(
            (preset) => DropdownOption(
              value: preset.name,
              label: preset == _providerPresets.last
                  ? context.l10n.uiCustom
                  : preset.name,
            ),
          )
          .toList(),
      onChanged: (value) {
        if (value != null) _selectProvider(value);
      },
    );
  }

  Widget _buildApiUrlField() {
    return AppTextField(
      key: const ValueKey<String>("copilot-api-url-field"),
      controller: _apiUrlController,
      labelText: "API URL",
      hintText: "https://api.openai.com/v1",
      prefixIcon: const Icon(Icons.link),
      onChanged: (_) => _scheduleSettingsSave(),
    );
  }

  Widget _buildModelField() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: RawAutocomplete<String>(
            textEditingController: _modelController,
            focusNode: _modelFocusNode,
            optionsBuilder: (TextEditingValue value) {
              final String query = value.text.trim().toLowerCase();
              if (query.isEmpty) return _availableModels;
              return _availableModels.where(
                (model) => model.toLowerCase().contains(query),
              );
            },
            fieldViewBuilder:
                (context, controller, focusNode, onFieldSubmitted) {
                  return AppTextField(
                    key: const ValueKey<String>("copilot-model-field"),
                    controller: controller,
                    focusNode: focusNode,
                    labelText: context.l10n.uiModel,
                    hintText: context.l10n.uiSelectOrEnterAModelID,
                    prefixIcon: const Icon(Icons.memory),
                    onChanged: (_) => _scheduleSettingsSave(),
                  );
                },
            optionsViewBuilder: (context, onSelected, options) {
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  elevation: 4,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 260,
                      maxWidth: 520,
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        final String option = options.elementAt(index);
                        return ListTile(
                          dense: true,
                          title: Text(option),
                          onTap: () {
                            onSelected(option);
                            _scheduleSettingsSave();
                          },
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: _isLoadingModels
              ? CircularProgressIndicator()
              : const Icon(Icons.refresh),
          tooltip: context.l10n.uiFetch,
          onPressed: _isLoadingModels ? null : _fetchModels,
          style: IconButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
      ],
    );
  }

  Widget _buildApiKeyField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          key: const ValueKey<String>("copilot-api-key-field"),
          controller: _apiKeyController,
          obscureText: !_showApiKey,
          labelText: "API Key",
          prefixIcon: const Icon(Icons.key),
          suffixIcon: IconButton(
            tooltip: _showApiKey
                ? context.l10n.uiHideAPIKey
                : context.l10n.uiShowAPIKey,
            onPressed: () => setState(() => _showApiKey = !_showApiKey),
            icon: Icon(_showApiKey ? Icons.visibility_off : Icons.visibility),
          ),
          onChanged: (_) => _scheduleSettingsSave(),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            key: const ValueKey<String>("copilot-clear-api-key"),
            onPressed: _isSending ? null : _clearStoredApiKey,
            icon: const Icon(Icons.key_off_outlined),
            label: Text(context.l10n.uiClearSavedKey),
          ),
        ),
      ],
    );
  }

  Widget _buildPrivacyAndLimitationsPanel() {
    return AppSectionCard(
      padding: EdgeInsets.zero,
      useSectionLayout: false,
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      child: ExpansionTile(
        key: const ValueKey<String>("copilot-privacy-limitations-panel"),
        leading: const Icon(Icons.privacy_tip_outlined),
        title: Text(context.l10n.uiPrivacyThirdPartyServicesAndLimitations),
        childrenPadding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          0,
          AppSpacing.xl,
          AppSpacing.xl,
        ),
        children: [
          SizedBox(height: 8),
          _CopilotDisclosureItem(
            icon: Icons.cloud_upload_outlined,
            text: context.l10n.uiChatSendsYourMessagesAskPlanAlsoSend,
          ),
          _CopilotDisclosureItem(
            icon: Icons.policy_outlined,
            text: context.l10n.uiWhetherAProviderStoresOrUsesDataDepends,
          ),
          _CopilotDisclosureItem(
            icon: Icons.history_outlined,
            text: context.l10n.uiConversationsAndPlansExistOnlyForThisScreen,
          ),
          _CopilotDisclosureItem(
            icon: Icons.warning_amber_outlined,
            text: context.l10n.uiAIResponsesMayBeIncorrectPlansAreFor,
          ),
        ],
      ),
    );
  }

  Widget _buildConversationPanel() {
    return AppSectionCard(
      padding: EdgeInsets.zero,
      useSectionLayout: false,
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: MediumTitle(
                    icon: Icons.forum_outlined,
                    text: context.l10n.uiConversationHistory,
                  ),
                ),
                TextButton.icon(
                  onPressed: _messages.isEmpty || _isSending
                      ? null
                      : _clearConversation,
                  icon: const Icon(Icons.delete_outline),
                  label: Text(context.l10n.uiClearAll),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CollectionPanel.custom(
              title: context.l10n.uiConversationHistory,
              showSectionCard: false,
              minHeight: 420,
              maxHeight: 420,
              content: _messages.isEmpty
                  ? AppEmptyState(
                      title: context.l10n.uiNoConversations,
                      description:
                          context.l10n.uiMessagesWillAppearHereAfterYouSendThem,
                      icon: Icons.chat_bubble_outline,
                      compact: true,
                    )
                  : ListView.separated(
                      controller: _conversationScrollController,
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      itemCount: _messages.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) =>
                          _buildMessageBubble(_messages[index]),
                    ),
            ),
            if (_statusMessage != null || _errorMessage != null) ...[
              const SizedBox(height: 12),
              _buildStatusMessage(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusMessage() {
    final bool hasError = _errorMessage != null;
    final Color color = hasError
        ? Theme.of(context).colorScheme.error
        : Theme.of(context).colorScheme.primary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          hasError ? Icons.error_outline : Icons.check_circle_outline,
          color: color,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            hasError ? _errorMessage! : _statusMessage!,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: color),
          ),
        ),
      ],
    );
  }

  Widget _buildMessageBubble(CopilotConversationMessage message) {
    final bool isUser = message.role == CopilotConversationRole.user;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color bubbleColor = isUser
        ? colorScheme.primaryContainer
        : colorScheme.secondaryContainer;
    final Color textColor = isUser
        ? colorScheme.onPrimaryContainer
        : colorScheme.onSecondaryContainer;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: AppSurfaceShape.borderRadius,
          ),
          child: Column(
            crossAxisAlignment: isUser
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isUser ? Icons.person_outline : Icons.auto_awesome,
                    size: 18,
                    color: textColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isUser ? context.l10n.uiYou : "Copilot",
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SelectableText(
                message.content,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: textColor,
                  height: 1.45,
                ),
              ),
              if (message.askResponse case final response?) ...[
                const SizedBox(height: 12),
                _buildAskDetails(response, message.contextSnapshot, textColor),
              ] else if (!isUser && message.mode == CopilotMode.ask) ...[
                const SizedBox(height: 8),
                Text(
                  context.l10n.uiTheModelSuppliedNoVerifiableStructuredSources,
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(color: textColor),
                ),
              ],
              if (message.plan case final plan?) ...[
                const SizedBox(height: 12),
                _buildPlanDetails(plan, message.contextSnapshot, textColor),
              ] else if (message.planValidationError case final error?) ...[
                const SizedBox(height: 8),
                Text(
                  context.l10n.uiCouldNotValidateThePlanTheOriginalResponse(
                    (error).toString(),
                  ),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAskDetails(
    CopilotAskResponse response,
    CopilotContextSnapshot? contextSnapshot,
    Color textColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (response.citations.isEmpty)
          Text(
            context.l10n.uiTheModelSuppliedNoVerifiableSources,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: textColor),
          )
        else ...[
          Text(
            context.l10n.uiSources,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final citation in response.citations)
                _buildCitationChip(citation, contextSnapshot),
            ],
          ),
        ],
        if (response.uncertainties.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            context.l10n.uiUncertain(
              (response.uncertainties.join("；")).toString(),
            ),
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: textColor),
          ),
        ],
        if (response.discardedInvalidCitations) ...[
          const SizedBox(height: 6),
          Text(
            context.l10n.uiInvalidSourcesSuppliedByTheModelWereIgnored,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: textColor),
          ),
        ],
      ],
    );
  }

  Widget _buildCitationChip(
    CopilotCitation citation,
    CopilotContextSnapshot? contextSnapshot,
  ) {
    final resource = contextSnapshot?.resourceById(citation.resourceId);
    VoidCallback? onOpen;
    if (resource?.resourceType == "chapter" && widget.onOpenChapter != null) {
      onOpen = () => widget.onOpenChapter!(citation.resourceId);
    } else if (resource != null &&
        resource.resourceType != "project" &&
        widget.onOpenResource != null) {
      onOpen = () =>
          widget.onOpenResource!(resource.resourceType, resource.resourceId);
    }
    return Tooltip(
      message: citation.quoteHint,
      child: onOpen == null
          ? Chip(
              avatar: const Icon(Icons.menu_book_outlined, size: 16),
              label: Text(citation.resourceTitle),
            )
          : ActionChip(
              avatar: const Icon(Icons.open_in_new_outlined, size: 16),
              label: Text(citation.resourceTitle),
              tooltip: context.l10n.uiOpenSource(
                (citation.quoteHint).toString(),
              ),
              onPressed: onOpen,
            ),
    );
  }

  bool _isContextStale(CopilotContextSnapshot? original) {
    if (original == null) return true;
    try {
      final current = _captureCurrentChapterContext();
      return current.resourceId != original.resourceId ||
          current.fingerprint != original.fingerprint;
    } on FormatException {
      return true;
    }
  }

  Future<void> _copyPlan(CopilotPlan plan) async {
    const encoder = JsonEncoder.withIndent("  ");
    await Clipboard.setData(
      ClipboardData(text: encoder.convert(plan.toJson())),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.l10n.uiPlanJSONCopied)));
  }

  String _planExportBaseName(CopilotPlan plan) {
    final sanitized = plan.goal
        .trim()
        .replaceAll(RegExp(r"[^\p{L}\p{N}_-]+", unicode: true), "_")
        .replaceAll(RegExp(r"_+"), "_")
        .replaceAll(RegExp(r"^_+|_+$"), "");
    final slug = sanitized.isEmpty
        ? "plan"
        : sanitized.substring(0, sanitized.length.clamp(0, 48));
    return "copilot_plan_$slug";
  }

  Future<void> _exportPlan(CopilotPlan plan) async {
    const encoder = JsonEncoder.withIndent("  ");
    try {
      final exported = await FileService.exportTextWithResult(
        content: encoder.convert(plan.toJson()),
        fileName: _planExportBaseName(plan),
        extension: ".json",
      );
      if (!mounted || !exported) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.uiPlanJSONExported)));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.uiCouldNotExportThePlanJSONCheckThe),
        ),
      );
    }
  }

  Widget _buildPlanDetails(
    CopilotPlan plan,
    CopilotContextSnapshot? originalContext,
    Color textColor,
  ) {
    final orderedSteps = [...plan.steps]
      ..sort((left, right) => left.order.compareTo(right.order));
    final isStale = _isContextStale(originalContext);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.55),
        borderRadius: AppSurfaceShape.borderRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  plan.goal,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _copyPlan(plan),
                icon: const Icon(Icons.copy_outlined),
                tooltip: context.l10n.uiCopyPlanJSON,
                color: textColor,
              ),
              IconButton(
                onPressed: () => _exportPlan(plan),
                icon: const Icon(Icons.download_outlined),
                tooltip: context.l10n.uiExportPlanJSON,
                color: textColor,
              ),
            ],
          ),
          if (isStale) ...[
            const SizedBox(height: 4),
            Text(
              context.l10n.uiTheCurrentChapterChangedThisPlanMayBe,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.error,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
          const SizedBox(height: 8),
          for (final step in orderedSteps)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Text(
                "${step.order}. ${step.proposal}\n${step.reason}",
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: textColor),
              ),
            ),
          if (plan.risks.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              context.l10n.uiRisk((plan.risks.join("；")).toString()),
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: textColor),
            ),
          ],
          if (plan.questions.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              context.l10n.uiToConfirm((plan.questions.join("；")).toString()),
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: textColor),
            ),
          ],
          const SizedBox(height: 6),
          Text(
            context.l10n.uiReadOnlyPlanNoChangesApplied,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  String _transmittedContextLabel() {
    if (_selectedMode != CopilotMode.ask) return context.l10n.uiCurrentChapter;
    return switch (_selectedContextScope) {
      CopilotContextScope.currentChapter => context.l10n.uiCurrentChapter,
      CopilotContextScope.currentChapterWithProjectOverview =>
        context.l10n.uiCurrentChapterAndProjectIndexSummary,
      CopilotContextScope.currentChapterWithSelectedResources =>
        context.l10n.uiCurrentChapterAndSelectedSupplementalResources,
    };
  }

  Widget _buildComposerPanel() {
    return AppSectionCard(
      padding: EdgeInsets.zero,
      useSectionLayout: false,
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_selectedMode == CopilotMode.ask ||
                _selectedMode == CopilotMode.plan) ...[
              AppNoticeBanner(
                message: context.l10n
                    .uiSendsDirectlyToYourConfiguredModelServiceWithout(
                      (_selectedMode == CopilotMode.ask ? "Ask" : "Plan")
                          .toString(),
                      (_transmittedContextLabel()).toString(),
                    ),
                tone: AppFeedbackTone.info,
              ),
              if (_selectedMode == CopilotMode.ask) ...[
                const SizedBox(height: 12),
                _buildContextScopeSelector(),
                if (_selectedContextScope ==
                    CopilotContextScope
                        .currentChapterWithSelectedResources) ...[
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FilledButton.tonalIcon(
                      onPressed: _isSending ? null : _selectContextResources,
                      icon: const Icon(Icons.library_add_check_outlined),
                      label: Text(
                        context.l10n.uiSelectSupplementalResources(
                          context.formats.integer(_selectedResourceKeys.length),
                          (CopilotProjectContextBuilder.maxSelectedResources)
                              .toString(),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
              const SizedBox(height: 8),
              Text(
                _currentContextSummary(),
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 16),
            ],
            Shortcuts(
              shortcuts: const {
                SingleActivator(LogicalKeyboardKey.enter):
                    _SendCopilotMessageIntent(),
              },
              child: Actions(
                actions: {
                  _SendCopilotMessageIntent:
                      CallbackAction<_SendCopilotMessageIntent>(
                        onInvoke: (_) {
                          unawaited(_sendMessage());
                          return null;
                        },
                      ),
                },
                child: AppTextField(
                  key: const ValueKey<String>("copilot-message-field"),
                  controller: _messageController,
                  enabled: _selectedMode != CopilotMode.agent && !_isSending,
                  minLines: 3,
                  maxLines: 8,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    hintText: switch (_selectedMode) {
                      CopilotMode.chat =>
                        context.l10n.uiEnterAMessageShiftEnterForANew,
                      CopilotMode.ask =>
                        context.l10n.uiAskAboutTheCurrentChapter,
                      CopilotMode.plan =>
                        context.l10n.uiDescribeTheChangesYouWantToPlan,
                      CopilotMode.agent => context.l10n.uiAgentIsUnavailable,
                    },
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(bottom: 56),
                      child: Icon(Icons.chat_bubble_outline),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildModeSelector(),
                const Spacer(),
                IconButton(
                  icon: _isSending
                      ? const Icon(Icons.stop_circle_outlined)
                      : const Icon(Icons.send),
                  tooltip: _isSending
                      ? context.l10n.uiCancelRequest
                      : context.l10n.uiSend,
                  onPressed: _isSending
                      ? _cancelActiveRequest
                      : _selectedMode == CopilotMode.agent
                      ? null
                      : _sendMessage,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              context.l10n.uiShiftEnterNewLineEnterSend,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeSelector() {
    return SizedBox(
      width: 180,
      child: AppDropdownField<CopilotMode>(
        key: const ValueKey<String>("copilot-mode-selector"),
        value: _selectedMode,
        labelText: context.l10n.uiModeSelection,
        options: [
          const DropdownOption<CopilotMode>(
            value: CopilotMode.chat,
            label: "Chat",
          ),
          DropdownOption<CopilotMode>(
            value: CopilotMode.ask,
            label: "Ask (Beta)",
          ),
          DropdownOption<CopilotMode>(
            value: CopilotMode.plan,
            label: "Plan (Beta)",
          ),
          DropdownOption<CopilotMode>(
            value: CopilotMode.agent,
            label: context.l10n.uiAgentUnavailable,
            enabled: false,
          ),
        ],
        onChanged: _isSending
            ? null
            : (value) {
                if (value == null) return;
                setState(() {
                  _selectedMode = value;
                  _statusMessage = null;
                  _errorMessage = null;
                });
              },
      ),
    );
  }

  Widget _buildContextScopeSelector() {
    return AppDropdownField<CopilotContextScope>(
      key: const ValueKey<String>("copilot-context-scope-selector"),
      value: _selectedContextScope,
      labelText: context.l10n.uiAskContext,
      options: [
        DropdownOption<CopilotContextScope>(
          value: CopilotContextScope.currentChapter,
          label: context.l10n.uiCurrentChapter,
        ),
        DropdownOption<CopilotContextScope>(
          value: CopilotContextScope.currentChapterWithProjectOverview,
          label: context.l10n.uiCurrentChapterProjectSummary,
        ),
        DropdownOption<CopilotContextScope>(
          value: CopilotContextScope.currentChapterWithSelectedResources,
          label: context.l10n.uiCurrentChapterSelectedResources,
        ),
      ],
      onChanged: _isSending
          ? null
          : (value) {
              if (value == null) return;
              setState(() => _selectedContextScope = value);
            },
    );
  }

  IconData _resourceIcon(String resourceType) {
    return switch (resourceType) {
      "character" => Icons.person_outline,
      "worldSetting" => Icons.public_outlined,
      "outlineEvent" => Icons.account_tree_outlined,
      "glossaryTerm" => Icons.menu_book_outlined,
      _ => Icons.description_outlined,
    };
  }

  Future<void> _selectContextResources() async {
    final options =
        widget.selectableResources ??
        CopilotProjectContextBuilder.selectableResources(
          ref.read(projectDataProvider),
          glossaryEntries: ref.read(glossaryStateProvider).entryIndex,
        );
    final availableKeys = options
        .map((resource) => resource.selectionKey)
        .toSet();
    final selected = _selectedResourceKeys
        .where(availableKeys.contains)
        .toSet();
    String query = "";
    final result = await showDialog<Set<String>>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          final normalizedQuery = query.trim().toLowerCase();
          final filtered = normalizedQuery.isEmpty
              ? options
              : options
                    .where(
                      (resource) =>
                          resource.title.toLowerCase().contains(
                            normalizedQuery,
                          ) ||
                          resource.description.toLowerCase().contains(
                            normalizedQuery,
                          ),
                    )
                    .toList(growable: false);
          final dialogHeight = (MediaQuery.sizeOf(dialogContext).height * 0.62)
              .clamp(280.0, 520.0);
          return AlertDialog(
            title: Text(dialogContext.l10n.uiSelectAskSupplementalResources),
            content: SizedBox(
              width: 620,
              height: dialogHeight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    key: const ValueKey<String>(
                      "copilot-resource-search-field",
                    ),
                    autofocus: true,
                    decoration: appFieldDecoration(
                      context,
                      decoration: InputDecoration(
                        labelText: dialogContext
                            .l10n
                            .uiSearchCharactersWorldbuildingOutlinesOrWords,
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                    onChanged: (value) => setDialogState(() => query = value),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    dialogContext.l10n.uiSelectedOnlySelectedResourcesAreSent(
                      context.formats.integer(selected.length),
                      (CopilotProjectContextBuilder.maxSelectedResources)
                          .toString(),
                    ),
                    style: Theme.of(dialogContext).textTheme.bodySmall,
                  ),
                  const Divider(height: 20),
                  Expanded(
                    child: filtered.isEmpty
                        ? Center(
                            child: Text(
                              dialogContext.l10n.uiNoMatchingResources,
                            ),
                          )
                        : ListView.builder(
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final resource = filtered[index];
                              final isSelected = selected.contains(
                                resource.selectionKey,
                              );
                              final canSelect =
                                  isSelected ||
                                  selected.length <
                                      CopilotProjectContextBuilder
                                          .maxSelectedResources;
                              return CheckboxListTile(
                                key: ValueKey<String>(
                                  "copilot-resource-${resource.selectionKey}",
                                ),
                                value: isSelected,
                                dense: true,
                                secondary: Icon(
                                  _resourceIcon(resource.resourceType),
                                ),
                                title: Text(resource.title),
                                subtitle: Text(resource.description),
                                onChanged: !canSelect
                                    ? null
                                    : (checked) {
                                        setDialogState(() {
                                          if (checked == true) {
                                            selected.add(resource.selectionKey);
                                          } else {
                                            selected.remove(
                                              resource.selectionKey,
                                            );
                                          }
                                        });
                                      },
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: selected.isEmpty
                    ? null
                    : () => setDialogState(selected.clear),
                child: Text(dialogContext.l10n.uiClear),
              ),
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(dialogContext.l10n.commonCancel),
              ),
              FilledButton(
                onPressed: () => Navigator.of(
                  dialogContext,
                ).pop(Set<String>.unmodifiable(selected)),
                child: Text(dialogContext.l10n.uiUseSelection),
              ),
            ],
          );
        },
      ),
    );
    if (!mounted || result == null) return;
    setState(() => _selectedResourceKeys = result);
  }

  String _currentContextSummary() {
    try {
      final snapshot = _captureCurrentChapterContext();
      final bytes = utf8.encode(snapshot.content).length;
      final suffix = snapshot.truncated ? context.l10n.uiTruncated : "";
      final overviewLabel =
          _selectedMode == CopilotMode.ask &&
              _selectedContextScope ==
                  CopilotContextScope.currentChapterWithProjectOverview
          ? context.l10n.uiProjectIndexSummaryUpToKiB
          : _selectedMode == CopilotMode.ask &&
                _selectedContextScope ==
                    CopilotContextScope.currentChapterWithSelectedResources
          ? context.l10n.uiSelectedResourcesUpToKiB(
              context.formats.integer(_selectedResourceKeys.length),
            )
          : "";
      return context.l10n.uiContextBytes(
        (snapshot.title).toString(),
        (bytes).toString(),
        (suffix).toString(),
        (overviewLabel).toString(),
      );
    } on FormatException {
      return context.l10n.uiContextNoChapterSelected;
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(editorSelectionProvider);
    ref.watch(segmentsDataProvider);
    ref.watch(selectedChapterStoredContentProvider);
    return Scaffold(
      body: AppPageScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: LargeTitle(icon: Icons.auto_awesome, text: "Copilot"),
            ),
            const SizedBox(height: 32),
            _buildWarningCard(),
            const SizedBox(height: 16),
            _buildModelPanel(),
            const SizedBox(height: 16),
            _buildPrivacyAndLimitationsPanel(),
            const SizedBox(height: 16),
            _buildConversationPanel(),
            const SizedBox(height: 16),
            _buildComposerPanel(),
          ],
        ),
      ),
    );
  }
}

class _CopilotDisclosureItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _CopilotDisclosureItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
