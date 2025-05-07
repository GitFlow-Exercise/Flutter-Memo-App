import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import 'package:mongo_ai/home/data/data_source/remote_database_data_source.dart';
import 'package:mongo_ai/home/data/data_source/remote_database_data_source_impl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../home/data/data_source/home_data_source.dart';
import '../../home/data/data_source/home_data_source_impl.dart';
import '../../home/data/repository/home_repository_impl.dart';
import '../../home/domain/repository/home_repository.dart';
import '../../home/domain/use_case/get_home_info_use_case.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final remoteDatabaseProvider = Provider<RemoteDataBaseDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return RemoteDataBaseDataSourceImpl(client: client);
});

final homeDataSourceProvider = Provider<HomeDataSource>((ref) {
  return HomeDataSourceImpl();
});

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  final dataSource = ref.watch(homeDataSourceProvider);
  return HomeRepositoryImpl(homeDataSource: dataSource);
});

final getHomeInfoUseCaseProvider = Provider<GetHomeInfoUseCase>((ref) {
  final repository = ref.watch(homeRepositoryProvider);
  return GetHomeInfoUseCase(repository);
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
