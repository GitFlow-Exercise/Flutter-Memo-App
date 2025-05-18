// import 'package:flutter_test/flutter_test.dart';
// import 'package:mongo_ai/core/constants/ai_constant.dart';
// import 'package:mongo_ai/core/exception/app_exception.dart';
// import 'package:mongo_ai/core/result/result.dart';
// import 'package:mongo_ai/create/data/data_source/file_picker_data_source.dart';
// import 'package:mongo_ai/create/data/data_source/mock/mock_file_picker_data_source_impl.dart';
// import 'package:mongo_ai/create/data/data_source/mock/mock_open_ai_data_source_impl.dart';
// import 'package:mongo_ai/create/data/data_source/open_ai_data_source.dart';
// import 'package:mongo_ai/create/data/repository/file_picker_repository_impl.dart';
// import 'package:mongo_ai/create/data/repository/open_ai_repository_impl.dart';
// import 'package:mongo_ai/create/domain/model/pick_file.dart';
// import 'package:mongo_ai/create/domain/repository/file_picker_repository.dart';
// import 'package:mongo_ai/create/domain/repository/open_ai_repository.dart';

// void main() {
//   late OpenAiDataSource openAiDataSource;
//   late OpenAiRepository openAiRepository;

//   setUpAll(() {
//     openAiDataSource = MockOpenAiDataSourceImpl();
//     openAiRepository = OpenAiRepositoryImpl(
//       openAiDataSource: openAiDataSource,
//     );
//   });

//   test('image picker test', () async {
//     final result = await openAiRepository.createProblem(body)

//     switch (result) {
//       case Success<PickFile?, AppException>():
//         expect(result.data, isNotNull);
//         expect(
//           result.data!.fileExtension,
//           MockFilePickerDataSourceImpl.pngExtension,
//         );
//         expect(result.data!.type, AiConstant.inputImage);
//       case Error<PickFile?, AppException>():
//         expect(result, isA<Error<PickFile?, AppException>>());
//     }
//   });

//   test('pdf picker test', () async {
//     final result = await filePickerRepository.selectPdf();

//     switch (result) {
//       case Success<PickFile?, AppException>():
//         expect(result.data, isNotNull);
//         expect(
//           result.data!.fileExtension,
//           MockFilePickerDataSourceImpl.pdfExtension,
//         );
//         expect(result.data!.type, AiConstant.inputFile);
//       case Error<PickFile?, AppException>():
//         expect(result, isA<Error<PickFile?, AppException>>());
//     }
//   });
// }
