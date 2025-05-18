import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mongo_ai/auth/data/data_source/auth_data_source.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockAuthDataSource extends Mock implements AuthDataSource {}

void main() {
  late AuthDataSource mockAuthDataSource;
  setUpAll(() {
    mockAuthDataSource = MockAuthDataSource();
  });

  test('login test', () {});
}
