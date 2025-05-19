import 'package:flutter_test/flutter_test.dart';
import 'package:mongo_ai/auth/data/data_source/mock/mock_auth_data_source_impl.dart';
import 'package:mongo_ai/auth/domain/repository/auth_repository.dart';
import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import '../../../core/di/test_di.dart';

void main() {
  late AuthRepository authRepository;

  const email = MockAuthDataSourceImpl.email;
  const password = 'qwer1234';

  setUpAll(() {
    mockdDISetup();
    authRepository = mockLocator();
  });

  test('signIn test', () async {
    final result = await authRepository.signIn(email, password);

    switch (result) {
      case Success<void, AppException>():
        expect(result, isA<Success<void, AppException>>());
        expect(authRepository.isAuthenticated, isTrue);
        final currentUserEmailResult =
            await authRepository.getCurrentUserEmail();
        switch (currentUserEmailResult) {
          case Success<String, AppException>():
            expect(currentUserEmailResult.data, MockAuthDataSourceImpl.email);
          case Error<String, AppException>():
            expect(currentUserEmailResult, isA<Error<void, AppException>>());
        }
        break;
      case Error<void, AppException>():
        expect(result, isA<Error<void, AppException>>());
    }
  });

  test('delete user test', () async {
    final id = 'id';
    final result = await authRepository.deleteUser(id);

    switch (result) {
      case Success<void, AppException>():
        expect(result, isA<Success<void, AppException>>());
        break;
      case Error<void, AppException>():
        expect(result, isA<Error<void, AppException>>());
    }
  });

  test('signOut test', () async {
    // when
    final result = await authRepository.signOut();

    switch (result) {
      case Success<void, AppException>():
        expect(result, isA<Success<void, AppException>>());
        expect(authRepository.isAuthenticated, isFalse);
        final currentUserEmailResult =
            await authRepository.getCurrentUserEmail();
        switch (currentUserEmailResult) {
          case Success<String, AppException>():
            expect(currentUserEmailResult.data, null);
          case Error<String, AppException>():
            expect(currentUserEmailResult, isA<Error<void, AppException>>());
        }
        break;
      case Error<void, AppException>():
        expect(result, isA<Error<void, AppException>>());
    }
  });

  test('signUp test', () async {
    // when
    final result = await authRepository.signUp(email, password);

    switch (result) {
      case Success<void, AppException>():
        expect(result, isA<Success<void, AppException>>());
        break;
      case Error<void, AppException>():
        expect(result, isA<Error<void, AppException>>());
    }
  });

  group('isExist Email test', () {
    test('isExist Email success test', () async {
      // when
      final result = await authRepository.isEmailExist(email);

      switch (result) {
        case Success<bool, AppException>():
          expect(result.data, isTrue);
          break;
        case Error<bool, AppException>():
          expect(result, isA<Error<void, AppException>>());
      }
    });

    test('isExist Email error test', () async {
      // when
      final result = await authRepository.isEmailExist('email');

      switch (result) {
        case Success<bool, AppException>():
          expect(result.data, isFalse);
          break;
        case Error<bool, AppException>():
          expect(result, isA<Error<void, AppException>>());
      }
    });
  });
}
