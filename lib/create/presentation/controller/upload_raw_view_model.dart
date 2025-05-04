import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mongo_ai/core/constants/ai_constant.dart';
import 'package:mongo_ai/core/di/providers.dart';
import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/create/domain/model/request/input_content.dart';
import 'package:mongo_ai/create/domain/model/request/message_input.dart';
import 'package:mongo_ai/create/domain/model/request/open_ai_body.dart';
import 'package:mongo_ai/create/domain/model/response/open_ai_response.dart';
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
          extension: result.data.extension,
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

  Future<void> handleSubmitForm(BuildContext context) async {
    if (state.selectedUploadType == AiConstant.inputText) {
      final text = state.textController.text.trim();
      if (text.isEmpty) {
        _readyForSnackBar('텍스트를 입력해주세요.');
        return;
      }

      //TODO: 다음 화면으로 데이터 이동
      debugPrint(text);
      return;
    }

    state = state.copyWith(isLoading: true);
    InputContent inputContent;

    if (state.selectedUploadType == AiConstant.inputImage) {
      if (state.imageBytes == null) {
        _readyForSnackBar('이미지를 선택해주세요.');
        state = state.copyWith(isLoading: false);
        return;
      }
      inputContent = InputContent.image(
        imageExtension: state.extension ?? '',
        base64: base64Encode(state.imageBytes!),
      );
    } else {
      if (state.pdfBytes == null) {
        _readyForSnackBar('PDF 파일을 선택해주세요.');
        state = state.copyWith(isLoading: false);
        return;
      }
      inputContent = InputContent.file(
        filename: state.pdfName ?? '',
        base64: base64Encode(state.pdfBytes!),
      );
    }

    final body = OpenAiBody(
      input: [
        MessageInput(content: [inputContent]),
      ],
      previousResponseId: null,
      instructions: 'Just OCR Result Please',
    );

    final result = await ref.read(createProblemUseCaseProvider).execute(body);

    switch (result) {
      case Success<OpenAiResponse, AppException>():
      //TODO: 다음 화면으로 데이터 이동
        debugPrint(result.data.toString());
      case Error<OpenAiResponse, AppException>():
        _readyForSnackBar(result.error.userFriendlyMessage);
    }

    state = state.copyWith(isLoading: false);
  }

  void _readyForSnackBar(String message) {
    _eventController.add(UploadRawEvent.showSnackBar(message));
  }
}
