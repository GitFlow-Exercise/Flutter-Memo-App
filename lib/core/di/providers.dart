import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/create/data/data_source/file_picker_data_source.dart';
import 'package:mongo_ai/create/data/data_source/file_picker_data_source_impl.dart';
import 'package:mongo_ai/create/data/data_source/open_ai_data_source.dart';
import 'package:mongo_ai/create/data/data_source/open_ai_data_source_impl.dart';
import 'package:mongo_ai/create/data/data_source/prompt_data_source.dart';
import 'package:mongo_ai/create/data/data_source/prompt_data_source_impl.dart';
import 'package:mongo_ai/create/data/repository/file_picker_repository_impl.dart';
import 'package:mongo_ai/create/data/repository/open_ai_repository_impl.dart';
import 'package:mongo_ai/create/data/repository/prompt_repository_impl.dart';
import 'package:mongo_ai/create/domain/model/prompt.dart';
import 'package:mongo_ai/create/domain/repository/file_picker_repository.dart';
import 'package:mongo_ai/create/domain/repository/open_ai_repository.dart';
import 'package:mongo_ai/create/domain/repository/prompt_repository.dart';
import 'package:mongo_ai/create/domain/use_case/create_problem_use_case.dart';
import 'package:mongo_ai/create/domain/use_case/download_pdf_use_case.dart';
import 'package:mongo_ai/create/domain/use_case/get_prompts_use_case.dart';
import 'package:mongo_ai/create/domain/use_case/image_pick_file_use_case.dart';
import 'package:mongo_ai/create/domain/use_case/pdf_pick_file_use_case.dart';
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
// -----------------------------------
// DataSource
final openAIDataSourceProvider = Provider<OpenAiDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return OpenAiDataSourceImpl(client);
});

final promptDataSourceProvider = Provider<PromptDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return PromptDataSourceImpl(client);
});

final filePickerDataSourceProvider = Provider<FilePickerDataSource>((ref) {
  return FilePickerDataSourceImpl();
});

// -----------------------------------
// Repository
final openAIRepositoryProvider = Provider<OpenAiRepository>((ref) {
  final dataSource = ref.watch(openAIDataSourceProvider);
  return OpenAiRepositoryImpl(openAiDataSource: dataSource);
});

final filePickerRepositoryProvider = Provider<FilePickerRepository>((ref) {
  final dataSource = ref.watch(filePickerDataSourceProvider);
  return FilePickerRepositoryImpl(filePickerDataSource: dataSource);
});

final promptRepositoryProvider = Provider<PromptRepository>((ref) {
  final dataSource = ref.watch(promptDataSourceProvider);
  return PromptRepositoryImpl(promptDataSource: dataSource);
});

// -----------------------------------
// UseCase
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

final getPromptsUseCaseProvider =
    FutureProvider<Result<List<Prompt>, AppException>>((ref) {
      final repository = ref.watch(promptRepositoryProvider);
      return GetPromptsUseCase(repository).execute();
    });

final downloadPdfUseCase = Provider<DownloadPdfUseCase>((ref) {
  return const DownloadPdfUseCase();
});

// -----------------------------------
// Auth
final authDataSourceProvider = Provider<AuthDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return AuthDataSourceImpl(client: client);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dataSource = ref.watch(authDataSourceProvider);
  return AuthRepositoryImpl(authDataSource: dataSource);
});
