import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthDataSource {
  Stream<AuthState> get authStateChanges;

  Session? get session;

  Future<void> login(String email, String password);

  Future<void> signInWithGoogle();

  Future<AuthResponse> signUp(String email, String password);

  Future<void> logout();

  Future<void> deleteUser(String id);

  Future<bool> isEmailExist(String email);

  Future<void> saveUser();

  Future<void> sendOtp(String email);

  Future<AuthResponse> verifyEmailOtp(String email, String otp);

  Future<AuthResponse> verifyMagicLinkOtp(String email, String otp);

  Future<UserResponse> resetPassword(String email);

  Future<String?> getCurrentUserEmail();

  Future<void> updateUserMetadata(String key, bool isSelect);

  Future<void> saveSelectedTeamId(int teamId);

  int? getSelectedTeamId();

  bool isAuthenticated();

  bool isInitialSetupUser();

  bool isPreferredTeamSelected();

  String? userId();

  bool checkMetadata(String key);

  String? getUserProvider();
}
