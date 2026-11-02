import 'package:flutter/foundation.dart';
import 'package:material_ribbon/material_ribbon.dart';
import 'generated/app_localizations.dart';

RibbonLocalizations localizedRibbon(
  AppLocalizations l10n,
  TargetPlatform platform,
) {
  // Material Ribbon handles Ctrl+F1 on every desktop platform.
  const shortcut = 'Ctrl+F1';
  return RibbonLocalizations(
    moreOptions: l10n.ribbonMoreOptions,
    customizeRibbon: l10n.ribbonCustomize,
    quickAccessToolbar: l10n.ribbonQuickAccess,
    ribbonTabs: l10n.ribbonTabs,
    done: l10n.ribbonDone,
    expandQuickAccessToolbar: l10n.ribbonExpandQuickAccess,
    collapseQuickAccessToolbar: l10n.ribbonCollapseQuickAccess,
    customizeQuickAccessToolbar: l10n.ribbonCustomizeQuickAccess,
    moreQuickAccessCommands: l10n.ribbonMoreQuickAccess,
    expandRibbon: l10n.ribbonExpand(shortcut),
    collapseRibbon: l10n.ribbonCollapse(shortcut),
    searchCommands: l10n.ribbonSearch,
    textColor: l10n.ribbonTextColor,
    color: l10n.ribbonColor,
    font: l10n.ribbonFont,
    increase: l10n.uiIncrease,
    decrease: l10n.uiDecrease,
    tabSemanticsPattern: l10n.ribbonTabSemantics('{label}'),
    moveTabUpPattern: l10n.ribbonMoveTabUp('{label}'),
    moveTabDownPattern: l10n.ribbonMoveTabDown('{label}'),
    commandsSemanticsPattern: l10n.ribbonCommandsSemantics('{label}'),
    groupSemanticsPattern: l10n.ribbonGroupSemantics('{label}'),
    tabNavigationSuffix: l10n.ribbonTabNavigation,
    resetToDefaults: l10n.ribbonReset,
  );
}
