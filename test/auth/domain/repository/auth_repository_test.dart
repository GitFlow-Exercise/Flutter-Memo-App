import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mongo_ai/auth/data/data_source/auth_data_source.dart';
import 'package:mongo_ai/auth/data/repository/auth_repository_impl.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// mockito가 모의 객체를 생성할 클래스 지정
@GenerateMocks([AuthDataSource])
import 'auth_repository_test.mocks.dart';

// Stream<AuthState>를 모킹하기 위한 클래스
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
  // 테스트에 필요한 변수 선언
  late MockAuthDataSource mockAuthDataSource;
  late AuthRepositoryImpl authRepository;
  late MockAuthStateStream mockAuthStateStream;

  // 각 테스트 전에 실행되는 setUp 함수
  setUp(() {
    // 모의 객체 생성
    mockAuthDataSource = MockAuthDataSource();
    mockAuthStateStream = MockAuthStateStream();

    // authStateChanges getter에 대한 스텁 설정
    when(
      mockAuthDataSource.authStateChanges,
    ).thenAnswer((_) => mockAuthStateStream);

    // isAuthenticated, isInitialSetupUser, isSelectTeam 메서드에 대한 스텁 설정
    when(mockAuthDataSource.isAuthenticated()).thenReturn(true);
    when(mockAuthDataSource.isInitialSetupUser()).thenReturn(true);
    when(mockAuthDataSource.isSelectTeam()).thenReturn(true);

    // 테스트할 객체 생성
    authRepository = AuthRepositoryImpl(authDataSource: mockAuthDataSource);
  });

  group('로그인 테스트', () {
    test('로그인이 성공했을 때 Success를 반환해야 한다.', () async {
      final email = 'test@example.com';
      final password = 'password123';

      when(mockAuthDataSource.login(email, password)).thenAnswer((_) async {});

      final result = await authRepository.signIn(email, password);

      switch (result) {
        case Success():
          break;
        case Error():
          // 실패할때만
          fail('로그인을 성공해야 하지만 Error가 반환되었습니다.');
      }

      verify(mockAuthDataSource.login(email, password)).called(1);
    });

    // 실패 케이스 테스트
    test('should return error when login fails', () async {
      // 준비: 모의 객체의 동작 설정
      final email = 'test@example.com';
      final password = 'password123';

      // 모의 객체가 login 메서드가 호출되면 예외를 발생시키도록 설정
      when(
        mockAuthDataSource.login(email, password),
      ).thenThrow(const AuthException('Invalid credentials'));

      // 실행: 테스트할 메서드 호출
      final result = await authRepository.signIn(email, password);

      // 검증: 결과 확인
      switch (result) {
        case Success():
          fail('Expected Error, but got Success');
        case Error():
          // 에러 메시지 확인
          expect(result.error.message, '이메일 또는 비밀번호가 일치하지 않습니다.');
      }

      // login 메서드가 정확히 한 번 호출되었는지 확인
      verify(mockAuthDataSource.login(email, password)).called(1);
    });
  });

  // 회원가입 테스트 그룹
  group('signUp', () {
    test('should return success when signUp is successful', () async {
      // 준비: 모의 객체의 동작 설정
      final email = 'test@example.com';
      final password = 'password123';
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

      // signUp 메서드가 호출되면 AuthResponse를 반환하도록 설정
      when(
        mockAuthDataSource.signUp(email, password),
      ).thenAnswer((_) async => authResponse);

      // 실행: 테스트할 메서드 호출
      final result = await authRepository.signUp(email, password);

      // 검증: 결과 확인
      switch (result) {
        case Success():
          // 성공 케이스
          break;
        case Error():
          fail('Expected Success, but got Error');
      }

      // signUp 메서드가 정확히 한 번 호출되었는지 확인
      verify(mockAuthDataSource.signUp(email, password)).called(1);
    });
  });

  // OTP 검증 테스트 그룹
  group('verifyEmailOtp', () {
    test('should return success when otp verification is successful', () async {
      // 준비: 모의 객체의 동작 설정
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

      // verifyEmailOtp 메서드가 호출되면 AuthResponse를 반환하도록 설정
      when(
        mockAuthDataSource.verifyEmailOtp(email, otp),
      ).thenAnswer((_) async => authResponse);

      // 실행: 테스트할 메서드 호출
      final result = await authRepository.verifyEmailOtp(email, otp);

      // 검증: 결과 확인
      switch (result) {
        case Success():
          // 성공 케이스
          break;
        case Error():
          fail('Expected Success, but got Error');
      }

      // verifyEmailOtp 메서드가 정확히 한 번 호출되었는지 확인
      verify(mockAuthDataSource.verifyEmailOtp(email, otp)).called(1);
    });
  });

  // Google 로그인 처리 테스트 그룹
  group('handleGoogleSignIn', () {
    test('should save user and return success for new user', () async {
      // 준비: 모의 객체의 동작 설정
      final user = const User(
        id: '1',
        appMetadata: {'provider': 'google'},
        userMetadata: {},
        aud: '',
        createdAt: '',
      );

      // 새 사용자(메타데이터가 없는 사용자)로 설정
      when(
        mockAuthDataSource.checkMetadata('is_initial_setup_user'),
      ).thenReturn(false);
      when(mockAuthDataSource.saveUser()).thenAnswer((_) async {});
      when(
        mockAuthDataSource.updateUserMetadata('is_initial_setup_user'),
      ).thenAnswer((_) async {});

      // 실행: 테스트할 메서드 호출
      final result = await authRepository.handleGoogleSignIn(user);

      // 검증: 결과 확인
      switch (result) {
        case Success():
          // 성공 케이스
          break;
        case Error():
          fail('Expected Success, but got Error');
      }

      // 새 사용자이므로 saveUser가 호출되었는지 확인
      verify(mockAuthDataSource.saveUser()).called(1);
    });

    test('should return success without saving for existing user', () async {
      // 준비: 모의 객체의 동작 설정
      final user = const User(
        id: '1',
        appMetadata: {'provider': 'google'},
        userMetadata: {'is_initial_setup_user': true},
        aud: '',
        createdAt: '',
      );

      // 기존 사용자(메타데이터가 있는 사용자)로 설정
      when(
        mockAuthDataSource.checkMetadata('is_initial_setup_user'),
      ).thenReturn(true);

      // 실행: 테스트할 메서드 호출
      final result = await authRepository.handleGoogleSignIn(user);

      // 검증: 결과 확인
      switch (result) {
        case Success():
          // 성공 케이스
          break;
        case Error():
          fail('Expected Success, but got Error');
      }

      // 기존 사용자이므로 saveUser가 호출되지 않아야 함
      verifyNever(mockAuthDataSource.saveUser());
    });
  });

  // 로그아웃 테스트 그룹
  group('signOut', () {
    test('should return success when logout is successful', () async {
      // 준비: 모의 객체의 동작 설정
      when(mockAuthDataSource.logout()).thenAnswer((_) async {});

      // 실행: 테스트할 메서드 호출
      final result = await authRepository.signOut();

      // 검증: 결과 확인
      switch (result) {
        case Success():
          // 성공 케이스
          break;
        case Error():
          fail('Expected Success, but got Error');
      }

      // logout 메서드가 정확히 한 번 호출되었는지 확인
      verify(mockAuthDataSource.logout()).called(1);
    });
  });
}
