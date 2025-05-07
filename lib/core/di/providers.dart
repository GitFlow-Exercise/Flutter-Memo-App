import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/create/data/data_source/open_ai_data_source.dart';
import 'package:mongo_ai/create/data/data_source/open_ai_data_source_impl.dart';
import 'package:mongo_ai/create/data/repository/open_ai_repository_impl.dart';
import 'package:mongo_ai/create/domain/repository/open_ai_repository.dart';
import 'package:mongo_ai/create/domain/use_case/create_problem_use_case.dart';
import 'package:mongo_ai/auth/data/data_source/auth_data_source.dart';
import 'package:mongo_ai/auth/data/data_source/auth_data_source_impl.dart';
import 'package:mongo_ai/auth/data/repository/auth_repository_impl.dart';
import 'package:mongo_ai/auth/domain/repository/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});


// -----------------------------------
// create
final openAIDataSourceProvider = Provider<OpenAiDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return OpenAiDataSourceImpl(client);
});

final openAIRepositoryProvider = Provider<OpenAiRepository>((ref) {
  final dataSource = ref.watch(openAIDataSourceProvider);
  return OpenAiRepositoryImpl(openAiDataSource: dataSource);
});

final createProblemUseCaseProvider = Provider<CreateProblemUseCase>((ref) {
  final repository = ref.watch(openAIRepositoryProvider);
  return CreateProblemUseCase(repository);
});

final authDataSourceProvider = Provider<AuthDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return AuthDataSourceImpl(client: client);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dataSource = ref.watch(authDataSourceProvider);
  return AuthRepositoryImpl(authDataSource: dataSource);
});
