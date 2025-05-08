import 'package:mongo_ai/auth/data/data_source/auth_data_source.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthDataSourceImpl implements AuthDataSource {
  final SupabaseClient _client;

  AuthDataSourceImpl({required SupabaseClient client}) : _client = client;

  @override
  Future<void> login(String email, String password) async {
    await _client.auth.signInWithPassword(email: email, password: password);
  }

  @override
  Future<void> logout() async {
    await _client.auth.signOut();
  }

  @override
  Future<AuthResponse> signUp(String email, String password) async {
    final authResponse = await _client.auth.signUp(
      email: email,
      password: password,
    );

    return authResponse;
  }

  @override
  Future<bool> isEmailExist(String email) async {
    final response =
        await _client
            .from('users')
            .select()
            .eq('user_email', email)
            .maybeSingle();

    return response != null;
  }

  @override
  Future<void> saveUser() async {
    await _client.from('users').insert({
      'user_id': _client.auth.currentUser?.id,
      'user_name': _client.auth.currentUser?.email?.split('@')[0],
      'user_email': _client.auth.currentUser?.email,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  @override
  bool isAuthenticated() {
    final user = _client.auth.currentUser;
    if (user == null) {
      return false;
    }
    return true;
  }
}
