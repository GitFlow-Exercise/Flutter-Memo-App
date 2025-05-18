import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mongo_ai/auth/data/data_source/auth_data_source.dart';
import 'package:mongo_ai/auth/data/data_source/auth_data_source_impl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

class MockGoTrueAdmin extends Mock implements GoTrueAdminApi {}

// 테스트는 mock data를 생성하여 진행합니다.
// 1. mock class setup
// 2. mock class의 함수 리턴값 임의로 설정
// 3. dataSource를 호출
// 4. verify를 이용하여 dataSource 내부에 mock class의 함수가 1번 호출되었는지 검증
void main() {
  late MockSupabaseClient mockClient;
  late MockGoTrueClient mockAuth;
  late MockGoTrueAdmin mockAdmin;
  late AuthDataSource authDataSource;

  const email = 'test@test.com';
  const password = 'qwer1234';
  const userId = 'userId';
  final mockAuthResponse = AuthResponse();

  // setting
  setUpAll(() {
    mockClient = MockSupabaseClient();
    mockAuth = MockGoTrueClient();
    mockAdmin = MockGoTrueAdmin();

    // mockClient.auth 리턴값 설정
    when(() => mockClient.auth).thenReturn(mockAuth);

    // mockClient.auth.admin 리턴값 설정
    when(() => mockAuth.admin).thenReturn(mockAdmin);

    authDataSource = AuthDataSourceImpl(client: mockClient);
  });

  group('login test', () {
    test('email, password login test', () async {
      // signIn 리턴값 설정
      when(
        () => mockAuth.signInWithPassword(email: email, password: password),
      ).thenAnswer((_) async {
        return mockAuthResponse;
      });

      // 실제 login() 호출
      await authDataSource.login(email, password);

      verify(() => authDataSource.login(email, password)).called(1);
    });

    test('google login test', () async {
      final provider = OAuthProvider.google;
      final redirectUrl = '${Uri.base.origin}/auth/callback';
      // signIn 리턴값 설정
      when(
        () => mockAuth.signInWithOAuth(provider, redirectTo: redirectUrl),
      ).thenAnswer((_) async {
        return true;
      });

      // 실제 login() 호출
      await authDataSource.signInWithGoogle();

      verify(
        () => mockAuth.signInWithOAuth(provider, redirectTo: redirectUrl),
      ).called(1);
    });
  });

  test('logout test', () async {
    when(() => mockAuth.signOut()).thenAnswer((_) async {});

    await authDataSource.logout();

    verify(() => mockAuth.signOut()).called(1);
  });

  test('deleteUser test', () async {
    when(() => mockAdmin.deleteUser(userId)).thenAnswer((_) async {});

    await authDataSource.deleteUser(userId);

    verify(() => mockAdmin.deleteUser(userId)).called(1);
  });

  test('signup test', () async {
    // signIn 리턴값 설정
    when(() => mockAuth.signUp(email: email, password: password)).thenAnswer((
      _,
    ) async {
      return mockAuthResponse;
    });

    // 실제 login() 호출
    final authResponse = await authDataSource.signUp(email, password);

    verify(() => mockAuth.signUp(email: email, password: password)).called(1);
    expect(authResponse, equals(mockAuthResponse));
  });
}
