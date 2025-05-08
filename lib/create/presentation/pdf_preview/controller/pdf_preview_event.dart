import 'package:freezed_annotation/freezed_annotation.dart';

part 'pdf_preview_event.freezed.dart';

@freezed
sealed class PdfPreViewEvent with _$PdfPreViewEvent {
  const factory PdfPreViewEvent.showSnackBar(String message) = ShowSnackBar;
}
