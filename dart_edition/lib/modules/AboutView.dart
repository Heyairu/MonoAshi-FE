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
import "package:flutter/material.dart";

import "../ui_library/layout.dart";
import "../ui_library/spacing.dart";
import "../ui_library/surface_shape.dart";

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppPageScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 應用圖標
            Container(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  "assets/icon/Title.png",

                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    // 如果圖片載入失敗，顯示預設圖標
                    return Icon(
                      Icons.edit_note,
                      size: 80,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 8),

            // 應用名稱
            Text(
              "MonoAshi v1 RC1",
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 8),

            // Codename
            Text(
              context.l10n.uiCodenameHana,
              style: Theme.of(context).textTheme.titleSmall,
            ),

            // 版本狀態
            // Text("RC1", style: Theme.of(context).textTheme.titleSmall),

            // Version
            Text("Ver 0.9.63", style: Theme.of(context).textTheme.labelLarge),

            const SizedBox(height: 32),

            // 描述
            Container(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Text(
                context.l10n.uiMonoAshiIsAWritingAssistantForAuthorsAnd,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 32),

            // 功能特點
            Container(
              constraints: const BoxConstraints(maxWidth: 600),
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: AppSurfaceShape.borderRadius,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.uiKeyFeatures,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureItem(
                    context,
                    Icons.book,
                    context.l10n.uiStorySettingsManagement,
                  ),
                  _buildFeatureItem(
                    context,
                    Icons.menu_book,
                    context.l10n.uiChapterAndParagraphEditing,
                  ),
                  _buildFeatureItem(
                    context,
                    Icons.list,
                    context.l10n.uiOutlinePlanning,
                  ),
                  _buildFeatureItem(
                    context,
                    Icons.public,
                    context.l10n.uiWorldbuilding,
                  ),
                  _buildFeatureItem(
                    context,
                    Icons.person,
                    context.l10n.uiCharacterDatabase,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // 版權信息
            Text(
              context.l10n.uiHeyairu,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Text(text, style: Theme.of(context).textTheme.labelLarge),
        ],
      ),
    );
  }
}
