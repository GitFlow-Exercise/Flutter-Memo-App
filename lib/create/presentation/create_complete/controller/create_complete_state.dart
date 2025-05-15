import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_complete_state.freezed.dart';

@freezed
abstract class CreateCompleteState with _$CreateCompleteState {
  const factory CreateCompleteState({
    @Default(AsyncValue.loading()) AsyncValue<Uint8List> bytes,
    @Default('document.pdf') String fileName,
  }) = _CreateCompleteState;
}
