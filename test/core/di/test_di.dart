import 'package:get_it/get_it.dart';
import 'package:mongo_ai/auth/data/data_source/auth_data_source.dart';
import 'package:mongo_ai/auth/data/data_source/mock/mock_auth_data_source_impl.dart';
import 'package:mongo_ai/auth/data/repository/auth_repository_impl.dart';
import 'package:mongo_ai/auth/domain/repository/auth_repository.dart';
import 'package:mongo_ai/create/data/data_source/file_picker_data_source.dart';
import 'package:mongo_ai/create/data/data_source/mock/mock_file_picker_data_source_impl.dart';
import 'package:mongo_ai/create/data/data_source/mock/mock_open_ai_data_source_impl.dart';
import 'package:mongo_ai/create/data/data_source/mock/mock_prompt_data_source_impl.dart';
import 'package:mongo_ai/create/data/data_source/open_ai_data_source.dart';
import 'package:mongo_ai/create/data/data_source/prompt_data_source.dart';
import 'package:mongo_ai/create/data/repository/file_picker_repository_impl.dart';
import 'package:mongo_ai/create/data/repository/open_ai_repository_impl.dart';
import 'package:mongo_ai/create/data/repository/prompt_repository_impl.dart';
import 'package:mongo_ai/create/domain/repository/file_picker_repository.dart';
import 'package:mongo_ai/create/domain/repository/open_ai_repository.dart';
import 'package:mongo_ai/create/domain/repository/prompt_repository.dart';
import 'package:mongo_ai/create/domain/use_case/create_problem_use_case.dart';
import 'package:mongo_ai/create/domain/use_case/get_prompts_use_case.dart';
import 'package:mongo_ai/create/domain/use_case/image_pick_file_use_case.dart';
import 'package:mongo_ai/create/domain/use_case/pdf_pick_file_use_case.dart';

final mockLocator = GetIt.instance;

void mockdDISetup() {
  // DataSource
  mockLocator.registerSingleton<AuthDataSource>(MockAuthDataSourceImpl());
  mockLocator.registerSingleton<FilePickerDataSource>(
    MockFilePickerDataSourceImpl(),
  );
  mockLocator.registerSingleton<OpenAiDataSource>(MockOpenAiDataSourceImpl());
  mockLocator.registerSingleton<PromptDataSource>(MokcPromptDataSourceImpl());

  // Repository
  mockLocator.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(authDataSource: mockLocator()),
  );
  mockLocator.registerSingleton<FilePickerRepository>(
    FilePickerRepositoryImpl(filePickerDataSource: mockLocator()),
  );
  mockLocator.registerSingleton<OpenAiRepository>(
    OpenAiRepositoryImpl(openAiDataSource: mockLocator()),
  );
  mockLocator.registerSingleton<PromptRepository>(
    PromptRepositoryImpl(promptDataSource: mockLocator()),
  );

  // UseCase
  mockLocator.registerSingleton<CreateProblemUseCase>(
    CreateProblemUseCase(mockLocator()),
  );
  mockLocator.registerSingleton<GetPromptsUseCase>(
    GetPromptsUseCase(mockLocator()),
  );
  mockLocator.registerSingleton<ImagePickFileUseCase>(
    ImagePickFileUseCase(filePickerRepository: mockLocator()),
  );
  mockLocator.registerSingleton<PdfPickFileUseCase>(
    PdfPickFileUseCase(filePickerRepository: mockLocator()),
  );
}
