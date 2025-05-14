import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mongo_ai/core/constants/ai_constant.dart';
import 'package:mongo_ai/create/domain/model/pick_file.dart';
import 'package:mongo_ai/create/domain/model/response/open_ai_response.dart';

part 'upload_raw_state.freezed.dart';

// 기존에 이미지, 파일별로 AsyncValue 할당해서 사용하던 형식에서
// 타입을 AsyncValue가 아닌 실제 타입으로 설정한 후
// 해당 viewmodel에서 UploadRawState 자체를 AsyncValue로
// 사용하는 형식으로 변경하였습니다.
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
    @Default(null) DropzoneViewController? dropController,
    @Default(null) PickFile? pickFile,
    @Default(null) OpenAiResponse? result,
    required TextEditingController textController,
  }) = _UploadRawState;
}

extension UploadRawStateExtension on UploadRawState {
  bool get isSubmitEnabled {
    if (selectedUploadType == AiConstant.inputText) {
      return textController.text.trim().isNotEmpty;
    } else if (selectedUploadType == AiConstant.inputImage) {
      return pickFile != null;
    } else if (selectedUploadType == AiConstant.inputFile) {
      return pickFile != null;
    }
    return false;
  }
}
