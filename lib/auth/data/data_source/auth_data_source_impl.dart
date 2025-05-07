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
    // TODO(jh): 회원가입 수정 예정
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
            .from('user_private')
            .select()
            .eq('user_email', email)
            .maybeSingle();

    return response != null;
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
