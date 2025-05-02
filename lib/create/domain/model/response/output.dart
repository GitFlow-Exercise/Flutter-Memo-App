import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mongo_ai/create/domain/model/response/content.dart';

part 'output.freezed.dart';
part 'output.g.dart';

@freezed
abstract class Output with _$Output {
  const factory Output({
    required String id,
    required String type,
    required String status,
    required List<Content> content,
    required String role,
  }) = _Output;

  factory Output.fromJson(Map<String, dynamic> json) => _$OutputFromJson(json);
}
