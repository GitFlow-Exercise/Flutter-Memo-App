import 'package:mongo_ai/dashboard/data/data_source/login_user_data_source.dart';
import 'package:mongo_ai/dashboard/domain/model/login_user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginUserDataSourceImpl implements LoginUserDataSource {
  final SupabaseClient _client;

  const LoginUserDataSourceImpl({
    required SupabaseClient client,
  }) : _client = client;

  @override
  Future<LoginUser> getCurrentLoginUser() async {
    final userId = _client.auth.currentUser!.id;
    final data = await _client
        .from('users')
        .select()
        .eq('user_id', userId)
        .single();

    return LoginUser.fromJson(data);
  }
}