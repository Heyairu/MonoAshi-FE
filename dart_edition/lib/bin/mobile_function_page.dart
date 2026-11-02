/*
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
 ************************************************************/

import 'package:monogatari_assistant/l10n/app_localization.dart';
import "package:flutter/material.dart";

import "dart:math" as math;

import "slidebar.dart";
import "../ui_library/mobile_editor_insets.dart";
import "../presentation/widgets/radial_gauge_dashboard.dart";
import "punctuation_panel.dart";

class MonogatariMobileLayout extends StatefulWidget {
  final bool isEditorMode;
  final int selectedIndex;
  final Widget functionPage;
  final Widget editorPage;
  final Widget statusBar;
  final Widget Function(VoidCallback onClose) dashboardBuilder;
  final ValueChanged<int> onDestinationSelected;

  const MonogatariMobileLayout({
    super.key,
    required this.isEditorMode,
    required this.selectedIndex,
    required this.functionPage,
    required this.editorPage,
    required this.statusBar,
    required this.dashboardBuilder,
    required this.onDestinationSelected,
  });

  @override
  State<MonogatariMobileLayout> createState() => _MonogatariMobileLayoutState();
}

class _MonogatariMobileLayoutState extends State<MonogatariMobileLayout> {
  bool _dashboardOpen = false;

  void _closeDashboard() => setState(() => _dashboardOpen = false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The outer workspace Scaffold already applies the keyboard inset.
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        top: false,
        bottom: false,
        child: MonogatariNavigationLayout(
          modal: true,
          selectedIndex: widget.selectedIndex,
          onDestinationSelected: widget.onDestinationSelected,
          modalLauncherBuilder: (context, openDrawer, focusNode) => Positioned(
            left:
                MobileEditorInsets.edge +
                (RadialGaugeDashboard.panelWidth -
                        MobileEditorInsets.buttonSize) /
                    2,
            bottom: MobileEditorInsets.edge,
            child: SizedBox.square(
              dimension: MobileEditorInsets.buttonSize,
              child: FloatingActionButton.large(
                key: const Key("mobile-navigation-button"),
                heroTag: null,
                focusNode: focusNode,
                tooltip: context.l10n.uiExpandNavigation,
                shape: const CircleBorder(),
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest,
                foregroundColor: Theme.of(context).colorScheme.primary,
                elevation: 0,
                focusElevation: 0,
                hoverElevation: 0,
                highlightElevation: 0,
                disabledElevation: 0,
                onPressed: () {
                  if (_dashboardOpen) _closeDashboard();
                  openDrawer();
                },
                child: const Icon(Icons.menu_rounded, size: 24),
              ),
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) => Stack(
              children: [
                Positioned.fill(
                  child: IndexedStack(
                    index: widget.isEditorMode ? 1 : 0,
                    children: [widget.functionPage, widget.editorPage],
                  ),
                ),
                if (_dashboardOpen)
                  Positioned.fill(
                    child: GestureDetector(
                      key: const Key("mobile-dashboard-dismiss-area"),
                      behavior: HitTestBehavior.opaque,
                      onTap: _closeDashboard,
                      child: const SizedBox.expand(),
                    ),
                  ),
                if (_dashboardOpen)
                  Positioned(
                    key: const Key("mobile-dashboard-capsule"),
                    right: MobileEditorInsets.edge,
                    bottom: MobileEditorInsets.edge,
                    width: RadialGaugeDashboard.panelWidth,
                    height: math.min(
                      560,
                      math.max(
                        0,
                        constraints.maxHeight - MobileEditorInsets.edge * 2,
                      ),
                    ),
                    child: widget.dashboardBuilder(_closeDashboard),
                  )
                else
                  Positioned(
                    right:
                        MobileEditorInsets.edge +
                        (RadialGaugeDashboard.panelWidth -
                                MobileEditorInsets.buttonSize) /
                            2,
                    bottom: MobileEditorInsets.edge,
                    child: SizedBox.square(
                      dimension: MobileEditorInsets.buttonSize,
                      child: FloatingActionButton.large(
                        key: const Key("mobile-dashboard-button"),
                        heroTag: null,
                        tooltip: context.l10n.uiOpenDashboard,
                        shape: const CircleBorder(),
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        elevation: 0,
                        focusElevation: 0,
                        hoverElevation: 0,
                        highlightElevation: 0,
                        disabledElevation: 0,
                        onPressed: () => setState(() => _dashboardOpen = true),
                        child: const ExcludeSemantics(
                          child: RadialGaugePreview(),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(top: false, child: widget.statusBar),
    );
  }
}

class MonogatariMobileFunctionPage extends StatelessWidget {
  final bool showPunctuationPanel;
  final ValueChanged<String> onInsertPunctuation;
  final VoidCallback onClosePunctuationPanel;
  final int pageCount;
  final int selectedIndex;
  final double fontSize;
  final Widget Function(int pageIndex) pageBuilder;

  const MonogatariMobileFunctionPage({
    super.key,
    required this.showPunctuationPanel,
    required this.onInsertPunctuation,
    required this.onClosePunctuationPanel,
    required this.pageCount,
    required this.selectedIndex,
    required this.fontSize,
    required this.pageBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showPunctuationPanel)
          PunctuationPanel(
            onInsert: onInsertPunctuation,
            onClose: onClosePunctuationPanel,
          ),

        Expanded(
          child: MobileModuleInsets(
            child: IndexedStack(
              key: const Key("mobile-module-pages"),
              index: selectedIndex.clamp(0, pageCount - 1),
              children: [for (var i = 0; i < pageCount; i++) pageBuilder(i)],
            ),
          ),
        ),
      ],
    );
  }
}
