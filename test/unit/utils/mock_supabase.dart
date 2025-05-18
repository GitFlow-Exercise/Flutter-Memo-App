import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// 1) Mock 클래스들
class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

class MockGoTrueAdmin extends Mock implements GoTrueAdminApi {}

class MockSupabaseQueryBuilder extends Mock implements SupabaseQueryBuilder {}

class MockPostgrestFilterBuilder extends Mock
    implements PostgrestFilterBuilder<List<Map<String, dynamic>>> {}

class NullableMockTransformBuilder extends Mock
    implements PostgrestTransformBuilder<PostgrestMap?> {
  @override
  PostgrestTransformBuilder<PostgrestMap> single() {
    return super.noSuchMethod(Invocation.method(#maybeSingle, []));
  }

  @override
  PostgrestTransformBuilder<PostgrestMap?> maybeSingle() {
    return super.noSuchMethod(Invocation.method(#maybeSingle, []));
  }
}

class MockPostgrestBuilder extends Mock implements PostgrestBuilder {}

class NotNullableMockTransformBuilder extends Mock
    implements PostgrestTransformBuilder<PostgrestMap> {}

// 2) 헬퍼 클래스
class SupabaseMockHelper {
  final mockClient = MockSupabaseClient();
  final mockAuth = MockGoTrueClient();
  final mockAdmin = MockGoTrueAdmin();
  final _mockQueryBuilder = MockSupabaseQueryBuilder();
  final _mockFilterBuilder = MockPostgrestFilterBuilder();
  final _nullableMockTransformBuilder = NullableMockTransformBuilder();
  final _notNullableMockTransformBuilder = NotNullableMockTransformBuilder();

  final mockAuthResponse = AuthResponse();

  /// 각 테스트 파일의 setUpAll에서 호출해 주세요.
  void init() {
    final fakeUrl = Uri.parse('https://mock.supabase.co/rest/v1/users');

    when(() => mockClient.from(any())).thenAnswer((_) => _mockQueryBuilder);
    when(
      () => _mockQueryBuilder.select(any()),
    ).thenAnswer((_) => _mockFilterBuilder);
    when(
      () => _mockFilterBuilder.eq(any(), any()),
    ).thenAnswer((_) => _mockFilterBuilder);
    when(() => _mockFilterBuilder.single()).thenAnswer(
      (_) => PostgrestFilterBuilder(
        PostgrestBuilder(url: fakeUrl, headers: const {}, method: 'GET'),
      ),
    );
    when(() => _mockFilterBuilder.maybeSingle()).thenAnswer(
      (_) => PostgrestFilterBuilder(
        PostgrestBuilder(url: fakeUrl, headers: const {}, method: 'GET'),
      ),
    );

    // ------------------------------------
    // Auth
    when(() => mockClient.auth).thenReturn(mockAuth);

    when(
      () => mockAuth.signInWithPassword(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async {
      return mockAuthResponse;
    });

    when(() => mockAuth.signOut()).thenAnswer((_) async {});

    when(
      () => mockAuth.verifyOTP(type: OtpType.email),
    ).thenAnswer((_) async => mockAuthResponse);

    when(
      () => mockAuth.verifyOTP(type: OtpType.magiclink),
    ).thenAnswer((_) async => mockAuthResponse);

    when(
      () => mockAuth.signUp(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => mockAuthResponse);

    // ------------------------------------
    // Admin
    when(() => mockAuth.admin).thenReturn(mockAdmin);

    when(() => mockAdmin.deleteUser(any())).thenAnswer((_) async {});
  }
}
