import 'package:freezed_annotation/freezed_annotation.dart';

part 'upload_raw_action.freezed.dart';

@freezed
sealed class UploadRawAction with _$UploadRawAction {
  const factory UploadRawAction.onTap() = OnTap;
}
