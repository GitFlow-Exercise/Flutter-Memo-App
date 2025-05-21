import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/core/state/current_team_id_state.dart';
import 'package:mongo_ai/create/data/data_source/file_picker_data_source.dart';
import 'package:mongo_ai/create/data/data_source/file_picker_data_source_impl.dart';
import 'package:mongo_ai/create/data/data_source/open_ai_data_source.dart';
import 'package:mongo_ai/create/data/data_source/open_ai_data_source_impl.dart';
import 'package:mongo_ai/create/data/data_source/problem_data_source.dart';
import 'package:mongo_ai/create/data/data_source/problem_data_source_impl.dart';
import 'package:mongo_ai/create/data/data_source/prompt_data_source.dart';
import 'package:mongo_ai/create/data/data_source/prompt_data_source_impl.dart';
import 'package:mongo_ai/create/data/repository/file_picker_repository_impl.dart';
import 'package:mongo_ai/create/data/repository/open_ai_repository_impl.dart';
import 'package:mongo_ai/create/data/repository/problem_repository_impl.dart';
import 'package:mongo_ai/create/data/repository/prompt_repository_impl.dart';
import 'package:mongo_ai/create/domain/model/prompt.dart';
import 'package:mongo_ai/create/domain/repository/file_picker_repository.dart';
import 'package:mongo_ai/create/domain/repository/open_ai_repository.dart';
import 'package:mongo_ai/create/domain/repository/problem_repository.dart';
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
import 'package:mongo_ai/dashboard/data/data_source/folder_data_source.dart';
import 'package:mongo_ai/dashboard/data/data_source/folder_data_source_impl.dart';
import 'package:mongo_ai/dashboard/data/data_source/team_data_source.dart';
import 'package:mongo_ai/dashboard/data/data_source/team_data_source_impl.dart';
import 'package:mongo_ai/dashboard/data/data_source/user_profile_data_source.dart';
import 'package:mongo_ai/dashboard/data/data_source/user_profile_data_source_impl.dart';
import 'package:mongo_ai/dashboard/data/data_source/workbook_data_source.dart';
import 'package:mongo_ai/dashboard/data/data_source/workbook_data_source_impl.dart';
import 'package:mongo_ai/dashboard/data/repository/folder_repository_impl.dart';
import 'package:mongo_ai/dashboard/data/repository/team_repository_impl.dart';
import 'package:mongo_ai/dashboard/data/repository/user_profile_repository_impl.dart';
import 'package:mongo_ai/dashboard/data/repository/workbook_repository_impl.dart';
import 'package:mongo_ai/dashboard/domain/model/folder.dart';
import 'package:mongo_ai/dashboard/domain/model/team.dart';
import 'package:mongo_ai/dashboard/domain/model/user_profile.dart';
import 'package:mongo_ai/dashboard/domain/model/workbook.dart';
import 'package:mongo_ai/dashboard/domain/repository/folder_repository.dart';
import 'package:mongo_ai/dashboard/domain/repository/team_repository.dart';
import 'package:mongo_ai/dashboard/domain/repository/user_profile_repository.dart';
import 'package:mongo_ai/dashboard/domain/repository/workbook_repository.dart';
import 'package:mongo_ai/dashboard/domain/use_case/bookmark_workbook_list_use_case.dart';
import 'package:mongo_ai/dashboard/domain/use_case/change_folder_workbook_list_use_case.dart';
import 'package:mongo_ai/dashboard/domain/use_case/delete_workbook_list_use_case.dart';
import 'package:mongo_ai/dashboard/domain/use_case/move_trash_workbook_list_use_case.dart';
import 'package:mongo_ai/dashboard/domain/use_case/move_trash_workbook_use_case.dart';
import 'package:mongo_ai/dashboard/domain/use_case/restore_workbook_list_use_case.dart';
import 'package:mongo_ai/dashboard/domain/use_case/toggle_bookmark_use_case.dart';
import 'package:mongo_ai/landing/data/data_source/privacy_policies_data_source.dart';
import 'package:mongo_ai/landing/data/data_source/privacy_policies_data_source_impl.dart';
import 'package:mongo_ai/landing/data/repository/privacy_policies_repository_impl.dart';
import 'package:mongo_ai/landing/domain/repository/privacy_policies_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});
// -----------------------------------
// dashboard

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

final getCurrentUserProfileProvider =
    FutureProvider.autoDispose<Result<UserProfile, AppException>>((ref) async {
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

final getTeamsByCurrentUserProvider =
    FutureProvider.autoDispose<Result<List<Team>, AppException>>((ref) async {
      final repository = ref.watch(teamRepositoryProvider);
      return repository.getTeamsByCurrentUser();
    });

// -----------------------------------
// folder 가져오기
final folderDataSourceProvider = Provider<FolderDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return FolderDataSourceImpl(client: client);
});

final folderRepositoryProvider = Provider<FolderRepository>((ref) {
  final dataSource = ref.watch(folderDataSourceProvider);
  return FolderRepositoryImpl(dataSource: dataSource);
});

final getFoldersByCurrentTeamIdProvider =
    FutureProvider.autoDispose<Result<List<Folder>, AppException>>((ref) async {
      // 현재 팀 ID 구독. 팀 ID 변경 시 자동으로 autoDispose되고 다시 호출
      final teamId = ref.watch(currentTeamIdStateProvider);
      if (teamId == null) {
        return const Result.success(<Folder>[]);
      }

      final repository = ref.watch(folderRepositoryProvider);
      return repository.getFoldersByCurrentTeamId(teamId);
    });

// -----------------------------------
// workbook 가져오기
final workbookDataSourceProvider = Provider<WorkbookDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return WorkbookDataSourceImpl(client: client);
});

final workbookRepositoryProvider = Provider<WorkbookRepository>((ref) {
  final dataSource = ref.watch(workbookDataSourceProvider);
  return WorkbookRepositoryImpl(dataSource: dataSource);
});

final getWorkbooksByCurrentTeamIdProvider =
    FutureProvider.autoDispose<Result<List<Workbook>, AppException>>((
      ref,
    ) async {
      // 현재 팀 ID 구독. 팀 ID 변경 시 자동으로 autoDispose되고 다시 호출
      final teamId = ref.watch(currentTeamIdStateProvider);
      if (teamId == null) {
        return const Result.success(<Workbook>[]);
      }

      final repository = ref.watch(workbookRepositoryProvider);
      return repository.getWorkbooksByCurrentTeamId(teamId);
    });

final toggleBookmarkUseCaseProvider = Provider<ToggleBookmarkUseCase>((ref) {
  final workbookRepository = ref.watch(workbookRepositoryProvider);
  return ToggleBookmarkUseCase(workbookRepository);
});

final moveTrashWorkbookUseCaseProvider = Provider<MoveTrashWorkbookUseCase>((ref) {
  final workbookRepository = ref.watch(workbookRepositoryProvider);
  return MoveTrashWorkbookUseCase(workbookRepository);
});

final moveTrashWorkbookListUseCaseProvider = Provider<MoveTrashWorkbookListUseCase>((ref) {
   final workbookRepository = ref.watch(workbookRepositoryProvider);
   return MoveTrashWorkbookListUseCase(workbookRepository);
});

final changeFolderWorkbookListUseCaseProvider = Provider<ChangeFolderWorkbookListUseCase>((ref) {
  final workbookRepository = ref.watch(workbookRepositoryProvider);
  return ChangeFolderWorkbookListUseCase(workbookRepository);
});

final bookmarkWorkbookListUseCaseProvider = Provider<BookmarkWorkbookListUseCase>((ref) {
  final workbookRepository = ref.watch(workbookRepositoryProvider);
  return BookmarkWorkbookListUseCase(workbookRepository);
});

final restoreWorkbookListUseCaseProvider = Provider<RestoreWorkbookListUseCase>((ref) {
  final workbookRepository = ref.watch(workbookRepositoryProvider);
  return RestoreWorkbookListUseCase(workbookRepository);
});

final deleteWorkbookListUseCaseProvider = Provider<DeleteWorkbookListUseCase>((ref) {
  final workbookRepository = ref.watch(workbookRepositoryProvider);
  return DeleteWorkbookListUseCase(workbookRepository);
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

// -----------------------------------
// Problem

final problemDataSourceProvider = Provider<ProblemDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return ProblemDataSourceImpl(client: client);
});

final problemRepositoryProvider = Provider<ProblemRepository>((ref) {
  final dataSource = ref.watch(problemDataSourceProvider);
  return ProblemRepositoryImpl(dataSource: dataSource);
});

// -----------------------------------
// landing
// -----------------------------------
// DataSource
final privacyPoliciesDataSourceProvider = Provider<PrivacyPoliciesDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return PrivacyPoliciesDataSourceImpl(client: client);
});

// -----------------------------------
// Repository

final privacyPoliciesRepositoryProvider = Provider<PrivacyPoliciesRepository>((ref) {
  final dataSource = ref.watch(privacyPoliciesDataSourceProvider);
  return PrivacyPoliciesRepositoryImpl(privacyPoliciesDataSource: dataSource);
});