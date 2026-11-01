import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../utils/welcome_greeting.dart";
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
    final greeting = welcomeGreetingParts(
      now: ref.watch(welcomeClockProvider)(),
      displayName: displayName,
    );
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: greeting.prefix),
          TextSpan(
            text: '${greeting.name}${greeting.suffix}',
            style: theme.textTheme.headlineLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w400,
            ),
          ),
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
