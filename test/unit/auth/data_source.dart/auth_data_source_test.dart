import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mongo_ai/auth/data/data_source/auth_data_source.dart';
import 'package:mongo_ai/auth/data/data_source/auth_data_source_impl.dart';

import '../../utils/mock_supabase.dart';

// 테스트는 mock data를 생성하여 진행합니다.
// 1. mock class setup
// 2. mock class의 함수 리턴값 임의로 설정
// 3. dataSource를 호출
// 4. verify를 이용하여 dataSource 내부에 mock class의 함수가 1번 호출되었는지 검증
void main() {
  final supabase = SupabaseMockHelper();
  late AuthDataSource authDataSource;

  const email = 'test@test.com';
  const password = 'qwer1234';
  const userId = 'userId';

  // setting
  setUpAll(() {
    supabase.init();
    authDataSource = AuthDataSourceImpl(client: supabase.mockClient);
  });

  // ------------------------------------
  // ⚠️ 구글 로그인은 내부 함수가 캡슐화 되어있어서
  // 테스트가 힘든 관계로 코드를 작성하지 않습니다.
  test('email, password login test', () async {
    await authDataSource.login(email, password);

    verify(
      () => supabase.mockAuth.signInWithPassword(
        email: email,
        password: password,
      ),
    ).called(1);
  });

  test('logout test', () async {
    await authDataSource.logout();

    verify(() => supabase.mockAuth.signOut()).called(1);
  });

  test('deleteUser test', () async {
    await authDataSource.deleteUser(userId);

    verify(() => supabase.mockAdmin.deleteUser(userId)).called(1);
  });

  test('signup test', () async {
    // 실제 login() 호출
    final authResponse = await authDataSource.signUp(email, password);

    verify(
      () => supabase.mockAuth.signUp(email: email, password: password),
    ).called(1);
    expect(authResponse, equals(supabase.mockAuthResponse));
  });

  test('isEmailExist returns true when a row is found', () async {
    final exists = await authDataSource.isEmailExist(email);

    verify(() => supabase.mockClient.from(any()).select()).called(1);

    expect(exists, isTrue);
  });
}
