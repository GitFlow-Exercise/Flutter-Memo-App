import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthDataSource {
  Future<void> login(String email, String password);
  Future<AuthResponse> signUp(String email, String password);
  Future<void> logout();
  Future<bool> isEmailExist(String email);
  Future<void> saveUser();
  Future<void> sendOtp(String email);
  Future<AuthResponse> verifyOtp(String email, String otp);
  Future<UserResponse> resetPassword(String email);
  Future<String?> getCurrentUserEmail();
  Future<void> updateUserMetadata(String key);
  bool isAuthenticated();
  bool isInitialSetupUser();
  bool isSelectTeam();
}
