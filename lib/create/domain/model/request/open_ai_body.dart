import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mongo_ai/core/constants/ai_constant.dart';
import 'package:mongo_ai/create/domain/model/request/message_input.dart';

part 'open_ai_body.freezed.dart';

@freezed
abstract class OpenAiBody with _$OpenAiBody {
  factory OpenAiBody({
    @Default(AiConstant.aiModel) String model,
    required List<MessageInput> input,
    required String instructions,
    String? previousResponseId,
    @Default(0.2) double temperature,
  }) = _OpenAiBody;
}
