import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthDataSource {
  Future<void> login(String email, String password);
  Future<AuthResponse> signUp(String email, String password);
  Future<void> logout();
  Future<bool> isEmailExist(String email);
}
