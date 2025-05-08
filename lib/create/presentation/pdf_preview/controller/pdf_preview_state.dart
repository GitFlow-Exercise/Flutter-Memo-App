import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mongo_ai/create/domain/model/pick_file.dart';

part 'pdf_preview_state.freezed.dart';

@freezed
abstract class PdfPreViewState with _$PdfPreViewState {
  const factory PdfPreViewState({
    @Default(AsyncValue.loading()) AsyncValue<PickFile> file,
  }) = _PdfPreViewState;
}
