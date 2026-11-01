import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_test/flutter_test.dart";
import "package:monogatari_assistant/data/repositories/user_profile_repository.dart";
import "package:monogatari_assistant/presentation/providers/global_state_providers.dart";
import "package:monogatari_assistant/presentation/widgets/welcome_greeting.dart";
import "package:monogatari_assistant/utils/welcome_greeting.dart";
import "package:shared_preferences/shared_preferences.dart";

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));

  for (final (hour, period) in [
    (0, "Night"),
    (4, "Night"),
    (5, "Morning"),
    (11, "Morning"),
    (12, "Afternoon"),
    (16, "Afternoon"),
    (17, "Evening"),
    (21, "Evening"),
    (22, "Night"),
    (23, "Night"),
  ]) {
    test("greeting at $hour uses $period and the configured display name", () {
      expect(
        welcomeGreeting(
          now: DateTime(2026, 10, 31, hour),
          displayName: "  伊琉  ",
        ),
        "Good $period, \n伊琉!",
      );
    });
  }

  test("skipped or blank name uses User", () {
    expect(
      welcomeGreeting(now: DateTime(2026, 10, 31, 8), displayName: "  "),
      "Good Morning, \nUser!",
    );
  });

  test("profile round trip trims names and keeps pen name opt-in", () async {
    final repository = UserProfileRepository();
    expect((await repository.load()).defaultPenName, isEmpty);
    await repository.save(const UserProfile(displayName: "  Writer  "));
    expect((await repository.load()).displayName, "Writer");
    expect((await repository.load()).defaultPenName, isEmpty);
    await repository.save(
      const UserProfile(displayName: "  Writer  ", useAsDefaultPenName: true),
    );
    expect((await repository.load()).defaultPenName, "Writer");
    await repository.save(
      const UserProfile(displayName: " ", useAsDefaultPenName: true),
    );
    expect((await repository.load()).useAsDefaultPenName, isFalse);
  });

  testWidgets("welcome greeting follows clock and saved profile changes", (
    tester,
  ) async {
    var now = DateTime(2026, 10, 31, 11, 59);
    SharedPreferences.setMockInitialValues({
      UserProfileRepository.displayNameKey: "Alice",
    });
    final container = ProviderContainer(
      overrides: [welcomeClockProvider.overrideWithValue(() => now)],
    );
    addTearDown(container.dispose);
    await container.read(userProfileProvider.future);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: Scaffold(body: WelcomeGreeting())),
      ),
    );
    expect(find.text("Good Morning, \nAlice!"), findsOneWidget);
    now = DateTime(2026, 10, 31, 12);
    await tester.pump(const Duration(minutes: 1));
    expect(find.text("Good Afternoon, \nAlice!"), findsOneWidget);
    await container
        .read(userProfileProvider.notifier)
        .save(const UserProfile(displayName: "Bob"));
    await tester.pump();
    expect(find.text("Good Afternoon, \nBob!"), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
}
