import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/create/data/data_source/file_picker_data_source.dart';
import 'package:mongo_ai/create/data/data_source/file_picker_data_source_impl.dart';
import 'package:mongo_ai/create/data/data_source/open_ai_data_source.dart';
import 'package:mongo_ai/create/data/data_source/open_ai_data_source_impl.dart';
import 'package:mongo_ai/create/data/repository/file_picker_repository_impl.dart';
import 'package:mongo_ai/create/data/repository/open_ai_repository_impl.dart';
import 'package:mongo_ai/create/domain/repository/file_picker_repository.dart';
import 'package:mongo_ai/create/domain/repository/open_ai_repository.dart';
import 'package:mongo_ai/create/domain/use_case/create_problem_use_case.dart';
import 'package:mongo_ai/create/domain/use_case/image_pick_file_use_case.dart';
import 'package:mongo_ai/create/domain/use_case/pdf_pick_file_use_case.dart';
import 'package:mongo_ai/auth/data/data_source/auth_data_source.dart';
import 'package:mongo_ai/auth/data/data_source/auth_data_source_impl.dart';
import 'package:mongo_ai/auth/data/repository/auth_repository_impl.dart';
import 'package:mongo_ai/auth/domain/repository/auth_repository.dart';
import 'package:mongo_ai/dashboard/data/data_source/team_data_source.dart';
import 'package:mongo_ai/dashboard/data/data_source/team_data_source_impl.dart';
import 'package:mongo_ai/dashboard/data/data_source/user_profile_data_source.dart';
import 'package:mongo_ai/dashboard/data/data_source/user_profile_data_source_impl.dart';
import 'package:mongo_ai/dashboard/data/repository/team_repository_impl.dart';
import 'package:mongo_ai/dashboard/data/repository/user_profile_repository_impl.dart';
import 'package:mongo_ai/dashboard/domain/model/team.dart';
import 'package:mongo_ai/dashboard/domain/model/user_profile.dart';
import 'package:mongo_ai/dashboard/domain/repository/team_repository.dart';
import 'package:mongo_ai/dashboard/domain/repository/user_profile_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// -----------------------------------
// user profile 가져오기
final userProfileDataSourceProvider = Provider<UserProfileDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return UserProfileDataSourceImpl(client: client);
});

final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  final dataSource = ref.watch(userProfileDataSourceProvider);
  return UserProfileRepositoryImpl(dataSource: dataSource);
});

final getCurrentUserProfileProvider = FutureProvider<Result<UserProfile, AppException>>((ref) async {
  final repository = ref.watch(userProfileRepositoryProvider);
  return repository.getCurrentUserProfile();
});

// -----------------------------------
// team data 가져오기
final teamDataSourceProvider = Provider<TeamDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return TeamDataSourceImpl(client: client);
});

final teamRepositoryProvider = Provider<TeamRepository>((ref) {
  final dataSource = ref.watch(teamDataSourceProvider);
  return TeamRepositoryImpl(dataSource: dataSource);
});

final getTeamsByCurrentUserProvider = FutureProvider<Result<List<Team>, AppException>>((ref) async {
  final repository = ref.watch(teamRepositoryProvider);
  return repository.getTeamsByCurrentUser();
});

// -----------------------------------
// create
final openAIDataSourceProvider = Provider<OpenAiDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return OpenAiDataSourceImpl(client);
});

final filePickerDataSourceProvider = Provider<FilePickerDataSource>((ref) {
  return FilePickerDataSourceImpl();
});

final openAIRepositoryProvider = Provider<OpenAiRepository>((ref) {
  final dataSource = ref.watch(openAIDataSourceProvider);
  return OpenAiRepositoryImpl(openAiDataSource: dataSource);
});

final filePickerRepositoryProvider = Provider<FilePickerRepository>((ref) {
  final dataSource = ref.watch(filePickerDataSourceProvider);
  return FilePickerRepositoryImpl(filePickerDataSource: dataSource);
});

final createProblemUseCaseProvider = Provider<CreateProblemUseCase>((ref) {
  final repository = ref.watch(openAIRepositoryProvider);
  return CreateProblemUseCase(repository);
});

final imagePickFileUseCaseProvider = Provider<ImagePickFileUseCase>((ref) {
  final repository = ref.watch(filePickerRepositoryProvider);
  return ImagePickFileUseCase(filePickerRepository: repository);
});

final pdfPickFileUseCaseProvider = Provider<PdfPickFileUseCase>((ref) {
  final repository = ref.watch(filePickerRepositoryProvider);
  return PdfPickFileUseCase(filePickerRepository: repository);
});

final authDataSourceProvider = Provider<AuthDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return AuthDataSourceImpl(client: client);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dataSource = ref.watch(authDataSourceProvider);
  return AuthRepositoryImpl(authDataSource: dataSource);
});
