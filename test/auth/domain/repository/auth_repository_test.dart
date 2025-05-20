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
    when(mockAuthDataSource.isPreferredTeamSelected()).thenReturn(true);

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

  group('handleGoogleSignIn 테스트', () {
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
      when(
        mockAuthDataSource.signInWithGoogle(),
      ).thenThrow(const AuthException('Google login failed'));

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

  group('signOut 테스트', () {
    test('로그아웃에 성공하면 Success를 반환해야 한다.', () async {
      when(mockAuthDataSource.logout()).thenAnswer((_) async {});

      final result = await authRepository.signOut();

      switch (result) {
        case Success():
          break;
        case Error():
          fail('success를 반환해야 하지만 Error를 반환했습니다.');
      }

      verify(mockAuthDataSource.logout()).called(1);
    });
  });

  group('deleteUser 테스트', () {
    test('사용자 삭제가 성공했을 때 Success를 반환해야 한다', () async {
      final userId = 'user123';
      when(mockAuthDataSource.deleteUser(userId)).thenAnswer((_) async {});

      final result = await authRepository.deleteUser(userId);

      switch (result) {
        case Success():
          break;
        case Error():
          fail('사용자 삭제가 성공해야 하지만 Error가 반환되었습니다.');
      }

      verify(mockAuthDataSource.deleteUser(userId)).called(1);
    });

    test('사용자 삭제가 실패했을 때 Error를 반환해야 한다', () async {
      final userId = 'user123';
      when(
        mockAuthDataSource.deleteUser(userId),
      ).thenThrow(Exception('Delete user failed'));

      final result = await authRepository.deleteUser(userId);

      switch (result) {
        case Success():
          fail('사용자 삭제가 실패해야 하지만 Success가 반환되었습니다.');
        case Error():
          expect(result.error.message, '유저를 삭제하던 중 오류가 발생했습니다.');
      }

      verify(mockAuthDataSource.deleteUser(userId)).called(1);
    });
  });

  group('isEmailExist 테스트', () {
    test('이메일이 존재하지 않을 때 Success(false)를 반환해야 한다', () async {
      final email = 'new@example.com';
      when(
        mockAuthDataSource.isEmailExist(email),
      ).thenAnswer((_) async => false);

      final result = await authRepository.isEmailExist(email);

      // 검증: 결과가 Success(false)인지 확인
      switch (result) {
        case Success(data: final exists):
          expect(exists, false);
        case Error():
          fail('이메일 존재 여부 로직에서 Error가 반환되었습니다.');
      }

      verify(mockAuthDataSource.isEmailExist(email)).called(1);
    });

    test('이메일이 존재할 때 Error를 반환해야 한다', () async {
      final email = 'existing@example.com';
      when(
        mockAuthDataSource.isEmailExist(email),
      ).thenAnswer((_) async => true);

      final result = await authRepository.isEmailExist(email);

      switch (result) {
        case Success():
          fail('이메일이 존재하므로 Error가 반환되어야 합니다.');
        case Error():
          expect(result.error.message, '이미 존재하는 이메일입니다.');
      }

      verify(mockAuthDataSource.isEmailExist(email)).called(1);
    });
  });

  group('saveUser 테스트', () {
    test('사용자 저장이 성공했을 때 Success를 반환해야 한다', () async {
      when(mockAuthDataSource.saveUser()).thenAnswer((_) async {});
      when(
        mockAuthDataSource.updateUserMetadata('is_initial_setup_user'),
      ).thenAnswer((_) async {});

      final result = await authRepository.saveUser();

      switch (result) {
        case Success():
          break;
        case Error():
          fail('사용자 저장이 성공해야 하지만 Error가 반환되었습니다.');
      }

      verify(mockAuthDataSource.saveUser()).called(1);
      verify(
        mockAuthDataSource.updateUserMetadata('is_initial_setup_user'),
      ).called(1);
    });

    test('사용자가 인증되지 않았을 때 Error를 반환해야 한다', () async {
      when(mockAuthDataSource.isAuthenticated()).thenReturn(false);

      final result = await authRepository.saveUser();

      switch (result) {
        case Success():
          fail('사용자가 인증되지 않았으므로 Error가 반환되어야 합니다.');
        case Error():
          expect(result.error.message, '인증되지 않은 사용자입니다.');
      }

      verifyNever(mockAuthDataSource.saveUser());
    });
  });

  group('resetPassword 테스트', () {
    test('비밀번호 재설정이 성공했을 때 Success를 반환해야 한다', () async {
      final mockUserResponse = MockUserResponse();
      final password = 'newPassword123';

      when(mockUserResponse.user).thenReturn(
        const User(
          id: '',
          appMetadata: {},
          userMetadata: {},
          aud: '',
          createdAt: '',
        ),
      );
      when(mockAuthDataSource.resetPassword(password)).thenAnswer((_) async {
        return mockUserResponse;
      });

      final result = await authRepository.resetPassword(password);

      switch (result) {
        case Success():
          break;
        case Error():
          fail('비밀번호 재설정이 성공해야 하지만 Error가 반환되었습니다.');
      }

      verify(mockAuthDataSource.resetPassword(password)).called(1);
    });

    test('비밀번호 재설정이 실패했을 때 Error를 반환해야 한다', () async {
      final password = 'newPassword123';

      when(
        mockAuthDataSource.resetPassword(password),
      ).thenThrow(Exception('Password reset failed'));

      final result = await authRepository.resetPassword(password);

      switch (result) {
        case Success():
          fail('비밀번호 재설정이 실패해야 하지만 Success가 반환되었습니다.');
        case Error():
          expect(result.error.message, '알 수 없는 오류입니다.');
      }

      verify(mockAuthDataSource.resetPassword(password)).called(1);
    });
  });

  group('getCurrentUserEmail 테스트', () {
    test('사용자 이메일을 성공적으로 가져왔을 때 Success를 반환해야 한다', () async {
      final email = 'user@example.com';
      when(
        mockAuthDataSource.getCurrentUserEmail(),
      ).thenAnswer((_) async => email);

      final result = await authRepository.getCurrentUserEmail();

      switch (result) {
        case Success(data: final userEmail):
          expect(userEmail, email);
        case Error():
          fail('사용자 이메일을 가져오는데 성공해야 하지만 Error가 반환되었습니다.');
      }

      verify(mockAuthDataSource.getCurrentUserEmail()).called(1);
    });

    test('사용자 이메일이 null일 때 Error를 반환해야 한다', () async {
      when(
        mockAuthDataSource.getCurrentUserEmail(),
      ).thenAnswer((_) async => null);

      final result = await authRepository.getCurrentUserEmail();

      switch (result) {
        case Success():
          fail('사용자 이메일이 null이므로 Error가 반환되어야 합니다.');
        case Error():
          expect(result.error.message, '사용자 이메일을 불러오던 중 오류가 발생했습니다.');
      }

      verify(mockAuthDataSource.getCurrentUserEmail()).called(1);
    });
  });

  group('setSelectTeamMetadata', () {
    test('팀 선택 메타데이터 설정이 성공했을 때 Success를 반환해야 한다', () async {
      when(
        mockAuthDataSource.updateUserMetadata('is_preferred_team_selected'),
      ).thenAnswer((_) async {});

      final result = await authRepository.setSelectTeamMetadata();

      // 검증: 결과가 Success인지 확인
      switch (result) {
        case Success():
          break;
        case Error():
          fail('메타데이터 설정이 성공해야 하지만 Error가 반환되었습니다.');
      }

      verify(mockAuthDataSource.updateUserMetadata('is_preferred_team_selected')).called(1);
    });

    test('메타데이터 설정이 실패했을 때 Error를 반환해야 한다', () async {
      when(
        mockAuthDataSource.updateUserMetadata('is_preferred_team_selected'),
      ).thenThrow(Exception('Metadata update failed'));

      final result = await authRepository.setSelectTeamMetadata();

      switch (result) {
        case Success():
          fail('메타데이터 설정이 실패해야 하지만 Success가 반환되었습니다.');
        case Error():
          expect(
            result.error.message,
            'Metadata를 설정하던 중 오류가 발생했습니다: is_preferred_team_selected',
          );
      }

      verify(mockAuthDataSource.updateUserMetadata('is_preferred_team_selected')).called(1);
    });
  });
}
