import 'package:mongo_ai/auth/data/data_source/auth_data_source.dart';
import 'package:mongo_ai/core/constants/app_table_name.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthDataSourceImpl implements AuthDataSource {
  final SupabaseClient _client;

  AuthDataSourceImpl({required SupabaseClient client}) : _client = client;

  @override
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  @override
  Future<void> login(String email, String password) async {
    await _client.auth.signInWithPassword(email: email, password: password);
  }

  @override
  Future<void> signInWithGoogle() async {
    final origin = Uri.base.origin;
    final redirectUrl = '$origin/auth/callback';
    await _client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: redirectUrl,
    );
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
  Future<void> deleteUser(String id) async {
    await _client.auth.admin.deleteUser(id);
  }

  @override
  Future<bool> isEmailExist(String email) async {
    final response =
        await _client
            .from(AppTableName.users)
            .select()
            .eq('user_email', email)
            .maybeSingle();

    return response != null;
  }

  @override
  Future<void> saveUser() async {
    await _client.from(AppTableName.users).insert({
      'user_id': _client.auth.currentUser?.id,
      'user_name': _client.auth.currentUser?.email?.split('@')[0],
      'user_email': _client.auth.currentUser?.email,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  @override
  Future<UserResponse> resetPassword(String password) async {
    final response = await _client.auth.updateUser(
      UserAttributes(password: password),
    );

    return response;
  }

  @override
  Future<void> sendOtp(String email) async {
    await _client.auth.signInWithOtp(email: email);
  }

  @override
  Future<AuthResponse> verifyEmailOtp(String email, String otp) async {
    final response = await _client.auth.verifyOTP(
      email: email,
      token: otp,
      type: OtpType.email,
    );

    return response;
  }

  @override
  Future<AuthResponse> verifyMagicLinkOtp(String email, String otp) async {
    final response = await _client.auth.verifyOTP(
      email: email,
      token: otp,
      type: OtpType.magiclink,
    );

    return response;
  }

  @override
  bool isAuthenticated() {
    final user = _client.auth.currentUser;
    if (user == null) {
      return false;
    }
    return true;
  }

  @override
  Future<void> updateUserMetadata(String key) async {
    await _client.auth.updateUser(UserAttributes(data: {key: true}));
  }

  @override
  Future<void> saveSelectedTeamId(int teamId) async {
    await _client.auth.updateUser(
      UserAttributes(data: {'current_team_id': teamId}),
    );
  }

  @override
  int? getSelectedTeamId() {
    final metadata = _client.auth.currentUser?.userMetadata;
    if (metadata != null && metadata.containsKey('current_team_id')) {
      return metadata['current_team_id'] as int?;
    }
    return null;
  }

  @override
  Future<String?> getCurrentUserEmail() async {
    return _client.auth.currentUser?.email;
  }

  @override
  bool isInitialSetupUser() {
    return checkMetadata('is_initial_setup_user');
  }

  @override
  bool isSelectTeam() {
    return checkMetadata('is_select_team');
  }

  @override
  String? userId() {
    return _client.auth.currentUser?.id;
  }

  @override
  bool checkMetadata(String key) {
    return _client.auth.currentUser?.userMetadata?[key] == true;
  }

  @override
  String? getUserProvider() {
    final user = _client.auth.currentUser;
    return user?.appMetadata['provider'] as String?;
  }
}
