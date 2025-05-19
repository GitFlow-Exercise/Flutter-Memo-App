import 'dart:async';
import 'package:mongo_ai/auth/data/data_source/auth_data_source.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockAuthDataSourceImpl implements AuthDataSource {
  final _authController = StreamController<AuthState>.broadcast();
  bool _isAuthenticated = false;
  static const email = 'test@test.com';
  final AuthResponse _authResponse = AuthResponse(
    session: null,
    user: const User(
      id: 'id',
      email: email,
      appMetadata: {},
      userMetadata: {},
      aud: 'aud',
      createdAt: 'createdAt',
    ),
  );

  MockAuthDataSourceImpl() {
    // 초기 상태: signedIn
    _authController.add(const AuthState(AuthChangeEvent.signedIn, null));
  }

  @override
  Stream<AuthState> get authStateChanges => _authController.stream;

  @override
  Future<void> login(String email, String password) async {
    // 네트워크 지연 시뮬레이션
    await Future.delayed(const Duration(milliseconds: 200));
    _isAuthenticated = true;
    // 로그인 후 signedIn 이벤트 발행
    _authController.add(const AuthState(AuthChangeEvent.signedIn, null));
  }

  @override
  Future<void> signInWithGoogle(String redirectUrl) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _isAuthenticated = true;
    _authController.add(const AuthState(AuthChangeEvent.signedIn, null));
  }

  @override
  Future<AuthResponse> signUp(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 200));
    // 더미 AuthResponse 반환
    return _authResponse;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _isAuthenticated = false;
    _authController.add(const AuthState(AuthChangeEvent.signedOut, null));
  }

  @override
  Future<void> deleteUser(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    // 사용자 삭제 시뮬레이션
  }

  @override
  Future<bool> isEmailExist(String email) async {
    await Future.delayed(const Duration(milliseconds: 100));
    // '@' 포함 여부로 체크
    return email.contains('@');
  }

  @override
  Future<void> saveUser() async {
    await Future.delayed(const Duration(milliseconds: 100));
    // 사용자 정보 저장 시뮬레이션
  }

  @override
  Future<void> sendOtp(String email) async {
    await Future.delayed(const Duration(milliseconds: 100));
    // OTP 전송 시뮬레이션
  }

  @override
  Future<AuthResponse> verifyEmailOtp(String email, String otp) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _authResponse;
  }

  @override
  Future<AuthResponse> verifyMagicLinkOtp(String email, String otp) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _authResponse;
  }

  @override
  Future<UserResponse> resetPassword(String email) async {
    await Future.delayed(const Duration(milliseconds: 200));
    // 더미 UserResponse 반환
    return UserResponse.fromJson(<String, dynamic>{});
  }

  @override
  Future<String?> getCurrentUserEmail() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _isAuthenticated ? email : null;
  }

  @override
  Future<void> updateUserMetadata(String key) async {}

  @override
  bool isAuthenticated() => _isAuthenticated;

  @override
  bool isInitialSetupUser() => false;

  @override
  bool isSelectTeam() => false;

  @override
  String? userId() => _isAuthenticated ? 'mock-user-id' : null;

  @override
  bool checkMetadata(String key) => false;

  @override
  String? getUserProvider() => _isAuthenticated ? 'email' : null;
}
