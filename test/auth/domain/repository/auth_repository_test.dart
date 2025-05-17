import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mongo_ai/auth/data/data_source/auth_data_source.dart';
import 'package:mongo_ai/auth/data/repository/auth_repository_impl.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@GenerateMocks([AuthDataSource, UserResponse])
import 'auth_repository_test.mocks.dart';

class MockAuthStateStream extends Stream<AuthState> {
  final StreamController<AuthState> _controller = StreamController<AuthState>();

  void emit(AuthState state) {
    _controller.add(state);
  }

  @override
  StreamSubscription<AuthState> listen(
    void Function(AuthState event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return _controller.stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}

void main() {
  late MockAuthDataSource mockAuthDataSource;
  late AuthRepositoryImpl authRepository;
  late MockAuthStateStream mockAuthStateStream;

  setUp(() {
    mockAuthDataSource = MockAuthDataSource();
    mockAuthStateStream = MockAuthStateStream();

    // authStateChanges 스텁 설정
    when(
      mockAuthDataSource.authStateChanges,
    ).thenAnswer((_) => mockAuthStateStream);

    // isAuthenticated, isInitialSetupUser, isSelectTeam 스텁 설정
    when(mockAuthDataSource.isAuthenticated()).thenReturn(true);
    when(mockAuthDataSource.isInitialSetupUser()).thenReturn(true);
    when(mockAuthDataSource.isSelectTeam()).thenReturn(true);

    authRepository = AuthRepositoryImpl(authDataSource: mockAuthDataSource);
  });

  group('signIn 테스트', () {
    test('로그인이 성공했을 때 Success를 반환해야 한다.', () async {
      final email = 'test@example.com';
      final password = 'password123';

      when(mockAuthDataSource.login(email, password)).thenAnswer((_) async {});

      final result = await authRepository.signIn(email, password);

      switch (result) {
        case Success():
          break;
        case Error():
          // 실패 할 때만
          fail('로그인을 성공해야 하지만 Error가 반환되었습니다.');
      }

      verify(mockAuthDataSource.login(email, password)).called(1);
    });

    test('로그인이 실패했을 때 Error를 반환해야 한다.', () async {
      final email = 'test@example.com';
      final password = 'password123';

      when(
        mockAuthDataSource.login(email, password),
      ).thenThrow(const AuthException('Invalid credentials'));

      final result = await authRepository.signIn(email, password);

      switch (result) {
        case Success():
          fail('로그인을 실패해야 하지만 Success가 반환되었습니다.');
        case Error():
          expect(result.error.message, '이메일 또는 비밀번호가 일치하지 않습니다.');
      }

      verify(mockAuthDataSource.login(email, password)).called(1);
    });
  });

  // OTP 검증 테스트
  group('verifyEmailOtp 테스트', () {
    test('OTP 검증이 성공하면 Success를 반환해야 한다.', () async {
      final email = 'test@example.com';
      final otp = '123456';
      final authResponse = AuthResponse(
        session: null,
        user: const User(
          id: '1',
          appMetadata: {},
          userMetadata: {},
          aud: '',
          createdAt: '',
        ),
      );

      when(
        mockAuthDataSource.verifyEmailOtp(email, otp),
      ).thenAnswer((_) async => authResponse);

      final result = await authRepository.verifyEmailOtp(email, otp);

      switch (result) {
        case Success():
          break;
        case Error():
          fail('검증에 성공해야 했지만 에러를 반환되었습니다.');
      }

      verify(mockAuthDataSource.verifyEmailOtp(email, otp)).called(1);
    });
  });

  group('handleGoogleSignIn 테스트', ()
  {
    test('새 사용자를 저장하고 Success를 반환해야 합니다', () async {
      // 준비: 모의 객체의 동작 설정
      final user = const User(
        id: '1',
        appMetadata: {'provider': 'google'},
        userMetadata: {},
        aud: '',
        createdAt: '',
      );

      // 새 사용자(is_initial_setup_user가 false)로 설정
      when(
        mockAuthDataSource.checkMetadata('is_initial_setup_user'),
      ).thenReturn(false);
      when(mockAuthDataSource.saveUser()).thenAnswer((_) async {});
      when(
        mockAuthDataSource.updateUserMetadata('is_initial_setup_user'),
      ).thenAnswer((_) async {});

      final result = await authRepository.handleGoogleSignIn(user);

      switch (result) {
        case Success():
          break;
        case Error():
          fail('구글 로그인 사용자를 저장에 Success를 반환해야하지만 Error를 반환했습니다.');
      }

      verify(mockAuthDataSource.saveUser()).called(1);
    });

    test('기존 사용자를 저장하지 않고 Success를 반환해야합니다', () async {
      final user = const User(
        id: '1',
        appMetadata: {'provider': 'google'},
        userMetadata: {'is_initial_setup_user': true},
        aud: '',
        createdAt: '',
      );

      when(
        mockAuthDataSource.checkMetadata('is_initial_setup_user'),
      ).thenReturn(true);

      final result = await authRepository.handleGoogleSignIn(user);

      switch (result) {
        case Success():
          break;
        case Error():
          fail('구글 로그인 사용자를 저장하지 않고 Success를 반환해야 하지만 Error를 반환했습니다.');
      }

      // 기존 사용자이므로 saveUser가 호출되지 않아야 함
      verifyNever(mockAuthDataSource.saveUser());
    });

    test('Google 로그인이 성공했을 때 Success를 반환해야 한다', () async {
      when(mockAuthDataSource.signInWithGoogle()).thenAnswer((_) async {});

      final result = await authRepository.signInWithGoogle();

      switch (result) {
        case Success():
          break;
        case Error():
          fail('Google 로그인이 성공해야 하지만 Error가 반환되었습니다.');
      }

      verify(mockAuthDataSource.signInWithGoogle()).called(1);
    });

    test('Google 로그인이 실패했을 때 Error를 반환해야 한다', () async {
      when(mockAuthDataSource.signInWithGoogle())
          .thenThrow(const AuthException('Google login failed'));

      final result = await authRepository.signInWithGoogle();

      switch (result) {
        case Success():
          fail('Google 로그인이 실패해야 하지만 Success가 반환되었습니다.');
        case Error():
          expect(result.error.message, 'Google 로그인 중 오류가 발생했습니다.');
      }

      verify(mockAuthDataSource.signInWithGoogle()).called(1);
    });
  });


}
