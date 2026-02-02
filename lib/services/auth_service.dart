import 'package:supabase_flutter/supabase_flutter.dart';

/// Auth state: uses Supabase session (no manual token storage).
class AuthService {
  static Session? get currentSession =>
      Supabase.instance.client.auth.currentSession;

  static Future<String?> getToken() async {
    return Supabase.instance.client.auth.currentSession?.accessToken;
  }

  static Future<void> logout() async {
    await Supabase.instance.client.auth.signOut();
  }

  static Future<bool> isLoggedIn() async {
    final session = Supabase.instance.client.auth.currentSession;
    return session != null;
  }

  static User? get currentUser => Supabase.instance.client.auth.currentUser;
}
