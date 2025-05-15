import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_complete_state.freezed.dart';

@freezed
abstract class CreateCompleteState with _$CreateCompleteState {
  const factory CreateCompleteState({
    @Default([]) List<CompleteProblem> problems,
    @Default(false) bool isEditMode,
    required Uint8List bytes,
    @Default('') String fileName,
    @Default('') String title,
    @Default(false) bool isDoubleColumns,
    @Default([]) List<String> problemTypes,
  }) = _CreateCompleteState;
}

@freezed
abstract class CompleteProblem with _$CompleteProblem {
  const factory CompleteProblem({
    required int id,
    required String question,
    required String content,
    required List<String> options,
  }) = _CompleteProblem;
}
