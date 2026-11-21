import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Returns a separate local history key for each signed-in Firebase account.
/// The old unscoped history is migrated once for the first account that opens it.
Future<String> mafixChatHistoryKey() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return 'mafix_ai_chat_history_guest_v2';

  final key = 'mafix_ai_chat_history_user_${user.uid}_v2';
  final prefs = await SharedPreferences.getInstance();
  if (!prefs.containsKey(key)) {
    const legacyKey = 'mafix_ai_chat_history_v1';
    final legacy = prefs.getString(legacyKey);
    if (legacy != null && legacy.isNotEmpty) {
      await prefs.setString(key, legacy);
    }
  }
  return key;
}
