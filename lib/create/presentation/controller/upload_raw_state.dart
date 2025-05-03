import 'package:freezed_annotation/freezed_annotation.dart';

part 'upload_raw_state.freezed.dart';

@freezed
abstract class UploadRawState with _$UploadRawState {
  const factory UploadRawState({
    @Default(false) bool isLoading,
  }) = _UploadRawState;
}
