import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mongo_ai/create/domain/model/problem.dart';

part 'create_complete_params.freezed.dart';

@freezed
abstract class CreateCompleteParams with _$CreateCompleteParams {
  const factory CreateCompleteParams({
    @Default(false) bool isDoubleColumns,
    @Default([]) List<Problem> problems,
  }) = _CreateCompleteParams;
}
