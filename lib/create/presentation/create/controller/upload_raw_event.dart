import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mongo_ai/create/domain/model/response/open_ai_response.dart';

part 'upload_raw_event.freezed.dart';

@freezed
sealed class UploadRawEvent with _$UploadRawEvent {
  const factory UploadRawEvent.showSnackBar(String message) = ShowSnackBar;

  const factory UploadRawEvent.successOCR(OpenAiResponse response) = SuccessOCR;
}
