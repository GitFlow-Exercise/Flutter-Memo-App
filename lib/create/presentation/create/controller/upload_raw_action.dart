import 'package:freezed_annotation/freezed_annotation.dart';

part 'upload_raw_action.freezed.dart';

@freezed
sealed class UploadRawAction with _$UploadRawAction {
  const factory UploadRawAction.selectUploadType(String type) =
      SelectUploadType;

  const factory UploadRawAction.pickImage() = PickImage;

  const factory UploadRawAction.pickPdf() = PickPdf;

  const factory UploadRawAction.submitForm() = SubmitForm;

  const factory UploadRawAction.clearText() = ClearText;

  const factory UploadRawAction.deleteFile() = DeleteFile;
}
