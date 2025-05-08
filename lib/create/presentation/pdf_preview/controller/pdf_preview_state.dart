import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pdf_preview_state.freezed.dart';

@freezed
abstract class PdfPreViewState with _$PdfPreViewState {
  const factory PdfPreViewState({
    @Default(AsyncValue.loading()) AsyncValue<Uint8List> bytes,
    @Default('document.pdf') String fileName,
  }) = _PdfPreViewState;
}
