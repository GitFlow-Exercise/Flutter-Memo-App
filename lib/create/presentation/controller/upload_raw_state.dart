import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mongo_ai/core/constants/ai_constant.dart';

part 'upload_raw_state.freezed.dart';

@freezed
abstract class UploadRawState with _$UploadRawState {
  const factory UploadRawState({
    @Default(false) bool isLoading,
    @Default(AiConstant.inputText) selectedUploadType,
    Uint8List? imageBytes,
    String? imageName,
    Uint8List? pdfBytes,
    String? pdfName,
    required TextEditingController textController,
  }) = _UploadRawState;
}

extension UploadRawStateExtension on UploadRawState {
  bool get isSubmitEnabled {
    if (selectedUploadType == AiConstant.inputText) {
      return textController.text.trim().isNotEmpty;
    } else if (selectedUploadType == AiConstant.inputImage) {
      return imageBytes != null;
    } else if (selectedUploadType == AiConstant.inputFile) {
      return pdfBytes != null;
    }
    return false;
  }
}
