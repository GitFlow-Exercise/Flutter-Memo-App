import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mongo_ai/dashboard/domain/model/workbook.dart';

part 'no_folder_state.freezed.dart';

@freezed
abstract class NoFolderState with _$NoFolderState {
  const factory NoFolderState({
    required AsyncValue<List<Workbook>> workbookList,
    required bool showGridView,
    int? currentTeamId,
  }) = _NoFolderState;
}
