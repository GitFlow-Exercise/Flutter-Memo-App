import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:go_router/go_router.dart';
import 'package:mongo_ai/core/constants/ai_constant.dart';
import 'package:mongo_ai/core/debounce/debounce.dart';
import 'package:mongo_ai/core/di/providers.dart';
import 'package:mongo_ai/core/enum/allowed_extension_type.dart';
import 'package:mongo_ai/core/event/app_event.dart';
import 'package:mongo_ai/core/event/app_event_provider.dart';
import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/core/routing/routes.dart';
import 'package:mongo_ai/core/utils/app_dialog.dart';
import 'package:mongo_ai/create/domain/model/pick_file.dart';
import 'package:mongo_ai/create/domain/model/request/input_content.dart';
import 'package:mongo_ai/create/domain/model/request/message_input.dart';
import 'package:mongo_ai/create/domain/model/request/open_ai_body.dart';
import 'package:mongo_ai/create/domain/model/response/open_ai_response.dart';
import 'package:mongo_ai/create/presentation/create/controller/upload_raw_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'upload_raw_view_model.g.dart';

@riverpod
class UploadRawViewModel extends _$UploadRawViewModel {
  @override
  Future<UploadRawState> build() async {
    final textController = TextEditingController();
    final debouncer = Debouncer(delay: const Duration(seconds: 1));

    ref.onDispose(() {
      textController.dispose();
    });

    return UploadRawState(textController: textController, debouncer: debouncer);
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
        _successOCR(result.data);
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
    ref
        .read(appEventProvider.notifier)
        .addEvent(AppEventState.showSnackBar(message: message));
  }

  // 텍스트 지우기
  void clearText() {
    state.whenData((cb) => cb.textController.clear());
  }

  // 파일 데이터 지우기
  void deleteFile() {
    state = state.whenData((cb) => cb.copyWith(pickFile: null));
  }

  // 파일 드래그앤드롭 controller 설정
  void setDropController(DropzoneViewController controller) {
    state = state.whenData((cb) => cb.copyWith(dropController: controller));
  }

  // 여러번 요청 로직을 막기위한 debounce
  // 1초내에 여러번 실행해도 마지막 함수만 실행됨.
  void debounceAction(VoidCallback action) {
    final pState = state.value;
    // 값이 할당되지 않은 경우 에러
    if (pState == null) {
      _readyForSnackBar('에러가 발생하였습니다.');
      return;
    }
    pState.debouncer.run(action);
  }

  // 이미지 파일 드롭
  void dropImageFile(DropzoneFileInterface event) async {
    final pState = state.value;
    // 값이 할당되지 않은 경우 에러
    if (pState == null || pState.dropController == null) {
      _readyForSnackBar('에러가 발생하였습니다.');
      return;
    }
    final ctrl = pState.dropController!;
    // 1) 이름
    final fileName = await ctrl.getFilename(event);
    // 2) 바이트 데이터
    final bytes = await ctrl.getFileData(event); // Uint8List
    // 3) 확장자
    final fileExtension = (await ctrl.getFilename(event)).split('.').last;

    if (!AllowedExtensionType.values
        .map((e) => e.name)
        .where((e) => e != 'pdf')
        .contains(fileExtension)) {
      _readyForSnackBar('지원되지 않는 파일 형식입니다.(지원되는 형식: jpg, png, jpeg)');
      return;
    }

    final dropedFile = PickFile(
      type: AiConstant.inputImage,
      fileName: fileName,
      fileExtension: fileExtension,
      bytes: bytes,
    );

    state = state.whenData((cb) {
      return cb.copyWith(pickFile: dropedFile);
    });
  }

  // PDF 파일 드롭
  void dropPdfFile(DropzoneFileInterface event) async {
    final pState = state.value;
    // 값이 할당되지 않은 경우 에러
    if (pState == null || pState.dropController == null) {
      _readyForSnackBar('에러가 발생하였습니다.');
      return;
    }
    final ctrl = pState.dropController!;
    // 1) 이름
    final fileName = await ctrl.getFilename(event);
    // 2) 바이트 데이터
    final bytes = await ctrl.getFileData(event); // Uint8List
    // 3) 확장자 (path package 사용)
    final fileExtension = (await ctrl.getFilename(event)).split('.').last;

    if (fileExtension != AllowedExtensionType.pdf.name) {
      _readyForSnackBar('지원되지 않는 파일 형식입니다.(지원되는 형식: pdf)');
      return;
    }

    final dropedFile = PickFile(
      type: AiConstant.inputImage,
      fileName: fileName,
      fileExtension: fileExtension,
      bytes: bytes,
    );

    state = state.whenData((cb) {
      return cb.copyWith(pickFile: dropedFile);
    });
  }

  void _successOCR(OpenAiResponse response) {
    ref
        .read(appEventProvider.notifier)
        .addEvent(
          AppEventState.showDialog(
            builder: (ctx) {
              final parts = response.getContent().split(AiConstant.splitEmoji);
              return AppDialog.cleanText(
                content: (idx) => '${idx + 1}번: ${parts[idx]}',
                okTap: () {
                  ctx.pop();
                  ctx.push(Routes.createProblem, extra: response);
                },
                cancelTap: () => ctx.pop(),
                itemCount: parts.length,
              );
            },
          ),
        );
  }
}
