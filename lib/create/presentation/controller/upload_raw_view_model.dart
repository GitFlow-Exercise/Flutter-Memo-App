import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mongo_ai/core/constants/ai_constant.dart';
import 'package:mongo_ai/core/enum/allowed_extension_type.dart';
import 'package:mongo_ai/create/presentation/controller/upload_raw_event.dart';
import 'package:mongo_ai/create/presentation/controller/upload_raw_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'upload_raw_view_model.g.dart';

@riverpod
class UploadRawViewModel extends _$UploadRawViewModel {
  final _eventController = StreamController<UploadRawEvent>();

  Stream<UploadRawEvent> get eventStream => _eventController.stream;

  @override
  UploadRawState build() {
    final textController = TextEditingController();

    ref.onDispose(() {
      _eventController.close();
      textController.dispose();
    });

    return UploadRawState(textController: textController);
  }

  void handleSelectUploadType(String type) {
    state = state.copyWith(
      selectedUploadType: type,
      imageBytes: type != AiConstant.inputImage ? null : state.imageBytes,
      imageName: type != AiConstant.inputImage ? null : state.imageName,
      pdfBytes: type != AiConstant.inputFile ? null : state.pdfBytes,
      pdfName: type != AiConstant.inputFile ? null : state.pdfName,
    );

    if (type != AiConstant.inputText) {
      state.textController.clear();
    }
  }

  Future<void> handlePickImage(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          AllowedExtensionType.png.name,
          AllowedExtensionType.jpg.name,
          AllowedExtensionType.jpeg.name,
        ],
      );

      if (result != null) {
        state = state.copyWith(
          imageBytes: result.files.single.bytes,
          imageName: result.files.single.name,
        );
      }
    } catch (e) {
      _readyForSnackBar('이미지 선택 중 오류 발생: $e');
    }
  }

  Future<void> handlePickPdf(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [AllowedExtensionType.pdf.name],
      );

      if (result != null) {
        state = state.copyWith(
          pdfBytes: result.files.single.bytes,
          pdfName: result.files.single.name,
        );
      }
    } catch (e) {
      _readyForSnackBar('PDF 선택 중 오류 발생: $e');
    }
  }

  void handleSubmitForm(BuildContext context) {
    _readyForSnackBar('제출 버튼이 눌렸습니다 (기능 미구현)');
  }

  void _readyForSnackBar(String message) {
    _eventController.add(UploadRawEvent.showSnackBar(message));
  }
}
