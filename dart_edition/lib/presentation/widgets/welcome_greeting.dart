import '../../l10n/app_localization.dart';
import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../providers/global_state_providers.dart";

final welcomeClockProvider = Provider<DateTime Function()>(
  (ref) => DateTime.now,
);

class WelcomeGreeting extends ConsumerStatefulWidget {
  const WelcomeGreeting({super.key});

  @override
  ConsumerState<WelcomeGreeting> createState() => _WelcomeGreetingState();
}

class _WelcomeGreetingState extends ConsumerState<WelcomeGreeting> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayName =
        ref.watch(userProfileProvider).valueOrNull?.displayName.trim() ?? "";
    final l10n = context.l10n;
    final name = displayName.isEmpty ? l10n.welcomeUser : displayName;
    const marker = '\uFFFC';
    final message = switch (ref.watch(welcomeClockProvider)().hour) {
      >= 5 && < 12 => l10n.welcomeMorning(marker),
      >= 12 && < 17 => l10n.welcomeAfternoon(marker),
      >= 17 && < 22 => l10n.welcomeEvening(marker),
      _ => l10n.welcomeNight(marker),
    };
    final parts = message.split(marker);
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: parts.first),
          TextSpan(
            text: name,
            style: theme.textTheme.headlineLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w400,
            ),
          ),
          TextSpan(text: parts.last),
        ],
      ),
      key: const Key("welcome-greeting"),
      softWrap: true,
      style: theme.textTheme.headlineMedium?.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w200,
        height: 1.3,
      ),
    );
  }
}
