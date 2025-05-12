import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mongo_ai/core/constants/ai_constant.dart';
import 'package:mongo_ai/create/domain/model/pick_file.dart';
import 'package:mongo_ai/create/domain/model/response/open_ai_response.dart';

part 'upload_raw_state.freezed.dart';

@freezed
abstract class UploadRawState with _$UploadRawState {
  const factory UploadRawState({
    @Default(AiConstant.inputText) String selectedUploadType,
    @Default([
      AiConstant.inputText,
      AiConstant.inputImage,
      AiConstant.inputFile,
    ])
    List<String> uploadTypes,
    @Default(AsyncValue.data(null)) AsyncValue<PickFile?> pickFile,
    @Default(AsyncValue.data(null)) AsyncValue<OpenAiResponse?> result,
    required TextEditingController textController,
  }) = _UploadRawState;
}

extension UploadRawStateExtension on UploadRawState {
  bool get isSubmitEnabled {
    if (selectedUploadType == AiConstant.inputText) {
      return textController.text.trim().isNotEmpty;
    } else if (selectedUploadType == AiConstant.inputImage) {
      return pickFile.when(
        data: (file) => file != null,
        loading: () => false,
        error: (_, __) => false,
      );
    } else if (selectedUploadType == AiConstant.inputFile) {
      return pickFile.when(
        data: (file) => file != null,
        loading: () => false,
        error: (_, __) => false,
      );
    }
    return false;
  }
}
