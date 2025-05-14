import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mongo_ai/core/constants/ai_constant.dart';
import 'package:mongo_ai/core/di/providers.dart';
import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/create/domain/model/request/input_content.dart';
import 'package:mongo_ai/create/domain/model/request/message_input.dart';
import 'package:mongo_ai/create/domain/model/request/open_ai_body.dart';
import 'package:mongo_ai/create/domain/model/response/open_ai_response.dart';
import 'package:mongo_ai/create/presentation/create/controller/upload_raw_event.dart';
import 'package:mongo_ai/create/presentation/create/controller/upload_raw_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'upload_raw_view_model.g.dart';

@riverpod
class UploadRawViewModel extends _$UploadRawViewModel {
  final _eventController = StreamController<UploadRawEvent>();

  Stream<UploadRawEvent> get eventStream => _eventController.stream;

  @override
  Future<UploadRawState> build() async {
    final textController = TextEditingController();

    ref.onDispose(() {
      _eventController.close();
      textController.dispose();
    });

    return UploadRawState(textController: textController);
  }

  // 업로드 타입 선택
  void handleSelectUploadType(String type) {
    final isTextType = type == AiConstant.inputText;
    state = state.whenData((cb) {
      return cb.copyWith(
        selectedUploadType: type,
        pickFile: isTextType ? cb.pickFile : null,
      );
    });

    if (!isTextType) {
      state = state.whenData((cb) {
        cb.textController.clear();
        return cb;
      });
    }
  }

  // 이미지 파일 선택(png, jpg, jpeg)
  Future<void> handlePickImage() async {
    final useCase = ref.read(imagePickFileUseCaseProvider);
    final result = await useCase.execute();

    switch (result) {
      case Success():
        state = state.whenData((cb) {
          return cb.copyWith(pickFile: result.data);
        });
        break;
      case Error(:final error):
        _readyForSnackBar(error.userFriendlyMessage);
        debugPrint(error.stackTrace.toString());
        break;
    }
  }

  // PDF 파일 선택
  Future<void> handlePickPdf() async {
    final useCase = ref.read(pdfPickFileUseCaseProvider);
    final result = await useCase.execute();

    switch (result) {
      case Success():
        state = state.whenData((cb) {
          return cb.copyWith(pickFile: result.data);
        });
        break;
      case Error(:final error):
        _readyForSnackBar(error.userFriendlyMessage);
        debugPrint(error.stackTrace.toString());
        break;
    }
  }

  // 설정된 타입으로 클린 텍스트 추출
  Future<void> handleSubmitForm() async {
    final pState = state.value;
    if (pState == null) {
      _readyForSnackBar('에러가 발생하였습니다. 다시 시도해주세요.');
      return;
    }
    // 텍스트 타입인데 입력된 텍스트가 없다면 에러처리
    if (pState.selectedUploadType == AiConstant.inputText) {
      final text = pState.textController.text.trim();
      if (text.isEmpty) {
        _readyForSnackBar('텍스트를 입력해주세요.');
        return;
      }
    }

    // 이미지 & PDF 파일 타입으로 추출
    final file = pState.pickFile;
    // 현재 데이터 타입이 텍스트가 아니고, file 데이터가 없다면 에러처리
    if (file == null && pState.selectedUploadType != AiConstant.inputText) {
      if (pState.selectedUploadType == AiConstant.inputImage) {
        _readyForSnackBar('이미지를 선택해주세요.');
      } else {
        _readyForSnackBar('PDF 파일을 선택해주세요.');
      }
      return;
    }

    state = const AsyncValue.loading();

    InputContent inputContent;
    if (pState.selectedUploadType == AiConstant.inputText) {
      inputContent = InputContent.text(text: pState.textController.text);
    } else if (pState.selectedUploadType == AiConstant.inputImage) {
      inputContent = InputContent.image(
        imageExtension: file!.fileExtension,
        base64: base64Encode(file.bytes),
      );
    } else {
      inputContent = InputContent.file(
        filename: file!.fileName,
        base64: base64Encode(file.bytes),
      );
    }

    final body = OpenAiBody(
      input: [
        MessageInput(content: [inputContent]),
      ],
      previousResponseId: null,
      instructions: AiConstant.cleanTextPrompt,
    );
    final result = await ref.read(createProblemUseCaseProvider).execute(body);

    switch (result) {
      case Success<OpenAiResponse, AppException>():
        debugPrint(result.data.toString());
        state = AsyncValue.data(pState.copyWith(result: result.data));
        _eventController.add(UploadRawEvent.successOCR(result.data));
      case Error<OpenAiResponse, AppException>():
        _readyForSnackBar(result.error.userFriendlyMessage);
        state = AsyncValue.error(
          result.error,
          result.error.stackTrace ?? StackTrace.empty,
        );
    }
  }

  // 하단 스낵바 출력
  void _readyForSnackBar(String message) {
    _eventController.add(UploadRawEvent.showSnackBar(message));
  }

  // 텍스트 지우기
  void clearText() {
    state.whenData((cb) => cb.textController.clear());
  }

  // 파일 데이터 지우기
  void deleteFile() {
    state = state.whenData((cb) => cb.copyWith(pickFile: null));
  }
}
