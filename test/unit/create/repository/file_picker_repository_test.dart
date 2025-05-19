import 'package:flutter_test/flutter_test.dart';
import 'package:mongo_ai/core/constants/ai_constant.dart';
import '../../../core/di/test_di.dart';
import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/create/data/data_source/mock/mock_file_picker_data_source_impl.dart';
import 'package:mongo_ai/create/domain/model/pick_file.dart';
import 'package:mongo_ai/create/domain/repository/file_picker_repository.dart';

void main() {
  late FilePickerRepository filePickerRepository;

  setUpAll(() {
    mockdDISetup();
    filePickerRepository = mockLocator();
  });

  test('image picker test', () async {
    final result = await filePickerRepository.selectImage();

    switch (result) {
      case Success<PickFile?, AppException>():
        expect(result.data, isNotNull);
        expect(
          result.data!.fileExtension,
          MockFilePickerDataSourceImpl.pngExtension,
        );
        expect(result.data!.type, AiConstant.inputImage);
      case Error<PickFile?, AppException>():
        expect(result, isA<Error<PickFile?, AppException>>());
    }
  });

  test('pdf picker test', () async {
    final result = await filePickerRepository.selectPdf();

    switch (result) {
      case Success<PickFile?, AppException>():
        expect(result.data, isNotNull);
        expect(
          result.data!.fileExtension,
          MockFilePickerDataSourceImpl.pdfExtension,
        );
        expect(result.data!.type, AiConstant.inputFile);
      case Error<PickFile?, AppException>():
        expect(result, isA<Error<PickFile?, AppException>>());
    }
  });
}
