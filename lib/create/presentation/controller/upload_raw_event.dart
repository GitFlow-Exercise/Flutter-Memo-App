import 'package:freezed_annotation/freezed_annotation.dart';

part 'upload_raw_event.freezed.dart';

@freezed
sealed class UploadRawEvent with _$UploadRawEvent {
  const factory UploadRawEvent.showSnackBar(String message) = ShowSnackBar;
}
