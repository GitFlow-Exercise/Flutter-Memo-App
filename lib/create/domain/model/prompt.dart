import 'package:freezed_annotation/freezed_annotation.dart';

part 'prompt.freezed.dart';

@freezed
abstract class Prompt with _$Prompt {
  const factory Prompt({
    required int id,
    required String name,
    required String detail,
  }) = _Prompt;
}
