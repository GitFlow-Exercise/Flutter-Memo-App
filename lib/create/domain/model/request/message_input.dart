import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mongo_ai/core/constants/ai_constant.dart';
import 'package:mongo_ai/create/domain/model/request/input_content.dart';

part 'message_input.freezed.dart';

@freezed
abstract class MessageInput with _$MessageInput {
  factory MessageInput({
    @Default(AiConstant.role) String role,
    required List<InputContent> content,
  }) = _MessageInput;
}
