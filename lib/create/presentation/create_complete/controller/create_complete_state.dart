import 'dart:typed_data';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mongo_ai/create/domain/model/problem.dart';

part 'create_complete_state.freezed.dart';

@freezed
abstract class CreateCompleteState with _$CreateCompleteState {
  const factory CreateCompleteState({
    @Default([]) List<Problem> problems,
    @Default(false) bool isEditMode,
    required Uint8List bytes,
    @Default('') String fileName,
    @Default('') String title,
    @Default(false) bool isDoubleColumns,
    @Default([]) List<String> problemTypes,
  }) = _CreateCompleteState;
}
