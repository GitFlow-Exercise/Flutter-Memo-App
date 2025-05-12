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
  UploadRawState build() {
    final textController = TextEditingController();

    ref.onDispose(() {
      _eventController.close();
      textController.dispose();
    });

    return UploadRawState(textController: textController);
  }

  void handleSelectUploadType(String type) {
    final isTextType = type == AiConstant.inputText;

    state = state.copyWith(
      selectedUploadType: type,
      pickFile: isTextType ? state.pickFile : null,
    );

    if (!isTextType) {
      state.textController.clear();
    }
  }

  Future<void> handlePickImage(BuildContext context) async {
    final useCase = ref.read(imagePickFileUseCaseProvider);
    final result = await useCase.execute();

    switch (result) {
      case Success():
        state = state.copyWith(pickFile: result.data);
        break;
      case Error(:final error):
        _readyForSnackBar(error.userFriendlyMessage);
        debugPrint(error.stackTrace.toString());
        break;
    }
  }

  Future<void> handlePickPdf(BuildContext context) async {
    final useCase = ref.read(pdfPickFileUseCaseProvider);
    final result = await useCase.execute();

    switch (result) {
      case Success():
        state = state.copyWith(pickFile: result.data);
        break;
      case Error(:final error):
        _readyForSnackBar(error.userFriendlyMessage);
        debugPrint(error.stackTrace.toString());
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

      debugPrint(text);
      _eventController.add(
        UploadRawEvent.successOCR(
          OpenAiResponse.justText(
            contents: '''
Urban delivery vehicles can be adapted to better suit the density of urban distribution, which often involves smaller vehicles such as vans, including bicycles. The latter have the potential to become a preferred 'last-mile' vehicle, particularly in high-density and congested areas. In locations where bicycle use is high, such as the Netherlands, delivery bicycles are also used to carry personal cargo (e.g. groceries). Due to their low acquisition and maintenance costs, cargo bicycles convey much potential in developed and developing countries alike, such as the becak (a three-wheeled bicycle) in Indonesia.
Services using electrically assisted delivery tricycles have been successfully implemented in France and are gradually being adopted across Europe for services as varied as parcel and catering deliveries. Using bicycles as cargo vehicles is particularly encouraged when combined with policies that restrict motor vehicle access to specific areas of a city, such as downtown or commercial districts, or with the extension of dedicated bike lanes.
① 도시에서 자전거는 효율적인 배송 수단으로 사용될 수 있다.
② 자전거는 출퇴근 시간을 줄이기 위한 대안으로 선호되고 있다.
③ 자전거는 배송 수단으로의 경제적 장단점을 모두 가질 수 있다.
④ 수요자의 요구에 부합하는 다양한 용도의 자전거가 개발되고 있다.
⑤ 세계 각국에서는 전기 자전거 사용을 장려하는 정책을 추진하고 있다.
''',
          ),
        ),
      );
      return;
    }

    final file = state.pickFile;
    if (file == null) {
      if (state.selectedUploadType == AiConstant.inputImage) {
        _readyForSnackBar('이미지를 선택해주세요.');
      } else {
        _readyForSnackBar('PDF 파일을 선택해주세요.');
      }
      return;
    }

    state = state.copyWith(result: const AsyncValue.loading());

    InputContent inputContent;
    if (state.selectedUploadType == AiConstant.inputImage) {
      inputContent = InputContent.image(
        imageExtension: file.fileExtension,
        base64: base64Encode(file.bytes),
      );
    } else {
      inputContent = InputContent.file(
        filename: file.fileName,
        base64: base64Encode(file.bytes),
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
        debugPrint(result.data.toString());
        state = state.copyWith(result: AsyncValue.data(result.data));
        _eventController.add(UploadRawEvent.successOCR(result.data));
      case Error<OpenAiResponse, AppException>():
        _readyForSnackBar(result.error.userFriendlyMessage);
        state = state.copyWith(
          result: AsyncValue.error(
            result.error,
            result.error.stackTrace ?? StackTrace.empty,
          ),
        );
    }
  }

  void _readyForSnackBar(String message) {
    _eventController.add(UploadRawEvent.showSnackBar(message));
  }
}
