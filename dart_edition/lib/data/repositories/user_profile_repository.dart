import 'package:shared_preferences/shared_preferences.dart';

class UserProfile {
  const UserProfile({this.displayName = '', this.useAsDefaultPenName = false});

  final String displayName;
  final bool useAsDefaultPenName;

  String get defaultPenName => useAsDefaultPenName ? displayName.trim() : '';

  UserProfile get normalized => UserProfile(
    displayName: displayName.trim(),
    useAsDefaultPenName: useAsDefaultPenName && displayName.trim().isNotEmpty,
  );
}

/// A local display preference. The pen name is copied into new projects only.
class UserProfileRepository {
  static const displayNameKey = 'user_display_name';
  static const defaultPenNameKey = 'use_display_name_as_default_pen_name';

  Future<UserProfile> load() async {
    final prefs = await SharedPreferences.getInstance();
    return UserProfile(
      displayName: prefs.getString(displayNameKey) ?? '',
      useAsDefaultPenName: prefs.getBool(defaultPenNameKey) ?? false,
    ).normalized;
  }

  Future<void> save(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    final normalized = profile.normalized;
    if (!await prefs.setString(displayNameKey, normalized.displayName)) {
      throw StateError('無法保存名稱，請重試。');
    }
    if (!await prefs.setBool(
      defaultPenNameKey,
      normalized.useAsDefaultPenName,
    )) {
      throw StateError('無法保存預設筆名，請重試。');
    }
  }
}
