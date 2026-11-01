String welcomeGreeting({required DateTime now, required String displayName}) {
  final parts = welcomeGreetingParts(now: now, displayName: displayName);
  return '${parts.prefix}${parts.name}${parts.suffix}';
}

({String prefix, String name, String suffix}) welcomeGreetingParts({
  required DateTime now,
  required String displayName,
}) {
  final period = switch (now.hour) {
    >= 5 && < 12 => "Morning",
    >= 12 && < 17 => "Afternoon",
    >= 17 && < 22 => "Evening",
    _ => "Night",
  };
  final name = displayName.trim();
  return (
    prefix: "Good $period, \n",
    name: name.isEmpty ? "User" : name,
    suffix: "!",
  );
}
