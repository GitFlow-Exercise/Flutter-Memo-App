import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mongo_ai/core/constants/ai_constant.dart';
import 'package:mongo_ai/core/di/providers.dart';
import 'package:mongo_ai/core/result/result.dart';
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
    state = state.copyWith(isLoading: true);

    final useCase = ref.read(pickFileUseCaseProvider);
    final result = await useCase.selectImage();

    switch (result) {
      case Success():
        state = state.copyWith(
          imageBytes: result.data.bytes,
          imageName: result.data.fileName,
          isLoading: false,
        );
        break;
      case Error(:final error):
        _readyForSnackBar(error.userFriendlyMessage);
        debugPrint(error.stackTrace.toString());
        state = state.copyWith(isLoading: false);
        break;
    }
  }

  Future<void> handlePickPdf(BuildContext context) async {
    state = state.copyWith(isLoading: true);

    final useCase = ref.read(pickFileUseCaseProvider);
    final result = await useCase.selectPdf();

    switch (result) {
      case Success():
        state = state.copyWith(
          pdfBytes: result.data.bytes,
          pdfName: result.data.fileName,
          isLoading: false,
        );
        break;
      case Error(:final error):
        _readyForSnackBar(error.userFriendlyMessage);
        debugPrint(error.stackTrace.toString());
        state = state.copyWith(isLoading: false);
        break;
    }
  }

  void handleSubmitForm(BuildContext context) {
    _readyForSnackBar('제출 버튼이 눌렸습니다 (기능 미구현)');
  }

  void _readyForSnackBar(String message) {
    _eventController.add(UploadRawEvent.showSnackBar(message));
  }
}
