import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mongo_ai/core/constants/ai_constant.dart';
import 'package:mongo_ai/create/domain/model/request/message_input.dart';

part 'open_ai_body.freezed.dart';
part 'open_ai_body.g.dart';

@freezed
abstract class OpenAiBody with _$OpenAiBody {
  const factory OpenAiBody({
    @Default(AiConstant.aiModel) String model,
    required List<MessageInput> input,
    required String instructions,
    required String previousResponseId,
  }) = _OpenAiBody;

  factory OpenAiBody.fromJson(Map<String, dynamic> json) =>
      _$OpenAiBodyFromJson(json);
}
